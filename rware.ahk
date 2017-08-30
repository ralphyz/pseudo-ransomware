; Permit only a single instance of this script at a time
#SingleInstance Force

; Disable warnings (error dialog boxes being shown to user)
#Warn All, Off  

; Disable the HTTP Download error message
ComObjError(false)

;========================================================
; User defined parameters
;========================================================
; Set the duration of the countdown clock
my_minutes := 5

; Set the minutes that must pass before revealing the escape message
my_SweatLimit := 1

; Set the key which must be pressed to escape
my_release_key = {F12}

; Try and use a proxy after trying without?
bUseProxy := true

; Move the mouse to draw the user's eye?
bMoveMouse := false

; The Proxy Information
; my_proxy = 

; the two messages that are displayed.
; 38 characters max (with the default wallpaper)
message1 =
(
Ransomware is the term for malware 
that prevents or limits users from 
accessing their files or even 
computers. It forces victims to pay
a ransom, usually in the form of 
Bitcoins, before they can get access
back, hence the name. It's a huge 
threat to our oranization, and must
be taken seriously.                     
)

message2 =
(
Paying a ransom does not guarantee
the decryption of data, nor does it
prevent the exfiltration of data. 
P&G's policy prohibits the payment of
any ransom. If a computer is infected,
the only course of action may be to 
have it reimaged. Proper web hygiene
and not falling for Phishing Scams 
are only way to remain safe!      
)

; URL for the background image
url = https://github.com/ralphyz/red/raw/master/shield.png
;========================================================
; end user defined parameters
;========================================================


;========================================================
; set some defaults
;========================================================
; set default gui color
Gui, Color, EEAA99

; Window always on top
Gui +AlwaysOnTop 

; Remove the borders, make it a tool window
Gui +ToolWindow 

; Remove the default margin
Gui, Margin, 0, 0

; Remove the title bar
Gui -Caption

; Make the window transparent - so the background of
; the text boxes are also transparent
WinSet, TransColor, EEAA99

; Temporary filename
file = %A_Temp%\shield.png

; Empty proxy variable
proxy = 

;========================================================
; end defaults
;========================================================

; Try and download the image

; If the file doesn't exist, Download it
IfNotExist, %file%
{
    try
    {
      DownloadToFile(url, file, proxy)
    }
    catch e
    {  
      Sleep 1000
    }
}

If bUseProxy
{
    ; If the file still doesn't exist, try again with a proxy
    IfNotExist, %file%
    {
        try
        {
          DownloadToFile(url, file, %my_proxy%)
        }
        catch e
        {  
          Sleep 1000
        }
    }
}

; If the file still doesn't exist, try one last time
IfNotExist, %file%
{
    try
    {
      DownloadToFile(url, file, proxy)
    }
    catch e
    {  
      Sleep 1000
    }
}

; If the file still doesn't exist, change the background color to RED
IfNotExist, %file%
{
    ; set default gui color to red
    Gui, Color, A60004
}
     
; add the background image
Gui, Add, Picture, , %file%

; set fonts to use for the shield text - if a font doesn't exist, it will use the one set prior
Gui, Font, s40 cWhite, Courier New
Gui, Font, s40 cWhite, Consolas

; Check that my_minutes > my_SweatLimit - set to 0 if false
if my_minutes < my_SweatLimit
{
    my_SweatLimit = 0
}

; add the text on the shield (countdown timer)
if my_minutes < 10
     msg_minutes = 0%my_minutes%
else
     msg_minutes = %my_minutes%
     
Gui, Add, Text, BackgroundTrans x690 y250 vShield, % msg_minutes ":00" 

; set fonts to use for the shield - if a font doesn't exist, it will use the previously set one
Gui, Font, s20 cWhite, Courier New
Gui, Font, s20 cWhite, Consolas

; Check which variable (message1 or message2) has the longest line:
MessageOneArray := StrSplit(message1, "`n")
max1_len := 0
Loop, % MessageOneArray.MaxIndex()
{
  this_message := MessageOneArray[a_index]
  StringLen, length, this_message
    
  if(length > max1_len)
    max1_len = %length%
}

MessageTwoArray := StrSplit(message2, "`n")
max2_len := 0
Loop, % MessageTwoArray.MaxIndex()
{
  this_message := MessageTwoArray[a_index]
  StringLen, length, this_message
    
  if(length > max2_len)
    max2_len = %length%
}

