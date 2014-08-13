function Set-FileTime {

  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Path
  )

  (Get-ChildItem $Path).LastWriteTime = [datetime]::Now

}
