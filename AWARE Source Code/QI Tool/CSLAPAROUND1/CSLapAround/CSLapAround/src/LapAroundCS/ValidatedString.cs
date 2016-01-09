using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace LapAroundCS.Application
{
    class ValidatedString
    {
        private string stringvalue = "";
        private bool stringisValid = true;

        public static ValidatedString operator +(ValidatedString s1, ValidatedString s2)
        {
            string concatString = s1.Value + s2.Value;
            return new ValidatedString(concatString);
        }

        public ValidatedString(string value)
        {
            Value = value;
        }

        public override string ToString()
        {
            return Value.ToString();
        }

        public string Value
        {
            get
            {
                return stringvalue;
            }
            set
            {
                stringvalue = value;
                stringisValid = Validate();
            }
        }

        private bool IsValid
        {
            get
            {
                return Validate();
            }
        }

        private bool Validate()
        {
            if (stringvalue.Length <= 255)
                return true;
            else
                return false;
        }
    }
}
