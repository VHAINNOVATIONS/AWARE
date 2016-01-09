using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Net;
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;
using System.Windows.Forms;

namespace AwareDbUtility
{
    class SQLHelpers
    {
        public const string AWARE_DB_NAME = "Aware";

        private const string MASTER_DB_NAME = "master";
        private const string REGVAL_USE_INT_SEC = "UseIntSecurity";
        private const int SQL_SERVER_PORT = 2737;
        
        private int m_SqlTimeoutVal = 15;   //seconds
        private RichTextBox theStatusBox;

        private string[,] DBConfigs = new string[,] {{"ANSI_NULL_DEFAULT", "OFF"}, {"ANSI_NULLS", "OFF"},{"ANSI_PADDING", "OFF"},{"ANSI_WARNINGS", "OFF"},
                                                      {"ARITHABORT", "OFF"}, {"AUTO_CLOSE", "OFF"}, {"AUTO_CREATE_STATISTICS", "ON"}, {"AUTO_SHRINK", "OFF"},
                                                      {"AUTO_UPDATE_STATISTICS", "ON"}, {"CURSOR_CLOSE_ON_COMMIT", "OFF"}, {"CURSOR_DEFAULT", "GLOBAL"}, 
                                                      {"CONCAT_NULL_YIELDS_NULL", "OFF"}, {"NUMERIC_ROUNDABORT", "OFF"}, {"QUOTED_IDENTIFIER", "OFF"}, 
                                                      {"RECURSIVE_TRIGGERS", "OFF"}, {"DISABLE_BROKER", ""}, {"AUTO_UPDATE_STATISTICS_ASYNC", "OFF"}, 
                                                      {"DATE_CORRELATION_OPTIMIZATION", "OFF"}, {"TRUSTWORTHY", "OFF"}, {"ALLOW_SNAPSHOT_ISOLATION", "ON"},
                                                      {"PARAMETERIZATION", "SIMPLE"}, {"READ_COMMITTED_SNAPSHOT", "ON"}, {"HONOR_BROKER_PRIORITY", "OFF"}, 
                                                      {"READ_WRITE", ""}, {"RECOVERY", "SIMPLE"}, {"MULTI_USER", ""}, {"PAGE_VERIFY", "CHECKSUM"}, 
                                                      {"DB_CHAINING", "OFF"}
                                                     };
        
        public string SqlConnectionString { get; set; }

        public SQLHelpers(ref RichTextBox statusBox , string dbConnString)
        {
            theStatusBox = statusBox;
            SqlConnectionString = dbConnString;
        }

        protected void OnInfoMessage(object sender, SqlInfoMessageEventArgs args)
        {
            _PostDiagnosticMsg(args.Message);

            foreach (SqlError err in args.Errors)
            {
                if (err.Number != 5701)
                {
                    _PostDiagnosticMsg(
                        string.Format(
                            "The {0} has received a severity {1}, state {2} error number {3}\n on line {4} of procedure {5} on server {6}:\n{7}",
                            err.Source, err.Class, err.State, err.Number, err.LineNumber,
                            err.Procedure, err.Server, err.Message));
                }
            }
        }

        protected void OnStateChange(object sender, StateChangeEventArgs args)
        {
            _PostDiagnosticMsg(string.Format("The current Connection state has changed from {0} to {1}.", args.OriginalState, args.CurrentState));
        }
        
        private void _PostDiagnosticMsg(string msg)
        {
            msg = string.Format("{0} : {1}", DateTime.Now.ToString("o"), msg);
            if (theStatusBox.Text.Length > 0)
            {
                theStatusBox.Text = theStatusBox.Text += "\n" + msg;
            }
            else
            {
                theStatusBox.Text = msg;
            }
        }


        public SqlConnection GetDbConnection()
        {
            _PostDiagnosticMsg("Getting DB Connection");
            SqlConnection sqlConn = new SqlConnection(SqlConnectionString);            
            try
            {
                sqlConn.Open();
                if (sqlConn.State.ToString() == "Open")
                {
                    sqlConn.InfoMessage += new SqlInfoMessageEventHandler(OnInfoMessage);
                    sqlConn.StateChange  += new StateChangeEventHandler(OnStateChange);
                    SqlCommand sqlCmd = new SqlCommand();
                    sqlCmd.CommandText = "SET QUOTED_IDENTIFIER OFF";
                    sqlCmd.Connection = sqlConn;
                    sqlCmd.ExecuteNonQuery();                    
                }                
            }

            catch (SqlException ex)
            {                
                sqlConn = null;
                _PostDiagnosticMsg(ex.Message);
            }

            catch (InvalidOperationException ex)
            {                
                sqlConn = null;
                _PostDiagnosticMsg(ex.Message);
            }
            
            return sqlConn;
        }

