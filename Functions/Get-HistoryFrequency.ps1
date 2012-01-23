<#
    Configure global persistent history.
#>

$global:MaxHistoryCount = 10Kb
$historyFile = Join-Path (Split-Path $PROFILE) 'history.csv'

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

Register-EngineEvent -SourceIdentifier powershell.exiting -SupportEvent -Action {
    Get-History -Count $global:MaxHistoryCount | Export-Csv $historyFile 
}

if(Test-Path $historyFile) {
    $history = Import-Csv $historyFile 
    "Importing persistent history ({0} of {1} commands)" -f $history.Count,$global:MaxHistoryCount
    $history | Add-History
}

Set-Alias hf Get-HistoryFrequency