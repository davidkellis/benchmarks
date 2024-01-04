package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strings"
)

func main() {
	path := os.Args[1]
	file, err := os.Open(path)

	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	pattern := regexp.MustCompile(`c?ei`)

	for scanner.Scan() {
		if !isValid(scanner.Text(), pattern) {
			fmt.Println(scanner.Text())
		}
	}
}

func isValid(s string, pattern *regexp.Regexp) bool {
	captures := pattern.FindAllString(s, -1)

	for _, capture := range captures {
		if !strings.HasPrefix(capture, "c") {
			return false
		}
	}
	return true
}
