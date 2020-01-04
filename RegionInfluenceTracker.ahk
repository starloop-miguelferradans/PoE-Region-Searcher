;Fall's PoE Region Searcher
;version 1.0.1 - 29 Dec 2019
;added custom hotkey, now you can change it in Config.ini
;demo video https://www.youtube.com/watch?v=_9x9TGSVCAA
;forked the repository and added support for automatic influence tracking by parsing PoE's client log
 
#NoEnv
SetWorkingDir %A_ScriptDir%
#WinActivateForce
#SingleInstance force
#Include %A_LineFile%\..\JSON.ahk
 
tog1:=0
Hide1:=0
WinName:="Path Of Exile's Conquerors Influence Tracker"
 
SleepTime=200
 
Array1:=[]
Array1[1]:="Glennach Cairns"
Array1[2]:="Haewark Hamlet"
Array1[3]:="Lex Ejoris"
Array1[4]:="Lex Proxima"
Array1[5]:="Lira Arthain"
Array1[6]:="New Vastir"
Array1[7]:="Tirn`'s End"
Array1[8]:="Valdo`'s Rest"
 
KeyWidth=90
KeyHeightRegionName=40
KeyHeightInfluence=10

NUM_REGIONS=8
 
;*** Create INI if not exist
ININame=%A_scriptdir%\Config.ini
ifnotexist,%ININame%
    {
    IniWrite, C:\Path of Exile\logs\Client.txt, %ININame%,ClientLog,Path
    IniWrite,F2,%ININame%,ToggleKey,KEY1
    Loop %NUM_REGIONS%
        {
        Col:=A_Index
        Name := Array1[A_Index]
        IniWrite,%Name%,%ININame%,Key%A_Index%,Name
        IniWrite,0,%ININame%,Key%A_Index%,Veritania
        IniWrite,0,%ININame%,Key%A_Index%,Drox
        IniWrite,0,%ININame%,Key%A_Index%,Baran
        IniWrite,0,%ININame%,Key%A_Index%,Al-Hezmin
        IniWrite,0,%ININame%,Key%A_Index%,Stones
        }
    }
   
;*** Load
lastRegionVisited := ""
lastRegionIndexVisited := 0
IniRead, LogPath, %ININame%, ClientLog, Path, ""

Loop %NUM_REGIONS% {
    IniRead, VeritaniaInfluence%A_Index%, %ININame%, Key%A_Index%, Veritania, 0
    }
    
Loop %NUM_REGIONS% {
    IniRead, DroxInfluence%A_Index%, %ININame%, Key%A_Index%, Drox, 0
    }
    
Loop %NUM_REGIONS% {
    IniRead, BaranInfluence%A_Index%, %ININame%, Key%A_Index%, Baran, 0
    }
    
Loop %NUM_REGIONS% {
    IniRead, HezminInfluence%A_Index%, %ININame%, Key%A_Index%, Al-Hezmin, 0
    }
 
Loop %NUM_REGIONS% {
    IniRead, LoadS%A_Index%, %ININame%, Key%A_Index%, Stones, 0
    }
	
;*** Custom hotkey
Iniread, HotkeyVariable, %ININame%, ToggleKey, KEY1
Hotkey, %HotkeyVariable%,CustomHotkeyName,On

