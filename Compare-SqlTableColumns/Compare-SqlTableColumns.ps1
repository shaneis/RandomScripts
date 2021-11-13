function Compare-SqlTableColumns {
	<#
	.SYNOPSIS
		Compares column names and column order of specified tables.
	.DESCRIPTION
		Compares two tables for differences in column names and column
		order between specified databases, or SQL instances.
	.EXAMPLE
		PS C:\> Compare-SqlTableColumns -ReferenceSqlInstance SQL01 -Table1 'dbo.DifferenceTable01' -Table2 'dbo.DifferenceTable02' -SqlCredential $SqlCred

		TableName       : DifferenceTable01
		ColumnName      : col1
		ComparisonTable : DifferenceTable02
		Columns         : {col1, $null}
		ColumnOrder     : {1, $null}
		Status          : present in DifferenceTable01 only

		TableName       : DifferenceTable01
		ColumnName      : col2
		ComparisonTable : DifferenceTable02
		Columns         : {col2, Col2}
		ColumnOrder     : {2, 2}
		Status          : case-sensitive mismatch

		TableName       : DifferenceTable01
		ColumnName      : col7
		ComparisonTable : DifferenceTable02
		Columns         : {col7, COL7}
		ColumnOrder     : {3, 6}
		Status          : {case-sensitive mismatch, different order in the tables}

		TableName       : DifferenceTable01
		ColumnName      : col4
		ComparisonTable : DifferenceTable02
		Columns         : {col4, col4}
		ColumnOrder     : {4, 4}
		Status          : present in both tables
	.INPUTS
		Inputs (if any)
	.OUTPUTS
		Output (if any)
	.NOTES
		General notes
	#>
	[CmdletBinding()]
	param (
		# SQL Instance to connect to.
		[Parameter(
			Mandatory,
			Position = 0,
			ValueFromPipelineByPropertyName
		)]	
		[Alias('SqlServer')]
		[string] $SqlInstance,

		# The first table to compare.
		[Parameter(
			Mandatory,
			Position = 1,
			ValueFromPipelineByPropertyName
		)]
		[string] $Table1,

		# The second table to compare.
		[Parameter(
			Mandatory,
			Position = 2,
			ValueFromPipelineByPropertyName
		)]
		[string] $Table2,

		# SQL Credentials to connect to the SQL instance.
		[Parameter(
			ValueFromPipelineByPropertyName
		)]
		[PSCredential] $SqlCredential
	)
	
	begin {
		Write-Verbose ('[{0}]: Starting function [{1}]' -f [datetime]::Now, $MyInvocation.MyCommand)

		$StopWatch = [Diagnostics.StopWatch]::StartNew()

		$ColumnDetailQuery = @'
SELECT	table_name = OBJECT_NAME(c.[object_id]),
	column_name = c.[name],
	c.column_id
FROM	[sys].[columns] AS c
WHERE	c.[object_id] = OBJECT_ID(@table_name, N'U');
'@	
	}
	
	process {
		Write-Verbose ('[{0}]: Gathering table column data' -f $StopWatch.Elapsed)
		
		$TableParams = @{
			SqlInstance = $SqlInstance
			Query = $ColumnDetailQuery
			Database = 'master'
			As = 'PSObject'
		}

		if ($PSBoundParameters.ContainsKey('SQLCredential')) {$TableParams['SQLCredential'] = $SqlCredential}

		Write-Verbose ('[{0}]: Querying [{1}] data' -f $StopWatch.Elapsed, $Table1)
		try {
		$FirstTable = Invoke-DbaQuery @TableParams -SqlParameter @{table_name = $Table1}
		} catch {
			Write-Warning -Message "Cannot query SQL instance [$SqlInstance].[master].[$Table1]"
		}

		Write-Verbose ('[{0}]: Querying [{1}] data' -f $StopWatch.Elapsed, $Table2)
		try {
		$SecondTable = Invoke-DbaQuery @TableParams -SqlParameter @{table_name = $Table2}
		} catch {
			Write-Warning -Message "Cannot query SQL instance [$SqlInstance].[master].[$Table2]"
		}

		$Seen = [Collections.Generic.Hashset[string]]::new()
		
		foreach ($ColumnDetail in $FirstTable, $SecondTable) {
			Write-Verbose ('[{0}]: Comparing table [{1}]' -f $StopWatch.Elapsed, $ColumnDetail[0].table_name)
			foreach ($Column in $ColumnDetail) {
				# Skip columns already seen.
				if ($Seen.Contains($Column.column_name.ToUpper())) {
					Write-Verbose ('[{0}]: Skipping previously seen column [{1}]' -f $StopWatch.Elapsed, $Column.column_name)
					continue
				}
				$null = $Seen.Add($Column.column_name.ToUpper())

				Write-Verbose ('[{0}]: Comparing column [{1}] in table [{2}]' -f $StopWatch.Elapsed, $Column.column_name, $Column.table_name)

				$ComparisonTable = if ($Column.table_name -eq $FirstTable[0].table_name) {
					$SecondTable
				} else {
					$FirstTable
				}

				$ComparisonColumn = if ($ComparisonTable[0].table_name -eq $FirstTable[0].table_name) {
					$FirstTable.Where{$_.column_name -eq $Column.column_name}
				} else {
					$SecondTable.Where{$_.column_name -eq $Column.column_name}
				}

				$CaseSensitiveMismatch = ($ComparisonColumn -and $ComparisonColumn.column_name -cnotmatch $Column.column_name)

				$DifferentColumnOrder = ($ComparisonColumn -and $Column.column_id -ne $ComparisonColumn.column_id)

				$Status = switch ($true) {
					$CaseSensitiveMismatch {'case-sensitive mismatch'}
					$DifferentColumnOrder {'different order in the tables'}
					default {
						if (-not $ComparisonColumn) {
							"present in $($Column[0].table_name) only"
						} else {
							'present in both tables'
						}
					}
				}

				[PSCustomObject] @{
					TableName = $Column.table_name
					ColumnName = $Column.column_name
					ComparisonTable = $ComparisonTable[0].table_name
					Columns = $Column.column_name, $ComparisonColumn.column_name
					ColumnOrder = $Column.column_id, $ComparisonColumn.column_id
					Status = $Status
				}

				Remove-Variable -ErrorAction Ignore -Name ComparisonTable,
					ComparisonColumn,
					Status,
					CaseSensitiveMismatch,
					DifferentColumnOrder,
					NotPresentInSecondTable
			}
		}
	}
	
	end {
		$StopWatch.Stop()
		Write-Verbose ('[{0}]: Ending function [{1}]' -f [datetime]::Now, $MyInvocation.MyCommand)
	}
}
