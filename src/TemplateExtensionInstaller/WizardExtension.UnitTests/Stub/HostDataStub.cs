using System.Drawing;
using Microsoft.VisualStudio.ContentInstaller;

namespace WizardExtension.UnitTests
{
    public class HostDataStub:IApplicationHostData
    {
        public string RegistryRoot
        {
            get { throw new System.NotImplementedException(); }
        }

        public string ApplicationName
        {
            get { throw new System.NotImplementedException(); }
        }

        public string UserDataFolder
        {
            get { throw new System.NotImplementedException(); }
        }

        public string ApplicationPath
        {
            get { return @"c:\this\and\that.txt"; }
        }

        public string ProgId
        {
            get { throw new System.NotImplementedException(); }
        }

        public Bitmap ApplicationImage
        {
            get { throw new System.NotImplementedException(); }
        }

        public bool ExpressVersion
        {
            get { throw new System.NotImplementedException(); }
        }
    }
}