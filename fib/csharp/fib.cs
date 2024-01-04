using System;

public class Fib
{
    public static Int32 fib(Int32 n)
    {
        if (n <= 2)
        {
            return 1;
        }
        else
        {
            return fib(n - 1) + fib(n - 2);
        }
    }

    public static void Main(string[] args)
    {
        Console.WriteLine(fib(45));
    }
}