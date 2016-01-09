using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.XPath;

namespace AWARE_SQL_Transporter
{
    class AwareXmlReader
    {
        public string XmlFileName { get; set; }
        public string XmlNode { get; set; }
        private string NodeXPath { get; set; }

        private XmlDocument m_XmlDocument = new XmlDocument();

        public AwareXmlReader(string xmlFileName)
        {
            XmlFileName = xmlFileName;
            m_XmlDocument.Load(XmlFileName);
            // set the default node path
            NodeXPath = "/configuration/VhaSites";
        }

        public void SetNodeXPath(string nodeXPath)
        {
            NodeXPath = nodeXPath;
        }

        public int GetKeyCount()
        {
            int cnt = 0;
            XmlNode node = m_XmlDocument.DocumentElement.SelectSingleNode(NodeXPath);
            cnt = node.SelectNodes("descendant::*").Count;
            return cnt;
        }

        public string GetVistaConnectionProperties(string vhaSiteMoniker)
        {
            string properties = string.Empty;
            XmlNode node = m_XmlDocument.DocumentElement.SelectSingleNode(NodeXPath);
            foreach (XmlNode chNode in node)
            {
                if (null != chNode.Attributes)
                {
                    if (vhaSiteMoniker == chNode.Attributes["SiteMoniker"].Value)
                    {
                        properties = chNode.Attributes["VistaDetails"].Value;
                    }
                }
            }
            return properties;
        }

        public SITE_PROPERTY[] GetVhaSiteConfigCollection()
        {
            SITE_PROPERTY [] configuredSites = new SITE_PROPERTY[GetKeyCount()];
            int idx = 0;
            XmlNode node = m_XmlDocument.DocumentElement.SelectSingleNode(NodeXPath);
            foreach (XmlNode chNode in node)
            {
                if (null != chNode.Attributes)
                {
                    configuredSites[idx].VhaSiteMoniker = chNode.Attributes["SiteMoniker"].Value;
                    configuredSites[idx].VistaProperties = chNode.Attributes["VistaDetails"].Value;
                }
                idx++;
            }
            return configuredSites;
        }




    }
}
