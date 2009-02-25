using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using System.Xml;
using EnvDTE;
using EnvDTE80;
using Microsoft.VisualStudio.TemplateWizard;
using SolutionFactory.Services;
using SolutionFactory.VSTemplateSchema;
using VSLangProj;

namespace SolutionFactory
{
    public class Wizard : IWizard
    {
        public const string SAFE_SOLUTION_NAME_KEY = "$safesolutionname$";
        public const string SOLUTION_FOLDER_KIND = "{66A26720-8FB5-11D2-AA7E-00C04F688DDE}";
        public const string SOLUTION_NAME_KEY = "$solutionname$";
        public static int _projectCount;
        private static string _safeSolutionName = string.Empty;
        private static string _solutionName = string.Empty;
        private readonly TokenNameDictionaryReplacer _solutionNameDictionaryReplacer = new TokenNameDictionaryReplacer();
        private readonly ProjectOutputFixer projectOutputFixer = new ProjectOutputFixer();
        private string _destinationDirectory;
        private bool _isSolutionWizard = false;
        private Project _project;
        private string _solutionDirectory = string.Empty;
        private string _solutionExecute;
        private string _solutionStartUp;
        private string _templateSourcePath;
        private DTE _visualStudio;
        private string _wizardData;

        #region IWizard Members

        void IWizard.BeforeOpeningFile(ProjectItem projectItem)
        {
        }

        void IWizard.ProjectFinishedGenerating(Project project)
        {
            _project = project;
            if (project != null)
                projectOutputFixer.RenameProjectOutputAssemblyName(project, SAFE_SOLUTION_NAME_KEY, _safeSolutionName);
        }

        void IWizard.ProjectItemFinishedGenerating(ProjectItem projectItem)
        {
        }

        void IWizard.RunFinished()
        {
            _projectCount--;
            if (_isSolutionWizard)
            {
                try
                {
                    MoveSolutionFileToTheProjectParentDirectory(_visualStudio);
                    CopySolutionItemsToDestinationFolder();

                    if (_solutionDirectory != string.Empty)
                    {
                        MoveSolutionAndProjectsToSubdirectory(_solutionDirectory);
                    }

                    foreach (Project project in _visualStudio.Solution.Projects)
                    {
                        FixProjectLinks(project);
                        FixProjectReferences(project);
                        if (project.IsDirty)
                            project.Save(null);
                    }

                    _visualStudio.Solution.Properties.Item("StartupProject").Value = _solutionStartUp;

                    if (_visualStudio.Solution.IsDirty)
                        _visualStudio.Solution.SaveAs(_visualStudio.Solution.FileName);

                    RunStartupCommand(_solutionExecute);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString());
                }
            }
            else
            {
                if (_project != null)
                {
                    MoveProjectsRootDirectory(_project, SAFE_SOLUTION_NAME_KEY, _safeSolutionName);
                }
            }
        }

