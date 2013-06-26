function Print-GitStatus {
  $realLASTEXITCODE = $LASTEXITCODE
  
  $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor
  Write-Host $pwd -NoNewLine
  Write-VcsStatus
  
  $global:LASTEXITCODE = $realLASTEXITCODE
}
