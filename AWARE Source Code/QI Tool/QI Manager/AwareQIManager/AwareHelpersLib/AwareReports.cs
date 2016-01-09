using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using Harris.Common;

namespace AwareHelpersLib
{
    #region struct
    public struct QI_REPORT_REC
    {
        public Guid ReportID;
        public string Name;
        public string PresentationName;

        public QI_REPORT_REC(Guid reportId, string reportName, string presName)
        {
            ReportID = reportId;
            Name = reportName;
            PresentationName = presName;
        }
    }
    #endregion

    public class AwareReports
    {
        private string m_AwareDbConnString = string.Empty;
        private SQLHelpers m_SqlHelpers = new SQLHelpers();
        
        public AwareReports(ref string dbConnString)
        {
            m_AwareDbConnString = dbConnString;
        }

        public List<QI_REPORT_REC> GetQiReportsCollection()
        {
            List<QI_REPORT_REC> reportsCollection = new List<QI_REPORT_REC>();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetReportsInfo";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectTypeId", (int)AwareObjectTypes.REPORT_DEFINITIONS );
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    try
                    {
                        QI_REPORT_REC rec = new QI_REPORT_REC(dr.GetGuid(0), dr.GetString(1), dr.GetString(2));
                        reportsCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return reportsCollection;
        }

        public List<QI_REPORT_REC> GetQiReportsCollection(bool sortByPresName)
        {
            List<QI_REPORT_REC> reportsCollection = new List<QI_REPORT_REC>();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetReportsInfo";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjectTypeId", (int)AwareObjectTypes.REPORT_DEFINITIONS);
                sqlCmd.Parameters.AddWithValue("@SortAsc", sortByPresName);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    try
                    {
                        QI_REPORT_REC rec = new QI_REPORT_REC(dr.GetGuid(0), dr.GetString(1), dr.GetString(2));
                        reportsCollection.Add(rec);
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return reportsCollection;
        }

        public QI_REPORT_REC GetReportRecord(Guid reportId)
        {
            QI_REPORT_REC rpt = new QI_REPORT_REC();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetReportsRec";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@RptId", reportId);
                sqlCmd.Parameters.AddWithValue("@ObjTypeId", (int)AwareObjectTypes.REPORT_DEFINITIONS);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    try
                    {
                        rpt = new QI_REPORT_REC(dr.GetGuid(0), dr.GetString(1), dr.GetString(2));                        
                    }
                    catch (InvalidCastException ex)
                    {
                    }
                }
                dr.Close();
                dbConn.Close();
            }

            return rpt;
        }

        public void UpdateReport(ref QI_REPORT_REC rptRec)
        {
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_UpdateReportsRec";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@RepFileName", rptRec.Name);
                sqlCmd.Parameters.AddWithValue("@RepPresName", rptRec.PresentationName);
                sqlCmd.Parameters.AddWithValue("@RptId", rptRec.ReportID);
                sqlCmd.ExecuteNonQuery();
                dbConn.Close();
            }
        }

        public Guid GetReportIdByName(string rptName)
        {
            Guid rptId = new Guid();
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AwareDbConnString))
            {
                string sqlText = "usp_GetReportIdByName";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@ObjTypeId", (int)AwareObjectTypes.REPORT_DEFINITIONS);
                sqlCmd.Parameters.AddWithValue("@RepName", rptName);
                SqlDataReader dr = sqlCmd.ExecuteReader();
                rptId = (Guid)sqlCmd.ExecuteScalar();
                dr.Close();
                dbConn.Close();
            }
            return rptId;
        }
    }
}

        
