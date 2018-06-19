// Taken from https://rosettacode.org/wiki/Matrix_multiplication#Go - (see 2D representation)

package main

import (
	"flag"
	"math/rand"
	"strconv"
)

func randRow(n int) []float64 {
	a := make([]float64, n)
	for i := range a {
		a[i] = rand.Float64()
	}
	return a
}

func randMatrix(n int) [][]float64 {
	rows := make([][]float64, n)
	for i := range rows {
		rows[i] = randRow(n)
	}
	return rows
}

func multiply(m1, m2 [][]float64) (m3 [][]float64, ok bool) {
	rows, cols, extra := len(m1), len(m2[0]), len(m2)
	if len(m1[0]) != extra {
		return nil, false
	}
	m3 = make([][]float64, rows)
	for i := 0; i < rows; i++ {
		m3[i] = make([]float64, cols)
		for j := 0; j < cols; j++ {
			for k := 0; k < extra; k++ {
				m3[i][j] += m1[i][k] * m2[k][j]
			}
		}
	}
	return m3, true
}

func main() {
	n := 0

	flag.Parse()
	if flag.NArg() > 0 {
		n, _ = strconv.Atoi(flag.Arg(0))
	}

	for i := 0; i < n; i++ {
		a := randMatrix(1000)
		b := randMatrix(1000)
		_, _ = multiply(a, b)
	}
}