        public void CloseDbConnection(SqlConnection dbConn)
        {
            try
            {
                dbConn.Close();   
                _PostDiagnosticMsg("Closing database connection");
            }
            catch (SqlException ex)
            {                
                dbConn = null;
                _PostDiagnosticMsg(ex.Message);
            }

            catch (InvalidOperationException ex)
            {                
                dbConn = null;
                _PostDiagnosticMsg(ex.Message);
            }            
        }

        public string GetSqlServerName()
        {   
            string svr = string.Empty;
            SqlConnection dbConn = this.GetDbConnection();
            if (null != dbConn)
            {
                svr = dbConn.DataSource;
                CloseDbConnection(dbConn);
            }
            _PostDiagnosticMsg("SQL Server name: "+ svr);
            return svr;            
        }

        public string GetSqlServerVersion()
        {
            string ver = string.Empty;
            SqlConnection dbConn = this.GetDbConnection();
            if (null != dbConn)
            {
                ver = dbConn.ServerVersion;
                CloseDbConnection(dbConn);
            }

            _PostDiagnosticMsg("SQL Server version: " + ver);
            return ver;
        }

        public bool DatabaseExists(string dbName)
        {
            bool exists = false;
            string sqlCmdText = string.Format("SELECT count(*) FROM master.dbo.sysdatabases WHERE name = \"{0}\"", dbName);
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            if (0 < (int)sqlCmd.ExecuteScalar())
                exists = true;

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("Database: " + dbName + " exists");
            return exists;
        }

        public bool TableExists(string dbName, string tblName)
        {
            bool exists = false;
            string sqlCmdText = String.Format("SELECT COUNT(*) FROM sys.objects WHERE type = \"U\" AND name = \"{0}\"", tblName);
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(dbName);
            if (0 < (int)sqlCmd.ExecuteScalar())
                exists = true;

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("Table: " + dbName + ".." + tblName + " exists");
            return exists;
        }

        public bool ViewExists(string dbName, string vwName)
        {
            bool exists = false;
            string sqlCmdText = String.Format("SELECT COUNT(*) FROM sys.objects WHERE type = \"V\" AND name = \"{0}\"", vwName);
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(dbName);
            if (0 < (int)sqlCmd.ExecuteScalar())
                exists = true;

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("View: " + dbName + ".." + vwName + " exists");
            return exists;
        }

        public bool StoredProcedureExists(string dbName, string spName)
        {
            bool exists = false;
            string sqlCmdText = String.Format("SELECT COUNT(*) FROM sys.objects WHERE type = \"P\" AND name = \"{0}\"", spName);
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(dbName);
            if (0 < (int)sqlCmd.ExecuteScalar())
                exists = true;

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("Stored Procedure: " + dbName + ".." + spName + " exists");
            return exists;
        }

        public bool DropStoredProcedure(string dbName, string spName)
        {
            _PostDiagnosticMsg("Dropping Stored Procedure: " + dbName + ".." + spName);
            string sqlCmdText = String.Format("DROP PROCEDURE {0}", spName);
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(dbName);
            sqlCmd.ExecuteNonQuery();
            
            CloseDbConnection(sqlCmd.Connection);
            return StoredProcedureExists(dbName, spName);
        }

        public string SqlServerDefaultDataPath()
        {
            string path = string.Empty;
            string sqlCmdText = "SELECT SUBSTRING(physical_name, 1, CHARINDEX(\"master.mdf\", LOWER(physical_name)) - 1) FROM master.sys.master_files WHERE database_id = 1 AND file_id = 1";
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            path = (string)sqlCmd.ExecuteScalar();

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("Default SQL Server Data path: " + path);
            return path;
        }

        public string SqlServerDefaultLogPath()
        {
            string path = string.Empty;
            string sqlCmdText = "SELECT SUBSTRING(physical_name, 1, CHARINDEX(\"mastlog.ldf\", LOWER(physical_name)) - 1) FROM master.sys.master_files WHERE database_id = 1 AND file_id = 2";
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            path = (string)sqlCmd.ExecuteScalar();

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("Default SQL Server TRX Log path: " + path);
            return path;
        }

