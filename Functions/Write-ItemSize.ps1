function Write-ItemSize {
  param(
    [Parameter(Mandatory = $true)]
    [string]$path
  )
  
  $item = Get-Item $path
  $size = $item.Length
  
  $b  = "{0:N3}" -f $size
  $kb = "{0:N3}" -f ($size / 1KB)
  $mb = "{0:N3}" -f ($size / 1MB)
  $gb = "{0:N3}" -f ($size / 1GB)
  
  Write-Host ""
  Write-Host ("  {0}" -f $item.Name)
  Write-Host ""
  Write-Host (" {0,$($kb.Length + ($kb.Length - $kb.Length))} KB" -f $kb)
  Write-Host (" {0,$($mb.Length + ($kb.Length - $mb.Length))} MB" -f $mb)
  Write-Host (" {0,$($gb.Length + ($kb.Length - $gb.Length))} GB" -f $gb)
  Write-Host ""
}

Set-Alias size Write-ItemSize
