using System;

class Program
{
    static double ApproxPi(int throws)
    {
        var rng = new Random();
        int inside = 0;
        for (int i = 0; i < throws; i++)
        {
            double x = rng.NextDouble();
            double y = rng.NextDouble();
            if (Math.Sqrt(x * x + y * y) <= 1.0)
                inside++;
        }
        return 4.0 * inside / throws;
    }

    static void Main(string[] args)
    {
        int[] samples = { 1000, 10000, 100000, 1000000, 10000000 };
        foreach (int n in samples)
        {
            Console.WriteLine($"{n,8} samples: PI = {ApproxPi(n)}");
        }
    }
}
