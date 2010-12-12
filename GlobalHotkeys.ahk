/* KEYS !

Work Keyboard                                          Home Keyboard
=============                                          =============
vkA6sc16A Browser_Back     ;(not on home kybd)
vkA7sc169 Browser_Forward  ;(not on home kybd)
vkAEsc12E ;vol down;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;vkADsc120 ;messenger;;;;
vkADsc120 ;mute;;;;;;;;;;;;;;;; COLLISIONS ;;;;;;;;;;;;vkAEsc12E ;webcam;;;;;;;
vkAFsc130 ;vol up;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;vkAFsc130 ;mute;;;;;;;;;
vkB3sc122 ;play/pause                                  vkB5sc16D Launch_Media
vkACsc132 ;web/home                                    vkACsc132 ;my home
vkAAsc165 Browser_Search                               vkAAsc165 Browser_Search
vkB4sc16C Launch_Mail                                  vkB4sc16C Launch_Mail

*/

;Kill the AppsKey menu & act like a modifier
AppsKey:: return
;if (in use appskey to launch temp hotkey mode)
   ;Run, temporary.ahk
;return

;Alt-Tab Replacements (no need to let go of AppsKey)
AppsKey & RShift:: AltTab
AppsKey & Enter::  ShiftAltTab

;Mappings for the temporary hotkeys
AppsKey & 1::  Run, temporary1.ahk
AppsKey & 2::  Run, temporary2.ahk
AppsKey & 3::  Run, temporary3.ahk
AppsKey & 4::  Run, temporary4.ahk
AppsKey & 5::  Run, temporary5.ahk
AppsKey & 6::  Run, temporary6.ahk
AppsKey & 7::  Run, temporary7.ahk
AppsKey & 8::  Run, temporary8.ahk
AppsKey & 9::  Run, temporary9.ahk
AppsKey & 0::  Run, ResaveTemporary.ahk

;Egg Timer
AppsKey & t:: Run, EggTimer.ahk

;Arrange Windows
AppsKey & w:: Run, ArrangeWindows.ahk

;Nopaste macro
Appskey & v:: Run, nopaste.ahk

;Debug (on work pc)
AppsKey & d:: Run, DebugAgain.ahk

;View All Tasks
AppsKey & a:: Run, TaskMgr-AllTasks.ahk

;Make New Task
AppsKey & n:: Run, TaskMgr-NewTask.ahk

;Make New Jira Issue
AppsKey & j:: Run, CreateJiraIssue.ahk

;PrintScreen, Crop and Save
AppsKey & c:: Run, CaptureAhkImage.ahk

;Suspend hotkeys for 10 seconds
;so user can use a key combo that is normally overridden
AppsKey & s::
Suspend
Sleep, 10000
Suspend
return

;Run an AHK from the AHKs folder
;TODO a dropdown menu that allows text input in AHK
;TODO C# autocompleter field
AppsKey & k::
if NOT IsVM()
{
   ;use Find and Run Robot, if possible
   Send, {PAUSE}
   return
}
InputBox, filename, AHK Filename, Please enter the filename of the AHK to run:

;if they forgot to add ".ahk", then add it
StringRight, fileExtension, filename, 4
if (fileExtension <> ".ahk")
   filename.=".ahk"

;if it doesn't exist, get rid of spaces and check again
if NOT FileExist(filename)
   filename:=StringReplace(filename, " ")

if NOT FileExist(filename)
   return

Run %filename%
return

AppsKey & e::
message:=prompt("Please enter your message for Melinda:")
;debug("before")
if (message=="")
   return
;debug("after")
;SendEmail("IM", message, "", "cameronbaustian+testing@gmail.com", "cameronbaustian+im@gmail.com")
SendEmail("IM", message, "", "mbaustian@nbsdefaultservices.com", "cameronbaustian+im@gmail.com")
return

;Print Screen and Save to Disk (C:\DataExchange)
^PrintScreen:: SaveScreenShot("KeyPress")
AppsKey & PrintScreen::
path=C:\My Dropbox\ahk large files\screenshots\%A_ComputerName%
SaveScreenShot("KeyPress", path)
return

