using System;
using System.Runtime.InteropServices;
using EnvDTE;
using EnvDTE80;
using Microsoft.VisualStudio.Shell.Interop;
using SolutionFactory.Exporter;
using SolutionFactory.Services;
using IServiceProvider=Microsoft.VisualStudio.OLE.Interop.IServiceProvider;

namespace SolutionFactory.Services
{
    public class IoC : IIoC
    {
        private readonly DTE2 _dte2;

        public IoC(DTE2 dte2)
        {
            _dte2 = dte2;
        }

        public IVsMonitorSelection MonitorSelection
        {
            get { return GetService<IVsMonitorSelection>(); }
        }

        #region IIoC Members

        public TInterface GetService<TInterface>()
        {
            return (TInterface) GetService(_dte2, typeof (TInterface).GUID);
        }

        public ExportGenerator CreateExportGenerator()
        {
            return new ExportGenerator(
                (DTE) _dte2,
                new FileSystem(),
                new FileTokenReplacer(new FileSystem()),
                new MessageBox());
        }

        #endregion

        public object GetService(object serviceProvider, Guid guid)
        {
            object objService = null;

            IServiceProvider objIServiceProvider;

            IntPtr objIntPtr;

            int hr;

            Guid objSIDGuid;
            Guid objIIDGuid;
            objSIDGuid = guid;
            objIIDGuid = objSIDGuid;
            objIServiceProvider = (IServiceProvider) serviceProvider;
            hr = objIServiceProvider.QueryService(ref objSIDGuid, ref objIIDGuid, out objIntPtr);
            if (hr != 0)
            {
                Marshal.ThrowExceptionForHR(hr);
            }
            else if (!objIntPtr.Equals(IntPtr.Zero))
            {
                objService = Marshal.GetObjectForIUnknown(objIntPtr);
                Marshal.Release(objIntPtr);
            }
            return objService;
        }
    }
}