#!/bin/bash
case "$1" in
	3306) 
	mysql --user=root --host=127.0.0.1 --socket=/tmp/mysql.sock --port=3306 -p
	;;
	3307)
	mysql --user=root --host=127.0.0.1 --socket=/tmp/mysql3307.sock --port=3307 -p
	;;
	*|-h|--help)
#	echo -e "\033[32;31mPlease Input Login Database Port\033[0m"
	#echo -e "\033[40;34m$0: Please Input Login Database Port !!!\033[0m"
	echo -e "\033[40;34m$0: Please Input Login Database Port !!!\033[0m"
#	echo -e "\033[32;31mPlease Input Login Database Port\033[0m"
	RETVAL=2
esac
exit $RETVAL
