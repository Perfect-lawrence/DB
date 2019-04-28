#!/bin/bash

rs=0
case $1 in 
	version)
	redis_version=$(awk -F":" '{if($1=="redis_version"){print $2}}'  /cron/monitor/monitor_redis/Server.txt)
	echo $redis_version
	;;
	uptime_in_days)
	uptime_in_days=$(awk -F":" '{if($1=="uptime_in_days"){print $2}}'  /cron/monitor/monitor_redis/Server.txt)
	echo $uptime_in_days
	;;
	tcp_port)
	tcp_port=$(awk -F":" '{if($1=="tcp_port"){print $2}}'  /cron/monitor/monitor_redis/Server.txt)
	echo $tcp_port
	;;
	connected_clients)
	connected_clients=$(awk -F":" '{if($1=="connected_clients"){print $2}}'  /cron/monitor/monitor_redis/Clients.txt)
	echo $connected_clients
	;;
	slave0_status)
	slave0_status=$(awk -F":" '{if($1=="slave0"){print $2}}' /cron/monitor/monitor_redis/Replication.txt|cut -f1-3 -d ',')
	echo $slave0_status
	;;
	slave1_status) # 
	slave1_status1=$(awk -F":" '{if($1=="slave1"){print $2}}' /cron/monitor/monitor_redis/Replication.txt|cut -f1-3 -d ',')
	echo $slave1_status1
	;;
	role) #当前实例的角色master还是slave
	role=$(awk -F":" '{if($1=="role"){print $2}}'  /cron/monitor/monitor_redis/Replication.txt)
	echo $role
	;;
	connected_slaves)
	connected_slaves=$(awk -F":" '{if($1=="connected_slaves"){print $2}}'  /cron/monitor/monitor_redis/Replication.txt)
	echo $connected_slaves
	;;
	rejected_connections)
	rejected_connections=$(awk -F":" '{if($1=="rejected_connections"){print $2}}'  /cron/monitor/monitor_redis/Stats.txt)
	echo $rejected_connections
	;;
	used_memory_human)
	used_memory_human=$(awk -F":" '{if($1=="used_memory_human"){print $2}}' /cron/monitor/monitor_redis/Memory.txt)
	echo $used_memory_human
	;;
	used_memory_rss_human)
	used_memory_rss_human=$(awk -F":" '{if($1=="used_memory_rss_human"){print $2}}' /cron/monitor/monitor_redis/Memory.txt)
	echo $used_memory_rss_human
	;;
	used_memory_peak_human)
	used_memory_peak_human=$(awk -F":" '{if($1=="used_memory_peak_human"){print $2}}' /cron/monitor/monitor_redis/Memory.txt)
	echo $used_memory_peak_human
	;;
	used_memory_dataset_perc)
	used_memory_dataset_perc=$(awk -F":" '{if($1=="used_memory_dataset_perc"){print $2}}' /cron/monitor/monitor_redis/Memory.txt)
	echo $used_memory_dataset_perc
	;;
	maxmemory_human) # 
	maxmemory_human=$(awk -F":" '{if($1=="maxmemory_human"){print $2}}' /cron/monitor/monitor_redis/Memory.txt)
	echo $maxmemory_human
	;;
	lazyfree_pending_objects)
	lazyfree_pending_objects=$(awk -F":" '{if($1=="lazyfree_pending_objects"){print $2}}' /cron/monitor/monitor_redis/Memory.txt)
	echo $lazyfree_pending_objects
	;;
	
	*|-h|--help)
		echo $"Useage: $0 {version|uptime_in_days|tcp_port|connected_clients|slave0_status|slave1_status|role|connected_slaves|rejected_connections|......}"
		exit 2
	
esac
exit $rs
