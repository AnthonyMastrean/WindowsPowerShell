if(Test-Path Function:Register-TabExpansion) {
  Register-TabExpansion -Name 'rake' -Type Command -Handler {
    rake -T | %{ $_ -match '(^rake)(?<task>.*)(#.*)' } | %{ $matches['task'] } | %{ $_.Trim() }
  }
}
