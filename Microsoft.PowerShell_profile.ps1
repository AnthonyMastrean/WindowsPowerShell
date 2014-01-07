$here = Split-Path $PROFILE

Get-ChildItem $here\Modules -include *.psm1 -recurse | Import-Module
Get-ChildItem $here\Functions -include *.ps1 -recurse | %{ . $_.FullName }

$host.UI.RawUi.WindowTitle = ('{5}{0}@{1}({4}) [PS {6}] [.NET {2}.{3}]' -f `
  $ENV:USERNAME, `
  $ENV:COMPUTERNAME, `
  $PSVersionTable.CLRVersion.Major, `
  $PSVersionTable.CLRVersion.Minor, `
  $(if([IntPtr]::Size -eq 8){'x64'}else{'x86'}),
  $(if($host.UI.RawUI.WindowTitle.StartsWith('Administrator: ')){'Administrator: '}),
  $PSVersionTable.PSVersion
)

$global:GitPromptSettings.EnableWindowTitle = $false

function prompt {
  Set-VisitedDirectory
  
  Write-Host (Split-Path $pwd -Leaf) -NoNewLine
  
  $temp = $LASTEXITCODE
  Write-VcsStatus  
  $global:LASTEXITCODE = $temp

  "> "
}

Set-Alias new New-Object

Enable-GitColors
