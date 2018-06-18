function Invoke-Watch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock] $Command,

        [Parameter(Mandatory = $false)]
        [int] $Interval = 2
    )

    while($true) {
        Clear-Host
        & $Command

        Start-Sleep -Seconds $Interval
    }
}
