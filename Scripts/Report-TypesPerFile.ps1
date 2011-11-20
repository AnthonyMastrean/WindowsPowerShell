<#
    .Synopsis
    Report the files that contain more than one public type.
    
    .Description
    Are you nuts about having only 1 public type declaration per code file? Then this function is for you! Run it at 
    the solution root to inspect all C# code files for lines containing
    
        public class
        public abstract class
        public static class
        public interface
        public enum
    
    Files with more than one such declaration will be grouped and sorted by that count. Enjoy beating your coworkers
    for violations :)
    
    .Example
    C:\PS\my-solution> Report-TypesPerFile | Format-Table -AutoSize -Wrap
    
    Count Values
    ----- ------
        4 {C:\PS\my-solution\my-project\events.cs}
        2 {C:\PS\my-solution\my-project\somehandler.cs}
        2 {C:\PS\my-solution\my-project\someclass.cs}
        
    .Example
    C:\PS\my-solution> Report-TypesPerFile | Export-CSV types-per-file.csv
#>
function Report-TypesPerFile {
    $tokens = "public class","public abstract class","public static class","public interface","public enum"
    Get-ChildItem -Recurse -Include *.cs -Exclude *.Designer.cs `
        | Select-String $tokens `
        | Group-Object Path `
        | Where-Object { $_.Count -gt 1 } `
        | Sort-Object Count -Descending `
        | Select-Object Count, Values
}