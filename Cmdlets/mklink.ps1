function New-SymbolicLink {
  param(
    [switch] $Directory
  )

  if($Directory) {
    cmd /D /C mklink /D $args
  }

  cmd /D /C mklink $args
}
