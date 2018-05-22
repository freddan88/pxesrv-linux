#!/bin/sh
# Updated: 2018-01-10
# Script: www.leemann.se/fredrik | www.youtube.com/user/FreLee54
# Dnsmasq: http://www.thekelleys.org.uk/dnsmasq/doc.html
# Lighttpd: https://www.lighttpd.net
#################
## Configuration:
root_user=root
root_group=root

## Please don´t change this:
root_folder=/srv/pxesrv

service_user=pxesrv
service_group=pxesrv

s1_src=http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.77.tar.gz
#s1_src=https://src.fedoraproject.org/repo/pkgs/dnsmasq/dnsmasq-2.66.tar.gz/c5eb8fb88847a5e9bf18db67c74efd47/dnsmasq-2.66.tar.gz
s2_src=https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.45.tar.gz
###################################################################################
if [ "$(id -u)" != "0" ]; then
	echo " "
	echo "PLEASE RUN THIS SCRIPT AS root_folder OR SUDO!"
	echo "---------------------------------------"
	exit
fi
##########
case $1 in

start)
echo " "
	if [ -f $root_folder/tmp/pid/pxesrv.lock ]; then
		echo "Services is running"
		echo "-------------------"
		exit
	else
		echo "Starting Lighttpd - Service for pxesrv" && sleep 1
		echo " " && echo "  PID TTY          TIME CMD"
		$root_folder/sbin/lighttpd -f $root_folder/pxe/configs/lighttpd.conf
		ps -e | grep $(cat $root_folder/tmp/pid/lighttpd.pid) 2>/dev/null
	echo " "
		echo "Starting Dnsmasq - Service for pxesrv" && sleep 1
		echo " " && echo "  PID TTY          TIME CMD"
		$root_folder/sbin/dnsmasq -x $root_folder/tmp/pid/dnsmasq.pid --conf-file=$root_folder/pxe/configs/dnsmasq.conf --dhcp-leasefile=$root_folder/pxe/dnsmasq_dhcp-leases.txt
		ps -e | grep $(cat 2>/dev/null $root_folder/tmp/pid/dnsmasq.pid) 2>/dev/null
		touch $root_folder/tmp/pid/pxesrv.lock
	fi
echo " "
;;

stop)
echo " "
	if ! [ -f $root_folder/tmp/pid/dnsmasq.pid ]; then
		echo "Dnsmasq is not running"
	else
		echo "Stopping Dnsmasq" && sleep 1
		kill -9 $(cat 2>/dev/null $root_folder/tmp/pid/dnsmasq.pid) 2>/dev/null
		rm -f $root_folder/tmp/pid/dnsmasq.pid 2>/dev/null
	fi

	if ! [ -f $root_folder/tmp/pid/lighttpd.pid ]; then
		echo "Lighttpd is not running"
	else
		echo "Stopping Lighttpd" && sleep 1
		kill -9 $(cat 2>/dev/null $root_folder/tmp/pid/lighttpd.pid) 2>/dev/null
		rm -f $root_folder/tmp/pid/lighttpd.pid 2>/dev/null
	fi
	rm -f $root_folder/tmp/pid/pxesrv.lock
	rm -f $root_folder/pxe/dnsmasq_dhcp-leases.txt
echo " "
;;

restart)
echo " "
	echo "Stopping services"
	echo "-----------------"
	$root_folder/tmp/pxesrv.sh stop >/dev/null
	$root_folder/tmp/pxesrv.sh start
;;

status)
echo " "
	if ! [ -f $root_folder/tmp/pid/pxesrv.lock ]; then
		echo "Services is not running"
		echo "-----------------------"
		exit
	else
		echo "Pidfiles located in: $root_folder/tmp/pid"
		echo " " && echo "Displaying runing processes:"
	echo " "
		echo "  PID TTY          TIME CMD"
		ps -e | grep $(cat 2>/dev/null $root_folder/tmp/pid/dnsmasq.pid) 2>/dev/null
		ps -e | grep $(cat 2>/dev/null $root_folder/tmp/pid/lighttpd.pid) 2>/dev/null
	fi
echo " "
;;

leases)
echo " "
	if ! [ -f $root_folder/tmp/pid/dnsmasq.pid ]; then
		echo "Dnsmasq is not running"
		echo "----------------------"
		exit
	else
		echo "DNSMASQ: ACTIVE DHCP LEASES"
		cat $root_folder/pxe/dnsmasq_dhcp-leases.txt
	fi
echo " "
;;

perm)
	chown -R $root_user:$root_group $root_folder
	chown -R $service_user:$service_group $root_folder/pxe $root_folder/share 2>/dev/null
	find $root_folder -type d -exec chmod 0755 {} \;
	find $root_folder -type f -exec chmod 0764 {} \;
	chmod -R 775 $root_folder/pxe/pxe-boot
	chmod -R 775 $root_folder/tmp
