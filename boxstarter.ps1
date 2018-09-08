function Set-WindowsExplorerLaunchInSeparateProcess {
    # Launch folder windows in a separate process
    #     https://github.com/mwrock/boxstarter/issues/299

    Set-ItemProperty `
        -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
        -Name SeparateProcess `
        -Value 1
}

function Set-WindowsExplorerClickState {
    # Single-click to open an item
    #   https://github.com/mwrock/boxstarter/issues/300

    $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    $shell_state = (Get-ItemProperty -Path $path).ShellState
    $shell_state[4] = $shell_state[4] -bxor 32
    Set-ItemProperty -Path $path -Name ShellState -Value $shell_state
}

Disable-UAC

Set-TimeZone -Name 'Eastern Standard Time'

Set-WindowsExplorerLaunchInSeparateProcess
Set-WindowsExplorerClickState

Set-TaskbarOptions `
    -Dock Left `
    -Size Large
  
Disable-BingSearch

Get-WindowsOptionalFeature -Online -FeatureName *Internet* | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *Media* | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *NetFx* | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *Print* | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *SMB* | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *WorkFolders* | Disable-WindowsOptionalFeature -Online -NoRestart

choco install -y `
    7zip `
    docker-for-windows `
    git `
    googlechrome `
    notepad2-mod `
    vscode

Install-Module -Force -Name posh-git
    
Enable-PSRemoting -Force
Enable-RemoteDesktop

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -AcceptEula -SuppressReboots
