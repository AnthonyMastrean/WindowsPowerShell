$here = Split-Path $PROFILE
$cmdlets = Join-Path $here "Cmdlets"
$modules = Join-Path $here "Modules"

Get-ChildItem $modules | Import-Module
Get-ChildItem $cmdlets | %{ . $_.FullName }

$global:GitPromptSettings.EnableWindowTitle = $false

Set-PSReadlineOption -ExtraPromptLineCount 2

function prompt {
  $Host.UI.RawUI.ForegroundColor = $global:GitPromptSettings.DefaultForegroundColor

  Write-Host "`n$ENV:USERNAME@$ENV:COMPUTERNAME " -ForegroundColor "DarkGreen" -NoNewLine
  Write-Host ($PWD -replace [regex]::Escape($ENV:USERPROFILE), "~") -ForegroundColor "DarkYellow" -NoNewLine
  Write-VcsStatus
  return "`nPS> "
}

Set-Alias new New-Object
Set-Alias which Get-Command
Set-Alias play Send-Sound
Set-Alias first Select-FirstObject
Set-Alias last Select-LastObject
Set-Alias top Select-TopObject
Set-Alias size Write-ItemSize
Set-Alias cal Write-Calendar
Set-Alias httpcode Get-HttpStatusCode
Set-Alias isup Test-IsWebsiteUp
Set-Alias fastdelete Remove-ItemNative
Set-Alias unzip Expand-Archive
Set-Alias touch Set-FileTime
Set-Alias mklink New-SymbolicLink
Set-Alias less more
Set-Alias mnemonic Get-MnemonicName
Set-Alias sunrise Get-Sunrise
Set-Alias say Speak-Text
Set-Alias uuidgen New-Guid