        void IWizard.RunStarted(object automationObject, Dictionary<string, string> replacementsDictionary,
                                WizardRunKind runKind, object[] customParams)
        {
            try
            {
                SetWizardState(automationObject, customParams, replacementsDictionary, runKind);

                AddReplacementData(replacementsDictionary);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
        }

        bool IWizard.ShouldAddProjectItem(string filePath)
        {
            return true;
        }

        #endregion

        private void RunStartupCommand(string startupCommand)
        {
            string clickToBuild = Path.Combine(_destinationDirectory, startupCommand);
            IProcessExecutor processExecutor = new ProcessExecutor();
            processExecutor.Execute(clickToBuild);
        }

        private void FixProjectLinks(Project project)
        {
            foreach (ProjectItem projectItem in project.ProjectItems)
            {
                if (projectItem.IsLinkedFile())
                {
                    string solutionFile = Path.Combine(Path.GetDirectoryName(GetSolutionFilePath(_visualStudio)),
                                                       projectItem.Name);
                    if (!File.Exists(projectItem.Folder()) && File.Exists(solutionFile))
                    {
                        object copyTo = projectItem.Properties.Item("CopyToOutputDirectory").Value;
                        projectItem.Remove();
                        ProjectItem item = project.ProjectItems.AddFromFile(solutionFile);
                        item.Properties.Item("CopyToOutputDirectory").Value = copyTo;
                    }
                }
            }
        }

        private void CopySolutionItemsToDestinationFolder()
        {
            string sourcedirectory = Path.Combine(Path.GetDirectoryName(_templateSourcePath), "solution-items");
            CopyFolder(sourcedirectory, _destinationDirectory);
        }

        private void AddReplacementData(Dictionary<string, string> replacementsDictionary)
        {
            _solutionNameDictionaryReplacer.ReplaceTokensInTheDictionary(replacementsDictionary, SOLUTION_NAME_KEY,
                                                                         _solutionName);
            _solutionNameDictionaryReplacer.ReplaceTokensInTheDictionary(replacementsDictionary,
                                                                         SAFE_SOLUTION_NAME_KEY, _safeSolutionName);
        }

        private void MoveSolutionAndProjectsToSubdirectory(string subdirectory)
        {
            string sourceSolutionFilePath = GetSolutionFilePath(_visualStudio);
            string sourceSolutionDirectory = Path.GetDirectoryName(sourceSolutionFilePath);
            string destinationSolutionDirectory = Path.Combine(sourceSolutionDirectory, subdirectory);

            CreateDirectory(destinationSolutionDirectory);

            SaveSolutionToNewDirectory(destinationSolutionDirectory);

            DeleteSolutionFile(sourceSolutionFilePath);

            var projects = new List<Project>();
            foreach (Project project in _visualStudio.Solution.Projects)
            {
                projects.Add(project);
            }
            foreach (Project project in projects)
            {
                string projectDestination = Path.Combine(destinationSolutionDirectory, project.Name);
                MoveProjectToDirectory(project, projectDestination);
            }
        }

        private void SaveSolutionToNewDirectory(string destinationSolutionDirectory)
        {
            string sourceSolutionFilePath = GetSolutionFilePath(_visualStudio);
            string newFilename = Path.Combine(destinationSolutionDirectory, Path.GetFileName(sourceSolutionFilePath));
            _visualStudio.Solution.SaveAs(newFilename);
        }

        private void CreateDirectory(string destinationSolutionDirectory)
        {
            if (!Directory.Exists(destinationSolutionDirectory))
            {
                Directory.CreateDirectory(destinationSolutionDirectory);
            }
        }

        private void DeleteSolutionFile(string solutionFilePath)
        {
            File.Delete(solutionFilePath);
            string sourceSolutionDirectory = Path.GetDirectoryName(solutionFilePath);
            string suoFile = Path.GetFileNameWithoutExtension(solutionFilePath) + ".suo";
            string suoFilePath = Path.Combine(sourceSolutionDirectory, suoFile);
            File.Delete(suoFilePath);
        }


        public void MoveProjectsRootDirectory(Project project, string variableName, string variableValue)
        {
            string projectDir = Path.GetDirectoryName(project.FileName);

            if (projectDir.Contains(variableName))
            {
                string newProjectDir = projectDir.Replace(variableName, variableValue);

                MoveProjectToDirectory(project, newProjectDir);
            }
        }

        private void MoveProjectToDirectory(Project project, string destinationDirectory)
        {
            string projectFilename = Path.GetFileName(project.FileName);
            string projectDir = Path.GetDirectoryName(project.FileName);
            CopyFolder(projectDir, destinationDirectory);
            string newProjectFilename = Path.Combine(destinationDirectory, projectFilename);

            Project newProject;
            if (project.ParentProjectItem != null)
            {
                var folder = (SolutionFolder) project.ParentProjectItem.ContainingProject.Object;
                _visualStudio.Solution.Remove(project);
                newProject = folder.AddFromFile(newProjectFilename);
            }
            else
            {
                _visualStudio.Solution.Remove(project);
                newProject = _visualStudio.Solution.AddFromFile(newProjectFilename, false);
            }


            Directory.Delete(projectDir, true);
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


        private void SetWizardState(object automationObject, object[] customParams,
                                    Dictionary<string, string> replacementsDictionary, WizardRunKind runKind)
        {
            _projectCount++;
            _visualStudio = automationObject as DTE;
            if (customParams.Length > 0)
                _templateSourcePath = customParams[0].ToString();
            if (replacementsDictionary.ContainsKey("$destinationdirectory$"))
            {
                _destinationDirectory = replacementsDictionary["$destinationdirectory$"];
            }
            if (replacementsDictionary.ContainsKey("$wizarddata$"))
            {
                _wizardData = replacementsDictionary["$wizarddata$"];
                if (_wizardData.Length > 0)
                {
                    GetWizardData(_wizardData);
                }
            }

            if (runKind == WizardRunKind.AsMultiProject)
            {
                _isSolutionWizard = true;
                _projectCount = 1;
                _solutionName = replacementsDictionary["$projectname$"];
                _safeSolutionName = replacementsDictionary["$safeprojectname$"];
            }
        }


        private void GetWizardData(string wizardXmlFragment)
        {
            _solutionDirectory = GetWizardData("directory", wizardXmlFragment);
            _solutionStartUp = GetWizardData("startUpProject", wizardXmlFragment);
            _solutionExecute = GetWizardData("execute", wizardXmlFragment);
        }

        private string GetWizardData(string nodeName, string data)
        {
            string text = string.Empty;
            var document = new XmlDocument();
            document.LoadXml("<WizardData>" + data + "</WizardData>");

            XmlNode node =
                document.DocumentElement.ChildNodes.Cast<XmlNode>().Where(n => n.Name == nodeName).FirstOrDefault();

            if (node != null)
            {
                text = node.InnerText;
            }
            return text;
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

        public void MoveSolutionFileToTheProjectParentDirectory(DTE vs)
        {
            string originalSolutionPath = GetSolutionFilePath(vs);
            string originalSolutionDir = Path.GetDirectoryName(originalSolutionPath);
            string originalSolutionFilename = Path.GetFileNameWithoutExtension(originalSolutionPath);

            string newSolutionPath = Path.Combine(originalSolutionDir, originalSolutionFilename);

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
            IFileTokenReplacer replacer = CreateTokenReplacer();

            if (!Directory.Exists(destFolder))
                Directory.CreateDirectory(destFolder);
            string[] files = Directory.GetFiles(sourceFolder);
            foreach (string file in files)
            {
                string name = Path.GetFileName(file);
                string dest = Path.Combine(destFolder, name);
                File.Copy(file, dest);
                replacer.Replace(dest);
            }
            string[] folders = Directory.GetDirectories(sourceFolder);
            foreach (string folder in folders)
            {
                string name = Path.GetFileName(folder);
                string dest = Path.Combine(destFolder, name);
                CopyFolder(folder, dest);
            }
        }

        private static IFileTokenReplacer CreateTokenReplacer()
        {
            IFileTokenReplacer replacer = new FileTokenReplacer(new FileSystem());
            var dictionary = new Dictionary<string, string>();
            dictionary.Add(SAFE_SOLUTION_NAME_KEY, _safeSolutionName);
            replacer.SetTokens(dictionary);
            return replacer;
        }
    }
}