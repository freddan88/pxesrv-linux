@echo off
dir /s /b /a C:\winpe\drivers\64\*.inf > drivers_64.txt

title Installing drivers from: winpe\drivers\64 to winpe_x64 - [winpe-64Bit]

echo.
echo Press Enter to install drivers listed in drivers_64.txt to winpe_x64
echo --------------------------------------------------------------------
pause

FOR /F %%D IN (drivers_64.txt) DO dism /add-driver /image:C:\winpe\winpe_x64\mount /driver:%%D
del /F /Q C:\winpe\drivers\drivers_64.txt

REM Lista installed drivers
dism /get-drivers /image:C:\winpe\winpe_x64\mount
pause