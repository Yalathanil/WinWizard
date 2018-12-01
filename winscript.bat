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
PowerShell Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
pause


:M
Echo ----------------------------------------
echo                  MENU                  
echo ----------------------------------------
echo.
echo.
echo FUNCTIONALITIES:
echo.
echo Services -- 1
echo Auditing -- 2
echo Firewall -- 3
echo Media    -- 4
echo Users    -- 5
echo Policies -- 6
echo   -- 7
echo Update   -- 8
echo Auto     -- A
echo Menu     -- M
echo.
Choice /C 12345678AM /N /M "Please choose a functionality: "
goto %errorlevel%


::Disables Vulnerable Services
:1
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
sc config MpsSvc start= auto
sc start MpsSvc 
goto :M

::Turns on all Auditing
:2
Echo Enabling Auditing
auditpol /set /category:"logon/logoff" /success:enable /failure:enable
auditpol /set /category:"Account Logon" /success:enable /failure:enable
auditpol /set /category:"Account Management" /success:enable /failure:enable
auditpol /set /category:"Detailed Tracking" /success:enable /failure:enable
auditpol /set /category:"DS Access" /success:enable /failure:enable
auditpol /set /category:"Object Access" /success:enable /failure:enable
auditpol /set /category:"Policy Change" /success:enable /failure:enable
auditpol /set /category:"Privilege Use" /success:enable /failure:enable
auditpol /set /category:"System" /success:enable /failure:enable
goto :M

::Turns on Firewall
:3
echo Enabled Firewall
netsh advfirewall set allprofiles state on
goto :M

::Serches for Media Files
:4
:beginMedia
Echo Media Management Menu
echo.
echo Purge system of all media -- 1
echo Generate log of all media -- 2
echo Search for particular ext -- 3
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
	dir /S /B /A *.txt *.mp3 *.mp4 *.mov *.wav *.bat *.vbi >> MediaLog.txt
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
if [%mediaf%]==[M] (
	goto :M
)
echo Incorrect value entered.
goto :beginMedia


::User/Group Management
:5
setlocal
net user guest /active:no
::Users
:beginUser
net users
set /p user="Enter username to be manipulated: "
Echo Delete user             -- 1
Echo Add user                -- 2
Echo Groups                  -- 3
Echo Return to main menu     -- M
set /P uservar="Enter your selection: "

if [%uservar%]==[1] (net user %user% /DELETE)

if [%uservar%]==[2] (
	set /p newuserpassword="Enter new user password: "
	net user /ADD %user% %newuserpassword%
	echo.
	echo New User Added:
	echo Username: %user% Password: %newuserpassword%
	set newuserpassword=
)

if [%uservar%]==[3] (
	:beginGroup
	echo Select group level
	set /p grouplvl="GROUP/LOCALGROUP: "
	net %grouplvl% 
	echo Delete Group           -- 1
	echo Add Group              -- 2
	echo Add User to Group      -- 3
	echo Remove User from Group -- 4
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
		
)
		if [%uservar%]==[M] (
			goto :M
)
echo Incorrect value entered
goto :beginning
endlocal
goto :beginUser

::Policies
:6
net accounts /minpwlen:8 /maxpwage:90 /minpwage:15 /uniquepw:24
reg add HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers /v DisableAutoplay /t REG_DWORD /d 0 
secedit /import /db secedit.sbd /cfg c:\Users\%userprofile%\Desktop\Win10SecPolTemp.inf
goto :M

::Updates
:8
echo Initializing 3rd Pary Program Downloads and Updates
choco update Firefox
choco install sysinternals
choco install ie11
choco install malwarebytes
echo Initializing Windows Updates
pause
wuauclt /detectnow /updatenow
goto :M



