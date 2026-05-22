:: ---------------------------------------------------------------------
:: DESIGNER.BAT
::
:: 15 JUN 2015 BJACKSON 
:: ---------------------------------------------------------------------
::
:: Utility for invoking PL/B designer
::
:: ---------------------------------------------------------------------
@echo off

echo PL/B Form Designer

if "%~1"=="" (start plbwin designer) else (start plbwin designer .\src\plf\%1)

echo.
echo DESIGNER.BAT complete
echo.
