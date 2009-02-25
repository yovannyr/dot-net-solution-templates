using System;

namespace SolutionFactory.Services
{
    public class TokenInserter
    {
        public static string WordReplace(string source, string search, string replace)
        {
            int startIndex = 0;
            while (true)
            {
                int num2;
                do
                {
                    do
                    {
                        num2 = source.IndexOf(search, startIndex, StringComparison.Ordinal);
                        if (num2 == -1)
                        {
                            return source;
                        }
                        startIndex = num2 + search.Length;
                    } while (((num2 != 0) && !char.IsWhiteSpace(source[num2 - 1])) &&
                             ("\\/.,;-()<>{}'\"~!+=`@#$%^&*[]|:?".IndexOf(source[num2 - 1]) == -1));
                } while (((source.Length != (num2 + search.Length)) && !char.IsWhiteSpace(source[num2 + search.Length])) &&
                         ("\\/.,;-()<>{}'\"~!+=`@#$%^&*[]|:?".IndexOf(source[num2 + search.Length]) == -1));
                source = source.Remove(num2, search.Length).Insert(num2, replace);
                startIndex = num2 + replace.Length;
            }
        }
    }
}