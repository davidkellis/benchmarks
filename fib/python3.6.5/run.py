def fib(n):
    if n <= 1:
        return 1
    else:
        return fib(n - 1) + fib(n - 2)

def main():
    print(fib(45))

if __name__ == '__main__':
    main()
