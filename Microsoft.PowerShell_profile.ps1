$here = Split-Path $PROFILE

Get-ChildItem $here\Modules -include *.psm1 -recurse | Import-Module
Get-ChildItem $here\Functions -include *.ps1 -recurse | %{ . $_.FullName }

$global:GitPromptSettings.EnableWindowTitle = $false

function prompt {
  Set-VisitedDirectory
  Write-Host (Split-Path $pwd -Leaf) -NoNewLine
  Print-GitStatus
  '> '
}

Set-Alias new New-Object

Enable-GitColors
