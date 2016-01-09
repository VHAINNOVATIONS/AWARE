using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Linq;
using System.Threading;

namespace AWARE_SQL_Transporter
{   
    class Program
    {
        private const string RPC_NAME = "VEFA AWARE ALERT CACHE";
        private const string FOLLOW_UPS_COMP_STRING = "STATION-DATETIME-ALERTID^FOLLOWUP^FOLLOWUPDATETIME^";
        private const string FOLLOWUP_STRING = "FOLLOWUP";
        private const string LogFileName = "AWARE_SQL_Transporter.log";
        private const string ArchivedLogFileFolder = "Archived Log Files";

        AppSettings theAppSettings = new AppSettings();
        private RPCSharedBrokerSessionMgr2.SharedBroker rpcBroker;
        private RPCSharedBrokerSessionMgr2.ISharedBrokerClient BrokerClient;
        private RPCSharedBrokerSessionMgr2.ISharedBrokerShowErrorMsgs ShowErrMsgs;
        //static SqlConnection connection;
        private string @STATIONDATETIMEALERTID;
        private string @FOLLOWUP;
        private string @FOLLOWUPDATETIME;
        private string @FACILITYNAME;
        private string @SERVICE1;
        private string @CLINIC;
        private string @ORDERINGPROVIDER;
        private string @ALERTTYPE;

        public static void Main(string[] args)
        {
            Program theApp = new Program();
            AwareXmlReader xmlRdr = new AwareXmlReader("AWARE_SQL_Transporter.exe.config");
            xmlRdr.SetNodeXPath("/configuration/VhaSites");
            if (0 < xmlRdr.GetKeyCount())
            {
                SITE_PROPERTY[] configuredSites = xmlRdr.GetVhaSiteConfigCollection();
                foreach (SITE_PROPERTY site in configuredSites)
                {
                    SQLTransporter sqlTrx = null;
                    sqlTrx = new SQLTransporter(string.Format("{0}^{1}", site.VhaSiteMoniker, site.VistaProperties));
                    sqlTrx.DoWork();
                    // Just chill for a sec and let all the writers complete and close
                    Thread.Sleep(1000);
                }
            }
        }

    //    private void DoWork()
    //    {
    //        ManageLogFiles();
    //        LogMessageToFile("------------------------------ Build Version: " + GetBuildVersion() + "---------------------------------------");
    //        LogMessageToFile("Starting SQL Transporter...");
    //        if (GetFreeDiskSpace() < theAppSettings.MinimumAmtFreeDiskSpace)
    //        {
    //            LogMessageToFile("Warning: Total free disk space is less than " + (theAppSettings.MinimumAmtFreeDiskSpace / 1000000) + " megabytes!!!");
    //        }

    //        try
    //        {
    //            string stRpcResults = string.Empty;
    //            object strStDt = "1";
    //            LogMessageToFile("Connecting to " + theAppSettings.VistaIpAddress);
    //            stRpcResults = CallRPC(RPC_NAME, theAppSettings.VistaIpAddress, strStDt);
    //            if (true == string.IsNullOrEmpty(stRpcResults))
    //            {
    //                LogMessageToFile("CallRPC return no data, shutting down till next time");
    //                return;
    //            }

    //            string[] astrLines = stRpcResults.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None);
    //            LogMessageToFile(string.Format("Recieved {0} alert data row(s)", astrLines.Length));
    //            if (true == theAppSettings.GetLogRpcResults())
    //            {
    //                LogMessageToFile("CallRPC Results");
    //                LogMessageToFile("---------------");
    //                foreach (string singleLine in astrLines)
    //                {
    //                    LogMessageToFile(singleLine);
    //                }
    //                LogMessageToFile("---------------");
    //            }
                
    //            //Create a SqlConnection to the AWARE database. 
    //            using (SqlConnection dbConn = new SqlConnection(theAppSettings.SqlServerConnectionString))
    //            {
    //                try
    //                {
    //                    dbConn.Open();
    //                    if(dbConn.State == ConnectionState.Open)
    //                    {
    //                        LogMessageToFile("The SqlConnection is open.");
    //                    }
    //                    else
    //                    {
    //                        LogMessageToFile("ERROR: Unabale to open a connection to SQL.");
    //                        return;
    //                    }

    //                    //Create a SqlDataAdapter for the Alerts table.
    //                    //SqlDataAdapter adapter = new SqlDataAdapter();
    //                    SqlDataAdapter adapter = CreateCustomerAdapter(dbConn);
    //                    // A table mapping names the DataTable.
    //                    // Fill the DataSet.

    //                    DataSet dataSet = new DataSet("Alerts");
    //                    //DataTable Alerts = MakeTable(astrLines[0]);
    //                    DataTable Alerts = dataSet.Tables.Add("Alerts");
    //                    DefineTable(astrLines[0], Alerts);
    //                    //dataSet.Tables.Add(AlertsTable);
    //                    adapter.TableMappings.Add("Alerts$", "Alerts");

    //                    //Create a SqlDataAdapter for the Followups table.
    //                    //SqlDataAdapter adapter = new SqlDataAdapter();
    //                    SqlDataAdapter adapter2 = CreateFollowupsAdapter(dbConn);
    //                    // A table mapping names the DataTable.
    //                    // Fill the DataSet.
    //                    DataSet dataSet2 = new DataSet("Followups");
    //                    DataTable Followups = dataSet2.Tables.Add("Followups");
    //                    DefineTable1(FOLLOW_UPS_COMP_STRING, Followups);
    //                    adapter2.TableMappings.Add("Followups$", "Followups");

                        
    //                    long totalAlertRecords = 0;
    //                    long totalFollowUpRecords = 0;
    //                    int I = -1;
    //                    //Boolean retpoint;
    //                    foreach (string strLine in astrLines)
    //                    {
    //                        I++;
    //                        if (!string.IsNullOrEmpty(strLine))
    //                        {
    //                            long alertRecords = 0;
    //                            long followupReords = 0;
    //                            BuildTable(strLine, Alerts, I, adapter, dataSet, dbConn, adapter2, Followups, dataSet2,
    //                                out alertRecords, out followupReords);
    //                            totalAlertRecords = totalAlertRecords + alertRecords;
    //                            totalFollowUpRecords = totalFollowUpRecords + followupReords;
    //                        }
    //                    }

