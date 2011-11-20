<#
    .SYNOPSIS
    Report long running tests.
    
    .DESCRIPTION
    Want to blame someone for making the build go over 10 minutes? 
    Run this function on any solution directory, assuming you're 
    using MSTest (or any test runner that outputs TRX files) and 
    outputting the TestResults to the solution root. You'll get a 
    list of the latest tests that run over 10 milliseconds, sorted 
    by longest duration first. Michael Feathers says that unit tests 
    run fast (100s per second), so this is a gracious threshold!

    .PARAMETER threshold
    The threshold to compare against each test duration to determine if
    it is a 'long' test. The default value is 10 milliseconds.
    
    .EXAMPLE
    Scripts:\Get-LongTests.ps1 | Format-Table -AutoSize

    Report long tests to the console.
    
    duration         testName   
    --------         --------   
    00:00:01.1465716 When_frobbing_the_widget
    00:00:00.1141878 After_toggling_the_foo
    00:00:00.0171146 When_managing_the_components
    
    .Example
    Scripts:\Get-LongTests.ps1 | Export-CSV long-tests.csv
    
    Export long tests to a CSV file.
#>
param([timespan] $threshold = "00:00:00.010")

if(-not(Test-Path "TestResults"))
{
    Write-Error "Cannot find a TestResults directory at $(Resolve-Path '.')"
    return
}

# TODO: Use $(Resolve-Path **\*.trx) to catch all Test Results
# even in different sub-folders (ReSharper puts test results in 
# the bin\ folder of the test project).
$trx = Get-ChildItem "TestResults" *.trx `
    | Sort-Object LastWriteTime -Descending `
    | Select-Object -First 1

"Test Results: $trx"

$doc = [xml] (Get-Content $trx.FullName)
$doc.TestRun.Results.UnitTestResult `
    | ?{ $_.Duration -gt $threshold } `
    | Sort-Object Duration -Descending `
    | Select-Object Duration, TestName `