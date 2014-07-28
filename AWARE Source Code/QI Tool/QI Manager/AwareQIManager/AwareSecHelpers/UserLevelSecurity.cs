using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Harris.Common;
using System.Data.SqlClient;
using System.Configuration;



namespace AwareSecHelpers
{
    public class UserLevelSecurity
    {
        private HAR_StringEncrypter m_Encrypter = new HAR_StringEncrypter();
        private SQLHelpers m_SqlHelpers = new SQLHelpers();
        private SqlConnection m_DbConn;
        private string m_DbConnString = string.Empty;

        public UserLevelSecurity(string dbConnString)
        {       
            m_DbConnString = dbConnString;
        }

        public string EncryptString(string StringToEncrypt)
        {
            string encryptedVal = StringToEncrypt;
            if (encryptedVal.Length > 0)
                encryptedVal = m_Encrypter.EncryptString(StringToEncrypt);

            return encryptedVal;
        }

        public bool ValidateLocalUserCredentials(string UserName, string UserPassword)
        {
            bool valid = false;           
            m_DbConn = m_SqlHelpers.GetDbConnection(m_DbConnString);
            string sqlText = string.Format("SELECT COUNT(*) FROM USERS WHERE USER_NAME = \"{0}\" AND PASSWORD = \"{1}\"", UserName, UserPassword);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int cnt = (int)sqlCmd.ExecuteScalar();            
            m_DbConn.Close();
            if (0 < cnt)
                valid = true;

            return valid;
        }

        public Guid GetLocalUserGuid(string UserName, string UserPassword)
        {
            Guid userGuid = new Guid();

            string User = m_Encrypter.DecryptString(UserName);
            string PassWord = m_Encrypter.DecryptString(UserPassword);

            m_DbConn = m_SqlHelpers.GetDbConnection(m_DbConnString);
            string sqlText = string.Format("SELECT TOP 1 ID FROM USERS WHERE USER_NAME = \"{0}\" AND PASSWORD = \"{1}\"", UserName, UserPassword);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            userGuid = (Guid)sqlCmd.ExecuteScalar();
            m_DbConn.Close();
            return userGuid;
        }

        public Guid AddUserToDb(string userName, string pwd, Guid grpId)
        {
            // add the user
            Guid userId = new Guid();
            m_DbConn = m_SqlHelpers.GetDbConnection(m_DbConnString);
            string sqlText = string.Format("INSERT USERS (USER_NAME, PASSWORD, SECURITY_GROUP_ID) VALUES(\"{0}\", \"{1}\", \"{2}\")", userName, pwd, grpId);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int cnt = sqlCmd.ExecuteNonQuery();
            m_DbConn.Close();
            
            userId = GetLocalUserGuid(userName, pwd);

            // add the role
            m_DbConn = m_SqlHelpers.GetDbConnection(m_DbConnString);
            sqlText = string.Format("INSERT SECURITY_ROLES (GROUP_ID, USER_ID) VALUES(\"{0}\", \"{1}\")", grpId, userId);
            sqlCmd = new SqlCommand(sqlText, m_DbConn);
            cnt = sqlCmd.ExecuteNonQuery();
            m_DbConn.Close();

            // add the rights for the user based on the group            
            m_DbConn = m_SqlHelpers.GetDbConnection(m_DbConnString);
            sqlText = string.Format("INSERT INTO SECURITY_RIGHTS(OBJECT_TYPE_ID, OBJECT_ID, ENTITY_ID) SELECT OBJECT_TYPE_ID, OBJECT_ID, \"{0}\" FROM SECURITY_RIGHTS WHERE ENTITY_ID = \"{1}\"", userId, grpId);
            sqlCmd = new SqlCommand(sqlText, m_DbConn);
            cnt = sqlCmd.ExecuteNonQuery();
            m_DbConn.Close();
            return userId;
        }
        
    }
}
