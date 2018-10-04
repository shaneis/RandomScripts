function Get-ParameterAlias {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [Alias('Function')]
        [String[]]
        $Command
    )
    
    begin {
    }
    
    process {
        Write-Verbose -Message "[PROCESS] Checking parameter aliases for [$_]..."
        foreach ($cmd in (Get-Command -Name $Command -CmdletType Cmdlet).Name) {
            $cmdObject = Get-Command -Name $cmd
            $cmdObject.Parameters.Values |
                ForEach-Object -Process {
                    [PSCustomObject]@{
                        Command = $cmd
                        Parameterr = $_.Name
                        Alias = $_ | Select-Object -ExpandProperty Aliases
                    }
                }
        }
    }
    
    end {
    }
}