    //                    //Update the QI Report Manager facility/provider tables 
    //                    int rowCount = 0;
    //                    string sqlText = "usp_SyncQIFacilitiesAndProviders";
    //                    SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
    //                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
    //                    if (true == theAppSettings.GetLogSqlStatements())
    //                        LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, sqlCmd.CommandText));
    //                    try
    //                    {
    //                        rowCount = sqlCmd.ExecuteNonQuery();
    //                    }
    //                    catch (Exception e)
    //                    {
    //                        LogErrorMessage(e);
    //                    }

    //                    // Close the connection.
    //                    if (dbConn.State == ConnectionState.Open)
    //                    {
    //                        dbConn.Close();
    //                    }
    //                    LogMessageToFile("Processed " + totalAlertRecords + " Alert records.");
    //                    LogMessageToFile("Processed " + totalFollowUpRecords + " Followup records.");
    //                    LogMessageToFile("The SqlConnection is closed.");
    //                    LogMessageToFile("SQL Transporter execution is completed.");
    //                }
    //                catch (Exception ex)
    //                {
    //                    LogErrorMessage(ex);
    //                    LogMessageToFile("SQl Transporter execution unsuccessful!");
    //                    return;
    //                }
    //            }
    //        }
    //        catch (NullReferenceException ex)
    //        {
    //            LogErrorMessage(ex);
    //            LogMessageToFile("SQl Transporter execution unsuccessful!");
    //            return;
    //        }
    //    }

    //    /// <summary>
    //    /// If the log file is too large, it will have performance impact for the SQL Transporter. To solve this problem,
    //    /// we will rename the log file from AWARE_SQL_Transporter.log to AWARE_SQL_Transporter_yyyyMMddhhmmss.log when its size > set size (configurable value)
    //    /// 
    //    /// We also want to only keep the last x (configurable value) number of the log files to prevent the disk space full issue.
    //    /// </summary>
    //    private void ManageLogFiles()
    //    {
    //        // rename the log file if it's size exceeds the max size allowed
    //        FileInfo file = new FileInfo(LogFileName);
    //        long logFileSize = 0;
    //        string archivedLogFileFolder = Directory.GetCurrentDirectory() + "\\" + ArchivedLogFileFolder;

    //        // if the log file does not exist yet, the file size is 0
    //        try
    //        {
    //            logFileSize = file.Length;
    //        }
    //        catch
    //        {
    //            logFileSize = 0;
    //        }
    //        if (logFileSize > theAppSettings.MinimumAmtFreeDiskSpace)
    //        {
    //            if (!Directory.Exists(archivedLogFileFolder))
    //            {
    //                Directory.CreateDirectory(archivedLogFileFolder);
    //            }
    //            File.Move(LogFileName, archivedLogFileFolder + "\\" + LogFileName.Replace(".log", "_" + DateTime.Now.ToString("yyyyMMddhhmmss") + ".log"));
    //        }
            
    //        // Delete the oldest log file if the number of the log files exceeds the maximum number of log files allowed.
    //        if (Directory.Exists(archivedLogFileFolder))
    //        {
    //            int numberOfLogFilesToKeep = theAppSettings.MaximumNumberOfSavedLogFiles;
    //            var files = new DirectoryInfo(archivedLogFileFolder).EnumerateFiles()
    //                .Where(f => f.FullName.EndsWith(".log"))
    //                .OrderByDescending(f => f.LastWriteTime)
    //                .Skip(numberOfLogFilesToKeep)
    //                .ToList();

    //            files.ForEach(f => f.Delete());
    //        }
    //    }

    //    private long GetFreeDiskSpace()
    //    {
    //        return new DriveInfo(Path.GetPathRoot(System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName).Substring(0, 1)).AvailableFreeSpace;
    //    }

    //    private string ValidateDateTimeStringValue(string dateTime)
    //    {
    //        DateTime dt = DateTime.Now;
            
    //        if(false == DateTime.TryParse(dateTime,out dt))
    //        {
    //            int idxSpace = dateTime.IndexOf(" ");
    //            string date = dateTime.Substring(0, idxSpace);
    //            string time = dateTime.Substring((idxSpace + 1));

    //            DateTime tmpdate = new DateTime();
    //            DateTime tmpTime = new DateTime();
    //            if (true == DateTime.TryParse(date, out tmpdate))
    //            {
    //                dt = tmpdate;
    //            }

    //            if (true == DateTime.TryParse(time, out tmpTime))
    //            {
    //                // this section still needs abit of work
    //            }
    //        }

    //        return dt.ToString("o");
    //    }

    //    public string CallRPC(string strRPC, string ServerPort, params object[] strP)
    //    {
    //        string strData;
    //        string strParams;
    //        string login;
    //        string ErrorMsg;
    //        bool blnConn = false;

    //        if (rpcBroker == null)
    //        {
    //            blnConn = false;
    //        }

