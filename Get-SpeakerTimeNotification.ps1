function Get-SpeakerTimeNotification {
    [CmdletBinding()]
    <#
    .SYNOPSIS
        Creates notifications after specified minutes

    .DESCRIPTION
        Uses the BurntToast module to create notifications for the user after a supplied number
        of minutes have passed. These can be sorted and a final notification can be given that
        just specifies "TIME!"

    .EXAMPLE
        PS C:\> Get-SpeakerTimeNotification -CountdownMinutes 30, 15, 10, 5

        Creates a notification after 30 minutes, 15 minutes, 10 minutes, 5 minutes.
        
    .EXAMPLE
        PS C:\> Get-SpeakerTimeNotification 1, 2 -Sort

        Sorts the minutes first so the notification appears after 2 minutes then 1 minute.

    .EXAMPLE
        PS C:\> Get-SpeakerTimeNotification 1, 2 -Sort -Verbose -FinalNotification

        Sorts the minutes first so the notification appears after 2 minutes then 1 minute.
        Creates a final notification after an extra minute saying "TIME!".
        
    .INPUTS
        [int[]]

    .OUTPUTS
        Burnt Toast Notification

    .NOTES
        General notes
    #>
    param (
        # a list of minutes to notify the speaker when they have elapsed.
        [Parameter(Mandatory,
                    ValueFromPipelineByPropertyName,
                    Position = 0,
                    HelpMessage = 'List of minutes to notify the speaker after')]
        [int[]]$CountdownMinutes,

        # switch to see if you want the minutes sorted largest to smallest.
        [switch]$Sort,

        # switch to see if you want a final "TIME!" notification. If the "Sorted" switch is specified,
        # will use the smallest input time. Otherwise uses the last inputted time.
        [switch]$FinalNotification
    )
    
    begin {
        $stopWatch = [System.Diagnostics.Stopwatch]::new()

        if ($Sort) {
            $CountdownMinutes = $CountdownMinutes | Sort-Object -Descending
        }

        Write-Verbose "FinalNotification: $FinalNotification"
        if ($FinalNotification) {
            if ($Sort) {
                $finalTime = ($CountdownMinutes | Sort-Object -Descending)[-1]
            } else {
                $finalTime = $CountdownMinutes[-1]
            }
        }
        Write-Verbose "FinalNotification: $FinalNotification"
    }
    
    process {
        $stopWatch.Start()

        foreach ($time in $CountdownMinutes) {
            do {
                Start-Sleep -Seconds 60
                $VerboseMessage = [PSCustomObject]@{
                    MinutesElapsed = $stopWatch.Elapsed.TotalMinutes
                    TimeWaitingFor = $time
                }
                Write-Verbose $VerboseMessage
            } until ($stopWatch.Elapsed.TotalMinutes -ge $time)

            $text = "$time minutes left!"
            if ($time -eq 1) {
                $text = "$time minute left!"
            }

            New-BurntToastNotification -Text $text

            $stopWatch.Restart()
        }

        if ($finalTime) {
            Start-Sleep -Seconds ($finalTime * 60) # seconds, not minutes...
            New-BurntToastNotification -Text 'TIME!'
        }
    }
    
    end {
        $stopWatch.Stop()
    }
}
