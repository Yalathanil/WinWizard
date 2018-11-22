@echo off
title Savior of Windows
:Intro
Echo ----------------------------------------
echo  Welcome to the glorious windows script
echo ----------------------------------------
echo.
echo.
goto :M

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
echo Auto     -- A
echo Menu     -- M
echo.
Choice /C 123456AM /N /M "Please choose a functionality: "
goto %errorlevel%


::Disables Vulnerable Services
:1
Echo Disabling Vulnerable Services
sc config SessionEnv start= disabled 
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
sc config MpsSvc start= enabled
goto :M

::Turns on all Auditing
:2
Echo Auditing Enabled
auditpol /set /category:* /success:enable /failure:enable
goto :M

::Turns on Firewall
:3
echo Enabled Firewall
netsh advfirewall set allprofiles state on
goto :M

::Serches for Media Files
:4
Echo Media Management Menu
echo.
echo Purge system of all media -- 1
echo Generate log of all media -- 2
echo Search for particular ext -- 3
echo Return to menu            -- M
set /p mediaf="Enter Selection Here: "
if [mediaf]==[1] (
	del /p  %homedrive%\*.mp3 /s /a-s
)
Type NUL > MediaLog.txt
cd %homedrive%\
dir /S /B /A *.txt *.mp3 *.mp4 *.mov *.wav >> MediaLog.txt
start MediaLog.txt
pause
goto :M

::User/Group Management
:5
setlocal
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

else (
	echo Incorrect value entered
	goto :beginning
)
net user guest /active:no
endlocal
goto :beginUser

::Policies
:6
net accounts /minpwlen:8 /maxpwage:90 /minpwage:15 /uniquepw:24
goto :M


