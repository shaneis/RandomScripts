function Start-IncreasingBackoff {
    <#
    .SYNOPSIS
        Starts a timespan with increasing backoff
    .DESCRIPTION
        Enter a timespan and a result will return an increasing backoff
        based on default percent for a default number of times.

        Extra parameters allow the specification of percent backoff, number of
        runs, include a sleep for the timespan, or include a sound
        notification.
    .EXAMPLE
        PS C:\> Start-IncreasingBackoff -StartingTimespan '00:05:00'

        Counter Date                TimeSpan Backoff
        ------- ----                -------- -------
              1 06/12/2020 15:50:57 00:05:00 00:00:00
              2 06/12/2020 15:56:27 00:05:30 00:00:30
              3 06/12/2020 16:02:30 00:06:03 00:00:33
              4 06/12/2020 16:09:09 00:06:39 00:00:36
              5 06/12/2020 16:16:28 00:07:19 00:00:40
              6 06/12/2020 16:24:32 00:08:03 00:00:44
              7 06/12/2020 16:33:23 00:08:51 00:00:48
              8 06/12/2020 16:43:08 00:09:45 00:00:53
              9 06/12/2020 16:53:51 00:10:43 00:00:58
             10 06/12/2020 17:05:38 00:11:47 00:01:04

        Uses the timespan of 5 minutes, increased by 10% each time, for 10 runs.
        There is no delay between runs and no sound notification is enabled.
    .EXAMPLE
        PS C:\> Start-IncreasingBackoff -StartingTimespan '00:05:00' -Counter 4

        Counter Date                TimeSpan Backoff
        ------- ----                -------- -------
              1 06/12/2020 15:52:16 00:05:00 00:00:00
              2 06/12/2020 15:57:46 00:05:30 00:00:30
              3 06/12/2020 16:03:49 00:06:03 00:00:33
              4 06/12/2020 16:10:28 00:06:39 00:00:36

        Uses the timespan of 5 minutes, increased by 10% each time, for 4 runs.
        There is no delay between runs and no sounds notification is enabled.
    .EXAMPLE
        PS C:\> Start-IncreasingBackoff -StartingTimespan '00:05:00' -Counter 4 -PercentPushback 50      

        Counter Date                TimeSpan Backoff
        ------- ----                -------- -------
              1 06/12/2020 15:53:13 00:05:00 00:00:00
              2 06/12/2020 16:00:43 00:07:30 00:02:30
              3 06/12/2020 16:11:58 00:11:15 00:03:45
              4 06/12/2020 16:28:50 00:16:52 00:05:38

        Uses the timespan of 5 minutes, increased by 50% each time, for 4 runs.
        There is no delay between runs and no sounds notification is enabled.
    .INPUTS

    .OUTPUTS
    
    .NOTES
        
    #>
    [CmdletBinding(DefaultParameterSetName = 'TimeSpan')]
    param (
        [Parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Position = 0)]
        [ValidateScript({ $PSItem -gt 1 -and $PSItem -is [int] })]
        [ValidateNotNullOrEmpty()]
        [int]$Counter = 10,

        [Parameter(ValueFromPipeline,
                   ValueFromPipelineByPropertyName,
                   Position = 1,
                   ParameterSetName = 'TimeSpan',
                   Mandatory)]
        [timespan]$StartingTimespan,

        [Parameter(ValueFromPipelineByPropertyName,
                   Position = 2)]
        [switch]$IncludeSoundNotification,

        [Parameter(ValueFromPipelineByPropertyName,
                   Position = 3)]
        [switch]$IncludeSleepDelay,

        [Parameter(ValueFromPipelineByPropertyName,
                   Position = 4)]
        [double]$PercentPushback = 10
    )
    
    begin {
        
    }
    
    process {
        if ($PSCmdlet.ParameterSetName -eq 'TimeSpan') {
            $newTimeSpan = $StartingTimespan
            $seconds = $StartingTimespan.TotalSeconds
            $oldSeconds = $seconds
	        $date = Get-Date
        }


        1..($Counter) | ForEach-Object -Process {
            try {
                if ($PSItem -ne 1) {
                    $seconds = $seconds * (1 + ($PercentPushback / 100))
                    Write-PSFMessage -Level Verbose -Message "Seconds increased: $seconds"
                    $newTimeSpan = New-TimeSpan -Seconds $seconds
                }
            }
            catch {
                Write-PSFMessage -Level Critical -Message "Cannot convert seconds [$seconds] to timespan!"
                break
            }

	        $date = $date.AddSeconds($seconds)

            [PSCustomObject]@{
                Counter = $PSItem
                Date = $date
                TimeSpan = $newTimeSpan
                Backoff = New-TimeSpan -Seconds ($seconds - $oldSeconds)
            }

            if ($IncludeSoundNotification) {
                [Console]::Beep()
            }

            if ($IncludeSleepDelay){
                Start-Sleep -Seconds $seconds
            }

            $oldSeconds = $seconds
        }

    }
    
    end {
        
    }
}
