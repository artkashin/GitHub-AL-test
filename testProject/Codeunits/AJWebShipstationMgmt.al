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
<<<<<<< HEAD

                if JObject.Get('createDate', ValueJToken) then
                    AJWebServiceWarehouse."Created At" := ValueJToken.AsValue().AsDateTime();
                if JObject.Get('isDefault', ValueJToken) then
                    AJWebServiceWarehouse.Default := ValueJToken.AsValue().AsBoolean();

            end;
            if not AJWebServiceWarehouse.Insert() then
                AJWebServiceWarehouse.Modify();
        end;
    end;

    procedure SaveLabel(AJWebOrderHeader: Record "AJ Web Order Header")
    var
        IS: InStream;
        ToFile: Text;
    begin
        AJWebOrderHeader.Find();
        AJWebOrderHeader.CalcFields("Shipping Agent Label");
        if AJWebOrderHeader."Shipping Agent Label".HasValue() then begin
            AJWebOrderHeader."Shipping Agent Label".CreateInStream(IS);
            ToFile := 'LBL-' + AJWebOrderHeader."Web Order No." + '.pdf';
            DownloadFromStream(IS, 'Save label as', 'C:\', 'Adobe Acrobat file(*.pdf)|*.pdf', ToFile);
        end;
    end;

    procedure CreateWebOrderFromSalesOrder(var SalesHeader: Record "Sales Header"; var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        SalesLine: Record "Sales Line";
        AJWebOrderLine: Record "AJ Web Order Line";
        Customer: Record Customer;
        Currency: Record Currency;
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        AJWebService: Record "AJ Web Service";
    begin
        if AJWebOrderHeader."Web Order No." = '' then begin
            AJWebOrderHeader."Created From Sales Order" := true;
            AJWebOrderHeader.Insert(true);
        end;

        // IF SalesHeader."Ship-to Phone No." = '' THEN // mbs commented
        //  IF ShiptoAddress.GET(SalesHeader."Sell-to Customer No.",SalesHeader."Ship-to Code") THEN
        //    SalesHeader."Ship-to Phone No." := ShiptoAddress."Phone No.";
        //
        // IF SalesHeader."Ship-to Phone No." = '' THEN // mbs commented
        //  IF Customer.GET(SalesHeader."Sell-to Customer No.") THEN
        //    SalesHeader."Ship-to Phone No." := Customer."Phone No.";

        if AJWebOrderHeader."Web Service PO Number" = '' then
            AJWebOrderHeader."Web Service PO Number" := SalesHeader."No.";
        if AJWebOrderHeader."Customer Reference ID" = '' then
            AJWebOrderHeader."Customer Reference ID" := SalesHeader."External Document No.";
        AJWebOrderHeader."Custom Field 1" := 'ID: ' + SalesHeader."Sell-to Customer No." + ' DOC: ' + SalesHeader."No.";
        AJWebOrderHeader."Custom Field 2" := SalesHeader."Your Reference";

        AJWebOrderHeader."Custom Field 3" := SalesHeader."External Document No.";

        AJWebOrderHeader."Order DateTime" := CreateDateTime(SalesHeader."Order Date", 0T);

        AJWebOrderHeader."Bill-To Customer Name" := SalesHeader."Bill-to Name";
        AJWebOrderHeader."Bill-To Company" := CopyStr(SalesHeader."Bill-to Name", 1, MaxStrLen(AJWebOrderHeader."Bill-To Company"));
        AJWebOrderHeader."Bill-To Customer Address 1" := SalesHeader."Bill-to Address";
        AJWebOrderHeader."Bill-To Customer Address 2" := SalesHeader."Bill-to Address 2";
        AJWebOrderHeader."Bill-To Customer Address 3" := '';
        AJWebOrderHeader."Bill-To Customer City" := SalesHeader."Bill-to City";
        AJWebOrderHeader."Bill-To Customer State" := CopyStr(SalesHeader."Bill-to County", 1, MaxStrLen(AJWebOrderHeader."Bill-To Customer State"));
        AJWebOrderHeader."Bill-To Customer Zip" := CopyStr(SalesHeader."Bill-to Post Code", 1, MaxStrLen(AJWebOrderHeader."Bill-To Customer Zip"));
        AJWebOrderHeader."Bill-To Customer Country" := SalesHeader."Bill-to Country/Region Code";
        AJWebOrderHeader."Bill-To Customer Phone" := '';
        if Customer.Get(SalesHeader."Bill-to Customer No.") then
            AJWebOrderHeader."Bill-To Customer Phone" := Customer."Phone No.";
        AJWebOrderHeader."Bill-To Residential" := false;

        AJWebOrderHeader."Ship-To Customer Name" := SalesHeader."Ship-to Name";
        AJWebOrderHeader."Ship-To Company" := SalesHeader."Ship-to Name";
        AJWebOrderHeader."Ship-To Customer Address 1" := SalesHeader."Ship-to Address";
        if AJWebOrderHeader."Ship-To Customer Address 1" = '' then
            AJWebOrderHeader."Ship-To Customer Address 1" := SalesHeader."Ship-to Address 2"
        else
            AJWebOrderHeader."Ship-To Customer Address 2" := SalesHeader."Ship-to Address 2";
        AJWebOrderHeader."Ship-To Customer Address 3" := '';
        AJWebOrderHeader."Ship-To Customer City" := SalesHeader."Ship-to City";
        AJWebOrderHeader."Ship-To Customer State" := CopyStr(SalesHeader."Ship-to County", 1, MaxStrLen(AJWebOrderHeader."Ship-To Customer State"));
        AJWebOrderHeader."Ship-To Customer Zip" := CopyStr(SalesHeader."Ship-to Post Code", 1, MaxStrLen(AJWebOrderHeader."Ship-To Customer Zip"));
        AJWebOrderHeader."Ship-To Customer Country" := SalesHeader."Ship-to Country/Region Code";
        //AJWebOrderHeader."Ship-To Customer Phone" := SalesHeader."Ship-to Phone No.";
        AJWebOrderHeader."Ship-To Residential" := false;
        //AJWebOrderHeader."Ship-To E-mail" := SalesHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesHeader."Salesperson Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJWebOrderHeader."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJWebOrderHeader."Ship-To E-mail") then
                if AJWebOrderHeader."Ship-To E-mail" = '' then
                    AJWebOrderHeader."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJWebOrderHeader."Ship-To E-mail"))
                else
                    AJWebOrderHeader."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";


        if not AJWebService.Get(AJWebOrderHeader."Shipping Web Service Code") then
            AJWebService.Init();

        AJWebOrderHeader."Merchandise Amount" := 0;
        // MBS commented >>
        // IF (SalesHeader."Shipping Agent Code" <> '') AND (SalesHeader."Shipping Agent Service Code" <> '') THEN
        //  IF ShippingAgentServices.GET(SalesHeader."Shipping Agent Code", SalesHeader."Shipping Agent Service Code") THEN
        //     AJWebOrderHeader."Saturday Delivery" := ShippingAgentServices."Saturday Delivery";
        // MBS commented <<
        AJWebOrderHeader.Modify();

        AJWebOrderHeader.TestField("Ship-To Customer Address 1");

        if AJWebOrderHeader."Created From Sales Order" then begin
            AJWebOrderLine.Reset();
            AJWebOrderLine.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if not AJWebOrderLine.IsEmpty() then
                AJWebOrderLine.DeleteAll(true);

            Currency.InitRoundingPrecision();
            AJWebOrderHeader."Merchandise Amount" := 0;
            if SalesHeader."Document Type" = -1 then begin
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
                SalesInvoiceLine.SetRange(Type, SalesLine.Type::Item);
                SalesInvoiceLine.SetFilter("No.", '<>%1', '');
                SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
                if SalesInvoiceLine.FindFirst() then
                    repeat
                        AJWebOrderLine.Init();
                        AJWebOrderLine."Web Order No." := AJWebOrderHeader."Web Order No.";
                        AJWebOrderLine."Line No." := SalesInvoiceLine."Line No.";
                        AJWebOrderLine."Order Item ID" := SalesInvoiceLine."No.";
                        AJWebOrderLine.Quantity := SalesInvoiceLine.Quantity;
                        AJWebOrderLine."Unit Price" := Round(SalesInvoiceLine."Amount Including VAT" / SalesInvoiceLine.Quantity, 0.001);
                        AJWebOrderLine.Insert();
                        AJWebOrderHeader."Merchandise Amount" += AJWebOrderLine.Quantity * AJWebOrderLine."Unit Price";
                    until SalesInvoiceLine.Next() = 0;
            end else begin
                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("No.", '<>%1', '');
                SalesLine.SetFilter("Qty. to Ship", '<>%1', 0);
                if SalesLine.FindFirst() then
                    repeat
                        AJWebOrderLine.Init();
                        AJWebOrderLine."Web Order No." := AJWebOrderHeader."Web Order No.";
                        AJWebOrderLine."Line No." := SalesLine."Line No.";
                        AJWebOrderLine."Order Item ID" := SalesLine."No.";
                        AJWebOrderLine.Quantity := SalesLine."Qty. to Ship";
                        AJWebOrderLine."Unit Price" := Round(SalesLine."Amount Including VAT" / SalesLine.Quantity, Currency."Unit-Amount Rounding Precision");
                        AJWebOrderLine.Name := SalesLine.Description;
                        AJWebOrderLine.Insert();

                        AJWebOrderHeader."Merchandise Amount" += AJWebOrderLine.Quantity * AJWebOrderLine."Unit Price";
                    until SalesLine.Next() = 0;
            end;
            AJWebOrderHeader."Merchandise Amount" := Round(AJWebOrderHeader."Merchandise Amount", Currency."Amount Rounding Precision"); // 4/12/2018
            AJWebOrderHeader."NAV Order Status" := AJWebOrderHeader."NAV Order Status"::Created; // 4/12/2018
            AJWebOrderHeader.Modify();
        end;

        CreateOrder(AJWebOrderHeader);
    end;

    procedure GetOrderLabel(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebService: Record "AJ Web Service";
        AJWebOrderLine: Record "AJ Web Order Line";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        AJWebCarrier: Record "AJ Web Carrier";
        Item: Record Item;
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        Base64Convert: Codeunit Base64Convert;
        JArray: JsonArray;
        JToken: JsonToken;
        ValueJToken: JsonToken;
        JObject: JsonObject;
        AddJObject: JsonObject;
        JValue: JsonValue;
        OutStr: OutStream;
        SkipDefaultDimensions: Boolean;
        Uri: Text;
        Txt: Text;
        LabelPdf: Text;
    begin
        SkipDefaultDimensions := true;

        if AJWebOrderHeader."Ship Date" <> Today() then begin
            AJWebOrderHeader.Validate("Ship Date", Today());
            AJWebOrderHeader.Modify(false);
        end;

        if (not DoNotSendOrder) and (AJWebOrderHeader."COD Status" = AJWebOrderHeader."COD Status"::" ") then
            if AJWebOrderHeader."Created From Sales Order" or
            (AJWebOrderHeader."Shipping Web Service Code" <> AJWebOrderHeader."Web Service Code")
            then begin
                CreateOrderForWeb(AJWebOrderHeader);
                Commit();

            end;

        if AJWebOrderHeader."Shipping Web Service Order No." = '' then begin
            CreateOrder(AJWebOrderHeader);
            Commit();
        end;

        AJWebOrderHeader.TestField("Shipping Web Service Order No.");

        AJWebService.Get(AJWebOrderHeader."Web Service Code");

        AJWebOrderHeader.TestField("Shipping Carrier Code");
        AJWebOrderHeader.TestField("Shipping Carrier Service");
        AJWebOrderHeader.TestField("Shipping Package Type");
        AJWebOrderHeader.TestField("Shipping Delivery Confirm");

        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        Uri := AJWebService."API Endpoint Domain" + 'orders/createlabelfororder';

        JToken := JValue.AsToken();
        Clear(JObject);

        AJWebJsonHelper.JSONAddTxtasDec(JObject, 'orderId', AJWebOrderHeader."Shipping Web Service Order No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'carrierCode', AJWebOrderHeader."Shipping Carrier Code");
        AJWebJsonHelper.JSONAddTxt(JObject, 'serviceCode', AJWebOrderHeader."Shipping Carrier Service");
        AJWebJsonHelper.JSONAddTxt(JObject, 'packageCode', AJWebOrderHeader."Shipping Package Type");
        AJWebJsonHelper.JSONAddTxt(JObject, 'confirmation', AJWebOrderHeader."Shipping Delivery Confirm");

        if AJWebOrderHeader."Ship Date" = 0D then
            AJWebOrderHeader."Ship Date" := WorkDate();
        AJWebJsonHelper.JSONAddTxt(JObject, 'shipDate', Format(AJWebOrderHeader."Ship Date", 0, '<Standard Format,9>'));

        if AJWebOrderHeader."Shp. Product Weight" = 0 then begin
            AJWebOrderLine.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if AJWebOrderLine.FindFirst() then
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
                until AJWebOrderLine.Next() = 0;
        end;

        AJWebOrderHeader.TestField("Shp. Product Weight");
        AJWebOrderHeader.TestField("Shp. Product Weight Unit");

        Clear(AddJObject);

        AJWebJsonHelper.JSONAddDec(AddJObject, 'value', AJWebOrderHeader."Shp. Product Weight");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJWebOrderHeader."Shp. Product Weight Unit");
        AJWebJsonHelper.JSONAddObject(JObject, 'weight', AddJObject);

        if AJWebOrderHeader."Shp. Product Dimension Unit" = '' then
            if not SkipDefaultDimensions then begin
                AJWebCarrierPackageType.Get(AJWebService.Code, AJWebOrderHeader."Shipping Carrier Code", AJWebOrderHeader."Shipping Package Type");
                AJWebOrderHeader."Shp. Product Dimension Unit" := AJWebCarrierPackageType."Def. Dimension Unit";
                AJWebOrderHeader."Shp. Product Width" := AJWebCarrierPackageType."Def. Width";
                AJWebOrderHeader."Shp. Product Length" := AJWebCarrierPackageType."Def. Length";
                AJWebOrderHeader."Shp. Product Height" := AJWebCarrierPackageType."Def. Height";
            end;

        if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
            Clear(AddJObject);
            if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJWebOrderHeader."Shp. Product Dimension Unit");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'length', AJWebOrderHeader."Shp. Product Length");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'width', AJWebOrderHeader."Shp. Product Width");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'height', AJWebOrderHeader."Shp. Product Height");
                AJWebJsonHelper.JSONAddObject(JObject, 'dimensions', AddJObject);
            end else
                AJWebJsonHelper.JSONAddNULL(JObject, 'dimensions');
        end;

        if AJWebOrderHeader."Insure Shipment" then begin
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'provider', 'carrier');// "shipsurance" or "carrier"
            AJWebJsonHelper.JSONAddBool(AddJObject, 'insureShipment', true);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'insuredValue', AJWebOrderHeader."Insured Value" + AJWebOrderHeader."Additional Insurance Value");
            AJWebJsonHelper.JSONAddObject(JObject, 'insuranceOptions', AddJObject);
        end else
            AJWebJsonHelper.JSONAddNULL(JObject, 'insuranceOptions');

        if AJWebOrderHeader."International Shipment" then begin

            SalesHeader.Reset();
            SalesHeader.SetFilter("Document Type", '%1|%2',
            SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
            SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if SalesHeader.FindFirst() then begin

                JArray := JToken.AsArray();

                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("No.", '<>%1', '');
                SalesLine.SetFilter(Quantity, '<>%1', 0);
                SalesLine.SetFilter("Qty. to Ship", '<>0');
                if SalesLine.FindFirst() then
                    repeat
                        Item.Get(SalesLine."No.");

                        Clear(AddJObject);
                        AJWebJsonHelper.JSONAddTxt(AddJObject, 'description', Item.Description);
                        AJWebJsonHelper.JSONAddDec(AddJObject, 'quantity', SalesLine."Qty. to Ship");
                        AJWebJsonHelper.JSONAddDec(AddJObject, 'value', SalesLine."Unit Price");

                        JArray.Add(AddJObject.AsToken());
                    until SalesLine.Next() = 0
                else
                    Error('No items to ship has been found!');

                Clear(AddJObject);
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'contents', 'merchandise');
                AddJObject.Add('customsItems', JArray);
                JObject.Add('internationalOptions', AddJObject);
            end;

        end else
            AJWebJsonHelper.JSONAddNULL(JObject, 'internationalOptions');

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'warehouseId', AJWebOrderHeader."Ship-From Warehouse ID");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'nonMachinable', AJWebOrderHeader."Non Machinable");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'saturdayDelivery', AJWebOrderHeader."Saturday Delivery");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'containsAlcohol', AJWebOrderHeader."Contains Alcohol");
        //AJWebJsonHelper.JSONAddTxt(AddJObject,'storeId', '51791'); // MBS commented

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
        if SalesHeader.FindFirst() then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', SalesHeader."No.");   //sales order #
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', SalesHeader."External Document No.");  //external document #
        end;

        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', AJWebOrderHeader."Custom Field 3");

        //for third party billing
        if AJWebOrderHeader."Bill-to Type" <> 0 then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebOrderHeader."Bill-to Type"));
            if AJWebOrderHeader."Bill-to Type" = AJWebOrderHeader."Bill-to Type"::my_other_account then
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebOrderHeader."Bill-To Account")
            else
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJWebOrderHeader."Bill-To Account");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJWebOrderHeader."Bill-To Postal Code");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJWebOrderHeader."Bill-To Country Code");
        end else begin
            // take Bill-to default from WEB SERVICE, NOT SHIPPING WEB SERVICE
            AJWebCarrier.Get(AJWebOrderHeader."Web Service Code", AJWebOrderHeader."Shipping Carrier Code");
            if AJWebCarrier."Bill-to Type" <> 0 then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebCarrier."Bill-to Type"));
                if AJWebCarrier."Bill-to Type" = AJWebCarrier."Bill-to Type"::my_other_account then
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebCarrier."Bill-to Account No.")
                else
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJWebCarrier."Bill-to Account No.");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJWebCarrier."Bill-to Account Post Code");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJWebCarrier."Bill-to Account Country Code");
                AJWebOrderHeader."Bill-to Type" := AJWebCarrier."Bill-to Type";
                AJWebOrderHeader."Bill-To Account" := AJWebCarrier."Bill-to Account No.";
                AJWebOrderHeader."Bill-To Postal Code" := CopyStr(AJWebCarrier."Bill-to Account Post Code", 1, MaxStrLen(AJWebOrderHeader."Bill-To Postal Code"));
                AJWebOrderHeader."Bill-To Country Code" := AJWebCarrier."Bill-to Account Country Code";
            end;
        end;
        AJWebJsonHelper.JSONAddObject(JObject, 'advancedOptions', AddJObject);

        // "Fedex does not support test labels at this time."
        if LowerCase(AJWebOrderHeader."Shipping Carrier Code") <> 'fedex' then
            AJWebJsonHelper.JSONAddBool(JObject, 'testLabel', true);

        JObject.WriteTo(Txt);

        if not AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt) then begin
            JObject.ReadFrom(Txt);
            if JObject.Get('ExceptionMessage', ValueJToken) then
                Error('Web service error:\%1', ValueJToken.AsValue().AsText())
            else
                Error('Web service error:\%1', Txt);
        end;

        JObject.ReadFrom(Txt);

        if JObject.Contains('labelData') then begin
            LabelPdf := AJWebJsonHelper.GetJsonValueAsText(JObject, 'labelData');

            AJWebOrderHeader."Shipping Agent Label".CreateOutStream(OutStr);
            Base64Convert.FromBase64StringToStream(LabelPdf, OutStr);

            AJWebOrderHeader."Carier Shipping Charge" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'shipmentCost');
            AJWebOrderHeader."Carier Tracking Number" := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'trackingNumber'), 1, MaxStrLen(AJWebOrderHeader."Carier Tracking Number"));
            AJWebOrderHeader."Carier Insurance Cost" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'insuranceCost');
        end;

        AJWebOrderHeader."Web Service Shipment ID" := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'shipmentId'), 1, MaxStrLen(AJWebOrderHeader."Web Service Shipment ID"));
        AJWebOrderHeader."Labels Created" := true;
        AJWebOrderHeader."Labels Printed" := false;
        AJWebOrderHeader.Modify();
    end;

    procedure GetOrderLabelParam(NewDoNotSendOrder: Boolean)
    begin
        DoNotSendOrder := NewDoNotSendOrder;
    end;

    local procedure CreateOrderForWeb(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebCarrier: Record "AJ Web Carrier";

        AJWebService: Record "AJ Web Service";
        AJWebService2: Record "AJ Web Service";
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        JArray: JsonArray;
        JToken: JsonToken;
        AddJObject: JsonObject;
        JObject: JsonObject;
        Uri: Text;
        Txt: Text;
    begin
        if AJWebOrderHeader."Shipping Web Service Code" <> '' then
            AJWebService.Get(AJWebOrderHeader."Shipping Web Service Code")
        else
            AJWebService.Get(AJWebOrderHeader."Web Service Code");
        AJWebService.TestField("Web Service Type", AJWebService."Web Service Type"::ShipStation);
        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        //>> Additional Check
        if AJWebOrderHeader."Ship-To Customer Country" in ['USA', ''] then
            AJWebOrderHeader."Ship-To Customer Country" := 'US';
        if AJWebOrderHeader."Bill-To Customer Country" in ['USA', ''] then
            AJWebOrderHeader."Bill-To Customer Country" := 'US';

        AJWebCarrier.Get(AJWebService.Code, AJWebOrderHeader."Shipping Carrier Code");
        if AJWebCarrier."2 Lines Address only" and ((AJWebOrderHeader."Bill-To Customer Address 3" <> '')
          or (AJWebOrderHeader."Ship-To Customer Address 3" <> ''))
        then
            Error(StrSubstNo(AddressErr, AJWebCarrier.Code));
        //<< Additional Check

        Uri := AJWebService."API Endpoint Domain" + 'orders/createorder';


        //Clear(JObject);
        Clear(JObject);
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderNumber', AJWebOrderHeader."Web Order No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderKey', AJWebOrderHeader."Web Order No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderDate', Format(DT2Date(AJWebOrderHeader."Order DateTime"), 0, '<Standard Format,9>'));
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderStatus', 'awaiting_shipment');// awaiting_payment, awaiting_shipment,shipped,on_hold,cancelled
        if AJWebOrderHeader."Ship-To E-mail" <> '' then
            AJWebJsonHelper.JSONAddTxt(JObject, 'customerEmail', AJWebOrderHeader."Ship-To E-mail");

        Clear(AddJObject);

        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJWebOrderHeader."Bill-To Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJWebOrderHeader."Bill-To Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJWebOrderHeader."Bill-To Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJWebOrderHeader."Bill-To Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJWebOrderHeader."Bill-To Customer Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJWebOrderHeader."Bill-To Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJWebOrderHeader."Bill-To Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJWebOrderHeader."Bill-To Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJWebOrderHeader."Bill-To Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJWebOrderHeader."Bill-To Customer Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJWebOrderHeader."Bill-To Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'billTo', AddJObject);

        //sdf
        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJWebOrderHeader."Ship-To Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJWebOrderHeader."Ship-To Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJWebOrderHeader."Ship-To Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJWebOrderHeader."Ship-To Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJWebOrderHeader."Ship-To Customer Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJWebOrderHeader."Ship-To Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJWebOrderHeader."Ship-To Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJWebOrderHeader."Ship-To Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJWebOrderHeader."Ship-To Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJWebOrderHeader."Ship-To Customer Phone");

        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJWebOrderHeader."Ship-To Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'shipTo', AddJObject);

        //Clear(AddJObject);
        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'warehouseId', AJWebOrderHeader."Ship-From Warehouse ID");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'nonMachinable', AJWebOrderHeader."Non Machinable");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'saturdayDelivery', AJWebOrderHeader."Saturday Delivery");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'containsAlcohol', AJWebOrderHeader."Contains Alcohol");
        //AJWebJsonHelper.JSONAddTxt(AddJObject,'storeId',AJWebStore.Code); // MBS 12.09.2019 commented

        // we fill CustomFields with spec values for JCP
        AJWebService2.Get(AJWebOrderHeader."Web Service Code");
        if (AJWebOrderHeader."Custom Field 1" <> '') and (AJWebOrderHeader."Custom Field 2" <> '')
        then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', AJWebOrderHeader."Custom Field 1");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', AJWebOrderHeader."Custom Field 2");
        end else begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', AJWebOrderHeader."Web Service PO Number");   //sales order #
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', AJWebOrderHeader."Customer Reference ID");  //external document #
        end;

        AJWebService2.Get(AJWebOrderHeader."Web Service Code");
        if AJWebService2."Reference 3" = AJWebService2."Reference 3"::PO then
            AJWebOrderHeader."Custom Field 3" := AJWebOrderHeader."Web Service PO Number"
        else
            //>> COD
            AJWebOrderHeader."Custom Field 3" := CopyStr(IsCOD(AJWebOrderHeader), 1, MaxStrLen(AJWebOrderHeader."Custom Field 3"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', AJWebOrderHeader."Custom Field 3");
        //<< COD

        AJWebJsonHelper.JSONAddObject(JObject, 'advancedOptions', AddJObject);

        //>> COD
        if (IsCOD(AJWebOrderHeader) <> '') and (AJWebOrderHeader."COD Amount" <> 0) then begin
            // item
            //Clear(AddJObject);
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'sku', 'COD');
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', 'COD amount');
            AJWebJsonHelper.JSONAddDec(AddJObject, 'quantity', 1);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'unitPrice', AJWebOrderHeader."COD Amount");

            JArray := AddJObject.AsToken().AsArray();
            JArray.Add(JToken);
            JObject.Add('items', JArray.AsToken());
        end;
        //<< COD

        JObject.WriteTo(Txt);
        /*
        Encoding := SystemTextUTF8Encoding.UTF8Encoding(false);
        HttpWebRequest.ContentLength := Encoding.GetByteCount(Txt);        
        MemoryStream := HttpWebRequest.GetRequestStream();
        StreamWriter := StreamWriter.StreamWriter(MemoryStream, Encoding);
        StreamWriter.Write(Txt);
        StreamWriter.Flush();
        StreamWriter.Close();
        MemoryStream.Flush();
        MemoryStream.Close();
        */

        if not AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt) then
            Error('Web service error:\%1', Txt);

        JObject.ReadFrom(Txt);
        if JObject.Contains('orderId') then begin
            AJWebOrderHeader."Shipping Web Service Order No." := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'orderId'), 1, MaxStrLen(AJWebOrderHeader."Shipping Web Service Order No."));
            AJWebOrderHeader.Modify();
        end;
    end;

    procedure CreateOrder(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebCarrier: Record "AJ Web Carrier";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        AJWebService2: Record "AJ Web Service";
        AJWebOrderLine: Record "AJ Web Order Line";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
        AJWebService: Record "AJ Web Service";
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        JArray: JsonArray;
        JObject: JsonObject;
        AddJObject: JsonObject;
        JToken: JsonToken;
        Uri: Text;
        Txt: Text;
    begin
        if AJWebOrderHeader."Shipping Web Service Code" <> '' then
            AJWebService.Get(AJWebOrderHeader."Shipping Web Service Code")
        else
            AJWebService.Get(AJWebOrderHeader."Web Service Code");

        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        AJWebServiceWarehouse.Get(AJWebService.Code, AJWebOrderHeader."Ship-From Warehouse ID");

        if AJWebServiceWarehouse."Ship-From Country" = '' then
            AJWebServiceWarehouse."Ship-From Country" := 'US';
        if AJWebOrderHeader."Shipping Carrier Code" = '' then
            AJWebOrderHeader."Shipping Carrier Code" := AJWebServiceWarehouse."Def. Shipping Carrier Code";
        if AJWebOrderHeader."Shipping Carrier Service" = '' then
            AJWebOrderHeader."Shipping Carrier Service" := AJWebServiceWarehouse."Def. Shipping Carrier Service";
        if AJWebOrderHeader."Shipping Package Type" = '' then
            AJWebOrderHeader."Shipping Package Type" := CopyStr(AJWebServiceWarehouse."Def. Shipping Package Type", 1, MaxStrLen(AJWebOrderHeader."Shipping Package Type"));
        if AJWebOrderHeader."Shipping Delivery Confirm" = '' then
            AJWebOrderHeader."Shipping Delivery Confirm" := CopyStr(AJWebServiceWarehouse."Def. Shipping Delivery Confirm", 1, MaxStrLen(AJWebOrderHeader."Shipping Delivery Confirm"));
        if AJWebOrderHeader."Shipping Insutance Provider" = '' then
            AJWebOrderHeader."Shipping Insutance Provider" := CopyStr(AJWebServiceWarehouse."Def. Shipping Insutance Provd", 1, MaxStrLen(AJWebOrderHeader."Shipping Insutance Provider"));
        if (AJWebOrderHeader."Ship Date" = 0D) or (AJWebOrderHeader."Ship Date" < WorkDate()) then
            AJWebOrderHeader."Ship Date" := WorkDate();
        if AJWebOrderHeader."Ship-To Customer Country" = '' then
            AJWebOrderHeader."Ship-To Customer Country" := 'US';

        if AJWebOrderHeader."Bill-To Customer Country" = 'USA'
          then
            AJWebOrderHeader."Bill-To Customer Country" := 'US';
        if AJWebOrderHeader."Bill-To Customer Country" = '' then
            AJWebOrderHeader."Bill-To Customer Country" := 'US';

        AJWebOrderHeader."International Shipment" := AJWebOrderHeader."Ship-To Customer Country" <> 'US';

        AJWebOrderHeader.TestField("Ship-From Warehouse ID");
        AJWebOrderHeader.TestField("Shipping Carrier Code");
        AJWebOrderHeader.TestField("Shipping Carrier Service");
        AJWebOrderHeader.TestField("Shipping Package Type");
        AJWebOrderHeader.TestField("Shipping Delivery Confirm");

        Uri := AJWebService."API Endpoint Domain" + 'orders/createorder';

        Clear(JObject);
        //sdf
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderNumber', AJWebOrderHeader."Web Order No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderKey', AJWebOrderHeader."Web Order No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderDate', Format(DT2Date(AJWebOrderHeader."Order DateTime"), 0, '<Standard Format,9>'));
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderStatus', 'awaiting_shipment'); // awaiting_payment, awaiting_shipment,shipped,on_hold,cancelled

        if AJWebOrderHeader."Ship-To E-mail" <> '' then
            AJWebJsonHelper.JSONAddTxt(JObject, 'customerEmail', AJWebOrderHeader."Ship-To E-mail");

        //>> LABEL INFO

        AJWebJsonHelper.JSONAddTxt(JObject, 'carrierCode', AJWebOrderHeader."Shipping Carrier Code");
        AJWebJsonHelper.JSONAddTxt(JObject, 'serviceCode', AJWebOrderHeader."Shipping Carrier Service");
        AJWebJsonHelper.JSONAddTxt(JObject, 'packageCode', AJWebOrderHeader."Shipping Package Type");
        AJWebJsonHelper.JSONAddTxt(JObject, 'confirmation', AJWebOrderHeader."Shipping Delivery Confirm");

        if AJWebOrderHeader."Ship Date" = 0D then
            AJWebOrderHeader."Ship Date" := WorkDate();
        AJWebJsonHelper.JSONAddTxt(JObject, 'shipDate', Format(AJWebOrderHeader."Ship Date", 0, '<Standard Format,9>'));

        if AJWebOrderHeader."Shp. Product Weight" = 0 then begin
            AJWebOrderLine.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if AJWebOrderLine.FindFirst() then
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
                until AJWebOrderLine.Next() = 0;
        end;

        AJWebOrderHeader.TestField("Shp. Product Weight");
        AJWebOrderHeader.TestField("Shp. Product Weight Unit");

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddDec(AddJObject, 'value', AJWebOrderHeader."Shp. Product Weight");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJWebOrderHeader."Shp. Product Weight Unit");
        AJWebJsonHelper.JSONAddObject(JObject, 'weight', AddJObject);

        if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
            Clear(AddJObject);
            if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJWebOrderHeader."Shp. Product Dimension Unit");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'length', AJWebOrderHeader."Shp. Product Length");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'width', AJWebOrderHeader."Shp. Product Width");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'height', AJWebOrderHeader."Shp. Product Height");
                AJWebJsonHelper.JSONAddObject(JObject, 'dimensions', AddJObject);
            end else
                AJWebJsonHelper.JSONAddNULL(JObject, 'dimensions');
        end;

        if AJWebOrderHeader."Insure Shipment" then begin
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'provider', 'carrier');// "shipsurance" or "carrier"
            AJWebJsonHelper.JSONAddBool(AddJObject, 'insureShipment', true);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'insuredValue', AJWebOrderHeader."Insured Value");
            AJWebJsonHelper.JSONAddObject(JObject, 'insuranceOptions', AddJObject);
        end else begin
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'provider', 'carrier');
            AJWebJsonHelper.JSONAddBool(AddJObject, 'insureShipment', false);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'insuredValue', 0);
            AJWebJsonHelper.JSONAddObject(JObject, 'insuranceOptions', AddJObject);
        end;


        if AJWebOrderHeader."International Shipment" then begin
            SalesHeader.Reset();
            SalesHeader.SetFilter("Document Type", '%1|%2',
              SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
            SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if SalesHeader.FindFirst() then begin

                JArray := JToken.AsArray();

                SalesLine.Reset();
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("No.", '<>%1', '');
                SalesLine.SetFilter(Quantity, '<>%1', 0);
                SalesLine.SetFilter("Qty. to Ship", '<>0');
                if SalesLine.FindFirst() then
                    repeat

                        Item.Get(SalesLine."No.");

                        Clear(AddJObject);
                        AJWebJsonHelper.JSONAddTxt(AddJObject, 'description', Item.Description);
                        AJWebJsonHelper.JSONAddDec(AddJObject, 'quantity', SalesLine."Qty. to Ship");
                        AJWebJsonHelper.JSONAddDec(AddJObject, 'value', SalesLine."Unit Price");

                        JToken := AddJObject.AsToken();
                        JArray.Add(JToken);
                    until SalesLine.Next() = 0
                else
                    Error('No items to ship has been found!');

                Clear(AddJObject);
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'contents', 'merchandise');
                AddJObject.Add('customsItems', JArray);
                JObject.Add('internationalOptions', AddJObject);
            end;


        end else
            AJWebJsonHelper.JSONAddNULL(JObject, 'internationalOptions');

        //<< LABEL INFO

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJWebOrderHeader."Bill-To Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJWebOrderHeader."Bill-To Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJWebOrderHeader."Bill-To Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJWebOrderHeader."Bill-To Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJWebOrderHeader."Bill-To Customer Address 3"); //sdf check

        AJWebCarrier.Get(AJWebService.Code, AJWebOrderHeader."Shipping Carrier Code");

        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJWebOrderHeader."Bill-To Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJWebOrderHeader."Bill-To Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJWebOrderHeader."Bill-To Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJWebOrderHeader."Bill-To Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJWebOrderHeader."Bill-To Customer Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJWebOrderHeader."Bill-To Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'billTo', AddJObject);

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJWebOrderHeader."Ship-To Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJWebOrderHeader."Ship-To Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJWebOrderHeader."Ship-To Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJWebOrderHeader."Ship-To Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJWebOrderHeader."Ship-To Customer Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJWebOrderHeader."Ship-To Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJWebOrderHeader."Ship-To Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJWebOrderHeader."Ship-To Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJWebOrderHeader."Ship-To Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJWebOrderHeader."Ship-To Customer Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJWebOrderHeader."Ship-To Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'shipTo', AddJObject);

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'warehouseId', AJWebOrderHeader."Ship-From Warehouse ID");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'nonMachinable', AJWebOrderHeader."Non Machinable");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'saturdayDelivery', AJWebOrderHeader."Saturday Delivery");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'containsAlcohol', AJWebOrderHeader."Contains Alcohol");
        //AJWebJsonHelper.JSONAddTxt(AddJObject,'storeId','51791'); //MBS commented
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', AJWebOrderHeader."Web Service PO Number");   //sales order #
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', AJWebOrderHeader."Customer Reference ID");  //external document #

        AJWebService2.Get(AJWebOrderHeader."Web Service Code");
        if AJWebService2."Reference 3" <> AJWebService2."Reference 3"::PO then

            //>> COD
            AJWebOrderHeader."Custom Field 3" := CopyStr(IsCOD(AJWebOrderHeader), 1, MaxStrLen(AJWebOrderHeader."Custom Field 3"));

        if StrPos(UpperCase(UserId()), 'SK') > 0 then
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', 'CUSTOM3')
        else
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', AJWebOrderHeader."Custom Field 3");

        // take Bill-to default from WEB SERVICE, NOT SHIPPING WEB SERVICE
        AJWebCarrier.Get(AJWebOrderHeader."Web Service Code", AJWebOrderHeader."Shipping Carrier Code");
        if AJWebOrderHeader."Bill-to Type" <> 0 then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebOrderHeader."Bill-to Type"));
            if AJWebOrderHeader."Bill-to Type" = AJWebOrderHeader."Bill-to Type"::my_other_account then
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebOrderHeader."Bill-To Account")
            else
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJWebOrderHeader."Bill-To Account");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJWebOrderHeader."Bill-To Postal Code");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJWebOrderHeader."Bill-To Country Code");
        end else
            if AJWebCarrier."Bill-to Type" <> 0 then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebCarrier."Bill-to Type"));
                if AJWebCarrier."Bill-to Type" = AJWebCarrier."Bill-to Type"::my_other_account then
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebCarrier."Bill-to Account No.")
                else
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJWebCarrier."Bill-to Account No.");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJWebCarrier."Bill-to Account Post Code");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJWebCarrier."Bill-to Account Country Code");
            end;
        AJWebJsonHelper.JSONAddObject(JObject, 'advancedOptions', AddJObject);

        //>> COD
        if (IsCOD(AJWebOrderHeader) <> '') and (AJWebOrderHeader."COD Amount" <> 0) then begin
            // item
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'sku', 'COD');
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', 'COD amount');
            AJWebJsonHelper.JSONAddDec(AddJObject, 'quantity', 1);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'unitPrice', AJWebOrderHeader."COD Amount");

            JToken := AddJObject.AsToken();
            JArray := JToken.AsArray();

            JArray.Add(JToken);
            JObject.Add('items', JArray);
        end;
        //<< COD

        JObject.WriteTo(Txt);

        /* mbs commented. check!
        Encoding := SystemTextUTF8Encoding.UTF8Encoding(false);
        HttpWebRequest.ContentLength := Encoding.GetByteCount(Txt);        
        MemoryStream := HttpWebRequest.GetRequestStream();
        StreamWriter := StreamWriter.StreamWriter(MemoryStream, Encoding);
        StreamWriter.Write(Txt);
        StreamWriter.Flush();
        StreamWriter.Close();
        MemoryStream.Flush();
        MemoryStream.Close();               
        */

        if not AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt) then
            Error('Web service error:\%1', Txt);

        JObject.ReadFrom(Txt);
        if JObject.Contains('orderId') then begin
            AJWebOrderHeader."Shipping Web Service Order No." := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'orderId'), 1, MaxStrLen(AJWebOrderHeader."Shipping Web Service Order No."));
            AJWebOrderHeader.Modify();
        end;
    end;

    local procedure GetBillToTypeName(BillToType: Option) Txt: Text
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
    begin
        case BillToType of
            AJWebOrderHeader."Bill-to Type"::my_account:
                exit('my_account');
            AJWebOrderHeader."Bill-to Type"::my_other_account:
                exit('my_other_account');
            AJWebOrderHeader."Bill-to Type"::recipient:
                exit('recipient');
            AJWebOrderHeader."Bill-to Type"::third_party:
                exit('third_party');
            else
                Error('Unsupported bill-to type %1', BillToType);
        end;
    end;

    procedure IsCOD(AJWebOrderHeader: Record "AJ Web Order Header"): Text
    var
        PaymentTerms: Record "Payment Terms";
        AJWebCarrier: Record "AJ Web Carrier";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        //>> COD
        if not AJWebOrderHeader."Created From Sales Order" then
            exit;
        SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
        if not SalesHeader.FindFirst() then begin
            SalesInvoiceHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if not SalesInvoiceHeader.FindFirst() then
                exit;
            SalesHeader.TransferFields(SalesInvoiceHeader);
        end;
        if not PaymentTerms.Get(SalesHeader."Payment Terms Code") then
            exit;
        if not AJWebCarrier.Get(AJWebOrderHeader."Shipping Web Service Code", AJWebOrderHeader."Shipping Carrier Code") then
            exit;
        if not AJWebCarrier."Allow COD" then
            exit;
        if PaymentTerms."COD Type" = 0 then
            exit;
        case PaymentTerms."COD Type" of
            PaymentTerms."COD Type"::Any:
                exit('COD1');
            PaymentTerms."COD Type"::Cash:
                exit('COD2');
            PaymentTerms."COD Type"::MoneyOrderCheck:
                exit('COD3');
        end;
        //<< COD
    end;

    local procedure GetCountryCode("Code": Code[10]): Code[10]
    var
        CountryRegion: Record "Country/Region";
    begin
        if not CountryRegion.Get(Code) then
            exit(Code);
        exit(Code);
    end;

    local procedure Http_TryGetResponse(var HttpWebRequest: HttpRequestMessage; var HttpWebResponse: HttpResponseMessage): Boolean
    var
        HttpWebClient: HttpClient;
    begin
        exit(HttpWebClient.Send(HttpWebRequest, HttpWebResponse));
    end;
}
=======
            until AJWebCarrier.Next = 0;
    end;

}
>>>>>>> parent of 7df33c2... Merge branch 'master' of https://github.com/artkashin/GitHub
