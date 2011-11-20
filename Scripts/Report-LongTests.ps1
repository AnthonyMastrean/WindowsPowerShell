<#
    .Synopsis
    Report long running tests.
    
    .Description
    Want to blame someone for making the build go over 10 minutes? 
    Run this function on any solution directory, assuming you're 
    using MSTest (or any test runner that outputs TRX files) and 
    outputting the TestResults to the solution root. You'll get a 
    list of the latest tests that run over 10 milliseconds, sorted 
    by longest duration first. Michael Feathers says that unit tests 
    run fast (100s per second), so this is a gracious threshold!
    
    .Example
    PS\my-solution> Report-LongTests | Format-Table -AutoSize
    
    duration         testName   
    --------         --------   
    00:00:01.1465716 TestMethod3
    00:00:00.1141878 TestMethod1
    00:00:00.0171146 TestMethod2
    
    .Example
    PS\my-solution> Report-LongTests | Export-CSV long-tests.csv
#>
function Report-LongTests 
{
    param
    (
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ -Type Leaf })]
        [string] $trx,
        
        [timespan] $threshold = "00:00:00.010"
    )

    # If the $trx file is not specified, we'll find the latest one
    if(-not($trx))
    {
        if(-not(Test-Path "TestResults"))
        {
            Write-Error "Cannot find a TestResults directory here"
            return
        }
    
        $trx = Get-ChildItem "TestResults" *.trx `
            | Sort-Object LastWriteTime -Descending `
            | Select-Object -First 1
    }
    
    Write-Host "Test Results: $trx"
    
    $doc = [xml] (Get-Content $trx.FullName)
    $doc.TestRun.Results.UnitTestResult `
        | Where-Object { $_.Duration -gt $threshold } `
        | Sort-Object Duration -Descending `
        | Select-Object Duration, TestName `
}