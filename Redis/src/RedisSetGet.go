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

	_, err = c.Do("Set", "Redis_Set", 100)
	if err != nil {
		fmt.Println(err)
		return
	}

	r, err := redis.Int(c.Do("Get", "Redis_Set"))
	if err != nil {
		fmt.Println("Get Redis_Set failed", err)
		return
	}

	fmt.Println(r)

}

// 127.0.0.1:6379> get Redis_Set
// "100"
