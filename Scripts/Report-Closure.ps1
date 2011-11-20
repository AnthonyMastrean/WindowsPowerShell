<#
    .Synopsis
    Report the relative degree of closure of a codebase.
    
    .Description
    Are you concerned that your codebase is a festering one? Want proof? Then run this function at the solution root 
    and watch as it reports the number of check-ins per C# code file. This function only works against TFS source 
    control (and the working directory must be mapped in a Workspace for the TFS PowerShell snap-in to work). The idea
    is that files with numerous check-ins are being modified in-place. Whereas, the Open-Closed Principle states that 
    
        "entities should be open for extension, but closed for modification"
        
    What we want to see is a budding codebase! New files, meaning new classes and methods, are preferable.
    
    .Example
    C:\PS\my-solution> Report-Closure | Format-Table -AutoSize
    
    .Example
    C:\PS\my-solution> Report-Closure | Export-CSV closure.csv
#>
function Report-Closure {
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.TeamFoundation.VersionControl.Client") | Out-Null
    $filter = [Microsoft.TeamFoundation.VersionControl.Client.ChangeType] "Add, Edit, Rename"
    Get-TfsItemHistory *.cs -Recurse -IncludeItems `
        | Select-Object -Expand "Changes" `
        | Where-Object { ($_.ChangeType -band $filter) -ne 0 } `
        | Select-TfsItem `
        | Group-Object Path `
        | Select-Object Count, Name `
        | Sort-Object Count -Descending 
}