function Remove-ItemNative {
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $path
  )

  cmd /C "del /f/s/q $path > nul"
  cmd /C "rmdir /s/q $path"
}
