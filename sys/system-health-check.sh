#!/usr/bin/env bash

# system-health-check.sh


# Status page
status_page=/var/www/system-health-check.html


# Enable / Disable Checks
memory_check=off
swap_check=on
load_check=on
storage_check=on
process_check=on
replication_check=off
http_content_check=off


# Configure partitions for storage check
partitions=( / )


# Configure process(es) to check
process_names=( httpd mysqld postfix )


# Configure HTTP Content Check
site=www.example.com
search_string="CHANGEME"


# Configure Thresholds
memory_threshold=99
swap_threshold=80
load_threshold=10
storage_threshold=80


# Logging Metrics - Linux

if [ `uname` = Linux ]; then

load_alarm=`/usr/bin/uptime | awk -F'load average:' '{ print $2}' | sed 's/\./ /g' | awk '{print $1}'`
memory_alarm=`/usr/bin/free -m | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d\. -f1`
swap_alarm=`/usr/bin/free -m | grep Swap | awk '{print $3/$2 * 100.0}' | cut -d\. -f1`
Slave_IO_Running=`/usr/bin/mysql -Bse "show slave status\G" | grep Slave_IO_Running | awk '{ print $2 }'`
Slave_SQL_Running=`/usr/bin/mysql -Bse "show slave status\G" | grep Slave_SQL_Running | awk '{ print $2 }'`
Last_error=`/usr/bin/mysql -Bse "show slave status\G" | grep Last_error | awk -F \: '{ print $2 }'`
http_content_check_alarm=`/usr/bin/curl -sLH "host: $site" localhost | grep "$search_string" |wc -l`


# Logging Metrics - FreeBSD

elif [ `uname` = FreeBSD ]; then

if [ ! -f `which bc` ]; then
	echo "Please install bc, or disable memory check"
	exit
fi

load_alarm=`/usr/bin/uptime | awk -F'load averages:' '{ print $2}' | sed 's/\./ /g' | awk '{print $1}'`
memory_physmem=`/sbin/sysctl -n hw.physmem`
memory_active=`/sbin/sysctl -n vm.stats.vm.v_active_count`
memory_pagesize=`/sbin/sysctl -n hw.pagesize`
memory_alarm=`echo "($memory_active * $memory_pagesize / 1024) / ($memory_physmem / 1024) * 100" |bc -l |cut -d\. -f1`
swap_alarm=`/usr/sbin/swapinfo -h | grep -v Device | awk '{print $5}' | sed -e 's/\%//g'`
Slave_IO_Running=`/usr/local/bin/mysql -Bse "show slave status\G" | grep Slave_IO_Running | awk '{ print $2 }'`
Slave_SQL_Running=`/usr/local/bin/mysql -Bse "show slave status\G" | grep Slave_SQL_Running | awk '{ print $2 }'`
Last_error=`/usr/local/bin/mysql -Bse "show slave status\G" | grep Last_error | awk -F \: '{ print $2 }'`
http_content_check_alarm=`/usr/local/bin/curl -sLH "host: $site" localhost | grep "$search_string" |wc -l`


else
	echo "Cannot detect OS version!  Exit"
	exit
fi


# Clear status page and initialize variable

> $status_page
ok=1


# Memory Check

if [ $memory_check = on ]; then
	if [ $memory_alarm -ge $memory_threshold ]; then
        	echo "CRITICAL : Memory usage of $memory_alarm% detected." >> $status_page
        	ok=0
	fi
fi


# Swap Check

if [ $swap_check = on ]; then
	if [ $swap_alarm -ge $swap_threshold ]; then
        	echo "CRITICAL : Swap usage of $swap_alarm% detected." >> $status_page
        	ok=0
	fi
fi


# Load Check

if [ $load_check = on ]; then
	if [ $load_alarm -ge 10 ]; then
        	echo "CRITICAL : Load Average of $load_alarm detected." >> $status_page
        	ok=0
	fi
fi


# Storage Check

if [ $storage_check = on ]; then
	for i in ${partitions[@]}; do
		disk_alarm=`/bin/df -h $i | tail -1 |awk '{print $5}' | sed -e 's/\%//g'`
		diskused=`/bin/df -h $i | tail -1 | awk '{print $3}'`
		diskmax=`/bin/df -h $i | tail -1 | awk '{print $2}'`
			if [ $disk_alarm -ge $storage_threshold ]; then
        			echo "CRITICAL : $i currently at $disk_alarm% capacity." >> $status_page
				ok=0
			fi
	done;
fi


# Process Check

if [ $process_check = on ]; then
	for i in ${process_names[@]}; do
		check=`ps ax |grep -v grep | grep -c $i`
		if [ $check = 0 ]; then
			echo "CRITICAL : $i not running!" >> $status_page
			ok=0
		fi;
	done	
fi


# Replication Check

if [ $replication_check = on ]; then

	if [ -z $Slave_IO_Running -o -z $Slave_SQL_Running ] ; then
        	echo "CRITICAL : Replication is not configured or you do not have the required access to MySQL" >> $status_page
		ok=0
	fi

	if [ $Slave_SQL_Running = 'No' ] ; then
       		echo "CRITICAL : Replication SQL thread not running on server `hostname -s`!" >> $status_page
        	echo "Last Error: $Last_error" >> $status_page
		ok=0
	fi

	if [ $Slave_IO_Running = 'No' ] ; then
        	echo "CRITICAL : Replication LOG IO thread not running on server `hostname -s`!" >> $status_page
        	echo "Last Error:" $Last_error >> $status_page
		ok=0
	fi
fi


# HTTP Content Check

if [ $http_content_check = on ]; then

        if [ ! $http_content_check_alarm -ge '1' ]; then
                echo "CRITICAL : HTTP Content Check for $site!" >> $status_page
                ok=0
        fi
fi
	

# Change status page if anything failed

if [ $ok = 1 ]; then
	echo "OK" >> $status_page
fi