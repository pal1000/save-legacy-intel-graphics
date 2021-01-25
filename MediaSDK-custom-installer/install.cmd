@echo off
@cd /d "%~dp0"
@set "ERRORLEVEL="
@CMD /C EXIT 0
@"%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" >nul 2>&1
@if NOT "%ERRORLEVEL%"=="0" (
@powershell -Command Start-Process """%0""" -Verb runAs 2>nul
@exit
)
:--------------------------------------
@TITLE Install Intel MediaSDK

@rem Detect Device ID
@CMD /C EXIT 0
@where /q devcon
@if NOT "%ERRORLEVEL%"=="0" echo Windows Device console - devcon.exe is required.&pause&exit
@for /F "tokens=2 USEBACKQ delims=&" %%a IN (`devcon find ^=Display "PCI\VEN_8086&DEV_*"`) do @set deviceid=%%a
@set deviceid=%deviceid:~4%

@rem Register MediaSDK
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK /ve /f
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK\Dispatch /ve /f
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK\Dispatch\%deviceid% /ve /f
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK\Dispatch\%deviceid% /v APIVersion /t REG_DWORD /d 0x104 /f
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK\Dispatch\%deviceid% /v DeviceID /t REG_DWORD /d 0x%deviceid% /f
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK\Dispatch\%deviceid% /v Merit /t REG_DWORD /d 0x800005f /f
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK\Dispatch\%deviceid% /v Path /t REG_SZ /d "%ProgramFiles(x86)%\Intel\Media SDK\libmfxhw64.dll" /f
@REG ADD HKLM\SOFTWARE\Intel\MediaSDK\Dispatch\%deviceid% /v VendorID /t REG_DWORD /d 0x8086 /f

@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK /ve /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK\Dispatch /ve /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK\Dispatch\%deviceid% /ve /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK\Dispatch\%deviceid% /v APIVersion /t REG_DWORD /d 0x104 /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK\Dispatch\%deviceid% /v DeviceID /t REG_DWORD /d 0x%deviceid% /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK\Dispatch\%deviceid% /v Merit /t REG_DWORD /d 0x800005f /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK\Dispatch\%deviceid% /v Path /t REG_SZ /d "%ProgramFiles(x86)%\Intel\Media SDK\libmfxhw32.dll" /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Intel\MediaSDK\Dispatch\%deviceid% /v VendorID /t REG_DWORD /d 0x8086 /f

@rem Copy MediaSDK files
@IF NOT EXIST "%ProgramFiles(x86)%\Intel\" md "%ProgramFiles(x86)%\Intel"
@IF EXIST "%ProgramFiles(x86)%\Intel\Media SDK\" RD /S /Q "%ProgramFiles(x86)%\Intel\Media SDK"
@md "%ProgramFiles(x86)%\Intel\Media SDK"
@copy MediaSDK\*.* "%ProgramFiles(x86)%\Intel\Media SDK"
@pause

