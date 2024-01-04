// Taken from https://github.com/kostya/benchmarks/blob/master/json/test.go

package main

import (
	"fmt"
	"io/ioutil"
	"math/rand"
	"sort"
	"strconv"
	"strings"
)

func partition(a sort.Interface, first int, last int, pivotIndex int) int {
	a.Swap(first, pivotIndex) // move it to beginning
	left := first + 1
	right := last
	for left <= right {
		for left <= last && a.Less(left, first) {
			left++
		}
		for right >= first && a.Less(first, right) {
			right--
		}
		if left <= right {
			a.Swap(left, right)
			left++
			right--
		}
	}
	a.Swap(first, right) // swap into right place
	return right
}

func quicksortHelper(a sort.Interface, first int, last int) {
	if first >= last {
		return
	}
	pivotIndex := partition(a, first, last, rand.Intn(last-first+1)+first)
	quicksortHelper(a, first, pivotIndex-1)
	quicksortHelper(a, pivotIndex+1, last)
}

func quicksort(a sort.Interface) {
	quicksortHelper(a, 0, a.Len()-1)
}

func main() {
	b, err := ioutil.ReadFile("./numbers.txt")
	if err != nil {
		panic(err)
	}

	str := strings.TrimSpace(string(b))
	numbers := strings.Split(str, ",")
	ints := []int{}
	for _, n := range numbers {
		i, _ := strconv.ParseInt(n, 10, 32)
		ints = append(ints, int(i))
	}

	intSlice := sort.IntSlice(ints)
	quicksort(intSlice)

	for i := 0; i < 10; i++ {
		fmt.Printf("%v\n", intSlice[i])
	}
	for i := len(intSlice) - 10; i < len(intSlice); i++ {
		fmt.Printf("%v\n", intSlice[i])
	}
}
