$here = Split-Path $PROFILE
$cmdlets = Join-Path $here 'Cmdlets'
$modules = Join-Path $here 'Modules'

function prompt {
  Write-Host ''
  Write-Host "$ENV:USERNAME@$ENV:COMPUTERNAME " -ForegroundColor 'DarkGreen' -NoNewLine
  Write-Host ($ExecutionContext.SessionState.Path.CurrentLocation -replace [regex]::Escape($ENV:USERPROFILE), '~') -ForegroundColor 'DarkYellow' -NoNewLine
  Write-VcsStatus
  Write-Host ''
  "$('PS>' * ($nestedPromptLevel + 1)) "
}

Get-ChildItem $modules | Import-Module
Get-ChildItem $cmdlets | %{ . $_.FullName }

Import-Module posh-git
$GitPromptSettings.EnableWindowTitle = $true

Set-PSReadlineOption -ExtraPromptLineCount 2
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
Set-PSReadLineKeyHandler `
    -Chord 'Oem7','Shift+Oem7' `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
    -ScriptBlock {
        param($key, $arg)

        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

        if ($line[$cursor] -eq $key.KeyChar) {
            # Just move the cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
        }
        else {
            # Insert matching quotes, move cursor to be in between the quotes
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
        }
    }

Set-Alias cal Write-Calendar
Set-Alias fastdelete Remove-ItemNative
Set-Alias first Select-FirstObject
Set-Alias httpcode Get-HttpStatusCode
Set-Alias isup Test-IsWebsiteUp
Set-Alias last Select-LastObject
Set-Alias less more
Set-Alias mklink New-SymbolicLink
Set-Alias mnemonic Get-MnemonicName
Set-Alias new New-Object
Set-Alias play Send-Sound
Set-Alias say Speak-Text
Set-Alias size Write-ItemSize
Set-Alias sunrise Get-Sunrise
Set-Alias time Invoke-Stopwatch
Set-Alias top Select-TopObject
Set-Alias touch Set-FileTime
Set-Alias unzip Expand-Archive
Set-Alias uuidgen New-Guid
Set-Alias watch Invoke-Watch
Set-Alias which Get-Command
