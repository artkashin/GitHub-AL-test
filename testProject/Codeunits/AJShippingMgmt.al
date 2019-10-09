codeunit 37072304 "AJ Shipping Mgmt."
{

    var
    //AddressErr: Label 'Carrier %1 does not allow to ship with 3 address lines, \please change it to 2 lines.';
    //DoNotSendOrder: Boolean;
    /*
    local procedure CreateOrderForWeb(var AJShippingHeader: Record "AJ Shipping Header")
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
        if AJShippingHeader."Shipping Web Service Code" <> '' then
            AJWebService.Get(AJShippingHeader."Shipping Web Service Code")
        else
            AJWebService.Get(AJShippingHeader."Web Service Code");
        AJWebService.TestField("Web Service Type", AJWebService."Web Service Type"::ShipStation);
        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        //>> Additional Check
        if AJShippingHeader."Ship-To Customer Country" in ['USA', ''] then
            AJShippingHeader."Ship-To Customer Country" := 'US';
        if AJShippingHeader."Ship-From Customer Country" in ['USA', ''] then
            AJShippingHeader."Ship-From Customer Country" := 'US';

        AJWebCarrier.Get(AJWebService.Code, AJShippingHeader."Shipping Carrier Code");
        if AJWebCarrier."2 Lines Address only" and ((AJShippingHeader."Ship-From Customer Address 3" <> '')
          or (AJShippingHeader."Ship-To Customer Address 3" <> ''))
        then
            Error(StrSubstNo(AddressErr, AJWebCarrier.Code));
        //<< Additional Check

        Uri := AJWebService."API Endpoint Domain" + 'orders/createorder';


        //Clear(JObject);
        Clear(JObject);
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderNumber', AJShippingHeader."Shipping No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderKey', AJShippingHeader."Shipping No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderDate', Format(DT2Date(AJShippingHeader."Order DateTime"), 0, '<Standard Format,9>'));
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderStatus', 'awaiting_shipment');// awaiting_payment, awaiting_shipment,shipped,on_hold,cancelled
        if AJShippingHeader."Ship-To E-mail" <> '' then
            AJWebJsonHelper.JSONAddTxt(JObject, 'customerEmail', AJShippingHeader."Ship-To E-mail");

        Clear(AddJObject);

        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJShippingHeader."Ship-From Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJShippingHeader."Ship-From Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJShippingHeader."Ship-From Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJShippingHeader."Ship-From Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJShippingHeader."Ship-From Customer Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJShippingHeader."Ship-From Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJShippingHeader."Ship-From Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJShippingHeader."Ship-From Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJShippingHeader."Ship-From Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJShippingHeader."Ship-From Customer Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJShippingHeader."Ship-From Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'billTo', AddJObject);


        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJShippingHeader."Ship-To Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJShippingHeader."Ship-To Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJShippingHeader."Ship-To Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJShippingHeader."Ship-To Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJShippingHeader."Ship-To Customer Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJShippingHeader."Ship-To Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJShippingHeader."Ship-To Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJShippingHeader."Ship-To Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJShippingHeader."Ship-To Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJShippingHeader."Ship-To Customer Phone");

        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJShippingHeader."Ship-To Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'shipTo', AddJObject);

        //Clear(AddJObject);
        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'warehouseId', AJShippingHeader."Ship-From Warehouse ID");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'nonMachinable', AJShippingHeader."Non Machinable");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'saturdayDelivery', AJShippingHeader."Saturday Delivery");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'containsAlcohol', AJShippingHeader."Contains Alcohol");
        //AJWebJsonHelper.JSONAddTxt(AddJObject,'storeId',AJWebStore.Code); // MBS 12.09.2019 commented

        // we fill CustomFields with spec values for JCP
        AJWebService2.Get(AJShippingHeader."Web Service Code");
        if (AJShippingHeader."Custom Field 1" <> '') and (AJShippingHeader."Custom Field 2" <> '')
        then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', AJShippingHeader."Custom Field 1");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', AJShippingHeader."Custom Field 2");
        end else begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', AJShippingHeader."Web Service PO Number");   //sales order #
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', AJShippingHeader."Customer Reference ID");  //external document #
        end;

        AJWebService2.Get(AJShippingHeader."Web Service Code");
        if AJWebService2."Reference 3" = AJWebService2."Reference 3"::PO then
            AJShippingHeader."Custom Field 3" := AJShippingHeader."Web Service PO Number"
        else
            //>> COD
            AJShippingHeader."Custom Field 3" := CopyStr(IsCOD(AJShippingHeader), 1, MaxStrLen(AJShippingHeader."Custom Field 3"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', AJShippingHeader."Custom Field 3");
        //<< COD

        AJWebJsonHelper.JSONAddObject(JObject, 'advancedOptions', AddJObject);

        //>> COD
        if (IsCOD(AJShippingHeader) <> '') and (AJShippingHeader."COD Amount" <> 0) then begin
            // item            
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'sku', 'COD');
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', 'COD amount');
            AJWebJsonHelper.JSONAddDec(AddJObject, 'quantity', 1);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'unitPrice', AJShippingHeader."COD Amount");

            JArray := AddJObject.AsToken().AsArray();
            JArray.Add(JToken);
            JObject.Add('items', JArray.AsToken());
        end;
        //<< COD

        JObject.WriteTo(Txt);


        if not AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt) then
            Error('Web service error:\%1', Txt);

        JObject.ReadFrom(Txt);
        if JObject.Contains('orderId') then begin
            AJShippingHeader."Shipping Web Service Order No." := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'orderId'), 1, MaxStrLen(AJShippingHeader."Shipping Web Service Order No."));
            AJShippingHeader.Modify();
        end;
    end;

    procedure CreateOrder(var AJShippingHeader: Record "AJ Shipping Header")
    var
        AJWebCarrier: Record "AJ Web Carrier";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        AJWebService2: Record "AJ Web Service";
        AJShippingLine: Record "AJ Shipping Line";
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
        if AJShippingHeader."Shipping Web Service Code" <> '' then
            AJWebService.Get(AJShippingHeader."Shipping Web Service Code")
        else
            AJWebService.Get(AJShippingHeader."Web Service Code");

        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        AJWebServiceWarehouse.Get(AJWebService.Code, AJShippingHeader."Ship-From Warehouse ID");

        if AJWebServiceWarehouse."Ship-From Country" = '' then
            AJWebServiceWarehouse."Ship-From Country" := 'US';
        if AJShippingHeader."Shipping Carrier Code" = '' then
            AJShippingHeader."Shipping Carrier Code" := AJWebServiceWarehouse."Def. Shipping Carrier Code";
        if AJShippingHeader."Shipping Carrier Service" = '' then
            AJShippingHeader."Shipping Carrier Service" := AJWebServiceWarehouse."Def. Shipping Carrier Service";
        if AJShippingHeader."Shipping Package Type" = '' then
            AJShippingHeader."Shipping Package Type" := CopyStr(AJWebServiceWarehouse."Def. Shipping Package Type", 1, MaxStrLen(AJShippingHeader."Shipping Package Type"));
        if AJShippingHeader."Shipping Delivery Confirm" = '' then
            AJShippingHeader."Shipping Delivery Confirm" := CopyStr(AJWebServiceWarehouse."Def. Shipping Delivery Confirm", 1, MaxStrLen(AJShippingHeader."Shipping Delivery Confirm"));        
        if (AJShippingHeader."Ship Date" = 0D) or (AJShippingHeader."Ship Date" < WorkDate()) then
            AJShippingHeader."Ship Date" := WorkDate();
        if AJShippingHeader."Ship-To Customer Country" = '' then
            AJShippingHeader."Ship-To Customer Country" := 'US';

        if AJShippingHeader."Ship-From Customer Country" = 'USA'
          then
            AJShippingHeader."Ship-From Customer Country" := 'US';
        if AJShippingHeader."Ship-From Customer Country" = '' then
            AJShippingHeader."Ship-From Customer Country" := 'US';

        AJShippingHeader."International Shipment" := AJShippingHeader."Ship-To Customer Country" <> 'US';

        AJShippingHeader.TestField("Ship-From Warehouse ID");
        AJShippingHeader.TestField("Shipping Carrier Code");
        AJShippingHeader.TestField("Shipping Carrier Service");
        AJShippingHeader.TestField("Shipping Package Type");
        AJShippingHeader.TestField("Shipping Delivery Confirm");

        Uri := AJWebService."API Endpoint Domain" + 'orders/createorder';

        Clear(JObject);

        AJWebJsonHelper.JSONAddTxt(JObject, 'orderNumber', AJShippingHeader."Shipping No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderKey', AJShippingHeader."Shipping No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderDate', Format(DT2Date(AJShippingHeader."Order DateTime"), 0, '<Standard Format,9>'));
        AJWebJsonHelper.JSONAddTxt(JObject, 'orderStatus', 'awaiting_shipment'); // awaiting_payment, awaiting_shipment,shipped,on_hold,cancelled

        if AJShippingHeader."Ship-To E-mail" <> '' then
            AJWebJsonHelper.JSONAddTxt(JObject, 'customerEmail', AJShippingHeader."Ship-To E-mail");

        //>> LABEL INFO

        AJWebJsonHelper.JSONAddTxt(JObject, 'carrierCode', AJShippingHeader."Shipping Carrier Code");
        AJWebJsonHelper.JSONAddTxt(JObject, 'serviceCode', AJShippingHeader."Shipping Carrier Service");
        AJWebJsonHelper.JSONAddTxt(JObject, 'packageCode', AJShippingHeader."Shipping Package Type");
        AJWebJsonHelper.JSONAddTxt(JObject, 'confirmation', AJShippingHeader."Shipping Delivery Confirm");

        if AJShippingHeader."Ship Date" = 0D then
            AJShippingHeader."Ship Date" := WorkDate();
        AJWebJsonHelper.JSONAddTxt(JObject, 'shipDate', Format(AJShippingHeader."Ship Date", 0, '<Standard Format,9>'));

        if AJShippingHeader."Shp. Product Weight" = 0 then begin
            AJShippingLine.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
            if AJShippingLine.FindFirst() then
                repeat
                    if AJShippingLine.Weight = 0 then begin
                        AJWebCarrierPackageType.Get(AJWebService.Code, AJShippingHeader."Shipping Carrier Code", AJShippingHeader."Shipping Package Type");
                        AJShippingHeader."Shp. Product Weight" := AJWebCarrierPackageType."Def. Weight";
                        AJShippingHeader."Shp. Product Weight Unit" := AJWebCarrierPackageType."Def. Weight Unit";
                    end else
                        if (AJShippingHeader."Shp. Product Weight Unit" = '') then begin
                            AJShippingLine.TestField("Weigh Unit");
                            AJShippingHeader."Shp. Product Weight" := AJShippingLine.Weight;
                            AJShippingHeader."Shp. Product Weight Unit" := AJShippingLine."Weigh Unit";
                        end else
                            if AJShippingHeader."Shp. Product Weight Unit" = AJShippingLine."Weigh Unit" then
                                AJShippingHeader."Shp. Product Weight" += AJShippingLine.Weight
                            else
                                AJShippingHeader.TestField("Shp. Product Weight");
                until AJShippingLine.Next() = 0;
        end;

        AJShippingHeader.TestField("Shp. Product Weight");
        AJShippingHeader.TestField("Shp. Product Weight Unit");

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddDec(AddJObject, 'value', AJShippingHeader."Shp. Product Weight");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJShippingHeader."Shp. Product Weight Unit");
        AJWebJsonHelper.JSONAddObject(JObject, 'weight', AddJObject);

        if AJShippingHeader."Shp. Product Dimension Unit" <> '' then begin
            Clear(AddJObject);
            if AJShippingHeader."Shp. Product Dimension Unit" <> '' then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJShippingHeader."Shp. Product Dimension Unit");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'length', AJShippingHeader."Shp. Product Length");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'width', AJShippingHeader."Shp. Product Width");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'height', AJShippingHeader."Shp. Product Height");
                AJWebJsonHelper.JSONAddObject(JObject, 'dimensions', AddJObject);
            end else
                AJWebJsonHelper.JSONAddNULL(JObject, 'dimensions');
        end;

        if AJShippingHeader."Insure Shipment" then begin
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'provider', 'carrier');// "shipsurance" or "carrier"
            AJWebJsonHelper.JSONAddBool(AddJObject, 'insureShipment', true);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'insuredValue', AJShippingHeader."Insured Value");
            AJWebJsonHelper.JSONAddObject(JObject, 'insuranceOptions', AddJObject);
        end else begin
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'provider', 'carrier');
            AJWebJsonHelper.JSONAddBool(AddJObject, 'insureShipment', false);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'insuredValue', 0);
            AJWebJsonHelper.JSONAddObject(JObject, 'insuranceOptions', AddJObject);
        end;


        if AJShippingHeader."International Shipment" then begin
            SalesHeader.Reset();
            SalesHeader.SetFilter("Document Type", '%1|%2',
              SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
            SalesHeader.SetRange("Web Order No.", AJShippingHeader."Shipping No.");
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
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJShippingHeader."Ship-From Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJShippingHeader."Ship-From Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJShippingHeader."Ship-From Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJShippingHeader."Ship-From Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJShippingHeader."Ship-From Customer Address 3");

        AJWebCarrier.Get(AJWebService.Code, AJShippingHeader."Shipping Carrier Code");

        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJShippingHeader."Ship-From Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJShippingHeader."Ship-From Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJShippingHeader."Ship-From Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJShippingHeader."Ship-From Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJShippingHeader."Ship-From Customer Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJShippingHeader."Ship-From Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'billTo', AddJObject);

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJShippingHeader."Ship-To Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJShippingHeader."Ship-To Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJShippingHeader."Ship-To Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJShippingHeader."Ship-To Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJShippingHeader."Ship-To Customer Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJShippingHeader."Ship-To Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJShippingHeader."Ship-To Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJShippingHeader."Ship-To Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJShippingHeader."Ship-To Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJShippingHeader."Ship-To Customer Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJShippingHeader."Ship-To Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'shipTo', AddJObject);

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'warehouseId', AJShippingHeader."Ship-From Warehouse ID");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'nonMachinable', AJShippingHeader."Non Machinable");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'saturdayDelivery', AJShippingHeader."Saturday Delivery");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'containsAlcohol', AJShippingHeader."Contains Alcohol");
        //AJWebJsonHelper.JSONAddTxt(AddJObject,'storeId','51791'); //MBS commented
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', AJShippingHeader."Web Service PO Number");   //sales order #
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', AJShippingHeader."Customer Reference ID");  //external document #

        AJWebService2.Get(AJShippingHeader."Web Service Code");
        if AJWebService2."Reference 3" <> AJWebService2."Reference 3"::PO then

            //>> COD
            AJShippingHeader."Custom Field 3" := CopyStr(IsCOD(AJShippingHeader), 1, MaxStrLen(AJShippingHeader."Custom Field 3"));

        if StrPos(UpperCase(UserId()), 'SK') > 0 then
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', 'CUSTOM3')
        else
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', AJShippingHeader."Custom Field 3");

        // take Ship-From default from WEB SERVICE, NOT SHIPPING WEB SERVICE
        AJWebCarrier.Get(AJShippingHeader."Web Service Code", AJShippingHeader."Shipping Carrier Code");
        if AJShippingHeader."Ship-From Type" <> 0 then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJShippingHeader."Ship-From Type"));
            if AJShippingHeader."Ship-From Type" = AJShippingHeader."Ship-From Type"::my_other_account then
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJShippingHeader."Ship-From Account")
            else
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJShippingHeader."Ship-From Account");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJShippingHeader."Ship-From Postal Code");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJShippingHeader."Ship-From Country Code");
        end else
            if AJWebCarrier."Ship-From Type" <> 0 then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebCarrier."Ship-From Type"));
                if AJWebCarrier."Ship-From Type" = AJWebCarrier."Ship-From Type"::my_other_account then
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebCarrier."Ship-From Account No.")
                else
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJWebCarrier."Ship-From Account No.");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJWebCarrier."Ship-From Account Post Code");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJWebCarrier."Ship-From Account Country Code");
            end;
        AJWebJsonHelper.JSONAddObject(JObject, 'advancedOptions', AddJObject);

        //>> COD
        if (IsCOD(AJShippingHeader) <> '') and (AJShippingHeader."COD Amount" <> 0) then begin
            // item
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'sku', 'COD');
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', 'COD amount');
            AJWebJsonHelper.JSONAddDec(AddJObject, 'quantity', 1);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'unitPrice', AJShippingHeader."COD Amount");

            JToken := AddJObject.AsToken();
            JArray := JToken.AsArray();

            JArray.Add(JToken);
            JObject.Add('items', JArray);
        end;
        //<< COD

        JObject.WriteTo(Txt);

        if not AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt) then
            Error('Web service error:\%1', Txt);

        JObject.ReadFrom(Txt);
        if JObject.Contains('orderId') then begin
            AJShippingHeader."Shipping Web Service Order No." := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'orderId'), 1, MaxStrLen(AJShippingHeader."Shipping Web Service Order No."));
            AJShippingHeader.Modify();
        end;
    end;


    procedure GetOrderLabel(var AJShippingHeader: Record "AJ Shipping Header")
    var
        AJWebService: Record "AJ Web Service";
        AJShippingLine: Record "AJ Shipping Line";
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

        if AJShippingHeader."Ship Date" <> Today() then begin
            AJShippingHeader.Validate("Ship Date", Today());
            AJShippingHeader.Modify(false);
        end;

        if (not DoNotSendOrder) and (AJShippingHeader."COD Status" = AJShippingHeader."COD Status"::" ") then
            if AJShippingHeader."Created From Sales Order" or
            (AJShippingHeader."Shipping Web Service Code" <> AJShippingHeader."Web Service Code")
            then begin
                CreateOrderForWeb(AJShippingHeader);
                Commit();

            end;

        if AJShippingHeader."Shipping Web Service Order No." = '' then begin
            CreateOrder(AJShippingHeader);
            Commit();
        end;

        AJShippingHeader.TestField("Shipping Web Service Order No.");

        AJWebService.Get(AJShippingHeader."Web Service Code");

        AJShippingHeader.TestField("Shipping Carrier Code");
        AJShippingHeader.TestField("Shipping Carrier Service");
        AJShippingHeader.TestField("Shipping Package Type");
        AJShippingHeader.TestField("Shipping Delivery Confirm");

        AJWebService.TestField("API Endpoint Domain");
        AJWebService.TestField("API Encoded String");

        Uri := AJWebService."API Endpoint Domain" + 'orders/createlabelfororder';

        JToken := JValue.AsToken();
        Clear(JObject);

        AJWebJsonHelper.JSONAddTxtasDec(JObject, 'orderId', AJShippingHeader."Shipping Web Service Order No.");
        AJWebJsonHelper.JSONAddTxt(JObject, 'carrierCode', AJShippingHeader."Shipping Carrier Code");
        AJWebJsonHelper.JSONAddTxt(JObject, 'serviceCode', AJShippingHeader."Shipping Carrier Service");
        AJWebJsonHelper.JSONAddTxt(JObject, 'packageCode', AJShippingHeader."Shipping Package Type");
        AJWebJsonHelper.JSONAddTxt(JObject, 'confirmation', AJShippingHeader."Shipping Delivery Confirm");

        if AJShippingHeader."Ship Date" = 0D then
            AJShippingHeader."Ship Date" := WorkDate();
        AJWebJsonHelper.JSONAddTxt(JObject, 'shipDate', Format(AJShippingHeader."Ship Date", 0, '<Standard Format,9>'));

        if AJShippingHeader."Shp. Product Weight" = 0 then begin
            AJShippingLine.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
            if AJShippingLine.FindFirst() then
                repeat
                    if AJShippingLine.Weight = 0 then begin
                        AJWebCarrierPackageType.Get(AJWebService.Code, AJShippingHeader."Shipping Carrier Code", AJShippingHeader."Shipping Package Type");
                        AJShippingHeader."Shp. Product Weight" := AJWebCarrierPackageType."Def. Weight";
                        AJShippingHeader."Shp. Product Weight Unit" := AJWebCarrierPackageType."Def. Weight Unit";
                    end else
                        if (AJShippingHeader."Shp. Product Weight Unit" = '') then begin
                            AJShippingLine.TestField("Weigh Unit");
                            AJShippingHeader."Shp. Product Weight" := AJShippingLine.Weight;
                            AJShippingHeader."Shp. Product Weight Unit" := AJShippingLine."Weigh Unit";
                        end else
                            if AJShippingHeader."Shp. Product Weight Unit" = AJShippingLine."Weigh Unit" then
                                AJShippingHeader."Shp. Product Weight" += AJShippingLine.Weight
                            else
                                AJShippingHeader.TestField("Shp. Product Weight");
                until AJShippingLine.Next() = 0;
        end;

        AJShippingHeader.TestField("Shp. Product Weight");
        AJShippingHeader.TestField("Shp. Product Weight Unit");

        Clear(AddJObject);

        AJWebJsonHelper.JSONAddDec(AddJObject, 'value', AJShippingHeader."Shp. Product Weight");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJShippingHeader."Shp. Product Weight Unit");
        AJWebJsonHelper.JSONAddObject(JObject, 'weight', AddJObject);

        if AJShippingHeader."Shp. Product Dimension Unit" = '' then
            if not SkipDefaultDimensions then begin
                AJWebCarrierPackageType.Get(AJWebService.Code, AJShippingHeader."Shipping Carrier Code", AJShippingHeader."Shipping Package Type");
                AJShippingHeader."Shp. Product Dimension Unit" := AJWebCarrierPackageType."Def. Dimension Unit";
                AJShippingHeader."Shp. Product Width" := AJWebCarrierPackageType."Def. Width";
                AJShippingHeader."Shp. Product Length" := AJWebCarrierPackageType."Def. Length";
                AJShippingHeader."Shp. Product Height" := AJWebCarrierPackageType."Def. Height";
            end;

        if AJShippingHeader."Shp. Product Dimension Unit" <> '' then begin
            Clear(AddJObject);
            if AJShippingHeader."Shp. Product Dimension Unit" <> '' then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJShippingHeader."Shp. Product Dimension Unit");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'length', AJShippingHeader."Shp. Product Length");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'width', AJShippingHeader."Shp. Product Width");
                AJWebJsonHelper.JSONAddDec(AddJObject, 'height', AJShippingHeader."Shp. Product Height");
                AJWebJsonHelper.JSONAddObject(JObject, 'dimensions', AddJObject);
            end else
                AJWebJsonHelper.JSONAddNULL(JObject, 'dimensions');
        end;

        if AJShippingHeader."Insure Shipment" then begin
            Clear(AddJObject);
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'provider', 'carrier');// "shipsurance" or "carrier"
            AJWebJsonHelper.JSONAddBool(AddJObject, 'insureShipment', true);
            AJWebJsonHelper.JSONAddDec(AddJObject, 'insuredValue', AJShippingHeader."Insured Value" + AJShippingHeader."Additional Insurance Value");
            AJWebJsonHelper.JSONAddObject(JObject, 'insuranceOptions', AddJObject);
        end else
            AJWebJsonHelper.JSONAddNULL(JObject, 'insuranceOptions');

        if AJShippingHeader."International Shipment" then begin

            SalesHeader.Reset();
            SalesHeader.SetFilter("Document Type", '%1|%2',
            SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
            SalesHeader.SetRange("Web Order No.", AJShippingHeader."Shipping No.");
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
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'warehouseId', AJShippingHeader."Ship-From Warehouse ID");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'nonMachinable', AJShippingHeader."Non Machinable");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'saturdayDelivery', AJShippingHeader."Saturday Delivery");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'containsAlcohol', AJShippingHeader."Contains Alcohol");
        //AJWebJsonHelper.JSONAddTxt(AddJObject,'storeId', '51791'); // MBS commented

        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.", AJShippingHeader."Shipping No.");
        if SalesHeader.FindFirst() then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField1', SalesHeader."No.");   //sales order #
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField2', SalesHeader."External Document No.");  //external document #
        end;

        AJWebJsonHelper.JSONAddTxt(AddJObject, 'customField3', AJShippingHeader."Custom Field 3");

        //for third party billing
        if AJShippingHeader."Ship-From Type" <> 0 then begin
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJShippingHeader."Ship-From Type"));
            if AJShippingHeader."Ship-From Type" = AJShippingHeader."Ship-From Type"::my_other_account then
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJShippingHeader."Ship-From Account")
            else
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJShippingHeader."Ship-From Account");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJShippingHeader."Ship-From Postal Code");
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJShippingHeader."Ship-From Country Code");
        end else begin
            // take Ship-From default from WEB SERVICE, NOT SHIPPING WEB SERVICE
            AJWebCarrier.Get(AJShippingHeader."Web Service Code", AJShippingHeader."Shipping Carrier Code");
            if AJWebCarrier."Ship-From Type" <> 0 then begin
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToParty', GetBillToTypeName(AJWebCarrier."Ship-From Type"));
                if AJWebCarrier."Ship-From Type" = AJWebCarrier."Ship-From Type"::my_other_account then
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToMyOtherAccount', AJWebCarrier."Ship-From Account No.")
                else
                    AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToAccount', AJWebCarrier."Ship-From Account No.");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToPostalCode', AJWebCarrier."Ship-From Account Post Code");
                AJWebJsonHelper.JSONAddTxt(AddJObject, 'billToCountryCode', AJWebCarrier."Ship-From Account Country Code");
                AJShippingHeader."Ship-From Type" := AJWebCarrier."Ship-From Type";
                AJShippingHeader."Ship-From Account" := AJWebCarrier."Ship-From Account No.";
                AJShippingHeader."Ship-From Postal Code" := CopyStr(AJWebCarrier."Ship-From Account Post Code", 1, MaxStrLen(AJShippingHeader."Ship-From Postal Code"));
                AJShippingHeader."Ship-From Country Code" := AJWebCarrier."Ship-From Account Country Code";
            end;
        end;
        AJWebJsonHelper.JSONAddObject(JObject, 'advancedOptions', AddJObject);

        // "Fedex does not support test labels at this time."
        if LowerCase(AJShippingHeader."Shipping Carrier Code") <> 'fedex' then
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

            AJShippingHeader."Shipping Agent Label".CreateOutStream(OutStr);
            Base64Convert.FromBase64StringToStream(LabelPdf, OutStr);

            AJShippingHeader."Carier Shipping Charge" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'shipmentCost');
            AJShippingHeader."Carier Tracking Number" := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'trackingNumber'), 1, MaxStrLen(AJShippingHeader."Carier Tracking Number"));
            AJShippingHeader."Carier Insurance Cost" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'insuranceCost');
        end;

        AJShippingHeader."Web Service Shipment ID" := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'shipmentId'), 1, MaxStrLen(AJShippingHeader."Web Service Shipment ID"));
        AJShippingHeader."Labels Created" := true;
        AJShippingHeader."Labels Printed" := false;
        AJShippingHeader.Modify();
    end;
    */
    procedure GetLabel(var AJShippingHeader: Record "AJ Shipping Header")
    var
        AJWebService: Record "AJ Web Service";
        //AJShippingLine: Record "AJ Shipping Line";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
        AJWebJsonHelper: Codeunit "AJ Web Json Helper";
        AJWebServiceBase: Codeunit "AJ Web Service Base";
        Base64Convert: Codeunit Base64Convert;
        ValueJToken: JsonToken;
        JObject: JsonObject;
        AddJObject: JsonObject;
        OutStr: OutStream;
        Uri: Text;
        Txt: Text;
        LabelPdf: Text;
    begin
        AJWebService.GET(AJShippingHeader."Shipping Web Service Code");
        AJWebService.TESTFIELD("Web Service Type", AJWebService."Web Service Type"::ShipStation);
        AJWebService.TESTFIELD("API Endpoint Domain");
        AJWebService.TESTFIELD("API Encoded String");

        AJWebServiceWarehouse.GET(AJShippingHeader."Shipping Web Service Code", AJShippingHeader."Ship-From Warehouse ID");
        IF AJWebServiceWarehouse."Ship-From Country" = '' THEN
            AJWebServiceWarehouse."Ship-From Country" := 'US';
        IF AJShippingHeader."Shipping Carrier Code" = '' THEN
            AJShippingHeader."Shipping Carrier Code" := AJWebServiceWarehouse."Def. Shipping Carrier Code";
        IF AJShippingHeader."Shipping Carrier Service" = '' THEN
            AJShippingHeader."Shipping Carrier Service" := AJWebServiceWarehouse."Def. Shipping Carrier Service";
        if AJShippingHeader."Shipping Package Type" = '' then
            AJShippingHeader."Shipping Package Type" := CopyStr(AJWebServiceWarehouse."Def. Shipping Package Type", 1, MaxStrLen(AJShippingHeader."Shipping Package Type"));
        if AJShippingHeader."Shipping Delivery Confirm" = '' then
            AJShippingHeader."Shipping Delivery Confirm" := CopyStr(AJWebServiceWarehouse."Def. Shipping Delivery Confirm", 1, MaxStrLen(AJShippingHeader."Shipping Delivery Confirm"));
        IF (AJShippingHeader."Ship Date" = 0D) OR (AJShippingHeader."Ship Date" < WorkDate()) THEN
            AJShippingHeader."Ship Date" := WorkDate();
        IF AJShippingHeader."Ship-To Customer Country" = '' THEN
            AJShippingHeader."Ship-To Customer Country" := 'US';

        AJShippingHeader.TESTFIELD("Web Service Order ID");
        AJShippingHeader.TESTFIELD("Ship-From Warehouse ID");
        AJShippingHeader.TESTFIELD("Shipping Carrier Code");
        AJShippingHeader.TESTFIELD("Shipping Carrier Service");
        AJShippingHeader.TESTFIELD("Shipping Package Type");
        AJShippingHeader.TESTFIELD("Shipping Delivery Confirm");

        Uri := AJWebService."API Endpoint Domain" + 'shipments/createlabel';

        Clear(JObject);
        AJWebJsonHelper.JSONAddTxt(JObject, 'carrierCode', AJShippingHeader."Shipping Carrier Code");
        AJWebJsonHelper.JSONAddTxt(JObject, 'serviceCode', AJShippingHeader."Shipping Carrier Service");
        AJWebJsonHelper.JSONAddTxt(JObject, 'packageCode', AJShippingHeader."Shipping Package Type");
        AJWebJsonHelper.JSONAddTxt(JObject, 'confirmation', AJShippingHeader."Shipping Delivery Confirm");
        AJWebJsonHelper.JSONAddTxt(JObject, 'shipDate', FORMAT(AJShippingHeader."Ship Date", 0, '<Standard Format,9>'));

        Clear(AddJObject);
        /*
        IF AJShippingHeader."Shp. Product Weight" = 0 THEN BEGIN
            AJShippingLine.SETRANGE("Shipping No.", AJShippingHeader."Shipping No.");
            IF AJShippingLine.FINDFIRST() THEN
                REPEAT
                    IF AJShippingLine.Weight = 0 THEN BEGIN
                        AJWebCarrierPackageType.GET(AJShippingHeader."Shipping Web Service Code", AJShippingHeader."Shipping Carrier Code", AJShippingHeader."Shipping Package Type");
                        AJShippingHeader."Shp. Product Weight" := AJWebCarrierPackageType."Def. Weight";
                        AJShippingHeader."Shp. Product Weight Unit" := AJWebCarrierPackageType."Def. Weight Unit";
                    END ELSE
                        IF (AJShippingHeader."Shp. Product Weight Unit" = '') THEN BEGIN
                            AJShippingLine.TESTFIELD("Weigh Unit");
                            AJShippingHeader."Shp. Product Weight" := AJShippingLine.Weight;
                            AJShippingHeader."Shp. Product Weight Unit" := AJShippingLine."Weigh Unit";
                        END ELSE
                            IF AJShippingHeader."Shp. Product Weight Unit" = AJShippingLine."Weigh Unit" THEN
                                AJShippingHeader."Shp. Product Weight" += AJShippingLine.Weight
                            ELSE
                                AJShippingHeader.TESTFIELD("Shp. Product Weight");
                UNTIL AJShippingLine.NEXT() = 0;            
        END;
        */
        AJShippingHeader.TESTFIELD("Shp. Product Weight");
        AJWebJsonHelper.JSONAddDec(AddJObject, 'value', AJShippingHeader."Shp. Product Weight");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJShippingHeader."Shp. Product Weight Unit");
        AJWebJsonHelper.JSONAddObject(JObject, 'weight', AddJObject);

        IF AJShippingHeader."Shp. Product Dimension Unit" = '' THEN BEGIN
            AJWebCarrierPackageType.GET(AJShippingHeader."Shipping Web Service Code", AJShippingHeader."Shipping Carrier Code", AJShippingHeader."Shipping Package Type");
            AJShippingHeader."Shp. Product Dimension Unit" := AJWebCarrierPackageType."Def. Dimension Unit";
            AJShippingHeader."Shp. Product Width" := AJWebCarrierPackageType."Def. Width";
            AJShippingHeader."Shp. Product Length" := AJWebCarrierPackageType."Def. Length";
            AJShippingHeader."Shp. Product Height" := AJWebCarrierPackageType."Def. Height";
        END;

        Clear(AddJObject);
        IF AJShippingHeader."Shp. Product Dimension Unit" <> '' THEN BEGIN
            AJWebJsonHelper.JSONAddTxt(AddJObject, 'units', AJShippingHeader."Shp. Product Dimension Unit");
            AJWebJsonHelper.JSONAddDec(AddJObject, 'length', AJShippingHeader."Shp. Product Length");
            AJWebJsonHelper.JSONAddDec(AddJObject, 'width', AJShippingHeader."Shp. Product Width");
            AJWebJsonHelper.JSONAddDec(AddJObject, 'height', AJShippingHeader."Shp. Product Height");
            AJWebJsonHelper.JSONAddObject(JObject, 'dimensions', AddJObject);
        END ELSE
            AJWebJsonHelper.JSONAddNULL(JObject, 'dimensions');

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJWebServiceWarehouse."Ship-From Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJWebServiceWarehouse."Ship-From Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJWebServiceWarehouse."Ship-From Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJWebServiceWarehouse."Ship-From Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJWebServiceWarehouse."Ship-From Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJWebServiceWarehouse."Ship-From City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJWebServiceWarehouse."Ship-From State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJWebServiceWarehouse."Ship-From Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(CopyStr(AJWebServiceWarehouse."Ship-From Country", 1, 10)));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJWebServiceWarehouse."Ship-From Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJWebServiceWarehouse."Ship-From Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'shipFrom', AddJObject);

        Clear(AddJObject);
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'name', AJShippingHeader."Ship-To Customer Name");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'company', AJShippingHeader."Ship-To Company");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street1', AJShippingHeader."Ship-To Customer Address 1");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street2', AJShippingHeader."Ship-To Customer Address 2");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'street3', AJShippingHeader."Ship-To Customer Address 3");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'city', AJShippingHeader."Ship-To Customer City");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'state', AJShippingHeader."Ship-To Customer State");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'postalCode', AJShippingHeader."Ship-To Customer Zip");
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'country', GetCountryCode(AJShippingHeader."Ship-To Customer Country"));
        AJWebJsonHelper.JSONAddTxt(AddJObject, 'phone', AJShippingHeader."Ship-To Customer Phone");
        AJWebJsonHelper.JSONAddBool(AddJObject, 'residential', AJShippingHeader."Ship-To Residential");
        AJWebJsonHelper.JSONAddObject(JObject, 'shipTo', AddJObject);

        AJWebJsonHelper.JSONAddNULL(JObject, 'insuranceOptions');

        IF AJShippingHeader."International Shipment" THEN
            ERROR('International Not Supported.')
        ELSE
            AJWebJsonHelper.JSONAddNULL(JObject, 'internationalOptions');

        AJWebJsonHelper.JSONAddNULL(JObject, 'advancedOptions');
        AJWebJsonHelper.JSONAddBool(JObject, 'testLabel', FALSE);

        JObject.WriteTo(Txt);

        if not AJWebServiceBase.CallWebService(AJWebService, Uri, 'POST', 'application/json', Txt) then begin
            JObject.ReadFrom(Txt);
            if JObject.Get('ExceptionMessage', ValueJToken) then
                Error('Web service error:\%1', ValueJToken.AsValue().AsText())
            else
                Error('Web service error:\%1', Txt);
        end;

        JObject.ReadFrom(Txt);

        IF JObject.Contains('labelData') THEN BEGIN
            LabelPdf := AJWebJsonHelper.GetJsonValueAsText(JObject, 'labelData');

            AJShippingHeader."Shipping Agent Label".CreateOutStream(OutStr);
            Base64Convert.FromBase64StringToStream(LabelPdf, OutStr);

            AJShippingHeader."Carier Shipping Charge" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'shipmentCost');
            AJShippingHeader."Carier Tracking Number" := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'trackingNumber'), 1, MaxStrLen(AJShippingHeader."Carier Tracking Number"));
            AJShippingHeader."Carier Insurance Cost" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'insuranceCost');

            AJShippingHeader."Carier Shipping Charge" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'shipmentCost');
            AJShippingHeader."Carier Tracking Number" := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'trackingNumber'), 1, MAXSTRLEN(AJShippingHeader."Carier Tracking Number"));
            AJShippingHeader."Carier Insurance Cost" := AJWebJsonHelper.GetJsonValueAsDec(JObject, 'insuranceCost');
        END;

        AJShippingHeader."Web Service Shipment ID" := CopyStr(AJWebJsonHelper.GetJsonValueAsText(JObject, 'shipmentId'), 1, MAXSTRLEN(AJShippingHeader."Web Service Shipment ID"));
        AJShippingHeader."Labels Created" := TRUE;
        AJShippingHeader."Labels Printed" := FALSE;

        AJShippingHeader.MODIFY();
    end;
    /*
    procedure CreateWebOrderFromSalesOrder(var SalesHeader: Record "Sales Header"; var AJShippingHeader: Record "AJ Shipping Header")
    var
        SalesLine: Record "Sales Line";
        AJShippingLine: Record "AJ Shipping Line";
        Customer: Record Customer;
        Currency: Record Currency;
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        AJWebService: Record "AJ Web Service";
    begin
        if AJShippingHeader."Shipping No." = '' then begin
            AJShippingHeader."Created From Sales Order" := true;
            AJShippingHeader.Insert(true);
        end;

        // IF SalesHeader."Ship-to Phone No." = '' THEN // mbs commented
        //  IF ShiptoAddress.GET(SalesHeader."Sell-to Customer No.",SalesHeader."Ship-to Code") THEN
        //    SalesHeader."Ship-to Phone No." := ShiptoAddress."Phone No.";
        //
        // IF SalesHeader."Ship-to Phone No." = '' THEN // mbs commented
        //  IF Customer.GET(SalesHeader."Sell-to Customer No.") THEN
        //    SalesHeader."Ship-to Phone No." := Customer."Phone No.";

        if AJShippingHeader."Web Service PO Number" = '' then
            AJShippingHeader."Web Service PO Number" := SalesHeader."No.";
        if AJShippingHeader."Customer Reference ID" = '' then
            AJShippingHeader."Customer Reference ID" := SalesHeader."External Document No.";
        AJShippingHeader."Custom Field 1" := 'ID: ' + SalesHeader."Sell-to Customer No." + ' DOC: ' + SalesHeader."No.";
        AJShippingHeader."Custom Field 2" := SalesHeader."Your Reference";

        AJShippingHeader."Custom Field 3" := SalesHeader."External Document No.";

        AJShippingHeader."Order DateTime" := CreateDateTime(SalesHeader."Order Date", 0T);

        AJShippingHeader."Bill-To Customer Name" := SalesHeader."Bill-to Name";
        AJShippingHeader."Bill-To Company" := CopyStr(SalesHeader."Bill-to Name", 1, MaxStrLen(AJShippingHeader."Bill-To Company"));
        AJShippingHeader."Bill-To Customer Address 1" := SalesHeader."Bill-to Address";
        AJShippingHeader."Bill-To Customer Address 2" := SalesHeader."Bill-to Address 2";
        AJShippingHeader."Bill-To Customer Address 3" := '';
        AJShippingHeader."Bill-To Customer City" := SalesHeader."Bill-to City";
        AJShippingHeader."Bill-To Customer State" := CopyStr(SalesHeader."Bill-to County", 1, MaxStrLen(AJShippingHeader."Bill-To Customer State"));
        AJShippingHeader."Bill-To Customer Zip" := CopyStr(SalesHeader."Bill-to Post Code", 1, MaxStrLen(AJShippingHeader."Bill-To Customer Zip"));
        AJShippingHeader."Bill-To Customer Country" := SalesHeader."Bill-to Country/Region Code";
        AJShippingHeader."Bill-To Customer Phone" := '';
        if Customer.Get(SalesHeader."Bill-to Customer No.") then
            AJShippingHeader."Bill-To Customer Phone" := Customer."Phone No.";
        AJShippingHeader."Bill-To Residential" := false;

        AJShippingHeader."Ship-To Customer Name" := SalesHeader."Ship-to Name";
        AJShippingHeader."Ship-To Company" := SalesHeader."Ship-to Name";
        AJShippingHeader."Ship-To Customer Address 1" := SalesHeader."Ship-to Address";
        if AJShippingHeader."Ship-To Customer Address 1" = '' then
            AJShippingHeader."Ship-To Customer Address 1" := SalesHeader."Ship-to Address 2"
        else
            AJShippingHeader."Ship-To Customer Address 2" := SalesHeader."Ship-to Address 2";
        AJShippingHeader."Ship-To Customer Address 3" := '';
        AJShippingHeader."Ship-To Customer City" := SalesHeader."Ship-to City";
        AJShippingHeader."Ship-To Customer State" := CopyStr(SalesHeader."Ship-to County", 1, MaxStrLen(AJShippingHeader."Ship-To Customer State"));
        AJShippingHeader."Ship-To Customer Zip" := CopyStr(SalesHeader."Ship-to Post Code", 1, MaxStrLen(AJShippingHeader."Ship-To Customer Zip"));
        AJShippingHeader."Ship-To Customer Country" := SalesHeader."Ship-to Country/Region Code";
        //AJShippingHeader."Ship-To Customer Phone" := SalesHeader."Ship-to Phone No.";
        AJShippingHeader."Ship-To Residential" := false;
        //AJShippingHeader."Ship-To E-mail" := SalesHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesHeader."Salesperson Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJShippingHeader."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJShippingHeader."Ship-To E-mail") then
                if AJShippingHeader."Ship-To E-mail" = '' then
                    AJShippingHeader."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJShippingHeader."Ship-To E-mail"))
                else
                    AJShippingHeader."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";


        if not AJWebService.Get(AJShippingHeader."Shipping Web Service Code") then
            AJWebService.Init();

        AJShippingHeader."Merchandise Amount" := 0;
        // MBS commented >>
        // IF (SalesHeader."Shipping Agent Code" <> '') AND (SalesHeader."Shipping Agent Service Code" <> '') THEN
        //  IF ShippingAgentServices.GET(SalesHeader."Shipping Agent Code", SalesHeader."Shipping Agent Service Code") THEN
        //     AJShippingHeader."Saturday Delivery" := ShippingAgentServices."Saturday Delivery";
        // MBS commented <<
        AJShippingHeader.Modify();

        AJShippingHeader.TestField("Ship-To Customer Address 1");

        if AJShippingHeader."Created From Sales Order" then begin
            AJShippingLine.Reset();
            AJShippingLine.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
            if not AJShippingLine.IsEmpty() then
                AJShippingLine.DeleteAll(true);

            Currency.InitRoundingPrecision();
            AJShippingHeader."Merchandise Amount" := 0;
            if SalesHeader."Document Type" = -1 then begin
                SalesInvoiceLine.Reset();
                SalesInvoiceLine.SetRange("Document No.", SalesHeader."No.");
                SalesInvoiceLine.SetRange(Type, SalesLine.Type::Item);
                SalesInvoiceLine.SetFilter("No.", '<>%1', '');
                SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
                if SalesInvoiceLine.FindFirst() then
                    repeat
                        AJShippingLine.Init();
                        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
                        AJShippingLine."Line No." := SalesInvoiceLine."Line No.";
                        AJShippingLine."Source ID" := SalesInvoiceLine."No.";
                        AJShippingLine.Quantity := SalesInvoiceLine.Quantity;
                        AJShippingLine."Unit Price" := Round(SalesInvoiceLine."Amount Including VAT" / SalesInvoiceLine.Quantity, 0.001);
                        AJShippingLine.Insert();
                        AJShippingHeader."Merchandise Amount" += AJShippingLine.Quantity * AJShippingLine."Unit Price";
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
                        AJShippingLine.Init();
                        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
                        AJShippingLine."Line No." := SalesLine."Line No.";
                        AJShippingLine."Source ID" := SalesLine."No.";
                        AJShippingLine.Quantity := SalesLine."Qty. to Ship";
                        AJShippingLine."Unit Price" := Round(SalesLine."Amount Including VAT" / SalesLine.Quantity, Currency."Unit-Amount Rounding Precision");
                        AJShippingLine.Description := SalesLine.Description;
                        AJShippingLine.Insert();

                        AJShippingHeader."Merchandise Amount" += AJShippingLine.Quantity * AJShippingLine."Unit Price";
                    until SalesLine.Next() = 0;
            end;
            AJShippingHeader."Merchandise Amount" := Round(AJShippingHeader."Merchandise Amount", Currency."Amount Rounding Precision"); // 4/12/2018
            AJShippingHeader."NAV Order Status" := AJShippingHeader."NAV Order Status"::Created;
            AJShippingHeader.Modify();
        end;

        CreateOrder(AJShippingHeader);
    end;

    procedure SaveLabel(AJShippingHeader: Record "AJ Shipping Header")
    var
        IS: InStream;
        ToFile: Text;
    begin
        AJShippingHeader.Find();
        AJShippingHeader.CalcFields("Shipping Agent Label");
        if AJShippingHeader."Shipping Agent Label".HasValue() then begin
            AJShippingHeader."Shipping Agent Label".CreateInStream(IS);
            ToFile := 'LBL-' + AJShippingHeader."Shipping No." + '.pdf';
            DownloadFromStream(IS, 'Save label as', 'C:\', 'Adobe Acrobat file(*.pdf)|*.pdf', ToFile);
        end;
    end;

    procedure GetOrderLabelParam(NewDoNotSendOrder: Boolean)
    begin
        DoNotSendOrder := NewDoNotSendOrder;
    end;

    local procedure GetBillToTypeName(BillToType: Option) Txt: Text
    var
        AJShippingHeader: Record "AJ Shipping Header";
    begin
        case BillToType of
            AJShippingHeader."Bill-to Type"::my_account:
                exit('my_account');
            AJShippingHeader."Bill-to Type"::my_other_account:
                exit('my_other_account');
            AJShippingHeader."Bill-to Type"::recipient:
                exit('recipient');
            AJShippingHeader."Bill-to Type"::third_party:
                exit('third_party');
            else
                Error('Unsupported bill-to type %1', BillToType);
        end;
    end;
    */
    procedure IsCOD(AJShippingHeader: Record "AJ Shipping Header"): Text
    var
        PaymentTerms: Record "Payment Terms";
        AJWebCarrier: Record "AJ Web Carrier";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        //>> COD
        if not AJShippingHeader."Created From Sales Order" then
            exit;
        SalesHeader.SetRange("Web Order No.", AJShippingHeader."Shipping No.");
        if not SalesHeader.FindFirst() then begin
            SalesInvoiceHeader.SetRange("Web Order No.", AJShippingHeader."Shipping No.");
            if not SalesInvoiceHeader.FindFirst() then
                exit;
            SalesHeader.TransferFields(SalesInvoiceHeader);
        end;
        if not PaymentTerms.Get(SalesHeader."Payment Terms Code") then
            exit;
        if not AJWebCarrier.Get(AJShippingHeader."Shipping Web Service Code", AJShippingHeader."Shipping Carrier Code") then
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