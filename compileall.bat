@echo off
cls
echo Master Project Compile Script
echo.
choice /M "Recompile all programs "
IF ERRORLEVEL == 2 GOTO END

:: get the git branch we are building from and store in a file
del src\gitbranch.tmp /Q
for /f %%f in ('git branch --show-current') do (SET GITBRANCH=%%f)
echo $GITBRANCH INIT "%GITBRANCH%" > src\gitbranch.tmp

del .\bin\*.plc
del .\bin\*.sdb
del .\bin\*.lst

for /f %%f in ('dir src\*.pls /b /on') do (plbcon plbcmp src\%%f -ZG,ZT,S,WS,E,X,VGIT=1,P "mass compile")

echo.
echo Recompile complete.
echo.

for %%f in ('dir .\bin\*.plc /b /on') do if %%~zf==0 ( echo Compile Error: %%~nf )

echo.

:: delete the temporary gitbracnh file
del src\gitbranch.tmp

choice /M "Delete all LST and PLBM files? "
IF ERRORLEVEL == 2 GOTO END

del .\bin\*.lst
del .\bin\*.plbm

:END

