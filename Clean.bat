@echo off
TITLE Free Portable Cleanup Suite by Ohmnivore

SET HELP=false
SET CDEL=false

IF "%1"=="--delete" SET CDEL=true
IF "%2"=="--delete" SET CDEL=true

IF "%1"=="-h" SET HELP=true
IF "%1"=="--help" SET HELP=true
IF "%1"=="/help" SET HELP=true

IF %HELP%==true (
call :showhelp
exit /b
)
IF %HELP%==false (
call :main
exit /b
)

:showhelp
Echo(
call :Info "Usage- Clean.bat [drive letter, default is c]"
Echo(
call :Info "Ex- Clean.bat d"
call :Info "Just run Clean.bat without parameters to run on C"
Echo(
call :Info "the --delete flag can be used to allow ClamWin"
call :Info "to delete infected files instead of just logging them."
Echo(
call :Info "ClamWin logs to ClamWinLog.txt"
Echo(
exit /b

:main
copy /y NUL %~dp0ClamWinLog.txt >NUL
copy /y NUL %~dp0ClamWinUpdateLog.txt >NUL

call :ColorText 0b "No guarantees, bla, bla, bla, etc, etc"
ECHO(
call :sleep 4

call :Info "Green text stands for INFORMATION."
call :Instr "Red text stands for INSTRUCTIONS."
call :sleep 5
ECHO(

call :Instr "NOTE that browsers will close"
call :Instr "during this process. Make sure"
call :Instr "you saved anything important."
call :sleep 10
ECHO(

call :Info "Running Junk Removal Tool by Thisisu"
call :Instr "Select the JRT.exe window and hit Enter"
call :Instr "to continue with the process"
Echo(
start "" "%~dp0JRT.exe"
call :sleep 20

call :Instr "From now on all the clean up process"
call :Instr "will be automatic"
Echo(

call :Info "Running Windows cleanmgr.exe"
Echo(
"cleanmgr.exe"/sagerun: n

call :Info "Updating ClamWin portable"
cd "%~dp0ClamWinPortable\App\clamwin\bin\"
Echo(
start /WAIT "" "%~dp0ClamWinPortable\App\clamwin\bin\freshclam.exe" --log="%~dp0ClamWinUpdateLog.txt"
start /WAIT "" "%~dp0ClamWinPortable\App\clamwin\bin\freshclam.exe" --log="%~dp0ClamWinUpdateLog.txt"

call :Info "Running ClamWin portable"
Echo(
IF %CDEL%==false (
IF "%~1"=="" start /WAIT "" "%~dp0ClamWinPortable\App\clamwin\bin\clamscan.exe" --log="%~dp0ClamWinLog.txt" --recursive -i --database="%~dp0ClamWinPortable\Data\db\\" C:\
IF not "%1" == "" start /WAIT "" "%~dp0ClamWinPortable\App\clamwin\bin\clamscan.exe" --log="%~dp0ClamWinLog.txt" --recursive -i --database="%~dp0ClamWinPortable\Data\db\\" %~d1\
)
IF %CDEL%==true (
IF "%~1"=="" start /WAIT "" "%~dp0ClamWinPortable\App\clamwin\bin\clamscan.exe" --log="%~dp0ClamWinLog.txt" --remove --recursive -i --database="%~dp0ClamWinPortable\Data\db\\" C:\
IF not "%1" == "" start /WAIT "" "%~dp0ClamWinPortable\App\clamwin\bin\clamscan.exe" --log="%~dp0ClamWinLog.txt" --remove --recursive -i --database="%~dp0ClamWinPortable\Data\db\\" %~d1\
)

call :Info "Running UltraDefrag portable"
Echo(
IF "%~1"=="" start /WAIT "" "%~dp0UltraDefragPortable\App\UltraDefrag\x86\udefrag.exe" --defragment -q c:
IF not "%1" == "" start /WAIT "" "%~dp0UltraDefragPortable\App\UltraDefrag\x86\udefrag.exe" --defragment -q %~d1

call :Info "Done. Finished. Haha."
Echo(

exit /b

:sleep Seconds
ping -n %~1 127.0.0.1 > nul

:Instr %1=Str
call :ColorText 0c %1
ECHO(
exit /b

:Info %1=Str
call :ColorText 0a %1
ECHO(
exit /b

:ColorText Color String
:: http://stackoverflow.com/questions/2586012/how-to-change-the-text-color-of-comments-line-in-a-batch-file
:: Prints String in color specified by Color.
::
::   Color should be 2 hex digits
::     The 1st digit specifies the background
::     The 2nd digit specifies the foreground
::     See COLOR /? for more help
::
::   String is the text to print. All quotes will be stripped.
::     The string cannot contain any of the following: * ? < > | : \ /
::     Also, any trailing . or <space> will be stripped.
::
::   The string is printed to the screen without issuing a <newline>,
::   so multiple colors can appear on one line. To terminate the line
::   without printing anything, use the ECHO( command.
::
setlocal
pushd %temp%
for /F "tokens=1 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  <nul set/p"=%%a" >"%~2"
)
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
popd
exit /b