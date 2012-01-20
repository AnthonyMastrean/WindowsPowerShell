function Get-HistoryFrequency
{
    $commands = Get-Command | Select -Expand Name
    Get-History -Count $global:MaxHistoryCount `
        | Select -Expand CommandLine `
        | %{        
            $tokens = $_.Split(' ')
            $isMatch = $commands -contains $tokens[0]
            if($isMatch) { $tokens[0] } else { "{0} {1}" -f $tokens[0], $tokens[1] }
        } `
        | Group-Object `
        | ?{ $_.Count -gt 1 } `
        | Sort-Object Count -Descending `
        | Format-Table Count, @{ Label='Command'; Expression={$_.Name} } -AutoSize
}

Set-Alias hf Get-HistoryFrequency