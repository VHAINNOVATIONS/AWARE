using System;
using System.Web.UI;
using AwareQIManager.AwareWebSrv;

namespace AwareQIManager
{
    public partial class AlertDemographic : System.Web.UI.Page
    {
        private string _patientID = string.Empty;
        private string _patientName = string.Empty;

        public AlertDemographic()
        {
              
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (true == string.IsNullOrEmpty((string) Session["UserSid"]))
            {
                Session["LastError"] = "NO_ERROR";
                Response.Redirect("Logon.aspx");
            }
            else
            {
                _patientID = Request.QueryString["p"];
                using (AwareQIManager.AwareWebSrv.WSAWARE webSrv = new WSAWARE())
                {
                    try
                    {
                        string webResponse = webSrv.GetPatientInfo(int.Parse(_patientID), true);
                        if (-1 < webResponse.IndexOf(" - Unknown"))
                        {
                            _patientName = string.Format("Patient ID {0} not found in VistA!!!", _patientID);
                        }
                        else
                        {
                            if (-1 < webResponse.IndexOf("["))
                            {
                                _patientName = webResponse.Substring(0, (webResponse.IndexOf("[") - 1));
                            }
                            else
                            {
                                _patientName = webResponse;
                            }

                            int brkyIdx = _patientName.IndexOf("]");
                            if (-1 < webResponse.IndexOf("]"))
                            {
                                lblLastandFourValue.Text = webResponse[0] + webResponse.Substring((webResponse.IndexOf("]") - 4), 4);
                            }
                            else
                            {
                                lblLastandFourValue.Text = "Web response in wrong format, missing ending bracket!";
                            }
                        }
                    }
                    catch (System.InvalidOperationException ex)
                    {
                        _patientName = string.Format("Patient ID {0} not found in VistA!!!", _patientID);
                        lblLastandFourValue.Text = _patientName;
                    }
                }

                lblDemIdValue.Text = _patientID;
                lblDemNameValue.Text = _patientName;
                 
            }
        }

        protected void btnClose_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(typeof(Page), "ClosePage", "window.close();", true);
        }        
    }
}