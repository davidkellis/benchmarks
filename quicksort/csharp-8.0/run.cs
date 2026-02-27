using System;
using System.IO;
using System.Globalization;

class Program
{
    static void QuickSort(double[] arr, int lo, int hi)
    {
        if (lo >= hi) return;
        double pivot = arr[(lo + hi) / 2];
        int i = lo, j = hi;
        while (i <= j)
        {
            while (arr[i] < pivot) i++;
            while (arr[j] > pivot) j--;
            if (i <= j) { double t = arr[i]; arr[i] = arr[j]; arr[j] = t; i++; j--; }
        }
        if (lo < j) QuickSort(arr, lo, j);
        if (i < hi) QuickSort(arr, i, hi);
    }

    static void Main(string[] args)
    {
        string[] lines = File.ReadAllLines("numbers.txt");
        double[] nums = new double[lines.Length];
        for (int i = 0; i < lines.Length; i++)
            nums[i] = double.Parse(lines[i].Trim(), CultureInfo.InvariantCulture);

        QuickSort(nums, 0, nums.Length - 1);

        for (int i = 0; i < 10; i++) Console.WriteLine(nums[i]);
        Console.WriteLine("...");
        for (int i = nums.Length - 10; i < nums.Length; i++) Console.WriteLine(nums[i]);
    }
}
