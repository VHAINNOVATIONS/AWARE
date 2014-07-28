using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Harris.Common;

namespace AwareHelpersLib
{
    #region structs
    public struct QI_VISTA_GRP_REC
    {
        public Guid VistaGrpID;
        public string Name;
        public Guid AwareGrpId;
        public Guid FacilityId;
        public bool ViewAllProv;

        public QI_VISTA_GRP_REC(Guid grpId, string grpName, Guid awGrpId, Guid facId, bool viewAllProvs)
        {
            VistaGrpID = grpId;
            Name = grpName;
            AwareGrpId = awGrpId;
            FacilityId = facId;
            ViewAllProv = viewAllProvs;
        }
    }
    #endregion

    public class VistaGroups
    {
        private string m_AwareDbConnString = string.Empty;
        private SQLHelpers m_SqlHelpers = new SQLHelpers();
        
        public VistaGroups(ref string dbConnString)
        {
            m_AwareDbConnString = dbConnString;
        }

        public List<QI_VISTA_GRP_REC> GetVistaGroupCollection()
        {
            List<QI_VISTA_GRP_REC> vistaGroupsCollection = new List<QI_VISTA_GRP_REC>();            
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetVistaGroups";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                while (dr.Read())
                {
                    try
                    {
                        QI_VISTA_GRP_REC rec = new QI_VISTA_GRP_REC();
                        try{rec.VistaGrpID = dr.GetGuid(0);}catch(SqlNullValueException Exception){rec.VistaGrpID = new Guid();}
                        try{rec.Name = dr.GetString(1);}catch(SqlNullValueException ex){rec.Name = string.Empty;}
                        try{rec.AwareGrpId = dr.GetGuid(2);}catch(SqlNullValueException ex){rec.AwareGrpId = new Guid();}
                        try{rec.FacilityId = dr.GetGuid(3);}catch(SqlNullValueException ex){rec.FacilityId = new Guid();}
                        vistaGroupsCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return vistaGroupsCollection;
        }

        public List<QI_VISTA_GRP_REC> GetVistaGroupCollection(bool SortByName)
        {
            List<QI_VISTA_GRP_REC> vistaGroupsCollection = new List<QI_VISTA_GRP_REC>();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetVistaGroups";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@SortAsc", SortByName);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    try
                    {
                        QI_VISTA_GRP_REC rec = new QI_VISTA_GRP_REC();
                        try { rec.VistaGrpID = dr.GetGuid(0); }catch (SqlNullValueException Exception) { rec.VistaGrpID = new Guid(); }
                        try { rec.Name = dr.GetString(1); }catch (SqlNullValueException ex) { rec.Name = string.Empty; }
                        try { rec.AwareGrpId = dr.GetGuid(2); }catch (SqlNullValueException ex) { rec.AwareGrpId = new Guid(); }
                        try { rec.FacilityId = dr.GetGuid(3); }catch (SqlNullValueException ex) { rec.FacilityId = new Guid(); }
                        vistaGroupsCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return vistaGroupsCollection;
        }

        public bool DoesVistaGroupExist(string GroupName)
        {
            bool exists = true;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesVistaGrpExists";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupName", GroupName);
                int cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();

                if (cnt == 0)
                    exists = false;
            }

            return exists;
        }

        public Guid GetVistaGroupId(string GroupName)
        {
            Guid guid = new Guid();
            if (true == DoesVistaGroupExist(GroupName))
            {
                using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                {
                    string sqlText = "usp_GetVistaGrpIdByName";
                    SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@GroupName", GroupName);
                    guid = (Guid)sqlCmd.ExecuteScalar();
                    awareDbConn.Close();
                }
            }

            return guid;
        }

        //public Guid AddVistaGroup(string GroupName, Guid FacilityId, bool viewAllProvs)
        //{
        //    Guid guid = new Guid();
        //    using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
        //    {
        //        string sqlText = "usp_InsertVistaGroupMapping";
        //        SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
        //        sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
        //        sqlCmd.Parameters.AddWithValue("@GroupName", GroupName);
        //        sqlCmd.Parameters.AddWithValue("@FacilityId", FacilityId);
        //        int cnt = (int)sqlCmd.ExecuteNonQuery();
        //        awareDbConn.Close();

        //        if (true == DoesVistaGroupExist(GroupName))
        //        {
        //            guid = GetVistaGroupId(GroupName);
        //        }
        //    }

