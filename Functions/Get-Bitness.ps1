function Get-Bitness {
    if(Get-Is64Bit) { 'amd64' } else { 'x86' }
}

function Get-Is64Bit {
    [IntPtr]::size -eq 8
}