    //        // Create RPC Broker
    //        try
    //        {
    //            if (rpcBroker == null || blnConn == false)
    //            {
    //                rpcBroker = new RPCSharedBrokerSessionMgr2.SharedBroker();
    //                int clientid;
    //                login = "" + Convert.ToChar(28) + "" + Convert.ToChar(28) + theAppSettings.VistaAccessCode + Convert.ToChar(28) + theAppSettings.VistaVerifyCode + Convert.ToChar(28) + "" + Convert.ToChar(28) + '1';
    //                // Connect with Client name, Type, Server:Port, etc.
    //                if (rpcBroker.BrokerConnect("VEFA AWARE ALERT CACHE", BrokerClient, ServerPort, false, false, false, ShowErrMsgs, 0, ref login, out clientid, out ErrorMsg) != RPCSharedBrokerSessionMgr2.ISharedBrokerErrorCode.Success)
    //                {
    //                    blnConn = false;
    //                    throw new Exception("Unable to connect to host or invalid login");
    //                }

    //                if (rpcBroker.BrokerSetContext("VEFA AWARE GET ALERT CACHE") != RPCSharedBrokerSessionMgr2.ISharedBrokerErrorCode.Success)
    //                {
    //                    LogMessageToFile("Error creating context");
    //                    return "";
    //                }

    //                blnConn = true;
    //            }
    //        }
    //        catch (Exception ex)
    //        {
    //            LogMessageToFile("Error creating RPC Broker...");
    //            LogErrorMessage(ex);
    //            return string.Empty;
    //        }

    //        strParams = "";
    //        foreach (object vntItem in strP)
    //        {
    //            strParams = strParams + "L " + vntItem.ToString() + Convert.ToChar(29);
    //        }

    //        if (strParams.Equals("L " + Convert.ToChar(29)))
    //        {
    //            strParams = string.Empty;
    //        }

    //        if (string.IsNullOrEmpty(strParams))
    //        {
    //            LogMessageToFile("DUZ or Other Input\nParameter required.");
    //            return string.Empty;
    //        }

    //        strData = string.Empty;
    //        int rpcCallId;
    //        try
    //        {
    //            rpcBroker.BrokerCall(strRPC, strParams, 0, out strData, out rpcCallId);
    //        }
    //        catch (Exception ex)
    //        {
    //            LogErrorMessage(ex);
    //            rpcBroker.BrokerDisconnect();
    //        }

    //        return strData;
    //    }

    //    private string FormatSqlValue(string value)
    //    {
    //        return value.Replace("'", "''");
    //    }

    //     //public void BuildTable(string [] astrLines)
    //    public void BuildTable(string strLine,DataTable table, int I,SqlDataAdapter adapter,DataSet dataSet,
    //                           SqlConnection connection,SqlDataAdapter adapter2,DataTable Followups,DataSet dataSet2,
    //                           out long totalAlertRecords, out long totalFollowUpRecords)
    //    {            
    //        DataRow row;
    //        DataRowCollection rowCollection = table.Rows;
    //        totalAlertRecords = 0;
    //        totalFollowUpRecords = 0;
  
    //        if (!string.IsNullOrEmpty(strLine))
    //        {
    //            if (I>0)
    //            {                
    //                string[] astrFields = strLine.Split(new string[] {"^"}, StringSplitOptions.None);
    //                int J = 0 ;
    //                if (astrFields[1] != FOLLOWUP_STRING)
    //                {
    //                    //fill with select
    //                    @STATIONDATETIMEALERTID = astrFields[0];
    //                    //dynamically change the select command
    //                    SqlCommand command = new SqlCommand("SELECT * FROM Alerts$ WHERE STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'", connection);
    //                    if (true == theAppSettings.GetLogSqlStatements())
    //                        LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                    adapter.SelectCommand = command;
    //                    adapter.Fill(dataSet);
                        
    //                    command = new SqlCommand("DELETE FROM Alerts$ WHERE STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'", connection);
    //                    if (true == theAppSettings.GetLogSqlStatements())
    //                        LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));
                        
    //                    try
    //                    {
    //                        command.ExecuteNonQuery();
    //                    }
    //                    catch (Exception e)
    //                    {
    //                        LogErrorMessage(e);
    //                    }

    //                    //then delete row if necessary
    //                    foreach (DataRow row1 in table.Rows)
    //                    {
    //                        //dynamically change the delete command

    //                        command = new SqlCommand("DELETE FROM Alerts$ WHERE STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'", connection);
    //                        if (true == theAppSettings.GetLogSqlStatements())
    //                            LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                        try
    //                        {
    //                            command.ExecuteNonQuery();
    //                        }
    //                        catch (Exception e)
    //                        {
    //                            LogErrorMessage(e);
    //                        }

    //                        adapter.DeleteCommand = command;

    //                        row1.Delete();
    //                    }
    //                    // Create a new DataRow.
    //                    row = table.NewRow();
    //                    foreach (string astrField in astrFields)
    //                    {
    //                        //J++;
    //                        if (!string.IsNullOrEmpty(astrField))
    //                        {
    //                            if (J == 2)
    //                            {
    //                                ValidateDateTimeStringValue(astrField);                                                
    //                            }
    //                            row[J] = astrField;                                
    //                        }
    //                        J++;
    //                    }
    //                    // Detached row.
    //                    if (true == theAppSettings.GetLogSqlStatements())
    //                        LogMessageToFile("New Row " + row.RowState);
                                               
    //                    //dynamically change the insert command

