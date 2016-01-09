using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Harris.Common;


namespace AwareHelpersLib
{
    public class AwareSecurity
    {
        private string  m_AwareDbConnString = string.Empty;        
        private SQLHelpers m_SqlHelpers = new SQLHelpers();        

        public AwareSecurity(ref string awareDbConnString)
        {
            m_AwareDbConnString = awareDbConnString;
        }

        public bool VerifyUserCredentials(string userName, string verifyCode)
        {
            bool verified = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_VerifyQiUserCredentials";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserName", userName);
                sqlCmd.Parameters.AddWithValue("@VerifyCode", verifyCode);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt > 0)
                {
                    verified = true;
                }
            }

            return verified;
        }

        public bool IsGroupPermittedAccess(string grpName)
        {
            bool permitted = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                HAR_StringEncrypter encrypter = new HAR_StringEncrypter();
                string sqlText = "usp_IsGroupPermittedAccess"; 
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GrpName", grpName);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt > 0)
                {
                    permitted = true;
                }
            }

            return permitted;
        }

        public bool DoesSecurityRightExists(int ObjectType, Guid ObjectId, Guid EntityId)
        {
            bool exists = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesSecurityRightExists";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectType", ObjectType);
                sqlCmd.Parameters.AddWithValue("@ObjectId", ObjectId);
                sqlCmd.Parameters.AddWithValue("@EntityId", EntityId);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt > 0)
                {
                    exists = true;
                }
            }

            return exists;
        }

        public Guid AddSecurityRight(int ObjectType, Guid ObjectId, Guid EntityId)
        {
            Guid SecRightId = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_AddSecurityRight";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjTypeId", ObjectType);
                sqlCmd.Parameters.AddWithValue("@ObjectId", ObjectId);
                sqlCmd.Parameters.AddWithValue("@EntityId", EntityId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();

                if (true == DoesSecurityRightExists(ObjectType, ObjectId, EntityId))
                {
                    SecRightId = GetSecurityRightId(ObjectType, ObjectId, EntityId);
                }                
            }

            return SecRightId;
        }

        public Guid GetSecurityRightId(int ObjectType, Guid ObjectId, Guid EntityId)
        {
            Guid rightId = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetSecurityRightId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectType", ObjectType);
                sqlCmd.Parameters.AddWithValue("@ObjectId", ObjectId);
                sqlCmd.Parameters.AddWithValue("@EntityId", EntityId);
                rightId = (Guid)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return rightId;
        }

        public void DeleteSecurityRight(int ObjectType, Guid ObjectId, Guid EntityId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteSecurityRight"; 
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@EntityId", EntityId);
                sqlCmd.Parameters.AddWithValue("@ObjectType", ObjectType);
                sqlCmd.Parameters.AddWithValue("@ObjectId", ObjectId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }
	
        public void DeleteEntitySecurityRights(Guid EntityId, int ObjectTypeId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteSecurityRight"; 
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@EntityId", EntityId);
                sqlCmd.Parameters.AddWithValue("@ObjectType", ObjectTypeId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public void DeleteVistaGroupMappings(Guid AwareGrpId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteVistaGroupMapping";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@AwareGroupId", AwareGrpId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public Guid GetSecurityRole(Guid UserId)
        {
            Guid roleId = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetSecurityRoleByUserId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                roleId = (Guid)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return roleId;
        }

        public Guid GetGroupIdFromUserId(Guid userId)
        {
            Guid grpId = new Guid();
            if (0 < GetGroupCountFromUserId(userId))
            {               
                using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                {
                    string sqlText = "usp_GetGroupIdByUserId";
                    SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@UserId", userId);
                    grpId = (Guid)sqlCmd.ExecuteScalar();
                    awareDbConn.Close();
                }
            }

            return grpId;
        }

        public int GetGroupCountFromUserId(Guid userId)
        {
            int cnt = 0;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesSecurityRoleExistByUserId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserId", userId);
                cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return cnt;
        }

        public Guid GetGroupIdFromProviderId(Guid prvId)
        {
            Guid grpId = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                try
                {
                    string sqlText = "usp_GetVistaProviderGroupId";
                    SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@ProviderId", prvId);
                    grpId = (Guid)sqlCmd.ExecuteScalar();
                    awareDbConn.Close();
                }
                catch
                {
                }
            }

            return grpId;
        }

        public bool DoesProviderExist(string provId)
        {
            bool exists = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesVistaProviderExists";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ProviderId", provId);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt > 0)
                {
                    exists = true;
                }
            }

            return exists;
        }

        public Guid AddProvider(string provName, string vistaId, Guid vistaGrpId)
        {
            Guid provId = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_InsertProvider";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Name", provName);
                sqlCmd.Parameters.AddWithValue("@VistaId", vistaId);
                sqlCmd.Parameters.AddWithValue("@VistaGrpId", vistaGrpId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();

                if (true == DoesProviderExist(vistaId))
                {
                    provId = GetProviderId(vistaId);
                }
            }

            return provId;
        }

        public Guid UpdateProvider(string provName, string vistaId, Guid vistaGrpId)
        {
            Guid provId = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_UpdateProvider";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@Name", provName);
                sqlCmd.Parameters.AddWithValue("@VistaId", vistaId);
                sqlCmd.Parameters.AddWithValue("@VistaGrpId", vistaGrpId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
                provId = GetProviderId(vistaId);                
            }

            return provId;
        }

        public Guid GetProviderId(string vistaId)
        {
            Guid prvId = new Guid();
            if (true == DoesProviderExist(vistaId))
            {
                using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                {
                    string sqlText = "usp_GetVistaProviderID";
                    SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@VistaId", vistaId);
                    prvId = (Guid)sqlCmd.ExecuteScalar();
                    awareDbConn.Close();
                }
            }

            return prvId;
        }

        public string GetProviderVistaId(Guid provId)
        {
            string vistaId = string.Empty;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetProviderVistaId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ProvId", provId);
                vistaId = (string)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }
            
            return vistaId;
        }

        public bool ViewAllProviders(Guid provId)
        {
            bool allowed = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_CanProviderSeeAll";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ProvId", provId);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt > 0)
                {
                    allowed = true;
                }
            }

            return allowed;
        }

        public bool DoesGrpHaveAllProvView(Guid visGrpId)
        {
            bool allowed = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_CanGroupSeeAll";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@VistaGrpId", visGrpId);
                int cnt = (int)sqlCmd.ExecuteScalar();                
                awareDbConn.Close();

                if (cnt > 0)
                {
                    allowed = true;
                }
            }

            return allowed;
        }
    }
}
