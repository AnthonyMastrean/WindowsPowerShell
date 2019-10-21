function Get-HttpStatusCodeInfo([int]$code) {
    $url = "http://httpcode.info/$code"

    Invoke-RestMethod `
        -Uri $url `
        -UserAgent 'curl'
}
