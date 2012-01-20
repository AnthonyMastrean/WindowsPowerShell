Import-Module Pester
Import-Module PowerTab -ArgumentList "$ENV:APPDATA\powertab\powertabconfig.xml"
Import-Module Pscx
Import-Module posh-git

# ==================================================
# Setup PSDrive for Scripts directory
# ==================================================
if(-not(Test-Path Scripts:)) {
    $scripts = Join-Path (Split-Path $PROFILE) 'Scripts'
    New-PSDrive -name Scripts -PSProvider FileSystem -Root $scripts | Out-Null
}

# ==================================================
# Include the Visual Studio tools
# ==================================================
$vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
$vcvars = "${ENV:VS100COMNTOOLS}..\..\VC\vcvarsall.bat"
Invoke-BatchFile $vcvars $vcargs

# ==================================================
# Set up a simple prompt, adding the git prompt parts inside git repos
# ==================================================
function prompt 
{
    $host.UI.RawUi.WindowTitle = ("{0}@{1}" -f $ENV:USERNAME, $ENV:COMPUTERNAME)
    
    Write-Host($pwd) -nonewline
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $GitStatus
    
    return "> "
}

# ==================================================
# Setup PowerTab
# ==================================================
if(-not(Test-Path Function:\DefaultTabExpansion)) 
{
    Rename-Item Function:\TabExpansion DefaultTabExpansion
}

# ==================================================
# Setup tab expansion and include git expansion
# ==================================================
function TabExpansion($line, $lastWord) 
{
    $lastBlock = [regex]::Split($line, '[|;]')[-1]
    switch -regex ($lastBlock) 
    {
        'git (.*)' { GitTabExpansion $lastBlock }
        default { DefaultTabExpansion $line $lastWord }
    }
}

# ==================================================
# Configure persistent history
# ==================================================
$history = Join-Path (Split-Path $PROFILE) 'history.csv'

Register-EngineEvent -SourceIdentifier powershell.exiting -SupportEvent -Action {
    Get-History -Count 10Kb | Export-Csv $history }

if(Test-Path $history) {
    Import-Csv $history | Add-History
}

Enable-GitColors