; Permit only a single instance of this script at a time
#SingleInstance Force

; Disable warnings (error dialog boxes being shown to user)
#Warn All, Off  

; Set the duration of the countdown
timer_minutes := 60
timer_seconds := 0

; get the middle of the screen
xMidScrn :=  A_ScreenWidth //2
yMidScrn :=  A_ScreenHeight //2

; set default gui color
Gui, Color, EEAA99

; set some defaults for the window
Gui +AlwaysOnTop 
Gui +ToolWindow 
Gui, Margin, 0, 0
Gui -Caption
WinSet, TransColor, EEAA99

; get the image
url = https://github.com/ralphyz/red/raw/master/shield2.png
file = %A_Temp%\shield.png
DownloadToFile(url, file)
;file = shield2.png

; add the background image
Gui, Add, Picture, , %file%

; set fonts to use for the shield - if a font doesn't exist, it will use the previous set one
Gui, Font, s40 cWhite, Courier New
Gui, Font, s40 cWhite, Consolas

; add the text on the shield (countdown timer)
Gui, add, text, BackgroundTrans x690 y250 vShield, % "60:00" 

; set fonts to use for the shield - if a font doesn't exist, it will use the previous set one
Gui, Font, s20 cWhite, Courier New
Gui, Font, s20 cWhite, Consolas

message =
(
Ransomware is the term for malware 
that prevent or limit users from 
accessing their files or even 
computers. They force victims to pay
ransom, usually in the form of 
Bitcoins, before they can get access
back, hence the name. It a huge 
threat to our oranization, and must
be taken seriously.
)

; add the text on the shield (countdown timer)
Gui, add, text, BackgroundTrans x40 y175 vMessage, % message


; show the gui
Gui, show, w1050 h700, Red Team

; start a countdown timer for the shield text running the text
; in the label 'Update'
SetTimer, Update, 1000

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

 ; remove 1 second from the timer
 timer_seconds -= 1
 
 ; if the timer has reached 0, exit!  
 if (timer_minutes = 0 and timer_minutes = 0)
 {
   ExitApp
 }
 else
 {
   ; If the seconds have ticked below 0, reset them to 59 and decrement the minutes
   if(timer_seconds < 0)
   {
     timer_seconds = 59
     timer_minutes -= 1
   }
   
   ; prepend a 0 for single digit minutes
   if(timer_minutes < 10)
     my_min := "0" timer_minutes
   else 
     my_min := timer_minutes
   
   ; prepend a 0 for single digit seconds
   if(timer_seconds < 10)
     my_sec := "0" timer_seconds
   else 
     my_sec := timer_seconds  
   
   ; add the formatted text to the Shield text control
   GuiControl,, Shield, % my_min ":" my_sec
 }

; Capture the Windows Keys
Lwin::return
Rwin::return


DownloadToFile(u,s){
	static r:=false,request:=comobjcreate("WinHttp.WinHttpRequest.5.1")
	if(!r||request.option(1)!=u)
		request.open("GET",u)
    ;request.SetProxy(2, "XXX.XXX.XXX.XXX:PORT") ; IF YOU NEED TO SET YOUR PROXY
	request.send()
	if(request.responsetext="failed"||request.status!=200||comobjtype(request.responsestream)!=0xd)
		return false
	p:=comobjquery(request.responsestream,"{0000000c-0000-0000-C000-000000000046}")
	f:=fileopen(s,"w")
	loop{
		varsetcapacity(b,8192)
		r:=dllcall(numget(numget(p+0)+3*a_ptrsize),ptr,p,ptr,&b,uint,8192, "ptr*",c)
		f.rawwrite(&b,c)
	}until (c=0)
	objrelease(p)
	f.close()
	return request.responsetext
}
