function Get-HistoryFrequency
{
    Get-History -Count $($global:MaxHistoryCount `
        | Group-Object CommandLine `
        | Sort-Object Count -Descending `
        | ?{ $_.Count -gt 1 } `
        | Format-Table Count, @{ Label='Command'; Expression={$_.Name} } -AutoSize
}

Set-Alias hf Get-HistoryFrequency