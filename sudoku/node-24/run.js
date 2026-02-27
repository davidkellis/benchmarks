const fs = require("fs");

function solve(board) {
  const empty = findEmpty(board);
  if (!empty) return true;
  const [row, col] = empty;
  for (let num = 1; num <= 9; num++) {
    if (isValid(board, row, col, num)) {
      board[row][col] = num;
      if (solve(board)) return true;
      board[row][col] = 0;
    }
  }
  return false;
}

function findEmpty(board) {
  for (let i = 0; i < 9; i++)
    for (let j = 0; j < 9; j++)
      if (board[i][j] === 0) return [i, j];
  return null;
}

function isValid(board, row, col, num) {
  for (let i = 0; i < 9; i++) {
    if (board[row][i] === num) return false;
    if (board[i][col] === num) return false;
  }
  const br = Math.floor(row / 3) * 3, bc = Math.floor(col / 3) * 3;
  for (let i = br; i < br + 3; i++)
    for (let j = bc; j < bc + 3; j++)
      if (board[i][j] === num) return false;
  return true;
}

function parsePuzzle(line) {
  const board = [];
  for (let i = 0; i < 9; i++) {
    board[i] = [];
    for (let j = 0; j < 9; j++) {
      board[i][j] = parseInt(line[i * 9 + j]);
    }
  }
  return board;
}

function boardToString(board) {
  return board.map(r => r.join("")).join("");
}

const lines = fs.readFileSync("sudoku.txt", "utf8").trim().split("\n");
for (let iter = 0; iter < 10; iter++) {
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed.length >= 81) {
      const board = parsePuzzle(trimmed);
      solve(board);
      console.log(boardToString(board));
    }
  }
}