Update_GUI()
{
    global
    ;*** GUI layout
    Gui, 4:+LastFound
    WinGetPos,posX,posY,w,h
    GUI, 4:New
    Gui, 4:+AlwaysOnTop
    Gui, 4:Font, s11
    Gui, 4:Add, Text,, Last MapRegion Visited: %lastRegionVisited%
     
    Loop %NUM_REGIONS% {
        Col:=A_Index
        If Col=1
            Gui, 4:Add, Button,vBtnId%A_Index% gKeyPressed%A_Index% w%KeyWidth% h%KeyHeightRegionName% y+10, % Array1[A_Index]
        Else
            Gui, 4:Add, Button,vBtnId%A_Index% gKeyPressed%A_Index% w%KeyWidth% h%KeyHeightRegionName% x+0 yp, % Array1[A_Index]
     
    }
     
    Loop %NUM_REGIONS% {
        influence := "None"
        
        if (VeritaniaInfluence%A_Index% > 0)
        {
            if (VeritaniaInfluence%A_Index% < 4)
            {    
                influence := StrConcat("Veritania ", VeritaniaInfluence%A_Index%)
                influence := StrConcat(influence, "/3")
            }
            else
            {
                influence := "Veritania Done"
            }
        }
        
        if (DroxInfluence%A_Index% > 0)
        {
            if (DroxInfluence%A_Index% < 4)
            {  
                influence := StrConcat("Drox ", DroxInfluence%A_Index%)
                influence := StrConcat(influence, "/3")
            }
            else
            {
                influence := "Drox Done"
            }
        }
        
        if (BaranInfluence%A_Index% > 0)
        {
            if (BaranInfluence%A_Index% < 4)
            {  
                influence := StrConcat("Baran ", BaranInfluence%A_Index%)
                influence := StrConcat(influence, "/3")
            }
            else
            {
                influence := "Baran Done"
            }
        }
        
        if (HezminInfluence%A_Index% > 0)
        {
            if (HezminInfluence%A_Index% < 4)
            {  
                influence := StrConcat("Hezmin ", HezminInfluence%A_Index%)
                influence := StrConcat(influence, "/3")
            }
            else
            {
                influence := "Hezmin Done"
            }
        }

        Col:=A_Index
        If Col=1
            Gui, 4:Add, Text, r2 w%KeyWidth% h%KeyHeightInfluence% xm y+5, %influence%
        Else
            Gui, 4:Add, Text, r2 w%KeyWidth% h%KeyHeightInfluence% x+0 yp, %influence%
    }
     
    Loop %NUM_REGIONS% {
        Col:=A_Index
        If Col=1
            Gui, 4:Add, DropDownList, r5 gStoneAction%A_Index% vSelectedItem%A_Index% w%KeyWidth% h%KeyHeightInfluence% xm y+5,0 Stones|1 Stone|2 Stones|3 Stones|4 Stones
        Else
            Gui, 4:Add, DropDownList, r5 gStoneAction%A_Index% vSelectedItem%A_Index% w%KeyWidth% h%KeyHeightInfluence% x+0 yp,0 Stones|1 Stone|2 Stones|3 Stones|4 Stones
    }
     
    Gui, 4:Show, AutoSize x%posX% y%posY%, %WinName%
    
    If (Hide1)=1 {
        Gui, 4:Hide
    } Else {
        Gui, 4:Show
    }
}

Update_GUI()

json_file = %A_ScriptDir%\maps.txt

filehandle := FileOpen(LogPath, "r")
if !IsObject(filehandle) {
	MsgBox Error while opening Path of Exile's Client.txt.
}
filehandle.seek(0, 2)

mapshandle := FileOpen(json_file, "r")
if !IsObject(mapshandle) {
	MsgBox Error while opening maps json file.
}
data := JSON.Load(mapshandle.Read())

SetTimer, read_poe_log, 500

Return

read_poe_log:
    loop {
        line := filehandle.ReadLine()
		StringReplace, line, line, `r,, All
		StringReplace, line, line, `n,, All
		
        if line {
			if InStr(line, "You have entered") {
				line_parts := StrSplit(line, A_Space)
				map := line_parts[12]
				
				if !InStr(map, ".")
				{
					mapLastPart := StrReplace(line_parts[13], ".", "")
					map := StrConcat(map, " ")
					map := StrConcat(map, mapLastPart)
				}
				else
				{
					map := StrReplace(map, ".", "")
				}
				
				mapRegion := GetRegion(data, map)
				
				if (mapRegion and mapRegion != lastRegionVisited)
				{
					lastRegionVisited := mapRegion
                    lastRegionIndexVisited := GetRegionIndex(Array1, lastRegionVisited)
                    Update_GUI()
				}
			}
            
            if (lastRegionVisited)
            {
                key := StrConcat("Key", lastRegionIndexVisited)
            
                if InStr(line, "Veritania, the Redeemer") and VeritaniaInfluence%lastRegionIndexVisited% < 4
                {
                    VeritaniaInfluence%lastRegionIndexVisited% := VeritaniaInfluence%lastRegionIndexVisited% + 1     
                    UpdateINI(VeritaniaInfluence%lastRegionIndexVisited%, ININame, key, "Veritania")
                    Update_GUI()
                }
                
                if InStr(line, "Drox, the Warlord") and DroxInfluence%lastRegionIndexVisited% < 4
                {
                    DroxInfluence%lastRegionIndexVisited% := DroxInfluence%lastRegionIndexVisited% + 1  
                    UpdateINI(DroxInfluence%lastRegionIndexVisited%, ININame, key, "Drox")      
                    Update_GUI()                
                }
                
                if InStr(line, "Baran, the Crusader") and BaranInfluence%lastRegionIndexVisited% < 4
                {
                    BaranInfluence%lastRegionIndexVisited% := BaranInfluence%lastRegionIndexVisited% + 1     
                    UpdateINI(BaranInfluence%lastRegionIndexVisited%, ININame, key, "Baran")      
                    Update_GUI()
                }
                
                if InStr(line, "Al-Hezmin, the Hunter") and HezminInfluence%lastRegionIndexVisited% < 4
                {
                    HezminInfluence%lastRegionIndexVisited% := HezminInfluence%lastRegionIndexVisited% + 1               
                    UpdateINI(HezminInfluence%lastRegionIndexVisited%, ININame, key, "Al-Hezmin")      
                    Update_GUI()
                }
                
                ResetIfCompleted()
            }
            
        } else break
    }
    
    ResetIfCompleted()
    {
        global
        conquerorsDone := 0
        loop %NUM_REGIONS%
        {
            if (VeritaniaInfluence%A_Index% == 4 or DroxInfluence%A_Index% == 4 or BaranInfluence%A_Index% == 4 or HezminInfluence%A_Index% == 4)
            {
                conquerorsDone := conquerorsDone + 1
            }
        }
        
        if (conquerorsDone == 4)
        {
            loop %NUM_REGIONS%
            {
                lastRegionVisited := false
                VeritaniaInfluence%A_Index% := 0
                DroxInfluence%A_Index% := 0
                BaranInfluence%A_Index% := 0
                HezminInfluence%A_Index% := 0
                UpdateINI(VeritaniaInfluence%A_Index%, ININame, key, "Veritania")
                UpdateINI(DroxInfluence%A_Index%, ININame, key, "Drox")
                UpdateINI(BaranInfluence%A_Index%, ININame, key, "Baran")
                UpdateINI(HezminInfluence%A_Index%, ININame, key, "Al-Hezmin")
            }
            
            Update_GUI()
        }
    }
