using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using EnvDTE;
using EnvDTE80;
using Extensibility;
using Microsoft.VisualStudio.CommandBars;
using SolutionFactory.Exporter;
using SolutionFactory.Services;
//using Scaffolding.UI.Impl;

namespace SolutionFactory
{
    public class Addin : IDTExtensibility2, IDTCommandTarget
    {
        private readonly List<CommandBar> _commandBars = new List<CommandBar>();
        private readonly IMessageBox _messageBox = new MessageBox();
        private AddIn _addInInstance;
        private DTE2 _applicationObject;
        private IIoC _ioc;

        #region IDTCommandTarget Members

        public void QueryStatus(string commandName, vsCommandStatusTextWanted neededText, ref vsCommandStatus status,
                                ref object commandText)
        {
            if (neededText == vsCommandStatusTextWanted.vsCommandStatusTextWantedNone)
            {
                switch (commandName.Replace(Command.COMMAND_PREFIX, ""))
                {
                    case Command.MENU_BAR_EXPORT_COMMAND_NAME:
                        if (_applicationObject.Solution.IsOpen && DependenciesAreLoaded())
                            status = vsCommandStatus.vsCommandStatusSupported | vsCommandStatus.vsCommandStatusEnabled;
                        else
                            status = vsCommandStatus.vsCommandStatusSupported;
                        return;
                }
            }
        }


        public void Exec(string commandName, vsCommandExecOption executeOption, ref object varIn, ref object varOut,
                         ref bool handled)
        {
            handled = false;
            if (executeOption == vsCommandExecOption.vsCommandExecOptionDoDefault)
            {
                if (commandName == Command.COMMAND_PREFIX + Command.MENU_BAR_EXPORT_COMMAND_NAME)
                {
                    ExportGenerator generator = _ioc.CreateExportGenerator();
                    generator.Generate();
                }
            }
        }

        #endregion

        #region IDTExtensibility2 Members

        public void OnConnection(object application, ext_ConnectMode connectMode, object addInInst, ref Array custom)
        {
            _applicationObject = (DTE2) application;
            _addInInstance = (AddIn) addInInst;
            _ioc = new IoC(_applicationObject);

            switch (connectMode)
            {
                case ext_ConnectMode.ext_cm_UISetup:

                    AddContextMenusToVisualStudio();
                    break;
            }
        }

        public void OnDisconnection(ext_DisconnectMode RemoveMode, ref Array custom)
        {
            RemoveMenus();
        }


        public void OnAddInsUpdate(ref Array custom)
        {
            try
            {
                if (_addInInstance.Connected)
                {
                    AddContextMenusToVisualStudio();
                }
            }
            catch (COMException)
            {
                System.Windows.Forms.MessageBox.Show("Not a registered add-in.");
            }
        }

        public void OnStartupComplete(ref Array custom)
        {
            try
            {
            }
            catch (Exception ex)
            {
                _messageBox.ShowError(ex.ToString());
            }
        }

        public void OnBeginShutdown(ref Array custom)
        {
        }

        #endregion

        public bool DependenciesAreLoaded()
        {
            try
            {
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }


        private void RemoveMenus()
        {
            DelectCommmand(Command.MENU_BAR_EXPORT_COMMAND_NAME);

            CommandBar cmdBar = ((CommandBars) _applicationObject.CommandBars)["MenuBar"];
            try
            {
                IEnumerable<CommandBarControl> barsToDelete =
                    cmdBar.Controls.Cast<CommandBarControl>().Where(
                        control => control.Caption == Command.MENU_BAR_COMMAND_NAME);

                foreach (CommandBarControl bar in barsToDelete)
                {
                    bar.Delete(false);
                    //_applicationObject.Commands.RemoveCommandBar(bar);
                }
            }
            catch (Exception)
            {
            }
            try
            {
                foreach (CommandBar bar in _commandBars)
                {
                    bar.Delete();
                }
            }
            catch (Exception)
            {
            }
            _commandBars.Clear();
        }

        private void AddContextMenusToVisualStudio()
        {
            CommandBar menu = CreateCommandBar(Command.MENU_BAR_COMMAND_NAME);
            _commandBars.Add(menu);
            CreateCommand(menu, Command.ExportSolutionCommand);
        }

        private CommandBar CreateCommandBar(string commandName)
        {
            try
            {
                CommandBar newCmdBar = ((CommandBars) _applicationObject.CommandBars)[commandName];
                if (newCmdBar != null)
                    return newCmdBar;
            }
            catch
            {
                ;
            }

            CommandBar cmdBar = ((CommandBars) _applicationObject.CommandBars)["MenuBar"];
            if (cmdBar != null)
            {
                return (CommandBar) _applicationObject.Commands.AddCommandBar(commandName,
                                                                              vsCommandBarType.vsCommandBarTypeMenu,
                                                                              cmdBar, cmdBar.Controls.Count - 4);
            }
            return null;
        }


        private void CreateCommand(CommandBar cmdBar, Command command)
        {
            try
            {
                if (CommandDoesNotExist(command.CommandName))
                {
                    var contextGUIDS = new object[] {};
                    EnvDTE.Command cmd = _applicationObject.Commands.AddNamedCommand(_addInInstance, command.CommandName,
                                                                                     command.CommandText,
                                                                                     command.ToolTip,
                                                                                     true, 0, ref contextGUIDS,
                                                                                     (int)
                                                                                     vsCommandDisabledFlags.
                                                                                         vsCommandDisabledFlagsHidden);

                    if (cmdBar != null)
                    {
                        cmd.AddControl(cmdBar, 1);
                    }
                }
            }
            catch (Exception ex)
            {
                _messageBox.ShowError(ex.Message);
            }
        }

        private void DelectCommmand(params string[] commandNames)
        {
            foreach (string commandName in commandNames)
            {
                try
                {
                    EnvDTE.Command cmd = _applicationObject.Commands.Item(Command.COMMAND_PREFIX + commandName, 1);
                    cmd.Delete();
                }
                catch (Exception ex)
                {
                }
            }
        }

        private bool CommandDoesNotExist(string commandName)
        {
            try
            {
                _applicationObject.Commands.Item(Command.COMMAND_PREFIX + commandName, 1);
                return false;
            }
            catch (Exception ex)
            {
                return true;
            }
        }
    }
}