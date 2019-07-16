function Start-Pomodoro {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [datetime]
        $EndDate = (Get-Date).AddMinutes(90),

        [Parameter(ValueFromPipeline,
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Subjects,

        [Parameter(Position = 2)]
        [Switch]
        $ShowBlocks
    )

    begin {
        <#
            foreach subject,
                We create a "run" hash table,
                output the start/end values.
                and then run everything in the end block.
        #>
        $StartDate = Get-Date

        <#
            We have 30 minute blocks and each block contains a subject and a rest.
            So each block is essentially 2.
        #>
        $TotalBlocks = (($EndDate - $StartDate).TotalMinutes / 30) * 2

        [PSCustomObject]$DetailsTable = 1..$TotalBlocks |
            ForEach-Object -Begin {
                Write-Verbose -Message "[$((Get-Date).TimeOfDay)][$($MyInvocation.MyCommand)] Populating details table"
            } -Process {
                if (($_ % 2) -ne 0) {
                    @{Work = 25}
                } else {
                    @{Rest = 5}
                }
            } -End {
                Write-Verbose -Message "[$((Get-Date).TimeOfDay)][$($MyInvocation.MyCommand)] Populated details table"
            }
    }

    process {
        foreach ($Action in $DetailsTable) {
            [PSCustomObject]@{
                Timing = $Action.Values
                Subject = $Action.Keys -as [String]
                StartDate = $StartDate
                EndDate = $EndDate
            }
        }
    }

    end {
        
    }
}
