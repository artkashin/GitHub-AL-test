codeunit 50100 "AJ Web Order Service Mgmt New"
{
    trigger OnRun()
    var
        HttpWebRequest: HttpRequestMessage;
        HttpWebContentHeaders: HttpHeaders;
        HttpWebHeaders: HttpHeaders;
        HttpWebClient: HttpClient;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        Txt: text;
        Uri: Text;
    begin
        Uri := 'https://ssapi.shipstation.com/orders/createlabelfororder';
        Txt := '{"orderId": 3767637,"carrierCode": "fedex","serviceCode": "fedex_2day","packageCode": "package","confirmation": "none","shipDate": "2019-09-19","weight": {"value": 1,"units": "value"},"dimensions": {"units": "units","length": 1,"width": 1,"height": 1},"insuranceOptions": null,"internationalOptions": null,"advancedOptions": {"warehouseId": "0","nonMachinable": false,"saturdayDelivery": false,"containsAlcohol": false,"customField1": "101018","customField2": null,"customField3": null}}';

        HttpWebRequest.SetRequestUri(Uri);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.GetHeaders(HttpWebHeaders);

        HttpWebContent.GetHeaders(HttpWebContentHeaders);

        HttpWebHeaders.Remove('authorization');
        HttpWebHeaders.Add('authorization', 'Basic ' + 'Y2NiMmEwYWYwMDJiNGNiN2FmZmMwNDY0NjFhNDMzNGQ6YzQzNGYxMWJjNzgzNDBjYTk5NDRmNTdhMTllYTMwZDU=');


        HttpWebContent.WriteFrom(Txt);

        HttpWebContentHeaders.Remove('Content-Type');
        HttpWebContentHeaders.Add('Content-Type', 'application/json');
        HttpWebRequest.Content(HttpWebContent);

        IF not Http_TryGetResponse(HttpWebRequest, HttpWebResponse) then
            Error('Error with request');
        HttpWebContent := HttpWebResponse.Content();
        HttpWebContent.ReadAs(Txt);
        Message(Txt);
    end;

    local procedure Http_TryGetResponse(var HttpWebRequest: HttpRequestMessage; var HttpWebResponse: HttpResponseMessage): Boolean
    var
        HttpWebClient: HttpClient;
    begin
        exit(HttpWebClient.Send(HttpWebRequest, HttpWebResponse));
    end;
}