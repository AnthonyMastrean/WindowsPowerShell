function Write-Calendar {
  <#
    .SYNOPSIS
    Displays a calendar.
    
    .DESCRIPTION
    Displays a simple calendar with today's date highlighted.
    
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
  $first = Get-Date -Year $today.Year -Month $today.Month -Day 1
  $days = [datetime]::DaysInMonth($today.Year, $today.Month)
  
  $header = "{0:MMMM yyyy}" -f $today
  $header_padding = [math]::Floor((19 - $header.Length) / 2) + $header.Length
  $first_padding = 3 * [int]$first.DayOfweek
  
  Write-Host ""
  Write-Host ("{0,$header_padding}" -f $header)
  Write-Host "Su Mo Tu We Th Fr Sa"
  Write-Host ("{0,$first_padding}" -f "") -NoNewLine
  
  1..$days | %{ 
    $current = Get-Date -Year $today.Year -Month $today.Month -Day $_
    
    $date = @{$true=" $_ ";$false="$_ "}[$_ -lt 10]
    $foreground = @{$true="Green";$false=$HOST.UI.RawUI.ForegroundColor}[$_ -eq $today.Day]
    
    Write-Host $date -ForegroundColor $foreground -NoNewLine 
    
    if($current.DayOfWeek -eq "Saturday") { 
      Write-Host "" 
    }
  }
  
  Write-Host ""
  Write-Host ""
}
 