function Initialize-Choice {
    [Alias("Initialize-Choice_v2", "InitializeChoice", "Init-Choice", "InitChoice", "Choice", "Make-Choice")]
    [CmdletBinding()]
    param (
        # title of the choice
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [string] $Title = "Make a choice",

        # caption for the choice
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 1
        )]
        [string] $Caption = "Choose an option:",

        # choices
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 2
        )]
        [ValidateCount(1, 9)] # Limit to 10 choices
        [string[]] $Choices = @("Yes", "No", "Cancel"),

        # default choice index
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 3
        )]
        [int] $DefaultChoiceIndex = ($Choices.Length), # Yeah, we +1 the indexes :(

        # exclude cancel option
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 4
        )]
        [switch] $ExcludeCancel
    )

    begin {
        $funcName = $MyInvocation.MyCommand.Name
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        Write-Verbose "[$([datetime]::UtcNow)][$funcName][$($sw.Elapsed)]: Starting function: $funcName"

        $chosenChoices = @()
        for ($i = 0; $i -lt $Choices.Count; $i++ ) {
            $thisChoice = $Choices[$i]

            Write-Verbose "[$([datetime]::UtcNow)][$funcName][$($sw.Elapsed)]: parsing choice: $thisChoice"
            if ($thisChoice -match '^&(?=\d*?)') { # Already has an ampersand and a number, assuming shortcut choice
                $escapedChoice = $thisChoice
            } elseif ($thisChoice -match '&') { # Has an ampersand but not at the start
                $escapedChoice = $thisChoice -replace '&', "[AND]"
                $escapedChoice = "&$($i+1) - $escapedChoice"
            } else {
                $escapedChoice = "&$($i+1) - $thisChoice"
            }

            Write-Verbose "[$([datetime]::UtcNow)][$funcName][$($sw.Elapsed)]: adding choice: $escapedChoice"
            $chosenChoices += [System.Management.Automation.Host.ChoiceDescription]::new($escapedChoice)
        }

        if (-not $ExcludeCancel) {
            Write-Verbose "[$([datetime]::UtcNow)][$funcName][$($sw.Elapsed)]: adding cancel choice"
            $cancelIndex = $Choices.Length+1
            $chosenChoices += [System.Management.Automation.Host.ChoiceDescription]::new("&$cancelIndex - Cancel")
        }
    }

    process {
        if ($PSBoundParameters.ContainsKey('DefaultChoiceIndex')) {
            $Host.UI.PromptForChoice(
                $Title,
                $Caption,
                $chosenChoices,
                $DefaultChoiceIndex
            )
        } else {
            $Host.UI.PromptForChoice(
                $Title,
                $Caption,
                $chosenChoices,
                $chosenChoices.Count - 1 # Default to the last choice if not specified
            )
        }
    }

    end {
        Write-Verbose "[$([datetime]::UtcNow)][$funcName][$($sw.Elapsed)]: Ending function: $funcName"
        $sw.Stop()
    }
}