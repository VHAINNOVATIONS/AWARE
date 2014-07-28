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
            bool exists = true;
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("SELECT COUNT(*) FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = {0} AND OBJECT_NAME = \"{1}\"", objType, secItem);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int cnt = (int)sqlCmd.ExecuteScalar();
            m_DbConn.Close();
            if (0 == cnt)
                exists = false;
            return exists;
        }

        public bool DoesSecurableExists(string secItem, int objType, string presentationName)
        {
            bool exists = true;
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("SELECT COUNT(*) FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = {0} AND OBJECT_NAME = \"{1}\" AND PRESENTATION_NAME = \"{2}\"", objType, secItem, presentationName);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int cnt = (int)sqlCmd.ExecuteScalar();
            m_DbConn.Close();
            if (0 == cnt)
                exists = false;
            return exists;
        }

        public bool AddSecurable(string secItem, int objType)
        {            
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("INSERT INTO SECURITY_ITEMS (OBJECT_TYPE_ID, OBJECT_NAME) VALUES ({0}, \"{1}\")", objType, secItem);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int rowCnt = (int)sqlCmd.ExecuteNonQuery();
            m_DbConn.Close();

            return DoesSecurableExists(secItem, objType);
        }

        public bool AddSecurable(string secItem, int objType, string presentationName)
        {
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("INSERT INTO SECURITY_ITEMS (OBJECT_TYPE_ID, OBJECT_NAME, PRESENTATION_NAME) VALUES ({0}, \"{1}\", \"{2}\")", objType, secItem, presentationName);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int rowCnt = (int)sqlCmd.ExecuteNonQuery();
            m_DbConn.Close();

            return DoesSecurableExists(secItem, objType);
        }

        public Guid GetObjectGuid(int ObjectType, string Name)
        {
            Guid retGuid = new Guid();
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("SELECT ID FROM SECURITY_ITEMS WHERE OBJECT_TYPE_ID = {0} AND OBJECT_NAME = \"{1}\"", ObjectType, Name);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            try
            {
                retGuid = (Guid)sqlCmd.ExecuteScalar();
                m_DbConn.Close();
            }
            catch (SqlException ex)
            {
            }
                
            return retGuid;
        }

        public string GetObjectNameByPresNameObjType(string presName, int objType)
        {
            string name = string.Empty;
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = string.Format("SELECT OBJECT_NAME FROM SECURITY_ITEMS WHERE PRESENTATION_NAME = \"{0}\" AND OBJECT_TYPE_ID = {1}", presName, objType);
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                try
                {
                    name = (string)sqlCmd.ExecuteScalar();
                    dbConn.Close();
                }
                catch (SqlException ex)
                {
                }
            }

            return name;
        }

        public bool GetRoles(Guid grpUid, Guid userUid)
        {
            bool granted = false;
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("SELECT COUNT(*) FROM SECURITY_ROLES WHERE GROUP_ID = \"{0}\" AND USER_ID = \"{1}\"", grpUid, userUid);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int cnt = (int)sqlCmd.ExecuteScalar();
            m_DbConn.Close();
            if (0 < cnt)
                granted = true;

            return granted;
        }

        public Guid GetUserGuid(string name)
        {
            Guid userid = new Guid();
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("SELECT ID FROM USERS WHERE USER_NAME = \"{0}\"", name);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            try
            {
                userid = (Guid)sqlCmd.ExecuteScalar();
            }
            catch (SqlException ex)
            {
            }
            m_DbConn.Close();

            return userid;
        }

        public Guid GetGrpGuid(string name)
        {
            Guid grpId = new Guid();
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("SELECT ID FROM SECURITY_GROUPS WHERE GROUP_NAME = \"{0}\"", name);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            try
            {
                grpId = (Guid)sqlCmd.ExecuteScalar();
            }
            catch (SqlException ex)
            {
            }
            m_DbConn.Close();

            return grpId;
        }

        public bool GetPermission(int ObjectType, Guid EntityId, Guid ObjectId)
        {
            bool granted = false;
            int cnt = 0;
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("SELECT COUNT(*) FROM SECURITY_RIGHTS WHERE OBJECT_TYPE_ID = {0} AND OBJECT_ID = \"{1}\" AND ENTITY_ID = \"{2}\"", ObjectType, ObjectId, EntityId);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            cnt = (int)sqlCmd.ExecuteScalar();
            if (0 < cnt)
                granted = true;

            m_DbConn.Close();

            return granted;
        }

        public void ClearPermissions(int ObjectType, Guid EntityId, Guid ObjectId)
        {
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("DELETE FROM SECURITY_RIGHTS WHERE OBJECT_TYPE_ID = {0} AND OBJECT_ID = \"{1}\" AND ENTITY_ID = \"{2}\"", ObjectType, ObjectId, EntityId);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int cnt = sqlCmd.ExecuteNonQuery();
            m_DbConn.Close();
        }

        public void AddPermissions(int ObjectType, Guid EntityId, Guid ObjectId)
        {
            if(false == GetPermission(ObjectType,EntityId, ObjectId))
            {
                m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
                string sqlText = string.Format("INSERT SECURITY_RIGHTS (OBJECT_TYPE_ID, OBJECT_ID, ENTITY_ID) VALUES ({0}, \"{1}\", \"{2}\")", ObjectType, ObjectId, EntityId);
                SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
                int cnt = sqlCmd.ExecuteNonQuery();
                m_DbConn.Close();
            }
        }

        public void AddUserRole(Guid grpId, Guid userId)
        {
            if (false == GetRoles(grpId, userId))
            {
                m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
                string sqlText = string.Format("INSERT SECURITY_ROLES (GROUP_ID, USER_ID) VALUES (\"{0}\", \"{1}\")", grpId, userId);
                SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
                int cnt = sqlCmd.ExecuteNonQuery();
                m_DbConn.Close();
            }
        }

        public void DeleteUserRole(Guid grpId, Guid userId)
        {
            m_DbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString);
            string sqlText = string.Format("DELETE FROM SECURITY_ROLES WHERE GROUP_ID = \"{0}\" AND USER_ID = \"{1}\"", grpId, userId);
            SqlCommand sqlCmd = new SqlCommand(sqlText, m_DbConn);
            int cnt = sqlCmd.ExecuteNonQuery();
            m_DbConn.Close();
        }

        

        public void RemoveSecurable()
        {
        }

        public void UpdateSecurable()
        {
        }
    }
}
