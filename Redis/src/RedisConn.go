package main

import (
	"fmt"
	"github.com/garyburd/redigo/redis"
)

func main() {
	c, err := redis.Dial("tcp", "localhost:6379")

	if err != nil {
		fmt.Println("conn redis failed", err)
		return
	}

	fmt.Println("redis conn success")

	defer c.Close()

}
// [xiangxh@paojiao src]$ go fmt RedisConn.go  # 优化代码格式
// [xiangxh@paojiao src]$ go run RedisConn.go 
// redis conn success

