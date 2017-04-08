; Permit only a single instance of this script at a time
#SingleInstance Force

; Disable warnings (error dialog boxes being shown to user)
#Warn All, Off  

; Disable the HTTP Download error message
ComObjError(false)

; Set the duration of the countdown
my_minutes := 5

;========================================================
; set some defaults for the window
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
;========================================================
; end defaults
;========================================================

; get the image
url = https://github.com/ralphyz/red/raw/master/shield2.png
file = %A_Temp%\shield.png
proxy = 

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

; If the file still doesn't exist, try again with a proxy
IfNotExist, %file%
{
   proxy = 104.129.198.34:9400
   try
   {
     DownloadToFile(url, file, proxy)
   }
   catch e
   {  
     Sleep 1000
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

; Try one last time with a proxy
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

; add the text on the shield (countdown timer)
if my_minutes < 10
    msg_minutes = 0%my_minutes%
else
    msg_minutes = %my_minutes%
    
Gui, Add, Text, BackgroundTrans x690 y250 vShield, % msg_minutes ":00" 

; set fonts to use for the shield - if a font doesn't exist, it will use the previously set one
Gui, Font, s20 cWhite, Courier New
Gui, Font, s20 cWhite, Consolas

; the messages that are displayed.
message1 =
(
Ransomware is the term for malware 
that prevents or limits users from 
accessing their files or even 
computers. It forces victims to pay
a ransom, usually in the form of 
Bitcoins, before they can get access  _  
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

; add the text on the shield (countdown timer)
Gui, Add, Text, BackgroundTrans x40 y175 vMessage, % message1

; add the next button
Gui, Add, Button, gNextClick x500 y500 072736, >>

; show the gui
Gui, Show, w1050 h700, Red Team

; Move the mouse around
MouseMove, 0, 0
MouseMove, 1050, 700, 20
MouseMove, 1050, 0
MouseMove, 0, 700, 20



; start a countdown timer for the shield text running the text
; in the label 'Update'
SetTimer, Update, 1000


; Place the mouse over the button
MouseMove, 525, 540, 20

; prevent the mouse from moving
BlockInput, MouseMove

; capture all keyboard input (does not capture the windows key)
; Win+L will still lock the workstation
Loop 
{
  ;keep accepting keystroke input until F12 is pressed
  Input, in, IL1, {F12}  
  EL:=ErrorLevel
} until (EL!="Max") ; on F12, ErrorLevel = "Max"

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
   if((timer_minutes = (my_minutes - 1)) and timer_seconds = 0)
   {
      tt_text = Press F12 to break free of this ransomware warning!
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
