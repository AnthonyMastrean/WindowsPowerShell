function Get-Sunrise {
  $url = "http://api.wolframalpha.com/v2/query?input=sunrise%20pittsburgh%20pa&appid=$ENV:WOLFRAM_APPID&includepodid=Result"

  $req = Invoke-WebRequest $url
  $content = [xml] $req.Content

  $content.queryresult.pod.subpod.plaintext
}
