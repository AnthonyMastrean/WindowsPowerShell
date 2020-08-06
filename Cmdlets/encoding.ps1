function ConvertTo-Base64 {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Text
    )

    [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Text))
}

function ConvertFrom-Base64 {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Text
    )

    [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Text))
}

function ConvertTo-HtmlEncode {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Text
    )

    [System.Net.WebUtility]::HtmlEncode($Text)
}

function ConvertFrom-HtmlEncode {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Text
    )

    [System.Net.WebUtility]::HtmlDecode($Text)
}

function ConvertTo-UrlEncode {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Text
    )

    [System.Net.WebUtility]::UrlEncode($Text)
}

function ConvertFrom-UrlEncode {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Text
    )

    [System.Net.WebUtility]::UrlDecode($Text)
}
