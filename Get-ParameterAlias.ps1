class ParameterAliasInfo {
  [System.Management.Automation.CommandInfo]$Command
  [string]$Parameter
  [string]$Alias
}

function Get-ParameterAlias {

    [CmdletBinding()]
    [OutputType([ParameterAliasInfo])]
    Param (
        [Parameter(Position = 0, ValueFromPipeline)]
        [Alias('Function')]
        [Alias('Command')]
        [String[]]
        $Name,

        [switch]
        $IncludeCommon
    )

    Begin {
      $ParametersToExclude = 
        if($IncludeCommon) {
          Write-Verbose 'Including common parameters'
        }
        else {
          Write-Verbose 'Excluding common parameters'

          'WarningVariable',
          'ErrorVariable',
          'InformationVariable',
          'PipelineVariable',
          'OutBuffer',
          'InformationAction',
          'Verbose',
          'OutVariable',
          'Debug',
          'WarningAction',
          'ErrorAction',
          'WhatIf',
          'Confirm'
        }
    }
    
    Process {
        Get-Command -Name $Name -PipelineVariable Command -Type Cmdlet,Function,Filter |
          Foreach-Object {
            if(-not $Command.Parameters) {
              Write-Verbose "$($Command.Name) has no parameters; skipping it."
              return
            }

            Write-Verbose "Processing $($Command.Name)."

            @($Command.Parameters.GetEnumerator()).Value |
              Where-Object Name -NotIn $ParametersToExclude |
              Where-Object Aliases -PipelineVariable Parameter |
              ForEach-Object {
                $Parameter.Aliases |
                  ForEach-Object {
                    [ParameterAliasInfo]@{
                      Command   = $Command
                      Parameter = $Parameter.Name
                      Alias     = $_
                    }
                  }
              }
        }
    }
}
