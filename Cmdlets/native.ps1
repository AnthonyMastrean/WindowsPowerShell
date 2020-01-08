function Invoke-NativeCommand {
    <#
    .SYNOPSIS
    Executes an external utility with stderr output sent to PowerShell's error
    stream, and an exception thrown if the utility reports a nonzero exit code.
    #>

    param(
        [parameter(Mandatory = $true)]
        [string] $Command
    )

    . { Invoke-Expression $Command } 2>&1 | %{
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            # send stderr to PowerShell's error stream
            Write-Error $_
        } else {
            # pass stdout
            $_
        }
    }

    if ($LASTEXITCODE) {
        Throw "Command failed with exit code ${LASTEXITCODE}: $Command"
    }
}
