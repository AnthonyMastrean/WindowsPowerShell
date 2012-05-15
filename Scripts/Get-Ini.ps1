<#
    .SYNOPSIS
    Get a hashed set of all sections, keys, and values in an INI file.
    
    .DESCRIPTION
    Get a hashed set of all sections, keys, and values in an INI file. This 
    parser will ignore comments (lines starting with ';'). The resulting 
    hashtable is like `$hashtable[$section][$key] = $value`.
    
    .PARAMETER ini
    The INI file to parse.
    
    .EXAMPLE
    C:\PS> $ini = Get-Ini .\settings.ini
    C:\PS> $ini['mysection']['akey']
    
    Parse an INI file, settings.ini, and then print the key 'akey' from the 
    section 'mysection'.
#>
function Get-Ini {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ -Type Leaf })]
        [string] $ini
    )
    
    $hashedset = @{ }
    
    $content = Get-Content $ini
    $section = ''
    
    foreach($line in $content) {
    
        # comment
        if($line.StartsWith(';')) {
            Write-Debug $line
            continue
        }
        
        # new section
        if($line.StartsWith('[')) {
            Write-Debug $line
            
            $section = $line.Trim(@('[',']'))
            $hashedset[$section] = @{}
            
            continue
        }
        
        # key/value
        Write-Debug $line
        
        $tokens = $line.Split('=')
        $key = $tokens[0].Trim()
        $value = $tokens[1].Trim()
        
        $hashedset[$section][$key] = $value
    }
    
    $hashedset
}