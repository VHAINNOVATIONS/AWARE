using System;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Threading;

namespace AwareDbUtility
{
    public partial class Dlg_Main : Form
    {
        
        private const string DEF_SQL_SCRIPTS_PATH = "C:\\AWARE\\SQLScripts\\Database\\";
        private const string AWARE_DB_STRING = "[AWARE]";
        private const string CREATE_SP_PREFIX = "CREATE PROCEDURE [dbo].[";
        private const string CREATE_TBL_PREFIX = "CREATE TABLE [dbo].[";
        private const string CREATE_VW_PREFIX = "CREATE VIEW [dbo].[";

        private  AppSettings theAppSettings;
        private SQLHelpers theSqlHelpers;

        private const string LOG_FILE_NAME = "AwareDbUtilityLog.log";

        public Dlg_Main(AppSettings appSettings)
        {            
            InitializeComponent();
            rtbxDbStatus.Text = string.Format("Aware DB Utility started: {0}", DateTime.Now.ToString("o"));
            theAppSettings = appSettings;
            theAppSettings.AwareSqlScriptsPath = tbxDbScriptFiles.Text = DEF_SQL_SCRIPTS_PATH;
            theSqlHelpers = new SQLHelpers(ref rtbxDbStatus, theAppSettings.SqlConnString);

            tbxDbDataFilePath.Text = theSqlHelpers.SqlServerDefaultDataPath();
            tbxDbLogFilePath.Text = theSqlHelpers.SqlServerDefaultLogPath();
            _UpdateRadioButtonSelection();
            theSqlHelpers.GetSqlServerName();
            theSqlHelpers.GetSqlServerVersion();
            theSqlHelpers.GetSqlServerCompatibilityLevel();
            _PostDiagnosticMsg("Aware DB Utility initialized!");
        }

        /// <summary>
        /// This method is responsible for posting diagnostic messages to the rtbox
        /// </summary>
        /// <param name="msg">the message to post</param>
        private void _PostDiagnosticMsg(string msg)
        {
            msg = string.Format("{0} : {1}", DateTime.Now.ToString("o"), msg);
            if (rtbxDbStatus.Text.Length > 0)
            {
                rtbxDbStatus.Text = rtbxDbStatus.Text += "\n" + msg;
            }
            else
            {
                rtbxDbStatus.Text = msg;
            }
            rtbxDbStatus.SelectionLength = 0;
            rtbxDbStatus.SelectionStart = rtbxDbStatus.Text.Length;
            rtbxDbStatus.ScrollToCaret();
            Application.DoEvents();
        }

        private void _PostDiagnosticMsg(string msg, MessageBoxButtons buttons, MessageBoxIcon icon)
        {
            MessageBox.Show(msg, theAppSettings.ApplicationName, buttons, icon);
            msg = string.Format("{0} : {1}", DateTime.Now.ToString("o"), msg);
            if (rtbxDbStatus.Text.Length > 0)
            {
                rtbxDbStatus.Text = rtbxDbStatus.Text += "\n" + msg;
            }
            else
            {
                rtbxDbStatus.Text = msg;
            }
            rtbxDbStatus.SelectionLength = 0;
            rtbxDbStatus.SelectionStart = rtbxDbStatus.Text.Length;
            rtbxDbStatus.ScrollToCaret();
            Application.DoEvents();
        }

        /// <summary>
        /// This method closes the application before performing any work.  It will NOT stop the process once 
        /// begin has been clicked.  In that case the user needs to terminate the application vis task manager
        /// and manually walk back the sql operations 
        /// </summary>
        /// <param name="sender">The cancel button (btnCancel)</param>
        /// <param name="e"></param>
        private void btnCancel_Click(object sender, EventArgs e)
        {
            if (btnCancel.Text == "Cancel")
            {
                _PostDiagnosticMsg("**************************");
                _PostDiagnosticMsg("* Cancel button clicked. *");
                _PostDiagnosticMsg("**************************");
                string logFile = LOG_FILE_NAME;
                if (true == File.Exists(logFile))
                {
                    int logIdx = 0;
                    do
                    {
                        logFile = string.Format("AwareDbUtilityLog_{0}.log", ++logIdx);
                    } while (File.Exists(logFile));
                }
                StreamWriter sr = new StreamWriter(logFile);
                sr.AutoFlush = true;
                sr.Write(rtbxDbStatus.Text);
                sr.Close();
            }
            
            this.Close();
        }

        /// <summary>
        /// This method will handle the browsing for a target folder for any folder needs for the application
        /// </summary>
        /// <param name="sender">The specific button that was clicked to invoke this method</param>
        /// <param name="e">No arguments set</param>
        private void BrowseForFolder(object sender, EventArgs e)
        {
            Button howWeGotHereBtn = (Button)sender;
            string btnName = theAppSettings.SqlConnString;

            FolderBrowserDialog dlg = new FolderBrowserDialog();
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                switch (howWeGotHereBtn.Name)
                {
                    case "btnDbFileBrowse":
                        tbxDbDataFilePath.Text = dlg.SelectedPath;
                        break;
                    case "btnDbLogBrowse":
                        tbxDbLogFilePath.Text = dlg.SelectedPath;
                        break;
                    case "btnDbScriptsBrowse":
                        tbxDbScriptFiles.Text = dlg.SelectedPath;
                        break;
                    default:
                        break;
                }                
            }
        }

