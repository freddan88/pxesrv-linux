﻿Links:
------
WebPage: http://www.leemann.se/fredrik
Donate: https://www.paypal.me/freddan88
YouTube: https://www.youtube.com/user/FreLee54
GitHub: https://github.com/freddan88/pxesrv-linux

Tutorial: http://www.leemann.se/fredrik/tutorials/project-pxesrv-v2-compile-network-boot-server

Description:
------------
Easy to use script to build winpe.iso

winpe_x86.cmd will generate winpe_x86.iso (32Bit Winpe that can be used in pxesrv etc.)
winpe_x64.cmd will generate winpe_x64.iso (64Bit Winpe that can be used in pxesrv etc.)

I take no responsibility for this script, use at your own risk
The script is only tested with: Windows 7 32 and 64Bit...
---------------------------------------------------------

Directory: winpe\drivers shall be used if you need to install drivers to winpe

Extract 32Bit drivers for winpe in: winpe\drivers\32
Extract 64Bit drivers for winpe in: winpe\drivers\64

For easy installation you can use:
winpe\drivers\install_32.bat
winpe\drivers\install_64.bat

Winpe drivers are often 3 files: .inf + .sys + .cat

File: winpe\startnet\winpe_startnet_x64.txt and winpe_startnet_x86.txt
Those files must be configured before generating winpe.iso

configure line 9 and 10 to attach your share if you are using pxesrv

Examples: winpe\examples.txt contains examples on how to install drivers etc.