function Show-WifiStatus {
    <#
        Displays:
            [))))]
            [))) ]
            [))  ]
            [)   ]
            [    ]
    #>

    $wifiSymbol = [char]::ConvertFromUtf32(0x26A1)

    $interfaces = Get-NetAdapter -Physical | ? { $_.PhysicalMediaType -eq 'Native 802.11' } | ? { $_.Status -eq 'Up' }
    $chunk = [System.Math]::Ceiling($percent / 25) # 0..4

    "{0} {1,3}% [{2}{3}]" -f $wifiSymbol, $percent, (')' * $chunk), (' ' * (4 - $chunk))
}
