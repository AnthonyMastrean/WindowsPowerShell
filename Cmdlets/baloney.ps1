function Foo() {
  $url = "http://www.dack.com/web/bullshit.html"
  Invoke-WebRequest -Uri $url -Method POST
}
