function Write-ItemSize {
  <#
    .SYNOPSIS
    Pretty-print the size-on-disk of an item

    .DESCRIPTION
    Write the size of an item, on disk, to the console using
    nice formatting and showing the common orders-of-magnitude:
    KB, MB, and GB.

    .PARAMETER path
    The path to the item whose size to calculate
  #>

  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $path
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
