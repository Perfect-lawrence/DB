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
	defer c.Close()
	_, err = c.Do("expire", "Redis_Set", 10)
	if err != nil {
		fmt.Println(err)
		return
	}

}

/*
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
"100"
127.0.0.1:6379> get Redis_Set
(nil)
127.0.0.1:6379> get Redis_Set
(nil)
127.0.0.1:6379>
*/
