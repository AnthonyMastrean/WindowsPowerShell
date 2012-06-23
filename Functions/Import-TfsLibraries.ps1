function Import-TfsLibraries {
    $snapin   = 'Microsoft.TeamFoundation.PowerShell'
    $assembly = 'Microsoft.TeamFoundation.VersionControl.Client'

    if(-not(Get-PSSnapin $snapin)) {
        Add-PSSnapin $snapin | Out-Null
    }
    
    [System.Reflection.Assembly]::LoadWithPartialName($assembly) | Out-Null   
}