        public int GetDatabaseId(string dbName)
        {
            int dbId = 0;
            if (true == DatabaseExists(dbName))
            {
                //string sqlCmdText = string.Format("select database_id from master.sys.master_files where name = \"{0}\"", dbName);
                string sqlCmdText = string.Format("SELECT smf.database_id FROM master.sys.master_files smf JOIN master.dbo.sysdatabases sdb ON sdb.dbid = smf.database_id WHERE sdb.name =  \"{0}\"", dbName);
                SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
                sqlCmd.Connection = this.GetDbConnection();
                dbId = (int)sqlCmd.ExecuteScalar();

                CloseDbConnection(sqlCmd.Connection);
            }
            _PostDiagnosticMsg("Database " + dbName + " id=" + dbId.ToString());
            return dbId;
        }

        public string GetDatabaseDataPath(string dbName)
        {
            string path = string.Empty;
            string sqlCmdText = string.Format("SELECT physical_name FROM master.sys.master_files WHERE database_id = {0} AND file_id = 1", GetDatabaseId(dbName));
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            path = (string)sqlCmd.ExecuteScalar();

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("Database Data path: " + path);                         
            return path.Substring(0, path.LastIndexOf('\\'));
        }

        public string GetDatabaseLogPath(string dbName)
        {
            string path = string.Empty;
            string sqlCmdText = string.Format("SELECT physical_name FROM master.sys.master_files WHERE database_id = {0} AND file_id = 2", GetDatabaseId(dbName));
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            path = (string)sqlCmd.ExecuteScalar();
            _PostDiagnosticMsg("Database TRX Log path: " + path);
            CloseDbConnection(sqlCmd.Connection);

            return path.Substring(0, path.LastIndexOf('\\'));
        }

        public bool CreateDatabase(string dbName, string dataPath, string logPath, bool applyDefDbSettings)
        {            
            _PostDiagnosticMsg("Creating database " + dbName + " on " + dataPath);
            string sqlCmdText = string.Format("CREATE DATABASE {0} ON  PRIMARY ( NAME = \"{0}\", FILENAME = \"{1}\\{0}.mdf\", SIZE = 4096KB , FILEGROWTH = 1024KB ) LOG ON ( NAME = \"{0}_Log\", FILENAME = \"{2}\\{0}_Log.ldf\", SIZE = 1024KB , FILEGROWTH = 10%)", dbName, dataPath, logPath);
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.ExecuteNonQuery();

            if ((true == applyDefDbSettings)&&(true == DatabaseExists(dbName)))
            {                
                SetCompatibilityLevelToServerDefault(dbName);
                EnableFullText(dbName, true);
                SetCLREnabled(true);
                for (int idx = 0; idx < DBConfigs.GetLength(0); idx++)
                {
                    string stg = DBConfigs[idx, 0];
                    string val = DBConfigs[idx, 1];
                    AlterDbConfiguration(dbName, stg, val);
                }
            }

            CloseDbConnection(sqlCmd.Connection);
            return DatabaseExists(dbName);            
        }

        public byte GetSqlServerCompatibilityLevel()
        {
            byte compLvl = 0;
            string sqlCmdText = "SELECT compatibility_level from sys.databases where name = \"master\"";
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(MASTER_DB_NAME);
            compLvl = (byte)sqlCmd.ExecuteScalar();

            CloseDbConnection(sqlCmd.Connection);
            _PostDiagnosticMsg("SQL Server compatibility level: " + compLvl.ToString())
            ;
            return compLvl;
        }

        public bool SetCompatibilityLevelToServerDefault(string dbName)
        {
            _PostDiagnosticMsg("Setting database " + dbName + " compatibility level to server default");
            bool success = true;
            string sqlCmdText = string.Format("USE MASTER ALTER DATABASE {0} SET COMPATIBILITY_LEVEL = {1}", dbName, GetSqlServerCompatibilityLevel().ToString());
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(MASTER_DB_NAME);
            int cnt = sqlCmd.ExecuteNonQuery();
            if (cnt == 0)
                success = false;

            CloseDbConnection(sqlCmd.Connection);
            return success;
        }

