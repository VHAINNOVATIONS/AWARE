using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.Diagnostics;

namespace AWARE_SQL_Transporter
{
        
    class ObjectTest
    {
        public string s = "1";
    }
    class Program
    {
        static RPCSharedBrokerSessionMgr2.SharedBroker rpcBroker;
        static RPCSharedBrokerSessionMgr2.ISharedBrokerClient BrokerClient;
        static RPCSharedBrokerSessionMgr2.ISharedBrokerShowErrorMsgs ShowErrMsgs;
        static SqlConnection connection;
        static string @STATIONDATETIMEALERTID;
        static string @FOLLOWUP;
        static string @FOLLOWUPDATETIME;
        static string @FACILITYNAME;
        static string @SERVICE1;
        static string @CLINIC;
        static string @ORDERINGPROVIDER;
        static string @ALERTTYPE;

        
        public static string CallRPC(string strRPC, string ServerPort, params object[] strP)
        {
            string strData;
            string strParams;
            string login;
            string ErrorMsg;
            bool blnConn = false;

            if (rpcBroker == null)
            {
                blnConn = false;
            }

            // Create RPC Broker
            try
            {
                if (rpcBroker == null || blnConn == false)
                {
                    rpcBroker = new RPCSharedBrokerSessionMgr2.SharedBroker();
                    int clientid;
                    login = "" + Convert.ToChar(28) + "" + Convert.ToChar(28) + Properties.Settings.Default.AccessCode + Convert.ToChar(28) + Properties.Settings.Default.VerifyCode + Convert.ToChar(28) + "" + Convert.ToChar(28) + '1';
                    // Connect with Client name, Type, Server:Port, etc.
                    if (rpcBroker.BrokerConnect("VEFA AWARE ALERT CACHE", BrokerClient, ServerPort, false, false, false, ShowErrMsgs, 0, ref login, out clientid, out ErrorMsg) != RPCSharedBrokerSessionMgr2.ISharedBrokerErrorCode.Success)
                    {
                        blnConn = false;
                        throw new Exception("Unable to connect to host or invalid login");
                    }

                    if (rpcBroker.BrokerSetContext("VEFA AWARE GET ALERT CACHE") != RPCSharedBrokerSessionMgr2.ISharedBrokerErrorCode.Success)
                    {
                        LogMessageToFile("Error creating context");
                        return "";
                    }

                    blnConn = true;
                }
            }
            catch (Exception ex)
            {
                LogMessageToFile("Error creating RPC Broker...");
                LogErrorMessage(ex);
                return string.Empty;
            }

            strParams = "";
            foreach (object vntItem in strP)
            {
                strParams = strParams + "L " + vntItem.ToString() + Convert.ToChar(29);
            }

            if (strParams.Equals("L " + Convert.ToChar(29)))
            {
                strParams = string.Empty;
            }

            if (string.IsNullOrEmpty(strParams))
            {
                LogMessageToFile("DUZ or Other Input\nParameter required.");
                return string.Empty;
            }

            strData = string.Empty;
            int rpcCallId;
            try
            {
                rpcBroker.BrokerCall(strRPC, strParams, 0, out strData, out rpcCallId);
            }
            catch (Exception ex)
            {
                LogErrorMessage(ex);
                rpcBroker.BrokerDisconnect();
            }

            return strData;
        }



