@echo off
dir /s /b /a C:\winpe\drivers\32\*.inf > drivers_32.txt

title Installing drivers from: winpe\drivers\32 to winpe_x86 - [winpe-32Bit]

echo.
echo Press Enter to install drivers listed in drivers_32.txt to winpe_x86
echo --------------------------------------------------------------------
pause

FOR /F %%D IN (drivers_32.txt) DO dism /add-driver /image:C:\winpe\winpe_x86\mount /driver:%%D
del /F /Q C:\winpe\drivers\drivers_32.txt

REM Lista installed drivers
dism /get-drivers /image:C:\winpe\winpe_x86\mount
pause