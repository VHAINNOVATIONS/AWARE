using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.IO;
using System.Data.SqlClient;
using System.Text;
using System.Windows.Forms;

namespace AwareDbUtility
{
    public partial class Dlg_DbOptions : Form
    {        
        private const string MASTER_DB_NAME = "Master";
        private const string WINDOWS_SEC_STRING = "Windows Authentication";
        private const int SQL_TIMEOUT_VAL = 15;

        private AppSettings theAppSettings;

        public bool DBConnectionTested { get; set; }

        public Dlg_DbOptions(ref AppSettings appSettings)
        {
            InitializeComponent();
            theAppSettings = appSettings;
            _GetAvailableSQLSvrs();
            cboxAuthType.SelectedIndex = 0;
            tbxUserName.Text = Environment.UserDomainName + "\\" + Environment.UserName;
        }

        private void _GetAvailableSQLSvrs()
        {
            Cursor.Current = Cursors.WaitCursor;
            System.Data.Sql.SqlDataSourceEnumerator instance = System.Data.Sql.SqlDataSourceEnumerator.Instance;
            System.Data.DataTable dataTable = instance.GetDataSources();
            foreach (System.Data.DataRow row in dataTable.Rows)
            {
                cbxSqlServers.Items.Add((string)row[0].ToString());
            }
            Cursor.Current = Cursors.Default;

            // if the local machine is in the list, lets select it by default
            cbxSqlServers.SelectedIndex = cbxSqlServers.FindString(Dns.GetHostName());
        }

        private void btnTest_Click(object sender, EventArgs e)
        {
            if (0 < cbxSqlServers.Text.Length)
            {
                if (true == _TestDbSvrConnection(_BuildDbConnString()))
                {
                    MessageBox.Show("Connectivity test successful!!!", theAppSettings.ApplicationName, MessageBoxButtons.OK, MessageBoxIcon.Information);
                    theAppSettings.SqlConnString = _BuildDbConnString();
                    theAppSettings.SqlSvrName = cbxSqlServers.Text;
                    DBConnectionTested = true;
                }
                else
                {
                    MessageBox.Show("Connectivity test un-successful!!!", theAppSettings.ApplicationName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    DBConnectionTested = false;
                }
            }
        }

        private string _BuildDbConnString()
        {
            string connString = string.Empty;
            SqlConnectionStringBuilder dbConnStrbuilder = new SqlConnectionStringBuilder();
            dbConnStrbuilder.ApplicationName = theAppSettings.ApplicationName;
            string svr = cbxSqlServers.Text;
            dbConnStrbuilder.ConnectTimeout = SQL_TIMEOUT_VAL;
            if(cboxAuthType.Text == WINDOWS_SEC_STRING)
            {
                dbConnStrbuilder.DataSource = svr;
                dbConnStrbuilder.IntegratedSecurity = true;
            }
            else
            {
                dbConnStrbuilder.DataSource = svr + "," + tbxSvrPort.Text;
                dbConnStrbuilder.UserID = tbxUserName.Text;
                dbConnStrbuilder.Password = tbxPassword.Text;
                dbConnStrbuilder.IntegratedSecurity = false;
            }
            dbConnStrbuilder.InitialCatalog = MASTER_DB_NAME;

            connString = dbConnStrbuilder.ConnectionString;
            return connString;
        }

        private bool _TestDbSvrConnection(string dbConnString)
        {
            bool success = true;
            SqlConnection sqlConn = new SqlConnection(dbConnString);
            try
            {
                sqlConn.Open();
                if (sqlConn.State.ToString() == "Open")
                {
                    SqlCommand sqlCmd = new SqlCommand(string.Format("USE {0}", MASTER_DB_NAME), sqlConn);
                    sqlCmd.ExecuteNonQuery();
                    sqlCmd.CommandText = "SET Quoted_Identifier OFF";
                    sqlCmd.ExecuteNonQuery();
                }
                sqlConn.Close();
            }

            catch (SqlException ex)
            {
                success = false;
            }

            catch (InvalidOperationException ex)
            {
                success = false;
            }

            return success;
        }

        private void cboxAuthType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (cboxAuthType.Text == WINDOWS_SEC_STRING)
            {
                tbxUserName.Enabled = false;
                tbxSvrPort.Enabled = false;
                tbxPassword.Enabled = false;
                lblUserName.Enabled = false;
                lblPassword.Enabled = false;
                lblPort.Enabled = false;
            }
            else
            {
                tbxUserName.Enabled = true;
                tbxSvrPort.Enabled = true;
                tbxPassword.Enabled = true;
                lblUserName.Enabled = true;
                lblPassword.Enabled = true;
                lblPort.Enabled = true;
            }
        }

        private void cbxSqlServers_TextChanged(object sender, EventArgs e)
        {
            btnTest.Enabled = cbxSqlServers.Text.Length > 0 ? true : false;
            DBConnectionTested = false;
            theAppSettings.SqlConnString = string.Empty;
            theAppSettings.SqlSvrName = string.Empty;
        }

        private void btnOK_Click(object sender, EventArgs e)
        {
            if (DBConnectionTested == false)
            {
                if (DialogResult.Yes == MessageBox.Show("Database Connectivity has not been confirmed, would you like to test it now?", theAppSettings.ApplicationName, MessageBoxButtons.YesNo, MessageBoxIcon.Question))
                {
                    btnTest_Click(null, null);
                }
            }
        }

    }
}
