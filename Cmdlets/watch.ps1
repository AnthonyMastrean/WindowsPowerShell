function Invoke-Watch {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [scriptblock] $InputObject = { }
    )

    while($true) {
        Clear-Host
        & $InputObject
    }
}
