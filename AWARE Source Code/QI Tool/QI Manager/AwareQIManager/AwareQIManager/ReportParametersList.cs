using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.Reporting.WebForms;
using AwareQIManager.Reportingservice2010;

namespace AwareQIManager
{
    public class ReportParametersList : List<ReportParameter>, ICloneable
    {
        public object Clone()
        {
            ReportParametersList paramsList = new ReportParametersList();

            for (int i = 0; i < Count; i++)
            {
                paramsList.Add(this.Clone() as ReportParameter);

                //m_ParamList.Add(new ReportParameter(parameter, value, false));
                int a = 9;
            }

            return (paramsList);
        }
    }

    static class Extensions
    {
        public static IList<T> Clone<T>(this IList<T> listToClone) where T : ICloneable
        {
            return listToClone.Select(item => (T)item.Clone()).ToList();
        }
    }
}

