import os

fn solve(mut board [][]int) bool {
	row, col := find_empty(board) or { return true }
	for num in 1 .. 10 {
		if is_valid(board, row, col, num) {
			board[row][col] = num
			if solve(mut board) {
				return true
			}
			board[row][col] = 0
		}
	}
	return false
}

fn find_empty(board [][]int) ?(int, int) {
	for i in 0 .. 9 {
		for j in 0 .. 9 {
			if board[i][j] == 0 {
				return i, j
			}
		}
	}
	return none
}

fn is_valid(board [][]int, row int, col int, num int) bool {
	for i in 0 .. 9 {
		if board[row][i] == num || board[i][col] == num {
			return false
		}
	}
	br := (row / 3) * 3
	bc := (col / 3) * 3
	for i in br .. br + 3 {
		for j in bc .. bc + 3 {
			if board[i][j] == num {
				return false
			}
		}
	}
	return true
}

fn parse_puzzle(line string) [][]int {
	mut board := [][]int{len: 9, init: []int{len: 9}}
	for i in 0 .. 81 {
		board[i / 9][i % 9] = int(line[i] - u8(`0`))
	}
	return board
}

fn board_to_string(board [][]int) string {
	mut result := ''
	for row in board {
		for d in row {
			result += d.str()
		}
	}
	return result
}

fn main() {
	lines := os.read_lines('sudoku.txt') or { panic(err) }
	for _ in 0 .. 10 {
		for line in lines {
			trimmed := line.trim_space()
			if trimmed.len >= 81 {
				mut board := parse_puzzle(trimmed)
				solve(mut board)
				println(board_to_string(board))
			}
		}
	}
}
