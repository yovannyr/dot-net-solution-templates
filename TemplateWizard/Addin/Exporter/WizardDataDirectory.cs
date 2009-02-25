using System.Xml;

namespace SolutionFactory.Exporter
{
    public class WizardDataDirectory : XmlElement
    {
        public WizardDataDirectory(string directory) : base("", "directory", null, new XmlDocument())
        {
            InnerText = directory;
        }
    }
}