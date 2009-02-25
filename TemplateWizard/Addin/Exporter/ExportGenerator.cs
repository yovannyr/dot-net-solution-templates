using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Xml;
using EnvDTE;
using SolutionFactory.Services;
using SolutionFactory.VSTemplateSchema;
using SolutionFactory;
using ProjectItem=EnvDTE.ProjectItem;
using ProjectItemExtensions=SolutionFactory.Services.ProjectItemExtensions;

namespace SolutionFactory.Exporter
{
    public class ExportGenerator
    {
        private const string PROJECTS_FOLDER_NAME = "projects";
        private const string SOLUTION_ITEMS_FOLDER_NAME = "solution-items";
        public static readonly string WizardAssemblyName = Path.GetFileNameWithoutExtension( typeof (Wizard).Assembly.Location); //    "SolutionTemplate";
        private static readonly string WizardClassName = typeof (Wizard).FullName;
        private readonly DTE _dte;
        private readonly IFileSystem _fileSystem;
        private readonly IFileTokenReplacer _fileTokenReplacer;
        private readonly IMessageBox _messageBox;

        public ExportGenerator(DTE dte, IFileSystem fileSystem, IFileTokenReplacer fileTokenReplacer,
                               IMessageBox messageBox)
        {
            _dte = dte;
            _fileSystem = fileSystem;
            _fileTokenReplacer = fileTokenReplacer;
            _messageBox = messageBox;
        }

        public void Generate()
        {
            try
            {
                string dir = @"c:\temp\";
                string templateName = "Template";
                string startupFileToExecute = "Click To Build.bat";

                if (_dte.Solution.IsOpen)
                {
                    var templates = new List<VSTemplate>();
                    var templateLinks = new List<ProjectTemplateLink>();
                    var solutionFolder = new List<SolutionFolder>();

                    string name = _fileSystem.GetFileName(_dte.Solution.FileName);

                    InitializeTokenReplacer(name);

                    dir = dir.Combine(name);
                    string solutionItemDir = dir.Combine(SOLUTION_ITEMS_FOLDER_NAME);
                    string projectDestinationDirectory = dir.Combine(PROJECTS_FOLDER_NAME);

                    _fileSystem.Delete(dir);

                    CopyNonSolutionFiles(solutionItemDir, solutionFolder);

                    CreateProjectTemplates(templateLinks, templates, projectDestinationDirectory);

                    CopyProjectsToDestinationFolder(projectDestinationDirectory);


                    CreateSolutionTemplate(templateLinks, dir, solutionFolder, templateName, startupFileToExecute);
                }
            }
            catch (Exception ex)
            {
                _messageBox.ShowError(ex.ToString());
            }
        }

        private void InitializeTokenReplacer(string name)
        {
            var dictionary = new Dictionary<string, string>();
            dictionary.Add(name, "$safesolutionname$");
            _fileTokenReplacer.SetTokens(dictionary);
        }


        private string GetSolutionParentDir()
        {
            string solutionDir = _fileSystem.GetDirectoryName(_dte.Solution.FileName);
            string[] rootDirArray = solutionDir.Split('\\');
            string targetSolutionRootDir = "";
            if (rootDirArray.Length > 1)
            {
                targetSolutionRootDir = rootDirArray[rootDirArray.Length - 1];
            }
            return targetSolutionRootDir;
        }

        private void CopyNonSolutionFiles(string dir, List<SolutionFolder> solutionFolder)
        {
            string solutionDir = _fileSystem.GetDirectoryName(_dte.Solution.FileName);
            string solutionDirRoot = _fileSystem.GetFullPath(Path.Combine(solutionDir, "..\\"));
            string solutionParentDir = GetSolutionParentDir();
            CopySolutionRootDirectories(solutionDirRoot, solutionParentDir, dir);
            CopyRootFiles(solutionDirRoot, dir);
            CopySolutionSrcFiles(solutionParentDir, dir);
        }

        private void CopySolutionRootDirectories(string solutionDirRoot, string solutionParentDir, string dir)
        {
            foreach (string subDirectory in _fileSystem.GetSubDirectories(solutionDirRoot))
            {
                string subDirName = subDirectory.Replace(solutionDirRoot, "");
                if (subDirName != solutionParentDir && !subDirName.StartsWith("."))
                {
                    string targetDir = Path.Combine(dir, subDirName);
                    string sourceDir = Path.Combine(solutionDirRoot, subDirName);
                    _fileSystem.CopyFilesAndDirectories(sourceDir, targetDir);
                    //solutionFolder.Add(new SolutionFolder {Name = subDirName});
                }
            }
        }

