#!/bin/sh
# Date: 2018-06-02
# Author: www.leemann.se/fredrik
# YouTube: https://www.youtube.com/user/FreLee54
##
# WebPage: http://www.leemann.se/fredrik
# Donate: https://www.paypal.me/freddan88
# GitHub: https://github.com/freddan88/pxesrv-linux
##
# Tutorial: http://www.leemann.se/fredrik/tutorials/project-pxesrv-v2-compile-network-boot-server
##
### BEGIN INIT INFO
# Provides:          pxesrv
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: pxesrv
# Description:       pxesrv - dnsmasq & lighttpd By: www.leemann.se/fredrik
### END INIT INFO
##
## Links:
## How to LSBize Init Script: https://wiki.debian.org/LSBInitScripts
## Insserv: https://help.directadmin.com/item.php?id=379
########################################################
## Configuration:
ROOT=/srv/pxesrv
#
## Do not edit bellow those lines!
## To add this script as a system-service and autostart it at boot run:
## Command as sudo/root - Debian/Ubuntu: update-rc.d init-pxesrv defaults
## Command as sudo/root - CentOS/Fedora: chkconfig --add init-pxesrv && chkconfig init-pxesrv on
################################################################################################
case $1 in

start)
	kill -9 $(cat 2>/dev/null $ROOT/tmp/pid/dnsmasq.pid) 2>/dev/null
	kill -9 $(cat 2>/dev/null $ROOT/tmp/pid/lighttpd.pid) 2>/dev/null
	rm -f $ROOT/tmp/pid/pxesrv.lock 2>/dev/null
	rm -f $ROOT/tmp/pid/*.pid 2>/dev/null
	$ROOT/sbin/lighttpd -f $ROOT/pxe/configs/lighttpd.conf
	$ROOT/sbin/dnsmasq -x $ROOT/tmp/pid/dnsmasq.pid --conf-file=$ROOT/pxe/configs/dnsmasq.conf
	echo "Starting services for pxesrv - lighttpd + dnsmasq"
	touch $ROOT/tmp/pid/pxesrv.lock
;;

stop)
	kill -9 $(cat 2>/dev/null $ROOT/tmp/pid/dnsmasq.pid) 2>/dev/null
	kill -9 $(cat 2>/dev/null $ROOT/tmp/pid/lighttpd.pid) 2>/dev/null
	rm -f $ROOT/tmp/pid/pxesrv.lock 2>/dev/null
	rm -f $ROOT/tmp/pid/*.pid 2>/dev/null
	echo "Stopping services for pxesrv - lighttpd + dnsmasq"
;;

*)
echo " "
	echo "Argumets: start|stop"
	echo "--------------------"
;;

esac
exit