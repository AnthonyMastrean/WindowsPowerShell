function Get-MnemonicName {
  $url = "https://gist.githubusercontent.com/AnthonyMastrean/3f0056d405c952b67a76/raw/9e148ff3f8b5a32e061117b0fc43d47265a475a8/wordlist.txt"
  $list = (Invoke-WebRequest $url).Content
  
  -split $list | Get-Random
}
