function Start-Pomodoro {
    [CmdletBinding()]
    param()

    process {
        for([Int]$i = 0; $i -lt 10; $i++) {
            $Timing = switch ($i) {
                {($_ % 8) -eq 0 -and $_ -ne 0} {
                    10
                    break
                }
                {($_ % 2) -eq 0 -and $_ -ne 0} {
                    5
                    break
                }
                default {
                    25
                }
            }

            [PSCustomObject]@{
                Timing = $Timing
                Subject = $null
            }
        }
    }
}


Describe 'Start-Pomodoro' {
    Context 'Properties' {
        BeforeEach -Scriptblock {
            $basicExecution = Start-Pomodoro
        }

        $expectedProperites = 'Timing', 'Subject'
        foreach ($expProperty in $expectedProperites) {
            It "has the expected property of [$expProperty]" {
                $notePropertyName = ($basicExecution | Get-Member -MemberType NoteProperty).Name
                $notePropertyName | Should -Contain $expProperty
            }
        }
    }

    Context 'Timings' {
        It 'has the first timing of 25' {
            $Pomodoro = Start-Pomodoro
            
            $Pomodoro[0].Timing | Should -Be 25
        }
    }
}

