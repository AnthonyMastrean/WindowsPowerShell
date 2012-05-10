param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$log
)

$token = 'OmnyxScannerLogger'

$item = (Get-Item $log)
$filename = '{0}.{1}{2}' -f $item.BaseName, 'trimmed', $item.Extension
$output = Join-Path $item.Directory $filename

(Get-Content $log) `
    | ?{ -not $_.Contains($token) } `
    | Set-Content $output