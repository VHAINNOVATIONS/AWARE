using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AwareQIManager.Views
{
    public partial class AwareQIManager : System.Web.UI.MasterPage
    {        
        protected void Page_Load(object sender, EventArgs e)
        {
            AwareAppSettings appSettings = new AwareAppSettings();
            Page.Title = appSettings.GetApplicationName;
        }
    }
}