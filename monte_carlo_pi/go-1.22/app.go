package main

import (
	"fmt"
	"math"
	"math/rand"
)

func approxPi(throws int) float64 {
	inside := 0
	for i := 0; i < throws; i++ {
		x := rand.Float64()
		y := rand.Float64()
		if math.Hypot(x, y) <= 1.0 {
			inside++
		}
	}
	return 4.0 * float64(inside) / float64(throws)
}

func main() {
	for _, n := range []int{1000, 10000, 100000, 1000000, 10000000} {
		fmt.Printf("%8d samples: PI = %v\n", n, approxPi(n))
	}
}
