function Select-FirstObject {
  @($Input) | Select-Object -First 1
}

function Select-LastObject {
  @($Input) | Select-Object -Last 1
}

function Select-TopObject {
  param(
    [Parameter(ValueFromPipeline = $true)]
    $InputObject,

    [Parameter(Mandatory = $false, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [int] $n = 10
  )

  @($Input) | Select-Object -First $n
}
