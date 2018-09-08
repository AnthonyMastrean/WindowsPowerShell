function Remove-WindowsApp {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $Name
    )
    
    # https://github.com/Microsoft/windows-dev-box-setup-scripts/blob/master/scripts/RemoveDefaultApps.ps1
    Get-AppxPackage -Name $Name -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online | ?{ $_.DisplayName -like $Name } | Remove-AppxProvisionedPackage -Online
}

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

Set-TaskbarOptions -Dock Left -Size Large
  
Disable-BingSearch

Get-WindowsOptionalFeature -Online -FeatureName *Internet* | ?{ $_.State -eq 'Enabled' } | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *Media* | ?{ $_.State -eq 'Enabled' } | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *Print* | ?{ $_.State -eq 'Enabled' } | Disable-WindowsOptionalFeature -Online -NoRestart
Get-WindowsOptionalFeature -Online -FeatureName *SMB* | ?{ $_.State -eq 'Enabled' } | Disable-WindowsOptionalFeature -Online -NoRestar
Get-WindowsOptionalFeature -Online -FeatureName *WorkFolders* | ?{ $_.State -eq 'Enabled' } | Disable-WindowsOptionalFeature -Online -NoRestart

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

@(
    "Microsoft.BingFinance"
    "Microsoft.3DBuilder"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.CommsPhone"
    "Microsoft.Getstarted"
    "Microsoft.WindowsMaps"
    "*MarchofEmpires*"
    "Microsoft.GetHelp"
    "Microsoft.Messaging"
    "*Minecraft*"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.OneConnect"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "*Solitaire*"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Office.Sway"
    "Microsoft.XboxApp"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.FreshPaint"
    "Microsoft.Print3D"
    "*Autodesk*"
    "*BubbleWitch*"
    "king.com.CandyCrush*"
    "*Dell*"
    "*Facebook*"
    "*Keeper*"
    "*Netflix*"
    "*Twitter*"
    "*Plex*"
    "*.Duolingo-LearnLanguagesforFree"
    "*.EclipseManager"
    "ActiproSoftwareLLC.562882FEEB491" # Code Writer
    "*.AdobePhotoshopExpress"
) | Remove-WindowsApp

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
