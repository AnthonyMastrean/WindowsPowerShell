Disable-UAC

Update-ExecutionPolicy -Policy Unrestricted

Set-WindowsExplorerOptions `
  -DisableShowHiddenFilesFoldersDrives `
  -DisableShowProtectedOSFiles `
  -DisableShowFileExtensions `
  -DisableShowFullPathInTitleBar `
  -DisableShowFrequentFoldersInQuickAccess `
  -DisableShowRecentFilesInQuickAccess `
  -DisableExpandToOpenFolder `
  -DisableOpenFileExplorerToQuickAccess

# https://github.com/mwrock/boxstarter/issues/299
Set-ItemProperty `
  -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
  -Name SeparateProcess `
  -Value 1
  
# https://github.com/mwrock/boxstarter/issues/300

Set-TaskbarOptions `
  -Size Large `
  -Unlock `
  -Dock Left `
  -Combine Always `
  -AlwaysShowIconsOn

Enable-PSRemoting -Force
Enable-MicrosoftUpdate
Enable-RemoteDesktop
Enable-UAC

Disable-BingSearch

Install-BoxstarterPackage `
    -DisableReboots `
    -DisableRestart `
    -Force `
    -PackageName `
        7zip, `
        docker, `
        git, `
        googlechrome, `
        linqpad, `
        notepad2-mod, `
        openssh, `
        rsync, `
        vscode

Install-Module `
    -Force `
    -Name `
        posh-git

Install-WindowsUpdate `
    -AcceptEula `
    -SuppressReboots
