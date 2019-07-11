### MySQL主从延迟及解决办法
## 复制延迟产生原因

```markdown
1. 主库对所有DDL和DML产生binlog，binlog是顺序写，效率很高

2.  slave的I/O线程到主库取日志，效率也比较高

3. 网络抖动

4. slave的SQL线程将主库的DDL和DML操作在slave实施。DML和DDL的IO操作是随即的，不是顺序的，成本高很多，还可能存在slave上的其他查询产生lock争用的情况，由于SQL也是单线程的，所以一个DDL卡住了，需要执行很长一段事件，后续的DDL线程会等待这个DDL执行完毕之后才执行，这就导致了延时。当主库的TPS并发较高时，产生的DDL数量超过slave一个sql线程所能承受的范围，延时就产生了，除此之外，还有可能与slave的大型query语句产生了锁等待导致。

```
## 复制延迟解决方法

```markdown
1. 采用分库架构，分散写压力

2. 加入memcache、Redis、mongodb等
cache层降低mysql的读压力

3. 使用IO更好的磁盘（如SSD)

4. 优化sql语句，减少全表扫描（DML)

5. 精简slave配置，减少io使用sync_binlog在slave端设置为0；

6. logs-slave-updates配置为off，从服务器从主服务器接收到的更新不记入它的二进制日志；

7. 禁用slave的binlog;

8. 并行复制

9. MySQL5.6开始可以在从库上使用并行复制，不过是基于数据库的，不过大部分应用都是单库的，这种并行意义并不是很大；

10. MySQL5.7开始引入了组提交的并行复制，一个组提交的事务都是可以并行回放，relay log中 last_committed相同的事务（sequence_num不同）可以并发执行 MySQL 5.7开启Enhanced Multi-Threaded Slave配置： 
# slave 
	slave-parallel-type=LOGICAL_CLOCK 
	slave-parallel-workers=16 
	master_info_repository=TABLE 
	relay_log_info_repository=TABLE 
	relay_log_recovery=ON


```