        /// <summary>
        /// This method will verify whether the database already exixts or not.  If it does the create option will
        /// be disabled and functionality limited to just updating.  If the named database doesnt exist the full
        /// functionality, create and update will be available
        /// </summary>
        /// <param name="sender">Refers to the Database name text box (tbxDbName)</param>
        /// <param name="e">No arguments set</param>
        private void tbxDbName_Leave(object sender, EventArgs e)
        {
            _UpdateRadioButtonSelection();
        }

        private void _UpdateRadioButtonSelection()
        {
            if (true == theSqlHelpers.DatabaseExists(tbxDbName.Text))
            {
                rbtnUpdateDb.Checked = rbtnUpdateDb.Enabled = true;
                rbtnCreateDb.Enabled = rbtnCreateDb.Checked = false;                                
                tbxDbDataFilePath.Text = theSqlHelpers.GetDatabaseDataPath(tbxDbName.Text);
                tbxDbLogFilePath.Text = theSqlHelpers.GetDatabaseLogPath(tbxDbName.Text);
            }
            else
            {
                rbtnUpdateDb.Checked = rbtnUpdateDb.Enabled = false;
                rbtnCreateDb.Enabled = rbtnCreateDb.Checked = true;
            }
        }
        
        private string _StripTrailingBackslashifPresent(string path)
        {
            if (path.LastIndexOf('\\') == (path.Length - 1))
            {
                path = path.Substring(0, path.Length - 1);
            }

            return path;
        }

