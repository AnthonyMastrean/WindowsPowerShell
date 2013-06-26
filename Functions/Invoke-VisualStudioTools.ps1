<# 
	.SYNOPSIS
	Include the Visual Studio tools using the PSCX
#>

$var    = @('ENV:VS110COMNTOOLS', 'ENV:VS100COMNTOOLS') | ?{ Test-Path $_ } | Select-Object -First 1
$tools  = (Get-Item $var).Value
$vcargs = if([IntPtr]::Size -eq 8){'amd64'}else{'x86'}
$vcvars = Resolve-Path "$tools\..\..\VC\vcvarsall.bat"

Invoke-BatchFile $vcvars $vcargs
