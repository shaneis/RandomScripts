function Invoke-Lollercoaster {
    [CmdletBinding()]
    param ()
    
    begin {
        $LollerCoasterTable = [Data.DataTable]::new('LollerCoaster')
        
        $LollerCoasterStage = [Data.DataColumn]::new('LollerCoasterStage', [String])
        $LollerCoasterTable.Columns.Add($LollerCoasterStage)

        #region Store the coaster states.
        $null = $LollerCoasterTable.Rows.Add(@'
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
        $null = $LollerCoasterTable.Rows.Add(@'
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
        $null = $LollerCoasterTable.Rows.Add(@'
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
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL\
           O\)
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
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O\
            L\)       LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L\        LOL   LOL
             O\)     O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L         LOL   LOL
             O\      O   O O   O
              L\)   L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L         LOL   LOL
             O       O   O O   O
              L\    L     L     L
               O\) O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O\_)O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O__)O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L         LOL   LOL
             O       O   O O   O
              L    )L     L     L
               O _/O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L         LOL   LOL
             O      )O   O O   O
              L    /L     L     L
               O  /O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O
            L        )LOL   LOL
             O      /O   O O   O
              L    /L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O          ) 
            L        /LOL   LOL
             O      /O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL            )
           O          / 
            L        /LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O          __)
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
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O           __)
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
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O            __)
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
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O          
            L         LOL\  LOL
             O       O   O\)   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O          
            L         LOL   LOL
             O       O   O\O   O
              L     L     L\)   L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L\    L
               O   O       O\) O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O__)O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L    )L
               O   O       O _/O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O  \O
              L     L     L    )L
               O   O       O  /O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O  \O
              L     L     L    )L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O( \O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O/  O
              L     L     L()   L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L(    L
               O   O       O\) O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O__)O
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O __)
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O  __)
                LOL         LOL
                               O
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL\
                               O\)
                                L     LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O\
                                L\)   LOL
                                 O   O
                                  LOL
'@)
         $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L\    LOL
                                 O\) O
                                  LOL
'@)  
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O\_)O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L     LOL
                                 O__)O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O
                                L    )LOL
                                 O _/O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL        )
                               O      /
                                L    /LOL
                                 O   O
                                  LOL
'@)
        $null = $LollerCoasterTable.Rows.Add(@'
          
        LOL
           O         
            L         LOL   LOL
             O       O   O O   O
              L     L     L     L
               O   O       O   O
                LOL         LOL
                               O      __)
                                L     LOL
                                 O   O
                                  LOL
'@)
        #endregion

        #region current console info.
        $StartCursorPosition = $Host.UI.RawUI.CursorPosition
        #endregion
    }
    
    process {
        
       [Environment]::NewLine
        for ([Int]$i = 0; $i -lt $LollerCoasterTable.Rows.Count; $i++) {
            $Host.UI.RawUI.CursorPosition = $StartCursorPosition

            ($LollerCoasterTable.Rows[$i]).LollerCoasterStage
            
            $EndCursorPosition = $Host.UI.RawUI.CursorPosition

            switch ($i) {
               { $_ -in (21..28) } {
                  Start-Sleep -Milliseconds 100
                  $Host.UI.RawUI.SetBufferContents(
                     @{Top = $StartCursorPosition.Y; Bottom = $EndCursorPosition.Y; Right = [System.Console]::BufferWidth; Left = 0},
                     @{Character = ' '; ForegroundColor = $($Host.UI.RawUI.ForegroundColor); BackgroundColor = $($Host.UI.RawUI.BackgroundColor)}
                  )
               }
               { $_ -eq ($LollerCoasterTable.Rows.Count -1)} {
                     # Leave it in all it's glory
                     continue
                  }
               default { 
                  Start-Sleep -Milliseconds 150
                     $Host.UI.RawUI.SetBufferContents(
                        @{Top = $StartCursorPosition.Y; Bottom = $EndCursorPosition.Y; Right = [System.Console]::BufferWidth; Left = 0},
                        @{Character = ' '; ForegroundColor = $($Host.UI.RawUI.ForegroundColor); BackgroundColor = $($Host.UI.RawUI.BackgroundColor)}
                     )
                  }
            }
            
            }
    }
    
    end {
    }
}
