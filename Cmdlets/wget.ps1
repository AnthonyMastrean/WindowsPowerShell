function Get-WebFile {
  param(
    [Parameter(Mandatory = $true)]
    [string] $Url,

    [string] $Path = (Split-Path -Leaf $Url)
  )

  $Path = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)

  $client = New-Object System.Net.WebClient
  $client.DownloadFile($Url, $Path)
}
