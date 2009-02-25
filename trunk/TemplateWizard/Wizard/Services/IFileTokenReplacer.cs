using System.Collections.Generic;

namespace SolutionFactory.VSTemplateSchema
{
    public interface IFileTokenReplacer
    {
        void SetTokens(Dictionary<string, string> dictionary);
        void Replace(string file);
    }
}