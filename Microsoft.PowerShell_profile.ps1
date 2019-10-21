$here = Split-Path $PROFILE
$cmdlets = Join-Path $here 'Cmdlets'

if (Test-Path -Path $cmdlets) { Get-ChildItem $cmdlets | %{ . $_.FullName } }

# prompt
Set-Theme Paradox

# chocolatey
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path -Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}

# psreadline
Set-PSReadlineOption -ExtraPromptLineCount 2
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# built-in aliases
Set-Alias -Name less -Value more
Set-Alias -Name mklink -Value New-Item
Set-Alias -Name new -Value New-Object
Set-Alias -Name unzip -Value Expand-Archive
Set-Alias -Name uuidgen -Value New-Guid
Set-Alias -Name which -Value Get-Command

# custom aliases
Set-Alias -Name cal -Value Write-Calendar
Set-Alias -Name del -Value Remove-ItemNative -Option AllScope -Force
Set-Alias -Name first -Value Select-FirstObject
Set-Alias -Name http -Value Get-HttpStatusCodeInfo
Set-Alias -Name last -Value Select-LastObject
Set-Alias -Name mnemonic -Value Get-MnemonicName
Set-Alias -Name play -Value Send-Sound
Set-Alias -Name say -Value Speak-Text
Set-Alias -Name size -Value Write-ItemSize
Set-Alias -Name top -Value Select-TopObject
Set-Alias -Name touch -Value Set-FileTime
Set-Alias -Name watch -Value Invoke-Watch