        public bool AlterDbConfiguration(string dataBase, string setting, string value)
        {
            _PostDiagnosticMsg("Altering database " + dataBase + " setting: " + setting + "-" + value);
            bool success = true;
            string sqlCmdText = string.Empty;
            if (value.Length == 0)
            {
                sqlCmdText = string.Format("ALTER DATABASE {0} SET {1}", dataBase, setting);
            }
            else
            {
                sqlCmdText = string.Format("ALTER DATABASE {0} SET {1} {2}", dataBase, setting, value);
            }
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(MASTER_DB_NAME);
            int cnt = sqlCmd.ExecuteNonQuery();
            if (cnt == 0)
                success = false;

            CloseDbConnection(sqlCmd.Connection);
            return success;
        }

        public bool EnableFullText(string dataBase, bool enable)
        {            
            _PostDiagnosticMsg("Setting database " + dataBase + " Full Text service to " + enable.ToString());
            bool success = true;
            string sqlCmdText = string.Empty;
            if (false == enable)
            {
                sqlCmdText = string.Format("IF (1 = FULLTEXTSERVICEPROPERTY(\"IsFullTextInstalled\"))begin EXEC {0}.dbo.sp_fulltext_database @action = \"disable\" end", dataBase);
            }
            else
            {
                sqlCmdText = string.Format("IF (1 = FULLTEXTSERVICEPROPERTY(\"IsFullTextInstalled\"))begin EXEC {0}.dbo.sp_fulltext_database @action = \"enable\" end", dataBase);
            }
            SqlCommand sqlCmd = new SqlCommand(sqlCmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(MASTER_DB_NAME);
            int cnt = sqlCmd.ExecuteNonQuery();
            if (cnt == 0)
                success = false;

            CloseDbConnection(sqlCmd.Connection);
            return success;
        }

        public void SetCLREnabled(bool enable)
        {
            _PostDiagnosticMsg("Setting CLR Enabled to " + enable.ToString());
            string cmdText = "EXEC sp_configure \"show advanced options\", 1";
            SqlCommand sqlCmd = new SqlCommand(cmdText);
            sqlCmd.Connection = this.GetDbConnection();
            sqlCmd.Connection.ChangeDatabase(MASTER_DB_NAME);
            sqlCmd.ExecuteNonQuery();

            cmdText = "reconfigure";
            sqlCmd.CommandText = cmdText;
            sqlCmd.ExecuteNonQuery();

            cmdText = "EXEC sp_configure \"xp_cmdshell\", 1";
            sqlCmd.CommandText = cmdText;
            sqlCmd.ExecuteNonQuery();

            cmdText = "reconfigure";
            sqlCmd.CommandText = cmdText;
            sqlCmd.ExecuteNonQuery();

            cmdText = "EXEC sp_configure \"xp_cmdshell\", 1";
            sqlCmd.CommandText = cmdText;
            sqlCmd.ExecuteNonQuery();

            if (enable == true)
            {
                cmdText = "EXEC sp_configure \"clr enabled\", \"1\"";
            }
            else
            {
                cmdText = "EXEC sp_configure \"clr enabled\", \"1\"";
            }
            sqlCmd.CommandText = cmdText;
            sqlCmd.ExecuteNonQuery();

            cmdText = "reconfigure";
            sqlCmd.CommandText = cmdText;
            sqlCmd.ExecuteNonQuery();

            cmdText = "EXEC sp_configure \"xp_cmdshell\", 1";
            sqlCmd.CommandText = cmdText;
            sqlCmd.ExecuteNonQuery();

            CloseDbConnection(sqlCmd.Connection);
        }

        public void ExecuteSqlScript(string sqlScriptText, ref RichTextBox theRtb)
        {   
            _PostDiagnosticMsg("Executing SQL Script: \n" + sqlScriptText);
            
            // gotta do this a little differently to allow for the "GO" if present in a sql statement
            SqlConnection sqlConnection = new SqlConnection(SqlConnectionString);
            ServerConnection svrConnection = new ServerConnection(sqlConnection);
            Server sqlServer = new Server(svrConnection);
            try
            {
                sqlServer.ConnectionContext.ExecuteNonQuery(sqlScriptText);
                svrConnection.CommitTransaction();
            }
            catch (ExecutionFailureException ex)
            {                
                string msg = ex.Message;
            }

            theRtb.SelectionLength = 0;
            theRtb.SelectionStart = theRtb.Text.Length;
            theRtb.ScrollToCaret();
            Application.DoEvents();
            
        }
    }    
}
