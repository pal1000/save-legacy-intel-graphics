@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
@TITLE Install OpenCL CPU Runtime
@IF EXIST "%ProgramFiles%\Intel\OpenCL\" RD /S /Q "%ProgramFiles%\Intel\OpenCL"
@copy SystemFolder\OpenCL.dll %windir%\syswow64
@copy System64Folder\OpenCL.dll %windir%\system32
@xcopy /E /I Intel\OpenCL\*.* "%ProgramFiles%\Intel\OpenCL"
@REG ADD HKLM\SOFTWARE\Khronos\OpenCL\Vendors /v "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\intel64_win\Intelocl64.dll" /t REG_DWORD /d 00000000 /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Khronos\OpenCL\Vendors /v "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\ia32_win\Intelocl32.dll" /t REG_DWORD /d 00000000 /f
@set ERRRORLEVEL=0
@where /q Intelocl64.dll
@IF ERRORLEVEL 1 setx PATH "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\intel64_win\;%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\ia32_win\;%PATH%" /m
@pause
