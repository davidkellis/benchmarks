// Taken from https://github.com/JuliaLang/Microbenchmarks/blob/master/perf.go

// Implementation of the Julia benchmark suite in Go.
//
// Three gonum packages must be installed, and then an additional environment
// variable must be set to use the BLAS installation.
// To install the gonum packages, run:
// 		go get github.com/gonum/blas
//		go get github.com/gonum/matrix/mat64
//		go get github.com/gonum/stat
// The cgo ldflags must then be set to use the BLAS implementation. As an example,
// download OpenBLAS to ~/software
//		git clone https://github.com/xianyi/OpenBLAS
// 		cd OpenBLAS
//		make
// Then edit the enivorment variable to have
// 		export CGO_LDFLAGS="-L/$HOME/software/OpenBLAS -lopenblas"
package main

import (
	"flag"
	"math/rand"
	"strconv"

	"gonum.org/v1/gonum/mat"
	// "github.com/gonum/blas/blas64"
	// "github.com/gonum/blas/cgo"
	// "github.com/gonum/matrix/mat64"
	// "github.com/gonum/stat"
)

func init() {
	// Use the BLAS implementation specified in CGO_LDFLAGS. This line can be
	// commented out to use the native Go BLAS implementation found in
	// github.com/gonum/blas/native.
	//blas64.Use(cgo.Implementation{})

	// These are here so that toggling the BLAS implementation does not make imports unused
	// _ = cgo.Implementation{}
	// _ = blas64.General{}
}

func randmatmul(n int) *mat.Dense {
	aData := make([]float64, n*n)
	for i := range aData {
		aData[i] = rand.Float64()
	}
	a := mat.NewDense(n, n, aData)

	bData := make([]float64, n*n)
	for i := range bData {
		bData[i] = rand.Float64()
	}
	b := mat.NewDense(n, n, bData)
	var c mat.Dense
	c.Mul(a, b)
	return &c
}

func main() {
	n := 0

	flag.Parse()
	if flag.NArg() > 0 {
		n, _ = strconv.Atoi(flag.Arg(0))
	}

	for i := 0; i < n; i++ {
		_ = randmatmul(1000)
	}
}
