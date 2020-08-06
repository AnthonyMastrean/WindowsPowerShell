function Get-HttpStatusCodeInfo([int]$code) {
    $uri = "http://httpcode.info/$code"

    Invoke-RestMethod `
        -Uri $uri `
        -UserAgent curl
}
