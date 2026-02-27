// Taken from https://github.com/kostya/benchmarks/blob/master/matmul/go/matmul/matmul.go

// Written by Attractive Chaos; distributed under the MIT license

package main

import (
	"fmt"
	"os"
	"strconv"
)

func matgen(n int, seed float64) [][]float64 {
	a := make([][]float64, n)
	tmp := seed / float64(n) / float64(n) // pretty silly...
	for i := 0; i < n; i++ {
		a[i] = make([]float64, n)
		for j := 0; j < n; j++ {
			a[i][j] = tmp * float64(i-j) * float64(i+j)
		}
	}
	return a
}

func matmul(a [][]float64, b [][]float64) [][]float64 {
	m := len(a)
	n := len(a[0])
	p := len(b[0])
	x := make([][]float64, m)
	c := make([][]float64, p)
	for i := 0; i < p; i++ {
		c[i] = make([]float64, n)
		for j := 0; j < n; j++ {
			c[i][j] = b[j][i]
		}
	}
	for i, am := range a {
		x[i] = make([]float64, p)
		for j, cm := range c {
			s := float64(0)
			for k, m := range am {
				s += m * cm[k]
			}
			x[i][j] = s
		}
	}
	return x
}

func calc(n int) float64 {
	n = n / 2 * 2
	a := matgen(n, 1.0)
	b := matgen(n, 1.0)
	x := matmul(a, b)
	return x[n/2][n/2]
}

func main() {
	n := 100
	var err error
	if len(os.Args) > 1 {
		n, err = strconv.Atoi(os.Args[1])
		if err != nil {
			panic(err)
		}
	}
	fmt.Printf("%f\n", calc(n))
}




// // Taken from https://github.com/kostya/benchmarks/blob/master/matmul/matmul.go

// // Written by Attractive Chaos; distributed under the MIT license

// package main

// import "fmt"
// import "flag"
// import "strconv"

// func matgen(n int) [][]float64 {
// 	a := make([][]float64, n)
// 	tmp := float64(1.0) / float64(n) / float64(n) // pretty silly...
// 	for i := 0; i < n; i++ {
// 		a[i] = make([]float64, n)
// 		for j := 0; j < n; j++ {
// 			a[i][j] = tmp * float64(i-j) * float64(i+j)
// 		}
// 	}
// 	return a
// }

// func matmul(a [][]float64, b [][]float64) [][]float64 {
// 	m := len(a)
// 	n := len(a[0])
// 	p := len(b[0])
// 	x := make([][]float64, m)
// 	c := make([][]float64, p)
// 	for i := 0; i < p; i++ {
// 		c[i] = make([]float64, n)
// 		for j := 0; j < n; j++ {
// 			c[i][j] = b[j][i]
// 		}
// 	}
// 	for i, am := range a {
// 		x[i] = make([]float64, p)
// 		for j, cm := range c {
// 			s := float64(0)
// 			for k, m := range am {
// 				s += m * cm[k]
// 			}
// 			x[i][j] = s
// 		}
// 	}
// 	return x
// }

// func main() {
// 	n := int(100)
// 	flag.Parse()
// 	if flag.NArg() > 0 {
// 		n, _ = strconv.Atoi(flag.Arg(0))
// 	}
// 	a := matgen(n)
// 	b := matgen(n)
// 	x := matmul(a, b)
// 	fmt.Printf("%f\n", x[n/2][n/2])
// }

// // // Taken from https://rosettacode.org/wiki/Matrix_multiplication#Go - (see 2D representation)

// // package main

// // import (
// // 	"flag"
// // 	"math/rand"
// // 	"strconv"
// // )

// // func randRow(n int) []float64 {
// // 	a := make([]float64, n)
// // 	for i := range a {
// // 		a[i] = rand.Float64()
// // 	}
// // 	return a
// // }

// // func randMatrix(n int) [][]float64 {
// // 	rows := make([][]float64, n)
// // 	for i := range rows {
// // 		rows[i] = randRow(n)
// // 	}
// // 	return rows
// // }

// // func multiply(m1, m2 [][]float64) (m3 [][]float64, ok bool) {
// // 	rows, cols, extra := len(m1), len(m2[0]), len(m2)
// // 	if len(m1[0]) != extra {
// // 		return nil, false
// // 	}
// // 	m3 = make([][]float64, rows)
// // 	for i := 0; i < rows; i++ {
// // 		m3[i] = make([]float64, cols)
// // 		for j := 0; j < cols; j++ {
// // 			for k := 0; k < extra; k++ {
// // 				m3[i][j] += m1[i][k] * m2[k][j]
// // 			}
// // 		}
// // 	}
// // 	return m3, true
// // }

// // func main() {
// // 	n := 0

// // 	flag.Parse()
// // 	if flag.NArg() > 0 {
// // 		n, _ = strconv.Atoi(flag.Arg(0))
// // 	}

// // 	for i := 0; i < n; i++ {
// // 		a := randMatrix(1000)
// // 		b := randMatrix(1000)
// // 		_, _ = multiply(a, b)
// // 	}
// // }
