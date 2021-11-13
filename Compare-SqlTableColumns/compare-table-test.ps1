# !/opt/microsoft/powershell/7/pwsh

#region Import functions
. $PSScriptRoot/Compare-SqlTableColumns.ps1
#endregion

$Cred = [PSCredential]::new(
	'sa',
	(ConvertTo-SecureString -String 'ThisIsAStrongPassword1!' -AsPlainText -Force)
)

(Get-DbaDbTable -SqlInstance localhost -Table 'dbo.DifferenceTable01', 'dbo.DifferenceTable02' -SqlCredential $Cred).Columns |
	Select-Object -Property Parent, Name, ID, DataType |
	Format-Table -GroupBy Parent

pause

Write-Verbose @'
Running [
	Compare-SqlTableColumns -SqlInstance localhost -Table1 'dbo.DifferenceTable01' -Table2 'dbo.DifferenceTable02' -SqlCredential $Cred
]
'@ -Verbose
Compare-SqlTableColumns -SqlInstance localhost -Table1 'dbo.DifferenceTable01' -Table2 'dbo.DifferenceTable02' -SqlCredential $Cred |
	Format-Table

pause

Write-Verbose @'
Running [
	$x = Compare-SqlTableColumns -SqlInstance localhost -Table1 'dbo.DifferenceTable01' -Table2 'dbo.DifferenceTable02' -SqlCredential $Cred
	$x | Format-Table
]
'@ -Verbose
$x = Compare-SqlTableColumns -SqlInstance localhost -Table1 'dbo.DifferenceTable01' -Table2 'dbo.DifferenceTable02' -SqlCredential $Cred -Verbose

$x | Format-Table
