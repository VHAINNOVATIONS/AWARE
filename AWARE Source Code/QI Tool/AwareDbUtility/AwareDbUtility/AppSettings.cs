using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AwareDbUtility
{
    public class AppSettings
    {
        public string AwareSqlScriptsPath { get; set; }
        public string SqlSvrName { get; set; }
        public string SqlConnString { get; set; }
        public string ApplicationName { get; set; }              
    }
}
