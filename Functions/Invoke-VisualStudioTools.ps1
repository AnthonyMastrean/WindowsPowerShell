<# 
	.SYNOPSIS
	Include the Visual Studio tools using the Pscx
#>

$tools = $ENV:VS110COMNTOOLS

if(-not(Test-Path $tools)) {
	Write-Error "Cannot find Visual Studio 2012 common tools"
	return
}

$vcargs = if($Pscx:Is64BitProcess) { 'amd64' } else { 'x86' }
$vcvars = "$tools\..\..\VC\vcvarsall.bat"

Invoke-BatchFile $vcvars $vcargs
