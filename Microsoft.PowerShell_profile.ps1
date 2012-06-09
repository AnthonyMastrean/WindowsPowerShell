Import-Module PowerTab -ArgumentList "$ENV:APPDATA\powertab\powertabconfig.xml"
Import-Module Pscx

Get-Module -ListAvailable | ?{ $_.ModuleType -eq 'Script' } | Import-Module

$here      = Split-Path $PROFILE
$scripts   = Join-Path  $here 'Scripts'
$functions = Join-Path  $here 'Functions'

if(-not(Test-Path Scripts:)) {
    New-PSDrive -Name Scripts -PSProvider FileSystem -Root $scripts | Out-Null
}

Resolve-Path $functions\*.ps1 | %{ . $_.ProviderPath }

function prompt {
    $host.UI.RawUi.WindowTitle = ('{0}@{1} [.NET {2}.{3}] ({4})' -f `
        $ENV:USERNAME, `
        $ENV:COMPUTERNAME, `
        $PSVersionTable.CLRVersion.Major, `
        $PSVersionTable.CLRVersion.Minor, `
        $vcargs)
    
    $realLASTEXITCODE = $LASTEXITCODE
    
    # posh-git
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    Write-Host $pwd -nonewline
    Write-VcsStatus
    
    $global:LASTEXITCODE = $realLASTEXITCODE
    
    return '> '
}

Enable-GitColors