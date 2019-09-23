codeunit 37072302 "AJ Web Shipstation Mgmt."
{
    trigger OnRun()
    var
        AJWebServParameters: Record "AJ Web Service Parameters" temporary;
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        Txt: text;
    begin
        Txt := '{"orderId": 3767637,"carrierCode": "fedex","serviceCode": "fedex_2day","packageCode": "package","confirmation": "none","shipDate": "2019-09-19","weight": {"value": 1,"units": "value"},"dimensions": {"units": "units","length": 1,"width": 1,"height": 1},"insuranceOptions": null,"internationalOptions": null,"advancedOptions": {"warehouseId": "0","nonMachinable": false,"saturdayDelivery": false,"containsAlcohol": false,"customField1": "101018","customField2": null,"customField3": null}}';

        AJWebServParameters.SetRequestContentasTxt(Txt);
        AJWebServParameters.URI := 'https://ssapi.shipstation.com/orders/createlabelfororder';
        AJWebServParameters.Method := AJWebServParameters.Method::post;
        AJWebServParameters.UserName := 'ccb2a0af002b4cb7affc046461a4334d';
        AJWebServParameters.Password := 'c434f11bc78340ca9944f57a19ea30d5';
        AJWebServParameters.ContentType := 'application/json';

        AJWebServiceBase.CallWebService(AJWebServParameters);

        Message(AJWebServParameters.GetResponseContentAsText());
    end;

    procedure GetOrderLabel(AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebServParameters: Record "AJ Web Service Parameters" temporary;
        AJWebService: Record "AJ Web Service";
    begin
    end;

    local procedure InitParameters(Parameters: Record "AJ Web Service Parameters" temporary; AJWebService: Record "AJ Web Service")
    var
    begin
    end;

    local procedure Http_TryGetResponse(var HttpWebRequest: HttpRequestMessage; var HttpWebResponse: HttpResponseMessage): Boolean
    var
        HttpWebClient: HttpClient;
    begin
        exit(HttpWebClient.Send(HttpWebRequest, HttpWebResponse));
    end;

    procedure GetShipAgentInfo(AJWebService: Record "AJ Web Service")
    var
        AJWebServParameters: Record "AJ Web Service Parameters" temporary;
        AJWebCarrier: Record "AJ Web Carrier";
        AJWebCarrierService: Record "AJ Web Carrier Service";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
        AjWebJsonHelper: Codeunit "AJ Web Json Helper";
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        HttpWebRequest: HttpRequestMessage;
        HttpWebContentHeaders: HttpHeaders;
        HttpWebHeaders: HttpHeaders;
        HttpWebContent: HttpContent;
        HttpWebResponse: HttpResponseMessage;
        JArray: JsonArray;
        ValueJToken: JsonToken;
        JObject: JsonObject;
        JToken: JsonToken;
        i: Integer;
        Txt: text;
        Uri: Text;
    begin
        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        //Uri := AJWebService."API Endpoint Domain" + 'carriers';
        //HttpWebRequest.SetRequestUri(Uri);
        //HttpWebRequest.Method := 'GET';
        //HttpWebRequest.GetHeaders(HttpWebHeaders);
        //HttpWebHeaders.Remove('authorization');
        //HttpWebHeaders.Add('authorization', 'Basic ' + AJWebService."API Encoded String");
        AJWebServParameters.URI := AJWebService."API Endpoint Domain" + 'carriers';
        AJWebServParameters.Method := AJWebServParameters.Method::get;
        AJWebServParameters.UserName := AJWebService."API User ID (Key)";
        AJWebServParameters.Password := AJWebService."API Password (Secret)";

        //IF not Http_TryGetResponse(HttpWebRequest, HttpWebResponse) then
        //  Error('Error with request');
        //if not HttpWebResponse.IsSuccessStatusCode then
        //    error('The web service returned an error message:\\' +
        //        'Status code: %1\' +
        //        'Description: %2',
        //        HttpWebResponse.HttpStatusCode,
        //        HttpWebResponse.ReasonPhrase);
        //HttpWebResponse.Content.ReadAs(Txt);

        AJWebServiceBase.CallWebService(AJWebServParameters);
        Txt := AJWebServParameters.GetResponseContentAsText();

        AjWebJsonHelper.JsonReadArrayFrom(JArray, Txt);

        for i := 1 to JArray.Count do begin
            JObject := AjWebJsonHelper.GetJsonObjFromArray(JArray, i - 1);

            //JArray.Get(i - 1, JToken);
            //JObject := JToken.AsObject();

            if JObject.Get('code', ValueJToken) then begin
                AJWebCarrier."Web Service Code" := AJWebService.Code;
                AJWebCarrier.Code := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrier.Code));
                if AJWebCarrier.Find then;
                if JObject.Get('name', ValueJToken) then
                    AJWebCarrier.Name := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrier.Name));
                if JObject.Get('accountNumber', ValueJToken) then
                    AJWebCarrier."Account No." := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrier."Account No."));
                if JObject.Get('requiresFundedAccount', ValueJToken) then
                    AJWebCarrier."Requires Funded Account" := ValueJToken.AsValue.AsBoolean;
                if JObject.Get('balance', ValueJToken) then
                    AJWebCarrier.Balance := ValueJToken.AsValue.AsDecimal;
                if not AJWebCarrier.Insert then
                    AJWebCarrier.Modify;
            end;
        end;

        AJWebCarrier.SetRange("Web Service Code", AJWebService.Code);
        if AJWebCarrier.FindFirst then
            repeat
                Uri := AJWebService."API Endpoint Domain" + 'carriers/listpackages?carrierCode=' + AJWebCarrier.Code;

                HttpWebRequest.SetRequestUri(Uri);
                HttpWebRequest.Method := 'GET';
                HttpWebRequest.GetHeaders(HttpWebHeaders);

                HttpWebHeaders.Remove('authorization');
                HttpWebHeaders.Add('authorization', 'Basic ' + AJWebService."API Encoded String");

                IF not Http_TryGetResponse(HttpWebRequest, HttpWebResponse) then
                    Error('Error with request');

                if not HttpWebResponse.IsSuccessStatusCode then
                    error('The web service returned an error message:\\' +
                        'Status code: %1\' +
                        'Description: %2',
                        HttpWebResponse.HttpStatusCode,
                        HttpWebResponse.ReasonPhrase);

                HttpWebResponse.Content.ReadAs(Txt);

                if not JArray.ReadFrom(Txt) then
                    Error('Bad response');

                for i := 1 to JArray.Count do begin
                    JArray.Get(i - 1, JToken);
                    JObject := JToken.AsObject();

                    if JObject.Get('code', ValueJToken) then begin
                        AJWebCarrierPackageType."Web Service Code" := AJWebService.Code;
                        AJWebCarrierPackageType."Package Code" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrierPackageType."Package Code"));
                        if JObject.Get('carrierCode', ValueJToken) then
                            AJWebCarrierPackageType."Web Carrier Code" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrierPackageType."Web Carrier Code"));

                        if AJWebCarrierPackageType.Find then;
                        if JObject.Get('name', ValueJToken) then
                            AJWebCarrierPackageType."Package Name" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrierPackageType."Package Name"));
                        if JObject.Get('domestic', ValueJToken) then
                            AJWebCarrierPackageType.Domestic := ValueJToken.AsValue.AsBoolean;
                        if JObject.Get('international', ValueJToken) then
                            AJWebCarrierPackageType.International := ValueJToken.AsValue.AsBoolean;
                        if not AJWebCarrierPackageType.Insert then
                            AJWebCarrierPackageType.Modify;
                    end;
                end;

                Uri := AJWebService."API Endpoint Domain" + 'carriers/listservices?carrierCode=' + AJWebCarrier.Code;
                HttpWebRequest.SetRequestUri(Uri);
                HttpWebRequest.Method := 'GET';
                HttpWebRequest.GetHeaders(HttpWebHeaders);
                HttpWebHeaders.Remove('authorization');
                HttpWebHeaders.Add('authorization', 'Basic ' + AJWebService."API Encoded String");

                IF not Http_TryGetResponse(HttpWebRequest, HttpWebResponse) then
                    Error('Error with request');

                if not HttpWebResponse.IsSuccessStatusCode then
                    error('The web service returned an error message:\\' +
                        'Status code: %1\' +
                        'Description: %2',
                        HttpWebResponse.HttpStatusCode,
                        HttpWebResponse.ReasonPhrase);

                HttpWebResponse.Content.ReadAs(Txt);

                if not JArray.ReadFrom(Txt) then
                    Error('Bad response');

                for i := 1 to JArray.Count do begin
                    JArray.Get(i - 1, JToken);
                    JObject := JToken.AsObject();

                    if JObject.Get('code', ValueJToken) then begin
                        AJWebCarrierService."Web Service Code" := AJWebService.Code;
                        AJWebCarrierService."Service  Code" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrierService."Web Carrier Code"));
                        if JObject.Get('carrierCode', ValueJToken) then
                            AJWebCarrierService."Web Carrier Code" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrierService."Web Carrier Code"));

                        if AJWebCarrierService.Find then;
                        if JObject.Get('name', ValueJToken) then
                            AJWebCarrierService.Name := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebCarrierService.Name));
                        if JObject.Get('domestic', ValueJToken) then
                            AJWebCarrierService.Domestic := ValueJToken.AsValue.AsBoolean();
                        if JObject.Get('international', ValueJToken) then
                            AJWebCarrierService.International := ValueJToken.AsValue.AsBoolean();
                        if not AJWebCarrierService.Insert then
                            AJWebCarrierService.Modify;
                    end;
                end;
            until AJWebCarrier.Next = 0;
    end;

}