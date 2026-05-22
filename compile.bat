:: ---------------------------------------------------------------------
:: compile.bat
::
:: 15 JUN 2015 BJACKSON 
:: ---------------------------------------------------------------------
::
:: Utility for invoking PL/B compiler
::
:: ---------------------------------------------------------------------
@echo off

echo Compile Program

plbcon plbcmp %1 -s,y,e,p, "COMPILE"

echo.
echo COMPILE.BAT complete
echo.
