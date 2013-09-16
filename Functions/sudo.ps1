function sudo {
  if ($args.Length -eq 1) {
    Start-Process $args[0] -Verb "runAs"
  }
  if ($args.Length -gt 1) {
    Start-Process $args[0] -ArgumentList $args[1..$args.Length] -Verb "runAs"
  }
}