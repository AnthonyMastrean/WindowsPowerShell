<#
    .SYNOPSIS
    What pieces of code are owned by someone, and how you can detect 
    it? Owned means that they are the only one that can touch that 
    code. Whatever it is by policy or simply because they are the 
    only one with the skills / ability to do so.
    
    .DESCRIPTION
    This would be a good way to indicate a risky location, some place 
    that only very few people can touch and modify.
    
        * Find all files changed within the last year
        * Remove all files whose changes are over a period of less than 
          two weeks (that usually indicate a completed feature).
        * Remove all the files that are modified by more than 2 people.
        * Show the result and the associated names.
        
    .EXAMPLE
    C:\PS> Get-CodeOwnership
    
    Report the ownership for any C# files (.cs) that exist in this 
    directory.
#>
function Get-CodeOwnership {
    
    Import-TfsLibraries

    $filter     = [Microsoft.TeamFoundation.VersionControl.Client.ChangeType] 'Add,Edit,Rename'
    $threshold  = (Get-Date).AddYears(-1)
    $twoWeeks   = [timespan]::FromDays(14)
    
    $changesets = Get-TfsItemHistory *.cs -Recurse -IncludeItems `
        | ?{ $_.CreationDate -gt $threshold }
    
    $files = $changesets `
        | Select-Object -Expand 'Changes' `
        | ?{ ($_.ChangeType -band $filter) -ne 0 } `
        | Select-TfsItem `
        | Group-Object Path

    $files | %{
        $context = $_ `
            | Select-Object -Expand Group `
            | Select-Object -Expand Versions `
            | Select-Object ChangesetId `
            | % -begin { $ctx = @() } -process { $ctx += $changesets | ?{ $_.ChangesetId -eq $id.ChangesetId } } -end { $ctx }
        
        # Consider all files whose changes span over 2 weeks
        $dates  = $context | Select-Object -Expand CreationDate | Sort-Object
        $period = [datetime]($dates[0]) - [datetime]($dates[-1])
        if(-not($period -gt $twoWeeks)) {
            return
        }
        
        # Add all files with 1 or 2 authors
        $authors = $context | Group-Object Committer
        if($authors.Length -gt 2) {
            return
        }
        
        $_ | Select-Object `
            @{ Name = 'Item';    Expression = { $_.Name } }, `
            @{ Name = 'Authors'; Expression = { $authors | Select-Object -Expand Name } }
    }
}
