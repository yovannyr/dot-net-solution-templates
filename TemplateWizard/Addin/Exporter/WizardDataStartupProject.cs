using System.Xml;

namespace SolutionFactory.Exporter
{
    public class WizardDataStartupProject : XmlElement
    {
        public WizardDataStartupProject(string startupProjectName)
            : base("", "startUpProject", null, new XmlDocument())
        {
            InnerText = startupProjectName;
        }
    }
}