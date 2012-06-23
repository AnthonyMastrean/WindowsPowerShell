$here = Split-Path $PROFILE

Import-Module PowerTab -ArgumentList "$ENV:APPDATA\powertab\powertabconfig.xml"
Import-Module Pscx

Get-Module -ListAvailable | ?{ $_.ModuleType -eq 'Script' } | Import-Module

Get-ChildItem $here\Functions -include *.ps1 -recurse | %{ . $_.FullName }

function prompt {
    Set-LastVisitedDirectory

    $host.UI.RawUi.WindowTitle = ('{5}{0}@{1} [.NET {2}.{3}] ({4})' -f `
        $ENV:USERNAME, `
        $ENV:COMPUTERNAME, `
        $PSVersionTable.CLRVersion.Major, `
        $PSVersionTable.CLRVersion.Minor, `
        $(if([IntPtr]::Size -eq 8){'amd64'} else{'x86'}),
        $(if($host.UI.RawUI.WindowTitle.StartsWith('Administrator: ')){'Administrator: '})
    )
    
    $realLASTEXITCODE = $LASTEXITCODE
    
    # posh-git
    $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
    Write-Host $pwd -nonewline
    Write-VcsStatus
    
    $global:LASTEXITCODE = $realLASTEXITCODE
    
    return '> '
}

Set-Alias new New-Object

Enable-GitColors