        private void CopyRootFiles(string solutionDirRoot, string dir)
        {
            foreach (string file in _fileSystem.GetFilesInDirectory(solutionDirRoot, "*.*"))
            {
                string targetDir = Path.Combine(dir, _fileSystem.GetFileNameWithExtension(file));
                _fileSystem.Copy(file, targetDir);
                if (FileShouldHaveTokensReplaced(targetDir))
                {
                    _fileTokenReplacer.Replace(targetDir);
                }
            }
        }

        private void CopySolutionSrcFiles(string solutionParentDir, string dir)
        {
            List<string> files = _fileSystem.GetFilesInDirectory(
                _fileSystem.GetDirectoryName(_dte.Solution.FileName), "*.*").Where(
                s => !s.EndsWith(".user") &&
                     !s.EndsWith(".sln") &&
                     !s.EndsWith(".suo") &&
                     !s.EndsWith(".cache")).ToList();

            string destinationDir = dir.Combine(solutionParentDir);
            foreach (string file in files)
            {
                string targetDir = destinationDir.Combine(_fileSystem.GetFileNameWithExtension(file));
                _fileSystem.Copy(file, targetDir);
                if (FileShouldHaveTokensReplaced(targetDir))
                {
                    _fileTokenReplacer.Replace(targetDir);
                }
            }
        }

        private bool FileShouldHaveTokensReplaced(string targetDir)
        {
            return targetDir.EndsWith(".bat") ||
                   targetDir.EndsWith(".txt") ||
                   targetDir.EndsWith(".build") ||
                   targetDir.EndsWith(".config") ||
                   targetDir.EndsWith(".cs") ||
                   targetDir.EndsWith(".xml");
        }

        private void CopyProjectsToDestinationFolder(string destinationRootDirectory)
        {
            foreach (Project project in _dte.Solution.Projects.GetCodeProjects())
            {
                string sourceFile = project.FileName;
                string destinationPath = Path.Combine(destinationRootDirectory.Combine(GetSolutionParentDir()),
                                                      project.Name);
                string destinationFile = Path.Combine(destinationPath,
                                                      _fileSystem.GetFileNameWithExtension(project.FileName));
                _fileSystem.Copy(sourceFile, destinationFile);
                _fileTokenReplacer.Replace(destinationFile);
                CopyProjectItems(project.ProjectItems, destinationPath);
            }
        }

        private void CopyProjectItems(ProjectItems items, string destinationPath)
        {
            foreach (ProjectItem projectItem in items)
            {
                if (projectItem.IsAFile())
                {
                    if (ProjectItemExtensions.IsLinkedFile(projectItem))
                    {
                        string parentPath;
                        if (items.Parent is Project)
                        {
                            parentPath = Path.GetDirectoryName(((Project) items.Parent).FileName);
                        }
                        else
                        {
                            parentPath = Path.GetDirectoryName(((ProjectItem) items.Parent).get_FileNames(0));
                        }

                        string path = PathUtil.RelativePathTo(parentPath, ProjectItemExtensions.Folder(projectItem));
                        string destinationFile = Path.Combine(destinationPath, path);
                        if (!_fileSystem.Exists(destinationFile))
                        {
                            _fileSystem.Copy(ProjectItemExtensions.Folder(projectItem), destinationFile);
                            _fileTokenReplacer.Replace(destinationFile);
                        }
                    }
                    else
                    {
                        for (short fileCount = 0; fileCount < projectItem.FileCount; fileCount++)
                        {
                            string file = projectItem.get_FileNames(fileCount);
                            string destinationFile = Path.Combine(destinationPath,
                                                                  _fileSystem.GetFileNameWithExtension(file));
                            _fileSystem.Copy(file, destinationFile);
                            _fileTokenReplacer.Replace(destinationFile);
                        }
                        CopyProjectItems(projectItem.ProjectItems, destinationPath);
                    }
                }
                else
                {
                    string folderPath = Path.Combine(destinationPath, projectItem.Name);
                    CopyProjectItems(projectItem.ProjectItems, folderPath);
                }
            }
        }


