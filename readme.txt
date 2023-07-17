Links:
------
WebPage: http://www.leemann.se/fredrik
GitHub: https://github.com/freddan88/pxesrv-linux

Tutorial: http://www.leemann.se/fredrik/tutorials/project-pxesrv-v2-compile-network-boot-server
Download: http://www.leemann.se/fredrik/file_downloads/httpsrv_linux-server_2.0.zip
Video (SWE) https://www.youtube.com/watch?v=gJfK99RntxA&t=11s

Playlist PXESRV - YouTube
https://www.youtube.com/playlist?list=PLgwpw8nEhjkV4-S7cCYv72V2T19GW4qVi

Description:
------------
Easy to use script to compile and install dnsmasq, lighttpd to use a pxe
This script will also help you manage the service, stare/stop/restart etc.

Will be compiled into a single directory for easier manageability and portability

I take no responsibility for this script, use at your own risk
Security and bugs shall be reported to each individual project
This script is only tested with softwareversions found in the script
The script is only tested with: CentOS6, CentOS7 and Ubuntu 16.04 Linux

-----------------------------------------------------------------------

License MIT: https://choosealicense.com/licenses/mit

----------------------------------------------------

Actions in script:

// Start the server
#pxesrv start

// Stop the server
#pxesrv stop

// Restart the server
#pxesrv restart

// View server status
#pxesrv status

// View dnsmasq DHCP leases
#pxesrv leases

// Change permissions, owner and group on pxesrv
#pxesrv perm

// Compile and install service Dnsmasq
#pxesrv make_s1

// Compile and install service Lighttpd
#pxesrv make_s2

// Finalize installation of pxesrv
#pxesrv finalize

// Uninstall services but keeps Boot-files
#pxesrv remove_all

// Run this to delete users and home-directory
#userdel -fr pxesrv
