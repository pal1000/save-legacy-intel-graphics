@IF EXIST "%ProgramFiles%\Intel\OpenCL\" RD /S /Q "%ProgramFiles%\Intel\OpenCL"
@copy SystemFolder\OpenCL.dll %windir%\syswow64
@copy System64Folder\OpenCL.dll %windir%\system32
@xcopy /E /I Intel\OpenCL\*.* "%ProgramFiles%\Intel\OpenCL"
@REG ADD HKLM\SOFTWARE\Khronos\OpenCL\Vendors /v "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\intel64_win\Intelocl64.dll" /t REG_DWORD /d 00000000 /f
@REG ADD HKLM\SOFTWARE\WOW6432Node\Khronos\OpenCL\Vendors /v "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\ia32_win\Intelocl32.dll" /t REG_DWORD /d 00000000 /f
@setx PATH "%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\intel64_win\;%ProgramFiles%\Intel\OpenCL\windows\compiler\lib\ia32_win\;%PATH%" /m