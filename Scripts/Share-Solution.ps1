<#
    .Synopsis
    Clean and archive a solution for sharing.
    
    .Description
    Want to email a solution to your friend, coworker, or significant 
    other? You'll want to remove the large bin and obj directories 
    from every project. And throw away the TestResults while you're 
    at it. These directories are large! And they aren't needed when 
    sharing. While we're at it, let's zip the solution and place it 
    at the parent directory, right next to your solution directory!
       
    .Example
    Scripts:\Share-Solution.ps1 ocsbot
    
    Clean the chat bot project, ocsbot, and archive it here.
#>
param([string]$path = ".")

if(-not(Test-Path $path\*.sln))
{
    Write-Error "Cannot find a solution at '$(Resolve-Path $path)'"
    return
}

$path = Resolve-Path $path
$temp = "$path.tmp"
$name = "{0}.zip" -f (Split-Path $path -leaf)

# default includes, good for .NET projects
$exclude = "bin","obj"
if(Test-Path $path\.gitignore)
{
    $exclude = Get-Content $path\.gitignore
}

Copy-Item $path $temp -force -recurse
Get-ChildItem $temp -force -recurse -include $exclude | Remove-Item -force -recurse

& 7za u -tzip -mx9 "$name" "$temp\*" | Out-Null

Remove-Item $temp -force -recurse