using System;
using System.Collections.Specialized;
using Microsoft.VisualStudio.ContentInstaller;

namespace WizardExtension.UnitTests
{
    public class ContentItemStub : IContentItem
    {
        public string[] GetRootFileNames()
        {
            return new string[]{@"test.txt"};
        }

        public string[] GetFileNames()
        {
            return new string[]{@"c:\asdfasd\asdfsd.txt"};
        }

        public StringDictionary AttributePairs
        {
            get { throw new NotImplementedException(); }
        }

        public string Description
        {
            get { throw new NotImplementedException(); }
        }

        public string DisplayName
        {
            get { return "displayname"; }
        }

        public string FileContentType { get; set; }

        public string ContentVersion { get; set; }

        public bool ShouldInstall { get; set; }

        public bool InstalledSuccessfully
        {
            get { throw new NotImplementedException(); }
        }

        public string InstallMessage
        {
            get { throw new NotImplementedException(); }
        }
    }
}