        //    if (true == viewAllProvs)
        //    {
        //        if (false == _DoesViewAllProvsRightExist(guid, new Guid()))
        //        {
        //            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
        //            {
        //                string sqlText = "usp_AddSecurityRight";
        //                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
        //                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
        //                sqlCmd.Parameters.AddWithValue("@ObjTypeId", (int)AwareObjectTypes.VIEW_ALL_PROVIDERS);
        //                sqlCmd.Parameters.AddWithValue("@ObjectId", guid);
        //                sqlCmd.Parameters.AddWithValue("@EntityId", new Guid());
        //                sqlCmd.ExecuteNonQuery();
        //                awareDbConn.Close();
        //            }
        //        }
        //    }

        //    return guid;
        //}

        public Guid AddVistaGroup(string GroupName, Guid FacilityId, Guid QiGroupId, bool viewAllProvs)
        {
            Guid guid = new Guid();
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_InsertVistaGroupMapping";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupName", GroupName);
                sqlCmd.Parameters.AddWithValue("@FacilityId", FacilityId);
                sqlCmd.Parameters.AddWithValue("@AwareGrpId", QiGroupId);
                int cnt = (int)sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();

                if (true == DoesVistaGroupExist(GroupName))
                {
                    guid = GetVistaGroupId(GroupName);
                }                
            }

            if (true == viewAllProvs)
            {
                if (false == _DoesViewAllProvsRightExist(guid, new Guid()))
                {
                    using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                    {
                        string sqlText = "usp_AddSecurityRight";
                        SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                        sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                        sqlCmd.Parameters.AddWithValue("@ObjTypeId", (int)AwareObjectTypes.VIEW_ALL_PROVIDERS);
                        sqlCmd.Parameters.AddWithValue("@ObjectId", guid);
                        sqlCmd.Parameters.AddWithValue("@EntityId", new Guid());
                        sqlCmd.ExecuteNonQuery();
                        awareDbConn.Close();
                    }
                }
            }

            return guid;
        }

        public void UpdateVistaGroup(ref QI_VISTA_GRP_REC group)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_UpdateVistaGroupMapping";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupName", group.Name);
                sqlCmd.Parameters.AddWithValue("@FacilityId", group.FacilityId);
                sqlCmd.Parameters.AddWithValue("@AwareGrpId", group.AwareGrpId);
                sqlCmd.Parameters.AddWithValue("@VistaGrpId", group.VistaGrpID);
                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }

            if(true == group.ViewAllProv)
            {
                if (false == _DoesViewAllProvsRightExist(group.VistaGrpID, new Guid()))
                {
                    using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                    {
                        string sqlText = "usp_AddSecurityRight";
                        SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                        sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                        sqlCmd.Parameters.AddWithValue("@ObjTypeId", (int)AwareObjectTypes.VIEW_ALL_PROVIDERS);
                        sqlCmd.Parameters.AddWithValue("@ObjectId", group.VistaGrpID);
                        sqlCmd.Parameters.AddWithValue("@EntityId", new Guid());
                        sqlCmd.ExecuteNonQuery();
                        awareDbConn.Close();
                    }
                }
            }
        }

        private bool _DoesViewAllProvsRightExist(Guid entityId, Guid objId)
        {
            bool exists = false;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DoesSecurityRightExists";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectType", (int)AwareObjectTypes.VIEW_ALL_PROVIDERS);
                sqlCmd.Parameters.AddWithValue("@ObjectId", objId);
                sqlCmd.Parameters.AddWithValue("@EntityId", entityId);
                int cnt = (int)sqlCmd.ExecuteScalar();
                if (0 < cnt)
                {
                    exists = true;
                }
                awareDbConn.Close();
            }
            return exists;
        }

        public void DeleteVistaGroup(Guid grpId)
        {
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_DeleteAwareVistaGroupMapping";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupId", grpId);

                sqlCmd.ExecuteNonQuery();
                awareDbConn.Close();
            }
        }

        public Guid GetAwareGroupIdByVistaGrpName(Guid vistaId)
        {
            Guid grpId = new Guid();
            if (0 < GetAwareGroupCountByVistaGrpId(vistaId))
            {
                using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
                {
                    string sqlText = "usp_GetAwareGroupIdByVistaGrpId";// string.Format("SELECT AWARE_GROUP_ID FROM AWARE_VISTA_GROUP_MAPPINGS WHERE ID = \"{0}\"", vistaId);
                    SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@GroupId", vistaId);

                    grpId = (Guid)sqlCmd.ExecuteScalar();
                    awareDbConn.Close();
                }
            }
            return grpId;
        }

        public int GetAwareGroupCountByVistaGrpId(Guid vistaId)
        {
            int cnt = 0;
            using (SqlConnection awareDbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetVistaGrpCountById";
                SqlCommand sqlCmd = new SqlCommand(sqlText, awareDbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@GroupId", vistaId);
                cnt = (int)sqlCmd.ExecuteScalar();
                awareDbConn.Close();
            }

            return cnt;
        }
    }
}
