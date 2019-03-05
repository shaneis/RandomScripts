function Invoke-Lollercoaster {
    [CmdletBinding()]
    param ()
    
    begin {
        #region Store the coaster states.
        $LollerCoasterTable = [Data.DataTable]::new('LollerCoaster')

        $LollerCoasterStage = [Data.DataColumn]::new('LollerCoasterStage', [String])
        $LollerCoasterTable.Columns.Add($LollerCoasterStage)
        $LollerCoasterTable.Rows.Add(@'
        __)
        LOL
           O
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        #region
    }
    
    process {
        for ([Int]$i = 0; $i -lt $LollerCoasterTable.Rows.Count; $i++) {
            $LollerCoasterTable.Rows[$_] |
                Select-Object -ExpandProperty LollerCoasterStage
            
            Start-Sleep -Milliseconds 150   
        }
    }
    
    end {
    }
}
