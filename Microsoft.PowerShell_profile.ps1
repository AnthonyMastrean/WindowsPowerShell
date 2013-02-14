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

function Select-First { 
  $input | Select-Object -First 1
}

function Select-Last {
  $input | Select-Object -Last 1
}

Set-Alias first Select-First
Set-Alias last Select-Last

Enable-GitColors