;Insert Date / Time Hotstrings
:*:]0d:: ; With leading zeros and no slashes
FormatTime CurrentDateTime,, MMddyyyy
SendInput %CurrentDateTime%
return

:*:]d::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime CurrentDateTime,, ShortDate
SendInput %CurrentDateTime%
return

:*:]t::
FormatTime CurrentDateTime,, Time
SendInput %CurrentDateTime%
return

;Paste without formatting
^+v:: SendViaClipboard(Clipboard)

;Press the play/pause button in last.fm
;Play pause button on work keyboard
SC122::
Launch_Media::
SetTitleMatchMode, RegEx
WinGetTitle, titletext, ahk_class OperaWindowClass
Process, Exist, foobar2000.exe
FoobarPID := ERRORLEVEL
PowerIsStreamingInWMP:=WinExist("Windows Media Player")
if (titletext=="106.1 KISS FM - Opera" or titletext=="Mix 102.9 Stream - Opera"
      or titletext=="89.7 Power FM - Powered by ChristianNetcast.com - Opera"
      or titletext=="http://www.christiannetcast.com/listen/dynamicasx.asp?station=kvtt-fm2 - Opera"
      or InStr(titletext, "Last.fm"))
{
   ;debug("i saw a media window")
   ;Stop music
   ;WinShow, ahk_class OperaWindowClass
   ForceWinFocus(titletext, "Contains")
   ;Send, !d
   SendInput, !dhttp://www.google.com/{enter}
}
else if (PowerIsStreamingInWMP)
{
   WinClose, Windows Media Player
}
else if (FoobarPID)
{
   SetTitleMatchMode, 2
   DetectHiddenWindows, On
   WinRestore, foobar2000
   if ForceWinFocusIfExist("^foobar2000", "RegEx")
   {
      ;this will play
      Send, {ALT}pl
   }
   if ForceWinFocusIfExist("^.+foobar2000", "RegEx")
   {
      ;this will stop it
      Send, {ALT}ps
   }
}
else
{
   InputBox, bookmark, Choose Station, Choose which station you'd like to play

   if (InStr(bookmark, "Power"))
   {
      Run, http://www.christiannetcast.com/listen/dynamicasx.asp?station=897power-fm
      return
   }

   IfWinNotExist, ahk_class OperaWindowClass
   {
      operaPath:=ProgramFilesDir("\Opera\opera.exe")
      Run, %operaPath%
   }

   ;WinShow, ahk_class OperaWindowClass
   Sleep, 2000

   url=http://66.228.115.186/listen/player.asp?station=897power-fm&
   if (InStr(bookmark, "Last"))
      url=http://www.last.fm/listen/user/cameronbaustian/personal
   else if (InStr(bookmark, "Kiss"))
      url=http://www.1061kissfm.com/mediaplayer/?station=KHKS-FM&action=listenlive&channel_title=
   else if (InStr(bookmark, "Mix"))
      url=http://www.mix1029.com/mediaplayer/?station=KDMX-FM&action=listenlive&channel_title=
   ;else if (InStr(bookmark, "Wilder"))
      ;url=http://www.christiannetcast.com/listen/dynamicasx.asp?station=kvtt-fm2
   ;power
      ;url=http://66.228.115.186/listen/player.asp?station=897power-fm&

   ;debug("no media player detected... launching power fm")
   ;TODO model the other sections after this one... maybe make a function GoToURL(url, browser)
   ForceWinFocus("ahk_class (OpWindow|OperaWindowClass)", "RegEx")
   Loop
   {
      Sleep, 100
      WinGetActiveTitle, titletext
      Sleep, 100
      Send, ^{TAB}
      Sleep, 100
      WinGetActiveTitle, titletextnew
      Sleep, 100
      if (titletext == titletextnew)
         break
      Sleep, 100
      Send, ^w
      Sleep, 100
   }
   ;debug()
   Sleep, 100
   SendInput, !d
   Sleep, 100
   SendInput, %url%{ENTER}
   Sleep, 100

;http://www.1061kissfm.com/mediaplayer/?station=KHKS-FM&action=listenlive&channel_title=
;http://www.mix1029.com/mediaplayer/?station=KDMX-FM&action=listenlive&channel_title=
;http://66.228.115.186/listen/player.asp?station=897power-fm&
;http://www.christiannetcast.com/listen/dynamicasx.asp?station=kvtt-fm2
}
;WinMinimize
;WinHide
return

