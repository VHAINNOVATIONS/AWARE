using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Harris.Common;
using System.Data.SqlClient;
using AwareHelpersLib;
using System.Text;

namespace AwareQIManager
{
    public partial class Admin : System.Web.UI.Page
    {
        private Guid DEF_NEW_GUID = new Guid();
        private AwareHelpers m_AwHelpers;

        private SQLHelpers m_SqlHelpers = new SQLHelpers();
        private AwareAppSettings m_AppSettings = new AwareAppSettings();
        private HAR_StringEncrypter m_Encrypter = new HAR_StringEncrypter();

        public Admin()
        {
            m_AwHelpers = new AwareHelpers(m_AppSettings.GetAwareDbConnectionString);
            
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (true == string.IsNullOrEmpty((string)Session["UserSid"]))
            {
                Session["LastError"] = "NO_ERROR";
                Response.Redirect("Logon.aspx");
            }
            else
            {
                if (false == IsPostBack)
                {
                    _HideAllPanels();
                    _PopulateQiGroups();
                    _PopulateVistaGrps();
                    _PopulateUsers();
                    _PopulateReports();
                    _LoadUsersChkList();
                    _LoadReportsChkListBox();
                    _PopulateVisGrpUsersFacilities();
                }
            }
        }

        private void _InitAdminSessionVars()
        {
            Session["GrpIdBeingEdited"] = string.Empty;
            Session["GrpIdBeingDeleted"] = string.Empty;
            Session["UsersIdBeingEdited"] = string.Empty;
            Session["UserIdBeingDeleted"] = string.Empty;
            Session["VistaGrpIdBeingEdited"] = string.Empty;
            Session["VistaGrpIdBeingDeleted"] = string.Empty;
            Session["ReportBeingEdited"] = string.Empty;
        }

        private void _HideAllPanels()
        {
            PnlAddEditGroup.Visible = false;
            PnlDeleteGrp.Visible = false;
            PnlAddEditVistaGroup.Visible = false;
            PnlDeleteVistaGrp.Visible = false;
            PnlUsersDtl.Visible = false;
            PnlUserDel.Visible = false;
            PnlReports.Visible = false;
        }

        

        #region QI Groups related

        private int _PopulateQiGroups()
        {
            LstQiGrps.Items.Clear();
            DlstVisQiGrps.Items.Clear();

            DlstVisQiGrps.Items.Add("...Select a group...");            
            List<QI_GROUP_REC> groups = new List<QI_GROUP_REC>();
            groups = m_AwHelpers.AwareGroups.GetQiGroupCollection(true);
            foreach (QI_GROUP_REC grp in groups)
            {
                ListItem li = new ListItem(grp.Name);
                li.Value = grp.GroupID.ToString();
                LstQiGrps.Items.Add(li);
                DlstVisQiGrps.Items.Add(li);
            }

            return LstQiGrps.Items.Count;
        }
        
        protected void BtnGrpAdd_Click(object sender, EventArgs e)
        {            
            _HideAllPanels();
            PnlAddEditGroup.Visible = true;
            TbxQiGrpName.Text = string.Empty;
            CkBxGrpActive.Checked = false;
            _LoadUsersChkList();
            _LoadReportsChkListBox();
            Session["GrpIdBeingEdited"] = (Guid)new Guid();
            foreach (ListItem liUser in CkBxLstUsers.Items){liUser.Selected = false;}
            foreach (ListItem liRpt in CkBxLstReports.Items){liRpt.Selected = false;}
        }

