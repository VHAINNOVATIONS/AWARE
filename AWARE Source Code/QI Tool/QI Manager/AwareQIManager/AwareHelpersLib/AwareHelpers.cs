using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Harris.Common;

namespace AwareHelpersLib
{
    public enum AwareObjectTypes { REPORT_DEFINITIONS = 0, SECURITY_GROUPS, VIEW_ALL_PROVIDERS };

    #region structs
    public struct QI_FACILITY_REC
    {
        public Guid ID;
        public string Name;

        public QI_FACILITY_REC(Guid id, string name)
        {
            ID = id;
            Name = name;
        }
    }
    #endregion

    public class AwareHelpers
    {
        public AwareGroups AwareGroups;
        public AwareReports AwareReports;
        public AwareUsers AwareUsers;
        public VistaGroups VistaGroups;
        public AwareSecurity AwareSecurity;

        private string m_AwareDbConnString = string.Empty;
        private SQLHelpers m_SqlHelpers = new SQLHelpers();
        
        public AwareHelpers(string AwareDbConnString)
        {
            m_AwareDbConnString = AwareDbConnString;
            AwareGroups= new AwareGroups(ref AwareDbConnString);
            AwareReports = new AwareReports(ref AwareDbConnString);
            AwareUsers = new AwareUsers(ref AwareDbConnString);
            VistaGroups = new VistaGroups(ref AwareDbConnString);
            AwareSecurity = new AwareSecurity(ref AwareDbConnString);
        }

        public List<QI_FACILITY_REC> GetFacilitiesCollection()
        {
            List<QI_FACILITY_REC> facilitiesCollection = new List<QI_FACILITY_REC>();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetFacilities";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    try
                    {
                        QI_FACILITY_REC rec = new QI_FACILITY_REC();
                        try { rec.ID = dr.GetGuid(0); }
                        catch (SqlNullValueException Exception) { rec.ID = new Guid(); }
                        try { rec.Name = dr.GetString(1); }
                        catch (SqlNullValueException ex) { rec.Name = string.Empty; }
                        facilitiesCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return facilitiesCollection;
        }

    }

    
}
