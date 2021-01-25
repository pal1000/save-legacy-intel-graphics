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
@TITLE Install OpenCL CPU Runtime
@IF EXIST "%ProgramFiles%\Intel\OpenCL\" RD /S /Q "%ProgramFiles%\Intel\OpenCL"
@copy SystemFolder\OpenCL.dll %windir%\syswow64
@copy System64Folder\OpenCL.dll %windir%\system32
@xcopy /E /I Intel\OpenCL\*.* "%ProgramFiles%\Intel\OpenCL"
@REG ADD HKLM\SOFTWARE\Khronos\OpenCL\Vendors /v "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\intel64_win\Intelocl64.dll" /t REG_DWORD /d 00000000 /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Khronos\OpenCL\Vendors /v "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\ia32_win\Intelocl32.dll" /t REG_DWORD /d 00000000 /f
@CMD /C EXIT 0
@where /q Intelocl64.dll
@if NOT "%ERRORLEVEL%"=="0" setx PATH "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\intel64_win\;%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\ia32_win\;%PATH%" /m
@pause
