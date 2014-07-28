using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Reporting.WebForms;
using AwareQIManager.Reportingservice2010;
using System.Data.SqlClient;
using Harris.Common;
using AwareSecHelpers;
using AwareHelpersLib;

namespace AwareQIManager
{
    public partial class Default : System.Web.UI.Page
    {
        private const string RS_REPORT_TYPE = "Report";
        private const string DEF_LISTBOX_VALUE = "...Select a Value...";
        private const string DEF_RPT_LISTBOX_VALUE = "...Select a Report...";
        private SQLHelpers m_SqlHelpers = new SQLHelpers();
        
        private ReportingService2010 m_rs = new ReportingService2010();
        private AwareAppSettings m_AppSettings = new AwareAppSettings();
        private static List<ReportParameter> m_ParamList = new List<ReportParameter>();
        
        private string m_SelReport = string.Empty;
        private DateTime m_StartDate = DateTime.Now;
        private DateTime m_EndDate = DateTime.Now;

        private AwareHelpers m_AwHelpers;

        protected void Page_Load(object sender, EventArgs e)
        {            
            btnViewReport.Enabled = true;
            m_AwHelpers = new AwareHelpers(m_AppSettings.GetAwareDbConnectionString);
            if (true == string.IsNullOrEmpty((string)Session["UserSid"]))
            {
                Session["LastError"] = "NO_ERROR";
                Response.Redirect("Logon.aspx");
            }
            else
            {
                if (false == IsPostBack)
                {
                    lblLoggedOnUser.Text = string.Format("Logged on user: {0} : ", _TranslateUserSidToName((string)Session["UserSid"]));
                    _InitReportsList();                    
                    _HideAllParamPanels();
                    _SetCalDates();
                    TbAlertStartDate.Text = DateTime.Now.AddDays(m_AppSettings.GetDefaultDateSpan).ToShortDateString();                    
                    TbAlertEndDate.Text = DateTime.Now.ToShortDateString();
                    if (Session["IsSuperUser"].ToString() == "True")
                    {
                        LkBtnAdminTools.Visible = true;
                    }
                    else
                    {
                        LkBtnAdminTools.Visible = false;
                    }

                    if (Session["IsVistaLogon"] == "True")
                    {
                        // get the provider id from the provider table
                        Guid tmp = Guid.Parse(Session["UserSid"].ToString());

                        int a = 9;
                    }
                }                
            }             
        }

        protected void LnkBtnLogout_Click(object sender, EventArgs e)
        {
            _InitSessionVars();
            _InitRptsessionVars();            
            Response.Redirect("default.aspx");
        }

        protected void LnkBtnAdminTools_Click(object sender, EventArgs e)
        {
            Response.Redirect("admin.aspx");
        }

        private void _InitSessionVars()
        {
            Session["LastError"] = "NO_ERROR";
            Session["InnerExceptionText"] = string.Empty;
            Session["UserSid"] = string.Empty;
            Session["SelectedReport"] = string.Empty;
            Session["VistaAccessKey"] = string.Empty;
            Session["VistaGrpId"] = string.Empty;
            Session["IsSuperUser"] = string.Empty;
            Session["IsVistaLogon"] = "False";
        }

        private void _InitRptsessionVars()
        {
            Session["InputFacility"] = string.Empty;
            Session["InputService"] = string.Empty;
            Session["InputClinic"] = string.Empty;
            Session["InputProvider"] = string.Empty;
            Session["InputAlertType"] = string.Empty;
            Session["InputStart"] = string.Empty;
            Session["InputEnd"] = string.Empty;
        }

        private void _SetCalDates()
        {
            TbAlertStartDate.Text = DateTime.Now.AddDays(m_AppSettings.GetDefaultDateSpan).ToShortDateString();
            TbAlertEndDate.Text = DateTime.Now.ToShortDateString();
        }
        
