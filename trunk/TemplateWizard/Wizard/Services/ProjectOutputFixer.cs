using EnvDTE;

namespace SolutionFactory
{
    public class ProjectOutputFixer
    {
        public void RenameProjectOutputAssemblyName(Project project, string variableName, string variableValue)
        {
            if (project != null && project.Name.Contains(variableName))
            {
                project.Name = project.Name.Replace(variableName, variableValue);
                project.Properties.Item("AssemblyName").Value =
                    project.Properties.Item("AssemblyName").Value.ToString().Replace(variableName,
                                                                                     variableValue);
                project.Save(project.FileName);
            }
        }
    }
}