using System.Linq;
using EnvDTE;

namespace SolutionFactory
{
    public static class ProjectItemExtensions
    {
        public static bool IsLinkedFile(this ProjectItem projectItem)
        {
            Property isLinkProperty = projectItem.Property("IsLink");

            return isLinkProperty != null && (bool) isLinkProperty.Value;
        }

        public static string Folder(this ProjectItem projectItem)
        {
            Property localpathProperty = projectItem.Property("LocalPath");
            if (localpathProperty != null)
            {
                return localpathProperty.Value.ToString();
            }
            return "";
        }

        public static Property Property(this ProjectItem projectItem, string name)
        {
            return
                projectItem.Properties.OfType<Property>().Where(property => property.Name == name).FirstOrDefault();
        }
    }
}