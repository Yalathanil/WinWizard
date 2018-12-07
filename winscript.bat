@echo off
title Savior of Windows
:Intro
Echo ----------------------------------------
echo  Welcome to the glorious windows script
echo ----------------------------------------
echo.
echo.


Echo Initializing
::Choco lets us download a variety of things that are important. 
::Once set up it can be called by choco install blank
::Need to add a templates that can be downloaded and put in for security settings and the like
::Along with a checklist
echo.
echo If you want to skip the initial step, enter MENU
set /p Init="Enter here: "
if Init==M (
	goto :M
	)
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
pause


:M
cls
Echo ----------------------------------------
echo                  MENU                  
echo ----------------------------------------
echo.
echo.
echo FUNCTIONALITIES:
echo.
echo Update   -- 1
echo Programs -- 2
echo Services -- 3
echo Policies -- 4
echo Users    -- 5
echo Media    -- 6
echo Network  -- 7
echo Start Up -- 8
echo Computer -- 9
echo SysInt   -- S
echo Auto     -- A
echo Menu     -- M
echo.
Choice /C 123456789BAM /N /M "Please choose a functionality: "
goto %errorlevel%


::Updates & Install
:1
cls
setlocal
echo Initializing 3rd Pary Program Downloads and Updates
choco update Firefox
choco install sysinternals
choco install ie11
choco install malwarebytes
choco install notepadplusplus
echo Initializing Windows Updates
pause
wuauclt /detectnow /updatenow
endlocal
goto :M

::Programs
:2
cls
setlocal
echo Program management
echo.
echo Start Microsoft Defender
echo.
cd %programfiles%\Windows Defender
start MSASCui.exe
pause
echo Remove programs as dictated by the README
echo.
start appwiz.cpl
pause
cd C:\Program Files (x86)\Malwarebytes' Anti-Malware
echo Run Malware Bytes
start mbam.exe /fullauto
pause
cd /d %homedrive%\Users\%username%\Downloads

endlocal
goto :M


::Disables Vulnerable Services
:3
cls
setlocal
Echo Disabling Vulnerable Services
sc config SessionEnv start=  disabled 
sc stop SessionEnv 
sc config IISADMIN start= disabled 
sc stop IISADMIN
sc config TelnetClient start= disabled
sc stop TelnetClient
sc config TermService start= disabled
sc stop TermService
sc config RemoteRegistry start= disabled
sc stop RemoteRegistry
sc config RemoteAccess start= disabled
sc stop RemoteAccess

echo Enabling Important Services

endlocal
goto :M


::Policies
:4
cls
setlocal
echo Enabling Auditing
auditpol /set /category:"logon/logoff" /success:enable /failure:enable
auditpol /set /category:"Account Logon" /success:enable /failure:enable
auditpol /set /category:"Account Management" /success:enable /failure:enable
auditpol /set /category:"Detailed Tracking" /success:enable /failure:enable
auditpol /set /category:"DS Access" /success:enable /failure:enable
auditpol /set /category:"Object Access" /success:enable /failure:enable
auditpol /set /category:"Policy Change" /success:enable /failure:enable
auditpol /set /category:"Privilege Use" /success:enable /failure:enable
auditpol /set /category:"System" /success:enable /failure:enable
net accounts /minpwlen:8 /maxpwage:90 /minpwage:15 /uniquepw:24
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v DisableAutoplay /t REG_DWORD /d 0 
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d C:\Windows\system32\scrnsave.scr /f
secedit /configure /db secedit.sdb /cfg c:\users\%username%\Downloads\WinWizard-master\WinWizard-master\Win10SecPolTemp.inf

endlocal
goto :M


