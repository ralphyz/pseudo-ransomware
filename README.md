# pseudo-ransomware
Emulates a ransomeware program using AutoHotKey.  This script has a countdown timer which releases the mouse and keyboard when it completes.  Press {F12} anytime to terminate the script.  All settings are configurable, including the background download.  

## User defined parameters
```
;Set the duration of the countdown clock
my_minutes := 5

; Set the minutes that must pass before revealing the escape message
my_SweatLimit := 1

; Set the key which must be pressed to escape
my_release_key = {F12}

; Try and use a proxy after trying without?
bUseProxy := false

; Move the mouse to draw the user's eye?
bMoveMouse := false

; The Proxy Information
my_proxy = 

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
```
