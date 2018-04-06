function Invoke-Stopwatch {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [scriptblock] $InputObject = { }
    )

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    & $InputObject
    $stopwatch.Stop();
    $stopwatch
}
