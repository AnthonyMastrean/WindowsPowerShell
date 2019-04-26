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

if (Test-Path -Path $modules) { Get-ChildItem $modules | Import-Module }
if (Test-Path -Path $cmdlets) { Get-ChildItem $cmdlets | %{ . $_.FullName } }

# posh-git
Import-Module posh-git
Start-SshAgent -Quiet
$GitPromptSettings.EnableWindowTitle = $true

# chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Set-PSReadlineOption -ExtraPromptLineCount 2
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

Set-Alias cal Write-Calendar
Set-Alias fastdelete Remove-ItemNative
Set-Alias first Select-FirstObject
Set-Alias httpcode Get-HttpStatusCode
Set-Alias isup Test-IsWebsiteUp
Set-Alias last Select-LastObject
Set-Alias less more
Set-Alias mklink New-SymbolicLink
Set-Alias mnemonic Get-MnemonicName
Set-Alias new New-Object
Set-Alias play Send-Sound
Set-Alias say Speak-Text
Set-Alias size Write-ItemSize
Set-Alias sunrise Get-Sunrise
Set-Alias top Select-TopObject
Set-Alias touch Set-FileTime
Set-Alias unzip Expand-Archive
Set-Alias uuidgen New-Guid
Set-Alias watch Invoke-Watch
Set-Alias which Get-Command
