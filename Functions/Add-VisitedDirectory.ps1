$here  = Split-Path $MyInvocation.MyCommand.Path
$esent = Join-Path $here 'ManagedEsent.1.6\lib\net20'
$store = Join-Path $here 'VisitedDirectories'

[System.Reflection.Assembly]::LoadFrom("$esent\Esent.Interop.dll")     | Out-Null
[System.Reflection.Assembly]::LoadFrom("$esent\Esent.Collections.dll") | Out-Null

$map = New-Object "Microsoft.Isam.Esent.Collections.Generic.PersistentDictionary[string,int]" $store

function Add-VisitedDirectory {
    param(
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ -pathType Container })]
        [string] $path = $pwd
    )

	$path = Resolve-Path $path

    if(-not($map.ContainsKey($path))) {
        $map.Add($path, 0)
    }
    
    $map[$path] += 1
}

function Remove-VisitedDirectory {
    param(
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ -pathType Container })]
        [string] $path = $pwd
    )

	$path = Resolve-Path $path

    if($map.ContainsKey($path)) {
        $map.Remove($path)
    }
}

function Limit-VisitedDirectories {
    $map.Keys | %{
        $map[$_] = $map[$_] / 2
        
        if($map[$_] -eq 0) {
            $map.Remove($_)
        }
    }
}
