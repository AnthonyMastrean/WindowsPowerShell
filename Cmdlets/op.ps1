function Get-OpItemPassword {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Item
    )

    op get item $Item `
        | ConvertFrom-Json `
        | %{ $_.details.fields } `
        | ?{ $_.designation -eq 'password' } `
        | Select-Object -Expand value
}

function Set-ClipboardSecure {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        $Value,

        [Parameter(Mandatory = $false)]
        [int] $Interval = 10
    )

    Set-Clipboard -Value $Value

    $ps = [powershell]::Create()
    $ps.Runspace = [RunspaceFactory]::CreateRunspace()
    $ps.Runspace.ApartmentState = 'STA'
    $ps.Runspace.Open()

    [void] $ps.AddScript({
        param($Interval)

        Start-Sleep -Seconds $Interval
        Set-Clipboard -Value $null
    }).AddArgument($Interval)

    $ps.BeginInvoke() | Out-Null
}
