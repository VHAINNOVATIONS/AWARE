/* This set of classes handles all the work for the custom configuration section
 * for VhaSites in the applications config file.
 * 
 * DO NOT MODIFY UNLESS YOU YOU UNDERSTAND WHAT THESE CLASSES DO
 * */

using System.Configuration;

namespace AWARE_SQL_Transporter
{
    public class VhaSites : ConfigurationElementCollection
    {
        public VhaSite this[int index]
        {
            get
            {
                return base.BaseGet(index) as VhaSite;
            }
            set
            {
                if (base.BaseGet(index) != null)
                {
                    base.BaseRemoveAt(index);
                }
                this.BaseAdd(index, value);
            }
        }

        public new VhaSite this[string responseString]
        {
            get { return (VhaSite)BaseGet(responseString); }
            set
            {
                if (BaseGet(responseString) != null)
                {
                    BaseRemoveAt(BaseIndexOf(BaseGet(responseString)));
                }
                BaseAdd(value);
            }
        }

        protected override System.Configuration.ConfigurationElement CreateNewElement()
        {
            return new VhaSite();
        }

        protected override object GetElementKey(System.Configuration.ConfigurationElement element)
        {
            return ((VhaSite)element).Name;
        }
    }

    public class VhaSite : ConfigurationElement
    {
        [ConfigurationProperty("SiteMoniker", IsRequired = true)]
        public string Name
        {
            get
            {
                return this["SiteMoniker"] as string;
            }
        }

        [ConfigurationProperty("VistaDetails", IsRequired = true)]
        public string Code
        {
            get
            {
                return this["VistaDetails"] as string;
            }
        }
    }

    public class RegisterVhaSitesConfig
        : ConfigurationSection
    {

        public static RegisterVhaSitesConfig GetConfig()
        {
            return (RegisterVhaSitesConfig)System.Configuration.ConfigurationManager.GetSection("VhaSites") ?? new RegisterVhaSitesConfig();
        }

        [System.Configuration.ConfigurationProperty("VhaSites")]
        [ConfigurationCollection(typeof(VhaSites), AddItemName = "VhaSite")]
        public VhaSite VhaSite
        {
            get
            {
                object o = this["VhaSites"];
                return o as VhaSite;
            }
        }

    }
}
