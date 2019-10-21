function Remove-ItemNative {
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Path
  )

  cmd /C "del /f/s/q $Path > nul"
  cmd /C "rmdir /s/q $Path"
}
