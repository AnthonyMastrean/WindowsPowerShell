Import-Module Goto
Import-Module posh-git
Import-Module PowerTab -ArgumentList "$env:appdata\powertab\powertabconfig.xml"
Import-Module Pscx

$vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
$vcvars = "${env:VS100COMNTOOLS}..\..\VC\vcvarsall.bat"
Invoke-BatchFile $vcvars $vcargs

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt {
    Write-Host($pwd) -nonewline
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $GitStatus
    return "> "
}

if(-not (Test-Path Function:\DefaultTabExpansion)) {
    Rename-Item Function:\TabExpansion DefaultTabExpansion
}

# Set up tab expansion and include git expansion
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1]
    switch -regex ($lastBlock) {
        'git (.*)' { GitTabExpansion $lastBlock }
        default { DefaultTabExpansion $line $lastWord }
    }
}

Enable-GitColors
Clear-Host