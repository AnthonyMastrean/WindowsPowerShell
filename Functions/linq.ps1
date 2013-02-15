function Select-First { 
  $input | Select-Object -First 1
}

function Select-Last {
  $input | Select-Object -Last 1
}

Set-Alias first Select-First
Set-Alias last Select-Last
