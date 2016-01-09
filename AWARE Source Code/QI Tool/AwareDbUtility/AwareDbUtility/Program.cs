using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace AwareDbUtility
{
    static class Program
    {
        public static AppSettings theAppSettings = new AppSettings();
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {            
            Application.EnableVisualStyles();            
            Application.SetCompatibleTextRenderingDefault(false);
            theAppSettings.ApplicationName = "AWARE Database Utility";
            Dlg_DbOptions dlg = new Dlg_DbOptions(ref theAppSettings);
            if ((DialogResult.OK == dlg.ShowDialog())&&(dlg.DBConnectionTested == true))
            {                
                Application.Run(new Dlg_Main(theAppSettings));
            }
        }
    }
}
