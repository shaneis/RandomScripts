function Find-JsonElementValueByPropertyName {
    <#
    .SYNOPSIS
        Returns the value from a json string for a specified full-stop delimited path.

    .DESCRIPTION
        Given a JSON object and a full-stop delimited path, the function will convert the
        JSON object to a PSObject and will use a scriptblock to generate the dynamic 
        PowerShell to select down to the specified value.
        
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        TODO: Comment based help...
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   Position = 0,
                   HelpMessage = 'Pass in the object holding the json file contents.')]
        [string] $JsonContents,
        
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   Position = 1,
                   HelpMessage = 'Enter a full-stop delimited location to the property e.g. "web.smtp.password".')]
        [string] $JsonProperty
    )
    
    begin {
        Write-Verbose 'Splitting JSON properties...'
        $propertyCollection = $JsonProperty -split '\.'
        Write-Verbose "Json Elements:`n$($propertyCollection | Out-String)"
    }
    
    process {
        Write-Verbose 'Dynamically creating string script...'
        $preScriptBlock = $propertyCollection |
            ForEach-Object -Begin {
               'ConvertFrom-Json -InputObject $JsonContents'
            } -Process {
               " |`n`tSelect-Object -ExpandProperty $_"
            }

        Write-Verbose "Pre ScriptBlock string created:`n$($preScriptBlock | Out-String)"
        Write-Verbose 'Converting to scriptblock...'
        $script = [scriptblock]::Create($preScriptBlock)
        
        Write-Verbose "Executing scriptblock:`n$($script | Out-String)"
        $script.InvokeReturnAsIs()
    }
}
