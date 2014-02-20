function Get-IsWebsiteUp {
  param(
    [Parameter(Mandatory = $true)]
    [uri] $url
  )

  $result = Invoke-WebRequest "http://isup.me/$url"
  $result.Content.Contains("is up")
}

Set-Alias isup Get-IsWebsiteUp
