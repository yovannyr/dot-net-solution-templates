using System.Xml;

namespace SolutionFactory.Exporter
{
    public class WizardDataExecuteOnLoad : XmlElement
    {
        public WizardDataExecuteOnLoad(string filename)
            : base("", "execute", null, new XmlDocument())
        {
            InnerText = filename;
        }
    }
}