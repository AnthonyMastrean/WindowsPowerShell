$here = Split-Path $PROFILE

Get-ChildItem $here\Modules -include *.psm1 -recurse | Import-Module
Get-ChildItem $here\Functions -include *.ps1 -recurse | %{ . $_.FullName }

Set-VsVars

function prompt {
  Set-VisitedDirectory
  Print-GitStatus
  '> '
}

Set-Alias new New-Object

Enable-GitColors
