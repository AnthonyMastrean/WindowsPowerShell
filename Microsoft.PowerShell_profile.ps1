$here = Split-Path $PROFILE

Get-ChildItem $here\Modules\**\*.psm1 | Import-Module
Get-ChildItem $here\Functions\*.ps1 | %{ . $_.FullName }

function Get-HttpStatusCode($code) {
  (Invoke-WebRequest "http://httpcode.info/$code" -UserAgent "curl").Content
}

function Test-IsWebsiteUp($url) {
  (Invoke-WebRequest "http://isup.me/$url").Content.Contains("is up")
}

function prompt {
  Write-Host "
$ENV:USERNAME@$ENV:COMPUTERNAME " -ForegroundColor "DarkGreen" -NoNewLine
  Write-Host ($PWD -replace [regex]::Escape((Resolve-Path ~)), "~") -ForegroundColor "DarkYellow" -NoNewLine
  Write-VcsStatus
  return "
> "
}

Set-Alias new New-Object
Set-Alias which Get-Command
Set-Alias bits Test-Is64Bit
Set-Alias play Send-Sound
Set-Alias first Select-FirstObject
Set-Alias last Select-LastObject
Set-Alias top Select-TopObject
Set-Alias size Write-ItemSize
Set-Alias cal Write-Calendar
Set-Alias http Get-HttpStatusCode
Set-Alias isup Test-IsWebsiteUp
