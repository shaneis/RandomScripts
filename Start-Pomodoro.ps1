function Start-Pomodoro {
    [CmdletBinding()]
    param()

    process {
        for([Int]$i = 0; $i -lt 10; $i++) {
            $Timing = switch ($i) {
                {($_ % 8) -eq 0 -and $_ -ne 0} {10; break}
                {($_ % 2) -eq 0 -and $_ -ne 0} {5; break}
                default {25}
            }

            [PSCustomObject]@{
                Timing = $Timing
                Subject = $null
            }
        }
    }
}

