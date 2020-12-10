#Requires -Modules PoshNotify

[CmdletBinding(DefaultParameterSetName = 'Stack')]
param (
    [datetime]
    $EndDate = (Get-Date '16:00'),

    [Parameter(ParameterSetName = 'Random')]
    [Switch]
    $Random
)

[String[]]$Item = 'JavaScript','Research','PSKoans','Blog','Python','PowerShell','C#','dbachecks','DBAFundamentals','Entity Framework','Containers','R'

$TimeHash = @{
    'Work' = 25
    'Feedly' = 5
    'Long Break' = 20
}
$Item | ForEach-Object -Process {
    $TimeHash[$_] = 20
}

$ItemStack = [System.Collections.Generic.Stack[string]]::new()
[Int]$Counter = 0
[Int]$WorkCounter = 0

while ((Get-Date) -lt ($EndDate)) {
    if ($ItemStack.Count -eq 0) {
        foreach ($todo in (Get-Random -InputObject $Item -Count $Item.Count)) {
            $ItemStack.Push($todo)
        }
    }

        $CurrentAction = switch ($Counter) {
            {$_ % 5 -eq 0} { 'Long Break'; break }
            {$_ % 3 -eq 0} {
                if ($PSBoundParameters.ContainsKey('Random') -and $Random) {
                    Get-Random -InputObject $Item
                } else {
                    $ItemStack.Pop()
                }
                break
            }
            Default {'Work'}
        }

        if ($CurrentAction -eq 'Work') {$WorkCounter++}

        [PSCustomObject]@{
            Action = $CurrentAction
            StartTime = Get-Date
            PSTypeName = 'Pomodoro'
	    Mark = if ((($WorkCounter % 2) -ne 0) -and $WorkCounter -ne 1 -and $CurrentAction -eq 'Work') { 'X' }
        }
        Send-OSNotification -Title $CurrentAction -Body "Starting : $(Get-Date) - Finishing : $((Get-Date).AddMinutes(($TimeHash[$CurrentAction])))"
        Start-Sleep -Seconds (New-TimeSpan -Minutes ($TimeHash[$CurrentAction])).TotalSeconds
        [Console]::Beep()

        [PSCustomObject]@{
            Action = ($CurrentAction = 'Feedly')
            StartTime = Get-Date
            PSTypeName = 'Pomodoro'
            Mark = $null
        }
        Send-OSNotification -Title 'Feedly' -Body "Starting : $(Get-Date) - Finishing : $((Get-Date).AddMinutes(($TimeHash[$CurrentAction])))"
        Start-Sleep -Seconds (New-TimeSpan -Minutes ($TimeHash[$CurrentAction])).TotalSeconds
        [Console]::Beep()

        $Counter++
}

