<# 
    .Synopsis
    Report the projects that have post build steps.
    
    .Description
    Wondering why your projects fail to build from the command line? From TeamCity? or as part of an AutoTest.NET 
    watched directory? Wonder no more! Run this function to report all the projects that have gnarly post-build steps 
    and see what those steps are.
    
    .Example
    PS\my-solution> Report-PostBuildSteps
    
    .Example
    PS\my-solution> Set-Content post-build-steps.txt (Report-PostBuildSteps)
#>
function Report-PostBuildSteps 
{
    $projects = Get-ChildItem -Recurse -Include *.csproj
    
    foreach($project in $projects)
    {
        $xml = [xml] (Get-Content $project)
        $postbuild = $xml.Project.PropertyGroup | ?{ $_.PostBuildEvent -ne $null }
            
        if($postbuild -ne $null -and $postbuild.InnerText -ne "")
        {
            Write-Host "=================================================="
            Write-Host $project.BaseName
            Write-Host "--------------------------------------------------"
            Write-Host $postbuild.InnerText
            Write-Host "=================================================="
            Write-Host ""
        }
    }
}