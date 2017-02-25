function svn-clean() {
    svn status `
        | ?{ $_ -match '(?<status>^\?)(?<whitespace>\s+)(?<filepath>.+$)' } `
        | %{ $matches['filepath'] } `
        | Sort-Object -Descending `
        | Remove-Item -Recurse -Force
}
