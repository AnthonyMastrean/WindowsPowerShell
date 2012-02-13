Import-Module PowerTab -ArgumentList "$ENV:APPDATA\powertab\powertabconfig.xml"
Import-Module Pscx

Get-Module -ListAvailable | ?{ $_.ModuleType -eq 'Script' } | Import-Module

$bitness = if([IntPtr]::size -eq 8) { 'amd64' } else { 'x86' }

# ==================================================
# Setup PSDrive for Scripts directory
# ==================================================
if(-not(Test-Path Scripts:)) {
    $scripts = Join-Path (Split-Path $PROFILE) 'Scripts'
    New-PSDrive -name Scripts -PSProvider FileSystem -Root $scripts | Out-Null
}

# ==================================================
# Include all functions
# ==================================================
$functions = Join-Path (Split-Path $PROFILE) 'Functions'
Resolve-Path $functions\*.ps1 | %{ 
    . $_.ProviderPath
}

# ==================================================
# Include the Visual Studio tools
# ==================================================
$vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
$vcvars = "$ENV:VS100COMNTOOLS\..\..\VC\vcvarsall.bat"
Invoke-BatchFile $vcvars $vcargs

# ==================================================
# Set the prompt title and git status
# ==================================================
function prompt {
    $host.UI.RawUi.WindowTitle = ('{0}@{1} [.NET {2}.{3}] ({4})' -f `
        $ENV:USERNAME, `
        $ENV:COMPUTERNAME, `
        $PSVersionTable.CLRVersion.Major, `
        $PSVersionTable.CLRVersion.Minor, `
        $bitness)
    
    Write-Host $pwd  -NoNewline
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $GitStatus
    
    return '> '
}

# ==================================================
# Setup PowerTab
# ==================================================
if(-not(Test-Path Function:\DefaultTabExpansion)) {
    Rename-Item Function:\TabExpansion DefaultTabExpansion
}

# ==================================================
# Setup tab expansion and include git expansion
# ==================================================
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1]
    switch -regex ($lastBlock) 
    {
        'git (.*)' { GitTabExpansion $lastBlock }
        default { DefaultTabExpansion $line $lastWord }
    }
}

Enable-GitColors