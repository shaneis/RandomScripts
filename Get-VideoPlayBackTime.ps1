function Get-VideoPlayBackTime {
    <#
    .SYNOPSIS
        Returns the new playback time based on new playback speed.

    .DESCRIPTION
        This script calculates the time that a video will finish based on the original time of the video and
        the new playback speed.

    .EXAMPLE
        PS C:\> Get-VideoPlayBackTime -Seconds 0

        Minutes Seconds SpeedUp NewFinish
        ------- ------- ------- ---------
              0       0     1.5  00:00:00

        Works if a time of 0 seconds is passed in.

    .EXAMPLE
        PS C:\> Get-VideoPlayBackTime -Minutes 60 -Seconds 0 -SpeedUp 2

        Minutes Seconds SpeedUp NewFinish
        ------- ------- ------- ---------
             60       0       2  00:30:00


        If the video is sped up to 2x the speed, a video of 60 minutes will finish in 30 minutes.
        
    .EXAMPLE
        PS C:\> video 44 1

        Minutes Seconds SpeedUp NewFinish
        ------- ------- ------- ---------
             44       1     1.5  00:29:21

        Showing shortcut using alias, positional parameters, and default values.
        
    .INPUTS
        [Int]
        [Double]

    .OUTPUTS
        [PSCustomObject]

    .NOTES
        None.
    #>
    [Alias('video')]
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param (
        # Minutes of the video only
        [Parameter(Position = 0)]
        [int]$Minutes = 0,

        # Seconds of the video left over after minutes
        [Parameter(Mandatory,
            Position = 1)]
        [int]$Seconds,

        # Speed up value for the video defaulting to 1.5
        [Parameter(Position = 3)]
        [ValidateSet('0.25', '0.5', '0.75', '1', '1.25', '1.5', '2')]
        [double]$SpeedUp = 1.5
    )

    begin {}

    process {
        [PSCustomObject]@{
            Minutes   = $Minutes
            Seconds   = $Seconds
            SpeedUp   = $SpeedUp
            NewFinish = New-TimeSpan -Seconds ((New-TimeSpan -Minutes $Minutes -Seconds $Seconds).TotalSeconds / $SpeedUp)
        }
    }

    end {}
}
