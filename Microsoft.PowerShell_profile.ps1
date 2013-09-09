$here = Split-Path $PROFILE

Get-ChildItem $here\Modules -include *.psm1 -recurse | Import-Module
Get-ChildItem $here\Functions -include *.ps1 -recurse | %{ . $_.FullName }

Set-VsVars -version 11.0

$global:GitPromptSettings.EnableWindowTitle = $false

function prompt {
  Set-VisitedDirectory
  Print-GitStatus
  '> '
}

Set-Alias new New-Object

Enable-GitColors
