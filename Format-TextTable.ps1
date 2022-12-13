function ConvertTo-TextTableBody {
    [CmdletBinding()]
    [Alias('wrapBody')]
    param (
        [Parameter(Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )]
        [object[]] $Header,

        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 1
        )]
        [Collections.Generic.List[psobject]] $Line,

        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 2
        )]
        [hashtable] $Length
    )
    
    process {
        foreach ($L in $Line) {
            Write-Verbose "Wrapping: [$L]"
            $IsStart = $true

            foreach ($Head in $Header) {
                $HeaderName = $Head.Name
                Write-Verbose $L
                Write-Verbose $HeaderName
                $Res = $L.$HeaderName.ToString()
                $PadDir = $Head.TypeNameOfValue -eq 'System.Int32' ? 'PadLeft' : 'PadRight'
                $PadAmount = $Length[$HeaderName]

                if ($IsStart) {
                    $ResultLine = '|'
                    $IsStart = $false
                }
                $ResultLine += ' {0} |' -f $Res.$PadDir($PadAmount, ' ')
                Write-Verbose "So far: $ResultLine"
            }
            
            $ResultLine
        }        
    }
}

function Format-TextTable {
    [CmdletBinding()]
    [Alias('fmt')]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            Position = 0
        )] 
        [psobject[]] $Object
    )
    
    begin {
        $Capture = [Collections.Generic.List[psobject]]::new()
        $PropLength = [ordered] @{}
    }
    
    process {
        foreach ($Obj in $Object) {
            Write-Verbose "Capturing [$Obj]"
            $Capture.Add($Obj)
        }
    }
    
    end {
        Write-Verbose "Parsing the headers from [$($Capture[0])]"
        $Header = $Capture[0].psobject.properties | Where-Object MemberType -eq 'NoteProperty'

        Write-Verbose "Setting initial length to property name length"
        foreach ($Head in $Header) {
            $HeaderName = $Head.Name

            $PropLength[$HeaderName] = $HeaderName.length
        }

        Write-Verbose "Enumerating collection, in case value length is greater than property name"
        foreach ($Head in $Header) {
            $HeaderName = $Head.Name

            foreach ($Cap in $Capture) {
                $NewLen = $Cap.$HeaderName.ToString().Length
                $CurrLen = $PropLength[$HeaderName]

                $PropLength[$HeaderName] = [Math]::Max($CurrLen, $NewLen)
            }
        }

        Write-Verbose "Creating break line"
        $IsStart = $true

        foreach ($Len in $PropLength.GetEnumerator()) {
            $Delim = $IsStart ? '|' : '+'
            $Dash = '-' * ($Len.Value + 2)

            $BreakLine += '{0}{1}' -f $Delim, $Dash

            $IsStart = $false
        }
        $BreakLine += '|'

        Write-Verbose "Generating Text Table"
        $TextTableBodyParams = @{
            Header = $Header
            Length = $PropLength
        }

        $IsStart = $true 
        foreach ($Head in $Header) {
            $HeaderName = $Head.Name
            if ($IsStart) {$HeaderLine += '|'}

            $HeaderLine += ' {0} |' -f $HeaderName.PadRight($PropLength[$HeaderName], ' ')

            $IsStart = $false
        }

        $BreakLine
        $HeaderLine
        $BreakLine
        ConvertTo-TextTableBody @TextTableBodyParams -Line $Capture
        $BreakLine
    }
}