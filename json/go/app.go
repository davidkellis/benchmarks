// Taken from https://github.com/kostya/benchmarks/blob/master/json/test.go

package main

import (
	"encoding/json"
	"fmt"
	"os"
)

type Coordinate struct {
	X, Y, Z float64
}

type TestStruct struct {
	Coordinates []Coordinate
}

func main() {
	f, err := os.Open("./sample.json")
	if err != nil {
		panic(err)
	}

	jobj := TestStruct{}
	err = json.NewDecoder(f).Decode(&jobj)
	if err != nil {
		panic(err)
	}

	x, y, z := 0.0, 0.0, 0.0
	
	for _, coord := range jobj.Coordinates {
		x += coord.X
		y += coord.Y
		z += coord.Z
	}

	len := float64(len(jobj.Coordinates))
	fmt.Printf("%.8f\n%.8f\n%.8f\n", x/len, y/len, z/len)
}