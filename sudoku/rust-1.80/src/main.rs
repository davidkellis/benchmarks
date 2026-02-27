use std::fs;

fn solve(board: &mut [[u8; 9]; 9]) -> bool {
    if let Some((row, col)) = find_empty(board) {
        for num in 1..=9 {
            if is_valid(board, row, col, num) {
                board[row][col] = num;
                if solve(board) { return true; }
                board[row][col] = 0;
            }
        }
        false
    } else {
        true
    }
}

fn find_empty(board: &[[u8; 9]; 9]) -> Option<(usize, usize)> {
    for i in 0..9 {
        for j in 0..9 {
            if board[i][j] == 0 { return Some((i, j)); }
        }
    }
    None
}

fn is_valid(board: &[[u8; 9]; 9], row: usize, col: usize, num: u8) -> bool {
    for i in 0..9 {
        if board[row][i] == num || board[i][col] == num { return false; }
    }
    let br = (row / 3) * 3;
    let bc = (col / 3) * 3;
    for i in br..br+3 {
        for j in bc..bc+3 {
            if board[i][j] == num { return false; }
        }
    }
    true
}

fn parse_puzzle(line: &str) -> [[u8; 9]; 9] {
    let mut board = [[0u8; 9]; 9];
    for (i, ch) in line.chars().take(81).enumerate() {
        board[i / 9][i % 9] = ch.to_digit(10).unwrap_or(0) as u8;
    }
    board
}

fn board_to_string(board: &[[u8; 9]; 9]) -> String {
    board.iter().flat_map(|r| r.iter()).map(|&d| (b'0' + d) as char).collect()
}

fn main() {
    let content = fs::read_to_string("sudoku.txt").unwrap();
    let lines: Vec<&str> = content.lines().filter(|l| l.trim().len() >= 81).collect();
    for _ in 0..10 {
        for line in &lines {
            let mut board = parse_puzzle(line.trim());
            solve(&mut board);
            println!("{}", board_to_string(&board));
        }
    }
}