        private void CreateSolutionTemplate(List<ProjectTemplateLink> templateLinks, string dir,
                                            List<SolutionFolder> solutionFolder, string templateName,
                                            string startupFileToExecute)
        {
            VSTemplate template = CreateTemplateForSolution(templateName);
            template.TemplateContent.Items = CreateSolutionItems(templateLinks, solutionFolder);
            template.WizardExtension = CreateWizardExtention();


            template.WizardData = CreateSolutionWizardData(startupFileToExecute);
            string target = Path.Combine(dir, "solution.vstemplate");
            template.Serialize(target);
        }

        private VSTemplateTemplateContentProjectCollection[] CreateSolutionItems(
            List<ProjectTemplateLink> templateLinks, List<SolutionFolder> solutionFolder)
        {
            return new[]
                       {
                           new VSTemplateTemplateContentProjectCollection
                               {
                                   Items = templateLinks.ToArray()
                               }
                       };
        }

        private VSTemplateWizardData[] CreateSolutionWizardData(string startupFileName)
        {
            return new[]
                       {
                           new VSTemplateWizardData
                               {
                                   Any = new XmlElement[]
                                             {
                                                 new WizardDataDirectory(GetSolutionParentDir()),
                                                 new WizardDataStartupProject(GetSolutionStartup()),
                                                 new WizardDataExecuteOnLoad(startupFileName)
                                             }
                               },
                       };
        }

        private string GetSolutionStartup()
        {
            return _dte.Solution.Properties.Item("StartupProject").Value.ToString();
        }

        private VSTemplate CreateTemplateForSolution(string templateName)
        {
            var template = new VSTemplate {TemplateData = new VSTemplateTemplateData()};
            template.TemplateData.Name = new NameDescriptionIcon {Value = templateName};
            template.TemplateData.Description = new NameDescriptionIcon {Value = ""};
            template.TemplateData.ProjectType = "CSharp";
            template.TemplateData.ProjectSubType = "My Project Collection";
            template.TemplateData.SortOrder = "1";
            template.TemplateData.CreateNewFolder = true;
            template.TemplateData.CreateNewFolderSpecified = true;
            template.TemplateData.LocationFieldSpecified = true;
            template.TemplateData.EnableLocationBrowseButton = true;
            template.TemplateData.EnableLocationBrowseButtonSpecified = true;
            template.TemplateData.BuildOnLoad = true;
            template.Type = "ProjectGroup";
            template.Version = "2.0.0";
            template.TemplateContent = new VSTemplateTemplateContent();
            return template;
        }


        private void CreateProjectTemplates(List<ProjectTemplateLink> templateLinks, List<VSTemplate> templates,
                                            string dir)
        {
            foreach (Project project in  _dte.Solution.Projects.GetCodeProjects())
            {
                try
                {
                    VSTemplate template = GetProjectTemplate(project);
                    templates.Add(template);

                    templateLinks.Add(CreateProjectLink(project));

                    WriteTemplateToFile(template, dir, project.Name);
                }
                catch (Exception e)
                {
                    _messageBox.ShowError(e.ToString());
                }
            }
        }

        private void WriteTemplateToFile(VSTemplate template, string dir, string projectName)
        {
            dir = dir.Combine(GetSolutionParentDir());
            string targetDir = Path.Combine(dir, projectName) + "\\";
            string filename = Path.Combine(targetDir, projectName + ".vstemplate");
            _fileSystem.CreateDirectory(targetDir);
            template.Serialize(filename);
        }

        private ProjectTemplateLink CreateProjectLink(Project project)
        {
            string filename = PROJECTS_FOLDER_NAME +
                              @"\".Combine(GetSolutionParentDir()).Combine(project.Name).Combine(project.Name +
                                                                                                 ".vstemplate");
            return new ProjectTemplateLink
                       {
                           ProjectName = project.Name,
                           Value = filename
                       };
        }

