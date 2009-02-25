using SolutionFactory.Exporter;

//using Scaffolding.Generator;
//using Scaffolding.UI.Impl;
//using Scaffolding.VSHelpers;

namespace SolutionFactory.Services
{
    public interface IIoC
    {
        TInterface GetService<TInterface>();
        //IShouldContextMenu CreateShouldContextMenu();
        //IScaffoldingGenerator CreateScaffoldingGenerator();
        //IInstallTemplatesController CreateInstallTemplatesController();
        ExportGenerator CreateExportGenerator();
    }
}