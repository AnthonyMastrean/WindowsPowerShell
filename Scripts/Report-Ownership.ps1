<#
    .Synopsis
    What pieces of code are owned by someone, and how you can detect 
    it? Owned means that they are the only one that can touch that 
    code. Whatever it is by policy or simply because they are the 
    only one with the skills / ability to do so.
    
    .Description
    This would be a good way to indicate a risky location, some place 
    that only very few people can touch and modify.
    
        * Find all files changes within the last year
        * Remove all files whose changes are over a period of less than 
          two weeks (that usually indicate a completed feature).
        * Remove all the files that are modified by more than 2 people.
        * Show the result and the associated names.
#>
function Report-Ownership
{
    Load-TeamFoundationLibraries
    
    $changesets = Get-RecentChangesets $((Get-Date).AddYears(-1))
    $changes = Get-FilesFromChangesets $changesets
    
    foreach($change in $changes)
    {
        $context = Get-ChangesetsForFile $change $changesets
        
        # Consider all files whose changes span over 2 weeks
        $dates = $context | Select-Object -Expand CreationDate
        $earliest = Measure-Earliest $dates
        $latest = Measure-Latest $dates
        
        $period = [datetime]$latest - [datetime]$earliest
        $twoWeeks = [timespan]::FromDays(14)
        if(-not($period -gt $twoWeeks))
        {
            continue
        }
        
        # Add all files with 1 or 2 authors
        $authors = $context | Group-Object Committer
        if($authors.Length -gt 2)
        {
            continue
        }
        
        $change | Select-Object `
            @{ Name='Item'; Expression = { $change.Name } }, `
            @{ Name='Authors'; Expression = { $authors | Select-Object -Expand Name } }
            
    }
}

function Load-TeamFoundationLibraries()
{
    $snapin   = "Microsoft.TeamFoundation.PowerShell"
    $assembly = "Microsoft.TeamFoundation.VersionControl.Client"

    if(-not(Get-PSSnapin $snapin))
    {
        Add-PSSnapin $snapin | Out-Null
    }
    
    [System.Reflection.Assembly]::LoadWithPartialName($assembly) | Out-Null   
}

function Get-RecentChangesets([datetime]$threshold)
{
    Get-TfsItemHistory *.cs -Recurse -IncludeItems | ?{ $_.CreationDate -gt $threshold }
}

function Get-FilesFromChangesets($changesets)
{
    $filter = [Microsoft.TeamFoundation.VersionControl.Client.ChangeType] "Add, Edit, Rename"

    $changesets `
        | Select-Object -Expand "Changes" `
        | ?{ ($_.ChangeType -band $filter) -ne 0 } `
        | Select-TfsItem `
        | Group-Object Path
}

function Get-ChangesetsForFile($change, $changesets)
{
    $ids = $change `
        | Select-Object -Expand Group `
        | Select-Object -Expand Versions `
        | Select-Object ChangesetId
        
    $context = @()
    foreach($id in $ids)
    {
        $context += $changesets | ?{ $_.ChangesetId -eq $id.ChangesetId }
    }
    
    $context
}

function Measure-Earliest($range = @())
{
    $range | Sort-Object | Select-Object -First 1
}

function Measure-Latest($range = @())
{
    $range | Sort-Object -Descending | Select-Object -First 1
}