@echo off

REM Create directories:
mkdir C:\winpe\winpe_x64
cd C:\winpe\winpe_x64
mkdir sources
mkdir mount
mkdir ISO\EFI
mkdir ISO\boot
mkdir ISO\sources

REM Copy architecture dependent files for winpe:
xcopy "%ProgramFiles%\Windows AIK\Tools\PETools\amd64\boot" ISO\boot /E
xcopy "%ProgramFiles%\Windows AIK\Tools\PETools\amd64\efi" ISO\EFI /E
copy /Y "%ProgramFiles%\Windows AIK\Tools\PETools\amd64" ISO
copy C:\winpe\winpe_x64\ISO\bootmgr .
copy C:\winpe\winpe_x64\ISO\boot\etfsboot.com .
move C:\winpe\winpe_x64\ISO\BootSect.exe .
move C:\winpe\winpe_x64\ISO\winpe.wim .

REM Generate winpe_tools_x64.iso:
dism /mount-wim /wimfile:winpe.wim /index:1 /mountdir:mount
xcopy "%ProgramFiles%\Windows AIK\Tools\amd64" mount /E
copy /Y C:\winpe\startnet\winpe_startnet_x64.txt mount\Windows\System32\startnet.cmd

echo.
echo Install device drivers if needed. Se Example.txt for help.
echo ----------------------------------------------------------
pause

dism /unmount-wim /mountdir:mount /commit
copy /Y winpe.wim ISO\sources\boot.wim
move ISO\boot\bootfix.bin ISO\boot\bootfix_bak.bin

"%ProgramFiles%\Windows AIK\Tools\x86\oscdimg" -n -betfsboot.com ISO C:\winpe\winpe_x64.iso
cd C:\winpe
rmdir /S /Q winpe_x64
dism /cleanup-wim