    //                    command = new SqlCommand(
    //                                            "INSERT INTO Alerts$ (STATION_DATETIME_ALERTID " +
    //                                            ", ALERTID" +
    //                                            ", DATETIME1" +
    //                                            ", FACILITYNAME" +
    //                                            ", SERVICE1" +
    //                                            ", ORDERINGPROVIDER" +
    //                                            ", ALERTRECIPIENTS" +
    //                                            ", SPARE" +
    //                                            ", ALERTCATEGORY" +
    //                                            ", ALERTTYPE" +
    //                                            ", VALUE1" +
    //                                            ", UNACKSTATUS" +
    //                                            ", ACKRENEWDATE" +
    //                                            ", DELETEDATE" +
    //                                            ", FATSTATUS" +
    //                                            ", FATPROVIDER" +
    //                                            ", FOLLOW_UPPROVIDERID" +
    //                                            ", CLINIC" +
    //                                            ", PATIENTID" +
    //                                            ", ALERTRESULTOR" +
    //                                            ", RESULTORPERSONCLASS" +
    //                                            ", ALERTTYPEORIGSTATION" +
    //                                            ", FOLLOWUPGT7D" +
    //                                            ", ACKGT7D" +
    //                                            ", FOLLOWUPLT7D) " +
    //                                            "VALUES (" + "'" + FormatSqlValue(row[0].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[1].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[2].ToString()) + "'" +                                                
    //                                            ",'" + FormatSqlValue(row[3].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[4].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[5].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[6].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[7].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[8].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[9].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[10].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[11].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[12].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[13].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[14].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[15].ToString()) + "'" +
    //                                            "," + FormatSqlValue(row[16].ToString())  +
    //                                            ",'" + FormatSqlValue(row[17].ToString()) + "'" +
    //                                            "," + FormatSqlValue(row[18].ToString())  +
    //                                            ",'" + FormatSqlValue(row[19].ToString()) + "'" +
    //                                            ",'" + FormatSqlValue(row[20].ToString()) + "'" +
    //                                            "," + FormatSqlValue(row[21].ToString())  +
    //                                            "," + FormatSqlValue(row[22].ToString())  +
    //                                            "," + FormatSqlValue(row[23].ToString())  +
    //                                            "," + FormatSqlValue(row[24].ToString()) + ")" 
    //                                            , connection);
    //                                            //'500-3120507.115027-OR,228,57'
    //                                            //,'May 07, 2012@11:50:27'
    //                                            //,'ALBANY VA MEDICAL CENTER'
    //                                            //,'INFORMATION SYSTEMS CENTER'
    //                                            //,'PROGRAMMER,TWENTY - 755'
    //                                            //,'PROGRAMMER,TWENTY - 755;PROVIDER,EIGHT - 991;PROVIDER,PRF - 11597;VEHU,THIRTEEN - 20013;'
    //                                            //,''
    //                                            //,'Critical labs -'
    //                                            //,'[OCCULT BLOOD]'
    //                                            //,''
    //                                            //,''
    //                                            //,''
    //                                            //,'ONE OR MORE FAT ORDERS/FOLLOW-UPS MADE'
    //                                            //,'PROVIDER,EIGHT - 991'
    //                                            //,'PROVIDER,EIGHT - 991'
    //                                            //,'?'
    //                                            //,'228'
    //                                            //,'LABTECH,SEVENTEEN'
    //                                            //,''
    //                                            //,'500'
    //                                            //,'0'
    //                                            //,'0'
    //                                            //,'1')
    //                    if (true == theAppSettings.GetLogSqlStatements())
    //                        LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));
                        
    //                    try
    //                    {
    //                       command.ExecuteNonQuery();
    //                    }
    //                    catch (Exception e)
    //                    {
    //                        LogErrorMessage(e);
    //                    }
                        
    //                    adapter.InsertCommand = command;
    //                    table.Rows.Add(row);
    //                    // New row.
    //                    if (true == theAppSettings.GetLogSqlStatements())
    //                        LogMessageToFile("AddRow " + row.RowState);
                                                
    //                    totalAlertRecords++;

    //                    table.AcceptChanges();
    //                    UpdateDataSet(dataSet, adapter,row);
    //                    rowCollection.Remove(row);

    //                    //now add values into lookup tables
    //                    BuildLookUpTables(strLine, I, connection);
    //                }
                    
    //                if (astrFields[1] == FOLLOWUP_STRING)
    //                {
    //                    totalFollowUpRecords = totalFollowUpRecords + BuildFollowupTable(strLine, Followups, I, adapter2, dataSet2, connection);
    //                }
    //            }                
    //        }               
    //    }

    //    public long BuildFollowupTable(string strLine, DataTable table, int I, SqlDataAdapter adapter, DataSet dataSet, SqlConnection connection)
    //    {
    //        DataRow row;
    //        DataRowCollection rowCollection = table.Rows;
    //        long totalFollowUpRecords = 0;

    //        if (!string.IsNullOrEmpty(strLine))
    //        {
    //            if (I > 0)
    //            {
    //                string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
    //                int J = -1;
    //                //fill with select
    //                @STATIONDATETIMEALERTID = astrFields[0];
    //                @FOLLOWUP = astrFields[2];
    //                @FOLLOWUPDATETIME = astrFields[3];
    //                SqlCommand command = new SqlCommand("SELECT * FROM Followups$ WHERE (STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'" + ") AND (FOLLOWUP = " + "'" + FormatSqlValue(@FOLLOWUP) + "'" + ") AND (FOLLOWUPDATETIME = " + "'" + FormatSqlValue(@FOLLOWUPDATETIME) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                adapter.SelectCommand = command;
    //                adapter.Fill(dataSet);

    //                command = new SqlCommand("DELETE FROM Followups$ WHERE (STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'" + ") AND (FOLLOWUP = " + "'" + FormatSqlValue(@FOLLOWUP) + "'" + ") AND (FOLLOWUPDATETIME = " + "'" + FormatSqlValue(@FOLLOWUPDATETIME) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
                    