        protected void BtnGrpEdit_Click(object sender, EventArgs e)
        {
            _InitAdminSessionVars();
            ListItem selGrp = LstQiGrps.SelectedItem;
            if (selGrp == null)
            {
               return;
            }
            else
            {
                _InitAdminSessionVars();
                _HideAllPanels();
                PnlAddEditGroup.Visible = true;                
                _LoadUsersChkList();
                TbxQiGrpName.Text = selGrp.Text;
                Session["GrpIdBeingEdited"] = selGrp.Value;// (Guid)m_AwHelpers.AwareGroups.GetGroupId(selGrp.Text);
                CkBxGrpActive.Checked = m_AwHelpers.AwareGroups.IsGroupActive(m_AwHelpers.AwareGroups.GetGroupId(selGrp.Text));

                Guid grpId = Guid.Parse(Session["GrpIdBeingEdited"].ToString());
                foreach (ListItem liUser in CkBxLstUsers.Items)
                {                    
                    Guid userId = Guid.Parse(liUser.Value.ToString());
                    liUser.Selected = m_AwHelpers.AwareGroups.DoesRoleExist(grpId, userId);                    
                }

                foreach (ListItem liRpt in CkBxLstReports.Items)
                {
                    Guid rptId = Guid.Parse(liRpt.Value.ToString());
                    liRpt.Selected = m_AwHelpers.AwareSecurity.DoesSecurityRightExists((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, grpId);
                }


            }
        }

        protected void BtnGrpDelete_Click(object sender, EventArgs e)
        {
            _InitAdminSessionVars();
            ListItem selGrp = LstQiGrps.SelectedItem;
            if (selGrp == null)
            {
                return;
            }
            else
            {                
                Session["GrpIdBeingDeleted"] = selGrp.Value;
                _HideAllPanels();
                LblGrpDeleteMsg.Text = string.Format("Are you sure you want to delete the group {0}? Deleting will clear all permissions associated with the group!", selGrp.Text);
                PnlDeleteGrp.Visible = true;                
            }
        }

        private int _LoadUsersChkList()
        {
            //if (false == IsPostBack)
            //{
                CkBxLstUsers.Items.Clear();
                List<QI_USER_REC> users = new List<QI_USER_REC>();
                users = m_AwHelpers.AwareUsers.GetQiUsersCollection(true);
                foreach (QI_USER_REC usr in users)
                {
                    ListItem li = new ListItem(usr.UserName);
                    li.Value = usr.UserID.ToString();
                    li.Selected = false;
                    CkBxLstUsers.Items.Add(li);                    
                }
           // }
            return CkBxLstUsers.Items.Count;
        }

        private int _LoadReportsChkListBox()
        {
            if (false == IsPostBack)
            {
                CkBxLstReports.Items.Clear();
                List<QI_REPORT_REC> reports = new List<QI_REPORT_REC>();
                reports = m_AwHelpers.AwareReports.GetQiReportsCollection(true);
                foreach (QI_REPORT_REC rpt in reports)
                {
                    ListItem li = new ListItem(rpt.Name);
                    li.Value = rpt.ReportID.ToString();
                    li.Selected = false;
                    CkBxLstReports.Items.Add(li);
                }
            }
           
            return CkBxLstReports.Items.Count;
        }

        private bool CheckRequiredFieldWhenSavingQIGroup()
        {
            bool result = true;

            if (CkBxGrpActive.Checked)
            {
                List<ListItem> selected = new List<ListItem>();

                // check user list
                foreach (ListItem item in CkBxLstUsers.Items)
                    if (item.Selected) selected.Add(item);

                if (selected.Count == 0)
                {
                    PopupMessage("Please select at least one user!");
                    CkBxLstUsers.Focus();
                    result = false;
                }

                // check reports list
                selected = new List<ListItem>();
                foreach (ListItem item in CkBxLstReports.Items)
                    if (item.Selected) selected.Add(item);

                if (selected.Count == 0)
                {
                    PopupMessage("Please select at least one report!");
                    CkBxLstReports.Focus();
                    result = false;
                }
            }

            return result;

        }

        protected void BtnGroupApply_Click(object sender, EventArgs e)
        {
            try
            {
                if (CheckRequiredFieldWhenSavingQIGroup() == false)
                {
                    return;
                }
                if (Session["GrpIdBeingEdited"] == null || string.IsNullOrEmpty(Session["GrpIdBeingEdited"].ToString()))
                {
                    Session["GrpIdBeingEdited"] = new Guid();
                }
                if (Guid.Parse(Session["GrpIdBeingEdited"].ToString()) != DEF_NEW_GUID)
                {
                    if (TbxQiGrpName.Text.Length > 0)
                    {
                        QI_GROUP_REC grp = new QI_GROUP_REC(Guid.Parse(Session["GrpIdBeingEdited"].ToString()), TbxQiGrpName.Text, CkBxGrpActive.Checked);
                        m_AwHelpers.AwareGroups.UpdateGroup(ref grp);
                        Guid grpId = Guid.Parse(Session["GrpIdBeingEdited"].ToString());

                        foreach (ListItem liUser in CkBxLstUsers.Items)
                        {                            
                            Guid userId = Guid.Parse(liUser.Value.ToString());
                            if (liUser.Selected == true)
                            {
                                if (false == m_AwHelpers.AwareGroups.DoesRoleExist(grpId, userId))
                                {
                                    m_AwHelpers.AwareGroups.AddUserToGroup(grpId, userId);
                                }
                            }
                            else
                            {
                                if (true == m_AwHelpers.AwareGroups.DoesRoleExist(grpId, userId))
                                {
                                    m_AwHelpers.AwareGroups.DeleteRole(grpId, userId);
                                }
                            }
                        }

                        foreach (ListItem liRpt in CkBxLstReports.Items)
                        {
                            Guid rptId = Guid.Parse(liRpt.Value.ToString());
                            if(liRpt.Selected == true)
                            {                                
                                if (false == m_AwHelpers.AwareSecurity.DoesSecurityRightExists((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, grpId))
                                {
                                    m_AwHelpers.AwareSecurity.AddSecurityRight((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, grpId);
                                }
                            }
                            else
                            {                             
                                if (true == m_AwHelpers.AwareSecurity.DoesSecurityRightExists((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, grpId))
                                {
                                    m_AwHelpers.AwareSecurity.DeleteSecurityRight((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, grpId);
                                }
                            }
                        }

                        _InitAdminSessionVars();
                        TbxQiGrpName.Text = string.Empty;
                        CkBxGrpActive.Checked = false;
                        _PopulateQiGroups();
                        _InitAdminSessionVars();
                    }
                    else
                    {
                        _InitAdminSessionVars();
                        return;
                    }
                }
                else
                {
                    if (TbxQiGrpName.Text.Length > 0)
                    {
                        if (false == m_AwHelpers.AwareGroups.DoesGroupExist(TbxQiGrpName.Text))
                        {
                            m_AwHelpers.AwareGroups.AddGroup(TbxQiGrpName.Text, CkBxGrpActive.Checked);
                            Guid newGrpId = m_AwHelpers.AwareGroups.GetGroupId(TbxQiGrpName.Text);
                            foreach (ListItem liUser in CkBxLstUsers.Items)
                            {
                                Guid userId = Guid.Parse(liUser.Value.ToString());
                                if (liUser.Selected == true)
                                {
                                    if (false == m_AwHelpers.AwareGroups.DoesRoleExist(newGrpId, userId))
                                    {
                                        m_AwHelpers.AwareGroups.AddUserToGroup(newGrpId, userId);
                                    }
                                }
                                else
                                {
                                    if (true == m_AwHelpers.AwareGroups.DoesRoleExist(newGrpId, userId))
                                    {
                                        m_AwHelpers.AwareGroups.DeleteRole(newGrpId, userId);
                                    }
                                }
                            }

                            foreach (ListItem liRpt in CkBxLstReports.Items)
                            {
                                Guid rptId = Guid.Parse(liRpt.Value.ToString());
                                if (liRpt.Selected == true)
                                {
                                    if (false == m_AwHelpers.AwareSecurity.DoesSecurityRightExists((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, newGrpId))
                                    {
                                        m_AwHelpers.AwareSecurity.AddSecurityRight((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, newGrpId);
                                    }
                                }
                                else
                                {
                                    if (true == m_AwHelpers.AwareSecurity.DoesSecurityRightExists((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, newGrpId))
                                    {
                                        m_AwHelpers.AwareSecurity.DeleteSecurityRight((int)AwareObjectTypes.REPORT_DEFINITIONS, rptId, newGrpId);
                                    }
                                }
                            }

                            List<QI_GROUP_REC> groups = new List<QI_GROUP_REC>();
                            groups = m_AwHelpers.AwareGroups.GetQiGroupCollection(true);
                            foreach (QI_GROUP_REC grp in groups)
                            {
                                ListItem li = new ListItem(grp.Name);
                                li.Value = grp.GroupID.ToString();
                                LstQiGrps.Items.Add(li);
                            }
                            TbxQiGrpName.Text = string.Empty;
                            CkBxGrpActive.Checked = false;
                            _PopulateQiGroups();
                            _InitAdminSessionVars();
                        }
                        else
                        {
                            PopupMessage("The QI group you are trying to add already exists!");
                        }
                    }
                }
            }
            catch (NullReferenceException ex)
            {
            }
        }

        protected void BtnGrpDelYes_Click(object sender, EventArgs e)
        {
            try
            {
                if (Guid.Parse(Session["GrpIdBeingDeleted"].ToString()) != DEF_NEW_GUID)
                {
                    m_AwHelpers.AwareSecurity.DeleteEntitySecurityRights(Guid.Parse(Session["GrpIdBeingDeleted"].ToString()), (int)AwareObjectTypes.REPORT_DEFINITIONS);
                    m_AwHelpers.AwareSecurity.DeleteVistaGroupMappings(Guid.Parse(Session["GrpIdBeingDeleted"].ToString()));
                    m_AwHelpers.AwareGroups.DeleteGroup(Guid.Parse(Session["GrpIdBeingDeleted"].ToString()));
                    Session["GrpIdBeingDeleted"] = (Guid)new Guid();
                    _PopulateQiGroups();
                    PnlDeleteGrp.Visible = false;
                    _InitAdminSessionVars();
                }
            }
            catch (NullReferenceException ex)
            {
            }
        }

        protected void BtnGrpDelNo_Click(object sender, EventArgs e)
        {
            Session["GrpIdBeingDeleted"] = (Guid)new Guid();
            PnlDeleteGrp.Visible = false;
            _InitAdminSessionVars();
        }

        #endregion

        #region QI Users Related

        private int _PopulateUsers()
        {
            LstUsers.Items.Clear();
            List<QI_USER_REC> users = new List<QI_USER_REC>();
            users = m_AwHelpers.AwareUsers.GetQiUsersCollection(true);
            foreach (QI_USER_REC usr in users)
            {
                ListItem li = new ListItem(usr.UserName);
                li.Value = usr.UserID.ToString();
                LstUsers.Items.Add(li);
            }

            return LstReports.Items.Count;
        }

        protected void BtnUsersEdit_Click(object sender, EventArgs e)
        {
            _InitAdminSessionVars();
            _HideAllPanels();
            PnlUsersDtl.Visible = true;
            ListItem selUser = LstUsers.SelectedItem;           
            if (selUser != null)
            {
                Session["UsersIdBeingEdited"] = selUser.Value;
                QI_USER_REC user = m_AwHelpers.AwareUsers.GetUserRecordById(Guid.Parse(Session["UsersIdBeingEdited"].ToString()));
                TbxUserName.Text = user.UserName;
                TbxVerifyCode.Text = user.VerifyCode;
                // Find the user facility from the dropdown list
                int index = DdlUsersFac.Items.IndexOf(DdlUsersFac.Items.FindByValue(user.FacilityId.ToString()));
                DdlUsersFac.SelectedIndex = index < 0 ? 0 : index;
            }
        }

        protected void BtnUsersAdd_Click(object sender, EventArgs e)
        {
            _HideAllPanels();
            PnlUsersDtl.Visible = true;
            ResetUserInfo();
            Session["UsersIdBeingEdited"] = (Guid)new Guid();
        }

        protected void BtnUsersDel_Click(object sender, EventArgs e)
        {
            _HideAllPanels();
            ListItem selUser = LstUsers.SelectedItem;
            if (selUser != null)
            {
                Session["UserIdBeingDeleted"] = selUser.Value;
                LblUsersDel.Text = string.Format("Are you sure you want to delete the group {0}? Deleting will clear all permissions associated with the user!", selUser.Text);
                PnlUserDel.Visible = true;                
            }            
        }

        protected void BtnUserDelYes_Click(object sender, EventArgs e)
        {
            try
            {
                if (Guid.Parse(Session["UserIdBeingDeleted"].ToString()) != DEF_NEW_GUID)
                {
                    m_AwHelpers.AwareUsers.DeleteUser(Guid.Parse(Session["UserIdBeingDeleted"].ToString()));
                    Session["UserIdBeingDeleted"] = (Guid)new Guid();
                    _PopulateUsers();
                    PnlUserDel.Visible = false;
                    _InitAdminSessionVars();
                }
            }
            catch (NullReferenceException ex)
            {
            }
        }

        protected void BtnUserDelNo_Click(object sender, EventArgs e)
        {
            Session["UserIdBeingDeleted"] = (Guid)new Guid();
            PnlUserDel.Visible = false;
        }
        
        protected void BtnUsersApplyChanges_Click(object sender, EventArgs e)
        {
            try
            {   
                if (Session["UsersIdBeingEdited"] == null || string.IsNullOrEmpty(Session["UsersIdBeingEdited"].ToString()))
                {
                    Session["UsersIdBeingEdited"] = new Guid();
                }

                if (Guid.Parse(Session["UsersIdBeingEdited"].ToString()) != DEF_NEW_GUID)
                {
                    if (TbxUserName.Text.Length > 0)
                    {
                        Guid facId = new Guid();
                        facId = Guid.Parse(DdlUsersFac.SelectedValue);
                        QI_USER_REC user = new QI_USER_REC(Guid.Parse(Session["UsersIdBeingEdited"].ToString()), TbxUserName.Text, facId, TbxVerifyCode.Text);
                        m_AwHelpers.AwareUsers.UpdateUser(ref user);
                        ResetUserInfo();
                    }
                    else
                    {
                        _InitAdminSessionVars();
                        return;
                    }
                }
                else
                {
                    if (0 < TbxUserName.Text.Length)
                    {          
                        Guid facId = new Guid();
                        facId = Guid.Parse(DdlUsersFac.SelectedValue);
                        if (DEF_NEW_GUID == m_AwHelpers.AwareUsers.GetUsersId(TbxUserName.Text, facId))
                        {
                            Guid userId = m_AwHelpers.AwareUsers.AddUser(TbxUserName.Text, facId, TbxVerifyCode.Text);
                            ResetUserInfo();
                        }
                        else
                        {
                            PopupMessage("The user you are trying to add already exists!");
                        }
                    }
                }
            }
            catch (NullReferenceException ex)
            {
            }
        }

        #endregion


        #region Vista Groups related

        private int _PopulateVisGrpUsersFacilities()
        {
            DlstVisGrpFac.Items.Clear();
            DdlUsersFac.Items.Clear();
            List<QI_FACILITY_REC> facilities = new List<QI_FACILITY_REC>();
            facilities = m_AwHelpers.GetFacilitiesCollection();
            foreach (QI_FACILITY_REC fac in facilities)
            {
                ListItem li = new ListItem(fac.Name);
                li.Value = fac.ID.ToString();
                DlstVisGrpFac.Items.Add(li);
                DdlUsersFac.Items.Add(li);
            }

            return DlstVisGrpFac.Items.Count;
        }

        private int _PopulateVistaGrps()
        {
            LstVistaGrps.Items.Clear();
            List<QI_VISTA_GRP_REC> groups = new List<QI_VISTA_GRP_REC>();
            groups = m_AwHelpers.VistaGroups.GetVistaGroupCollection(true);
            foreach (QI_VISTA_GRP_REC grp in groups)
            {
                ListItem li = new ListItem(grp.Name);
                li.Value = grp.VistaGrpID.ToString();
                LstVistaGrps.Items.Add(li);
            }
                        
            return LstVistaGrps.Items.Count;            
        }

        protected void BtnVistaGrpAdd_Click(object sender, EventArgs e)
        {
            _HideAllPanels();
            PnlAddEditVistaGroup.Visible = true;
            Session["VistaGrpIdBeingEdited"] = (Guid)new Guid();

            ResetVistaGroup();
        }

        protected void BtnVistaGrpEdit_Click(object sender, EventArgs e)
        {
            ListItem selGrp = LstVistaGrps.SelectedItem;
            if (selGrp == null)
            {
                _InitAdminSessionVars();
                return;
            }
            else
            {
                _HideAllPanels();
                PnlAddEditVistaGroup.Visible = true;
                Session["VistaGrpIdBeingEdited"] = selGrp.Value;
                QI_VISTA_GRP_REC vistaGroup = m_AwHelpers.VistaGroups.GetVistaGroupById(Guid.Parse(selGrp.Value));
                TbxVisGrp.Text = vistaGroup.Name;
                int idx = DlstVisQiGrps.Items.IndexOf(DlstVisQiGrps.Items.FindByValue(vistaGroup.AwareGrpId.ToString()));
                DlstVisQiGrps.SelectedIndex = idx < 0 ? 0 : idx;
                idx = DlstVisGrpFac.Items.IndexOf(DlstVisGrpFac.Items.FindByValue(vistaGroup.FacilityId.ToString()));
                DlstVisGrpFac.SelectedIndex = idx < 0 ? 0 : idx;

                ChkBxOtherProvVisible.Checked = m_AwHelpers.AwareSecurity.DoesGrpHaveAllProvView(Guid.Parse(selGrp.Value.ToString()));
            }
        }

        protected void BtnVistaGrpDel_Click(object sender, EventArgs e)
        {
            ListItem selGrp = LstVistaGrps.SelectedItem;
            if (selGrp == null)
            {
                _InitAdminSessionVars();
                return;
            }
            else
            {
                Session["VistaGrpIdBeingDeleted"] = selGrp.Value;
                _HideAllPanels();
                LblVistaGrpDeleteMsg.Text = string.Format("Are you sure you want to delete the group {0}? Deleting will clear all permissions associated with the group!", selGrp.Text);
                PnlDeleteVistaGrp.Visible = true;
            }
        }

        protected void BtnVistaGrpDelYes_Click(object sender, EventArgs e)
        {
            try
            {

                if (Guid.Parse(Session["VistaGrpIdBeingDeleted"].ToString()) != DEF_NEW_GUID)
                {
                    m_AwHelpers.VistaGroups.DeleteVistaGroup(Guid.Parse(Session["VistaGrpIdBeingDeleted"].ToString()));
                    Session["VistaGrpIdBeingDeleted"] = (Guid)new Guid();
                    _PopulateVistaGrps();
                    PnlDeleteVistaGrp.Visible = false;
                    _InitAdminSessionVars();
                }
            }
            catch (NullReferenceException ex)
            {
            }
        }

        protected void BtnVistaGrpDelNo_Click(object sender, EventArgs e)
        {
            Session["VistaGrpIdBeingDeleted"] = (Guid)new Guid();
            PnlDeleteVistaGrp.Visible = false;
            _InitAdminSessionVars();
        }

        protected void VistaGrpApplyChanges_Click(object sender, EventArgs e)
        {
            try
            {
                if (Guid.Parse(Session["VistaGrpIdBeingEdited"].ToString()) != DEF_NEW_GUID)
                {
                    if (TbxVisGrp.Text.Length > 0)
                    {
                        Guid facId = new Guid();
                        facId = Guid.Parse(DlstVisGrpFac.SelectedValue);
                        Guid QiGrpId = new Guid();
                        QiGrpId = Guid.Parse(DlstVisQiGrps.SelectedValue);
                        QI_VISTA_GRP_REC grp = new QI_VISTA_GRP_REC(Guid.Parse(Session["VistaGrpIdBeingEdited"].ToString()), TbxVisGrp.Text, QiGrpId, facId, ChkBxOtherProvVisible.Checked);
                        m_AwHelpers.VistaGroups.UpdateVistaGroup(ref grp);                        
                        Session["VistaGrpIdBeingEdited"] = (Guid)new Guid();
                        ChkBxOtherProvVisible.Checked = false;
                        ResetVistaGroup();
                        _PopulateVistaGrps();
                    }
                    else
                    {
                        _InitAdminSessionVars();
                        return;
                    }
                }
                else
                {
                    if (0 < TbxVisGrp.Text.Length)
                    {
                        if (DEF_NEW_GUID == m_AwHelpers.VistaGroups.GetVistaGroupId(TbxVisGrp.Text))
                        {
                            Guid facId = new Guid();
                            facId = Guid.Parse(DlstVisGrpFac.SelectedValue);
                            Guid QiGrpId = new Guid();
                            QiGrpId = Guid.Parse(DlstVisQiGrps.SelectedValue);
                            Guid vistaMappingId = m_AwHelpers.VistaGroups.AddVistaGroup(TbxVisGrp.Text, facId, QiGrpId, ChkBxOtherProvVisible.Checked);
                            ResetVistaGroup();
                            _PopulateVistaGrps();
                        }
                        else
                        {
                            PopupMessage("The VistA group you are trying to add already exists!");
                        }
                    }
                }
            }
            catch (NullReferenceException ex)
            {
            }
        }

        #endregion

        #region Reports related

        private void ResetVistaGroup()
        {
            TbxVisGrp.Text = string.Empty;
            ChkBxOtherProvVisible.Checked = false;
            _PopulateVisGrpUsersFacilities();
            _PopulateQiGroups();
        }

        private void ResetUserInfo()
        {
            TbxUserName.Text = string.Empty;
            TbxVerifyCode.Text = string.Empty;
            _PopulateVisGrpUsersFacilities();
            _PopulateUsers();
            _LoadUsersChkList();
            _InitAdminSessionVars();
        }

        private int _PopulateReports()
        {
            LstReports.Items.Clear();
            List<QI_REPORT_REC> reports = new List<QI_REPORT_REC>();
            reports = m_AwHelpers.AwareReports.GetQiReportsCollection(true);
            foreach (QI_REPORT_REC rpt in reports)
            {
                ListItem li = new ListItem(rpt.PresentationName);
                li.Value = rpt.ReportID.ToString();
                LstReports.Items.Add(li);
            }
            
            return LstReports.Items.Count;
        }

        protected void BtnReportsEdit_Click(object sender, EventArgs e)
        {            
            ListItem selRpt = LstReports.SelectedItem;
            if (selRpt != null)
            {
                _HideAllPanels();
                PnlReports.Visible = true;
                Session["ReportBeingEdited"] = selRpt.Value;
                Guid rptId = new Guid();
                rptId = Guid.Parse(Session["ReportBeingEdited"].ToString());
                QI_REPORT_REC rpt = new QI_REPORT_REC();
                rpt = m_AwHelpers.AwareReports.GetReportRecord(rptId);
                TbxPresName.Text = rpt.PresentationName;
                TbxReportName.Text = rpt.Name;                
            }
        }

        protected void BtnRptsApply_Click(object sender, EventArgs e)
        {
            if (0 < TbxPresName.Text.Length)
            {
                Guid rptId = new Guid();
                rptId = Guid.Parse(Session["ReportBeingEdited"].ToString());
                QI_REPORT_REC rpt = new QI_REPORT_REC(rptId, TbxReportName.Text, TbxPresName.Text);
                m_AwHelpers.AwareReports.UpdateReport(ref rpt);
                Session["ReportBeingEdited"] = (Guid)new Guid();
                TbxPresName.Text = string.Empty;
                TbxReportName.Text = string.Empty;
                _PopulateReports();
                _InitAdminSessionVars();
            }
        }

        #endregion

        protected void LnkBtnRetToDef_Click(object sender, EventArgs e)
        {
           _InitAdminSessionVars();
           Response.Redirect("default.aspx");
        }

        private void PopupMessage(string message)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(@"<script language=JavaScript>");
            stringBuilder.Append(@"alert('" + message + "');");
            stringBuilder.Append(@"</");
            stringBuilder.Append(@"script>");

            ((Page)HttpContext.Current.Handler).RegisterStartupScript(new Guid().ToString(),
                stringBuilder.ToString());
        }
    }
}