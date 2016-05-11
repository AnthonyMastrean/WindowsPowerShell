function svn-stash($pattern = ".") {
    $stash = Join-Path $ENV:APPDATA (Join-Path "Subversion" "stash")
    $file = Join-Path $stash ([guid]::NewGuid())

    New-Item -Force -Type 'Directory' -Path $stash | Out-Null

    svn diff --internal-diff -- $pattern | Out-File -Force $file
    svn diff --summarize -- $pattern

    Write-Host ""
    Write-Host "Stashed to $file"

    svn revert --recursive --quiet -- $pattern
}
