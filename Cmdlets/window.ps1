function Select-Window {

    [CmdletBinding()]
    Param(
        [Alias('Sequence')]
        [Parameter(ValueFromPipeline = $true)]
        [PSObject[]] $InputObject = @(),

        [Parameter()]
        [int] $Size = 1
    )

    Begin {
        $queue = New-Object -TypeName 'System.Collections.Queue' -ArgumentList $Size
    }

    Process {
        foreach($item in $InputObject) {
            $queue.Enqueue($item)
            if($queue.Count -eq $Size) {
                try {
                    ,$queue.ToArray()
                } finally {
                    [void]$queue.Dequeue()
                }
            }
        }
    }

    End {}

}
