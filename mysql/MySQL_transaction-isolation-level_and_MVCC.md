我们需要创建一个表:
====
```
Create Table: CREATE TABLE `t` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```
- 然后向这个表里插入一条数据:

```
INSERT INTO t VALUES(1, '测试');
```
- 现在表里的数据就是这样的：

```
mysql> INSERT INTO t VALUES(1, '测试');
Query OK, 1 row affected (0.04 sec)

mysql> SELECT * FROM t;
+----+--------+
| id | name   |
+----+--------+
|  1 | 测试   |
+----+--------+
1 row in set (0.00 sec)

```
# 隔离级别