; now that you know the max_length of each line in the two variables, decide which to load first
; This ensures that the textbox is created with the right width
if(max1_len >= max2_len)
{    
    ; add the text on the shield (countdown timer)
    Gui, Add, Text, BackgroundTrans x40 y175 vMessage, % message1

}
else
{
    ; message2 has a longer line length than message 1 - set it first
    Gui, Add, Text, BackgroundTrans x40 y175 vMessage, % message2
    
    ; add the text on the shield (countdown timer)
    GuiControl,, Message, % message1
}

; add the next button
Gui, Add, Button, gNextClick x500 y500 072736, >>

; show the gui
Gui, Show, w1050 h700, Red Team

; start a countdown timer for the shield text running the text
; in the label 'Update'
SetTimer, Update, 1000

; Should we move the mouse to draw the user's attention?
if(bMoveMouse)
{
  ; Move the mouse around in an X
  MouseMove, 0, 0
  MouseMove, 1050, 700, 20
  MouseMove, 1050, 0
  MouseMove, 0, 700, 20
  
  ; Place the mouse over the button
  MouseMove, 525, 540, 20
}
else
{
    ;Park the mouse over the button instantly
    MouseMove, 525, 540, 0
}

; prevent the mouse from moving
BlockInput, MouseMove

; capture all keyboard input (does not capture the windows key)
; Win+L will still lock the workstation
Loop 
{
  ;keep accepting keystroke input until my_release_key is pressed
  Input, in, IL1, %my_release_key%  
  EL:=ErrorLevel
} until (EL!="Max") ; on {my_release_key}, ErrorLevel = "Max"

; Exit the script
ExitApp

; Decrement the timer and update the shield with the new value
Update:
  ;Close the task manager - this only works when run as administrator
  Process, Exist, PROCEXP.EXE
  If ( errorlevel > 0 )
     Process, Close, PROCEXP.EXE
     
  Process, Exist, taskmgr.exe
  If ( errorlevel > 0 )
     Process, Close, taskmgr.exe
     
 ; Remove 1 second from the timer
 timer_seconds -= 1
 
 ; If the timer has reached 0, exit!  
 if (timer_minutes = 0 and timer_seconds = 0)
 {
    ExitApp
 }
 else
 {
    ; If the timer variable is not set, set it
    if timer_minutes = 
    {
      timer_minutes = %my_minutes%
      timer_seconds = 0
    }
     
    ; If the seconds have ticked below 0, reset them to 59 and decrement the minutes
    if(timer_seconds < 0)
    {
      timer_seconds = 59
      timer_minutes -= 1
    }
    
    ; Prepend a 0 for single digit minutes
    if(timer_minutes < 10)
      my_min := "0" timer_minutes
    else 
      my_min := timer_minutes
    
    ; Prepend a 0 for single digit seconds
    if(timer_seconds < 10)
      my_sec := "0" timer_seconds
    else 
      my_sec := timer_seconds  
    
    ; Add the formatted text to the Shield text control
    GuiControl,, Shield, % my_min ":" my_sec
    
    ; After 1 minute, display a tooltip that tells how to exit
    if((timer_minutes = (my_minutes - my_SweatLimit)) and timer_seconds = 0)
    {
        tt_text = Press %my_release_key% to break free of this ransomware warning!
        mousegetpos, x, y
        tooltip, %tt_text%, (x + 20), (y + 20), 1
    }
 }

; Capture the Windows Keys
Lwin::return
Rwin::return

; Prevent Alt+F4
!F4::Return

; Event for button click
NextClick:
  If A_GuiControl = >>  
  {
     GuiControl,, Message, % message2
     GuiControl,, >>, <<
  }
  else
  {
     GuiControl,, Message, % message1
     GuiControl,, <<, >>
  }
  return

; Download a file
; u = url
; s = file
; pr = proxy
DownloadToFile(u,s,pr)
{
  static r:=false,request:=comobjcreate("WinHttp.WinHttpRequest.5.1")

  if(!r||request.option(1)!=u)
     request.open("GET",u)
  
  ;proxy format: xyz.xyz.xyz.xyz:PORT
  if(!pr)
     request.SetProxy(2, pr) ; IF YOU NEED TO SET YOUR PROXY
     
  request.send()
  
  if(request.responsetext="failed"||request.status!=200||comobjtype(request.responsestream)!=0xd)
     return false
  
  p:=comobjquery(request.responsestream,"{0000000c-0000-0000-C000-000000000046}")
  
  f:=fileopen(s,"w")
  Loop
  {
     varsetcapacity(b,8192)
     r:=dllcall(numget(numget(p+0)+3*a_ptrsize),ptr,p,ptr,&b,uint,8192, "ptr*",c)
     f.rawwrite(&b,c)
  }until (c=0)
  
  objrelease(p)
  f.close()
  
  return request.responsetext
}
