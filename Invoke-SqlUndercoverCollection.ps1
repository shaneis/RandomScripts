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
        [System.Collections.Generic.List[string]]$InvalidServers
        [System.Collections.Generic.List[string]]$ActiveServers
        [System.Collections.Generic.List[psobject]]$Build
        [string]$ModuleConfig

        Write-Verbose "[BEGIN  ] [$CentralServer] - Checking central server connectivity."
        $CentralConnection = Get-DbaDatabase -SqlInstance $CentralServer -Database $LoggingDb -ErrorAction Stop -WarningAction Stop
        Write-Verbose "[BEGIN  ] [$CentralServer] - Central server connectivity ok."

        Write-Verbose "[BEGIN  ] Checking for the existance of the database: ${LoggingDb}."
        if (-not ($CentralServer.Name)) {
            Write-Warning "[$CentralServer] - Logging database specified does not exist."
            break
        }

        Write-Verbose "[BEGIN  ] Getting a list of active servers from the Inspector Currentservers table..."
        $ActiveServersQry = "EXEC [$LoggingDb].[Inspector].[PSGetServers];"
        $ActiveServers = $CentralConnection.Query($ActiveServersQry)
    }
    
    process {
        $ActiveServers |
            ForEach-Object {
                Write-Verbose "[PROCESS] [$($_.ServerName)] - Getting Inspector build info..."
                $InspectorBuildQry = "EXEC [$LoggingDb].[Inspector].[PSGetInspectorBuild];"
                $Connection = Get-DbaDatabase -SqlInstance $_.ServerName -Database $LoggingDb -ErrorAction Stop -WarningAction Stop

                if (-not ($Connection.Name)) {
                    Write-Warning "[PROCESS] [$($_.ServerName)] - Logging database [$LoggingDb] does not exist."
                }
            }
    }
    
    end {
    }
}