dotnet
{
    assembly("mscorlib")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.DateTime";"DateTime")
        {
        }

        type("System.IO.MemoryStream";"MemoryStream")
        {
        }

        type("System.IO.StreamReader";"StreamReader")
        {
        }

        type("System.Text.Encoding";"Encoding")
        {
        }

        type("System.IO.StreamWriter";"StreamWriter")
        {
        }

        type("System.Convert";"Convert")
        {
        }

        type("System.Array";"Array")
        {
        }

        type("System.Environment";"Environment")
        {
        }

        type("System.Text.UTF8Encoding";"UTF8Encoding")
        {
        }

        type("System.Exception";"Exception")
        {
        }
    }

    assembly("System")
    {
        Version='2.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Net.HttpWebRequest";"HttpWebRequest")
        {
        }

        type("System.Net.WebHeaderCollection";"WebHeaderCollection")
        {
        }

        type("System.Uri";"Uri")
        {
        }

        type("System.Net.WebResponse";"WebResponse")
        {
        }

        type("System.Net.WebException";"WebException")
        {
        }

        type("System.Net.WebExceptionStatus";"WebExceptionStatus")
        {
        }
    }

    assembly("System.Xml")
    {
        Version='2.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Xml.XmlDocument";"XmlDocument")
        {
        }

        type("System.Xml.XmlNode";"XmlNode")
        {
        }
    }

    assembly("Newtonsoft.Json")
    {
        Version='6.0.0.0';
        Culture='neutral';
        PublicKeyToken='30ad4fe6b2a6aeed';

        type("Newtonsoft.Json.Linq.JArray";"JArray")
        {
        }

        type("Newtonsoft.Json.JsonConvert";"JsonConvert")
        {
        }

        type("Newtonsoft.Json.Linq.JToken";"JToken")
        {
        }

        type("Newtonsoft.Json.Linq.JObject";"JObject")
        {
        }
    }

    assembly("")
    {
        type("";"")
        {
        }
    }

    assembly("System.Web")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b03f5f7f11d50a3a';

        type("System.Web.HttpUtility";"HttpUtility")
        {
        }
    }

}
