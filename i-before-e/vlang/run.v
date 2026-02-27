import os
import regex

fn is_valid(s string) bool {
	mut re := regex.regex_opt('c?ei') or { return true }
	mut start := 0
	for {
		match_start, match_end := re.match_string(s, start, s.len)
		if match_start < 0 {
			break
		}
		matched := s[match_start..match_end]
		if !matched.starts_with('c') {
			return false
		}
		start = match_end
	}
	return true
}

fn main() {
	path := os.args[1]
	lines := os.read_lines(path) or { panic(err) }
	for line in lines {
		if !is_valid(line) {
			println(line)
		}
	}
}
