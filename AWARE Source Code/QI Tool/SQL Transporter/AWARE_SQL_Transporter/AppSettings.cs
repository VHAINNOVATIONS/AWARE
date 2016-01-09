using System;
using System.Configuration;
using System.IO;

namespace AWARE_SQL_Transporter
{
    public struct SITE_PROPERTY
    {
        public string VhaSiteMoniker;
        public string VistaProperties;

        public SITE_PROPERTY(string moniker, string props)
        {
            VhaSiteMoniker = moniker;
            VistaProperties = props;
        }
    }

    public class AppSettings
    {
        public AppSettings()
        {
            SqlServerConnectionString = Properties.Settings.Default.AwareDbConnString;
            MinimumAmtFreeDiskSpace = (Int64.Parse(ConfigurationManager.AppSettings["FreeDiskSpaceLimitMB"])*1000000);
            MaximumLogFileSize = (Int64.Parse(ConfigurationManager.AppSettings["FreeDiskSpaceLimitMB"])*1000000);
            ApplicationVersion = ConfigurationManager.AppSettings["ApplicationVersion"];
            ApplicationHomePath = Directory.GetCurrentDirectory();
        }

        #region Methods
        public bool GetLogRpcResults()
        {
            bool logResults = false;
            string val = ConfigurationManager.AppSettings["LogRpcResults"];
            if (val.ToLower() == true.ToString().ToLower())
                logResults = true;

            return logResults;
        }

        public bool GetLogSqlStatements()
        {
            bool logSql = false;
            string val = ConfigurationManager.AppSettings["LogSqlStatements"];
            if (val.ToLower() == true.ToString().ToLower())
                logSql = true;

            return logSql;
        }

        
        #endregion

        #region Properties
        public string VhaSiteMoniker { get; set; }
        public string VistaIpAddress { get; set;}
        public string VistaAccessCode { get; set; }
        public string VistaVerifyCode { get; set; }

        public string SqlServerConnectionString { get; set;}
        public Int64 MinimumAmtFreeDiskSpace { get; set; }
        public int MaximumNumberOfSavedLogFiles { get; set; }
        public Int64 MaximumLogFileSize { get; set; }
        public string ApplicationVersion { get; set; }
        public string ApplicationHomePath { get; set; }
        #endregion

    }
}
