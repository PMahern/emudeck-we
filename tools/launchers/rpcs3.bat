@echo off
set args=%*
title EmuDeck Launcher
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$toolsPath"') do set "toolsPath=%%~a"
for /f "tokens=2 delims==" %%a in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "$savesPath"') do set "savesPath=%%~a"
for /f "tokens=2 delims==" %%b in ('type "%userprofile%\EmuDeck\settings.ps1" ^| find "cloud_sync_status"') do set "cloud_sync_status=%%~b"
set rcloneConfig="%toolsPath%\rclone\rclone.conf"
if exist "%rcloneConfig%" (
	if "%cloud_sync_status%"=="true" (
		powershell -ExecutionPolicy Bypass -command "& { . $env:USERPROFILE/AppData/Roaming/EmuDeck/backend/functions/all.ps1 ; cloud_sync_downloadEmu rpcs3 "}
		start /min "CloudSync Monitor" cscript //nologo "%userprofile%/AppData/Roaming/EmuDeck/backend/tools/cloud_sync_monitor.vbs" rpcs3 %savesPath%
	)
)
"ESDEPATH\Emulators\RPCS3\rpcs3.exe" %args%