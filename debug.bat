:: ---------------------------------------------------------------------
:: DEBUG.BAT
::
:: 15 JUN 2015 BJACKSON 
:: ---------------------------------------------------------------------
::
:: Utility for invoking PL/B debugger
::
:: ---------------------------------------------------------------------
@echo off

echo Debug PL/B Program

start plbwin -d .\bin\%1 %2 %3 %4 %5 %6 %7 %8 %9

echo.
echo DEBUG.BAT complete
echo.
