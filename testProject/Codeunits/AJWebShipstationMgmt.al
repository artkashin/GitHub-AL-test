codeunit 37072302 "AJ Web Shipstation Mgmt."
{
    trigger OnRun()
    var
        AJWebServParameters: Record "AJ Web Service Parameters" temporary;
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        AJWebService: Record "AJ Web Service";
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
        Base64Convert: Codeunit Base64Convert;
        ValueJToken: JsonToken;
        JObject: JsonObject;
        JToken: JsonToken;
        InStr: InStream;
        OutStr: OutStream;
        Txt: Text;
        ResponseTxt: Text;
        Uri: Text;
        LabelPdf: Text;
    begin

        if not AJWebService.FindFirst() then begin
            InitRecords();
        end;

        Txt := '{"orderId": 3767637,"carrierCode": "fedex","serviceCode": "fedex_2day","packageCode": "package","confirmation": "none","shipDate": "2019-09-26","weight": {"value": 1,"units": "value"},"dimensions": {"units": "units","length": 1,"width": 1,"height": 1},"insuranceOptions": null,"internationalOptions": null,"advancedOptions": {"warehouseId": "0","nonMachinable": false,"saturdayDelivery": false,"containsAlcohol": false,"customField1": "101018","customField2": null,"customField3": null}}';
        Uri := AJWebService."API Endpoint Domain" + 'orders/createlabelfororder';
        Txt := AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt);

        JObject.ReadFrom(Txt);
        AJWebOrderHeader.FindFirst();
        if JObject.Contains('labelData') then begin
            LabelPdf := AJWebJsonHelper.GetJsonValueAsText(JObject, 'labelData');
            AJWebOrderHeader."Shipping Agent Label".CreateOutStream(OutStr);
            Base64Convert.FromBase64StringToStream(LabelPdf, OutStr);

            AJWebOrderHeader."Carier Shipping Charge" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'shipmentCost');
            AJWebOrderHeader."Carier Tracking Number" := AJWebJsonHelper.GetJsonValueAsText(JObject, 'trackingNumber');//,MaxStrLen(AJWebOrderHeader."Carier Tracking Number"));
            AJWebOrderHeader."Carier Insurance Cost" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'insuranceCost');
            AJWebOrderHeader."Web Service Shipment ID" := AJWebJsonHelper.GetJsonValueAsText(JObject, 'shipmentId');//,MaxStrLen(AJWebOrderHeader."Web Service Shipment ID"));
            AJWebOrderHeader."Labels Created" := true;
            AJWebOrderHeader."Labels Printed" := false;
            AJWebOrderHeader.Modify;
        end;
    end;

    procedure GetLabelForOrder(AJWebService: Record "AJ Web Service")
    var
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        Txt: Text;
        Uri: Text;
    begin
        Txt := '{"orderId": 3767637,"carrierCode": "fedex","serviceCode": "fedex_2day","packageCode": "package","confirmation": "none","shipDate": "2019-09-26","weight": {"value": 1,"units": "value"},"dimensions": {"units": "units","length": 1,"width": 1,"height": 1},"insuranceOptions": null,"internationalOptions": null,"advancedOptions": {"warehouseId": "0","nonMachinable": false,"saturdayDelivery": false,"containsAlcohol": false,"customField1": "101018","customField2": null,"customField3": null}}';
        Uri := 'https://ssapi.shipstation.com/orders/createlabelfororder';
        Message(AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt));
    end;

    procedure InitRecords()
    var
        AJWebService: Record "AJ Web Service";
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebContans: Record "AJ Web Service Constants";
    begin
        if not AJWebService.FindFirst() then begin
            AJWebService.Init();
            AJWebService.Code := 'TEST MBS';
            AJWebService.Description := 'Shipstation';
            AJWebService."API Endpoint Domain" := 'https://ssapi.shipstation.com/';
            AJWebService.Validate("API User ID (Key)", 'ccb2a0af002b4cb7affc046461a4334d');
            AJWebService.Validate("API Password (Secret)", 'c434f11bc78340ca9944f57a19ea30d5');
            AJWebService.Insert();
        end;

        AJWebContans.SetRange("Web Order Service Code", AJWebService.Code);
        if not AJWebContans.FindFirst() then begin
            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Confirmation;
            AJWebContans."Option Value" := 'adult_signature';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Confirmation;
            AJWebContans."Option Value" := 'delivery';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Confirmation;
            AJWebContans."Option Value" := 'none';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Confirmation;
            AJWebContans."Option Value" := 'signature';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Weight;
            AJWebContans."Option Value" := 'units';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Weight;
            AJWebContans."Option Value" := 'value';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Weight;
            AJWebContans."Option Value" := 'WeightUnits';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Dimension;
            AJWebContans."Option Value" := 'height';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Dimension;
            AJWebContans."Option Value" := 'length';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Dimension;
            AJWebContans."Option Value" := 'units';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Dimension;
            AJWebContans."Option Value" := 'width';
            AJWebContans.Insert();
            AJWebContans.Init();

            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Insurance;
            AJWebContans."Option Value" := 'insuredValue';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Insurance;
            AJWebContans."Option Value" := 'insureShipment';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Insurance;
            AJWebContans."Option Value" := 'provider';
            AJWebContans.Insert();

            AJWebContans.Init();
            AJWebContans."Web Order Service Code" := AJWebService.Code;
            AJWebContans.Type := AJWebContans.Type::Option;
            AJWebContans."Option Value" := 'nonDelivery';
            AJWebContans.Insert();
        end;

        if not AJWebOrderHeader.FindFirst() then begin
            AJWebOrderHeader.Init();
            AJWebOrderHeader."Web Order No." := 'AW-000002';
            AJWebOrderHeader."Web Service Code" := AJWebService.Code;
            AJWebOrderHeader."Shipping Web Service Order No." := '3767637';
            AJWebOrderHeader."Order DateTime" := CreateDateTime(20190926D, 0T);
            AJWebOrderHeader."Web Service Shipment ID" := '975752';
            AJWebOrderHeader."Web Service PO Number" := '101018';
            AJWebOrderHeader."Shipping Web Service Code" := AJWebService.Code;
            AJWebOrderHeader."Shp. Product Dimension Unit" := 'units';
            AJWebOrderHeader."Shp. Product Weight Unit" := 'value';
            AJWebOrderHeader."Shipping Carrier Code" := 'fedex';
            AJWebOrderHeader."Shipping Package Type" := 'package';
            AJWebOrderHeader."Shipping Carrier Service" := 'fedex_2day';
            AJWebOrderHeader."Bill-To Customer Name" := 'New Concepts Furniture';
            AJWebOrderHeader."Bill-To Customer Zip" := '31772';
            AJWebOrderHeader."Bill-To Customer Country" := 'US';
            AJWebOrderHeader."Bill-To Customer State" := 'GA';
            AJWebOrderHeader."Bill-To Customer City" := 'Atlanta';
            AJWebOrderHeader."Bill-To Customer Address 1" := '705 West Peachtree Street';
            AJWebOrderHeader."Bill-To Company" := 'New Concepts Furniture';
            AJWebOrderHeader."Ship-To Customer Name" := 'New Concepts Furniture';
            AJWebOrderHeader."Ship-To Customer Zip" := '31772';
            AJWebOrderHeader."Ship-To Customer Country" := 'US';
            AJWebOrderHeader."Ship-To Customer State" := 'GA';
            AJWebOrderHeader."Ship-To Customer City" := 'Atlanta';
            AJWebOrderHeader."Ship-To Customer Address 1" := '705 West Peachtree Street';
            AJWebOrderHeader."Ship-To Company" := 'New Concepts Furniture';
            AJWebOrderHeader."Ship-To E-mail" := 'JR@contoso.com;JR@contoso.com';
            AJWebOrderHeader."Merchandise Amount" := 1083.41;
            AJWebOrderHeader."Shipping Options" := 'nonDelivery';
            AJWebOrderHeader."Shipping Delivery Confirm" := 'none';
            AJWebOrderHeader."Ship Date" := 20190926D;
            AJWebOrderHeader."Custom Field 1" := 'ID: 01454545 DOC: 101018';
            AJWebOrderHeader."Bill-to Type" := AJWebOrderHeader."Bill-to Type"::my_account;
            AJWebOrderHeader."Acknowlegement Sent" := true;
            AJWebOrderHeader."Carier Shipping Charge" := 21.66;
            AJWebOrderHeader."Carier Tracking Number" := '789828713420';
            AJWebOrderHeader."Total Quantity" := 6;
            AJWebOrderHeader.Insert();
        end;
    end;

    local procedure Http_TryGetResponse(var HttpWebRequest: HttpRequestMessage; var HttpWebResponse: HttpResponseMessage): Boolean
    var
        HttpWebClient: HttpClient;
    begin
        exit(HttpWebClient.Send(HttpWebRequest, HttpWebResponse));
    end;

    procedure GetShipAgentInfo(AJWebService: Record "AJ Web Service")
    var
        AJWebCarrier: Record "AJ Web Carrier";
        AJWebCarrierService: Record "AJ Web Carrier Service";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
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
        Txt: Text;
        Uri: Text;
    begin
        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        Uri := AJWebService."API Endpoint Domain" + 'carriers';
        Txt := AJWebServiceBase.CallWebService(AJWebService, Uri, 'GET', '', '');

        if not JArray.ReadFrom(Txt) then
            Error('Bad response');

        for i := 1 to JArray.Count do begin
            JArray.Get(i - 1, JToken);
            JObject := JToken.AsObject();

            if JObject.Contains('code') then begin
                AJWebCarrier."Web Service Code" := AJWebService.Code;
                with AJWebJsonHelper do begin
                    AJWebCarrier.Code := CopyStr(GetJsonValueAsText(JObject, 'code'), 1, MaxStrLen(AJWebCarrier.Code));
                    if AJWebCarrier.Find then;
                    if JObject.Contains('name') then
                        AJWebCarrier.Name := CopyStr(GetJsonValueAsText(JObject, 'name'), 1, MaxStrLen(AJWebCarrier.Name));
                    if JObject.Contains('accountNumber') then
                        AJWebCarrier."Account No." := CopyStr(GetJsonValueAsText(JObject, 'accountNumber'), 1, MaxStrLen(AJWebCarrier."Account No."));
                    if JObject.Contains('requiresFundedAccount') then
                        AJWebCarrier."Requires Funded Account" := GetJsonValueAsBool(JObject, 'requiresFundedAccount');
                    if JObject.Contains('balance') then
                        AJWebCarrier.Balance := GetJsonValueAsDec(JObject, 'balance');
                    if not AJWebCarrier.Insert then
                        AJWebCarrier.Modify;
                end;
            end;
        end;

        AJWebCarrier.SetRange("Web Service Code", AJWebService.Code);
        if AJWebCarrier.FindFirst then
            repeat
                Uri := AJWebService."API Endpoint Domain" + 'carriers/listpackages?carrierCode=' + AJWebCarrier.Code;
                Txt := AJWebServiceBase.CallWebService(AJWebService, Uri, 'GET', '', '');

                if not JArray.ReadFrom(Txt) then
                    Error('Bad response');

                for i := 1 to JArray.Count do begin
                    JArray.Get(i - 1, JToken);
                    JObject := JToken.AsObject();

                    if JObject.Contains('code') then begin
                        AJWebCarrierPackageType."Web Service Code" := AJWebService.Code;
                        with AJWebJsonHelper do begin
                            AJWebCarrierPackageType."Package Code" := CopyStr(GetJsonValueAsText(JObject, 'code'), 1, MaxStrLen(AJWebCarrierPackageType."Package Code"));
                            if JObject.Contains('carrierCode') then
                                AJWebCarrierPackageType."Web Carrier Code" := CopyStr(GetJsonValueAsText(JObject, 'carrierCode'), 1, MaxStrLen(AJWebCarrierPackageType."Web Carrier Code"));
                            if AJWebCarrierPackageType.Find then;
                            if JObject.Contains('name') then
                                AJWebCarrierPackageType."Package Name" := CopyStr(GetJsonValueAsText(JObject, 'name'), 1, MaxStrLen(AJWebCarrierPackageType."Package Name"));
                            if JObject.Contains('domestic') then
                                AJWebCarrierPackageType.Domestic := GetJsonValueAsBool(JObject, 'domestic');
                            if JObject.Contains('international') then
                                AJWebCarrierPackageType.International := GetJsonValueAsBool(JObject, 'international');
                            if not AJWebCarrierPackageType.Insert then
                                AJWebCarrierPackageType.Modify;
                        end;
                    end;
                end;

                Uri := AJWebService."API Endpoint Domain" + 'carriers/listservices?carrierCode=' + AJWebCarrier.Code;
                Txt := AJWebServiceBase.CallWebService(AJWebService, Uri, 'GET', '', '');

                if not JArray.ReadFrom(Txt) then
                    Error('Bad response');

                for i := 1 to JArray.Count do begin
                    JArray.Get(i - 1, JToken);
                    JObject := JToken.AsObject();

                    if JObject.Contains('code') then begin
                        AJWebCarrierService."Web Service Code" := AJWebService.Code;
                        with AJWebJsonHelper do begin
                            AJWebCarrierService."Service  Code" := CopyStr(GetJsonValueAsText(JObject, 'code'), 1, MaxStrLen(AJWebCarrierService."Web Carrier Code"));
                            if JObject.Contains('carrierCode') then
                                AJWebCarrierService."Web Carrier Code" := CopyStr(GetJsonValueAsText(JObject, 'carrierCode'), 1, MaxStrLen(AJWebCarrierService."Web Carrier Code"));
                            if AJWebCarrierService.Find then;
                            if JObject.Contains('name') then
                                AJWebCarrierService.Name := CopyStr(GetJsonValueAsText(JObject, 'name'), 1, MaxStrLen(AJWebCarrierService.Name));
                            if JObject.Contains('domestic') then
                                AJWebCarrierService.Domestic := GetJsonValueAsBool(JObject, 'domestic');
                            if JObject.Contains('international') then
                                AJWebCarrierService.International := GetJsonValueAsBool(JObject, 'international');
                            if not AJWebCarrierService.Insert then
                                AJWebCarrierService.Modify;
                        end;
                    end;
                end;
            until AJWebCarrier.Next = 0;
    end;

    procedure ShipStation_GetMarketlaces(AJWebService: Record "AJ Web Service")
    var
        AJWebMarketplace: Record "AJ Web Marketplace (Mailbox)";
        HttpWebRequest: HttpRequestMessage;
        HttpWebHeaders: HttpHeaders;
        HttpWebResponse: HttpResponseMessage;
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        Uri: Text;
        Txt: Text;
        ErrorText: Text;
        JArray: JsonArray;
        JToken: JsonToken;
        JObject: JsonObject;
        ValueJToken: JsonToken;
        i: Integer;
    begin
        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");
        Uri := AJWebService."API Endpoint Domain" + 'stores/marketplaces';
        Txt := AJWebServiceBase.CallWebService(AJWebService, Uri, 'GET', '', '');

        if not JArray.ReadFrom(Txt) then
            Error('Bad response');

        for i := 1 to JArray.Count do begin
            JArray.Get(i - 1, JToken);
            JObject := JToken.AsObject();
            if JObject.Contains('marketplaceId') then begin
                AJWebMarketplace."Web Service Code" := AJWebService.Code;
                with AJWebJsonHelper do begin
                    AJWebMarketplace.Code := CopyStr(GetJsonValueAsText(JObject, 'marketplaceId'), 1, MaxStrLen(AJWebMarketplace.Code));
                    if AJWebMarketplace.Find then;
                    if JObject.Get('name', ValueJToken) then
                        AJWebMarketplace.Description := CopyStr(GetJsonValueAsText(JObject, 'name'), 1, MaxStrLen(AJWebMarketplace.Description));
                    if JObject.Get('canRefresh', ValueJToken) then
                        AJWebMarketplace."Can Refresh" := ValueJToken.AsValue.AsBoolean();
                    if JObject.Get('supportsCustomMappings', ValueJToken) then
                        AJWebMarketplace."Supports Custom Mappings" := GetJsonValueAsBool(JObject, 'supportsCustomMappings');
                    if JObject.Get('supportsCustomStatuses', ValueJToken) then
                        AJWebMarketplace."Supports Custom Statuses" := GetJsonValueAsBool(JObject, 'supportsCustomStatuses');
                    if JObject.Get('canConfirmShipments', ValueJToken) then
                        AJWebMarketplace."Can Confirm Shipments" := GetJsonValueAsBool(JObject, 'canConfirmShipments');
                    if not AJWebMarketplace.Insert then
                        AJWebMarketplace.Modify;
                end;
            end;
        end;
        //CheckResponce(HttpWebResponse, AJWebService);
    end;
    /*local procedure CheckResponce(var HttpWebResponse: HttpResponseMessage;var AJWebService: Record "AJ Web Service")
    var
        HttpWebHeaders: HttpHeaders;
    begin
        HttpWebHeaders := HttpWebResponse.Headers;
        if Evaluate(AJWebService."Rate Limit",HttpWebHeaders. .Get('X-Rate-Limit-Limit')) then;
        if Evaluate(AJWebService."Limit Remaining",HttpWebHeaders.Get('X-Rate-Limit-Remaining')) then;
        if Evaluate(AJWebService."Limit Reset",HttpWebHeaders.Get('X-Rate-Limit-Reset')) then;
        AJWebService.Modify;
        if (AJWebService."Limit Remaining" = 0) and (AJWebService."Limit Reset" <> 0) then begin
          Message('Web Service request limit reached. Reset in %1 seconds.',AJWebService."Limit Reset");
          Sleep(1000*AJWebService."Limit Reset");
        end;
    end;
    */
    procedure ShipStation_GetWarehouses(AJWebService: Record "AJ Web Service")
    var
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
        HttpWebRequest: HttpRequestMessage;
        HttpWebHeaders: HttpHeaders;
        HttpWebResponse: HttpResponseMessage;
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
        JArray: JsonArray;
        JToken: JsonToken;
        JObject: JsonObject;
        ValueJToken: JsonToken;
        JObject2: JsonObject;
        Uri: Text;
        Txt: Text;
        ErrorText: Text;
        i: Integer;
    begin
        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        Uri := AJWebService."API Endpoint Domain" + 'warehouses';
        Txt := AJWebServiceBase.CallWebService(AJWebService, Uri, 'GET', '', '');

        if not JArray.ReadFrom(Txt) then
            Error('Bad response');

        for i := 1 to JArray.Count do begin
            JArray.Get(i - 1, JToken);
            JObject := JToken.AsObject();

            with AJWebJsonHelper do begin
                if JObject.Get('warehouseId', ValueJToken) then begin
                    AJWebServiceWarehouse."Web Service Code" := AJWebService.Code;
                    AJWebServiceWarehouse."Warehouse ID" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Warehouse ID"));
                    if AJWebServiceWarehouse.Find then;
                    if JObject.Get('warehouseName', ValueJToken) then
                        AJWebServiceWarehouse.Description := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse.Description));

                    if JObject.Contains('originAddress') then begin
                        JObject.SelectToken('originAddress', JToken);
                        JObject2 := JToken.AsObject();

                        /*
                        my old code
                        if JObject2.Get('name', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Name" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Name"));
                        if JObject2.Get('company', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Company" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Company"));
                        if JObject2.Get('street1', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Address 1" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address 1"));
                        if JObject2.Get('street2', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Address 2" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address 2"));
                        if JObject2.Get('street3', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Address 3" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address 3"));
                        if JObject2.Get('city', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From City" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From City"));
                        if JObject2.Get('state', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From State" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From State"));
                        if JObject2.Get('postalCode', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Zip" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Zip"));
                        if JObject2.Get('country', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Country" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Country"));
                        if JObject2.Get('phone', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Phone" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Phone"));
                        if JObject2.Get('residential', ValueJToken) then
                            AJWebServiceWarehouse."Ship-From Residential" := ValueJToken.AsValue.AsBoolean();
                        if JObject2.Get('addressVerified', ValueJToken) then
                            // problem MBS
                            AJWebServiceWarehouse."Ship-From Address Verified" := CopyStr(GetJsonValueAsText(JObject2, 'addressVerified'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address Verified"));
                        //AJWebServiceWarehouse."Ship-From Address Verified" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address Verified"));
                        */
                        if JObject2.Contains('name') then
                            AJWebServiceWarehouse."Ship-From Name" := CopyStr(GetJsonValueAsText(JObject2, 'name'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Name"));
                        if JObject2.Contains('company') then
                            AJWebServiceWarehouse."Ship-From Company" := CopyStr(GetJsonValueAsText(JObject2, 'company'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Company"));
                        if JObject2.Contains('street1') then
                            AJWebServiceWarehouse."Ship-From Address 1" := CopyStr(GetJsonValueAsText(JObject2, 'street1'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address 1"));
                        if JObject2.Contains('street2') then
                            AJWebServiceWarehouse."Ship-From Address 2" := CopyStr(GetJsonValueAsText(JObject2, 'street2'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address 2"));
                        if JObject2.Contains('street3') then
                            AJWebServiceWarehouse."Ship-From Address 3" := CopyStr(GetJsonValueAsText(JObject2, 'street3'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address 3"));
                        if JObject2.Contains('city') then
                            AJWebServiceWarehouse."Ship-From City" := CopyStr(GetJsonValueAsText(JObject2, 'city'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From City"));
                        if JObject2.Contains('state') then
                            AJWebServiceWarehouse."Ship-From State" := CopyStr(GetJsonValueAsText(JObject2, 'state'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From State"));
                        if JObject2.Contains('postalCode') then
                            AJWebServiceWarehouse."Ship-From Zip" := CopyStr(GetJsonValueAsText(JObject2, 'postalCode'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Zip"));
                        if JObject2.Contains('country') then
                            AJWebServiceWarehouse."Ship-From Country" := CopyStr(GetJsonValueAsText(JObject2, 'country'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Country"));
                        if JObject2.Contains('phone') then
                            AJWebServiceWarehouse."Ship-From Phone" := CopyStr(GetJsonValueAsText(JObject2, 'phone'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Phone"));
                        if JObject2.Contains('residential') then
                            AJWebServiceWarehouse."Ship-From Residential" := GetJsonValueAsBool(JObject2, 'residential');
                        if JObject2.Contains('addressVerified') then
                            AJWebServiceWarehouse."Ship-From Address Verified" := CopyStr(GetJsonValueAsText(JObject2, 'addressVerified'), 1, MaxStrLen(AJWebServiceWarehouse."Ship-From Address Verified"));
                    end;


                    if JObject.Contains('returnAddress') then begin
                        JObject.SelectToken('returnAddress', JToken);
                        JObject2 := JToken.AsObject();

                        if JObject2.Contains('name') then
                            AJWebServiceWarehouse."Return Name" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Name"));
                        if JObject2.Contains('company') then
                            AJWebServiceWarehouse."Return Company" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Company"));
                        if JObject2.Contains('street1') then
                            AJWebServiceWarehouse."Return Address 1" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Address 1"));
                        if JObject2.Contains('street2') then
                            AJWebServiceWarehouse."Return Address 2" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Address 2"));
                        if JObject2.Contains('street3') then
                            AJWebServiceWarehouse."Return Address 3" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Address 3"));
                        if JObject2.Contains('city') then
                            AJWebServiceWarehouse."Return City" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return City"));
                        if JObject2.Contains('state') then
                            AJWebServiceWarehouse."Return State" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return State"));
                        if JObject2.Contains('postalCode') then
                            AJWebServiceWarehouse."Return Zip" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Zip"));
                        if JObject2.Contains('country') then
                            AJWebServiceWarehouse."Return Country" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Country"));
                        if JObject2.Contains('phone') then
                            AJWebServiceWarehouse."Return Phone" := CopyStr(ValueJToken.AsValue.AsText, 1, MaxStrLen(AJWebServiceWarehouse."Return Phone"));
                        if JObject2.Contains('residential') then
                            AJWebServiceWarehouse."Return Residential" := GetJsonValueAsBool(JObject2, 'residential');
                        if JObject2.Contains('addressVerified') then
                            AJWebServiceWarehouse."Return Address Verified" := CopyStr(GetJsonValueAsText(JObject2, 'addressVerified'), 1, MaxStrLen(AJWebServiceWarehouse."Return Address Verified"));
                    end;
                end;

                if JObject.Get('createDate', ValueJToken) then
                    AJWebServiceWarehouse."Created At" := ValueJToken.AsValue.AsDateTime();
                if JObject.Get('isDefault', ValueJToken) then
                    AJWebServiceWarehouse.Default := ValueJToken.AsValue.AsBoolean();

            end;
            if not AJWebServiceWarehouse.Insert then
                AJWebServiceWarehouse.Modify;
        end;
    end;

    procedure ShipStation_SaveLabel(AJWebOrderHeader: Record "AJ Web Order Header")
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Record TempBlob temporary;
        OS: OutStream;
        IS: InStream;
        ToFile: Text;
    begin
        AJWebOrderHeader.Find;
        AJWebOrderHeader.CalcFields("Shipping Agent Label");
        if AJWebOrderHeader."Shipping Agent Label".HasValue then begin
            AJWebOrderHeader."Shipping Agent Label".CreateInStream(IS);
            ToFile := 'LBL-' + AJWebOrderHeader."Web Order No." + '.pdf';
            DownloadFromStream(IS, 'Save label as', 'C:\', 'Adobe Acrobat file(*.pdf)|*.pdf', ToFile);
        end;
    end;
}

/*
local procedure ShipStation_GetOrderLabel(var AJWebOrderHeader: Record "AJ Web Order Header")
var
    AJWebMarketplace: Record "AJ Web Marketplace (Mailbox)";
    HttpWebRequest: HttpRequestMessage;
    HttpWebHeaders: HttpHeaders;
    Uri: Text;
    XMLDoc: DotNet XmlDocument;
    Txt: Text;
    ErrorText: Text;
    JArray: JsonArray;
    JToken: JsonToken;
    JObject: JsonObject;
    i: Integer;
    ValueJToken: JsonToken;
    AJWebService: Record "AJ Web Service";
    AddJObject: JsonObject;
    AJWebOrderLine: Record "AJ Web Order Line";
    AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
    AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
    StreamWriter: DotNet StreamWriter;
    LabelPdf: Text;
    base64Converter: DotNet Convert;
    LabelMemoryStream: DotNet MemoryStream;
    LabelBytes: DotNet Array;
    AJWebCarrierService: Record "AJ Web Carrier Service";
    SkipDefaultDimensions: Boolean;
    SalesHeader: Record "Sales Header";
    AJWebCarrier: Record "AJ Web Carrier";
    ld_test: Decimal;
    Customer: Record Customer;
    Item: Record Item;
    CountryRegion: Record "Country/Region";
    SalesLine: Record "Sales Line";
begin
    SkipDefaultDimensions := true;

    if AJWebOrderHeader."Ship Date" <> Today then begin
        AJWebOrderHeader.Validate("Ship Date", Today);
        AJWebOrderHeader.Modify(false);
    end;

    if (not DoNotSendOrder) and (AJWebOrderHeader."COD Status" = AJWebOrderHeader."COD Status"::" ") then
        if AJWebOrderHeader."Created From Sales Order" or
          (AJWebOrderHeader."Shipping Web Service Code" <> AJWebOrderHeader."Web Service Code")
        then begin
            ShipStation_CreateOrderForWeb(AJWebOrderHeader);
            Commit;

        end;

    if AJWebOrderHeader."Shipping Web Service Order No." = '' then begin
        ShipStation_CreateOrder(AJWebOrderHeader);
        Commit;
    end;

    AJWebOrderHeader.TestField("Shipping Web Service Order No.");

    AJWebService.Get(AJWebOrderHeader."Web Service Code");

    AJWebOrderHeader.TestField("Shipping Carrier Code");
    AJWebOrderHeader.TestField("Shipping Carrier Service");
    AJWebOrderHeader.TestField("Shipping Package Type");
    AJWebOrderHeader.TestField("Shipping Delivery Confirm");

    AJWebService.TestField("API Endpoint Domain");
    AJWebService.TestField("API Encoded String");
    Uri := AJWebService."API Endpoint Domain" + 'orders/createlabelfororder');

    HttpWebRequest := HttpWebRequest.Create(Uri);
    HttpWebRequest.Method := 'POST';
    HttpWebRequest.ContentType := 'application/json';

    HttpWebHeaders := HttpWebRequest.Headers;
    HttpWebHeaders.Add('authorization', 'Basic ' + AJWebService."API Encoded String");

    JObject := JObject.JObject(); //asd
    JSONAddTxtasDec(JObject, 'orderId', AJWebOrderHeader."Shipping Web Service Order No.");
    JSONAddTxt(JObject, 'carrierCode', AJWebOrderHeader."Shipping Carrier Code");
    JSONAddTxt(JObject, 'serviceCode', AJWebOrderHeader."Shipping Carrier Service");
    JSONAddTxt(JObject, 'packageCode', AJWebOrderHeader."Shipping Package Type");
    JSONAddTxt(JObject, 'confirmation', AJWebOrderHeader."Shipping Delivery Confirm");

    if AJWebOrderHeader."Ship Date" = 0D then
        AJWebOrderHeader."Ship Date" := WorkDate;
    JSONAddTxt(JObject, 'shipDate', Format(AJWebOrderHeader."Ship Date", 0, '<Standard Format,9>'));

    if AJWebOrderHeader."Shp. Product Weight" = 0 then begin
        AJWebOrderLine.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
        if AJWebOrderLine.FindFirst then
            repeat
                if AJWebOrderLine.Weight = 0 then begin
                    AJWebCarrierPackageType.Get(AJWebService.Code, AJWebOrderHeader."Shipping Carrier Code", AJWebOrderHeader."Shipping Package Type");
                    AJWebOrderHeader."Shp. Product Weight" := AJWebCarrierPackageType."Def. Weight";
                    AJWebOrderHeader."Shp. Product Weight Unit" := AJWebCarrierPackageType."Def. Weight Unit";
                end else
                    if (AJWebOrderHeader."Shp. Product Weight Unit" = '') then begin
                        AJWebOrderLine.TestField("Weigh Unit");
                        AJWebOrderHeader."Shp. Product Weight" := AJWebOrderLine.Weight;
                        AJWebOrderHeader."Shp. Product Weight Unit" := AJWebOrderLine."Weigh Unit";
                    end else
                        if AJWebOrderHeader."Shp. Product Weight Unit" = AJWebOrderLine."Weigh Unit" then
                            AJWebOrderHeader."Shp. Product Weight" += AJWebOrderLine.Weight
                        else
                            AJWebOrderHeader.TestField("Shp. Product Weight");
            until AJWebOrderLine.Next = 0;
    end;

    AJWebOrderHeader.TestField("Shp. Product Weight");
    AJWebOrderHeader.TestField("Shp. Product Weight Unit");
    AddJObject := AddJObject.JObject();
    JSONAddDec(AddJObject, 'value', AJWebOrderHeader."Shp. Product Weight");
    JSONAddTxt(AddJObject, 'units', AJWebOrderHeader."Shp. Product Weight Unit");
    JSONAddObject(JObject, 'weight', AddJObject);

    if AJWebOrderHeader."Shp. Product Dimension Unit" = '' then
        if not SkipDefaultDimensions then begin
            AJWebCarrierPackageType.Get(AJWebService.Code, AJWebOrderHeader."Shipping Carrier Code", AJWebOrderHeader."Shipping Package Type");
            AJWebOrderHeader."Shp. Product Dimension Unit" := AJWebCarrierPackageType."Def. Dimension Unit";
            AJWebOrderHeader."Shp. Product Width" := AJWebCarrierPackageType."Def. Width";
            AJWebOrderHeader."Shp. Product Length" := AJWebCarrierPackageType."Def. Length";
            AJWebOrderHeader."Shp. Product Height" := AJWebCarrierPackageType."Def. Height";
        end;

    if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
        AddJObject := AddJObject.JObject();
        if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
            JSONAddTxt(AddJObject, 'units', AJWebOrderHeader."Shp. Product Dimension Unit");
            JSONAddDec(AddJObject, 'length', AJWebOrderHeader."Shp. Product Length");
            JSONAddDec(AddJObject, 'width', AJWebOrderHeader."Shp. Product Width");
            JSONAddDec(AddJObject, 'height', AJWebOrderHeader."Shp. Product Height");
            JSONAddObject(JObject, 'dimensions', AddJObject);
        end else
            JSONAddNULL(JObject, 'dimensions');
    end;

    if AJWebOrderHeader."Insure Shipment" then begin
        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject, 'provider', 'carrier');// "shipsurance" or "carrier"
        JSONAddBool(AddJObject, 'insureShipment', true);
        JSONAddDec(AddJObject, 'insuredValue', AJWebOrderHeader."Insured Value" + AJWebOrderHeader."Additional Insurance Value");
        JSONAddObject(JObject, 'insuranceOptions', AddJObject);
    end else
        JSONAddNULL(JObject, 'insuranceOptions');

    if AJWebOrderHeader."International Shipment" then begin

        SalesHeader.Reset;
        SalesHeader.SetFilter("Document Type", '%1|%2',
          SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
        if SalesHeader.FindFirst then begin

            JArray := JArray.JArray();

            SalesLine.Reset;
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetFilter("No.", '<>%1', '');
            SalesLine.SetFilter(Quantity, '<>%1', 0);
            SalesLine.SetFilter("Qty. to Ship", '<>0');
            if SalesLine.FindFirst then
                repeat

                    Item.Get(SalesLine."No.");

                    AddJObject := AddJObject.JObject();
                    JSONAddTxt(AddJObject, 'description', Item.Description);
                    JSONAddDec(AddJObject, 'quantity', SalesLine."Qty. to Ship");
                    JSONAddDec(AddJObject, 'value', SalesLine."Unit Price");

                    JToken := AddJObject;
                    JArray.Add(JToken);
                until SalesLine.Next = 0
            else
                Error('No items to ship has been found!');

            AddJObject := AddJObject.JObject();
            JSONAddTxt(AddJObject, 'contents', 'merchandise');
            AddJObject.Add('customsItems', JArray);
            JObject.Add('internationalOptions', AddJObject);
        end;

    end else
        JSONAddNULL(JObject, 'internationalOptions');

    AddJObject := AddJObject.JObject();
    JSONAddTxt(AddJObject, 'warehouseId', AJWebOrderHeader."Ship-From Warehouse ID");
    JSONAddBool(AddJObject, 'nonMachinable', AJWebOrderHeader."Non Machinable");
    JSONAddBool(AddJObject, 'saturdayDelivery', AJWebOrderHeader."Saturday Delivery");
    JSONAddBool(AddJObject, 'containsAlcohol', AJWebOrderHeader."Contains Alcohol");
    //JSONAddTxt(AddJObject,'storeId', '51791'); // MBS commented

    SalesHeader.Reset;
    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
    SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
    if SalesHeader.FindFirst then begin
        JSONAddTxt(AddJObject, 'customField1', SalesHeader."No.");   //sales order #
        JSONAddTxt(AddJObject, 'customField2', SalesHeader."External Document No.");  //external document #
    end;

    JSONAddTxt(AddJObject, 'customField3', AJWebOrderHeader."Custom Field 3");

    //for third party billing
    if AJWebOrderHeader."Bill-to Type" <> 0 then begin
        JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebOrderHeader."Bill-to Type"));
        if AJWebOrderHeader."Bill-to Type" = AJWebOrderHeader."Bill-to Type"::my_other_account then
            JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebOrderHeader."Bill-To Account")
        else
            JSONAddTxt(AddJObject, 'billToAccount', AJWebOrderHeader."Bill-To Account");
        JSONAddTxt(AddJObject, 'billToPostalCode', AJWebOrderHeader."Bill-To Postal Code");
        JSONAddTxt(AddJObject, 'billToCountryCode', AJWebOrderHeader."Bill-To Country Code");
    end else begin
        // take Bill-to default from WEB SERVICE, NOT SHIPPING WEB SERVICE
        AJWebCarrier.Get(AJWebOrderHeader."Web Service Code", AJWebOrderHeader."Shipping Carrier Code");
        if AJWebCarrier."Bill-to Type" <> 0 then begin
            JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebCarrier."Bill-to Type"));
            if AJWebCarrier."Bill-to Type" = AJWebCarrier."Bill-to Type"::my_other_account then
                JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebCarrier."Bill-to Account No.")
            else
                JSONAddTxt(AddJObject, 'billToAccount', AJWebCarrier."Bill-to Account No.");
            JSONAddTxt(AddJObject, 'billToPostalCode', AJWebCarrier."Bill-to Account Post Code");
            JSONAddTxt(AddJObject, 'billToCountryCode', AJWebCarrier."Bill-to Account Country Code");
            AJWebOrderHeader."Bill-to Type" := AJWebCarrier."Bill-to Type";
            AJWebOrderHeader."Bill-To Account" := AJWebCarrier."Bill-to Account No.";
            AJWebOrderHeader."Bill-To Postal Code" := AJWebCarrier."Bill-to Account Post Code";
            AJWebOrderHeader."Bill-To Country Code" := AJWebCarrier."Bill-to Account Country Code";
        end;
    end;
    JSONAddObject(JObject, 'advancedOptions', AddJObject);

    // "Fedex does not support test labels at this time."
    if LowerCase(AJWebOrderHeader."Shipping Carrier Code") <> 'fedex' then
        JSONAddBool(JObject, 'testLabel', true);

    Txt := JObject.ToString();

    HttpWebRequest.ContentLength := StrLen(Txt);

    MemoryStream := HttpWebRequest.GetRequestStream();
    StreamWriter := StreamWriter.StreamWriter(MemoryStream);
    StreamWriter.Write(Txt);
    StreamWriter.Flush();
    StreamWriter.Close();
    MemoryStream.Flush();
    MemoryStream.Close();

    if not Http_GetResponse(HttpWebRequest, Txt) then begin
        JObject := JObject.Parse(Txt);
        if JObject.Get('ExceptionMessage', ValueJToken) then
            Error('Web service error:\%1', ValueJToken.AsValue.AsText())
        else
            Error('Web service error:\%1', Txt);
    end;

    JObject := JObject.Parse(Txt);
    ;
    if JObject.Get('labelData', ValueJToken) then begin
        LabelPdf := ValueJToken.AsValue.AsText();
        LabelBytes := base64Converter.FromBase64String(LabelPdf);
        LabelMemoryStream := LabelMemoryStream.MemoryStream(LabelBytes);
        AJWebOrderHeader."Shipping Agent Label".CreateOutStream(LabelOutSteram);
        LabelMemoryStream.WriteTo(LabelOutSteram);
        LabelMemoryStream.Flush();
        LabelMemoryStream.Close();
        AJWebOrderHeader."Carier Shipping Charge" := JSONGetDec(JObject, 'shipmentCost');
        AJWebOrderHeader."Carier Tracking Number" := JSONGetTxt(JObject, 'trackingNumber', MaxStrLen(AJWebOrderHeader."Carier Tracking Number"));
        AJWebOrderHeader."Carier Insurance Cost" := JSONGetDec(JObject, 'insuranceCost');
    end;

    // Test CASE?
    AJWebOrderHeader."Web Service Shipment ID" := JSONGetTxt(JObject, 'shipmentId', MaxStrLen(AJWebOrderHeader."Web Service Shipment ID"));
    AJWebOrderHeader."Labels Created" := true;
    AJWebOrderHeader."Labels Printed" := false;
    // Test CASE?

    AJWebOrderHeader.Modify;
end;

local procedure ShipStation_GetLabelForPackage(var AJWebPackage: Record "AJ Web Package")
var
    AJWebOrderHeader: Record "AJ Web Order Header";
    AJWebMarketplace: Record "AJ Web Marketplace (Mailbox)";
    HttpWebRequest: HttpRequestMessage;
    HttpWebHeaders: HttpHeaders;
    MemoryStream: DotNet MemoryStream;
    Uri: Text;
    XMLDoc: DotNet XmlDocument;
    StreamReader: DotNet StreamReader;
    Encoding: DotNet Encoding;
    Txt: Text;
    XmlNode: DotNet XmlNode;
    ErrorText: Text;
    JArray: JsonArray;
    JConvert: DotNet JsonConvert;
    JToken: JsonToken;
    JObject: JsonObject;
    i: Integer;
    ValueJToken: JsonToken;
    AJWebService: Record "AJ Web Service";
    AddJObject: JsonObject;
    AJWebOrderLine: Record "AJ Web Order Line";
    AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
    AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
    StreamWriter: DotNet StreamWriter;
    LabelPdf: Text;
    base64Converter: DotNet Convert;
    LabelMemoryStream: DotNet MemoryStream;
    LabelBytes: DotNet Array;
    LabelOutSteram: OutStream;
    AJWebCarrierService: Record "AJ Web Carrier Service";
    SkipDefaultDimensions: Boolean;
    SalesHeader: Record "Sales Header";
    AJWebCarrier: Record "AJ Web Carrier";
    AJWebCarrier2: Record "AJ Web Carrier";
    ld_test: Decimal;
    Customer: Record Customer;
begin
    SkipDefaultDimensions := true;

    AJWebPackage.TestField("Label Created", false);
    AJWebPackage.TestField("Shipping Carrier Code");
    AJWebPackage.TestField("Shipping Carrier Service");
    AJWebPackage.TestField("Shipping Package Type");
    AJWebPackage.TestField("Shipping Delivery Confirm");
    AJWebPackage.TestField("Shp. Product Weight");
    AJWebPackage.TestField("Shp. Product Weight Unit");

    if AJWebPackage."Source Type" <> DATABASE::"AJ Web Order Header" then
        exit;

    AJWebOrderHeader.Get(AJWebPackage."Source No.");
    if AJWebOrderHeader."International Shipment" then
        Error('International Not Supported.');

    if AJWebPackage."Ship Date" <> WorkDate then begin
        AJWebPackage.Validate("Ship Date", WorkDate);
        AJWebPackage.Modify;
    end;

    if ((AJWebOrderHeader."Shipping Web Service Code" <> AJWebOrderHeader."Web Service Code")
      or (AJWebOrderHeader."Created From Sales Order"))
      and (AJWebOrderHeader."Shipping Web Service Order No." <> '')
    then begin
        ShipStation_CreateOrderForWeb(AJWebOrderHeader);
    end;
    AJWebPackage."Shipping Web Service Order No." := AJWebOrderHeader."Shipping Web Service Order No.";
    AJWebPackage.Modify;

    if AJWebPackage."Shipping Web Service Order No." = '' then begin
        if AJWebOrderHeader."Shipping Web Service Order No." = '' then
            ShipStation_CreateOrderForWeb(AJWebOrderHeader);
        AJWebPackage."Shipping Web Service Order No." := AJWebOrderHeader."Shipping Web Service Order No.";
        AJWebPackage.Modify;
        Commit;
    end;

    AJWebPackage.TestField("Shipping Web Service Order No.");


    AJWebService.Get(AJWebPackage."Shipping Web Service Code");
    AJWebServiceWarehouse.Get(AJWebService.Code, AJWebPackage."Shipping Warehouse ID");
    AJWebCarrier.Get(AJWebService.Code, AJWebPackage."Shipping Carrier Code");
    AJWebCarrierPackageType.Get(AJWebService.Code, AJWebPackage."Shipping Carrier Code", AJWebPackage."Shipping Package Type");

    AJWebService.TestField("API Endpoint Domain");
    AJWebService.TestField("API Encoded String");
    Uri := AJWebService."API Endpoint Domain" + 'orders/createlabelfororder');

    HttpWebRequest := HttpWebRequest.Create(Uri);
    HttpWebRequest.Method := 'POST';
    HttpWebRequest.ContentType := 'application/json';

    HttpWebHeaders := HttpWebRequest.Headers;
    HttpWebHeaders.Add('authorization', 'Basic ' + AJWebService."API Encoded String");

    JObject := JObject.JObject();
    JSONAddTxtasDec(JObject, 'orderId', AJWebPackage."Shipping Web Service Order No.");
    JSONAddTxt(JObject, 'carrierCode', AJWebPackage."Shipping Carrier Code");
    JSONAddTxt(JObject, 'serviceCode', AJWebPackage."Shipping Carrier Service");
    JSONAddTxt(JObject, 'packageCode', AJWebPackage."Shipping Package Type");
    JSONAddTxt(JObject, 'confirmation', AJWebPackage."Shipping Delivery Confirm");
    JSONAddTxt(JObject, 'shipDate', Format(AJWebPackage."Ship Date", 0, '<Standard Format,9>'));

    AddJObject := AddJObject.JObject();
    JSONAddDec(AddJObject, 'value', AJWebPackage."Shp. Product Weight");
    JSONAddTxt(AddJObject, 'units', AJWebPackage."Shp. Product Weight Unit");
    JSONAddObject(JObject, 'weight', AddJObject);

    if AJWebPackage."Shp. Product Dimension Unit" <> '' then begin
        AddJObject := AddJObject.JObject();
        if AJWebPackage."Shp. Product Dimension Unit" <> '' then begin
            JSONAddTxt(AddJObject, 'units', AJWebPackage."Shp. Product Dimension Unit");
            JSONAddDec(AddJObject, 'length', AJWebPackage."Shp. Product Length");
            JSONAddDec(AddJObject, 'width', AJWebPackage."Shp. Product Width");
            JSONAddDec(AddJObject, 'height', AJWebPackage."Shp. Product Height");
            JSONAddObject(JObject, 'dimensions', AddJObject);
        end else
            JSONAddNULL(JObject, 'dimensions');
    end;

    if AJWebPackage."Insure Shipment" then begin
        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject, 'provider', 'carrier');// "shipsurance" or "carrier"
        JSONAddBool(AddJObject, 'insureShipment', true);
        JSONAddDec(AddJObject, 'insuredValue', AJWebPackage."Insured Value" + AJWebPackage."Additional Insurance Value");
        JSONAddObject(JObject, 'insuranceOptions', AddJObject);
    end else begin
        JSONAddNULL(JObject, 'insuranceOptions');
    end;

    JSONAddNULL(JObject, 'internationalOptions');

    AddJObject := AddJObject.JObject();
    JSONAddTxt(AddJObject, 'warehouseId', AJWebPackage."Shipping Warehouse ID");
    JSONAddBool(AddJObject, 'nonMachinable', AJWebPackage."Non Machinable");
    JSONAddBool(AddJObject, 'saturdayDelivery', AJWebPackage."Saturday Delivery");
    JSONAddBool(AddJObject, 'containsAlcohol', AJWebPackage."Contains Alcohol");
    //JSONAddTxt(AddJObject,'storeId',AJWebStore.Code); //MBS commented 12.09.2019

    SalesHeader.Reset;
    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
    SalesHeader.SetRange("Web Order No.", AJWebPackage."Source No.");
    if SalesHeader.FindFirst then begin
        JSONAddTxt(AddJObject, 'customField1', SalesHeader."No.");   //sales order #
        JSONAddTxt(AddJObject, 'customField2', SalesHeader."External Document No.");  //external document #
        Customer.Get(SalesHeader."Sell-to Customer No.");
    end;

    JSONAddNULL(AddJObject, 'customField3');

    // 3rd party billing
    if AJWebPackage."Bill-to Type" <> 0 then begin
        JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebPackage."Bill-to Type"));
        if AJWebPackage."Bill-to Type" = AJWebPackage."Bill-to Type"::my_other_account then
            JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebPackage."Bill-To Account")
        else
            JSONAddTxt(AddJObject, 'billToAccount', AJWebPackage."Bill-To Account");
        JSONAddTxt(AddJObject, 'billToPostalCode', AJWebPackage."Bill-To Postal Code");
        JSONAddTxt(AddJObject, 'billToCountryCode', AJWebPackage."Bill-To Country Code");
    end else
        if AJWebOrderHeader."Bill-to Type" <> 0 then begin
            AJWebPackage."Bill-to Type" := AJWebOrderHeader."Bill-to Type";
            AJWebPackage."Bill-To Account" := AJWebOrderHeader."Bill-To Account";
            AJWebPackage."Bill-To Postal Code" := AJWebOrderHeader."Bill-To Postal Code";
            AJWebPackage."Bill-To Country Code" := AJWebOrderHeader."Bill-To Country Code";
            AJWebPackage.Modify;

            JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebOrderHeader."Bill-to Type"));
            if AJWebOrderHeader."Bill-to Type" = AJWebOrderHeader."Bill-to Type"::my_other_account then
                JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebOrderHeader."Bill-To Account")
            else
                JSONAddTxt(AddJObject, 'billToAccount', AJWebOrderHeader."Bill-To Account");
            JSONAddTxt(AddJObject, 'billToPostalCode', AJWebOrderHeader."Bill-To Postal Code");
            JSONAddTxt(AddJObject, 'billToCountryCode', AJWebOrderHeader."Bill-To Country Code");

        end else
            if Customer."Bill-to Type" <> 0 then begin
                AJWebOrderHeader."Bill-to Type" := Customer."Bill-to Type";
                AJWebOrderHeader."Bill-To Account" := Customer."Bill-to Account No.";
                AJWebOrderHeader."Bill-To Postal Code" := Customer."Bill-to Account Post Code";
                AJWebOrderHeader."Bill-To Country Code" := Customer."Bill-to Account Country Code";
                AJWebOrderHeader.Modify;

                AJWebPackage."Bill-to Type" := Customer."Bill-to Type";
                AJWebPackage."Bill-To Account" := Customer."Bill-to Account No.";
                AJWebPackage."Bill-To Postal Code" := Customer."Bill-to Account Post Code";
                AJWebPackage."Bill-To Country Code" := Customer."Bill-to Account Country Code";
                AJWebPackage.Modify;

                JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebPackage."Bill-to Type"));
                if AJWebPackage."Bill-to Type" = AJWebPackage."Bill-to Type"::my_other_account then
                    JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebPackage."Bill-To Account")
                else
                    JSONAddTxt(AddJObject, 'billToAccount', AJWebPackage."Bill-To Account");
                JSONAddTxt(AddJObject, 'billToPostalCode', AJWebPackage."Bill-To Postal Code");
                JSONAddTxt(AddJObject, 'billToCountryCode', AJWebPackage."Bill-To Country Code");

            end else begin
                if AJWebCarrier2.Get(AJWebOrderHeader."Web Service Code", AJWebOrderHeader."Shipping Carrier Code") then
                    if AJWebCarrier2."Bill-to Type" <> 0 then begin
                        AJWebOrderHeader."Bill-to Type" := AJWebCarrier2."Bill-to Type";
                        AJWebOrderHeader."Bill-To Account" := AJWebCarrier2."Bill-to Account No.";
                        AJWebOrderHeader."Bill-To Postal Code" := AJWebCarrier2."Bill-to Account Post Code";
                        AJWebOrderHeader."Bill-To Country Code" := AJWebCarrier2."Bill-to Account Country Code";
                        AJWebOrderHeader.Modify;

                        AJWebPackage."Bill-to Type" := AJWebCarrier2."Bill-to Type";
                        AJWebPackage."Bill-To Account" := AJWebCarrier2."Bill-to Account No.";
                        AJWebPackage."Bill-To Postal Code" := AJWebCarrier2."Bill-to Account Post Code";
                        AJWebPackage."Bill-To Country Code" := AJWebCarrier2."Bill-to Account Country Code";
                        AJWebPackage.Modify;

                        JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebCarrier2."Bill-to Type"));
                        if AJWebCarrier2."Bill-to Type" = AJWebCarrier2."Bill-to Type"::my_other_account then
                            JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebCarrier2."Bill-to Account No.")
                        else
                            JSONAddTxt(AddJObject, 'billToAccount', AJWebCarrier2."Bill-to Account No.");
                        JSONAddTxt(AddJObject, 'billToPostalCode', AJWebCarrier2."Bill-to Account Post Code");
                        JSONAddTxt(AddJObject, 'billToCountryCode', AJWebCarrier2."Bill-to Account Country Code");
                    end;
            end;
    JSONAddObject(JObject, 'advancedOptions', AddJObject);

    // "Fedex does not support test labels at this time."
    if LowerCase(AJWebPackage."Shipping Carrier Code") <> 'fedex' then
        JSONAddBool(JObject, 'testLabel', false);
    Txt := JObject.ToString();

    HttpWebRequest.ContentLength := StrLen(Txt);

    MemoryStream := HttpWebRequest.GetRequestStream();
    StreamWriter := StreamWriter.StreamWriter(MemoryStream);
    StreamWriter.Write(Txt);
    StreamWriter.Flush();
    StreamWriter.Close();
    MemoryStream.Flush();
    MemoryStream.Close();

    if not Http_GetResponse(HttpWebRequest, Txt) then begin
        JObject := JObject.Parse(Txt);
        if JObject.Get('ExceptionMessage', ValueJToken) then
            Error('Web service error:\%1', ValueJToken.AsValue.AsText())
        else
            Error('Web service error:\%1', Txt);
    end;

    JObject := JObject.Parse(Txt);
    ;
    if JObject.Get('labelData', ValueJToken) then begin
        LabelPdf := ValueJToken.AsValue.AsText();
        LabelBytes := base64Converter.FromBase64String(LabelPdf);
        LabelMemoryStream := LabelMemoryStream.MemoryStream(LabelBytes);
        AJWebPackage.Label.CreateOutStream(LabelOutSteram);
        LabelMemoryStream.WriteTo(LabelOutSteram);
        LabelMemoryStream.Flush();
        LabelMemoryStream.Close();
        AJWebPackage."Carier Shipping Charge" := JSONGetDec(JObject, 'shipmentCost');
        AJWebPackage."Carier Tracking Number" := JSONGetTxt(JObject, 'trackingNumber', MaxStrLen(AJWebPackage."Carier Tracking Number"));
        AJWebPackage."Carier Insurance Cost" := JSONGetDec(JObject, 'insuranceCost');
    end;
    if LowerCase(AJWebPackage."Shipping Carrier Code") = 'fedex' then begin
        AJWebPackage."Shipping Web Service Shipm. ID" := JSONGetTxt(JObject, 'shipmentId', MaxStrLen(AJWebPackage."Shipping Web Service Shipm. ID"));
        AJWebPackage."Label Created" := true;
        AJWebPackage."Label Printed" := false;
    end;

    AJWebCarrierService.Get(AJWebPackage."Shipping Web Service Code", AJWebPackage."Shipping Carrier Code", AJWebPackage."Shipping Carrier Service");

    SalesHeader.Reset;
    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
    SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
    if SalesHeader.FindFirst then begin
        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            Customer.Init;
    end;

    AJWebPackage.Modify;
end;

local procedure ShipStation_CancelLabelForPackage(var AJWebPackage: Record "AJ Web Package")
var
    AJWebService: Record "AJ Web Service";
    HttpWebRequest: HttpRequestMessage;
    HttpWebHeaders: HttpHeaders;
    MemoryStream: DotNet MemoryStream;
    StreamWriter: DotNet StreamWriter;
    Uri: Text;
    Txt: Text;
    JObject: JsonObject;
    ValueJToken: JsonToken;
begin

    if not AJWebPackage."Label Created" then
        exit;

    AJWebPackage.TestField("Shipping Web Service Order No.");
    AJWebPackage.TestField("Shipping Web Service Shipm. ID");

    AJWebService.Get(AJWebPackage."Shipping Web Service Code");
    AJWebService.TestField("Web Service Type", AJWebService."Web Service Type"::ShipStation);

    AJWebService.TestField("API Endpoint Domain");
    AJWebService.TestField("API Encoded String");
    Uri := AJWebService."API Endpoint Domain" + 'shipments/voidlabel');

    HttpWebRequest := HttpWebRequest.Create(Uri);
    HttpWebRequest.Method := 'POST';
    HttpWebRequest.ContentType := 'application/json';

    HttpWebHeaders := HttpWebRequest.Headers;
    HttpWebHeaders.Add('authorization', 'Basic ' + AJWebService."API Encoded String");

    JObject := JObject.JObject();
    JSONAddTxtasDec(JObject, 'shipmentId', AJWebPackage."Shipping Web Service Shipm. ID");
    Txt := JObject.ToString();
    HttpWebRequest.ContentLength := StrLen(Txt);

    MemoryStream := HttpWebRequest.GetRequestStream();
    StreamWriter := StreamWriter.StreamWriter(MemoryStream);
    StreamWriter.Write(Txt);
    StreamWriter.Flush();
    StreamWriter.Close();
    MemoryStream.Flush();
    MemoryStream.Close();

    if not Http_GetResponse(HttpWebRequest, Txt) then begin
        JObject := JObject.Parse(Txt);
        if JObject.Get('ExceptionMessage', ValueJToken) then
            Error('Web service error:\%1', ValueJToken.AsValue.AsText())
        else
            Error('Web service error:\%1', Txt);
    end;

    JObject := JObject.Parse(Txt);
    if JSONGetBool(JObject, 'approved') then begin
        AJWebPackage."Shipping Web Service Shipm. ID" := '';
        AJWebPackage."Carier Shipping Charge" := 0;
        AJWebPackage."Carier Tracking Number" := '';
        AJWebPackage."Carier Insurance Cost" := 0;
        AJWebPackage."Label Created" := false;
        AJWebPackage."Label Printed" := false;
        AJWebPackage."Shipping & Handling Amount" := 0;
        Clear(AJWebPackage.Label);
        AJWebPackage.Modify;
    end;
end;
}
*/
