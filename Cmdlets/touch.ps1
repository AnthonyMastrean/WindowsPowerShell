function Set-FileTime {

  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Path
  )

  if(Test-Path $Path) {
    (Get-ChildItem $Path).LastWriteTime = [datetime]::Now
    return
  }

  New-Item $Path -Type "File" -Force
  
}
