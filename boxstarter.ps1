function Remove-WindowsApp {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $Name
    )
    
    Write-Output "Boxstarter: Removing Windows app '$Name'" -Verbose
    
    # https://github.com/Microsoft/windows-dev-box-setup-scripts/blob/master/scripts/RemoveDefaultApps.ps1
    Get-AppxPackage -Name $Name -AllUsers | Remove-AppxPackage
    Get-AppXProvisionedPackage -Online | ?{ $_.DisplayName -like $Name } | Remove-AppxProvisionedPackage -Online
}

function Remove-WindowsOptionalFeature {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $Name
    )
    
    Write-Output "Boxstarter: Removing Windows optional feature '$Name'" -Verbose
    
    Get-WindowsOptionalFeature -Online -FeatureName $Name `
    | ?{ $_.State -eq 'Enabled' } `
    | Disable-WindowsOptionalFeature -Online -NoRestart
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

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Disable-UAC

Set-TimeZone -Name 'Eastern Standard Time'

Set-WindowsExplorerLaunchInSeparateProcess
Set-WindowsExplorerClickState

Set-TaskbarOptions -Dock Left -Size Large

Disable-BingSearch

@(
    "Internet-Explorer-*"
    "MediaPlayback"
    "WindowsMediaPlayer"
    "*Printing*"
    "*SMB*"
    "*WorkFolders-Client"
) | Remove-WindowsOptionalFeature

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

@(
    "*.AdobePhotoshopExpress"
    "*.Duolingo-LearnLanguagesforFree"
    "*.EclipseManager"
    "*Autodesk*"
    "*BubbleWitch*"
    "*Dell*"
    "*Facebook*"
    "*HiddenCity*"
    "*Keeper*"
    "*MarchofEmpires*"
    "*Minecraft*"
    "*Netflix*"
    "*Plex*"
    "*Solitaire*"
    "*Twitter*"
    "ActiproSoftwareLLC.562882FEEB491" # Code Writer
    "king.com.CandyCrush*"
    "Microsoft.3DBuilder"
    "Microsoft.BingFinance"
    "Microsoft.BingFinance"
    "Microsoft.BingNews"
    "Microsoft.BingSports"
    "Microsoft.BingWeather"
    "Microsoft.CommsPhone"
    "Microsoft.FreshPaint"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.Print3D"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsPhone"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.XboxApp"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
) | Remove-WindowsApp

if ($onedrive = Get-UninstallRegistryKey -SoftwareName 'Microsoft OneDrive') {
    Uninstall-ChocolateyPackage `
      -PackageName 'onedrive' `
      -FileType 'EXE' `
      -Silent '/VERYSILENT /UNINSTALL' `
      -File (-split $onedrive.UninstallString)[0]
}

choco install -y `
    1password `
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