        private string _TranslateUserSidToName(string usersSid)
        {
            string userName = string.Empty;
            try
            {
                userName = new SecurityIdentifier(usersSid).Translate(typeof(NTAccount)).ToString();
                
                //NTAccount f = new NTAccount(usersSid);
                //SecurityIdentifier s = (SecurityIdentifier)f.Translate(typeof(SecurityIdentifier));
                //string sidString = s.ToString();
            }
            catch (ArgumentException ex)
            {
                try
                {
                    userName = m_AwHelpers.AwareUsers.GetUserNameById(Guid.Parse(Session["UserSid"].ToString()));
                    if ((null == userName) && (0 < Session["UserSid"].ToString().Length))
                    {                        
                        userName = m_AwHelpers.AwareUsers.GetProviderNameById(Guid.Parse(Session["UserSid"].ToString()));                        
                    }
                }
                catch (FormatException ex1)
                {
                    userName = usersSid;
                }                
            }            

            return userName;
        }

        private void _InitReportSecurables()
        {
            m_rs.Credentials = System.Net.CredentialCache.DefaultCredentials;
            m_rs.Url = m_AppSettings.GetReportServerUrl.ToString();

            try
            {
                CatalogItem[] items = m_rs.ListChildren(string.Format("/{0}", m_AppSettings.GetReportsRootFolder), true);
                AwareSecurables aws = new AwareSecurables(m_AppSettings.GetAwareDbConnectionString);
                foreach (CatalogItem ci in items)
                {
                    if (RS_REPORT_TYPE == ci.TypeName)
                    {                        
                        if (false == aws.DoesSecurableExists(ci.Name, (int)AwareObjectTypes.REPORT_DEFINITIONS))
                        {
                            string presName = _GetRptPresentationName(ci.Name);
                            aws.AddSecurable(ci.Name, (int)AwareObjectTypes.REPORT_DEFINITIONS, presName);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Session["LastError"] = ex.Message;
                Session["InnerExceptionText"] = ex.InnerException.Message;
                Response.Redirect("AwareError.aspx");
            }    
        }
               
        private void _InitReportsList()
        {
            _InitReportSecurables();

            Guid grpId = new Guid();
            if (Session["IsSuperUser"].ToString() == "False")
            {
                if (0 < m_AwHelpers.AwareSecurity.GetGroupCountFromUserId(Guid.Parse(Session["UserSid"].ToString())))
                {
                    grpId = m_AwHelpers.AwareSecurity.GetGroupIdFromUserId(Guid.Parse(Session["UserSid"].ToString()));
                }
                else
                {
                    grpId = m_AwHelpers.AwareSecurity.GetGroupIdFromProviderId(Guid.Parse(Session["UserSid"].ToString()));
                    if(grpId == new Guid())
                    {
                        return;
                    }

                    // user doesnt belong to any groups, try the vista groups
                    //if (0 < m_AwHelpers.VistaGroups.GetAwareGroupCountByVistaGrpName(Guid.Parse(Session["VistaGrpId"].ToString())))
                    //{
                    //    // we're dealing with a vista logon
                    //    grpId = m_AwHelpers.VistaGroups.GetAwareGroupIdByVistaGrpName(Guid.Parse(Session["VistaGrpId"].ToString()));
                    //}
                    //else return;
                }                
            }
            ddlistReports.Items.Add(DEF_RPT_LISTBOX_VALUE);

            List<QI_REPORT_REC> reports = new List<QI_REPORT_REC>();
            reports = m_AwHelpers.AwareReports.GetQiReportsCollection(true);
            foreach (QI_REPORT_REC rpt in reports)
            {
                if ((Session["IsSuperUser"].ToString() == "True") || (true == m_AwHelpers.AwareSecurity.DoesSecurityRightExists((int)AwareObjectTypes.REPORT_DEFINITIONS, rpt.ReportID, grpId)))
                {
                    ListItem li = new ListItem(rpt.PresentationName);
                    ddlistReports.Items.Add(li);
                }
            }                    
        }

        private string _GetRptPresentationName(string rptName)
        {
            string tmpVal = rptName.Replace('_', ' ');
            if (tmpVal.IndexOf("Aware") >= 0)
            {
                tmpVal = tmpVal.Substring(tmpVal.IndexOf("Aware") + 6);
            }

            if (tmpVal.IndexOf("Dashboard") >= 0)
            {
                tmpVal = tmpVal.Substring(0, tmpVal.IndexOf("Dashboard") - 1);
            }

            return tmpVal;
        }

        private void _ShowHideReportParams(string selRpt)
        {
            _HideAllParamPanels();
            switch ((string)Session["SelectedReport"])
            {
                case "Aware_Provider_Full_Drill_Down_Level_Dashboard":
                    FacSrvClnPrvAlt.Visible = true;
                    AlertTypeLabel.Visible = true;
                    ddlAlertTypes.Visible = true;
                    CalStartEndDates.Visible = true;
                    btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFacilities);
                    break;
                case "Aware_Provider_Full_Drill_Down_Level_Greater7Days_Dashboard":
                    goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";                    
                case "Aware_Provider1_All Alert Types_Drill_Down_Level_Greater7Days_Dashboard":
                    FacSrvClnPrvAlt.Visible = true;
                    CalStartEndDates.Visible = true;
                    AlertTypeLabel.Visible = false;
                    ddlAlertTypes.Visible = false;
                    RequiredFieldValidatorAlertType.Visible = false;
                    RequiredFieldValidatorAlertType.Enabled = false;
                    btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFacilities);
                    break;
                case "Aware_Provider1_All Alert Types_Drill-Down_Level_Greater7Days_Dashboard - Backup":
                    FacSrvClnPrvAlt.Visible = true;
                    CalStartEndDates.Visible = true;
                    AlertTypeLabel.Visible = false;
                    ddlAlertTypes.Visible = false;
                    RequiredFieldValidatorAlertType.Visible = false;
                    RequiredFieldValidatorAlertType.Enabled = false;
                   btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFacilities);
                    break;
                case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard":
                    FacSrvPrv.Visible = true;
                    CalStartEndDates.Visible = true;
                    btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFacilities_1);
                    break;
                case "Aware_Provider1_All Services_Drill_Down_Level_Greater7Days_Dashboard":
                    FacProv.Visible = true;
                    CalStartEndDates.Visible = true;
                    btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFacilities_2);
                    break;
                case "Aware_Provider1_All Services_Summary_Level_Dashboard":
                    goto case "Aware_Provider1_All Services_Drill_Down_Level_Greater7Days_Dashboard";
                case "Aware_Provider1_Composite_All Services_Summary_Level_Dashboard":
                    goto case "Aware_Provider1_All Services_Drill_Down_Level_Greater7Days_Dashboard";                
                case "Aware_Provider1_Service_All Clinics_Summary_Level_Dashboard":
                    goto case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard";
                case "Aware_Provider1_Summary_Level_Dashboard":
                    goto case "Aware_Provider1_All Alert Types_Drill-Down_Level_Greater7Days_Dashboard - Backup";
                case "Aware_Site_All_Services_Summary_Drill_Down_Level_Dashboard":
                    Fac.Visible = true;
                    CalStartEndDates.Visible = true;
                    btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFaclilities_3);
                    break;
                case "Aware_Site_All_Services1_Full_Summary_Drill_Down_Level_Show_Only_GT_7Days_Dashboard":
                    goto case "Aware_Site_All_Services_Summary_Drill_Down_Level_Dashboard";
                case "Aware_Site_All_ServicesClinics_Summary_Drill_Down_Level_Dashboard":
                    goto case "Aware_Site_All_Services_Summary_Drill_Down_Level_Dashboard";
                case "Aware_Site_Composite_All_Services1_Summary_Drill_Down_Level_Show_Only_GT_7Days_Dashboard":
                    goto case "Aware_Site_All_Services_Summary_Drill_Down_Level_Dashboard";
                case "Aware_Site_Full_Summary_Drill_Down_Level_Dashboard":
                    FacSrvCl.Visible = true;
                    CalStartEndDates.Visible = true;
                    btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFacilities_4);
                    break;                      
                case "Aware_Site_Full_Summary_Drill_Down_Level_Show_Only_GT_7Days_Dashboard":
                    goto case "Aware_Site_Full_Summary_Drill_Down_Level_Dashboard";                    
                case "Aware_Site_Service_All_Clinics_Summary_Drill_Down_Level_Dashboard":
                    FacSrv.Visible = true;
                    CalStartEndDates.Visible = true;
                    btnViewReport.Enabled = true;
                    _PopulateFacilities(ref ddlFacilities_5);
                    break;
                      
                case "Aware_Site_Service_All_Clinics1_Full_Summary_Drill_Down_Level_Show_Only_GT_7Days_Dashboard":
                    goto case "Aware_Site_Service_All_Clinics_Summary_Drill_Down_Level_Dashboard";
                default:
                    _HideAllParamPanels();
                    break;
            }            
        }

        private void _HideAllParamPanels()
        {
            btnViewReport.Enabled = true;
            CalStartEndDates.Visible = false;
            FacSrvClnPrvAlt.Visible = false;
            FacSrvPrv.Visible = false;
            FacProv.Visible = false;
            Fac.Visible = false;
            FacSrvCl.Visible = false;
            FacSrv.Visible = false;
        }

        protected void ddlistReports_SelectedIndexChanged(object sender, EventArgs e)
        {
            List<ReportParameter> m_ParamList = new List<ReportParameter>();
            ListItem selItem = ddlistReports.Items[ddlistReports.SelectedIndex];
            AwareSecurables aws = new AwareSecurables(m_AppSettings.GetAwareDbConnectionString);
            _InitRptsessionVars();
            Session["SelectedReport"] = aws.GetObjectNameByPresNameObjType(selItem.Text, (int)AwareObjectTypes.REPORT_DEFINITIONS);
            rptViewerMain.Reset();
            _ClearAllDropDownsOnRptChange();
            _ShowHideReportParams((string)Session["SelectedReport"]);            
        }

        private void _ClearAllDropDownsOnRptChange()
        {
            ddlAlertTypes.Items.Clear();
            ddlClinics.Items.Clear();
            ddlClinics_4.Items.Clear();
            ddlFacilities.Items.Clear();
            ddlFacilities_1.Items.Clear();
            ddlFacilities_2.Items.Clear();
            ddlFacilities_4.Items.Clear();
            ddlFacilities_5.Items.Clear();
            ddlProviders.Items.Clear();
            ddlProviders_1.Items.Clear();
            ddlProviders_2.Items.Clear();
            ddlServices.Items.Clear();
            ddlServices_1.Items.Clear();
            ddlServices_4.Items.Clear();
            ddlServices_5.Items.Clear();            
        }

        // Section responsible for populating drop downs
        private int _PopulateFacilities( ref DropDownList ddl)
        {
            ddl.Items.Clear();
            ddl.Items.Add(DEF_LISTBOX_VALUE);
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AppSettings.GetAwareDbConnectionString))
            {
                string sqlText = "usp_GetFacilities";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    string fac = string.Empty;
                    try
                    {
                        fac = dr.GetString(1);
                    }
                    catch (InvalidCastException ex)
                    {
                        fac = string.Empty;
                    }
                    ddl.Items.Add(fac);
                }
                dr.Close();
                dbConn.Close();

                ddl.SelectedIndex = 0;
            }
            
            return ddl.Items.Count;
        }

        protected void ddlFacilities_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            ListItem selItem = ddl.Items[ddl.SelectedIndex];
            Session["InputFacility"] = selItem.Text;
            if (DEF_LISTBOX_VALUE != (string)Session["InputFacility"])
            {                
                _UpdateReportParamList("InputFacility", (string)Session["InputFacility"]);

                switch ((string)Session["SelectedReport"])
                {
                    case "Aware_Provider_Full_Drill_Down_Level_Dashboard":
                        _PopulateServices(ref ddlServices);
                        break;
                    case "Aware_Provider_Full_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    case "Aware_Provider1_All Alert Types_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard":
                        _PopulateServices(ref ddlServices_1);
                        break;
                    case "Aware_Provider1_All Services_Drill_Down_Level_Greater7Days_Dashboard":
                        _PopulateProviders(ref ddlProviders_2);
                        break;
                    case "Aware_Provider1_All Services_Summary_Level_Dashboard":
                        goto case "Aware_Provider1_All Services_Drill_Down_Level_Greater7Days_Dashboard";
                    case "Aware_Site_Full_Summary_Drill_Down_Level_Dashboard":
                        _PopulateServices(ref ddlServices_4);
                        break;
                    case "Aware_Site_Service_All_Clinics_Summary_Drill_Down_Level_Dashboard":
                        _PopulateServices(ref ddlServices_5);
                        break;
                    case "Aware_Site_Service_All_Clinics1_Full_Summary_Drill_Down_Level_Show_Only_GT_7Days_Dashboard":
                        goto case "Aware_Site_Service_All_Clinics_Summary_Drill_Down_Level_Dashboard";
                    case "Aware_Provider1_Composite_All Services_Summary_Level_Dashboard":
                        goto case "Aware_Provider1_All Services_Drill_Down_Level_Greater7Days_Dashboard";
                    case "Aware_Provider1_Service_All Clinics_Summary_Level_Dashboard":
                        goto case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard";
                    case "Aware_Provider1_Summary_Level_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    case "Aware_Site_Full_Summary_Drill_Down_Level_Show_Only_GT_7Days_Dashboard":
                        goto case "Aware_Site_Full_Summary_Drill_Down_Level_Dashboard";
                    default:                        
                        break;
                }                
            }
        }

        private int _PopulateServices(ref DropDownList ddl)
        {
            ddl.Items.Clear();
            ddl.Items.Add(DEF_LISTBOX_VALUE);
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AppSettings.GetAwareDbConnectionString))
            {
                string sqlText = "usp_GetServices"; 
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@FacilityName", Session["InputFacility"].ToString());
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    string srv = string.Empty;
                    try
                    {
                        srv = dr.GetString(0);
                    }
                    catch (InvalidCastException ex)
                    {
                        srv = string.Empty;
                    }
                    ddl.Items.Add(srv);
                }
                dr.Close();
                dbConn.Close();

                ddl.SelectedIndex = 0;
            }
            
            return ddl.Items.Count;
        }

        protected void ddlServices_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            ListItem selItem = ddl.Items[ddl.SelectedIndex]; 
            Session["InputService"] = selItem.Text;
            if (DEF_LISTBOX_VALUE != (string)Session["InputService"])
            {                
                _UpdateReportParamList("InputService", (string)Session["InputService"]);

                switch ((string)Session["SelectedReport"])
                {
                    case "Aware_Provider_Full_Drill_Down_Level_Dashboard":
                        _PopulateClinics(ref ddlClinics);
                        break;
                    case "Aware_Provider_Full_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    case "Aware_Provider1_All Alert Types_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard":
                        _PopulateProviders(ref ddlProviders_1);
                        break;
                    case "Aware_Site_Full_Summary_Drill_Down_Level_Dashboard":
                        _PopulateClinics(ref ddlClinics_4);
                        break;
                    case "Aware_Provider1_Service_All Clinics_Summary_Level_Dashboard":
                        goto case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard";
                    case "Aware_Provider1_Summary_Level_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    case "Aware_Site_Full_Summary_Drill_Down_Level_Show_Only_GT_7Days_Dashboard":
                        goto case "Aware_Site_Full_Summary_Drill_Down_Level_Dashboard";
                    default:
                        break;
                }                
            }
        }

        private int _PopulateClinics(ref DropDownList ddl)
        {
                ddl.Items.Clear();
                ddl.Items.Add(DEF_LISTBOX_VALUE);
                using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AppSettings.GetAwareDbConnectionString))
                {
                    string sqlText = "usp_GetClinicbyFacSrv";
                    SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                    sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                    sqlCmd.Parameters.AddWithValue("@FacilityName", Session["InputFacility"].ToString());
                    sqlCmd.Parameters.AddWithValue("@Service", Session["InputService"].ToString());
                    SqlDataReader dr = sqlCmd.ExecuteReader();
                    while (dr.Read())
                    {
                        string cln = string.Empty;
                        try
                        {
                            cln = dr.GetString(0);
                        }
                        catch (InvalidCastException ex)
                        {
                            cln = string.Empty;
                        }
                        ddl.Items.Add(cln);
                    }
                    dr.Close();
                    dbConn.Close();

                    ddl.SelectedIndex = 0;
                }
            
            return ddl.Items.Count;
        }

        protected void ddlClinics_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            ListItem selItem = ddl.Items[ddl.SelectedIndex];
            Session["InputClinic"] = selItem.Text;
            if (DEF_LISTBOX_VALUE != (string)Session["InputClinic"])
            {
                _UpdateReportParamList("InputClinic", (string)Session["InputClinic"]);
                _PopulateProviders(ref ddlProviders);
            }            
        }
                  
        private int _PopulateProviders(ref DropDownList ddl)
        {
            ddl.Items.Clear();
            ddl.Items.Add(DEF_LISTBOX_VALUE);
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AppSettings.GetAwareDbConnectionString))
            {
                string sqlText = "usp_SelectProvider";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                switch ((string)Session["SelectedReport"])
                {
                    case "Aware_Provider_Full_Drill_Down_Level_Dashboard":                        
                        sqlCmd.Parameters.AddWithValue("@OrdProvTbl", "OrderingProvider$");
                        sqlCmd.Parameters.AddWithValue("@Service", Session["InputService"].ToString());
                        sqlCmd.Parameters.AddWithValue("@Clinic", Session["InputClinic"].ToString());
                        break;
                    case "Aware_Provider_Full_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";                        
                    case "Aware_Provider1_All Alert Types_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";                        
                    case "Aware_Provider1_All Alert Types_Drill-Down_Level_Greater7Days_Dashboard - Backup":                        
                        break;
                    case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard":
                        sqlCmd.Parameters.AddWithValue("@OrdProvTbl", "OrderingProviderAllClinics$");
                        sqlCmd.Parameters.AddWithValue("@Service", Session["InputService"].ToString());
                        break;
                    case "Aware_Provider1_Service_All Clinics_Summary_Level_Dashboard":
                        goto case "Aware_Provider1_All Clinics_Drill_Down_Level_Greater7Days_Dashboard";
                    case "Aware_Provider1_Summary_Level_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";                    
                    default:
                        sqlCmd.Parameters.AddWithValue("@OrdProvTbl", "OrderingProviderAllServices$");
                        break;
                }
                sqlCmd.Parameters.AddWithValue("@FacilityName", Session["InputFacility"].ToString());

                if(Session["IsSuperUser"].ToString() == "False")
                {
                    if (false == m_AwHelpers.AwareSecurity.ViewAllProviders(Guid.Parse(Session["UserSid"].ToString())))
                    {
                        sqlCmd.Parameters.AddWithValue("@ViewAll", false);
                        sqlCmd.Parameters.AddWithValue("@ProviderId", m_AwHelpers.AwareSecurity.GetProviderVistaId(Guid.Parse(Session["Usersid"].ToString())));                   
                    }
                }

                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    string prv = string.Empty;
                    try
                    {
                        prv = dr.GetString(0);
                    }
                    catch (InvalidCastException ex)
                    {
                        prv = string.Empty;
                    }
                    ddl.Items.Add(prv);
                }
                dr.Close();
                dbConn.Close();

                ddl.SelectedIndex = 0;
            }
            
            return ddl.Items.Count;
        }

        protected void ddlProviders_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            ListItem selItem = ddl.Items[ddl.SelectedIndex];
            Session["InputProvider"] = selItem.Text;
            if (DEF_LISTBOX_VALUE != (string)Session["InputProvider"])
            {
                _UpdateReportParamList("InputProvider", (string)Session["InputProvider"]);

                switch ((string)Session["SelectedReport"])
                {
                    case "Aware_Provider_Full_Drill_Down_Level_Dashboard":
                        _PopulateAlertTypes(ref ddlAlertTypes);
                        break;
                    case "Aware_Provider_Full_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    case "Aware_Provider1_All Alert Types_Drill_Down_Level_Greater7Days_Dashboard":
                        goto case "Aware_Provider_Full_Drill_Down_Level_Dashboard";
                    default:
                        break;
                }
                
            }             
        }

        private int _PopulateAlertTypes(ref DropDownList ddl)
        {
            ddl.Items.Clear();
            ddl.Items.Add(DEF_LISTBOX_VALUE);
            using (SqlConnection dbConn = m_SqlHelpers.GetDbConnection(m_AppSettings.GetAwareDbConnectionString))
            {
                string sqlText = "usp_SelectAlertTypes";
                SqlCommand sqlCmd = new SqlCommand(sqlText, dbConn);
                sqlCmd.CommandType = System.Data.CommandType.StoredProcedure;
                sqlCmd.Parameters.AddWithValue("@FacilityName", Session["InputFacility"].ToString());
                sqlCmd.Parameters.AddWithValue("@Service", Session["InputService"].ToString());
                sqlCmd.Parameters.AddWithValue("@Clinic", Session["InputClinic"].ToString());
                sqlCmd.Parameters.AddWithValue("@provider", Session["InputProvider"].ToString());
                SqlDataReader dr = sqlCmd.ExecuteReader();
                while (dr.Read())
                {
                    string alert = string.Empty;
                    try
                    {
                        alert = dr.GetString(0);
                    }
                    catch (InvalidCastException ex)
                    {
                        alert = string.Empty;
                    }
                    ddl.Items.Add(alert);
                }
                dr.Close();
                dbConn.Close();

                ddl.SelectedIndex = 0;
            }
            
            return ddl.Items.Count;
        }

        protected void ddlAlertTypes_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList ddl = (DropDownList)sender;
            ListItem selItem = ddl.Items[ddl.SelectedIndex];
            Session["InputAlertType"] = selItem.Text;
            if (DEF_LISTBOX_VALUE != (string)Session["InputAlertType"])
            {
                _UpdateReportParamList("InputAlertType", (string)Session["InputAlertType"]);                
            }
        }

        private void _SetAlertStartDate()
        {
            try
            {                
                Session["InputStart"] = TbAlertStartDate.Text;
                _UpdateReportParamList("InputStart", (string)Session["InputStart"]);                
            }
            catch (FormatException ex)
            {
            }
        }

        private void _SetAlertEndDate()
        {
            try
            {                
                Session["InputEnd"] = TbAlertEndDate.Text;
                _UpdateReportParamList("InputEnd", (string)Session["InputEnd"]);                
            }
            catch (FormatException ex)
            {
            }            
        }

        private void _UpdateReportParamList(string parameter, string value)
        {
            foreach (ReportParameter param in m_ParamList)
            {
                if (param.Name == parameter)
                {
                    m_ParamList.Remove(param);
                    break;
                }
            }
            m_ParamList.Add(new ReportParameter(parameter, value, false));
        }

        private void _UpdateParameterListForSelectedReport()
        {
            List<ReportParameter> tmpParamList = new List<ReportParameter>(m_ParamList);
            ReportingService2010 rs = new ReportingService2010();
            rs.Credentials = System.Net.CredentialCache.DefaultCredentials;
            rs.Url = m_AppSettings.GetReportServerUrl.ToString();
            string historyId = null;
            Reportingservice2010.ParameterValue[] values = null;
            Reportingservice2010.DataSourceCredentials[] credentials = null;
            string rptName = string.Format("/{0}/{1}", m_AppSettings.GetReportsRootFolder, Session["SelectedReport"]);
            var parameters = rs.GetItemParameters(string.Format("/{0}/{1}", m_AppSettings.GetReportsRootFolder, Session["SelectedReport"]), historyId, true, values, credentials);
            foreach (ReportParameter apParm in tmpParamList)
            {
                bool belongs = false;
                string apName = apParm.Name;
                foreach (var svrParm in parameters)
                {
                    string svrName = svrParm.Name;
                    if (apName == svrName)
                    {
                        belongs = true;
                        break;
                    }
                }

                if(belongs == false)
                {
                    m_ParamList.Remove(apParm);
                }
            }
        }

        protected void btnViewReport_Click(object sender, EventArgs e)
        {
            _SetAlertStartDate();
            _SetAlertEndDate();
            // here we need to send some parameters to the reporting service
            rptViewerMain.ProcessingMode = Microsoft.Reporting.WebForms.ProcessingMode.Remote;
            ServerReport svrRpt = rptViewerMain.ServerReport;
            System.Net.ICredentials credentials = System.Net.CredentialCache.DefaultCredentials;
            svrRpt.ReportServerUrl = new Uri(m_AppSettings.GetReportServerUrlSansWebService);
            svrRpt.ReportPath = string.Format("/{0}/{1}", m_AppSettings.GetReportsRootFolder, Session["SelectedReport"]);
            _UpdateParameterListForSelectedReport();
            rptViewerMain.ServerReport.SetParameters(m_ParamList);
            rptViewerMain.ServerReport.Refresh();
        }

        

        

        
        // End section
    }
}