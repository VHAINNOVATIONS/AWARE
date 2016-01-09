using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using Harris.Common;

namespace AwareSecHelpers
{
    public enum AwareObjectTypes { REPORT_DEFINITIONS = 0 };
    public class AwareSecurables
    {
        private string m_AwareDbConnString = string.Empty;
        private SqlConnection m_DbConn = null;
        private SQLHelpers m_SqlHelpers = new SQLHelpers();

        public AwareSecurables(string AwareDbConnString)
        {
            m_AwareDbConnString = AwareDbConnString;
        }

        public bool DoesSecurableExists(string secItem, int objType)
        {
            bool exists = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesSecurityItemExist";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectTypeId", objType);
                sqlCmd.Parameters.AddWithValue("@ObjectName", secItem);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt > 0)
                {
                    exists = true;
                }
            }

            return exists;
        }

        public bool AddSecurable(string secItem, int objType, string presentationName)
        {

            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_AddSecurityItem";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectTypeId", objType);
                sqlCmd.Parameters.AddWithValue("@ObjectName", secItem);
                sqlCmd.Parameters.AddWithValue("@PresentationName", presentationName);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }

            return DoesSecurableExists(secItem, objType);
        }

         public string GetObjectNameByPresNameObjType(string presName, int objType)
        {
            string name = string.Empty;

            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetSecurityItemName";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectTypeId", objType);
                sqlCmd.Parameters.AddWithValue("@PresentationName", presName);
                name = sqlCmd.ExecuteScalar().ToString();
                awareDbConn.Close();
            }

            return name;
        }


     }
}
