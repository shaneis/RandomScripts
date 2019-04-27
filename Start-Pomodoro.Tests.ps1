$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

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
