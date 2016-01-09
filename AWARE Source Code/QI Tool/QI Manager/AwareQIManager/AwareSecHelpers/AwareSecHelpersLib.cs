using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using Harris.Common;

namespace AwareSecHelpers
{   
    public class AwareSecHelpersLib
    {
        private string m_AwareDbConnString = string.Empty;
        private SQLHelpers m_SqlHelpers = new SQLHelpers();        

        public AwareSecHelpersLib(string awareDbConnString)
        {
            m_AwareDbConnString = awareDbConnString;
        }

        public string GetLocalUserName(Guid userId)
        {
            string user = string.Empty;
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetUserNameFromUserId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserId", userId);
                user = (string)sqlCmd.ExecuteScalar();
                dbConn.Close();
            }
           
            return user;
        }

        public string GetADUserName(Guid userId)
        {
            string user = string.Empty;

            return user;
        }

        public bool AddUserGroup(string name, bool active)
        {
            bool added = true;
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_InsertSecurityGroup";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupName", name);
                sqlCmd.Parameters.AddWithValue("@Active", active ? 1 : 0);
                int cnt = (int)sqlCmd.ExecuteNonQuery();
                dbConn.Close();

                if (cnt == 0)
                added = false;
            }           

            return added;
        }
        
        public bool DeleteUserGroup(Guid grpId)
        {
            bool deleted = true;
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {            
                string sqlText = "usp_DeleteSecurityGroup";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupId", grpId);
                int cnt = (int)sqlCmd.ExecuteNonQuery();
                dbConn.Close();
            }

            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteSecurityRole";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupId", grpId);
                int cnt = (int)sqlCmd.ExecuteNonQuery();
                dbConn.Close();
            }

            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteSecurityRight";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupId", grpId);
                int cnt = (int)sqlCmd.ExecuteNonQuery();
                dbConn.Close();
            }
            return deleted;
        }       
    }
}
