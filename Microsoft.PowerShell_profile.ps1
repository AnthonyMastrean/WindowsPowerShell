$here = Split-Path $PROFILE

Import-Module PowerTab -ArgumentList "$ENV:APPDATA\powertab\powertabconfig.xml"
Import-Module Pscx
Import-Module posh-git
Import-Module Pester
Import-Module trace-location

Get-ChildItem $here\Functions -include *.ps1 -recurse | %{ . $_.FullName }

function prompt {
  Set-VisitedDirectory
  Set-SessionTitle  
  Print-GitStatus
}

Set-Alias new New-Object

Enable-GitColors
