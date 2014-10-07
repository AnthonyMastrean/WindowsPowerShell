function Test-IsWebsiteUp($url) {
  $urlx = "http://isup.me/$url"
  $token = "is up"
  
  (Invoke-WebRequest $urlx).Content -match $token
}
