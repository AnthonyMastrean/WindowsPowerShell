<#
	.SYNOPSIS
	Add a font to the available fonts in the command window.
	
	.LINK
	http://support.microsoft.com/default.aspx?scid=KB;EN-US;Q247815
#>
param(
    [parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $name
)

# This registry key lists the fonts available in the console. The fonts are keyed
# with incrementing zeroes ('0'). We'll get the font keys and all of the font names 
# for invariant checks.
$consoleKey = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont'
$fontKeys = (Get-Item $consoleKey).GetValueNames() | ?{ $_.StartsWith('0') }
$fonts = $fontKeys | %{ (Get-ItemProperty $consoleKey -Name $key).$key }

if($fonts -contains $name) {
    Write-Debug "The font is already available in the command window"
    return
}

# Check to see if the font is installed on the system for use in the console.
$fontRegkey = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'
$names = (Get-Item $fontRegkey).GetValueNames()

if($names -notcontains $name) {
    Write-Error "The font is not installed on the system"
    return
}

# Get the next font key and add the property.
$newFontKey = $null
0..$fontKeys.Length | %{ $newFontKey += '0' }
New-ItemProperty $consoleKey -name $newFontKey -value $name