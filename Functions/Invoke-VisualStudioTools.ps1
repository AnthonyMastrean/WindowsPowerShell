<# 
	.SYNOPSIS
	Include the Visual Studio tools using the Pscx
#>

$var    = @( 'ENV:VS110COMNTOOLS', 'ENV:VS100COMNTOOLS' ) | ?{ Test-Path $_ } | Select-Object -First 1
$tools  = (Get-Item $var).Value
$vcargs = if($Pscx:Is64BitProcess) { 'amd64' } else { 'x86' }
$vcvars = "$tools\..\..\VC\vcvarsall.bat"

Invoke-BatchFile $vcvars $vcargs
