# matrixmultiply Benchmark

This benchmark calculates the product of two 1000x1000 element matrices using the standard iterative matrix multiplication algorithm described at https://en.wikipedia.org/wiki/Matrix_multiplication_algorithm#Iterative_algorithm.

### Implementation

An implementation of this benchmark should be defined as in the following pseudocode function definition:

```
// Assume the index operator (i.e. []) is 1-based instead of 0-based
// Assume a is an nxm matrix (n rows and m columns), and b is an mxp (m rows and p columns) matrix
// Also assume a and b are arrays of arrays, where the outer arrays represent rows, and the inner arrays represent column cells,
// for example, [ [1, 2, 3], [4, 5, 6] ] represents the 2x3 matrix:
// 1 2 3
// 4 5 6
function matmul(a, b) {
  c = build_empty_matrix(row_count(a), col_count(b))  // c is an nxp (n rows and p columns) matrix
  for row_i from 1 to row_count(a) {
    for col_j from 1 to col_count(b) {
      sum = 0
      for row_col_k from 1 to col_count(a) {
        sum = sum + a[row_i][row_col_k] * b[row_col_k][col_j]
      }
      c[row_i][col_j] = sum
    }
  }
  return c
}
```

The parameters `a` and `b` should be matrices holding double-precision floating point numbers (i.e. 64-bit floats). The `matmul` function should return a matrix consisting of double-precision floating point numbers (i.e. 64-bit floats).

The program should print a single line of output to standard out (STDOUT), consisting of the number at row floor(n/2) and column floor(p/2) of the matrix returned by the matmul function (i.e. `c[floor(n/2)][floor(p/2)]`). The line should be terminated with a newline.