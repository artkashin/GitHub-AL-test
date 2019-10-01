dotnet
{
    assembly("mscorlib")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Text.UTF8Encoding"; "UTF8Encoding")
        {
        }

        type("System.Environment"; "Environment")
        {
        }

    }

    assembly("System")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b77a5c561934e089';

        type("System.Net.WebHeaderCollection"; "WebHeaderCollection")
        {
        }

        type("System.Net.WebResponse"; "WebResponse")
        {
        }

        type("System.Net.WebExceptionStatus"; "WebExceptionStatus")
        {
        }
    }

    assembly("System.Web")
    {
        Version = '4.0.0.0';
        Culture = 'neutral';
        PublicKeyToken = 'b03f5f7f11d50a3a';

        type("System.Web.HttpUtility"; "HttpUtility")
        {
        }
    }

}
