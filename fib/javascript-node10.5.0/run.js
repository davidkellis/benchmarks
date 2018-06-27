// Taken from https://github.com/drujensen/fib/blob/master/fib.js

var fib = function(n) {
  if (n <= 1) {
    return 1;
  } else {
    return fib(n - 1) + fib(n - 2);
  }
};

console.log(fib(45));