        private void btnBegin_Click(object sender, EventArgs e)
        {
            Cursor.Current = Cursors.WaitCursor;   
            Application.DoEvents();
            _PostDiagnosticMsg("*************************");
            _PostDiagnosticMsg("* Begin button clicked. *");
            _PostDiagnosticMsg("*************************");
            _PostDiagnosticMsg("Database name input: " + tbxDbName.Text);
            _PostDiagnosticMsg("Database data path input: " + tbxDbDataFilePath.Text);
            _PostDiagnosticMsg("Database log path input: " + tbxDbLogFilePath.Text);
            _PostDiagnosticMsg("Database scripts path input: " + tbxDbScriptFiles.Text);
            
            if (true == rbtnCreateDb.Checked)
            {
                tbxDbDataFilePath.Text = _StripTrailingBackslashifPresent(tbxDbDataFilePath.Text);
                tbxDbLogFilePath.Text = _StripTrailingBackslashifPresent(tbxDbLogFilePath.Text);
                tbxDbScriptFiles.Text = _StripTrailingBackslashifPresent(tbxDbScriptFiles.Text);

                try
                {
                    if (false == Directory.Exists(tbxDbDataFilePath.Text + "\\Bkups"))
                    {
                        Directory.CreateDirectory(tbxDbDataFilePath.Text + "\\Bkups");
                    }

                    if (false == Directory.Exists(tbxDbLogFilePath.Text))
                    {
                        Directory.CreateDirectory(tbxDbLogFilePath.Text);
                    }
                }
                catch (IOException ex)
                {
                    _PostDiagnosticMsg(ex.Message, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    
                    return;
                }

                _CreateDatabase();

                if (true == theSqlHelpers.DatabaseExists(tbxDbName.Text))
                {
                    _UpdateDatabase();
                }
                else
                {
                    _PostDiagnosticMsg("Database creation failed", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                if (true == theSqlHelpers.DatabaseExists(tbxDbName.Text))
                {
                    _PostDiagnosticMsg("DB Created");
                }
            }

            if (true == rbtnUpdateDb.Checked)
            {
                if (true == theSqlHelpers.DatabaseExists(tbxDbName.Text))
                {
                    tbxDbScriptFiles.Text = _StripTrailingBackslashifPresent(tbxDbScriptFiles.Text);
                    try
                    {
                        if (false == Directory.Exists(tbxDbScriptFiles.Text))
                        {
                            _PostDiagnosticMsg("Database scripts folder not found!", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            return;
                        }
                        _UpdateDatabase();
                        _PostDiagnosticMsg("Database update completed!", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                    catch (IOException ex)
                    {
                        _PostDiagnosticMsg("Database update failed.", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }
            }

            Cursor.Current = Cursors.Default;
            Application.DoEvents();
            _PostDiagnosticMsg(string.Format("Aware DB Utility completed: {0}", DateTime.Now.ToString("o")));

            string logFile = LOG_FILE_NAME;
            if (true == File.Exists(logFile))
            {
                int logIdx = 0;
                do
                {
                    logFile = string.Format("AwareDbUtilityLog_{0}.log", ++logIdx);
                } while (File.Exists(logFile));
            }
            StreamWriter sr = new StreamWriter(logFile);
            sr.AutoFlush = true;
            sr.Write(rtbxDbStatus.Text);
            sr.Close();
            btnBegin.Enabled = false;
            btnCancel.Text = "Close";
        }        
    
        private void _CreateDatabase()
        {
            if (false == theSqlHelpers.DatabaseExists(tbxDbName.Text))
            {
                theSqlHelpers.CreateDatabase(tbxDbName.Text, tbxDbDataFilePath.Text, tbxDbLogFilePath.Text, true);               
            }
        }

        private void _UpdateDatabase()
        {            
            if (true == theSqlHelpers.DatabaseExists(tbxDbName.Text))
            {
                tbxDbScriptFiles.Text = _StripTrailingBackslashifPresent(tbxDbScriptFiles.Text);
                try
                {
                    if (true == Directory.Exists(tbxDbScriptFiles.Text))
                    {
                        //TABLES
                        string [] tablesSql =Directory.GetFiles(tbxDbScriptFiles.Text + "\\2.Tables", "*.sql");
                        foreach (string tableSqlFile in tablesSql)
                        {
                            using (StreamReader sr = new StreamReader(tableSqlFile, Encoding.ASCII))
                            {
                                string fileContents = fileContents = sr.ReadToEnd();
                                fileContents = fileContents.Replace(AWARE_DB_STRING, string.Format("[{0}]", tbxDbName.Text));
                                if (false == theSqlHelpers.TableExists(tbxDbName.Text, _GetTableNameFromSqlFile(fileContents)))
                                {
                                    _PostDiagnosticMsg("TABLE MISSING: " + _GetTableNameFromSqlFile(fileContents));
                                    theSqlHelpers.ExecuteSqlScript(fileContents, ref rtbxDbStatus);
                                    Application.DoEvents();
                                    Thread.Sleep(250);
                                }
                                sr.Close();
                            }
                        }

                        //VIEWS
                        string[] viewsSql = Directory.GetFiles(tbxDbScriptFiles.Text + "\\3.Views", "*.sql");
                        foreach (string viewSqlFile in viewsSql)
                        {
                            using (StreamReader sr = new StreamReader(viewSqlFile, Encoding.ASCII))
                            {
                                string fileContents = fileContents = sr.ReadToEnd();
                                fileContents = fileContents.Replace(AWARE_DB_STRING, string.Format("[{0}]", tbxDbName.Text));
                                if (false == theSqlHelpers.ViewExists(tbxDbName.Text, _GetViewNameFromSqlFile(fileContents)))
                                {
                                    _PostDiagnosticMsg("VIEW MISSING: " + _GetTableNameFromSqlFile(fileContents));
                                    theSqlHelpers.ExecuteSqlScript(fileContents, ref rtbxDbStatus);
                                    Application.DoEvents();
                                    Thread.Sleep(250);
                                }
                                sr.Close();
                            }
                        }

                        // INDEXES
                        // not implemented yet

                        // STORED PROCEDURES
                        string[] spsSql = Directory.GetFiles(tbxDbScriptFiles.Text + "\\5.StoredProcedures", "*.sql");
                        foreach (string spSqlFile in spsSql)
                        {
                            // does the procedure already exists?
                            using (StreamReader sr = new StreamReader(spSqlFile, Encoding.ASCII))
                            {
                                string fileContents = fileContents = sr.ReadToEnd();
                                fileContents = fileContents.Replace(AWARE_DB_STRING, string.Format("[{0}]", tbxDbName.Text));
                                string spName = _GetSPNameFromSqlFile(fileContents);
                                if (true == theSqlHelpers.StoredProcedureExists(tbxDbName.Text, spName))
                                {
                                    theSqlHelpers.DropStoredProcedure(tbxDbName.Text, spName);
                                }
                                theSqlHelpers.ExecuteSqlScript(fileContents, ref rtbxDbStatus);
                                sr.Close();
                                Application.DoEvents();
                                Thread.Sleep(250);
                            }
                        }
                    }
                }
                catch (IOException ex)
                {
                }
            }
        }

        private string _GetSPNameFromSqlFile(string sqlFileContents)
        {
            int srchBegIdx = (sqlFileContents.IndexOf(CREATE_SP_PREFIX) + CREATE_SP_PREFIX.Length);
            int srchEndIdx = sqlFileContents.IndexOf("]", srchBegIdx);
            return sqlFileContents.Substring(srchBegIdx, (srchEndIdx - srchBegIdx));
        }

        private string _GetTableNameFromSqlFile(string sqlFileContents)
        {
            int srchBegIdx = (sqlFileContents.IndexOf(CREATE_TBL_PREFIX) + CREATE_TBL_PREFIX.Length);
            int srchEndIdx = sqlFileContents.IndexOf("]", srchBegIdx);
            return sqlFileContents.Substring(srchBegIdx, (srchEndIdx - srchBegIdx));
        }

        private string _GetViewNameFromSqlFile(string sqlFileContents)
        {
            int srchBegIdx = (sqlFileContents.IndexOf(CREATE_VW_PREFIX) + CREATE_VW_PREFIX.Length);
            int srchEndIdx = sqlFileContents.IndexOf("]", srchBegIdx);
            return sqlFileContents.Substring(srchBegIdx, (srchEndIdx - srchBegIdx));
        }
        

        private void _UpdateStatistics()
        {
        }

    }
}