;Record the artist name in the log so we can remove them from the last.fm library later
AppsKey & b::
SetTitleMatchMode, 2
WinGetTitle, titletext, Last.fm
InputBox, inputtext, User, Whose account should we remove this artist from?
logPath=%A_WorkingDir%\logs
FileCreateDir, %logPath%
FileAppend, %titletext%`n%inputtext%`n`n, %logPath%\removeartist.log
return

/*
;FIXME odd... both come through as 13-045 on the VM and all keys come through as 90-045 on the parent
;SC169:: Send, ^{Alt}{vkA7sc169}
;SC16A:: Send, ^{Alt}{vkA6sc16A}
AppsKey:: Send, ^{Alt}
vk13sc045:: Send, {Ctrl Down}{Alt}{Ctrl Up}
vk5Dsc15D:: Send, {Ctrl Down}{Alt}{Ctrl Up}
vk90sc045:: Send, {Ctrl Down}{Alt}{Ctrl Up}
*/

;FIXME the code flow here is kinda crappy
;Show the current track from last.fm
AppsKey & SC122::
AppsKey & Launch_Media::
SetTitleMatchMode, RegEx
WinGetTitle, titletext, (Last.fm|Power FM)
PowerIsStreamingInWMP:=WinExist("Windows Media Player")
if (titletext=="89.7 Power FM - Powered by ChristianNetcast.com - Opera" OR PowerIsStreamingInWMP)
{
   filename=C:\DataExchange\urltempfile.txt
   playlist:=UrlDownloadToVar("http://on-air.897powerfm.com/")

   playlist:=RegExReplace(playlist, "(`r|`n)", " ")
   RegExMatch(playlist, "Now Playing.*What`'s Played Recently", outputVar)

   outputVar:=RegExReplace(outputVar, "(Now Playing|What`'s Played Recently)", "")
   outputVar:=RegExReplace(outputVar, "<.*?>", "")
   outputVar:=RegExReplace(outputVar, " +", " ")

   debug(outputVar)
   return
}
if (titletext=="")
   WinGetTitle, titletext, ahk_class QWidget
if (titletext=="")
   WinGetTitle, titletext, foobar2000
if (titletext<>"")
{
   titletext:=RegExReplace(titletext, "\[foobar2000.*$")
   titletext:=RegExReplace(titletext, " \[Indie.Rock Playlist.*?\]")
   titletext:=StringReplace(titletext, " - Last.fm - Opera")
   Debug(titletext)
}
return

AppsKey & q:: Run, temporary.ahk
AppsKey & m:: Run, RecordMacro.ahk

;TODO something that would remap or create a new set of hotkeys...
;     like a new AHK that will open up, then exit on another hotkey command
;===later note: I think I already did that (ResaveTemporary.ahk)
;     except for the exit part, maybe... but I don't think that even makes sense

;;Test to see if the Google Desktop errors are being detected
;^+d::
;titleofwin = Google Desktop Sidebar
;textofwin3 = One or more of the following gadget(s) raised an exception
;SetTitleMatchMode 1
;IfWinExist, %titleofwin%
;{
	;IfWinExist, %titleofwin%, %textofwin3%,
	;{
		;WinActivate, %titleofwin%
		;MouseClick, left, 410, 192
	;}
	;;MsgBox, Window Detected
;}
;Else
;{
	;MsgBox, Couldn't find it
;}
;return

;^#g::
;IfWinExist ahk_class _GD_Sidebar
;{
	;;this doesn't work
	;WinClose ahk_class _GD_Sidebar
	;;ahk_class _GD_Mon
	;;MsgBox Closing Google Desktop
;}
;Else
;{
	;Run "C:\Program Files\Google\Google Desktop Search\GoogleDesktop.exe" /sidebar
	;;MsgBox Google Desktop not open ... opening now
;}
;return
