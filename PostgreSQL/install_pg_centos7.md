# centos7 安装Postgresql使用yum安装
* 安装数据库
```bash
# yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
# yum install -y postgresql11-server postgresql11-contrib
```
* 初始化数据库
```bash
# /usr/pgsql-11/bin/postgresql-11-setup initdb
```
* 启动数据库
```bash
# systemct enable postgresql-11
# systemctl start postgresql-11
```
* 配置可以远程连接postgresql数据库
```bash
vim /var/lib/pgsql/11/data/postgresql.conf
....
listen_addresses = '*'  # modified "localhost" to "*"
port = 5432 # 默认是5432
# 如果想对所有IP开放，则将localhost改为*即可，如果想仅对部分IP开放，多个IP之间用,（逗号+空格）隔开
```
* 配置账户访问权限
```bash
vim /var/lib/pgsql/11/data/pg_hba.conf
82行处,放行内网访问
host    all             all             192.168.0.0/16            ident
```
* 为数据库postgres用户配置密码
```bash
# su - postgres
-bash-4.2$ psql -U postgres
postgres=# alter user postgres with encrypted password 'xxxxx';
ostgres=# \q
-bash-4.2$ exit
```
* 重启数据库配置生效
```bash
systemctl restart postgresql-11
```
* 再次登陆验证
```bash
# su - postgres
-bash-4.2$ psql -U postgres --port=15432
psql (11.4)
Type "help" for help.

postgres=# 
``` 
