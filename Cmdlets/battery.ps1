function Show-BatteryStatus {
    <#
        Displays:
            ⚡100% [++++]
            ⚡ 75% [+++ ]
            ⚡ 50% [++  ]
            ⚡ 25% [+   ]
            ⚡  0% [    ]
    #>

    $batterySymbol = [char]::ConvertFromUtf32(0x26A1)

    $battery = Get-WmiObject -ClassName Win32_Battery # estimated charge 0..100
    $chunk = [System.Math]::Ceiling($battery.EstimatedChargeRemaining / 25) # fit between 0..4

    $display += "{0} {1,3}% [{2}{3}]" -f $batterySymbol, $battery.EstimatedChargeRemaining, ('+' * $chunk), (' ' * (4 - $chunk))

    $display
}
