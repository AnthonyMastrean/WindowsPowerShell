function Print-GitStatus {
  $real_last_exit_code = $LASTEXITCODE
  $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
  Write-VcsStatus
  $global:LASTEXITCODE = $real_last_exit_code
}
