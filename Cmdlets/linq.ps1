function Select-FirstObject { 
  $input | Select-Object -First 1
}

function Select-LastObject {
  $input | Select-Object -Last 1
}

function Select-TopObject {
  param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [int] $n = 10
  )

  $input | Select-Object -First $n
}