    //                //then delete row if necessary
    //                foreach (DataRow row1 in table.Rows)
    //                {
    //                    command = new SqlCommand("DELETE FROM Followups$ WHERE (STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'" + ") AND (FOLLOWUP = " + "'" + FormatSqlValue(@FOLLOWUP) + "'" + ") AND (FOLLOWUPDATETIME = " + "'" + FormatSqlValue(@FOLLOWUPDATETIME) + "'" + ")", connection);
    //                    if (true == theAppSettings.GetLogSqlStatements())
    //                        LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                    adapter.DeleteCommand = command;
    //                    row1.Delete();
    //                }
    //                // Create a new DataRow.
    //                row = table.NewRow();
    //                foreach (string astrField in astrFields)
    //                {
    //                    J++;
    //                    if (!string.IsNullOrEmpty(astrField))
    //                    {
    //                        if (J == 0) row[J] = astrField;
    //                        if (J == 2) row[J - 1] = astrField;
    //                        if (J == 3) row[J - 1] = astrField;
    //                    }
    //                }
    //                // Detached row.
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile("New Row " + row.RowState);
                                       
    //                command = new SqlCommand("INSERT INTO Followups$ (STATION_DATETIME_ALERTID,FOLLOWUP,FOLLOWUPDATETIME) VALUES (" + "'" + @STATIONDATETIMEALERTID + "'" + "," + "'" + FormatSqlValue(@FOLLOWUP) + "'" + "," + "'" + FormatSqlValue(@FOLLOWUPDATETIME) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }

    //                adapter.InsertCommand = command;
    //                table.Rows.Add(row);
    //                // New row.
    //                Console.WriteLine("AddRow " + row.RowState);
    //                totalFollowUpRecords++;

    //                table.AcceptChanges();
    //                UpdateDataSet(dataSet, adapter, row);
    //                rowCollection.Remove(row);
    //            }
    //        }

    //        return totalFollowUpRecords;
    //    }

    //    public void BuildLookUpTables(string strLine, int I, SqlConnection connection)
    //    {
    //        if (!string.IsNullOrEmpty(strLine))
    //        {
    //            if (I > 0)
    //            {
    //                string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
                    
    //                //fill with select
    //                @FACILITYNAME = astrFields[3];
    //                @SERVICE1 = astrFields[4];
    //                @CLINIC = astrFields[17];
    //                @ORDERINGPROVIDER = astrFields[5];
    //                @ALERTTYPE = astrFields[9];

    //                //************************first FacilityName$ *************************
    //                SqlCommand command = new SqlCommand("DELETE FROM FacilityName$ WHERE (FacilityName = " + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
                    
    //                command = new SqlCommand("INSERT INTO FacilityName$ (FacilityName) VALUES (" + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
    //                //************************next Service$*************************
    //                command = new SqlCommand("DELETE FROM Service$ WHERE (FacilityName = " + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ") AND (Service = " + "'" + FormatSqlValue(@SERVICE1) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
                    
    //                command = new SqlCommand("INSERT INTO Service$ (FacilityName,Service) VALUES (" + "'" + FormatSqlValue(@FACILITYNAME) + "'" + "," + "'" + FormatSqlValue(@SERVICE1) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }

    //                //************************next Clinic$*************************   
    //                command = new SqlCommand("DELETE FROM Clinic$ WHERE (FacilityName = " + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ") AND (Service = " + "'" + FormatSqlValue(@SERVICE1) + "'" + ") AND (Clinic = " + "'" + FormatSqlValue(@CLINIC) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
                    
    //                command = new SqlCommand("INSERT INTO Clinic$ (FacilityName,Service,Clinic) VALUES (" + "'" + FormatSqlValue(@FACILITYNAME) + "'" + "," + "'" + FormatSqlValue(@SERVICE1) + "'" + "," + "'" + FormatSqlValue(@CLINIC) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }

    //                //************************next OrderingProvider$*************************   
    //                command = new SqlCommand("DELETE FROM OrderingProvider$ WHERE (FacilityName = " + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ") AND (Service = " + "'" + FormatSqlValue(@SERVICE1) + "'" + ") AND (Clinic = " + "'" + FormatSqlValue(@CLINIC) + "'" + ") AND (OrderingProvider = " + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));
                    
    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
                    
    //                command = new SqlCommand("INSERT INTO OrderingProvider$ (FacilityName,Service,Clinic,OrderingProvider) VALUES (" + "'" + FormatSqlValue(@FACILITYNAME) + "'" + "," + "'" + FormatSqlValue(@SERVICE1) + "'" + "," + "'" + FormatSqlValue(@CLINIC) + "'" + "," + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);

    //                }

    //                /*******OrderingProviderAllClinics ****/
    //                command = new SqlCommand("DELETE FROM OrderingProviderAllClinics$ WHERE (FacilityName = " + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ") AND (Service = " + "'" + FormatSqlValue(@SERVICE1) + "'" + ") AND (OrderingProvider = " + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }

    //                command = new SqlCommand("INSERT INTO OrderingProviderAllClinics$ (FacilityName,Service,OrderingProvider) VALUES (" + "'" + FormatSqlValue(@FACILITYNAME) + "'" + "," + "'" + FormatSqlValue(@SERVICE1) + "'" + "," + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }

    //                //****OrderingProviderAllServices *********/

    //                command = new SqlCommand("DELETE FROM OrderingProviderAllServices$ WHERE (FacilityName = " + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ") AND (OrderingProvider = " + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }

    //                command = new SqlCommand("INSERT INTO OrderingProviderAllServices$ (FacilityName,OrderingProvider) VALUES (" + "'" + FormatSqlValue(@FACILITYNAME) + "'" + "," + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
                    
    //                //************************next AlertType$*************************   
    //                command = new SqlCommand("DELETE FROM AlertType$ WHERE (FacilityName = " + "'" + FormatSqlValue(@FACILITYNAME) + "'" + ") AND (Service = " + "'" + FormatSqlValue(@SERVICE1) + "'" + ") AND (Clinic = " + "'" + FormatSqlValue(@CLINIC) + "'" + ") AND (OrderingProvider = " + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + ") AND (AlertType = " + "'" + FormatSqlValue(@ALERTTYPE) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }

    //                command = new SqlCommand("INSERT INTO AlertType$ (FacilityName,Service,Clinic,OrderingProvider,AlertType) VALUES (" + "'" + FormatSqlValue(@FACILITYNAME) + "'" + "," + "'" + FormatSqlValue(@SERVICE1) + "'" + "," + "'" + FormatSqlValue(@CLINIC) + "'" + "," + "'" + FormatSqlValue(@ORDERINGPROVIDER) + "'" + "," + "'" + FormatSqlValue(@ALERTTYPE) + "'" + ")", connection);
    //                if (true == theAppSettings.GetLogSqlStatements())
    //                    LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, command.CommandText));

    //                try
    //                {
    //                    command.ExecuteNonQuery();
    //                }
    //                catch (Exception e)
    //                {
    //                    LogErrorMessage(e);
    //                }
    //            }
    //        }
    //    }

    //    public void DefineTable(string strLine, DataTable table)
    //    {
    //        // Make a simple table with one column.
    //        string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
    //        int I = -1;
    //        foreach (string astrField in astrFields)
    //        {
    //            I++;
    //            if (!string.IsNullOrEmpty(astrField))
    //            {
    //                if (I == 0)
    //                {
    //                    DataColumn dcColumn0 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn0);
    //                }
    //                if (I == 1)
    //                {
    //                    DataColumn dcColumn1 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn1);
    //                }
    //                if (I == 2)
    //                {
    //                    DataColumn dcColumn2 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));  //SQL DateTime format
    //                    table.Columns.Add(dcColumn2);
    //                }
    //                if (I == 3)
    //                {
    //                    DataColumn dcColumn3 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn3);
    //                }
    //                if (I == 4)
    //                {
    //                    DataColumn dcColumn4 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn4);
    //                }
    //                if (I == 5)
    //                {
    //                    DataColumn dcColumn5 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn5);
    //                }
    //                if (I == 6)
    //                {
    //                    DataColumn dcColumn6 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn6);
    //                }
    //                if (I == 7)
    //                {
    //                    DataColumn dcColumn7 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn7);
    //                }
    //                if (I == 8)
    //                {
    //                    DataColumn dcColumn8 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn8);
    //                }
    //                if (I == 9)
    //                {
    //                    DataColumn dcColumn9 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn9);
    //                }
    //                if (I == 10)
    //                {
    //                    DataColumn dcColumn10 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn10);         //AlertValue
    //                }
    //                if (I == 11)
    //                {
    //                    DataColumn dcColumn11 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn11);
    //                }
    //                if (I == 12)
    //                {
    //                    DataColumn dcColumn12 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn12); //ACKRENEWDATE SQL datetime format 
    //                }
    //                if (I == 13)
    //                {
    //                    DataColumn dcColumn13 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn13); //DELETEDATE SQL datetime format 
    //                }
    //                if (I == 14)
    //                {
    //                    DataColumn dcColumn14 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn14);
    //                }
    //                if (I == 15)
    //                {
    //                    DataColumn dcColumn15 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn15);
    //                }
    //                if (I == 16)
    //                {
    //                    DataColumn dcColumn16 = new DataColumn(
    //                    astrField, Type.GetType("System.Int64"));
    //                    table.Columns.Add(dcColumn16);  //FOLLOW_UPPROVIDERID
    //                }
    //                if (I == 17)
    //                {
    //                    DataColumn dcColumn17 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn17);
    //                }
    //                if (I == 18)
    //                {
    //                    DataColumn dcColumn18 = new DataColumn(
    //                    astrField, Type.GetType("System.Int64"));
    //                    table.Columns.Add(dcColumn18);  //PATIENTID
    //                }
    //                if (I == 19)
    //                {
    //                    DataColumn dcColumn19 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn19);
    //                }
    //                if (I == 20)
    //                {
    //                    DataColumn dcColumn20 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn20);
    //                }
    //                if (I == 21)
    //                {
    //                    DataColumn dcColumn21 = new DataColumn(
    //                    astrField, Type.GetType("System.Int32"));
    //                    table.Columns.Add(dcColumn21);  //ALERTTYPEORIGSTATION
    //                }
    //                if (I == 22)
    //                {
    //                    DataColumn dcColumn22 = new DataColumn(
    //                    astrField, Type.GetType("System.Int32"));
    //                    table.Columns.Add(dcColumn22);  //FOLLOWUPGT7D
    //                }
    //                if (I == 23)
    //                {
    //                    DataColumn dcColumn23 = new DataColumn(
    //                    astrField, Type.GetType("System.Int32"));
    //                    table.Columns.Add(dcColumn23);  //ACKGT7D
    //                }
    //                if (I == 24)
    //                {
    //                    DataColumn dcColumn24 = new DataColumn(
    //                    astrField, Type.GetType("System.Int32"));
    //                    table.Columns.Add(dcColumn24);  //FOLLOWUPLT7D
    //                }
    //                if (I == 25)
    //                {
    //                    DataColumn dcColumn25 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn25);
    //                }
    //            }
    //        }
    //    }