        private VSTemplate GetProjectTemplate(Project project)
        {
            var template = new VSTemplate();
            template.Type = "Project";
            template.Type = "Project";
            template.Version = "2.0.0";
            template.TemplateData = new VSTemplateTemplateData
                                        {
                                            Name = new NameDescriptionIcon {Value = project.Name},
                                            ProjectType = "CSharp",
                                            Description = new NameDescriptionIcon {Value = ""},
                                            Icon = new NameDescriptionIcon {Value = "__TemplateIcon.ico"},
                                            DefaultName = project.Name,
                                            ProvideDefaultName = true,
                                            ProvideDefaultNameSpecified = true,
                                            SortOrder = "1000",
                                            CreateNewFolder = true,
                                            CreateNewFolderSpecified = true,
                                        };

            template.TemplateContent = new VSTemplateTemplateContent();

            template.TemplateContent.Items = new[]
                                                 {
                                                     new VSTemplateTemplateContentProject
                                                         {
                                                             File =
                                                                 _fileSystem.GetFileNameWithExtension(
                                                                 project.FileName),
                                                             Items = GetItems(project).ToArray(),
                                                             TargetFileName = _fileSystem.GetFileNameWithExtension(
                                                                 project.FileName),
                                                             ReplaceParametersSpecified = true,
                                                             ReplaceParameters = true,
                                                         }
                                                 };

            template.WizardExtension = CreateWizardExtention();

            return template;
        }

        private VSTemplateWizardExtension[] CreateWizardExtention()
        {
            return new[]
                       {
                           new VSTemplateWizardExtension
                               {
                                   Assembly = new[] {WizardAssemblyName},
                                   FullClassName = new[] {WizardClassName}
                               },
                       };
        }

        public IEnumerable<object> GetItems(Project project)
        {
            var items = new ArrayList();
            items.AddRange((ICollection) GetChildItems(project.ProjectItems));
            return items.ToArray();
        }


        private ICollection<object> GetChildItems(ProjectItems parentProjectItems)
        {
            var items = new ArrayList();
            foreach (ProjectItem projectItem in GetProjectItems(parentProjectItems))
            {
                if (ProjectItemExtensions.IsLinkedFile(projectItem))
                {
                    if (parentProjectItems.Parent is Project)
                    {
                        items.Add(CreateLinkedFileItem(projectItem,
                                                       ((Project) parentProjectItems.Parent).FileName));
                    }
                    else
                    {
                        items.Add(CreateLinkedFileItem(projectItem,
                                                       ((ProjectItem) parentProjectItems.Parent).get_FileNames(0)));
                    }
                }
                else
                {
                    items.Add(CreateFileItem(projectItem));
                    items.AddRange((ICollection) GetChildItems(projectItem.ProjectItems));
                }
            }
            foreach (ProjectItem projectItem in GetFolderItems(parentProjectItems))
            {
                items.Add(CreateFolderItem(projectItem));
            }
            return items.ToArray();
        }

        private object CreateLinkedFileItem(ProjectItem projectItem, string parentPath)
        {
            string filename = projectItem.get_FileNames(0);

            string relativepath = PathUtil.RelativePathTo(Path.GetDirectoryName(parentPath), filename);
            return new VSTemplateSchema.ProjectItem
                       {
                           ReplaceParameters = projectItem.ShouldReplaceParameters(),
                           Value = relativepath,
                           TargetFileName = projectItem.Name,
                           ReplaceParametersSpecified = true
                       };
        }

        private Folder CreateFolderItem(ProjectItem projectItem)
        {
            return new Folder
                       {
                           Name = projectItem.Name,
                           TargetFolderName = projectItem.Name,
                           Items = GetChildItems(projectItem.ProjectItems).ToArray()
                       };
        }

        private VSTemplateSchema.ProjectItem CreateFileItem(ProjectItem projectItem)
        {
            return new VSTemplateSchema.ProjectItem
                       {
                           ReplaceParameters = projectItem.ShouldReplaceParameters(),
                           Value = projectItem.Name,
                           TargetFileName = projectItem.Name,
                           ReplaceParametersSpecified = true
                       };
        }

        public IEnumerable<object> GetProjectItems(ProjectItems projectItems)
        {
            foreach (ProjectItem projectItem in projectItems)
            {
                if (projectItem.IsAFile())
                {
                    yield return projectItem;
                }
            }
        }

        public IEnumerable<object> GetFolderItems(ProjectItems projectItems)
        {
            foreach (ProjectItem projectItem in projectItems)
            {
                if (projectItem.IsAFolder())
                {
                    yield return projectItem;
                }
            }
        }
    }
}