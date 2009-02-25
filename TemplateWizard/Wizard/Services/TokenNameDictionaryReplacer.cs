using System.Collections.Generic;

namespace SolutionFactory
{
    public class TokenNameDictionaryReplacer
    {
        public void ReplaceTokensInTheDictionary(Dictionary<string, string> dictionary, string key, string value)
        {
            if (dictionary.ContainsKey(key))
            {
                dictionary[key] = value;
            }
            else
            {
                dictionary.Add(key, value);
            }
        }
    }
}