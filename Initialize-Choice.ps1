function Initialize-Choice {
  [CmdletBinding()]
  param (
    # title of the choice
    [Parameter(
      Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 0
    )]
    [string] $Title,

    # hashtable of choices and labels
    [Parameter(
      Mandatory,
      ValueFromPipeline,
      ValueFromPipelineByPropertyName,
      Position = 1
    )]
    [Collections.Specialized.OrderedDictionary] $Choice
  )

  begin {
    [int] $i = 0
  }

  process {
    # make a list of the passed in choices
    $CS = foreach ($Ch in $Choice.GetEnumerator()) {
        [Management.Automation.Host.ChoiceDescription]::new(
          "&$i - $($Ch.Key)",
          "$($Ch.Key) - $($Ch.Value)"
        )
        $i++
    }

    # add in a "cancel" option
    $CS += [Management.Automation.Host.ChoiceDescription]::new(
      "&$i - Cancel",
      "Choose this option to cancel"
    )
  }

  end {
    $ChoicePrompt = [Management.Automation.Host.ChoiceDescription[]] ($CS)

    $Host.UI.PromptForChoice(
      "Choose an option:",
      $Title,
      $ChoicePrompt,
      $i
    )
  }
}