;;

make_s1)
echo " "
$root_folder/tmp/pxesrv.sh stop >/dev/null
rm -rf $root_folder/tmp/src/build >/dev/null
	if [ -f $root_folder/sbin/dnsmasq ]; then
		echo "Service dnsmasq used by pxesrv is installed"
		echo "-------------------------------------------"
		exit
	fi
	mkdir -p $root_folder/tmp/src/build
		cd $root_folder/tmp/src && wget -O dnsmasq.tar.gz $s1_src 2>/dev/null
		cd $root_folder/tmp/src && tar -zxf dnsmasq.tar.gz -C $root_folder/tmp/src/build 2>/dev/null
		cd $root_folder/tmp/src/build/dnsmasq*
		
			mv Makefile Makefile.bak
	echo "PREFIX        = $root_folder" > Makefile
			tail -n +22 Makefile.bak >> Makefile
		make && make install && cd $root_folder
		rm -rf $root_folder/tmp/src/build
	echo " "
	echo "Dnsmasq compiled and installed"
	echo "------------------------------"
;;

make_s2)
echo " "
$root_folder/tmp/pxesrv.sh stop >/dev/null
rm -rf $root_folder/tmp/src/build >/dev/null
	if [ -f $root_folder/sbin/lighttpd ]; then
		echo "Service lighttpd used by pxesrv is installed"
		echo "--------------------------------------------"
		exit
	fi
	mkdir -p $root_folder/tmp/src/build
		cd $root_folder/tmp/src && wget -O lighttpd.tar.gz $s2_src 2>/dev/null
		cd $root_folder/tmp/src && tar -zxf lighttpd.tar.gz -C $root_folder/tmp/src/build 2>/dev/null
		cd $root_folder/tmp/src/build/lighttpd*
		./configure --prefix=$root_folder --exec-prefix=$root_folder --mandir=$root_folder/share --libdir=$root_folder/lib --sbindir=$root_folder/sbin
		make && make install && cd $root_folder
		mkdir -p $root_folder/share/log
		rm -rf $root_folder/tmp/src/build
	echo " "
	echo "Lighttpd compiled and installed"
	echo "-------------------------------"
;;

finalize)
echo " "
	cd $root_folder/tmp/src
	mkdir -p $root_folder/tmp/pid
	echo "Finalizing installation"
	
	useradd -r -U -c "pxesrv" -d $root_folder -s /bin/false pxesrv 2>/dev/null
	cp -Ru $root_folder/tmp/files/pxe $root_folder
	
	rm $root_folder/tmp/src/syslinux-4.07.tar.gz >/dev/null
	wget https://www.kernel.org/pub/linux/utils/boot/syslinux/4.xx/syslinux-4.07.tar.gz
	tar -zxf $root_folder/tmp/src/syslinux-4.07.tar.gz -C $root_folder/pxe/pxe-boot/tftp
	cp $root_folder/pxe/pxe-boot/tftp/syslinux-4.07/gpxe/gpxelinux.0 $root_folder/pxe/pxe-boot/tftp

	$root_folder/tmp/pxesrv.sh perm
	ln -sf $root_folder/tmp/pxesrv.sh /usr/local/sbin/pxesrv
	cp -f $root_folder/tmp/init-pxesrv.sh /etc/init.d/init-pxesrv
	chmod 764 /etc/init.d/init-pxesrv 2>/dev/null

echo " "
	echo "Script by: www.leemann.se/fredrik"
echo " "
;;

remove_all)
echo " "
	if [ -f $root_folder/tmp/pid/pxesrv.lock ]; then
		echo "Services is running"
		echo "-------------------"
		exit
	fi
		cd $root_folder
		rm -rf lib sbin share 2>/dev/null
		chkconfig init-pxesrv off 2>/dev/null
		chkconfig --del init-pxesrv 2>/dev/null
		update-rc.d -f init-pxesrv remove 2>/dev/null
		unlink /usr/local/sbin/pxesrv 2>/dev/null
		rm -f /etc/init.d/init-pxesrv 2>/dev/null
		
		$root_folder/tmp/pxesrv.sh perm
		chmod -R 777 $root_folder/tmp
		rm -f $root_folder/tmp/src/*
		chmod 777 $root_folder
	echo "Uninstall complete"
echo " "
;;

*)
	echo " "
	echo "Arguments: start|stop|restart|status|leases|perm|make_s1|make_s2|finalize|remove_all"
	echo "------------------------------------------------------------------------------------"
;;

esac
exit