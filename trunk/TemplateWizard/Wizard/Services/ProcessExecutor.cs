using System.Diagnostics;
using System.IO;

namespace SolutionFactory
{
    public class ProcessExecutor : IProcessExecutor
    {
        #region IProcessExecutor Members

        public void Execute(string path)
        {
            var process = new Process();
            process.StartInfo.FileName = "cmd.exe";
            process.StartInfo.Arguments = @"/C """"" + Path.GetFileName(path) + @"""""";
            process.StartInfo.WorkingDirectory = Path.GetDirectoryName(path);
            process.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
            process.Start();
        }

        #endregion
    }
}