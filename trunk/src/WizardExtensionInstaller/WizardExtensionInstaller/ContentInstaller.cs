using System.IO;
using Microsoft.VisualStudio.ContentInstaller;

namespace WizardExtension
{
    [ContentInstallerContentTypeRestriction("WizardExtension")]
    [ContentInstallerSupportedFileSecurity(".dll")]
    public class ContentInstaller : IImportCommunityContent
    {
        private IContentInstallerSite _site;
        public ContentInstaller()
        {
            
        }
        public ContentInstaller(IContentInstallerSite site)
        {
            _site = site;
        }

        public bool AddContentItem(IContentItem[] contentItems, IContentInstallerSite site)
        {
            _site = site;
            foreach (IContentItem contentItem in contentItems)
            {
                if (contentItem.FileContentType == "WizardExtension")
                {
                    return true;
                }
            }
            return false;
        }

        public string Import(IContentItem contentItem)
        {
            if (contentItem.ShouldInstall)
            {
                
                IApplicationHostData[] applicationHost;
                //Get the addin data since it is installed with VS.  This content type does not 
                //set any of the custom data need to located the VS installation path.
                _site.GetApplicationData("Addin", contentItem.ContentVersion, out applicationHost);

                string vsApplicationDirectory = Path.GetDirectoryName(applicationHost[0].ApplicationPath.Replace("\"",""));
                string destinationDirectory = Path.Combine(vsApplicationDirectory, "PrivateAssemblies");

                string actualDestinationPath;

                string[] sourceFileNames = contentItem.GetFileNames();
                string[] rootFileNames = contentItem.GetRootFileNames();

                for (int i = 0; i < sourceFileNames.Length; i++)
                {
                    string destinationPath = Path.Combine(destinationDirectory, rootFileNames[i]);

                    _site.StatusMessage("installing " + contentItem.DisplayName);

                    _site.CopyFile(sourceFileNames[i], destinationPath,
                                   DuplicateFileCase.EnableOverwrite | DuplicateFileCase.EnableSkip,
                                   out actualDestinationPath);
                }
                
                return "Installation completed successfully!";
            }
            return "Skipped";
        }


        public IImportPageData[] GetImportPages()
        {
            return null;
        }

        public void UpdateContentItemInstallStatus(IContentItem[] contentItem)
        {
        }

        public bool SupportsImportUI
        {
            get { return false; }
        }
    }
}