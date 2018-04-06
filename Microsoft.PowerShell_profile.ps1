$here = Split-Path $PROFILE
$cmdlets = Join-Path $here 'Cmdlets'
$modules = Join-Path $here 'Modules'

function prompt {
  Write-Host ''
  Write-Host "$ENV:USERNAME@$ENV:COMPUTERNAME " -ForegroundColor 'DarkGreen' -NoNewLine
  Write-Host ($ExecutionContext.SessionState.Path.CurrentLocation -replace [regex]::Escape($ENV:USERPROFILE), '~') -ForegroundColor 'DarkYellow' -NoNewLine
  Write-VcsStatus
  Write-Host ''
  "$('PS>' * ($nestedPromptLevel + 1)) "
}

Get-ChildItem $modules | Import-Module
Get-ChildItem $cmdlets | %{ . $_.FullName }

Import-Module "$ENV:ChocolateyInstall\helpers\chocolateyProfile.psm1"
Import-Module posh-docker

$GitPromptSettings.EnableWindowTitle = $false

Set-PSReadlineOption -ExtraPromptLineCount 2

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
Set-Alias time Invoke-Stopwatch
Set-Alias watch Invoke-Watch
