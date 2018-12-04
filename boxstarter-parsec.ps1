function Remove-WindowsOptionalFeature {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $Name
    )
    
    $Input | %{ 
        Write-Output "Boxstarter: Removing Windows optional feature '$_'" -Verbose
    
        Get-WindowsOptionalFeature -Online -FeatureName $_ `
        | ?{ $_.State -eq 'Enabled' } `
        | Disable-WindowsOptionalFeature -Online -NoRestart
    }
}

function Set-WindowsExplorerLaunchInSeparateProcess {
    # Launch folder windows in a separate process
    #     https://github.com/mwrock/boxstarter/issues/299

    Write-Output "Boxstarter: Launch Windows Explorer in separate process" -Verbose

    Set-ItemProperty `
        -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced `
        -Name SeparateProcess `
        -Value 1
}

function Set-WindowsExplorerClickState {
    # Single-click to open an item
    #   https://github.com/mwrock/boxstarter/issues/300

    Write-Output "Boxstarter: Set Windows Explorer to single-click" -Verbose

    $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'
    $shell_state = (Get-ItemProperty -Path $path).ShellState
    $shell_state[4] = $shell_state[4] -bxor 32
    Set-ItemProperty -Path $path -Name ShellState -Value $shell_state
}

Set-TimeZone -Name 'Eastern Standard Time'

Set-WindowsExplorerLaunchInSeparateProcess
Set-WindowsExplorerClickState

Set-TaskbarOptions -Dock Left -Size Large

Disable-BingSearch

@(
    "MediaPlayback"
    "WindowsMediaPlayer"
    "*Printing*"
    "*SMB*"
    "*WorkFolders-Client"
) | Remove-WindowsOptionalFeature

choco install -y `
    1password `   
    consoleclassix `
    steam
    
choco install -y --pre `
    rpcs3 `
    supermarioflashback

Enable-PSRemoting -Force
Enable-RemoteDesktop

Enable-MicrosoftUpdate
Install-WindowsUpdate -AcceptEula -SuppressReboots
