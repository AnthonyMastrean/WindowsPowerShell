Import-Module Goto
Import-Module posh-flow
Import-Module posh-git
Import-Module PowerTab -ArgumentList "$env:appdata\powertab\powertabconfig.xml"
Import-Module Pscx

$vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
$vcvars = "${env:VS100COMNTOOLS}..\..\VC\vcvarsall.bat"
Invoke-BatchFile $vcvars $vcargs

# Set up a simple prompt, adding the git prompt parts inside git repos
function prompt 
{
    $host.UI.RawUi.WindowTitle = ("{0}@{1}" -f $Env:USERNAME, $Env:COMPUTERNAME)
    
    Write-Host($pwd) -nonewline
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $GitStatus
    
    return "> "
}

if(-not (Test-Path Function:\DefaultTabExpansion)) 
{
    Rename-Item Function:\TabExpansion DefaultTabExpansion
}

# Set up tab expansion and include git expansion
function TabExpansion($line, $lastWord) 
{
    $lastBlock = [regex]::Split($line, '[|;]')[-1]
    switch -regex ($lastBlock) 
    {
        'git (.*)' { GitTabExpansion $lastBlock }
        default { DefaultTabExpansion $line $lastWord }
    }
}

function Print-EnvironmentPath
{
    param
    (
        [switch] $machine,
        [switch] $process
    )

    if($process)
    {
        Write-Host ""
        Write-Host "ENVIRONMENT :: PATH :: PROCESS"
        [System.Environment]::GetEnvironmentVariable("Path", "Process").Split(";")
        return
    }

    if($machine)
    {
        Write-Host "ENVIRONMENT :: PATH :: MACHINE"
        [System.Environment]::GetEnvironmentVariable("Path", "Machine").Split(";")
        return
    }
    
    Write-Host ""
    Write-Host "ENVIRONMENT :: PATH :: USER"
    (Get-ChildItem ENV:PATH).Value.Split(";")
}

Set-Alias pp Print-EnvironmentPath
Enable-GitColors
Clear-Host