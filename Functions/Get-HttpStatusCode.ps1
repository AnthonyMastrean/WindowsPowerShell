function Get-HttpStatusCode($code) {
  $web = New-Object System.Net.WebClient
  $web.Headers.Add("User-Agent", "curl")
  $web.DownloadString("http://httpcode.info/$code")
}

Set-Alias http Get-HttpStatusCode
