cls
$ErrorActionPreference = "Stop"; #  Make all errors terminating

$functionname = "Pack Source Code into ZIP"
Write-Host $functionname -ForegroundColor Cyan
Write-host "Pack Source Code into ZIP without binaries and other artifacts"  -ForegroundColor Cyan
Write-Host "Version: 2.0 / 08-25-2022" -ForegroundColor Cyan
Write-Host "Author: Dr. Holger Schwichtenberg, wwww.IT-Visions.de, 2019-2022" -ForegroundColor Cyan
Write-Host "Script: $PSScriptRoot\$($MyInvocation.MyCommand.Name)" -ForegroundColor Cyan

$robocopy = Get-Command "robocopy.exe" -ErrorAction SilentlyContinue
if ($robocopy -eq $null) 
{ 
 Write-Error "Script requires Robocopy.exe --> https://docs.microsoft.com/de-de/windows-server/administration/windows-commands/robocopy"
}

if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
Write-Host "Run script as admin to registry als Explorer command for directories!" -ForegroundColor white -BackgroundColor Cyan
}
#######################################################################################################################

# Parameters (can be changed)
$excludeDirs =  "Application Files", ".vs", "node_modules", "AppPackages", "TestResults", "Packages", "obj", "debug", "release", ".git", "bin" 
$excludeFile =  "*.vssscc", ".gitattributes", ".gitignore", "UpgradeLog.htm", "*.rar", "*.zip"
$readmeToAdd =  [System.IO.Path]::Combine($PSScriptRoot, "Readme!!! Copyright Haftungsausschluss Support.pdf")

#######################################################################################################################

### Register Windows Explorer Command for Directories
if ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
Write-Host "Registering this script in Registry as Windows Explorer command for directories..." -ForegroundColor Yellow
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

$registryPath1 = "HKCR:\Directory\shell\$functionname\"
mkdir $registryPath1 -Force
New-ItemProperty -Path $registryPath1 -Name "Icon" -Value "$PSScriptRoot\koffer.ico" -PropertyType String -Force | Out-Null

$registryPath2 = "HKCR:\Directory\shell\$functionname\Command"
mkdir $registryPath2 -Force

$Name = "(Default)"
$value = 'powershell.exe -File "'  + $PSScriptRoot +"\" + $MyInvocation.MyCommand.Name + '" "%1"'
"registryPath2:" + $registryPath2
New-ItemProperty -Path $registryPath2 -Name $name -Value $value -PropertyType String -Force | Out-Null

 Write-Host "DONE! Now run the script from the Windows Explorer on any directory containing code :-)" -ForegroundColor green

return
}

#######################################################################################################################

try
{
 $path = $args[0] # Get first parameter
 if ($path -eq $null) { $path = get-location }
 Write-Host "Parameter: $path" 

 $name = [System.IO.Path]::GetFileNameWithoutExtension($path)
 $pathParent = [System.IO.Path]::GetDirectoryName($path)
 $tempfolder = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(),$name)
 $targetzip = [System.IO.Path]::Combine($pathParent,"$name.zip")
 Write-Host "Pack $name in $pathParent via $tempfolder into $targetzip..." -ForegroundColor Yellow

 if ([System.IO.Directory]::Exists($tempfolder))
 {
  Write-Host "Removing $tempfolder..." -ForegroundColor Yellow
  remove-item "$tempfolder" -force -ea silentlycontinue -recurse
 }

 if ([System.IO.File]::Exists($targetzip))
 {
  Write-Host "Removing $targetzip..." -ForegroundColor Yellow
  remove-item "$targetzip" -force -ea silentlycontinue
 }

 Write-Host "Copying from $path to $tempfolder ..." -ForegroundColor Yellow
 $command = "robocopy $path $tempfolder /MIR /NP /purge /XA:SH /R:0 /TEE /XD " + ($excludeDirs -join " /XD ") + " /XF " + ($excludeFile -join " /XF ")
 $command
 Invoke-expression $command 

 if (-not [System.String]::IsNullOrEmpty(($readmeToAdd)) -and [System.IO.File]::Exists($readmeToAdd))
 {
  Write-Host "Copying File $readmeToAdd to $tempfolder..." -ForegroundColor Yellow
  copy-item $readmeToAdd $tempfolder\
 }

 Write-Host "Compressing $tempfolder into $targetzip..." -ForegroundColor Yellow
 Compress-Archive -path $tempfolder $targetzip

 Write-Host "Cleaning up $tempfolder..." -ForegroundColor Yellow
 remove-item "$tempfolder" -force -ea silentlycontinue -recurse
 Write-Host "DONE!" -ForegroundColor green
}
catch{
    Write-Error "$($_.Exception.Message)"
    Read-Host "Press ENTER to exit"
}