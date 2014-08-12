function Expand-Archive {

  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Path, 
    
    [ValidateNotNullOrEmpty()]
    [string] $Destination = $(Split-Path (Resolve-Path $Path)),

    [switch] $Force
  )

  $Path = (Resolve-Path $Path).Path
  $Destination = (Resolve-Path $Destination).Path

  $shell = New-Object -ComObject "Shell.Application"
  $zip = $shell.NameSpace($Path)
  $target = $shell.NameSpace($Destination)

  if($Force) {
    $target.CopyHere($zip.Items(), 16)
  } else {
    $target.CopyHere($zip.Items())
  }
}
