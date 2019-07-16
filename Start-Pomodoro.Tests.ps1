$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Start-Pomodoro' {
    Context 'Properties' {

        It -Name 'has the property [ <ExpProperty> ]' -TestCases @(
            @{ ExpProperty = 'Timing' },
            @{ ExpProperty = 'Subject' },
            @{ ExpProperty = 'EndDate' },
            @{ ExpProperty = 'StartDate' }
        ) -Test {
            param ($ExpProperty)

            $NotePropertyName = (Start-Pomodoro | Get-Member -MemberType NoteProperty).Name

            $NotePropertyName | Should -Contain $ExpProperty -Because 'we expect only these properties'
        }

        It -Name 'property [ <prop> ] should be of type [ <type> ]' -TestCases @(
            @{ prop = 'Timing';    type = 'Int' }
            @{ prop = 'Subject';   type = 'String'}
            @{ prop = 'EndDate';   type = 'Datetime'}
            @{ prop = 'StartDate'; type = 'Datetime'}
        ) -Test {
            param ( $prop, $type )
            $PomodoroOutput = (Start-Pomodoro)[0]

            $PomodoroOutput.$prop | Should -BeOfType $type
        }
    }

    Context -Name 'Parameters' -Fixture {
        It -Name 'has the parameters [ <ExpectedParameter> ]' -TestCases @(
            @{ ExpectedParameter = 'EndDate' },
            @{ ExpectedParameter = 'Subjects' },
            @{ ExpectedParameter = 'ShowBlocks'}
        ) -Test {
            param ($ExpectedParameter)

            Get-Command -Name Start-Pomodoro |
                Should -HaveParameter $ExpectedParameter -Because 'we defined them to'
        }
    }

    Context "Default run" {

        BeforeAll -Scriptblock {
            Mock -CommandName Get-Date -MockWith {
                [Datetime]::new(2019, 06, 29, 13, 30, 00)
            } -Verifiable

            $Pomodoro = Start-Pomodoro
        }

        It -Name 'defaults to 90 minutes from when called' -Test {
            $ActualEndDate = ($Pomodoro | Select-Object -Property EndDate -Unique).EndDate

            $ExpectedEndDate = [Datetime]::new(2019, 06, 29, 15, 00, 00)
            
            $ActualEndDate | Should -Be $ExpectedEndDate -Because 'we want to allocate 90 minutes as a default pomodoro'
        }

        It -Name 'defaults to 6 pomodoro blocks' -Test {
            $BlockCount = $Pomodoro.Count

            $BlockCount | Should -Be 6 -Because 'we should default to 6 blocks'
        }

        It -Name 'defaults to 3 blocks of work' -Test {
            $SubjectCount = $Pomodoro.Subject | Group-Object -NoElement

            $ActualCount = $SubjectCount | Where-Object Name -eq 'Work'
                
            $ActualCount.Count | Should -Be 3 -Because 'we should default to 3 blocks of work'
        }

        It -Name 'defaults to 3 blocks of rest' -Test {
            $RestCount = $Pomodoro.Subject | Group-Object -NoElement

            $ActualCount = $RestCount | Where-Object Name -eq 'Rest'
                
            $ActualCount.Count | Should -Be 3 -Because 'we should default to 3 blocks of rest'
        }

        
    }
}
