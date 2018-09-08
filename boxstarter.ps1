Disable-UAC

Set-WindowsExplorerOptions `
    -DisableShowHiddenFilesFoldersDrives `
    -DisableShowProtectedOSFiles `
    -DisableShowFileExtensions `
    -DisableShowFullPathInTitleBar `
    -DisableShowFrequentFoldersInQuickAccess `
    -DisableShowRecentFilesInQuickAccess `
    -DisableExpandToOpenFolder `
    -DisableOpenFileExplorerToQuickAccess

# Launch folder windows in a separate process
#     https://github.com/mwrock/boxstarter/issues/299
Set-ItemProperty `
  -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
  -Name SeparateProcess `
  -Value 1
  
# Single-click to open an item
#   https://github.com/mwrock/boxstarter/issues/300
# _TBD_

Set-TaskbarOptions `
    -AlwaysShowIconsOn `
    -Combine Always `
    -Dock Left `
    -Lock `
    -Size Large
  
Disable-BingSearch

# chocolatey packages
choco install -y
    7zip `
    docker-for-windows `
    git `
    googlechrome `
    notepad2-mod `
    vscode

# powershell modules
Install-Module -Force -Name `
    posh-git `
    psreadline `
    
# remoting
Enable-PSRemoting -Force
Enable-RemoteDesktop

# finalize!
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -AcceptEula -SuppressReboots
