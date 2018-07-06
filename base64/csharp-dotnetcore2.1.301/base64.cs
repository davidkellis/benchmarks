// Taken from https://github.com/kostya/benchmarks/blob/master/base64/test.cs

using System;
using System.Diagnostics;
using System.Text;

namespace base64
{
    class base64
    {
        static System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();

        static string md5sum(string str)
        {
            byte[] bytes = md5.ComputeHash(Encoding.ASCII.GetBytes(str));

            StringBuilder result = new StringBuilder(bytes.Length*2);

            for (int i = 0; i < bytes.Length; i++)
                result.Append(bytes[i].ToString("x2"));

            return result.ToString();
        }

        static void Main(string[] args)
        {
            
            const int STR_SIZE = 1000000;
            const int REPETITIONS = 20;

            string str = new String('a', STR_SIZE);
            Console.WriteLine("{0}", md5sum(str));

            for (int i = 0; i < REPETITIONS; i++)
            {
                str = Convert.ToBase64String(Encoding.ASCII.GetBytes(str));
            }
            Console.WriteLine("{0}", md5sum(str));

            for (int i = 0; i < REPETITIONS; i++)
            {
                str = Encoding.ASCII.GetString(Convert.FromBase64String(str));
            }
            Console.WriteLine("{0}", md5sum(str));
        }
    }
}