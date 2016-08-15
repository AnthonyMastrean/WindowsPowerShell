function svn-clean() {
    svn status `
        | ?{ $_ -match '(?<status>^\?)(?<whitespace>\s*)(?<filepath>.*)' } `
        | %{ $matches['filepath'] } `
        | Remove-Item -Recurse -Force
}
