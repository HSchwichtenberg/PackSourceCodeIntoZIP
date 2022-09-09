# Pack Source Code into ZIP using a PowerShell Script registered as Windows Explorer command for directories

Packs your Source Code into a ZIP <b>without</b> binaries and other artifacts!

1. Run this script as admin to register this script in the Registry as Windows Explorer command for directories

<img src="/Readme_Images/Readme_InstallationAdmin.png" width="600">

2. Now run the script from the Windows Explorer on any directory containing code :-)

<img src="/Readme_Images/Readme_Run.png" width="600">
<img src="/Readme_Images/Readme_Result1.png" width="600">
<img src="/Readme_Images/Readme_Result2.png" width="600">

Alternative: Run Script from PowerShell console with the code directory as parameter:

<code>
.\PackSourceCodeIntoZip.ps1 "T:\temp\HelloWorld1.0"
</code>

<img src="/Readme_Images/Readme_RunPowerShellConsole.png" width="600">

# Note

The script is not signed! If you see an error "is not digitally signed. You
cannot run this script on the current system." either
- <a href="https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_signing">sign the script</a>,
- <a href="https://superuser.com/questions/106360/how-to-enable-execution-of-powershell-scripts">change your execution policy</a> or 
- bypass the execution policy</a>:

<code>
powershell.exe -noprofile -executionpolicy bypass -file .\PackSourceCodeIntoZip.ps1
</code>

<img src="/Readme_Images/Readme_InstallationBypass.png" width="600">

<code>
powershell.exe -noprofile -executionpolicy bypass -file .\PackSourceCodeIntoZip.ps1 "T:\temp\HelloWorld1.0"
</code>

# Configuration

- You can configure the directories and files to exclude within the script ($excludeDirs, $excludeFiles)
- You can configure an optional Readme file to add to all created ZIP archives ($readmeFile)

# Source of the used icon

<a href="https://www.flaticon.com/de/kostenlose-icons/ausflug" title="ausflug Icons">Flaticon</a>
