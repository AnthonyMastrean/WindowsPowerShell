function Get-HttpStatusCode {
  param(
    [Parameter(Mandatory = $true)]
    [int] $code
  )

  $result = Invoke-WebRequest "http://httpcode.info/$code" -UserAgent "curl"
  $result.Content
}

Set-Alias http Get-HttpStatusCode
