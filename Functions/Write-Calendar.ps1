function Write-Calendar {
  <#
    .SYNOPSIS
    Write the current month's calendar to the console.
    
    .DESCRIPTION
    Write the current month's calendar to the console.
    
    .EXAMPLE
    PS> Get-Calendar
    
        August 2013     
    Su Mo Tu We Th Fr Sa
                 1  2  3
     4  5  6  7  8  9 10
    11 12 13 14 15 16 17
    18 19 20 21 22 23 24
    25 26 27 28 29 30 31
    
  #>
  
  $today = Get-Date
  $days = [datetime]::DaysInMonth($today.Year, $today.Month)
  
  $first = Get-Date -Year $today.Year -Month $today.Month -Day 1
  
  $header = "{0} {1}" -f $today.ToString("MMMM"), $today.Year
  $header_padding = [math]::Floor((19 - $header.Length) / 2)
  
  Write-Host ""
  Write-Host (" " * $header_padding), $header
  Write-Host "Su Mo Tu We Th Fr Sa"
  Write-Host ("   " * $first.DayOfWeek) -NoNewLine
  
  1..$days | %{ 
    $date = Get-Date -Year $today.Year -Month $today.Month -Day $_
    
    if($_ -lt 10) { $date_format = " {0} " } else { $date_format = "{0} " }
    if($_ -eq $today.Day) { $date_foreground = "Green" } else { $date_foreground = $Host.UI.RawUI.ForegroundColor }
    
    Write-Host ($date_format -f $_) -ForegroundColor $date_foreground -NoNewLine 
    
    if($date.DayOfWeek -eq "Saturday") { Write-Host "" }
  }
  
  Write-Host ""
  Write-Host ""
}
 
Set-Alias cal Write-Calendar