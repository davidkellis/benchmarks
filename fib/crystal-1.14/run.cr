def fib(n : Int32) : Int32
  if n <= 2
    1
  else
    fib(n - 1) + fib(n - 2)
  end
end

puts fib(45)