dotnet
{
    assembly("mscorlib")
    {
        Version='4.0.0.0';
        Culture='neutral';
        PublicKeyToken='b77a5c561934e089';

        type("System.Convert";"Convert")
        {
        }

        type("System.Text.Encoding";"Encoding")
        {
        }

        type("System.Text.UTF8Encoding";"UTF8Encoding")
        {
        }

        type("System.IO.MemoryStream";"MemoryStream")
        {
        }

        type("System.IO.StreamWriter";"StreamWriter")
        {
        }

        type("System.DateTime";"DateTime")
        {
        }

        type("System.IO.StreamReader";"StreamReader")
        {
        }

        type("System.Array";"Array")
        {
        }

        type("System.Environment";"Environment")
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

        type("System.Uri";"Uri")
        {
        }

        type("System.Net.HttpWebRequest";"HttpWebRequest")
        {
        }

        type("System.Net.WebHeaderCollection";"WebHeaderCollection")
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

    assembly("Newtonsoft.Json")
    {
        Version='6.0.0.0';
        Culture='neutral';
        PublicKeyToken='30ad4fe6b2a6aeed';

        type("Newtonsoft.Json.Linq.JObject";"JObject")
        {
        }

        type("Newtonsoft.Json.Linq.JToken";"JToken")
        {
        }

        type("Newtonsoft.Json.Linq.JArray";"JArray")
        {
        }

        type("Newtonsoft.Json.JsonConvert";"JsonConvert")
        {
        }
    }

    assembly("PdfSharp")
    {
        Version='1.32.2608.0';
        Culture='neutral';
        PublicKeyToken='f94615aa0424f9eb';

        type("PdfSharp.Pdf.PdfDocument";"PdfDocument")
        {
        }

        type("PdfSharp.Pdf.PdfPage";"PdfPage")
        {
        }

        type("PdfSharp.Pdf.IO.PdfReader";"PdfReader")
        {
        }

        type("PdfSharp.Pdf.IO.PdfDocumentOpenMode";"PdfDocumentOpenMode")
        {
        }

        type("PdfSharp.Drawing.XGraphics";"XGraphics")
        {
        }

        type("PdfSharp.Drawing.XPdfForm";"XPdfForm")
        {
        }

        type("PdfSharp.Drawing.XRect";"XRect")
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
