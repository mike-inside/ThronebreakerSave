# ThronebreakerSave  

------------------  
ThronebreakerSave.ahk  
Backup save creator for Thronebreaker - The Witcher Tales  
By mikeInside 20181104  
------------------  
Put ThronebreakerSave.ahk in the same directory as you installed Thronebreaker, (the one containing Thronebreaker.exe)  
If you don't have AutoHotKey installed, use ThronebreakerSave.exe instead of ThronebreakerSave.ahk
When you run ThronebreakerSave it will automatically open the game if it is not currently running  
By default it will temporarily rename the intro video files so that they will be skipped

Every 60 seconds the game will check if a new save has been made, and if so make a backup of it  
By default it will store up to 100 backups, old backups above this amount will be deleted  
If you want to restore a backup hold down the [Windows Key] plus [z] while the script is running to open the game's data folder  
Find the save you want to restore in the backups folder, then copy the files inside the folder into the main SaveData folder, overwriting files  
Then load the save inside Thronebreaker  

If the script checks for a new save and discovers you have exited the game, the script will exit too  
You can manually force a save game/exit game check by holding down the [Windows Key] plus [c]  
