using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Reflection;
using Harris.Common;
using System.Net;

namespace Harris.Common
{
    class SQLHelpers
    {
        private const string APP_NAME = "AWARE QI Report Manager";
        public const string AWARE_DB_NAME = "Aware";
        public const string CONSULTS_DB_NAME = "Consults";
        
        private const string REGVAL_USE_INT_SEC = "UseIntSecurity";
        private const int SQL_SERVER_PORT = 2737;
        
        private int m_SqlTimeoutVal = 15;   //seconds
        private string m_DbConnString = string.Empty;

        private HAR_StringEncrypter m_objEncrypt = new HAR_StringEncrypter();

        public SQLHelpers()
        {           
        }

        public SqlConnection GetDbConnection(string dbConnString)
        {
            SqlConnection sqlConn = new SqlConnection(dbConnString);            
            try
            {
                sqlConn.Open();
                if (sqlConn.State.ToString() == "Open")
                {
                    SqlCommand sqlCmd = new SqlCommand();
                    sqlCmd.CommandText = "usp_SetQuotedIdentifier";
                    sqlCmd.CommandType = CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@OnOff", 0);
                    sqlCmd.Connection = sqlConn;
                    sqlCmd.ExecuteNonQuery();
                }                 
            }
            catch (SqlException ex)
            {                
                sqlConn = null;
            }

            catch (InvalidOperationException ex)
            {                
                sqlConn = null;
            }
            
            return sqlConn;
        }

        public void CloseDbConnection(SqlConnection dbConn)
        {
            try
            {
                dbConn.Close();                
            }
            catch (SqlException ex)
            {                
                dbConn = null;
            }

            catch (InvalidOperationException ex)
            {                
                dbConn = null;
            }            
        }

        public string GetSqlServerName(string dbConnString)
        {            
            string svr = string.Empty;
            SqlConnection dbConn = this.GetDbConnection(dbConnString);
            if (null != dbConn)
            {
                svr = dbConn.DataSource;
                CloseDbConnection(dbConn);
            }

            return svr;            
        }

        public string GetSqlServerVersion(string dbConnString)
        {
            string ver = string.Empty;
            SqlConnection dbConn = this.GetDbConnection(dbConnString);
            if (null != dbConn)
            {
                ver = dbConn.ServerVersion;
                CloseDbConnection(dbConn);
            }

            return ver;
        }

               



    }    
}

