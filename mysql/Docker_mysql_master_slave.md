# Docker部署MySQL主从
* 1 首先要有Docker环境和mysql镜像
* 2 创建一个docker网络

```bash
docker network create master_slave

```
* 3 准备好主从配置文件

```markdown
# /data/master_conf/master_my.cnf
[client]
default-character-set=utf8
port            = 3306
socket          = /var/run/mysqld/mysqld.sock

[mysql]
auto-rehash
default-character-set=utf8

[mysqld_safe]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
nice            = 0

[mysqld]
user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
server-id       =  100
log-bin         = mysql-bin
binlog_format   = ROW
sync_binlog     = 1
log_slave_updates=1
#gtid_mode       = ON
#enforce_gtid_consitency = ON
log_bin_trust_function_creators=1
skip-host-cache
skip-name-resolve



port            = 3306
basedir         = /usr
datadir         = /var/lib/mysql
tmpdir          = /tmp
lc-messages-dir = /usr/share/mysql
explicit_defaults_for_timestamp
innodb_buffer_pool_size = 256M
join_buffer_size = 128M
sort_buffer_size = 20M
read_rnd_buffer_size = 64M
lower_case_table_names=1
max_allowed_packet=500M
wait_timeout=200000
interactive_timeout=200000

init_connect='SET collation_connection = utf8_unicode_ci'
init_connect='SET NAMES utf8'
character-set-server=utf8
collation-server=utf8_unicode_ci
skip-character-set-client-handshake

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

symbolic-links=0

```
```markdown
# /data/slave_conf/slave_my.cnf
[client]
default-character-set=utf8
port            = 3306
socket          = /var/run/mysqld/mysqld.sock

[mysql]
auto-rehash
default-character-set=utf8

[mysqld_safe]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
nice            = 0

[mysqld]
user            = mysql
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
server-id       = 101
log-bin         = mysql-slave-bin
binlog_format   = ROW
log_slave_updates=1
skip-host-cache
skip-name-resolve
relay_log       = mysql-relay-bin
port            = 3306
basedir         = /usr
datadir         = /var/lib/mysql
tmpdir          = /tmp
lc-messages-dir = /usr/share/mysql
explicit_defaults_for_timestamp
innodb_buffer_pool_size = 256M
join_buffer_size = 128M
sort_buffer_size = 20M
read_rnd_buffer_size = 64M
lower_case_table_names=1
max_allowed_packet=500M
wait_timeout=200000
interactive_timeout=200000

init_connect='SET collation_connection = utf8_unicode_ci'
init_connect='SET NAMES utf8'
character-set-server=utf8
collation-server=utf8_unicode_ci
skip-character-set-client-handshake

sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

symbolic-links=0

```
* 创建好容器目录映射到宿主机的相关目录

```bash
mkdir -pv /data/{master_data,slave_data,master_conf,slave_conf}
```
* 先登陆docker公有仓库，建议用阿里云docker仓库，国内比较快，都是要注册一个账号的，拉取mysql镜像文件


```bash
docker login 
username: 1432qazd
password: lawrence_docker_2017

docker pull mysql:5.6.35

```

* 启动master库容器
 
```bash
docker container run -itd --rm --name master --network master_slave -e MYSQL_ROOT_PASSWORD=1qaz_WSX  -p 23306:3306 -v /data/master_conf/:/etc/mysql/conf.d -v /data/master_data/:/var/lib/mysql mysql:5.6.35

```
*  查看是否启动成功并且登录数据库

```bash
docker container ps -l
docker container exec -it master bash
mysql -uroot -h127.0.0.1 --port=3306 -p


```
* 退出容器

```markdown
ctrl + p + q
```

* 查看容器的IP地址


```bash
# master IP adderss

docker container inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' master

172.18.0.2

# slave IP address
docker container inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' slave

172.18.0.3

# master IP adderss
docker container inspect master|grep IPAddress

"IPAddress": "172.18.0.2"

# slave IP address
docker container inspect slave|grep IPAddress

"IPAddress": "172.18.0.3"

```

* 登录主库，创建主从同步账号

```
docker container exec -it master bash
mysql -uroot -h127.0.0.1 --port=3306 -p 

grant replication slave on *.* to 'repl'@'172.18.0.3' identified by 'slave_123';
flush  privileges;
show master status;

mysql-bin.000004 |      407

```
* 登录从库 操作

```bash
docker container exec -it bash
mysql -uroot -h127.0.0.1 --port=3306 -p

CHANGE MASTER TO
MASTER_HOST='172.18.0.2',
MASTER_USER='repl',
MASTER_PASSWORD='slave_123',
MASTER_PORT=3306,
MASTER_LOG_FILE='mysql-bin.000004',
MASTER_LOG_POS=407,
MASTER_CONNECT_RETRY=10;

start slave;

show slave status\G;
....
   Slave_IO_Running: Yes  // IO进程正常
   Slave_SQL_Running: Yes   // SQL进程正常
....

```

* 退出容器

```markdown
ctrl + p + q
```
 
* 验证在主库创建一个库能否同步到从库

```sql
docker container exec -it master bash
mysql -uroot -h127.0.0.1 --port=3306 -p

create database if not exists xx_db  default character set utf8;

```