    //    public void DefineTable1(string strLine, DataTable table)
    //    {
    //        // Make a simple table with one column.
    //        //DataTable table = new DataTable("Followups");
    //        string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
    //        int I = -1;
    //        foreach (string astrField in astrFields)
    //        {
    //            I++;
    //            if (!string.IsNullOrEmpty(astrField))
    //            {
    //                if (I == 0)
    //                {
    //                    DataColumn dcColumn0 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn0);
    //                }
    //                if (I == 1)
    //                {
    //                    DataColumn dcColumn1 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));
    //                    table.Columns.Add(dcColumn1);
    //                }
    //                if (I == 2)
    //                {
    //                    DataColumn dcColumn2 = new DataColumn(
    //                    astrField, Type.GetType("System.String"));  //DATETIME
    //                    table.Columns.Add(dcColumn2);
    //                }
    //                if (I == 3)
    //                {
    //                    DataColumn dcColumn2 = new DataColumn(
    //                    astrField, Type.GetType("System.Int32"));  //FOLLOWGT7D
    //                    table.Columns.Add(dcColumn2);
    //                }
    //            }
    //        }
    //    }

    //    public SqlDataAdapter CreateCustomerAdapter(SqlConnection connection)
    //    {
    //        SqlDataAdapter adapter = new SqlDataAdapter();
    //        //return adapter;

    //        // Create the SelectCommand.
    //        SqlCommand command = new SqlCommand("SELECT * FROM [AWARE].[dbo].[Alerts$] WHERE STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID", connection);
            
    //        // Add the parameters for the SelectCommand.
    //        command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50);
    //        //command.Parameters.Add("@City", SqlDbType.NVarChar, 15);

    //        adapter.SelectCommand = command;
    //        if (true == theAppSettings.GetLogSqlStatements())
    //            LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, adapter.SelectCommand.CommandText));

    //        // Create the DeleteCommand.
    //        command = new SqlCommand("DELETE FROM [AWARE].[dbo].[Alerts$] WHERE STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID", connection);

    //        // Add the parameters for the DeleteCommand.
    //        SqlParameter parameter = command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
    //        parameter.SourceVersion = DataRowVersion.Original;
    //        adapter.DeleteCommand = command;
    //        if (true == theAppSettings.GetLogSqlStatements())
    //            LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, adapter.DeleteCommand.CommandText));

    //        // Create the InsertCommand.
    //        command = new SqlCommand(
    //            "INSERT INTO [AWARE].[dbo].[Alerts$] (STATION_DATETIME_ALERTID, ALERTID, DATETIME1, FACILITYNAME, SERVICE1, ORDERINGPROVIDER, ALERTRECIPIENTS, SPARE, ALERTCATEGORY, ALERTTYPE, VALUE1, UNACKSTATUS, ACKRENEWDATE, DELETEDATE, FATSTATUS, FATPROVIDER, FOLLOW_UPPROVIDERID, CLINIC, PATIENTID, ALERTRESULTOR, RESULTORPERSONCLASS, ALERTTYPEORIGSTATION,FOLLOWUPGT7D,ACKGT7D,FOLLOWUPLT7D) " +
    //            "VALUES (@STATIONDATETIMEALERTID, @ALERTID, @DATETIME1, @FACILITYNAME, @SERVICE1,@ORDERINGPROVIDER, @ALERTRECIPIENTS, @PATIENT, @ALERTCATEGORY, @ALERTTYPE, @VALUE1, @UNACKSTATUS, @ACKRENEWDATE, @DELETEDATE, @FATSTATUS, @FATPROVIDER, @FOLLOW_UPPROVIDERID, @CLINIC, @PATIENTID, @ALERTRESULTOR, @RESULTORPERSONCLASS, @ALERTTYPEORIGSTATION,@FOLLOWUPGT7D,@ACKGT7D,@FOLLOWUPLT7)", connection);


    //        // Add the parameters for the InsertCommand.
    //        command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
    //        command.Parameters.Add("@ALERTID", SqlDbType.VarChar, 50, "ALERTID");
    //        command.Parameters.Add("@DATETIME1", SqlDbType.VarChar, 50, "DATETIME1"); //2015-05-20 00:00:00-000
    //        command.Parameters.Add("@FACILITYNAME", SqlDbType.VarChar, 50, "FACILITYNAME");
    //        command.Parameters.Add("@SERVICE1", SqlDbType.VarChar, 50, "SERVICE1");
    //        command.Parameters.Add("@ORDERINGPROVIDER", SqlDbType.VarChar, 50, "ORDERINGPROVIDER");
    //        command.Parameters.Add("@ALERTRECIPIENTS", SqlDbType.VarChar, 150, "ALERTRECIPIENTS");
    //        command.Parameters.Add("@SPARE", SqlDbType.VarChar, 50, "SPARE");
    //        command.Parameters.Add("@ALERTCATEGORY", SqlDbType.VarChar, 50, "ALERTCATEGORY");
    //        command.Parameters.Add("@ALERTTYPE", SqlDbType.VarChar, 50, "ALERTTYPE");
    //        command.Parameters.Add("@VALUE1", SqlDbType.VarChar, 50, "VALUE1");
    //        command.Parameters.Add("@UNACKSTATUS", SqlDbType.VarChar, 50, "UNACKSTATUS");
    //        command.Parameters.Add("@ACKRENEWDATE", SqlDbType.VarChar, 50, "ACKRENEWDATE");
    //        command.Parameters.Add("@DELETEDATE", SqlDbType.VarChar, 50, "DELETEDATE");
    //        command.Parameters.Add("@FATSTATUS", SqlDbType.VarChar, 50, "FATSTATUS");
    //        command.Parameters.Add("@FATPROVIDER", SqlDbType.VarChar, 50, "FATPROVIDER");
    //        command.Parameters.Add("@FOLLOW_UPPROVIDERID", SqlDbType.NVarChar, 50, "FOLLOW_UPPROVIDERID");
    //        command.Parameters.Add("@CLINIC", SqlDbType.VarChar, 50, "CLINIC");
    //        command.Parameters.Add("@PATIENTID", SqlDbType.NVarChar, 50, "PATIENTID");
    //        command.Parameters.Add("@ALERTRESULTOR", SqlDbType.VarChar, 50, "ALERTRESULTOR");
    //        command.Parameters.Add("@RESULTORPERSONCLASS", SqlDbType.VarChar, 50, "RESULTORPERSONCLASS");
    //        command.Parameters.Add("@ALERTTYPEORIGSTATION", SqlDbType.NVarChar, 50, "ALERTTYPEORIGSTATION");
    //        command.Parameters.Add("@FOLLOWUPGT7D", SqlDbType.NChar, 10, "FOLLOWUPGT7D");
    //        command.Parameters.Add("@ACKGT7D", SqlDbType.NChar, 10, "ACKGT7D");
    //        command.Parameters.Add("@FOLLOWUPLT7", SqlDbType.NChar, 10, "FOLLOWUPLT7");
            
