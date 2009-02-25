namespace SolutionFactory
{
    public class Command
    {
        public static readonly string COMMAND_PREFIX = typeof(Addin).FullName + ".";
        //public const string SLN_EXPLR_GENERATE = "ScaffoldingUISlnExpr";
        public const string MENU_BAR_COMMAND_NAME = "Solution Fa&ctory";
        //public const string MENU_BAR_ABOUT_COMMAND_NAME = "ScaffoldingAbout";
        //public const string MENU_BAR_INSTALL_COMMAND_NAME = "ScaffoldingInstall";
        //public const string CODE_WINDOW_GENERATE = "ScaffoldingUI";
        public const string MENU_BAR_EXPORT_COMMAND_NAME = "ExportSolution";

        public static Command ExportSolutionCommand = new Command(MENU_BAR_EXPORT_COMMAND_NAME,
                                                                  "&Export Solution Template", "");

        //public static Command CodeWindowGenerate = new Command(CODE_WINDOW_GENERATE, "&Generate Scaffolding",
        //                                                       "Generate Scaffolding for current Class.");

        //public static Command SolutionExplorerGenerate = new Command(SLN_EXPLR_GENERATE, "&Generate Scaffolding", "Generate Scaffolding for current Class.");

        //public static Command AboutCommand = new Command(Command.MENU_BAR_ABOUT_COMMAND_NAME, "&About", "Show the About Dialog");
        //public static Command InstallCommand = new Command(Command.MENU_BAR_INSTALL_COMMAND_NAME, "&Install", "Install Templates into the current project.");

        private readonly string _commandName;
        private readonly string _commandText;
        private readonly string _toolTip;

        public Command(string CommandName, string commandText, string toolTip)
        {
            _commandName = CommandName;
            _commandText = commandText;
            _toolTip = toolTip;
        }

        public string CommandName
        {
            get { return _commandName; }
        }

        public string CommandText
        {
            get { return _commandText; }
        }

        public string ToolTip
        {
            get { return _toolTip; }
        }
    }
}