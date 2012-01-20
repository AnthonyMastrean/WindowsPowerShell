function Get-HistoryFrequency
{
    $commands = Get-Command
    $history = Get-History -Count $global:MaxHistoryCount | %{
        
        # If the command exactly matches a PowerShell command, ignore
        # the arguments. If not, it must be a native command, or something
        # special. Take the whole thing.
        
        $token = $_.CommandLine.Split(' ')[0]
        $isMatch = $commands | ?{ $_.Name -eq $token }
        
        if($isMatch) { $token } else { $_.CommandLine }
    }

    $history `
        | Group-Object `
        | ?{ $_.Count -gt 1 } `
        | Sort-Object Count -Descending `
        | Format-Table Count, @{ Label='Command'; Expression={$_.Name} } -AutoSize
}

Set-Alias hf Get-HistoryFrequency