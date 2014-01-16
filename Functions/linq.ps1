function Select-First { 
  $input | Select-Object -First 1
}

function Select-Last {
  $input | Select-Object -Last 1
}

function Select-Top([int]$n = 10) {
  $input | Select-Object -First $n
}

Set-Alias first Select-First
Set-Alias last Select-Last
Set-Alias top Select-Top
