using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Harris.Common;

namespace AwareHelpersLib
{
    public struct QI_USER_REC
    {
        public Guid UserID;
        public string UserName;
        public Guid FacilityId;
        public string VerifyCode;
        
        public QI_USER_REC(Guid userId, string userName, Guid facId, string verifyCode)
        {
            UserID = userId;
            UserName = userName;
            FacilityId = facId;
            VerifyCode = verifyCode;
        }
    }

    public class AwareUsers
    {
        private string m_AwareDbConnString = string.Empty;
        private SQLHelpers m_SqlHelpers = new SQLHelpers();
                
        public AwareUsers(ref string dbConnString)
        {
            m_AwareDbConnString = dbConnString;
        }

        public List<QI_USER_REC> GetQiUsersCollection(Guid facilityId)
        {
            List<QI_USER_REC> userCollection = new List<QI_USER_REC>();
            userCollection.Clear();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_SelectUserRecsByFacID";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@FacilityId", facilityId);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    QI_USER_REC rec = new QI_USER_REC();
                    try
                    {
                        rec.UserID = dr.GetGuid(0);
                        try{rec.UserName = dr.GetString(1);}
                            catch (SqlNullValueException ex){rec.UserName = string.Empty;}
                        try { rec.FacilityId = dr.GetGuid(2); }
                        catch (SqlNullValueException ex) { rec.FacilityId = new Guid(); }

                        userCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return userCollection;
        }

        public List<QI_USER_REC> GetQiUsersCollection(Guid facilityId, bool SortByNameAsc)
        {
            List<QI_USER_REC> userCollection = new List<QI_USER_REC>();
            userCollection.Clear();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_SelectUserRecsByFacID";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@FacilityId", facilityId);
                sqlCmd.Parameters.AddWithValue("@SortAsc", SortByNameAsc);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    QI_USER_REC rec = new QI_USER_REC();
                    try
                    {
                        rec.UserID = dr.GetGuid(0);
                        try { rec.UserName = dr.GetString(1); }
                        catch (SqlNullValueException ex) { rec.UserName = string.Empty; }
                        try { rec.FacilityId = dr.GetGuid(2); }
                        catch (SqlNullValueException ex) { rec.FacilityId = new Guid(); }

                        userCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return userCollection;
        }

        public List<QI_USER_REC> GetQiUsersCollection(bool SortByNameAsc)
        {
            List<QI_USER_REC> userCollection = new List<QI_USER_REC>();
            userCollection.Clear();

            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_SelectUserRecsByFacID";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@FacilityId", null);
                sqlCmd.Parameters.AddWithValue("@SortAsc", SortByNameAsc);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    QI_USER_REC rec = new QI_USER_REC();
                    try
                    {
                        rec.UserID = dr.GetGuid(0);
                        try { rec.UserName = dr.GetString(1); }
                        catch (SqlNullValueException ex) { rec.UserName = string.Empty; }
                        try { rec.FacilityId = dr.GetGuid(2); }
                        catch (SqlNullValueException ex) { rec.FacilityId = new Guid(); }

                        userCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return userCollection;
        }

        public bool DoesUserExist(string userName, Guid FacilityId)
        {            
            bool exists = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {                
                string sqlText = "usp_DoesUserExistWFacId";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserName", userName);
                sqlCmd.Parameters.AddWithValue("@FacilityId", FacilityId);
                exists = (Boolean)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return exists;
        }

        public bool DoesUserExist(string userName)
        {
            bool exists = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesUserExist";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserName", userName);                
                exists = (Boolean)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return exists;
        }

        public Guid GetUsersId(string userName, Guid FacilityId)
        {            
            Guid guid = new Guid();
            if (true == DoesUserExist(userName, FacilityId))
            {
                using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                {
                    string sqlText = "usp_GetUsersIdWFacID";
                    SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@UserName", userName);
                    sqlCmd.Parameters.AddWithValue("@FacilityId", FacilityId);
                    guid = (Guid)sqlCmd.ExecuteScalar();
                    awareDbConn.Close();
                }
            }

            return guid;
        }

        public Guid GetUsersId(string userName)
        {
            Guid guid = new Guid();            
            if (true == DoesUserExist(userName))
            {
                using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                {
                    string sqlText = "usp_GetUsersId";
                    SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@UserName", userName);
                    guid = (Guid)sqlCmd.ExecuteScalar();
                    awareDbConn.Close();
                }
            }
            
            return guid;
        }

        public Guid AddUser(string UserName, Guid FacilityId, string verifyCode)
        {
            Guid guid = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                HAR_StringEncrypter encrypter = new HAR_StringEncrypter();
                string sqlText = "usp_AddUser";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserName", UserName);
                sqlCmd.Parameters.AddWithValue("@FacilityId", FacilityId);
                sqlCmd.Parameters.AddWithValue("@VerifyCode", encrypter.EncryptString(verifyCode));
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
                if (true == DoesUserExist(UserName, FacilityId))
                {
                    guid = GetUsersId(UserName, FacilityId);
                }
            }

            return guid;
        }

        public void UpdateUser(ref QI_USER_REC userRec)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                HAR_StringEncrypter encrypter = new HAR_StringEncrypter();
                string sqlText = "usp_UpdateUser";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserName", userRec.UserName);
                sqlCmd.Parameters.AddWithValue("@FacilityId", userRec.FacilityId);
                sqlCmd.Parameters.AddWithValue("@VerifyCode", encrypter.EncryptString(userRec.VerifyCode));
                sqlCmd.Parameters.AddWithValue("@UserId", userRec.UserID);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public string GetUserVerifyCode(Guid UserId)
        {
            string verCode = string.Empty;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                HAR_StringEncrypter m_Encrypter = new HAR_StringEncrypter();
                string sqlText = "usp_SelectUsersVerifyCode";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                verCode = (string)sqlCmd.ExecuteScalar();                
                awareDbConn.Close();
            }
            return verCode;
        }

        public void DeleteUser(Guid UserId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteUserById";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public string GetUserNameById(Guid UserId)
        {
            string usrName = string.Empty;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetUserNameById";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                usrName = (string)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }
            return usrName;
        }

        public string GetProviderNameById(Guid UserId)
        {
            string usrName = string.Empty;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetProviderNameById";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@UserId", UserId);
                usrName = (string)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }
            return usrName;
        }
    }
}



        

        