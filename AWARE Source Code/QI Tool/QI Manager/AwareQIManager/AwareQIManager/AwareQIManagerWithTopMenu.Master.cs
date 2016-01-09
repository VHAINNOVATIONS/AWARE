using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AwareQIManager.Views
{
    public partial class AwareQIManagerWithTopMenu : System.Web.UI.MasterPage
    {
        public delegate void MasterPageMenuClickHandler(object sender, MenuEventArgs e);

        public event MasterPageMenuClickHandler MenuClick;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            AwareAppSettings appSettings = new AwareAppSettings();
            Page.Title = appSettings.GetApplicationName;
        }

        protected void MenuItemClick(object sender, MenuEventArgs e)
        {

            if (MenuClick != null)
            {
                MenuClick(sender, e);
            }

          }
    }
}