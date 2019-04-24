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

	_, err = c.Do("MSet", "Redis_Mset1", 200, "Redis_Mset2", 300)
	if err != nil {
		fmt.Println(err)
		return
	}

	r, err := redis.Ints(c.Do("MGet", "Redis_Mset1", "Redis_Mset2"))

	if err != nil {
		fmt.Println("MGet Redis_Mset1 or Redis_Mset2 failed", err)
		return
	}

	for _, v := range r {
		fmt.Println(v)
	}

}

// 127.0.0.1:6379> mget Redis_Mset1 Redis_Mset2
// 1) "200"
// 2) "300"
