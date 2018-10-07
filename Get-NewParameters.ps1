# Our starting command.
$c = 'Update-TypeData'

# Get all the parameters.
$AllParameters = (Get-Command -Parameter $c).Parameters

# Get the parameters that have and do not have aliases.
$IsNotAliased, $IsAliased = $AllParameters.GetEnumerator().Where({ $_.Value.Aliases.Count -eq 0}, 'SPLIT')

# For storing the aliases.
$NewAliases = [System.Collections.Generic.List[psobject]]::new()
$NewAliasValues = [System.Collections.Generic.HashSet[String]]::new()

# Add what is already there.
foreach ($alias in $IsAliased) {
    [void]$NewAliasValues.Add($alias.Value.Aliases)
    [void]$NewAliases.Add([PSCustomObject]@{ Parameter = $alias.Key; NewAlias = ($alias.Value).Aliases })
}

# Add what is NOT already there.
foreach ($param in $IsNotAliased) {
    for ($i = 1; $i -lt $param.Key.Length; $i++) {
        $Potential = $param.Key.Substring(0, $i)
        if ($Potential -notin $NewAliasValues) {
            [void]$NewAliasValues.Add($Potential)
            [void]$NewAliases.Add([PSCustomObject]@{ Parameter = $param.Key; NewAlias = $Potential })
            break
        }
        Write-Output "We're hit here for [$param] and [$i]"
    }
}

# Check what we have now.
$NewAliases
$NewAliasValues

# Clean up.
Remove-Variable NewAliases, NewAliasValues