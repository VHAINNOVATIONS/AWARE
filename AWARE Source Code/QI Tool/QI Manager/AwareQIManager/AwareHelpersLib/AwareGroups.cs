using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using Harris.Common;


namespace AwareHelpersLib
{
    #region structs
    public struct QI_GROUP_REC
    {
        public Guid GroupID;
        public string Name;
        public bool Active;

        public QI_GROUP_REC(Guid grpId, string groupName, bool active)
        {
            GroupID = grpId;
            Name = groupName;
            Active = active;
        }
    }
    #endregion

    public class AwareGroups
    {
        private string m_AwareDbConnString = string.Empty;
        private SQLHelpers m_SqlHelpers = new SQLHelpers();
        
        public AwareGroups(ref string dbConnString)
        {
            m_AwareDbConnString = dbConnString;
        }

        public List<QI_GROUP_REC> GetQiGroupCollection()
        {
            List<QI_GROUP_REC> qiGroupCollection = new List<QI_GROUP_REC>();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetQIGroups";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    try
                    {
                        QI_GROUP_REC rec = new QI_GROUP_REC(dr.GetGuid(0), dr.GetString(1), dr.GetBoolean(2));
                        qiGroupCollection.Add(rec);                        
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return qiGroupCollection;
        }

        public List<QI_GROUP_REC> GetQiGroupCollection(bool SortByNameAsc)
        {
            List<QI_GROUP_REC> qiGroupCollection = new List<QI_GROUP_REC>();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetQIGroups";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@SortAsc", SortByNameAsc);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    try
                    {
                        QI_GROUP_REC rec = new QI_GROUP_REC(dr.GetGuid(0), dr.GetString(1), dr.GetBoolean(2));
                        qiGroupCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return qiGroupCollection;
        }

        public bool DoesGroupExist(string GroupName)
        {
            bool exists = true;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesQiGroupExists";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupName", GroupName);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt == 0)
                    exists = false;
            }

            return exists;
        }

        public bool IsGroupActive(Guid grpId)
        {
            bool isActive = true;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_IsQiGroupActive";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupId", grpId);
                isActive = (bool)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return isActive;
        }

        public Guid GetGroupId(string GroupName)
        {
            Guid guid = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetQiGroupId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupName", GroupName);
                guid = (Guid)sqlCmd.ExecuteScalar();
                awareDbConn.Close();                                
            }

            return guid;
        }

        public Guid AddGroup(string GroupName, bool GroupActive)
        {
            Guid guid = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_AddQiGroup";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupName", GroupName);
                sqlCmd.Parameters.AddWithValue("@QiGroupActive", GroupActive);
                int cnt = (int)sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();

                if (true == DoesGroupExist(GroupName))
                {
                    guid = GetGroupId(GroupName);                    
                }                
            }

            return guid;
        }

        public void UpdateGroup(ref QI_GROUP_REC grpRec)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_UpdateQiGroup";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupName", grpRec.Name);
                sqlCmd.Parameters.AddWithValue("@QiGroupActive", grpRec.Active);
                sqlCmd.Parameters.AddWithValue("@QiGroupId", grpRec.GroupID);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public void DeleteGroup(Guid grpId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteQiGroup";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupId", grpId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public Guid AddUserToGroup(Guid GrpId, Guid UserId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_AddUserToQiGroup";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupId", GrpId);
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
            return GetRoleId(GrpId, UserId);
        }

        public bool DoesRoleExist(Guid GrpId, Guid UserId)
        {
            bool exists = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesQiSecurityRoleExists";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupId", GrpId);
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if(cnt > 0)
                {
                    exists = true;
                }
            }

            return exists;
        }

        public Guid GetRoleId(Guid GrpId, Guid UserId)
        {
            Guid roleId = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetQiRoleId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupId", GrpId);
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                roleId = (Guid)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return roleId;
        }

        public void DeleteRole(Guid RoleId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteQiRole";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiRoleId", RoleId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public void DeleteRole(Guid GrpId, Guid UserId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteQiUserRole";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@QiGroupId", GrpId);
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

    }
}
