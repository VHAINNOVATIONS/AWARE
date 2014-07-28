using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Security.Cryptography;
using Microsoft.SqlServer.Common;
//using System.Web.Configuration;
//using SqlConnectionStringBuilder;
//using SqlConnection;




namespace LapAroundCS.Application
{    
    public partial class Form1 : Form
    {
        RPCSharedBrokerSessionMgr2.ISharedBrokerClient BrokerClient;
        RPCSharedBrokerSessionMgr2.ISharedBrokerErrorCode Success;
        RPCSharedBrokerSessionMgr2.SharedBroker rpcBroker;
        RPCSharedBrokerSessionMgr2.ISharedBrokerShowErrorMsgs ShowErrMsgs;
        bool blnConn = false;
        PointA point1;
        DataTable table;
        DataTable tablefollowups;
        DataSetUse dataset1;
        string connectionString;
        string  followups = "STATION-DATETIME-ALERTID^FOLLOWUP^FOLLOWUPDATETIME^";
        string @STATIONDATETIMEALERTID;
        string @FOLLOWUP;
        string @FOLLOWUPDATETIME;
        string @FACILITYNAME;
        string @SERVICE1;
        string @CLINIC;
        string @ORDERINGPROVIDER;
        string @ALERTTYPE;

        SqlDataAdapter adapter2;
        DataSet dataSet2;
        //DataTable AlertsTable;
        //DataTable FollowupsTable;
        DataTable Followups;



        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            treeView1.Nodes.Clear();
            comboBox1.Items.Clear();
            comboBox1.Items.Add("VEFA AWARE ALERT CACHE");
            //comboBox1.Items.Add("AJJ3 GUI EXCEL RETRIEVE1");
            //comboBox1.Items.Add("AJJ3 GUI SORT RETRIEVE");
            //comboBox1.Items.Add("AJJ3 GUI PRINT RETRIEVE");
            //comboBox1.Items.Add("AJJ3 GUI GET VARIABLE VALUE");
            //comboBox1.Items.Add("AJJ3 GUI KEY CHECK");

            vsATextBox.Text = "1";
        }

        private void clearButton_Click(object sender, EventArgs e)
        {
            treeView1.Nodes.Clear();
        }

        public string CallRPC(string strRPC, string ServerPort, params object[] strP)
        {
            string strData;
            string strParams;
            string login;
            string ErrorMsg ;

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
                    //ShowErrMsgs = 1 ;  
                    int clientid;
                    login = "" + Convert.ToChar(28) + "" + Convert.ToChar(28) + "vhaino321" + Convert.ToChar(28) +"verify123."+ Convert.ToChar(28)+ "" + Convert.ToChar(28) + '1';
                    // Connect with Client name, Type, Server:Port, etc.
                    //if (rpcBroker.BrokerConnect(comboBox1.Text, BrokerClient, ServerPort, false, false, 0, out clientid) != RPCSharedBrokerSessionMgr.ISharedBrokerErrorCode.Success)
                    if (rpcBroker.BrokerConnect(comboBox1.Text, BrokerClient, ServerPort, false, false, true, ShowErrMsgs, 0, ref login, out clientid, out ErrorMsg) != RPCSharedBrokerSessionMgr2.ISharedBrokerErrorCode.Success)
                    {
                        blnConn = false;
                        throw new Exception("Unable to connect to host or invalid login");
                        //return "";
                    }

                    if (rpcBroker.BrokerSetContext("VEFA AWARE GET ALERT CACHE") != RPCSharedBrokerSessionMgr2.ISharedBrokerErrorCode.Success)
                    {
                        MessageBox.Show("Error creating context");
                        return "";
                    }
                    
                    blnConn = true;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error creating RPC Broker.\n" + ex.ToString(), ex);
            }

            strParams = "";
            foreach(object vntItem in strP)
            {
                strParams = strParams + "L " + vntItem.ToString() + Convert.ToChar(29);
            }

            if (strParams.Equals("L " + Convert.ToChar(29)))
            {
                strParams = string.Empty;  
            }

            //if(comboBox1.SelectedIndex == 3)
            //    strParams = "L DUZ" + Convert.ToChar(29);

            //if (comboBox1.SelectedIndex == 4)
            //    strParams = "L AJJ3 GUI FM SQLSERVER" + Convert.ToChar(29);

            if (string.IsNullOrEmpty(strParams))
            {
                MessageBox.Show("DUZ or Other Input\nParameter required.");
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
                MessageBox.Show(ex.ToString());
                rpcBroker.BrokerDisconnect();
            }

