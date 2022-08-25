# Pack Source Code Into ZIP using a PowerShell Script registered as Windows Explorer command for directories

Packs your Source Code into a ZIP <b>without</b> binaries and other artifacts!

1. Run this script as admin to register this script in the Registry as Windows Explorer command for directories
2. Now run the script from the Windows Explorer on any directory containing code :-)

<img src="/Readme_Images/Readme_Run.png" width="400">
<img src="/Readme_Images/Readme_Result.png" width="400">

# Configuration

- You can configure the directories and files to exclude within the script ($excludeDirs, $excludeFile)
- You can configure an optional Readme file to add to all ZIP ($readmeToAdd)
