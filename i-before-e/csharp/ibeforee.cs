// Taken from https://github.com/archer884/i-before-e/blob/master/csharp-ie/Program.cs

using System;
using System.IO;
using System.Text.RegularExpressions;

namespace csharp_ie
{
    class Program
    {
        class Filter
        {
            private Regex _pattern;

            public Filter()
            {
                _pattern = new Regex("c?ei", RegexOptions.Compiled);
            }

            public bool IsValid(string s)
            {
                foreach (Match capture in _pattern.Matches(s))
                {
                    if (!capture.Value.StartsWith('c'))
                    {
                        return false;
                    }
                }
                return true;
            }
        }

        static void Main(string[] args)
        {
            var filter = new Filter();
            foreach (var word in File.ReadLines(args[0]))
            {
                if (!filter.IsValid(word))
                {
                    Console.WriteLine(word);
                }
            }
        }
    }
}