::User/Group Management
:5
cls
setlocal
net user guest /active:no
::Users
:beginUser
net users
set /p user="Enter username to be manipulated: "
Echo Delete user             -- 1
Echo Add user                -- 2
Echo Secure Passwords        -- 3
Echo Groups                  -- 4
Echo Return to main menu     -- M
echo.
echo Password will be set to P@ssword123 for all accounts
echo.
set /P uservar="Enter your selection: "
::Delete User
if [%uservar%]==[1] (net user %user% /DELETE)
::Add User
if [%uservar%]==[2] (
	set /p newuserpassword="Enter new user password: "
	echo.
	echo New User Added:
	echo Username: %user% Password: %newuserpassword%
	net user /ADD %user% %newuserpassword%
	set newuserpassword=
	
)
::Set Secure Passords
echo Password will be set to P@ssword123 for all accounts
if %uservar%==1 (
	for %%A in ('net users') do (
	net user %%A P@ssword123
	goto :beginUser
	)
)
::Group Management
if [%uservar%]==[4] (
	:beginGroup
	echo Select group level
	set /p grouplvl="GROUP/LOCALGROUP: "
	net %grouplvl% 
	echo Delete Group           -- 1
	echo Add Group              -- 2
	echo Add User to Group      -- 3
	echo Remove User from Group -- 4
	echo 
	echo Return to User/Group   -- 5
	set /p groupvar="Enter Value: "
	
		if [%groupvar%]==[1] (
			set /p groupname="Enter the Groupname: "
			net %grouplvl% %groupname% /delete
			set groupname=
			goto :beginGroup
		)
		
		if [%grouplvl%]==[2] (
			set /p groupname="Enter the Groupname: "
			net %grouplvl% %groupname% /add
			set groupname=
			goto :beginGroup
		)
		
		if [%grouplvl%]==[3] (
			set /p groupname="Enter the Groupname: "
			set /p addusergroup="Enter Username: "
			net %grouplvl% %groupname% %addusergroup% /add
			set groupname=
			set addusergroup=
			goto :beginGroup
		)
		if [%grouplvl%]==[4] (
			set /p groupname="Enter the Groupname: "
			set /p addusergroup="Enter Username: "
			net %grouplvl% %groupname% %addusergroup% /delete
			set groupname=
			set addusergroup=
			goto :beginGroup
		)
		if [%grouplvl%==[5] (
			goto :beginUsers
		)
		
)
	if [%uservar%]==[M] (
		goto :M

		)
echo Incorrect value entered
goto :beginning
endlocal


::Serches for Media Files
:6
cls
setlocal
bcdedit.exe /set {current} nx AlwaysOn
:beginMedia
Echo Media Management Menu
echo.
echo Purge system of all media -- 1
echo Generate log of all media -- 2
echo Search for particular ext -- 3
echo Search in users		   -- 4
echo Return to menu            -- M
set /p mediaf="Enter Selection Here: "
if [%mediaf%]==[1] (
	del /p  %homedrive%\*.mp3 /s /a-s
	del /p  %homedrive%\*.mp4 /s /a-s
	del /p  %homedrive%\*.png /s /a-s
	del /p  %homedrive%\*.jpg /s /a-s
	del /p  %homedrive%\*.mov /s /a-s
	del /p  %homedrive%\*.avi /s /a-s
	del /p  %homedrive%\*.wmv /s /a-s
	goto :beginMedia
)
if [%mediaf%]==[2] (
	Type NUL > MediaLog.txt
	cd %homedrive%\
	echo .mp3 >> MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt
	dir /S /B /A *.mp3 > MediaLog.txt
	echo .mp4 > MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt
	dir /S /B /A *.mp4 > MediaLog.txt
	echo .mov > MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt
	dir /S /B /A *.mov > MediaLog.txt
	echo .pdf > MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt
	dir /S /B /A *.pdf > MediaLog.txt
	echo .vbi > MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt
	dir /S /B /A *.vbi > MediaLog.txt
    echo .msi > MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt	
	dir /S /B /A *.msi > MediaLog.txt
	echo .bat > MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt
	dir /S /B /A *.bat > MediaLog.txt	
	echo .exe > MediaLog.txt
	echo. > MediaLog.txt
	echo. > MediaLog.txt
	dir /S /B /A *.exe > MediaLog.txt	
	start MediaLog.txt
	echo MediaLog.txt will be deleted once done
	pause
	del MediaLog.txt
	goto :beginMedia
)
if [%mediaf%]==[3] (
	Type NUL > MediaLog.txt
	set /p mediaext="Enter extention to search for (.): "
	cd %homedrive%\
	dir /S /B /A *.%mediaext% >> MediaLog.txt
	start MediaLog.txt
	echo MediaLog.txt will be deleted once done
	pause
	del MediaLog.txt
	goto :beginMedia
)
if [%mediaf%]==[4] (
	dir c:\Users /b /s
	goto :beginMedia
)
if [%mediaf%]==[M] (
	goto :M
)
echo Incorrect value entered.
endlocal
goto :beginMedia


::Network Security
:7
cls
setlocal
echo Network Security Menu
echo.
echo Firewall    -- 1
echo DNS         -- 2
echo Netstat     -- 3
echo TCP         -- 4
echo Main Menu   -- M
echo.
set /p choice="Enter secletion here: "
::Firewall
if %choice%==1 (
	cls
	echo Firewall 
	sc config MpsSvc start= auto
	sc start MpsSvc
	echo. 
	echo MpsSvc enabled
	netsh advfirewall set allprofiles state on
	echo Enabled Firewall
	goto :7
	)
::DNS
if %choice%==2 (
	cls
	echo DNS
	ipconfig /displaydns
	echo.
	echo.
	set /p A="Do you wish to purge the DNS cache? (y/n): "
	if %A%==y do (
		ipconfig /flushdns
		)
	pause
	goto :7	
	)
::Netstat
if %choice%==3 (
	cls
	echo Netstat
	netstat -a
	pause
	netstat -e
	pause
	netstat -b	
	pause 
	netstat -r
	pause
	goto :7
	)
if %choice%==M (
	goto :M
	)
endlocal
goto :M


::Start up
:8
cls
setlocal
echo Welcome to the start up manager
echo.
echo Auto Runs
set /p choice="Do you want to run Autoruns.exe? (Y/N): "
if %choice%=Y (
	start autoruns.exe
	pause
	)
echo WMIC 
set /p choice1="Do you wish to use WMIC? (Y/N): "
if %choice1%==Y (
	:WMIC
	wmic startup get caption,command 
	echo If there are any suspicious processes remove them.
	set /p prog="Enter program name here: "
	wmic startup delete %prog%
	set /p choice2="Do you wish to use WMIC again? (Y/N): "
	if %choice2%==Y (
		goto :WMIC
	)
)
pause
endlocal


::Comupter Information
:9
cls
setlocal
echo Computer Information
echo.
echo Ipconfig:
echo.
ipconfig /all
pause
endlocal
goto :M

::System Internals
:S
cls
setlocal
:Sys
cls
echo Run Sysinternals
echo.
echo Process Explorer -- 1
echo TCP View         -- 2
echo Autoruns         -- 3
echo Sigcheck         -- 4
echo Sdelete          -- 5
echo AccessEnums      -- 6
echo Return to Menu   -- M
echo.
start https://ptgmedia.pearsoncmg.com/images/9780735656727/samplepages/9780735656727.pdf
choice=="Enter selection here: "
if %choice%==1 (
	start procexp.exe
	pause
	goto :Sys
	)
if %choice%==2 (
	start tcpview.exe
	pause
	goto :Sys
	)
if %choice%==3 (
	start autoruns.exe
	pause
	goto :Sys
	)
if %choice%==4 (
	start sigcheck.exe
	pause
	goto :Sys
	)
if %choice%==5 (
	start sdelete.exe
	pause
	goto :Sys
	)	
if %choice%==6 (
	start accessenums.exe
	pause
	goto :Sys
	)
if %choice%==M (
	goto :M
	pause
	goto :Sys
	)
	
pause
endlocal
goto :M







