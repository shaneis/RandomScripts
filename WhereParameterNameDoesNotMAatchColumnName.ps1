$PatternMatch = '(?<ColumnName>\w+) = @(?<ParameterName>\w+)'

$FindStoredProcedureParameters = @{
    SqlInstance = <instance>
    Database    = <database>
    Pattern     = $PatternMatch
}

Find-DbaStoredProcedure @FindStoredProcedureParameters |
    ForEach-Object -Process {
        $ParentRow = $_

        $_ | ForEach-Object StoredProcedureTextFound | Select-String -Pattern $PatternMatch | ForEach-Object -Process {
            [PSCustomObject]@{
                ServerName    = $ParentRow.SqlInstance
                DatabaseName  = $ParentRow.Database 
                SchemaName    = $ParentRow.Schema
                ProcedureName = $ParentRow.Name
                ColumnName    = ($_.Matches.Groups | Where-Object Name -eq 'ColumnName').Value
                ParameterName = ($_.Matches.Groups | Where-Object Name -eq 'ParameterName').Value
            }
        }
    } | Where-Object { $_.ColumnName -ne $_.ParameterName }
