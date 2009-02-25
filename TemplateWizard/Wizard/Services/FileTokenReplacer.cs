using System.Collections.Generic;
using SolutionFactory.Services;
using SolutionFactory.VSTemplateSchema;

namespace SolutionFactory.Services
{
    public class FileTokenReplacer : IFileTokenReplacer
    {
        private readonly IFileSystem _fileSystem;
        private Dictionary<string, string> _dictionary;

        public FileTokenReplacer(IFileSystem fileSystem)
        {
            _fileSystem = fileSystem;
        }

        #region IFileTokenReplacer Members

        public void SetTokens(Dictionary<string, string> dictionary)
        {
            _dictionary = dictionary;
        }

        public void Replace(string file)
        {
            if (FileShouldHaveTokensReplaced(file))
            {
                string filedata = _fileSystem.ReadFile(file);

                foreach (var pair in _dictionary)
                {
                    filedata = TokenInserter.WordReplace(filedata, pair.Key, pair.Value);
                }

                _fileSystem.WriteFile(file, filedata);
            }
        }

        #endregion

        private bool FileShouldHaveTokensReplaced(string targetDir)
        {
            return targetDir.EndsWith(".bat") ||
                   targetDir.EndsWith(".txt") ||
                   targetDir.EndsWith(".build") ||
                   targetDir.EndsWith(".config") ||
                   targetDir.EndsWith(".cs") ||
                   targetDir.EndsWith(".xml")||
                   targetDir.EndsWith(".asax") ||
                   targetDir.EndsWith(".aspx") ||
                   targetDir.EndsWith(".ascx") ||
                   targetDir.EndsWith(".master") ;
        }
    }
}