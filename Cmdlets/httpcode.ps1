function Get-HttpStatusCode($code) {
  $url = "http://httpcode.info/$code"
  $agent = "curl"
  
  (Invoke-WebRequest $url -UserAgent $agent).Content
}