            // Apply retrieved DUZ to vsATextBox
            if (!string.IsNullOrEmpty(strData) && comboBox1.SelectedIndex == 3)
            {
                string[] result = strData.Split(new string[] { "\r", "\n" }, StringSplitOptions.None);
                vsATextBox.Text = result[0];
            }

            return strData;
        }

        public void joinStringsButton_Click(object sender, EventArgs e)
        {
            ValidatedString vsA = new ValidatedString(vsATextBox.Text);
            ValidatedString vsB = new ValidatedString(vsBTextBox.Text);

            // + operator overloaded in ValidatedString.cs class
            ValidatedString vsResult = vsA + vsB;

            //vsResultTextbox.Text = vsResult.Value;
            object strStDt = vsATextBox.Text + vsBTextBox.Text;

            if (comboBox1.SelectedIndex < 3)
            {
                // pass DUZ
                strStDt = vsATextBox.Text;
            }
            else
            {
                strStDt = vsBTextBox.Text;
            }

            vsResultTextbox.Text = strStDt.ToString();
            //string stR = CallRPC(comboBox1.Text, "ecptest.houston.med.va.gov:19019", strStDt);
           //loop:
            try
            {
            string stR = string.Empty;
            //stR = CallRPC(comboBox1.Text, "23.21.114.197:9300", strStDt);
            //if (true == string.IsNullOrEmpty(stR))
            //     return;
            stR = CallRPC(comboBox1.Text, "75.101.135.12:9300", strStDt);
            if (true == string.IsNullOrEmpty(stR))
                 return;

            //stR = CallRPC(comboBox1.Text, "184.73.210.13:9200", strStDt);
            //if (true == string.IsNullOrEmpty(stR))
            //    return;
            treeView1.Nodes.Clear();
            TreeNode root = treeView1.Nodes.Add("Root");
            TreeNode node1;
            
            //string[] astrLines = stR.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None);
            string[] astrLines = stR.Split(new string[] { "\r\n", "\n" }, StringSplitOptions.None);
            int I = -1;
            //PointA point1;
            //DataTable table = new DataTable("table");
            table = null;
            // Now the variable can be used, but...
            point1 = null;
            dataset1 = null;
            dataset1 = new DataSetUse();
            //dataset1.ConnectToData(""); ;
            // ... a method call on a null object raises  
            // a run-time NullReferenceException. 
            // Uncomment the following line to see for yourself. 
            // mc.MyMethod(); 

            // Now mc has a value.
            ////table = MakeTable(astrLines[0]);
            //tablefollowups = MakeTable1(followups);
            point1= new PointA();
            connectionString= Start();

            //Point point1 = new Point(I);
            //Create a SqlConnection to the AWARE database. 
            using (SqlConnection connection =
                       new SqlConnection(connectionString))
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
                DefineTable(astrLines[0],Alerts);
                //dataSet.Tables.Add(AlertsTable);
                adapter.TableMappings.Add("Alerts$", "Alerts");

                //Create a SqlDataAdapter for the Followups table.
                //SqlDataAdapter adapter = new SqlDataAdapter();
                adapter2 = CreateFollowupsAdapter(connection);
                // A table mapping names the DataTable.
                // Fill the DataSet.
                dataSet2 = new DataSet("Followups");
                Followups = dataSet2.Tables.Add("Followups");
                DefineTable1(followups, Followups);
                adapter2.TableMappings.Add("Followups$", "Followups");

                // Open the connection.
                //connection.Close();
                //connection.Open();
                Console.WriteLine("The SqlConnection is open.");
                //Boolean retpoint;
                foreach (string strLine in astrLines)
                {
                    I++;
                    if (!string.IsNullOrEmpty(strLine))
                    {
                        node1 = root.Nodes.Add(strLine);
                        node1.Tag = "1";
                        //point1.SetArray1(I, strLine);
                        //BuildTable(strLine, table, I,adapter,dataSet);
                        ConnectToData(adapter,connection,strLine,Alerts,I,dataSet);
                    }
                }

                //Update the QI Report Manager facility/provider tables 
                int rowCount = 0;
                string sqlText = "usp_SyncQIFacilitiesAndProviders";
                SqlCommand sqlCmd = new SqlCommand(sqlText, connection);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                rowCount = sqlCmd.ExecuteNonQuery();
                // Close the connection.
                connection.Close();
                Console.WriteLine("The SqlConnection is closed.");
            }
            root.Expand();
            }
            catch (NullReferenceException ex)
            {
                // here we need to place what needs to take place when the above throws
            }
            // end 3/27/2014 edit by sb
            //root.Expand();
            
            //BuildTable(astrLines);
            //goto loop;
        }
        //public void BuildTable(string [] astrLines)
        public void BuildTable(string strLine,DataTable table, int I,SqlDataAdapter adapter,DataSet dataSet,SqlConnection connection)
        {
            
            //int I = -1;
            //DataTable table = MakeTable(astrLines[0]);
            DataRow row;
            DataRowCollection rowCollection = table.Rows;
                       

            //foreach (string strLine in astrLines)
            //{
            //    I++;
                
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
                            Console.WriteLine(e.ToString());
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
                                Console.WriteLine(e.ToString());
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
                        ////command = new SqlCommand(
                        ////"INSERT INTO dbo.Alerts$ (STATION_DATETIME_ALERTID, ALERTID, DATETIME1, FACILITYNAME, SERVICE1, ORDERINGPROVIDER, ALERTRECIPIENTS, PATIENT, ALERTCATEGORY, ALERTTYPE, UNACKSTATUS, ACKRENEWDATE, DELETEDATE, FATSTATUS, FATPROVIDER, FOLLOW_UPPROVIDERID, CLINIC, PATIENTID, ALERTRESULTOR, RESULTORPERSONCLASS, ALERTTYPEORIGSTATION,FOLLOWUPGT7D,ACKGT7D,FOLLOWUPLT7D) " +
                        ////"VALUES ("  +"'" + row[0] + "','"+  row[1] + "','"+   row[2] + "','"+   row[3] + "','"+   row[4] + "','"+  row[5] + "','"+   row[6] + "','"+   row[7] + "','"+   row[8] + "','"+   row[9] + "','"+   row[10] + "','"+   row[11] + "','"+   row[12] + "','"+
                        ////row[13] + "','" + row[14] + "','" + row[15] + "','" + row[16] + "','" + row[17] + "','" + row[18] + "','" + row[19] + "','" + row[20] + "','" +
                        ////row[21] + "','" + row[22] + "','" + row[23] + "'" + ")", connection);
                        //command = new SqlCommand(
                        //                "INSERT INTO dbo.Alerts$ (STATION_DATETIME_ALERTID) " +
                        //                "VALUES (" +"'" + @STATIONDATETIMEALERTID + "'"+ ")", connection);

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
                          Console.WriteLine(e.ToString());
                        }
                        
                        adapter.InsertCommand = command;
                        table.Rows.Add(row);
                        // New row.
                        Console.WriteLine("AddRow " + row.RowState);

                        table.AcceptChanges();
                        UpdateDataSet(dataSet, adapter,row);
                        rowCollection.Remove(row);

                        //now add values into lookup tables
                        BuildLookUpTables(strLine, I, connection);

                    }
                    if (astrFields[1] == "FOLLOWUP")
                    {
                        
                        BuildFollowupTable(strLine,Followups, I, adapter2, dataSet2,connection);
                    }
                    }
                    
                }
                
               
          //  }

               // UpdateDataSet(dataSet, adapter);
               // rowCollection.Remove(row);
        }
        public void BuildFollowupTable(string strLine, DataTable table, int I, SqlDataAdapter adapter, DataSet dataSet, SqlConnection connection)
        {

            //int I = -1;
            //DataTable table = MakeTable(astrLines[0]);
            DataRow row;
            DataRowCollection rowCollection = table.Rows;


            //foreach (string strLine in astrLines)
            //{
            //    I++;

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
                 "WHERE (STATION_DATETIME_ALERTID = " + "'"+ @STATIONDATETIMEALERTID+ "'" + ")" +
                 " AND (FOLLOWUP = " +"'" +@FOLLOWUP + "'" + ") AND (FOLLOWUPDATETIME = " + "'" + @FOLLOWUPDATETIME + "'" + ")", connection);
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
                            Console.WriteLine(e.ToString());
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
                                if (J == 2) row[J-1] = astrField;
                                if (J == 3) row[J-1] = astrField;

                            }
                        }
                        // Detached row.
                        Console.WriteLine("New Row " + row.RowState);

                        command = new SqlCommand(
                   "INSERT INTO Followups$ (STATION_DATETIME_ALERTID,FOLLOWUP,FOLLOWUPDATETIME) " +
                   "VALUES (" + "'" + @STATIONDATETIMEALERTID + "'" + "," +"'" + @FOLLOWUP + "'" + "," + "'" + @FOLLOWUPDATETIME + "'" + ")", connection);

                        try
                        {
                            command.ExecuteNonQuery();
                        }
                        catch (Exception e)
                        {
                            Console.WriteLine(e.ToString());
                        }
                    
                    
                        adapter.InsertCommand = command;
                        table.Rows.Add(row);
                        // New row.
                        Console.WriteLine("AddRow " + row.RowState);

                        table.AcceptChanges();
                        UpdateDataSet(dataSet, adapter,row);
                        rowCollection.Remove(row);
                    
                    
                }

            }


            //  }

            // UpdateDataSet(dataSet, adapter);
            // rowCollection.Remove(row);
        }


        public void BuildLookUpTables(string strLine, int I, SqlConnection connection)
        {

            
            //foreach (string strLine in astrLines)
            //{
            //    I++;

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
                        Console.WriteLine(e.ToString());
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
                        Console.WriteLine(e.ToString());
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
                        Console.WriteLine(e.ToString());
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
                        Console.WriteLine(e.ToString());
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
                        Console.WriteLine(e.ToString());
                    }


                    command = new SqlCommand(
             "INSERT INTO Clinic$ (FacilityName,Service,Clinic) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + "," + "'" + @CLINIC+ "'" + ")", connection);

                                       

                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());
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
                        Console.WriteLine(e.ToString());
                    }


                    command = new SqlCommand(
             "INSERT INTO OrderingProvider$ (FacilityName,Service,Clinic,OrderingProvider) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + "," + "'" + @CLINIC+ "'" + "," + "'" + @ORDERINGPROVIDER+ "'" + ")", connection);

                    

                    

                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());

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
                        Console.WriteLine(e.ToString());
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
                        Console.WriteLine(e.ToString());

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
                        Console.WriteLine(e.ToString());
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
                        Console.WriteLine(e.ToString());

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
                        Console.WriteLine(e.ToString());
                    }


                    command = new SqlCommand(
             "INSERT INTO AlertType$ (FacilityName,Service,Clinic,OrderingProvider,AlertType) " +
             "VALUES (" + "'" + @FACILITYNAME + "'" + "," + "'" + @SERVICE1 + "'" + "," + "'" + @CLINIC + "'" + "," + "'" + @ORDERINGPROVIDER + "'" + "," + "'" + @ALERTTYPE + "'"  + ")", connection);

                    
                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.ToString());

                    }

                }

            }

           
        }



        public void  DefineTable(string strLine,DataTable table)
        {
            // Make a simple table with one column.
            //DataTable table = new DataTable("Alerts");
            string[] astrFields = strLine.Split(new string[] {"^"}, StringSplitOptions.None);
            int I = -1 ;
            foreach (string astrField in astrFields)
            {
                I++;
                if (!string.IsNullOrEmpty(astrField))
                {
                 if (I==0)  
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
        public void DefineTable1(string strLine, DataTable table)
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
                "VALUES (@STATIONDATETIMEALERTID, @ALERTID, @DATETIME1, @FACILITYNAME, @SERVICE1,@ORDERINGPROVIDER, @ALERTRECIPIENTS, @SPARE, @ALERTCATEGORY, @ALERTTYPE, @VALUE1, @UNACKSTATUS, @ACKRENEWDATE, @DELETEDATE, @FATSTATUS, @FATPROVIDER, @FOLLOW_UPPROVIDERID, @CLINIC, @PATIENTID, @ALERTRESULTOR, @RESULTORPERSONCLASS, @ALERTTYPEORIGSTATION,@FOLLOWUPGT7D,@ACKGT7D,@FOLLOWUPLT7)", connection);

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
            command.Parameters.Add("@UNACKSTATUS", SqlDbType.VarChar,50, "UNACKSTATUS");
            command.Parameters.Add("@ACKRENEWDATE", SqlDbType.VarChar, 50, "ACKRENEWDATE");
            command.Parameters.Add("@DELETEDATE", SqlDbType.VarChar, 50, "DELETEDATE");
            command.Parameters.Add("@FATSTATUS", SqlDbType.VarChar, 50, "FATSTATUS");
            command.Parameters.Add("@FATPROVIDER", SqlDbType.VarChar, 50, "FATPROVIDER");
            command.Parameters.Add("@FOLLOW_UPPROVIDERID", SqlDbType.NVarChar, 50, "FOLLOW_UPPROVIDERID");
            command.Parameters.Add("@CLINIC", SqlDbType.VarChar, 50, "CLINIC");
            command.Parameters.Add("@PATIENTID", SqlDbType.NVarChar,50, "PATIENTID");
            command.Parameters.Add("@ALERTRESULTOR", SqlDbType.VarChar, 50, "ALERTRESULTOR");
            command.Parameters.Add("@RESULTORPERSONCLASS", SqlDbType.VarChar, 50, "RESULTORPERSONCLASS");
            command.Parameters.Add("@ALERTTYPEORIGSTATION", SqlDbType.NVarChar, 50 , "ALERTTYPEORIGSTATION");
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
                "@STATIONDATETIMEALERTID", SqlDbType.VarChar, 50 , "STATION_DATETIME_ALERTID");
            command.Parameters.Add("@FOLLOWUP", SqlDbType.VarChar, 50 ,"FOLLOWUP");
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
        //public static void SQLProgramAdapter(string[] astrLines)
        //{
         //   SqlConnection connection;
          
            //make connection with connection string
          // BuildTable(string [] astrLines);

        //}
        public void UpdateDataSet(DataSet dataSet, SqlDataAdapter adapter,DataRow row )
        {
            // Check for changes with the HasChanges method first. 
        //    if (!dataSet.HasChanges(DataRowState.Modified)) return;
         //   if (!dataSet.HasChanges(row.RowState.Modified) return;

            // Create temporary DataSet variable and 
            // GetChanges for modified rows only.
            //DataSet tempDataSet = new DataSet("Alerts");
            
            //tempDataSet =
            //    dataSet.GetChanges(DataRowState.Modified);

            // Check the DataSet for errors. 
           // if (tempDataSet.HasErrors)
           // {
                // Insert code to resolve errors.
          //  }
            // After fixing errors, update the data source with   
            // the DataAdapter used to create the DataSet.
            //adapter.Update(tempDataSet);
            adapter.Update(dataSet);
        }
        static string Start()
        {
            string connectionString = GetConnectionString();
            //ConnectToData(connectionString);
            return connectionString;
        }

        public void ConnectToData(SqlDataAdapter adapter, SqlConnection connection, string strLine, DataTable table, int I, DataSet dataSet)
        {
            //Create a SqlConnection to the AWARE database. 
            //using (SqlConnection connection =
            //           new SqlConnection(connectionString))
            //{
                //Create a SqlDataAdapter for the Suppliers table.
                //SqlDataAdapter adapter = new SqlDataAdapter();
                ////SqlDataAdapter adapter = CreateCustomerAdapter(connection);
                // A table mapping names the DataTable.
                ////adapter.TableMappings.Add("Table", "Suppliers");

                // Open the connection.
                ////connection.Open();
                ////Console.WriteLine("The SqlConnection is open.");

                // Create a SqlCommand to retrieve Suppliers data.
                ////SqlCommand command = new SqlCommand(
                ////    "SELECT SupplierID, CompanyName FROM dbo.Suppliers;",
                ////    connection);
                ////command.CommandType = CommandType.Text;

                // Set the SqlDataAdapter's SelectCommand.
                ////adapter.SelectCommand = command;

                // Fill the DataSet.
                //DataSet dataSet = new DataSet("Suppliers");
                ////adapter.Fill(dataSet);
                BuildTable(strLine, table, I, adapter, dataSet,connection);
        }
        public void ConnectToData1(SqlDataAdapter adapter, SqlConnection connection, string strLine, DataTable table, int I, DataSet dataSet)
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
                Console.WriteLine("The SqlConnection is closed.");

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
                Console.WriteLine(
                    "The {0} DataRelation has been created.",
                    relation.RelationName);
           // }
        }

        static private string GetConnectionString()
        {
            System.Data.SqlClient.SqlConnectionStringBuilder builder =
            new System.Data.SqlClient.SqlConnectionStringBuilder();
            builder["Data Source"] = "I20082SQL";
            builder["Integrated Security"] = true;
            builder["Initial Catalog"] = "AWARE";
            //builder["Persist Security Info"] = false;
            // To avoid storing the connection string in your code,  
            // you can retrieve it from a configuration file. 
            //return "Data Source=i20082sql\\master;Initial Catalog=AWARE;"
            //    + "Integrated Security=true;";
            return (builder.ConnectionString) ; // + "user id=username;" + 
                                      // "password=password;" + 
                                      // "Trusted_Connection=yes;" + 
                                      // "connection timeout=30");
        }
        

    }
}
