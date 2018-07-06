// Taken from https://github.com/kostya/benchmarks/blob/master/base64/test.go

package main

import "crypto/md5"
import "encoding/base64"
import "fmt"

import "strings"

func main() {
	h := md5.New()

	StrSize := 1000000
	TRIES := 20

	bytes := []byte(strings.Repeat("a", StrSize))
	str := string(bytes)
	h.Reset()
	h.Write(bytes)
	fmt.Printf("%x\n", h.Sum(nil))

	encoder := base64.StdEncoding

	for i := 0; i < TRIES; i++ {
		str = encoder.EncodeToString([]byte(str))
	}
	h.Reset()
	h.Write([]byte(str))
	fmt.Printf("%x\n", h.Sum(nil))

	for i := 0; i < TRIES; i++ {
		bytes, _ = encoder.DecodeString(str)
		str = string(bytes)
	}
	h.Reset()
	h.Write([]byte(str))
	fmt.Printf("%x\n", h.Sum(nil))
}
