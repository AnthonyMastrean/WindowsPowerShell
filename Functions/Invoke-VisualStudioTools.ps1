<# 
	.SYNOPSIS
	Include the Visual Studio tools using the Pscx
#>

$VERSION = 110
$TOOLS   = "ENV:VS{0}COMNTOOLS" -f $VERSION

if(-not(Test-Path $TOOLS)) {
	Write-Error "Cannot find Visual Studio $VERSION common tools"
	return
}

$vcargs = if($Pscx:Is64BitProcess) { 'amd64' } else { 'x86' }
$vcvars = "$TOOLS\..\..\VC\vcvarsall.bat"

Invoke-BatchFile $vcvars $vcargs
