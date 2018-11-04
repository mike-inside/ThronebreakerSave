; ------------------
; ThronebreakerSave.ahk
; Backup save creator for Thronebreaker - The Witcher Tales
; By mikeInside 20181104
; ------------------
; Put ThronebreakerSave.ahk in the same directory as you installed Thronebreaker, (the one containing Thronebreaker.exe)
; When you run ThronebreakerSave.ahk it will automatically open the game if it is not currently running
; By default it will temporarily rename the intro video files so that they will be skipped, you can change this setting below

; Every 60 seconds the game will check if a new save has been made, and if so make a backup of it
; The setting below controls how many backups to store, old backups above this amount will be deleted
; If you want to restore a backup hold down the [Windows Key] plus [z] to open the game's data folder
; Find the save you want to restore in the backups folder, then copy the files inside the folder into the main SaveData folder, overwriting files
; Then load the save inside Thronebreaker

; If the script checks for a new save and discovers you have exited the game, the script will exit too
; You can manually force a save game/exit game check by holding down the [Windows Key] plus [c]

; ------------------
; INITIALISATION
; ------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
OnExit("exitFunction") 

; ------------------
; SETTINGS
; ------------------
maxBackups := 100
skipIntroVideo := true

; ------------------
; SET FILE AND FOLDER LOCATIONS
; ------------------
; Save Data Location
folderData := A_AppData . "\..\LocalLow\CDProjektRED\Thronebreaker"
folderSave := folderData . "\SaveData"
folderBackup := folderData . "\SaveData Backups"

checkExist(folderData)
checkExist(folderSave)
if (!FileExist( folderBackup ))
	FileCreateDir, % folderBackup

; Game Location
folderGame := A_WorkingDir
exeName := "Thronebreaker.exe"
fileGame := folderGame . "\" . exeName

checkExist(folderGame)
checkExist(fileGame)
Menu, Tray, Icon, %fileGame%

; Intro Video Location
folderVideo := folderGame . "\Thronebreaker_Data\StreamingAssets\videos\campaign"
introVideo := folderVideo . "\nr000_cs1_game_intro"


; ------------------
; OPEN GAME (if it is not running)
; ------------------
Process, Exist, %exeName%
pidGame := ErrorLevel
if (!pidGame) {
	if (skipIntroVideo and FileExist( folderVideo )) {
		FileMove, %introVideo%, %introVideo%.bak
	}	
	Run, %fileGame%, , , pidGame
    WinWait ahk_pid %pidGame%.
}


; ------------------
; MAIN LOOP
; ------------------
; Check for an updated save game every 60 seconds
SetTimer, SaveCheck, 60000
Gosub, SaveCheck

; Pressing [Windows Key] plus [c] will manually run the subroutine to check for new saves and if the game is running
#c::
SaveCheck:

; If current save has not been backed up, make a copy
recentSave := mostRecentModification(folderSave)
if ( recentSave != mostRecentModification(folderBackup) ) {
	
	FileCopyDir, %folderSave%, % folderBackup . "\SaveData " . timeStamp( recentSave )
	
	; Count how many backups have been made
	saveTime := 0
	count := 0
	Loop, Files, %folderBackup%\*.* , D
	{
		if ( A_LoopFileTimeModified <= saveTime or saveTime = 0) {
			saveTime := A_LoopFileTimeModified
			oldestFile := A_LoopFileFullPath
		}
		count ++
	}
	; Delete oldest backup if we have too many
	if (count > maxBackups) {
		FileRemoveDir, %oldestFile% , 1
	}
}
; If game is no longer running exit script
Process, Exist, %pidGame%
pidGame := ErrorLevel
if (!pidGame) {
	ExitApp
}
return


; ------------------
; FUNCTIONS
; ------------------

checkExist(file) {
	if (!FileExist( file )) {
		MsgBox, % file . "`ndoes not exist`n`nProgram will now exit"
		ExitApp
	}
}

mostRecentModification(folder) {
	saveTime := 0
	Loop, Files, %folder%\*.* , R
	{
		If ( A_LoopFileTimeModified >= saveTime ) {
			saveTime := A_LoopFileTimeModified
		}
	}
	return saveTime
}

timeStamp( input ) {
	FormatTime, outputVar , %input% , yyyyMMdd HHmm
	return outputVar
}

exitFunction() {
	global introVideo
	FileMove, %introVideo%.bak, %introVideo%
}

; Pressing [Windows Key] plus [z] will open the data folder containing saves and backups
#z::
Run, %folderData%
return