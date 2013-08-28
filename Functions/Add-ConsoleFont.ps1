$script:ConsoleFontsKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"

<#
  .SYNOPSIS
  Add a font to the available fonts list in the console.
    
  .DESCRIPTION
  This function will confirm that the font you provide is installed in the 
  system. And will confirm and manage adding the font properly to the 
  registry, per the rules.
    
  .PARAMETER name
  The full name of the font as it"s printed in the output of the Get-Fonts 
  cmdlet.
	
  .LINK
  http://support.microsoft.com/default.aspx?scid=KB;EN-US;Q247815
#>
function Add-ConsoleFont {
	param(
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
    [ValidateScript({ $_.Contains("(TrueType)") })]
		[string] $name
	)

  $consoleFonts = Get-ConsoleFonts
	if($consoleFonts -contains $name) {
		Write-Debug "The font is already available in the console"
		return
	}

  $installedFonts = Get-Fonts
	if($installedFonts -notcontains $name) {
		Write-Error "The font is not installed on the system"
		return
	}

  $mangle = Get-TrimmedConsoleFontName $name
  $n = "0" * ($consoleFonts.Length + 1)
	New-ItemProperty $script:ConsoleFontsKey -name $n -value $mangle
}

<#
	.SYNOPSIS
	Remove a font from the available fonts list in the console.
    
  .PARAMETER name
  The full name of the font as it"s printed in the output of the Get-Fonts 
  cmdlet.
#>
function Remove-ConsoleFont {
	param(
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
    [ValidateScript({ $_.Contains("(TrueType)") })]
		[string] $name
	)

  $mangle = Get-TrimmedConsoleFontName $name

  $consoleFonts = Get-ConsoleFonts
	if($consoleFonts -notcontains $mangle) {
		Write-Debug "The font is not installed in the console"
		return
	}
    
  $n = Find-ConsoleFontIndex $mangle
  Remove-ItemProperty $script:ConsoleFontsKey -name $n
}

function Get-TrimmedConsoleFontName {
  param(
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
    [ValidateScript({ $_.Contains("(TrueType)") })]
		[string] $name
	)
    
  $name.Trim("(TrueType)").Trim()
}

function Find-ConsoleFontIndex {
  param(
		[parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string] $mangledName
	)
    
  Get-ConsoleFontIndexes | ?{ (Get-ItemProperty $script:ConsoleFontsKey -name $_).$_ -eq $mangledName }
}

function Get-ConsoleFontIndexes {
  (Get-Item $script:ConsoleFontsKey).GetValueNames() | ?{ $_.StartsWith("0") }
}

function Get-ConsoleFonts {
  Get-ConsoleFontIndexes | %{ (Get-ItemProperty $script:ConsoleFontsKey -Name $_).$_ }
}

function Get-Fonts {
	$key = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
	(Get-Item $key).GetValueNames()
}