    //        adapter.InsertCommand = command;
    //        if (true == theAppSettings.GetLogSqlStatements())
    //            LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, adapter.InsertCommand.CommandText));

    //        return adapter;
    //    }

    //    public SqlDataAdapter CreateFollowupsAdapter(SqlConnection connection)
    //    {
    //        SqlDataAdapter adapter = new SqlDataAdapter();

    //        // Create the SelectCommand.
    //        SqlCommand command = new SqlCommand("SELECT * FROM [AWARE].[dbo].[Followups$] " +
    //            "WHERE (STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID)" +
    //            " AND (FOLLOWUP = @FOLLOWUP) AND (FOLLOWUPDATETIME = @FOLLOWUPDATETIME)", connection);

    //        // Add the parameters for the SelectCommand.
    //        command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50);
    //        command.Parameters.Add("@FOLLOWUP", SqlDbType.VarChar, 50);
    //        command.Parameters.Add("@FOLLOWUPDATETIME", SqlDbType.DateTime, 23);
    //        //command.Parameters.Add("@City", SqlDbType.NVarChar, 15);

    //        adapter.SelectCommand = command;
    //        if (true == theAppSettings.GetLogSqlStatements())
    //            LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, adapter.SelectCommand.CommandText));

    //        // Create the DeleteCommand.
    //        command = new SqlCommand(
    //            "DELETE FROM [AWARE].[dbo].[Followups$] WHERE (STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID)" +
    //            " AND (FOLLOWUP = @FOLLOWUP) AND (FOLLOWUPDATETIME = @FOLLOWUPDATETIME)", connection);

    //        // Add the parameters for the DeleteCommand.
    //        SqlParameter parameter = command.Parameters.Add(
    //            "@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
    //        command.Parameters.Add("@FOLLOWUP", SqlDbType.VarChar, 50, "FOLLOWUP");
    //        command.Parameters.Add("@FOLLOWUPDATETIME", SqlDbType.DateTime, 23, "FOLLOWUPDATETIME");
    //        parameter.SourceVersion = DataRowVersion.Original;

    //        adapter.DeleteCommand = command;
    //        if (true == theAppSettings.GetLogSqlStatements())
    //            LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, adapter.DeleteCommand.CommandText));

    //        // Create the InsertCommand.
    //        command = new SqlCommand(
    //            "INSERT INTO [AWARE].[dbo].[Followups$] (STATION_DATETIME_ALERTID,FOLLOWUP,FOLLOWUPDATETIME) " +
    //            "VALUES (@STATIONDATETIMEALERTID, @FOLLOWUP, @FOLLOWUPDATETIME)", connection);

    //        // Add the parameters for the InsertCommand.
    //        command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
    //        command.Parameters.Add("@FOLLOWUP", SqlDbType.VarChar, 50, "FOLLOWUP");
    //        command.Parameters.Add("@FOLLOWUPDATETIME", SqlDbType.DateTime, 23, "FOLLOWUPDATETIME"); //2013-01-23@12:25A

    //        adapter.InsertCommand = command;
    //        if (true == theAppSettings.GetLogSqlStatements())
    //            LogMessageToFile(string.Format("{0} : {1}", MethodBase.GetCurrentMethod().Name, adapter.InsertCommand.CommandText));

    //        return adapter;
    //    }

    //    public void UpdateDataSet(DataSet dataSet, SqlDataAdapter adapter, DataRow row)
    //    {
    //        // Check for changes with the HasChanges method first. 
    //        adapter.Update(dataSet);
    //    }

    //    public void LogMessageToFile(string message)
    //    {
    //        using (StreamWriter writer = File.AppendText(LogFileName))
    //        {
    //            writer.WriteLine("{0}: {1}", DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToLongTimeString(), message);
    //        }
    //        Console.WriteLine(message);
    //    }

    //    public string GetBuildVersion()
    //    {
    //        return theAppSettings.ApplicationVersion;
    //    }

    //    public void LogErrorMessage(Exception ex)
    //    {
    //        using (StreamWriter writer = File.AppendText(LogFileName))
    //        {
    //            string message = string.Empty;
    //            StackTrace stack = new StackTrace(ex, true);

    //            writer.WriteLine("{0}: {1}", DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToLongTimeString(), "EXCEPTION: " + ex.Message.Replace("\r\n", "\r\n                       "));
    //            Console.WriteLine("EXCEPTION: " + ex.Message);
    //            foreach (StackFrame frame in stack.GetFrames())
    //            {
    //                if (string.IsNullOrEmpty(frame.GetFileName()))
    //                {
    //                    message = string.Format("METHOD: {0}", frame.GetMethod().ToString());
    //                }
    //                else
    //                {
    //                    message = string.Format("FILE: {0}, LINE: {1}, METHOD: {2}",
    //                        frame.GetFileName(), frame.GetFileLineNumber().ToString(), frame.GetMethod().ToString());
    //                }

    //                writer.WriteLine("                       " + message);                    
    //            }                
    //        }
    //    }
      }
}