         //public void BuildTable(string [] astrLines)
        public static void BuildTable(string strLine,DataTable table, int I,SqlDataAdapter adapter,DataSet dataSet,
            SqlConnection connection,SqlDataAdapter adapter2,DataTable Followups,DataSet dataSet2,
            out long totalAlertRecords, out long totalFollowUpRecords)
        {
            
            DataRow row;
            DataRowCollection rowCollection = table.Rows;
            totalAlertRecords = 0;
            totalFollowUpRecords = 0;
  
                if (!string.IsNullOrEmpty(strLine))
                {
                    if (I>0)
                    {
                    
                    string[] astrFields = strLine.Split(new string[] {"^"}, StringSplitOptions.None);
                    int J = -1 ;
                    if (astrFields[1] != "FOLLOWUP")
                    {

                        //fill with select
                        @STATIONDATETIMEALERTID = astrFields[0];
                        //dynamically change the select command
                        SqlCommand command = new SqlCommand("SELECT * FROM Alerts$ " +
                "WHERE STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'", connection);
                        adapter.SelectCommand = command;
                        adapter.Fill(dataSet);


                        command = new SqlCommand(
           "DELETE FROM Alerts$ WHERE STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'", connection);


                        try
                        {
                            command.ExecuteNonQuery();
                        }
                        catch (Exception e)
                        {
                            LogErrorMessage(e);
                        }

                        //then delete row if necessary
                        foreach (DataRow row1 in table.Rows)
                        {
                            //dynamically change the delete command

                            command = new SqlCommand(
               "DELETE FROM Alerts$ WHERE STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'", connection);

                            try
                            {
                                command.ExecuteNonQuery();
                            }
                            catch (Exception e)
                            {
                                LogErrorMessage(e);
                            }

                            adapter.DeleteCommand = command;

                            row1.Delete();
                        }
                        // Create a new DataRow.
                        row = table.NewRow();
                        foreach (string astrField in astrFields)
                        {
                            J++;
                            if (!string.IsNullOrEmpty(astrField))
                            {


                                //if (J == 0) { row[J] = astrField; }
                                row[J] = astrField;
                                
                            }
                        }
                        // Detached row.
                        Console.WriteLine("New Row " + row.RowState);
                        //dynamically change the insert command

                        command = new SqlCommand(
                        "INSERT INTO Alerts$ (STATION_DATETIME_ALERTID " +
                        ", ALERTID" +
                        ", DATETIME1" +
                        ", FACILITYNAME" +
                        ", SERVICE1" +
                        ", ORDERINGPROVIDER" +
                        ", ALERTRECIPIENTS" +
                        ", SPARE" +
                        ", ALERTCATEGORY" +
                        ", ALERTTYPE" +
                        ", VALUE1" +
                        ", UNACKSTATUS" +
                        ", ACKRENEWDATE" +
                        ", DELETEDATE" +
                        ", FATSTATUS" +
                        ", FATPROVIDER" +
                        ", FOLLOW_UPPROVIDERID" +
                        ", CLINIC" +
                        ", PATIENTID" +
                        ", ALERTRESULTOR" +
                        ", RESULTORPERSONCLASS" +
                        ", ALERTTYPEORIGSTATION" +
                        ", FOLLOWUPGT7D" +
                        ", ACKGT7D" +
                        ", FOLLOWUPLT7D) " +
                        "VALUES (" + "'" + row[0] + "'" +
                        ",'" + row[1] + "'" +
                        ",'" + row[2] + "'" +
                        ",'" + row[3] + "'" +
                        ",'" + row[4] + "'" +
                        ",'" + row[5] + "'" +
                        ",'" + row[6] + "'" +
                        ",'" + row[7] + "'" +
                        ",'" + row[8] + "'" +
                        ",'" + row[9] + "'" +
                        ",'" + row[10] + "'" +
                        ",'" + row[11] + "'" +
                        ",'" + row[12] + "'" +
                        ",'" + row[13] + "'" +
                        ",'" + row[14] + "'" +
                        ",'" + row[15] + "'" +
                        "," + row[16]  +
                        ",'" + row[17] + "'" +
                        "," + row[18]  +
                        ",'" + row[19] + "'" +
                        ",'" + row[20] + "'" +
                        "," + row[21]  +
                        "," + row[22]  +
                        "," + row[23]  +
                        "," + row[24] + ")" 
                        , connection);
                        //'500-3120507.115027-OR,228,57'
                        //,'May 07, 2012@11:50:27'
                        //,'ALBANY VA MEDICAL CENTER'
                        //,'INFORMATION SYSTEMS CENTER'
                        //,'PROGRAMMER,TWENTY - 755'
                        //,'PROGRAMMER,TWENTY - 755;PROVIDER,EIGHT - 991;PROVIDER,PRF - 11597;VEHU,THIRTEEN - 20013;'
                        //,''
                        //,'Critical labs -'
                        //,'[OCCULT BLOOD]'
                        //,''
                        //,''
                        //,''
                        //,'ONE OR MORE FAT ORDERS/FOLLOW-UPS MADE'
                        //,'PROVIDER,EIGHT - 991'
                        //,'PROVIDER,EIGHT - 991'
                        //,'?'
                        //,'228'
                        //,'LABTECH,SEVENTEEN'
                        //,''
                        //,'500'
                        //,'0'
                        //,'0'
                        //,'1')
                        
                        try
                        {
                           command.ExecuteNonQuery();
                        }
                        catch (Exception e)
                        {
                            LogErrorMessage(e);
                        }
                        
                        adapter.InsertCommand = command;
                        table.Rows.Add(row);
                        // New row.
                        Console.WriteLine("AddRow " + row.RowState);
                        totalAlertRecords++;

                        table.AcceptChanges();
                        UpdateDataSet(dataSet, adapter,row);
                        rowCollection.Remove(row);

                        //now add values into lookup tables
                        BuildLookUpTables(strLine, I, connection);

                    }
                    if (astrFields[1] == "FOLLOWUP")
                    {

                        totalFollowUpRecords = totalFollowUpRecords + BuildFollowupTable(strLine, Followups, I, adapter2, dataSet2, connection);
                    }
                    }
                    
                }
                
               
        }
        public static long BuildFollowupTable(string strLine, DataTable table, int I, SqlDataAdapter adapter, DataSet dataSet, SqlConnection connection)
        {

            DataRow row;
            DataRowCollection rowCollection = table.Rows;
            long totalFollowUpRecords = 0;

            if (!string.IsNullOrEmpty(strLine))
            {
                if (I > 0)
                {

                    string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
                    int J = -1;


                    //fill with select
                    @STATIONDATETIMEALERTID = astrFields[0];
                    @FOLLOWUP = astrFields[2];
                    @FOLLOWUPDATETIME = astrFields[3];
                    SqlCommand command = new SqlCommand("SELECT * FROM Followups$ " +
             "WHERE (STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'" + ")" +
             " AND (FOLLOWUP = " + "'" + @FOLLOWUP + "'" + ") AND (FOLLOWUPDATETIME = " + "'" + @FOLLOWUPDATETIME + "'" + ")", connection);
                    adapter.SelectCommand = command;
                    adapter.Fill(dataSet);

                    command = new SqlCommand(
               "DELETE FROM Followups$ WHERE (STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'" + ")" +
               " AND (FOLLOWUP = " + "'" + @FOLLOWUP + "'" + ") AND (FOLLOWUPDATETIME = " + "'" + @FOLLOWUPDATETIME + "'" + ")", connection);

                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }


                    //then delete row if necessary
                    foreach (DataRow row1 in table.Rows)
                    {
                        command = new SqlCommand(
            "DELETE FROM Followups$ WHERE (STATION_DATETIME_ALERTID = " + "'" + @STATIONDATETIMEALERTID + "'" + ")" +
            " AND (FOLLOWUP = " + "'" + @FOLLOWUP + "'" + ") AND (FOLLOWUPDATETIME = " + "'" + @FOLLOWUPDATETIME + "'" + ")", connection);
                        adapter.DeleteCommand = command;
                        row1.Delete();
                    }
                    // Create a new DataRow.
                    row = table.NewRow();
                    foreach (string astrField in astrFields)
                    {
                        J++;
                        if (!string.IsNullOrEmpty(astrField))
                        {


                            if (J == 0) row[J] = astrField;
                            if (J == 2) row[J - 1] = astrField;
                            if (J == 3) row[J - 1] = astrField;

                        }
                    }
                    // Detached row.
                    Console.WriteLine("New Row " + row.RowState);

                    command = new SqlCommand(
               "INSERT INTO Followups$ (STATION_DATETIME_ALERTID,FOLLOWUP,FOLLOWUPDATETIME) " +
               "VALUES (" + "'" + @STATIONDATETIMEALERTID + "'" + "," + "'" + @FOLLOWUP + "'" + "," + "'" + @FOLLOWUPDATETIME + "'" + ")", connection);

                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }


                    adapter.InsertCommand = command;
                    table.Rows.Add(row);
                    // New row.
                    Console.WriteLine("AddRow " + row.RowState);
                    totalFollowUpRecords++;

                    table.AcceptChanges();
                    UpdateDataSet(dataSet, adapter, row);
                    rowCollection.Remove(row);


                }
            }
            return totalFollowUpRecords;

        }


        public static void BuildLookUpTables(string strLine, int I, SqlConnection connection)
        {


            if (!string.IsNullOrEmpty(strLine))
            {
                if (I > 0)
                {

                    string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
                    int J = -1;


                    //fill with select
                    @FACILITYNAME = astrFields[3];
                    @SERVICE1 = astrFields[4];
                    @CLINIC = astrFields[17];
                    @ORDERINGPROVIDER = astrFields[5];
                    @ALERTTYPE = astrFields[9];

                    //************************first FacilityName$ *************************



                    SqlCommand command = new SqlCommand(
               "DELETE FROM FacilityName$ WHERE (FacilityName = " + "'" + @FACILITYNAME + "'" + ")", connection);

                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }



                    command = new SqlCommand(
               "INSERT INTO FacilityName$ (FacilityName) " +
               "VALUES (" + "'" + @FACILITYNAME + "'" + ")", connection);

                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }
                    //************************next Service$*************************




                    command = new SqlCommand(
            "DELETE FROM Service$ WHERE (FacilityName = " + "'" + @FACILITYNAME + "'" + ")" +
            " AND (Service = " + "'" + @SERVICE1 + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }




                    command = new SqlCommand(
             "INSERT INTO Service$ (FacilityName,Service) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }

                    //************************next Clinic$*************************   


                    command = new SqlCommand(
            "DELETE FROM Clinic$ WHERE (FacilityName = " + "'" + @FACILITYNAME + "'" + ")" +
            " AND (Service = " + "'" + @SERVICE1 + "'" + ") AND (Clinic = " + "'" + @CLINIC + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }


                    command = new SqlCommand(
             "INSERT INTO Clinic$ (FacilityName,Service,Clinic) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + "," + "'" + @CLINIC + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }
                    //************************next OrderingProvider$*************************   


                    command = new SqlCommand(
            "DELETE FROM OrderingProvider$ WHERE (FacilityName = " + "'" + @FACILITYNAME + "'" + ")" +
            " AND (Service = " + "'" + @SERVICE1 + "'" + ") AND (Clinic = " + "'" + @CLINIC + "'" + ") AND (OrderingProvider = " + "'" + @ORDERINGPROVIDER + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }


                    command = new SqlCommand(
             "INSERT INTO OrderingProvider$ (FacilityName,Service,Clinic,OrderingProvider) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + "," + "'" + @CLINIC + "'" + "," + "'" + @ORDERINGPROVIDER + "'" + ")", connection);





                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);

                    }



                    /*******OrderingProviderAllClinics ****/
                    command = new SqlCommand(
            "DELETE FROM OrderingProviderAllClinics$ WHERE (FacilityName = " + "'" + @FACILITYNAME + "'" + ")" +
            " AND (Service = " + "'" + @SERVICE1 + "'" + ") AND (OrderingProvider = " + "'" + @ORDERINGPROVIDER + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }


                    command = new SqlCommand(
             "INSERT INTO OrderingProviderAllClinics$ (FacilityName,Service,OrderingProvider) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + "," + "'" + @ORDERINGPROVIDER + "'" + ")", connection);





                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);

                    }

                    //****OrderingProviderAllServices *********/

                    command = new SqlCommand(
            "DELETE FROM OrderingProviderAllServices$ WHERE (FacilityName = " + "'" + @FACILITYNAME + "'" + ")" +
            " AND (OrderingProvider = " + "'" + @ORDERINGPROVIDER + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }


                    command = new SqlCommand(
             "INSERT INTO OrderingProviderAllServices$ (FacilityName,OrderingProvider) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @ORDERINGPROVIDER + "'" + ")", connection);





                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);

                    }


                    //************************next AlertType$*************************   


                    command = new SqlCommand(
            "DELETE FROM AlertType$ WHERE (FacilityName = " + "'" + @FACILITYNAME + "'" + ")" +
            " AND (Service = " + "'" + @SERVICE1 + "'" + ") AND (Clinic = " + "'" + @CLINIC + "'" + ") AND (OrderingProvider = " + "'" + @ORDERINGPROVIDER + "'" + ") AND (AlertType = " + "'" + @ALERTTYPE + "'" + ")", connection);



                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }


                    command = new SqlCommand(
             "INSERT INTO AlertType$ (FacilityName,Service,Clinic,OrderingProvider,AlertType) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + "," + "'" + @CLINIC + "'" + "," + "'" + @ORDERINGPROVIDER + "'" + "," + "'" + @ALERTTYPE + "'" + ")", connection);


                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        LogErrorMessage(e);
                    }

                }

            }


        }



        public static void DefineTable(string strLine, DataTable table)
        {
            // Make a simple table with one column.
            string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
            int I = -1;
            foreach (string astrField in astrFields)
            {
                I++;
                if (!string.IsNullOrEmpty(astrField))
                {
                    if (I == 0)
                    {
                        DataColumn dcColumn0 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn0);
                    }
                    if (I == 1)
                    {
                        DataColumn dcColumn1 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn1);
                    }
                    if (I == 2)
                    {
                        DataColumn dcColumn2 = new DataColumn(
                    astrField, Type.GetType("System.String"));  //SQL DateTime format
                        table.Columns.Add(dcColumn2);
                    }
                    if (I == 3)
                    {
                        DataColumn dcColumn3 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn3);
                    }
                    if (I == 4)
                    {
                        DataColumn dcColumn4 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn4);
                    }
                    if (I == 5)
                    {
                        DataColumn dcColumn5 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn5);
                    }
                    if (I == 6)
                    {
                        DataColumn dcColumn6 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn6);
                    }
                    if (I == 7)
                    {
                        DataColumn dcColumn7 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn7);
                    }
                    if (I == 8)
                    {
                        DataColumn dcColumn8 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn8);
                    }
                    if (I == 9)
                    {
                        DataColumn dcColumn9 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn9);
                    }
                    if (I == 10)
                    {
                        DataColumn dcColumn10 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn10);         //AlertValue
                    }
                    if (I == 11)
                    {
                        DataColumn dcColumn11 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn11);
                    }
                    if (I == 12)
                    {
                        DataColumn dcColumn12 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn12); //ACKRENEWDATE SQL datetime format 
                    }
                    if (I == 13)
                    {
                        DataColumn dcColumn13 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn13); //DELETEDATE SQL datetime format 
                    }
                    if (I == 14)
                    {
                        DataColumn dcColumn14 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn14);
                    }
                    if (I == 15)
                    {
                        DataColumn dcColumn15 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn15);
                    }
                    if (I == 16)
                    {
                        DataColumn dcColumn16 = new DataColumn(
                    astrField, Type.GetType("System.Int64"));
                        table.Columns.Add(dcColumn16);  //FOLLOW_UPPROVIDERID
                    }
                    if (I == 17)
                    {
                        DataColumn dcColumn17 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn17);
                    }
                    if (I == 18)
                    {
                        DataColumn dcColumn18 = new DataColumn(
                    astrField, Type.GetType("System.Int64"));
                        table.Columns.Add(dcColumn18);  //PATIENTID
                    }
                    if (I == 19)
                    {
                        DataColumn dcColumn19 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn19);
                    }
                    if (I == 20)
                    {
                        DataColumn dcColumn20 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn20);
                    }
                    if (I == 21)
                    {
                        DataColumn dcColumn21 = new DataColumn(
                    astrField, Type.GetType("System.Int32"));
                        table.Columns.Add(dcColumn21);  //ALERTTYPEORIGSTATION
                    }
                    if (I == 22)
                    {
                        DataColumn dcColumn22 = new DataColumn(
                    astrField, Type.GetType("System.Int32"));
                        table.Columns.Add(dcColumn22);  //FOLLOWUPGT7D
                    }
                    if (I == 23)
                    {
                        DataColumn dcColumn23 = new DataColumn(
                    astrField, Type.GetType("System.Int32"));
                        table.Columns.Add(dcColumn23);  //ACKGT7D
                    }
                    if (I == 24)
                    {
                        DataColumn dcColumn24 = new DataColumn(
                    astrField, Type.GetType("System.Int32"));
                        table.Columns.Add(dcColumn24);  //FOLLOWUPLT7D
                    }
                    if (I == 25)
                    {
                        DataColumn dcColumn25 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn25);
                    }
                }
            }


            //return table;
        }
        public static void DefineTable1(string strLine, DataTable table)
        {
            // Make a simple table with one column.
            //DataTable table = new DataTable("Followups");
            string[] astrFields = strLine.Split(new string[] { "^" }, StringSplitOptions.None);
            int I = -1;
            foreach (string astrField in astrFields)
            {
                I++;
                if (!string.IsNullOrEmpty(astrField))
                {
                    if (I == 0)
                    {
                        DataColumn dcColumn0 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn0);
                    }
                    if (I == 1)
                    {
                        DataColumn dcColumn1 = new DataColumn(
                    astrField, Type.GetType("System.String"));
                        table.Columns.Add(dcColumn1);
                    }
                    if (I == 2)
                    {
                        DataColumn dcColumn2 = new DataColumn(
                    astrField, Type.GetType("System.String"));  //DATETIME
                        table.Columns.Add(dcColumn2);
                    }
                    if (I == 3)
                    {
                        DataColumn dcColumn2 = new DataColumn(
                    astrField, Type.GetType("System.Int32"));  //FOLLOWGT7D
                        table.Columns.Add(dcColumn2);
                    }

                }
            }


            // return table;
        }
        public static SqlDataAdapter CreateCustomerAdapter(SqlConnection connection)
        {
            SqlDataAdapter adapter = new SqlDataAdapter();
            //return adapter;

            // Create the SelectCommand.
            SqlCommand command = new SqlCommand("SELECT * FROM [AWARE].[dbo].[Alerts$] " +
                "WHERE STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID", connection);

            // Add the parameters for the SelectCommand.
            command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50);
            //command.Parameters.Add("@City", SqlDbType.NVarChar, 15);

            adapter.SelectCommand = command;



            // Create the DeleteCommand.
            command = new SqlCommand(
                "DELETE FROM [AWARE].[dbo].[Alerts$] WHERE STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID", connection);

            // Add the parameters for the DeleteCommand.
            SqlParameter parameter = command.Parameters.Add(
                "@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
            parameter.SourceVersion = DataRowVersion.Original;

            adapter.DeleteCommand = command;

            // Create the InsertCommand.
            command = new SqlCommand(
                "INSERT INTO [AWARE].[dbo].[Alerts$] (STATION_DATETIME_ALERTID, ALERTID, DATETIME1, FACILITYNAME, SERVICE1, ORDERINGPROVIDER, ALERTRECIPIENTS, SPARE, ALERTCATEGORY, ALERTTYPE, VALUE1, UNACKSTATUS, ACKRENEWDATE, DELETEDATE, FATSTATUS, FATPROVIDER, FOLLOW_UPPROVIDERID, CLINIC, PATIENTID, ALERTRESULTOR, RESULTORPERSONCLASS, ALERTTYPEORIGSTATION,FOLLOWUPGT7D,ACKGT7D,FOLLOWUPLT7D) " +
                "VALUES (@STATIONDATETIMEALERTID, @ALERTID, @DATETIME1, @FACILITYNAME, @SERVICE1,@ORDERINGPROVIDER, @ALERTRECIPIENTS, @PATIENT, @ALERTCATEGORY, @ALERTTYPE, @VALUE1, @UNACKSTATUS, @ACKRENEWDATE, @DELETEDATE, @FATSTATUS, @FATPROVIDER, @FOLLOW_UPPROVIDERID, @CLINIC, @PATIENTID, @ALERTRESULTOR, @RESULTORPERSONCLASS, @ALERTTYPEORIGSTATION,@FOLLOWUPGT7D,@ACKGT7D,@FOLLOWUPLT7)", connection);

            // Add the parameters for the InsertCommand.
            command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
            command.Parameters.Add("@ALERTID", SqlDbType.VarChar, 50, "ALERTID");
            command.Parameters.Add("@DATETIME1", SqlDbType.VarChar, 50, "DATETIME1"); //2015-05-20 00:00:00-000
            command.Parameters.Add("@FACILITYNAME", SqlDbType.VarChar, 50, "FACILITYNAME");
            command.Parameters.Add("@SERVICE1", SqlDbType.VarChar, 50, "SERVICE1");
            command.Parameters.Add("@ORDERINGPROVIDER", SqlDbType.VarChar, 50, "ORDERINGPROVIDER");
            command.Parameters.Add("@ALERTRECIPIENTS", SqlDbType.VarChar, 150, "ALERTRECIPIENTS");
            command.Parameters.Add("@SPARE", SqlDbType.VarChar, 50, "SPARE");
            command.Parameters.Add("@ALERTCATEGORY", SqlDbType.VarChar, 50, "ALERTCATEGORY");
            command.Parameters.Add("@ALERTTYPE", SqlDbType.VarChar, 50, "ALERTTYPE");
            command.Parameters.Add("@VALUE1", SqlDbType.VarChar, 50, "VALUE1");
            command.Parameters.Add("@UNACKSTATUS", SqlDbType.VarChar, 50, "UNACKSTATUS");
            command.Parameters.Add("@ACKRENEWDATE", SqlDbType.VarChar, 50, "ACKRENEWDATE");
            command.Parameters.Add("@DELETEDATE", SqlDbType.VarChar, 50, "DELETEDATE");
            command.Parameters.Add("@FATSTATUS", SqlDbType.VarChar, 50, "FATSTATUS");
            command.Parameters.Add("@FATPROVIDER", SqlDbType.VarChar, 50, "FATPROVIDER");
            command.Parameters.Add("@FOLLOW_UPPROVIDERID", SqlDbType.NVarChar, 50, "FOLLOW_UPPROVIDERID");
            command.Parameters.Add("@CLINIC", SqlDbType.VarChar, 50, "CLINIC");
            command.Parameters.Add("@PATIENTID", SqlDbType.NVarChar, 50, "PATIENTID");
            command.Parameters.Add("@ALERTRESULTOR", SqlDbType.VarChar, 50, "ALERTRESULTOR");
            command.Parameters.Add("@RESULTORPERSONCLASS", SqlDbType.VarChar, 50, "RESULTORPERSONCLASS");
            command.Parameters.Add("@ALERTTYPEORIGSTATION", SqlDbType.NVarChar, 50, "ALERTTYPEORIGSTATION");
            command.Parameters.Add("@FOLLOWUPGT7D", SqlDbType.NChar, 10, "FOLLOWUPGT7D");
            command.Parameters.Add("@ACKGT7D", SqlDbType.NChar, 10, "ACKGT7D");
            command.Parameters.Add("@FOLLOWUPLT7", SqlDbType.NChar, 10, "FOLLOWUPLT7");


            adapter.InsertCommand = command;



            return adapter;
        }
        public static SqlDataAdapter CreateFollowupsAdapter(SqlConnection connection)
        {
            SqlDataAdapter adapter = new SqlDataAdapter();

            // Create the SelectCommand.
            SqlCommand command = new SqlCommand("SELECT * FROM [AWARE].[dbo].[Followups$] " +
                "WHERE (STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID)" +
                " AND (FOLLOWUP = @FOLLOWUP) AND (FOLLOWUPDATETIME = @FOLLOWUPDATETIME)", connection);

            // Add the parameters for the SelectCommand.
            command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50);
            command.Parameters.Add("@FOLLOWUP", SqlDbType.VarChar, 50);
            command.Parameters.Add("@FOLLOWUPDATETIME", SqlDbType.DateTime, 23);
            //command.Parameters.Add("@City", SqlDbType.NVarChar, 15);

            adapter.SelectCommand = command;



            // Create the DeleteCommand.
            command = new SqlCommand(
                "DELETE FROM [AWARE].[dbo].[Followups$] WHERE (STATION_DATETIME_ALERTID = @STATIONDATETIMEALERTID)" +
                " AND (FOLLOWUP = @FOLLOWUP) AND (FOLLOWUPDATETIME = @FOLLOWUPDATETIME)", connection);

            // Add the parameters for the DeleteCommand.
            SqlParameter parameter = command.Parameters.Add(
                "@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
            command.Parameters.Add("@FOLLOWUP", SqlDbType.VarChar, 50, "FOLLOWUP");
            command.Parameters.Add("@FOLLOWUPDATETIME", SqlDbType.DateTime, 23, "FOLLOWUPDATETIME");
            parameter.SourceVersion = DataRowVersion.Original;

            adapter.DeleteCommand = command;

            // Create the InsertCommand.
            command = new SqlCommand(
                "INSERT INTO [AWARE].[dbo].[Followups$] (STATION_DATETIME_ALERTID,FOLLOWUP,FOLLOWUPDATETIME) " +
                "VALUES (@STATIONDATETIMEALERTID, @FOLLOWUP, @FOLLOWUPDATETIME)", connection);

            // Add the parameters for the InsertCommand.
            command.Parameters.Add("@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50, "STATION_DATETIME_ALERTID");
            command.Parameters.Add("@FOLLOWUP", SqlDbType.VarChar, 50, "FOLLOWUP");
            command.Parameters.Add("@FOLLOWUPDATETIME", SqlDbType.DateTime, 23, "FOLLOWUPDATETIME"); //2013-01-23@12:25A


            adapter.InsertCommand = command;



            return adapter;
        }

        public static void UpdateDataSet(DataSet dataSet, SqlDataAdapter adapter, DataRow row)
        {
            // Check for changes with the HasChanges method first. 
            adapter.Update(dataSet);
        }

        public static void LogMessageToFile(string message)
        {
            using (StreamWriter writer = File.AppendText("AWARE_SQL_Transporter.log"))
            {
                writer.WriteLine("{0}: {1}", DateTime.Now.ToLongTimeString(), message);
            }
            Console.WriteLine(message);
        }


        public static void LogErrorMessage(Exception ex)
        {
            using (StreamWriter writer = File.AppendText("AWARE_SQL_Transporter.log"))
            {
                string message = string.Empty;
                StackTrace stack = new StackTrace(ex, true);

                writer.WriteLine("{0}: {1}", DateTime.Now.ToLongTimeString(), "EXCEPTION: " + ex.Message);
                Console.WriteLine("EXCEPTION: " + ex.Message);
                foreach (StackFrame frame in stack.GetFrames())
                {
                    if (string.IsNullOrEmpty(frame.GetFileName()))
                    {
                        message = string.Format("METHOD: {0}", frame.GetMethod().ToString());
                    }
                    else
                    {
                        message = string.Format("FILE: {0}, LINE: {1}, METHOD: {2}",
                            frame.GetFileName(), frame.GetFileLineNumber().ToString(), frame.GetMethod().ToString());
                    }

                    writer.WriteLine("            " + message);
                    Console.WriteLine(message);
                }
                
            }
        }


 
        static public void ConnectToData1(SqlDataAdapter adapter, SqlConnection connection, string strLine, DataTable table, int I, DataSet dataSet)
        {
            // Create a second Adapter and Command to get 
            // the Products table, a child table of Suppliers. 
            SqlDataAdapter productsAdapter = new SqlDataAdapter();
            productsAdapter.TableMappings.Add("Table", "Products");

            SqlCommand productsCommand = new SqlCommand(
                "SELECT ProductID, SupplierID FROM dbo.Products;",
                connection);
            productsAdapter.SelectCommand = productsCommand;

            // Fill the DataSet.
            productsAdapter.Fill(dataSet);

            // Close the connection.
            connection.Close();
            LogMessageToFile("The SqlConnection is closed.");

            // Create a DataRelation to link the two tables 
            // based on the SupplierID.
            DataColumn parentColumn =
                dataSet.Tables["Suppliers"].Columns["SupplierID"];
            DataColumn childColumn =
                dataSet.Tables["Products"].Columns["SupplierID"];
            DataRelation relation =
                new System.Data.DataRelation("SuppliersProducts",
                parentColumn, childColumn);
            dataSet.Relations.Add(relation);
            LogMessageToFile("The "+ relation.RelationName + " DataRelation has been created.");
        }

        private static long GetFreeDiskSpace()
        {
            long diskSpace = 0;

            FileInfo file = new FileInfo("AWARE_SQL_Transporter.log");
            string drive = Path.GetPathRoot(file.FullName);

            foreach (DriveInfo driveInfo in DriveInfo.GetDrives())
            {
                if (driveInfo.IsReady && driveInfo.Name == drive)
                {
                    diskSpace =  driveInfo.TotalFreeSpace;
                    break;
                }
            }

            return diskSpace;
        }

        public static void Main(string[] args)
        {
            string vistAIPAddress = string.Empty;
            string connectionString;
            string followups = "STATION-DATETIME-ALERTID^FOLLOWUP^FOLLOWUPDATETIME^";
            object strStDt = "1";


            LogMessageToFile("---------------------------------------------------------------------");
            LogMessageToFile("Starting SQL Transporter...");
            if (GetFreeDiskSpace() < Convert.ToInt64(Properties.Settings.Default.FreeDiskSpaceLimitMB) * 1000000)
            {
                LogMessageToFile("Warning: Total free disk space is less than " + Properties.Settings.Default.FreeDiskSpaceLimitMB + " megabytes!!!");
            }


            //3/27/2014 sb
            // need to handle the case where the CallRPC doesnt return any value (null)
            try
            {
                string stR = string.Empty;

                if (args.Length == 0)
                {
                    vistAIPAddress = Properties.Settings.Default.VistAIPAddress;
                }
                else
                {
                    try
                    {
                        for (int i = 0; i < args.Length; i++)
                        {
                            if (i == 0)
                            {
                                // expected input is "ecptest.houston.med.va.gov:19019;DUZ;station#508"
                                string[] input = args[i].Split(';');
                                strStDt = input[0];

                                if (input.Length > 0)
                                {
                                    switch (input[0])
                                    {
                                        case "1":
                                            vistAIPAddress = Properties.Settings.Default.VistAIPAddress;
                                            break;
                                        case "2":
                                            vistAIPAddress = Properties.Settings.Default.VistAIPAddress2;
                                            break;
                                        case "3":
                                            vistAIPAddress = Properties.Settings.Default.VistAIPAddress3;
                                            break;
                                        default:
                                            vistAIPAddress = Properties.Settings.Default.VistAIPAddress;
                                            break;

                                    }
                               }
                            }
                        }
                    }
                    catch
                    {
                        LogMessageToFile("Error: Invalid arguments.");
                    }
                }


                LogMessageToFile("Connecting to " + vistAIPAddress);
                stR = CallRPC("VEFA AWARE ALERT CACHE", vistAIPAddress, strStDt);
                if (true == string.IsNullOrEmpty(stR))
                return;

                string[] astrLines = stR.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None);
                int I = -1;

                connectionString = Properties.Settings.Default.SQLServerConnectionString;

                //Create a SqlConnection to the AWARE database. 
                using (connection =
                           new SqlConnection(connectionString))
                {
                    try
                    {
                        connection.Open();

                        //Create a SqlDataAdapter for the Alerts table.
                        //SqlDataAdapter adapter = new SqlDataAdapter();
                        SqlDataAdapter adapter = CreateCustomerAdapter(connection);
                        // A table mapping names the DataTable.
                        // Fill the DataSet.

                        DataSet dataSet = new DataSet("Alerts");
                        //DataTable Alerts = MakeTable(astrLines[0]);
                        DataTable Alerts = dataSet.Tables.Add("Alerts");
                        DefineTable(astrLines[0], Alerts);
                        //dataSet.Tables.Add(AlertsTable);
                        adapter.TableMappings.Add("Alerts$", "Alerts");

                        //Create a SqlDataAdapter for the Followups table.
                        //SqlDataAdapter adapter = new SqlDataAdapter();
                        SqlDataAdapter adapter2 = CreateFollowupsAdapter(connection);
                        // A table mapping names the DataTable.
                        // Fill the DataSet.
                        DataSet dataSet2 = new DataSet("Followups");
                        DataTable Followups = dataSet2.Tables.Add("Followups");
                        DefineTable1(followups, Followups);
                        adapter2.TableMappings.Add("Followups$", "Followups");

                        LogMessageToFile("The SqlConnection is open.");
                        long totalAlertRecords = 0;
                        long totalFollowUpRecords = 0;
                        //Boolean retpoint;
                        foreach (string strLine in astrLines)
                        {
                            I++;
                            if (!string.IsNullOrEmpty(strLine))
                            {
                                long alertRecords = 0;
                                long followupReords = 0;
                                BuildTable(strLine, Alerts, I, adapter, dataSet, connection, adapter2, Followups, dataSet2,
                                    out alertRecords, out followupReords);
                                totalAlertRecords = totalAlertRecords + alertRecords;
                                totalFollowUpRecords = totalFollowUpRecords + followupReords;
                            }
                        }

                        //Update the QI Report Manager facility/provider tables 
                        int rowCount = 0;
                        string sqlText = "usp_SyncQIFacilitiesAndProviders";
                        SqlCommand sqlCmd = new SqlCommand(sqlText, connection);
                        sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                        try
                        {
                            rowCount = sqlCmd.ExecuteNonQuery();
                        }
                        catch (Exception e)
                        {
                            LogErrorMessage(e);
                        }

                        // Close the connection.
                        connection.Close();
                        LogMessageToFile("Processed " + totalAlertRecords + " Alert records.");
                        LogMessageToFile("Processed " + totalFollowUpRecords + " Followup records.");
                        LogMessageToFile("The SqlConnection is closed.");
                    }
                    catch (Exception ex)
                    {
                        LogErrorMessage(ex);
                    }
                }
            }
            catch (NullReferenceException ex)
            {
                LogErrorMessage(ex);
            }

            LogMessageToFile("SQL Transporter execution is completed.");
        }
    }
}
