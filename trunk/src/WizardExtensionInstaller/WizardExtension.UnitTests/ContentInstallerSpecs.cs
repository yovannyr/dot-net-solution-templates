using Microsoft.VisualStudio.ContentInstaller;
using NBehave.Spec.NUnit;
using NUnit.Framework;
using Rhino.Mocks;

namespace WizardExtension.UnitTests
{
    [TestFixture]
    public class ContentInstallerSpecs
    {
        [Test]
        public void get_import_pages_should_install_null()
        {
            var installer = new ContentInstaller();
            IImportPageData[] result = installer.GetImportPages();
            result.ShouldBeNull();
        }

        [Test]
        public void Should_import_Successfully()
        {
            var site = MockRepository.GenerateMock<IContentInstallerSite>();
            IApplicationHostData[] hostdata;
            IApplicationHostData[] appdata = new HostDataStub[1] {new HostDataStub()};
            site.Stub(s => s.GetApplicationData("", "2.0", out hostdata)).IgnoreArguments().OutRef(new object[]
                                                                                                       {appdata}).Return
                (true);
            var installer = new ContentInstaller(site);
            string result = installer.Import(new ContentItemStub {ShouldInstall = true, ContentVersion = "2.0"});
            result.ShouldEqual("Installation completed successfully!");
            string asdf;
            site.AssertWasCalled(s => s.CopyFile("", "", DuplicateFileCase.EnableOverwrite, out asdf),
                                 s => s.IgnoreArguments());
        }

        [Test]
        public void Should_no_opp_on_update_status()
        {
            var installer = new ContentInstaller();
            installer.UpdateContentItemInstallStatus(null);
        }

        [Test]
        public void Should_return_false_for_supports_ui()
        {
            var installer = new ContentInstaller();
            bool result = installer.SupportsImportUI;

            result.ShouldBeFalse();
        }

        [Test]
        public void Should_return_false_for_unknown_content_type()
        {
            var installer = new ContentInstaller();
            IContentItem[] content = new[] {new ContentItemStub {FileContentType = "unknown"}};
            var site = MockRepository.GenerateStub<IContentInstallerSite>();

            bool result = installer.AddContentItem(content, site);

            result.ShouldBeFalse();
        }

        [Test]
        public void Should_return_true_for_wizard_extension_content_type()
        {
            var installer = new ContentInstaller();
            IContentItem[] content = new[] {new ContentItemStub {FileContentType = "WizardExtension"}};
            var site = MockRepository.GenerateStub<IContentInstallerSite>();

            bool result = installer.AddContentItem(content, site);

            result.ShouldBeTrue();
        }
    }
}