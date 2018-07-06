package main

import (
	"fmt"
)

func fib(n int32) int32 {
	if n <= 2 {
		return 1
	}

	return fib(n-1) + fib(n-2)
}

func main() {
	fmt.Println(fib(45))
}
