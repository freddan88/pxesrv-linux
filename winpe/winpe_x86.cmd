@echo off

REM Create directories:
mkdir C:\winpe\winpe_x86
cd C:\winpe\winpe_x86
mkdir sources
mkdir mount
mkdir ISO\EFI
mkdir ISO\boot
mkdir ISO\sources

REM Copy architecture dependent files for winpe:
xcopy "%ProgramFiles%\Windows AIK\Tools\PETools\x86\boot" ISO\boot /E
xcopy "%ProgramFiles%\Windows AIK\Tools\PETools\x86\efi" ISO\EFI /E
copy /Y "%ProgramFiles%\Windows AIK\Tools\PETools\x86" ISO
copy C:\winpe\winpe_x86\ISO\bootmgr .
copy C:\winpe\winpe_x86\ISO\boot\etfsboot.com .
move C:\winpe\winpe_x86\ISO\BootSect.exe .
move C:\winpe\winpe_x86\ISO\winpe.wim .

REM Generate winpe_tools_x86.iso:
dism /mount-wim /wimfile:winpe.wim /index:1 /mountdir:mount
xcopy "%ProgramFiles%\Windows AIK\Tools\x86" mount /E
copy /Y C:\winpe\startnet\winpe_startnet_x86.txt mount\Windows\System32\startnet.cmd

echo.
echo Install device drivers if needed. Se Example.txt for help.
echo ----------------------------------------------------------
pause

dism /unmount-wim /mountdir:mount /commit
copy /Y winpe.wim ISO\sources\boot.wim
move ISO\boot\bootfix.bin ISO\boot\bootfix_bak.bin

"%ProgramFiles%\Windows AIK\Tools\x86\oscdimg" -n -betfsboot.com ISO C:\winpe\winpe_x86.iso
cd C:\winpe
rmdir /S /Q winpe_x86
dism /cleanup-wim