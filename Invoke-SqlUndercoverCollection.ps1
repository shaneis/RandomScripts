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
        [string[]]$requiredModules = 'dbatools'
        Write-Verbose "[BEGIN  ] Checking required module is available: ${requiredModules}."
        $reqModulesPresent = Get-Module -ListAvailable -Name $requiredModules

        if (-not ($reqModulesPresent)) {
            Write-Warning "Missing required modules: ${requiredModules}."
            Write-Warning "Please install the required modules and try again."
            Write-Verbose "[BEGIN  ] Required modules not found. Exiting..."
            break
        }
        
        Write-Verbose "[BEGIN  ] Initialising default values and parameters..."
        [int]$Pos = 0
        $InvalidServers = New-Object -TypeName System.Collections.Generic.List[int]
        $ActiveServers = New-Object -TypeName System.Collections.Generic.List[string]
        $Build = New-Object -TypeName System.Collections.Generic.List[psobject]
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
                Write-Verbose "[PROCESS] Setting `$InspectorBuildQry variable."
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
            }
    }
    
    end {
    }
}