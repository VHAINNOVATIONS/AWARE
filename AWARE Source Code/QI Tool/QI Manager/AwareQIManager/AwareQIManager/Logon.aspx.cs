using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.DirectoryServices.AccountManagement;
using System.DirectoryServices.Protocols;
using System.DirectoryServices;
using System.Security.Principal;
using Harris.Common;
using AwareHelpersLib;
using AwareQIManager.AwareWebSrv;

namespace AwareQIManager
{
    public partial class Logon : System.Web.UI.Page
    {
        private const string WS_LOGON_INVALID_PAIR = "Not a valid ACCESS CODE/VERIFY CODE pair";
        private AwareAppSettings _appSettings = new AwareAppSettings();
        private AwareHelpers _awareHelpers; 
        protected void Page_Load(object sender, EventArgs e)
        {            
            IPrincipal princ = System.Web.HttpContext.Current.User;
            LabelBuildVersion.Text = "Build Version: " + _appSettings.GetApplicationVersion;
            LabelAccessCode.Text = _appSettings.GetLogonIdText;
            LabelVerifyCode.Text = _appSettings.GetLogonPwdText;

            if (false == _appSettings.GetSharedComputer)
            {
                tboxUserName.Text = princ.Identity.Name;
                tboxUserName.ReadOnly = true;
            }
            if ((string)Session["LastError"] != "NO_ERROR")
            {
                lblLogonStatus.Text = (string)Session["LastError"];
                lblLogonStatus.ForeColor = System.Drawing.Color.Red;
            }

            if (false == IsPostBack)
            {
                if (true == _appSettings.MaskLogonUserName)
                {
                    tboxUserName.TextMode = TextBoxMode.Password;
                    ChkBxRevealText.Checked = false;
                }
                else
                {
                    tboxUserName.TextMode = TextBoxMode.SingleLine;
                    ChkBxRevealText.Checked = true;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblLogonStatus.Text = "Attempting to logon...";
            Session["IsSuperUser"] = ValidateSUlogon().ToString();
            _awareHelpers = new AwareHelpers(_appSettings.GetAwareDbConnectionString);
            try
            {
                if (true == _AuthenticateUser(tboxUserName.Text.Substring(0, tboxUserName.Text.IndexOf('\\')), tboxUserName.Text.Substring((tboxUserName.Text.IndexOf('\\') + 1)), tboxPassword.Text))
                {
                    if (true == ValidateSUlogon())
                    {
                        Session["UserSid"] = _TranslateUserNameToSid(tboxUserName.Text);                        
                        Session["LastError"] = string.Empty;
                        Session["IsSuperUser"] = ValidateSUlogon().ToString();
                        Response.Redirect("Default.aspx");
                    }
                }
                else
                {                                              
                    if (false == ValidateAVCodes())
                    {
                        Session["LastError"] = "Logon credentials were invalid";
                        Page_Load(sender, e);                        
                    }
                }
            }
            catch (ArgumentOutOfRangeException ex)
            {
                if (false == ValidateAVCodes())
                {
                    string svrResponse = string.Empty;
                    using (AwareQIManager.AwareWebSrv.WSAWARE webSrv = new WSAWARE())
                    {
                        webSrv.UseDefaultCredentials = true;
                        svrResponse = webSrv.Login(tboxUserName.Text, tboxPassword.Text);
                        if (null != webSrv)
                        {
                            webSrv.Dispose();                               
                        }                        
                    }

                    // comment the following 2 lines out when building for release
                    //svrResponse = "1^OCONNOR,CATHERINE C[53902]^53902"; //no see all
                    //svrResponse = "2^OCONNOR,CATHERINE C[53902]^53902"; // see all

                    if (0 < svrResponse.IndexOf(WS_LOGON_INVALID_PAIR))
                    {
                        Session["LastError"] = WS_LOGON_INVALID_PAIR;
                        Page_Load(sender, e);
                        return;
                    }
                    string[] tokens = svrResponse.Split('^');

                    Guid prvId = new Guid();
                    if (false == _awareHelpers.AwareSecurity.DoesProviderExist(tokens[2]))
                    {
                        if (true == _awareHelpers.VistaGroups.DoesVistaGroupExist(tokens[0]))
                        {
                            prvId = _awareHelpers.AwareSecurity.AddProvider(tokens[1], tokens[2], _awareHelpers.VistaGroups.GetVistaGroupId(tokens[0]));
                            Session["UserSid"] = prvId.ToString();
                            Session["IsVistaLogon"] = "True";
                        }                        
                    }
                    else
                    {
                        prvId = _awareHelpers.AwareSecurity.UpdateProvider(tokens[1], tokens[2], _awareHelpers.VistaGroups.GetVistaGroupId(tokens[0]));                        
                        Session["UserSid"] = prvId.ToString();
                        Session["IsVistaLogon"] = "True";
                    }

                    if (true == _awareHelpers.VistaGroups.DoesVistaGroupExist(tokens[0]))
                    {
                        Guid vistaGrp = _awareHelpers.VistaGroups.GetVistaGroupId(tokens[0]);                        
                        Session["VistaAccessKey"] = tboxUserName.Text;
                        Session["VistaGrpId"] = (Guid)vistaGrp;
                        Session["LastError"] = string.Empty;
                        Session["IsSuperUser"] = ValidateSUlogon().ToString();
                        Response.Redirect("Default.aspx");
                    }
                    else
                    {
                        Session["LastError"] = "Logon credentials were invalid";
                        Page_Load(sender, e);
                    }
                }
                else
                {
                    Guid userId = new Guid();

                    userId = _awareHelpers.AwareUsers.GetUsersId(tboxUserName.Text);
                    if (userId != new Guid())
                    {
                        Session["UserSid"] = userId.ToString();
                        Session["LastError"] = string.Empty;
                        Session["IsSuperUser"] = ValidateSUlogon().ToString();
                        Response.Redirect("Default.aspx");
                    }
                    else
                    {
                        Session["LastError"] = "Logon credentials were invalid";
                        Page_Load(sender, e);
                    }                
                }
            }
        }

        private bool ValidateGroupMembership()
        {
            bool validated = false;
            List<GroupPrincipal> grpMemberships = new List<GroupPrincipal>();
            grpMemberships = GetUserGroups(tboxUserName.Text);           
            AwareAppSettings appSettings = new AwareAppSettings();
            AwareHelpers awHelpers = new AwareHelpers(appSettings.GetAwareDbConnectionString);
            foreach (GroupPrincipal grp in grpMemberships)
            {
                awHelpers.AwareSecurity.IsGroupPermittedAccess(grp.Name);
            }

            return validated;
        }

        private bool ValidateAVCodes()
        {
            bool isValid = false;
            HAR_StringEncrypter encrypter = new HAR_StringEncrypter();
            AwareAppSettings appSettings = new AwareAppSettings();
            AwareHelpers awHelpers = new AwareHelpers(appSettings.GetAwareDbConnectionString);
            if (true == awHelpers.AwareSecurity.VerifyUserCredentials(tboxUserName.Text, encrypter.EncryptString(tboxPassword.Text)))
            {
                isValid = true;                
            }

            return isValid;
        }

        private bool ValidateSUlogon()
        {
            bool isSu = false;
            AwareAppSettings appSettings = new AwareAppSettings();
            string suList = appSettings.GetSuperUserList;
            if (0 < suList.Length)
            {
                foreach (string su in suList.Split(';'))
                {
                    if (tboxUserName.Text.ToUpper() == su)
                    {
                        isSu = true;
                        break;
                    }
                }
            }

            return isSu;
        }

        private bool _AuthenticateUser(string domain, string username, string password)
        {
            bool authenticated = false;
            try
            {
                using (PrincipalContext pc = new PrincipalContext(ContextType.Domain, domain))
                {                    
                    authenticated = pc.ValidateCredentials(username, password);
                }
            }
            catch (PrincipalServerDownException ex)
            {                
                authenticated = _AuthenticateLocalUser(username, password);
            }

            return authenticated;
        }

        private bool _AuthenticateLocalUser(string username, string password ) 
        {
            PrincipalContext context = new PrincipalContext(ContextType.Machine); 
            
            return context.ValidateCredentials(username, password);        
        }

        private string _TranslateUserNameToSid(string username)
        {            
            NTAccount ntAcct = new NTAccount(username);
            SecurityIdentifier sid = (SecurityIdentifier)ntAcct.Translate(typeof(SecurityIdentifier));
                        
            return sid.ToString();
        }

        private List<GroupPrincipal> GetUserGroups(string userName)
        {
            List<GroupPrincipal> principleList = new List<GroupPrincipal>();
            
            PrincipalContext usersDomain = null;
            try
            {
                usersDomain = new PrincipalContext(ContextType.Domain);
            }
            catch (System.DirectoryServices.Protocols.LdapException ex)
            {
                usersDomain = new PrincipalContext(ContextType.Machine);
            }
            catch (PrincipalServerDownException ex)
            {
                usersDomain = new PrincipalContext(ContextType.Machine);
            }

            UserPrincipal userPrinc = UserPrincipal.FindByIdentity(usersDomain, userName);
            if (userPrinc != null)
            {
                PrincipalSearchResult<Principal> groups = userPrinc.GetAuthorizationGroups();
                foreach (Principal grp in groups)
                {
                    if (grp is GroupPrincipal)
                    {
                        principleList.Add((GroupPrincipal)grp);
                    }
                }
            }
            
            return principleList;
        }

        protected void ChkBxRevealText_CheckedChanged(object sender, EventArgs e)
        {
            string userNameVal = tboxUserName.Text;
            string userPwd = tboxPassword.Text;
            if (ChkBxRevealText.Checked == true)
            {
                tboxUserName.TextMode = TextBoxMode.SingleLine;
                tboxUserName.Attributes.Add("value", userNameVal); 
                tboxPassword.Attributes.Add("value", userPwd);
            }
            else
            {
                tboxUserName.TextMode = TextBoxMode.Password;                
                tboxUserName.Attributes.Add("value", userNameVal);
                tboxPassword.Attributes.Add("value", userPwd);
            }            
        }
    }
}