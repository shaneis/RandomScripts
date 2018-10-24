#requires -Modules dbatools

function Invoke-SQLUndercoverCollection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [Alias('SqlInstance', 'ServerName', 'Server')]
        [String]$CentralServer,

        [Parameter(Mandatory, Position = 1, ValueFromPipelineByPropertyName)]
        [Alias('Database', 'DatabaseName')]
        [String]$LoggingDb
    )
    
    begin {
        
        Write-Verbose "[BEGIN  ] Initialising default values and parameters..."
        [int]$Pos = 0
        $InvalidServers = New-Object -TypeName System.Collections.Generic.List[int]
        $ActiveServers = New-Object -TypeName System.Collections.Generic.List[string]
        $Builds = New-Object -TypeName System.Collections.Generic.List[psobject]
        [string]$ModuleConfig

        Write-Verbose "[BEGIN  ] [$CentralServer] - Checking central server connectivity."
        $CentralConnection = Get-DbaDatabase -SqlInstance $CentralServer -Database $LoggingDb -ErrorAction Stop -WarningAction Stop
        Write-Verbose "[BEGIN  ] [$CentralServer] - Central server connectivity ok."

        Write-Verbose "[BEGIN  ] Checking for the existance of the database: ${LoggingDb}."
        if (-not $CentralConnection.Name) {
            Write-Warning "[$CentralServer] - Logging database specified does not exist."
            break
        }

        Write-Verbose "[BEGIN  ] Getting a list of active servers from the Inspector Currentservers table..."
        $ActiveServersQry = "EXEC [$LoggingDb].[Inspector].[PSGetServers];"
        $ActiveServers = $CentralConnection.Query($ActiveServersQry)
    }
    
    process {
        $ActiveServers.Servername |
            ForEach-Object -Begin {
                Write-Verbose '[PROCESS] Setting $InspectorBuildQry variable.'
                $InspectorBuildQry = "EXEC [$LoggingDb].[Inspector].[PSGetInspectorBuild];"
            } -Process {
                Write-Verbose "[PROCESS] [$($_)] - Getting Inspector build info..."
                $Connection = Get-DbaDatabase -SqlInstance $_ -Database $LoggingDb -ErrorAction Stop -WarningAction Stop
                
                if (-not $Connection.Name) {
                    Write-Warning "[PROCESS] [$($_)] - Logging database [$LoggingDb] does not exist."
                    $InvalidServers.Add($Pos)
                    $Pos++
                    break
                }

                Write-Verbose "[PROCESS] Adding build for $Connection and $($Connection.Name)."
                $Builds.Add($Connection.Query($InspectorBuildQry))
                $Pos++
            }

        Write-Verbose "[PROCESS] Removing invalid servers from ActiveServers array..."
        $InvalidServers.Servername |
            ForEach-Object -Process {
                Write-Warning "[Validation] - Removing Invalid Server [$_] from the Active Server list."
                $ActiveServers.Remove($_)
            }

        Write-Verbose "[PROCESS] Checking minimum build and build comparison..."
        $BuildVersions = $Builds | Measure-Object -Property Build -Maximum -Minimum
        if ($BuildVersions.Minimum -lt 1.2) {
            Write-Warning "[Validation] - Inspector builds do not match."
            $Builds | Where-Object Build -lt 1.2 | Format-Table -Property Servername, Build
            break
        }
        Write-Verbose "[PROCESS] [Validation] - Minimum build check ok."

        Write-Verbose "[PROCESS] Comparing minimum build and maximum build..."
        if ($BuildVersions.Minimum -ne $BuildVersions.Maximum) {
            Write-Warning "[Validation] - Inspector builds do not match."
            $Builds | Format-Table -Property Servername, Build
            break
        }
        Write-Verbose "[PROCESS] [Validation] - Active Server Inspector builds match."
    }
    
    end {
    }
}