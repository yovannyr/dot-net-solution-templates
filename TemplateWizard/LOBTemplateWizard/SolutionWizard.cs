using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
using EnvDTE;
using EnvDTE80;
using Microsoft.VisualStudio.TemplateWizard;
using VSLangProj;

namespace LOBTemplateWizard
{
    public class SolutionWizard : IWizard
    {
        public const string SOLUTION_FOLDER_KIND = "{66A26720-8FB5-11D2-AA7E-00C04F688DDE}";
        public const string SAFE_SOLUTION_NAME_KEY = "$safesolutionname$";
        public const string SOLUTION_NAME_KEY = "$solutionname$";
        public static int _projectCount;
        private static string _safeSolutionName = string.Empty;
        private static string _solutionName = string.Empty;
        private Project _project;
        private DTE _visualStudio;
        private readonly TokenNameDictionaryReplacer _solutionNameDictionaryReplacer= new TokenNameDictionaryReplacer();
        private readonly ProjectOutputFixer projectOutputFixer= new ProjectOutputFixer();
        public void BeforeOpeningFile(ProjectItem projectItem)
        {
        }

        public void ProjectFinishedGenerating(Project project)
        {
            _project = project;
            if (project != null)
                projectOutputFixer.RenameProjectOutputAssemblyName(project, SAFE_SOLUTION_NAME_KEY, _safeSolutionName);
        }

        public void ProjectItemFinishedGenerating(ProjectItem projectItem)
        {
        }

        public void RunFinished()
        {
            _projectCount--;
            if (_projectCount == 0)
            {                
                MoveSolutionFile(_visualStudio);

                string projectDir = Path.GetDirectoryName(GetSolutionFilePath(_visualStudio));
                CopyFolder( Path.Combine( projectDir , "..\\LibrariesAndTools\\Build"),Path.Combine( projectDir , "..\\"));

                DisableProjectFromBuild("LibrariesAndTools");
            }
            else
            {
                MoveProjectsRootDirectory(_project, SAFE_SOLUTION_NAME_KEY, _safeSolutionName);

            }
        }

        public void MoveProjectsRootDirectory(Project project, string variableName, string variableValue)
        {
            string projectFilename = Path.GetFileName(project.FileName);
            string projectDir = Path.GetDirectoryName(project.FileName);
            if (projectDir.Contains(variableName))
            {
                string newProjectDir = projectDir.Replace(variableName, variableValue);

                CopyFolder(projectDir, newProjectDir);
                string newProjectFilename = Path.Combine(newProjectDir, projectFilename);

                var folder = (SolutionFolder) project.ParentProjectItem.ContainingProject.Object;
                _visualStudio.Solution.Remove(project);
                Project newProject = folder.AddFromFile(newProjectFilename);

                FixProjectReferences(newProject);

                Directory.Delete(projectDir, true);
            }
        }

        private void DisableProjectFromBuild(string projectName)
        {
            foreach (SolutionConfiguration config in _visualStudio.Solution.SolutionBuild.SolutionConfigurations)
            {
                foreach (SolutionContext context in config.SolutionContexts)
                {
                    if (context.ProjectName.Contains(projectName))
                    {
                        context.ShouldBuild = false;
                    }
                }
            }
        }


        public void RunStarted(object automationObject, Dictionary<string, string> replacementsDictionary,
                               WizardRunKind runKind, object[] customParams)
        {
            _projectCount++;
            _visualStudio = automationObject as DTE;
            try
            {
                if (runKind == WizardRunKind.AsMultiProject)
                {
                    if (_projectCount == 1)
                    {
                        _solutionName = replacementsDictionary["$projectname$"];
                        _safeSolutionName = replacementsDictionary["$safeprojectname$"];
                    }
                }
                this._solutionNameDictionaryReplacer.ReplaceTokensInTheDictionary(replacementsDictionary,SOLUTION_NAME_KEY, _solutionName);
                this._solutionNameDictionaryReplacer.ReplaceTokensInTheDictionary(replacementsDictionary, SAFE_SOLUTION_NAME_KEY, _safeSolutionName);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        public bool ShouldAddProjectItem(string filePath)
        {
            return true;
        }

        public void FixProjectReferences(Project project)
        {
            var vsProject = project.Object as VSProject;
            if (vsProject != null)
                foreach (Reference reference in vsProject.References)
                {
                    if (reference.Path == string.Empty)
                    {
                        FindProjectReference(project, vsProject, reference);

                        reference.Remove();
                    }
                }
        }

        public static void FindProjectReference(Project project, VSProject vsProject, Reference reference)
        {
            foreach (Project proj in project.DTE.Solution.Projects)
            {
                if (proj.Name.EndsWith(reference.Name))
                {
                    vsProject.References.AddProject(proj);
                    return;
                }

                if (proj.Kind.Equals(SOLUTION_FOLDER_KIND))
                {
                    foreach (ProjectItem subproj in proj.ProjectItems)
                    {
                        if (subproj.Name.EndsWith(reference.Name))
                        {
                            var pro = (Project) subproj.Object;
                            vsProject.References.AddProject(pro);
                            return;
                        }
                    }
                }
            }
        }

        public void MoveSolutionFile(DTE vs)
        {
            string originalSolutionPath = GetSolutionFilePath(vs);
            string originalSolutionDir = Path.GetDirectoryName(originalSolutionPath);
            string originalSolutionFilename = Path.GetFileNameWithoutExtension(originalSolutionPath);

            string newSolutionPath = Path.Combine(originalSolutionDir, originalSolutionFilename + "\\src");

            if (Directory.Exists(newSolutionPath))
            {
                string newFilename = Path.Combine(newSolutionPath, originalSolutionFilename + ".sln");
                // Save the current solution as the new file name.
                vs.Solution.SaveAs(newFilename);

                // Delete the old solution.
                File.Delete(originalSolutionPath);
                string suoFile = Path.GetFileNameWithoutExtension(originalSolutionPath) + ".suo";
                string suoFilePath = Path.Combine(originalSolutionDir, suoFile);
                File.Delete(suoFilePath);
            }
        }

        private string GetSolutionFilePath(DTE vs)
        {
            return (string) vs.Solution.Properties.Item("Path").Value;
        }

        public static void CopyFolder(string sourceFolder, string destFolder)
        {
            if (!Directory.Exists(destFolder))
                Directory.CreateDirectory(destFolder);
            string[] files = Directory.GetFiles(sourceFolder);
            foreach (string file in files)
            {
                string name = Path.GetFileName(file);
                string dest = Path.Combine(destFolder, name);
                File.Copy(file, dest);
            }
            string[] folders = Directory.GetDirectories(sourceFolder);
            foreach (string folder in folders)
            {
                string name = Path.GetFileName(folder);
                string dest = Path.Combine(destFolder, name);
                CopyFolder(folder, dest);
            }
        }
    }

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


    public class TokenNameDictionaryReplacer
    {
        public void ReplaceTokensInTheDictionary(Dictionary<string, string> dictionary, string key, string name)
        {
            foreach (KeyValuePair<string, string> pair in dictionary)
            {
                pair.Value.Replace(key, name);
            }
        }
    }
}