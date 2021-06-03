function ConvertTo-SQLStatement {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            Position = 0
        )]
        $Data
    )
    
    begin {
        $sqlStmt = [Text.StringBuilder]::new()
        $null = $sqlStmt.AppendLine('SELECT')

        [bool] $needsHeader = $true
        [bool] $needsStartingComma = $false
    }
    
    process {
        $headers = ($data | Get-Member -MemberType NoteProperty, Property).Name

        if ($needsHeader) {
            foreach ($header in $headers) {
              <# 
                Why the PadLeft and weird 5-2*bool variable? Formatting.
                Why the (Option1, Option2)[bool variable]? Chooses an option based on bool.
              #>
                $headerLine = ''.PadLeft(5 - (2 * $needsStartingComma)) + ('', ', ')[$needsStartingComma] + "[$($header)]"
                $null = $sqlStmt.AppendLine($headerLine)

                $needsStartingComma = $true
            }

            $needsStartingComma = $false
            $null = $sqlStmt.AppendLine('FROM (VALUES')

            $needsHeader = $false
        }

        foreach ($dataRow in $data) {
            $rowInsert = [Text.StringBuilder]::new()
            
            $startBracket = ''.PadLeft(5 - (2 * $needsStartingComma)) + ('', ', ')[$needsStartingComma] + '('
            $null = $rowInsert.Append($startBracket)

            [bool] $needsRowComma = $false

            foreach ($column in $headers) {
                Write-Verbose "Row: $dataRow - Column: $column - Value $($dataRow.$column)"

                $rowLine = ('', ', ')[$needsRowComma] + "'$($dataRow.$column)'"
                $null = $rowInsert.Append($rowLine)

                $needsRowComma = $true
            }

            $null = $rowInsert.Append(')')
            
            $null = $sqlStmt.AppendLine($rowInsert.ToString())

            $needsStartingComma = $true
        }

        $null = $sqlStmt.AppendLine(") X ([$($headers -join '], [')])")
    }
    
    end {
        $sqlStmt.ToString()    
    }
}
