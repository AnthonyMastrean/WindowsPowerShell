<# 
	.SYNOPSIS
	Include the Visual Studio tools using the Pscx
#>

$VERSION = 110
$TOOLS = "ENV:VS{0}COMNTOOLS" -f $VERSION

if(-not(Test-Path $TOOLS)) {
	Write-Error 'Cannot find the Visual Studio common tools'
	return
}

$vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
$vcvars = "$TOOLS\..\..\VC\vcvarsall.bat"
Invoke-BatchFile $vcvars $vcargs