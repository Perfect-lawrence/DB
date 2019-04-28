#!/bin/bash
rs=0
case $1 in
        version)
        redis_version=$(awk -F":" '{if($1=="redis_version"){print $2}}'  /app/redis_master/monitor_redis/Server.txt)
        echo $redis_version
        ;;
        uptime_in_days)
        uptime_in_days=$(awk -F":" '{if($1=="uptime_in_days"){print $2}}'  /app/redis_master/monitor_redis/Server.txt)
        echo $uptime_in_days
        ;;
        tcp_port)
        tcp_port=$(awk -F":" '{if($1=="tcp_port"){print $2}}'  /app/redis_master/monitor_redis/Server.txt)
        echo $tcp_port
        ;;
        connected_clients)
        connected_clients=$(awk -F":" '{if($1=="connected_clients"){print $2}}'  /app/redis_master/monitor_redis/Clients.txt)
        echo $connected_clients
        ;;
        slave0_status)
        slave0_status=$(awk -F":" '{if($1=="slave0"){print $2}}' /app/redis_master/monitor_redis/Replication.txt|cut -f1-3 -d ',')
        echo $slave2_status
        ;;
        slave1_status)
        slave1_status1=$(awk -F":" '{if($1=="slave1"){print $2}}' /app/redis_master/monitor_redis/Replication.txt|cut -f1-3 -d ',')
        echo $slave1_status1
        ;;
        role)
        role=$(awk -F":" '{if($1=="role"){print $2}}'  /app/redis_master/monitor_redis/Replication.txt)
        echo $role
        ;;
        connected_slaves)
        connected_slaves=$(awk -F":" '{if($1=="connected_slaves"){print $2}}'  /app/redis_master/monitor_redis/Replication.txt)
        echo $connected_slaves
        ;;
        rejected_connections)
        rejected_connections=$(awk -F":" '{if($1=="rejected_connections"){print $2}}'  /app/redis_master/monitor_redis/Stats.txt)
        echo $rejected_connections
        ;;
        *|-h|--help)
                echo $"Useage:$0 {version|uptime_in_days|tcp_port|connected_clients|slave0_status|slave1_status|role|connected_slaves|rejected_connections}"
        ;;

esac
exit $rs

