function Format-Bytes {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [byte[]] $Bytes
    )

    $n = 16

    $padded = $Input | %{ '{0,3}' -f $_ }
    $ascii = $Input | %{ [System.Text.Encoding]::ASCII.GetString($_) }

    for($i = 0; $i -lt $Input.Length; $i += $n) {
        $x = $padded[$i..($i + $n)] -join ' '
        $y = $ascii[$i..($i + $n)] -join '' -replace "`r|`n", ''

        '{0:00000000}   {1,-67}  {2}' -f $i, $x, $y
    }
}
