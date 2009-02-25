using System.IO;

namespace SolutionFactory.Services
{
    public static class StringExtentions
    {
        public static string Combine(this string value, string path)
        {
            return Path.Combine(value, path);
        }
    }
}