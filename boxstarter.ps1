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

Set-WindowsExplorerLaunchInSeparateProcess
Set-WindowsExplorerClickState
Restart-Explorer

Set-TaskbarOptions `
    -Dock Left `
    -Size Large
  
Disable-BingSearch

# chocolatey packages
choco install -y `
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
