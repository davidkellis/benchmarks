using System;
using System.IO;

class Program
{
    static int[] R = new int[729];
    static int[] C = new int[324];
    static int[,] rows = new int[729, 4];
    static int[,] cols = new int[324, 9];
    static int[] colCount = new int[324];

    static void Init()
    {
        int[] nr = new int[324];
        for (int i = 0; i < 729; i++)
        {
            int r2 = i / 9, c2 = i % 9;
            int row = r2 / 9, col = r2 % 9, box = row / 3 * 3 + col / 3;
            int[] cc = { 9 * row + c2, 81 + 9 * col + c2, 162 + 9 * box + c2, 243 + r2 };
            for (int j = 0; j < 4; j++)
            {
                rows[i, j] = cc[j];
                cols[cc[j], nr[cc[j]]++] = i;
            }
        }
        for (int i = 0; i < 324; i++) colCount[i] = 9;
    }

    static int Update(int[] sr, int r, int v)
    {
        int min = 10, minC = -1;
        for (int j = 0; j < 4; j++) colCount[rows[r, j]] += v < 0 ? -10 : 10;
        for (int j = 0; j < 4; j++)
        {
            int c = rows[r, j];
            if (v > 0)
            {
                for (int k = 0; k < 9; k++)
                {
                    int rr = cols[c, k];
                    if (sr[rr]++ != 0) continue;
                    for (int l = 0; l < 4; l++)
                        if (--colCount[rows[rr, l]] < min) { min = colCount[rows[rr, l]]; minC = rows[rr, l]; }
                }
            }
            else
            {
                for (int k = 0; k < 9; k++)
                {
                    int rr = cols[c, k];
                    if (--sr[rr] != 0) continue;
                    for (int l = 0; l < 4; l++) ++colCount[rows[rr, l]];
                }
            }
        }
        return minC;
    }

    static int Solve(int[] sr, int[] cr, int[] solution, int depth)
    {
        // find min column
        int min = 10, bestC = -1;
        for (int i = 0; i < 324; i++)
            if (colCount[i] < min) { min = colCount[i]; bestC = i; }
        if (min == 0 || min == 10) return min == 10 ? 1 : 0;

        for (int k = 0; k < 9; k++)
        {
            int r = cols[bestC, k];
            if (sr[r] != 0) continue;
            solution[depth] = r;
            int minC = Update(sr, r, 1);
            int result = Solve(sr, cr, solution, depth + 1);
            if (result > 0) return result;
            Update(sr, r, -1);
        }
        return 0;
    }

    static string SolvePuzzle(string puzzle)
    {
        Init();
        int[] sr = new int[729];
        int[] cr = new int[81];
        int[] solution = new int[81];
        char[] result = puzzle.ToCharArray();

        for (int i = 0; i < 81; i++)
        {
            cr[i] = -1;
            if (puzzle[i] >= '1' && puzzle[i] <= '9')
            {
                int r = i * 9 + (puzzle[i] - '1');
                Update(sr, r, 1);
                cr[i] = r;
            }
        }

        if (Solve(sr, cr, solution, 0) > 0)
        {
            for (int i = 0; i < 81; i++)
            {
                if (cr[i] >= 0) continue;
                // find which solution entry belongs to cell i
                for (int j = 0; j < 81; j++)
                    if (solution[j] / 9 == i)
                        result[i] = (char)('1' + solution[j] % 9);
            }
        }
        return new string(result);
    }

    static void Main(string[] args)
    {
        string[] lines = File.ReadAllLines("sudoku.txt");
        for (int iter = 0; iter < 10; iter++)
            foreach (string line in lines)
                if (line.Length >= 81)
                    Console.WriteLine(SolvePuzzle(line.Trim()));
    }
}
