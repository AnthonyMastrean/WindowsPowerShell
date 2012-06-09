<# 
	.SYNOPSIS
	Include the Visual Studio tools
#>

if(-not(Test-Path ENV:VS100COMNTOOLS)) {
	Write-Error 'Cannot find the Visual Studio common tools'
	return
}

$vcargs = ?: {$Pscx:Is64BitProcess} {'amd64'} {'x86'}
$vcvars = "$ENV:VS100COMNTOOLS\..\..\VC\vcvarsall.bat"
Invoke-BatchFile $vcvars $vcargs