return
 
;*** Move with -Caption on
;https://autohotkey.com/board/topic/67766-moving-gui-with-caption/
OnMessage(0x0201, "WM_LBUTTONDOWN")
 
WM_LBUTTONDOWN()
{
   If (A_Gui)
      PostMessage, 0xA1, 2
; 0xA1: WM_NCLBUTTONDOWN, refer to http://msdn.microsoft.com/en-us/library/ms645620%28v=vs.85%29.aspx
; 2: HTCAPTION (in a title bar), refer to http://msdn.microsoft.com/en-us/library/ms645618%28v=vs.85%29.aspx
}
 
;*** Load
Loop %NUM_REGIONS% {
    if (LoadInf%A_Index%)
       GuiControl, 4:Choose, SelectedInfluence%A_Index%, % LoadInf%A_Index%
       Gui, 4:Show
}
 
Loop %NUM_REGIONS% {
    if (LoadS%A_Index%)
       GuiControl, 4:ChooseString, SelectedItem%A_Index%, % LoadS%A_Index%
       Gui, 4:Show
}
Return ;prevents script auto KeyPressed1 searching when you open it
 
;*** Search
KeyPressed1:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[1]
        }
Return
 
KeyPressed2:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[2]
        }
Return
 
KeyPressed3:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[3]
        }
Return
 
KeyPressed4:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[4]
        }
Return
 
KeyPressed5:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[5]
        }
Return
 
KeyPressed6:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[6]
        }
Return
 
KeyPressed7:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[7]
        }
Return
 
KeyPressed8:
    if WinExist("Path of Exile") {
        WinActivate
        }
    if WinActive("Path of Exile") {
        Sleep, SleepTime
        Send ^f
        Send ^a
        SendInput % Array1[8]
        }
Return
 
;***Stone
StoneAction1:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem1%, %ININame%, Key1, Stones
Return
 
StoneAction2:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem2%, %ININame%, Key2, Stones
Return
 
StoneAction3:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem3%, %ININame%, Key3, Stones
Return
 
StoneAction4:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem4%, %ININame%, Key4, Stones
Return
 
StoneAction5:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem5%, %ININame%, Key5, Stones
Return
 
StoneAction6:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem6%, %ININame%, Key6, Stones
Return
 
StoneAction7:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem7%, %ININame%, Key7, Stones
Return
 
StoneAction8:
 Gui, Submit, NoHide
 IniWrite, %SelectedItem8%, %ININame%, Key8, Stones
Return
 
;*** Toggle GUI on button press
CustomHotkeyName:
    Hide1:=!Hide1
    If (Hide1)=1 {
        Gui, 4:Hide
    } Else {
        Gui, 4:Show
        }
Return

UpdateINI(value, file, sect, key)
{
    IniWrite, %value%, %file%, %sect%, %key%
}

StrConcat(a, b)
{
	Return, a b
}

GetRegion(data, map)
{
	for index, mapRegion in data.Regions
	{
		for regionIndex, mapName in mapRegion.maps
		{
			If (map == mapName)
			{
				return mapRegion.name
			}
		}
	}
	
	return false
}

GetRegionIndex(array1, lastRegionVisited)
{
	for index, mapRegion in array1
	{
        If InStr(lastRegionVisited, mapRegion, false)
        {
            return index
        }
	}
	
	return 0
}