using System.Collections.Generic;
using System.IO;

namespace SolutionFactory.Services
{
    public class FileSystem : IFileSystem
    {
        #region IFileSystem Members

        public string ReadFile(string filename)
        {
            return File.ReadAllText(filename);
        }

        public bool Exists(string filePath)
        {
            return File.Exists(filePath);
        }

        public void WriteFile(string filePath, string content)
        {
            File.WriteAllText(filePath, content);
        }

        public IEnumerable<string> GetFilesInDirectory(string directory, string filePattern)
        {
            return Directory.GetFiles(directory, filePattern);
        }

        public IEnumerable<string> GetSubDirectories(string directory)
        {
            if (Directory.Exists(directory))
            {
                foreach (string dir in Directory.GetDirectories(directory))
                {
                    if (new DirectoryInfo(dir).Attributes != FileAttributes.Hidden)
                        //&&  !Path.GetFileName(dir).StartsWith("."))
                    {
                        yield return dir;
                    }
                }
            }
            //yield return null;
        }

        public string GetFileName(string filePath)
        {
            return Path.GetFileNameWithoutExtension(filePath);
        }

        public string GetDirectoryName(string fileName)
        {
            return Path.GetDirectoryName(fileName);
        }

        public string GetFullPath(string path)
        {
            return Path.GetFullPath(path);
        }

        public void Copy(string targetFile, string destinationFile)
        {
            Directory.CreateDirectory(GetDirectoryName(destinationFile));
            File.Copy(targetFile, destinationFile);
        }

        public string GetFileNameWithExtension(string file)
        {
            return Path.GetFileName(file);
        }

        public void CreateDirectory(string directory)
        {
            Directory.CreateDirectory(GetDirectoryName(directory));
        }

        public void CopyFilesAndDirectories(string sourceDir, string targetDir)
        {
            CopyFiles(sourceDir, targetDir);
            CopySubDirs(sourceDir, targetDir);
        }

        public void Delete(string directory)
        {
            if (Directory.Exists(directory))
                Directory.Delete(directory, true);
        }

        #endregion

        private void CopyFiles(string sourceDir, string targetDir)
        {
            foreach (string file in GetFilesInDirectory(sourceDir, "*.*"))
            {
                string destinationFile = Path.Combine(targetDir, GetFileNameWithExtension(file));
                Copy(file, destinationFile);
            }
        }

        private void CopySubDirs(string sourceDir, string targetDir)
        {
            foreach (string subDirectory in GetSubDirectories(sourceDir))
            {
                if (!GetFileName(subDirectory).Equals(string.Empty))
                {
                    string[] dirArray = subDirectory.Split('\\');
                    string dirname = dirArray[dirArray.Length - 1];
                    string subDirectoryTarget = Path.Combine(targetDir, dirname);
                    CopyFilesAndDirectories(subDirectory, subDirectoryTarget);
                }
            }
        }
    }
}