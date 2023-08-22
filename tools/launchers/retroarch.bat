@echo off
set args=%*
title EmuDeck Launcher
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$toolsPath"') do set "toolsPath=%%~a"
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$savesPath"') do set "savesPath=%%~a"
for /f "tokens=2 delims==" %%b in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "cloud_sync_status"') do set "cloud_sync_status=%%~b"
set rcloneConfig="%toolsPath%\rclone\rclone.conf"
if exist "%rcloneConfig%" (
	if "%cloud_sync_status%"=="true" (	
		echo. > %savesPath%\.watching
	
		powershell -NoProfile -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/allCloud.ps1 ; cloud_sync_downloadEmu retroarch"}		
		%userprofile%\AppData\Roaming\EmuDeck\backend\wintools\nssm.exe stop "CloudWatch"
		%userprofile%\AppData\Roaming\EmuDeck\backend\wintools\nssm.exe start "CloudWatch"
	)
)

"ESDEPATH\Emulators\RetroArch\retroarch.exe" %args%
del %savesPath%\.watching
