$here = Split-Path $PROFILE

Get-Module -ListAvailable | ?{ $_.Path.Contains(($ENV:PSMODULEPATH -split ";")[0]) } | Import-Module
Get-ChildItem $here\Cmdlets\*.ps1 | %{ . $_.FullName }

$global:GitPromptSettings.EnableWindowTitle = $false

function Get-HttpStatusCode($code) {
  (Invoke-WebRequest "http://httpcode.info/$code" -UserAgent "curl").Content
}

function Test-IsWebsiteUp($url) {
  (Invoke-WebRequest "http://isup.me/$url").Content.Contains("is up")
}

Set-PSReadlineOption -ExtraPromptLineCount 2

function prompt {
  Write-Host "`n$ENV:USERNAME@$ENV:COMPUTERNAME " -ForegroundColor "DarkGreen" -NoNewLine
  Write-Host ($PWD -replace [regex]::Escape((Resolve-Path ~)), "~") -ForegroundColor "DarkYellow" -NoNewLine
  Write-VcsStatus
  "`nPS> "
}

Set-Alias new New-Object
Set-Alias which Get-Command
Set-Alias play Send-Sound
Set-Alias first Select-FirstObject
Set-Alias last Select-LastObject
Set-Alias top Select-TopObject
Set-Alias size Write-ItemSize
Set-Alias cal Write-Calendar
Set-Alias http Get-HttpStatusCode
Set-Alias isup Test-IsWebsiteUp
