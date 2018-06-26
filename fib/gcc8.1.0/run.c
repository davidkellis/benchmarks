#include <stdio.h>

int fib(int n) {
  if (n <= 1) {
    return 1;
  } else {
    return fib(n - 1) + fib(n - 2);
  }
}

int main(int argc, char **argv){
  printf("%i\n", fib(45));
  return 0;
}