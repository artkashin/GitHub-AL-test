codeunit 37075095 "AJ Web Order Service Mgmt"
{

    trigger OnRun()
    begin
    end;

    var
        JetComDateTimeFormat: Label 'yyyy-MM-ddTHH:mm:ss.fffffff-HH:MM';
        SystemDateTime: DotNet DateTime;
        OasisDateTimeFormat: Label 'yyyy-MM-ddTHH:mm:ss.fffzzz';
        LogicBrokerDateTimeFormat: Label 'yyyy-MM-ddTHH:mm:ss';
        JetComWebSKUPrefix: Label 'M';
        Text001: Label 'Field %1 have to be the same for all orders in Pick Document.\You have two different values: %2 and %3. \Web OrderNumbers: %4 and%5.';
        Text002: Label 'Integration code %1 for Web Carrier Service %2 have to be set up.';
        Text003: Label 'Current Insured Value %1 more than Carrier Service "Max Insurance Limit" %2.\Are you sure you want to continue?';
        Text004: Label 'Operation cancelled by user.';
        Text005: Label 'Action is too dangerous.';
        Text006: Label 'Quantity of Web Items created: %1.\Quantity of Web Items modified: %2.';
        Text007: Label 'Unknown integration code: %1.';
        Text008: Label 'Wrong web service subtype for sending invoice: %1.';
        Text009: Label 'There is no Label data for Web Order No.: %1';
        Text010: Label 'There is no Packlist data for Web Order No.: %1';
        Text011: Label 'Complete';
        Text012: Label 'You have no integration set up/code for Web Service: %1, Carrier: %2, Carrier Service: %3.';
        Text013: Label 'Processing... \@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text014: Label 'Carrier %1 does not allow to ship with 3 address lines, \please change it to 2 lines.';
        Text015: Label 'Are you sure you want to update ticket list?';
        Text016: Label 'Quantity of tickets imported: %1.\Skipped: %2.';
        Text017: Label 'Loading...\Ticket No.: #1###########\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text018: Label 'Are you sure you want to update tickets timing?';
        Text019: Label 'Quantity of time records imported:\ %1.';
        Text020: Label 'Are you sure you want to invoice selected(%1) lines?';
        Text021: Label 'Processing...\Ticket No.: #1###########\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text022: Label 'Tickets processed: %1.';
        Text023: Label 'Are you sure you created label for order %1 manually?';
        Text024: Label 'Tracking number must be 18 symbols.';
        Text025: Label 'All items are set up.';
        Text026: Label 'Not for you, mortal.';
        ShowDialog: Boolean;
        Wnd: Dialog;
        Cnt: Integer;
        AJWebSetup: Record "AJ Web Setup";
        Text027: Label 'Uploading pictures...\@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text028: Label 'Updated pictures: %1.';
        Text029: Label 'Are you sure you want to update parent items?';
        Text030: Label 'Processing...\@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text031: Label 'Items with parent found:\ %1.';
        Text032: Label 'File with type = %1 was not created.';
        Text033: Label 'Ticket already has been created.';
        Text034: Label 'Assembly Order# %1.';
        LF: Text;
        CR: Text;
        XX: Text;
        DoNotSendOrder: Boolean;
        i: Integer;
        UpdatePar: Integer;
        "--": Integer;
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        StopMessage: Boolean;
        ReplaceNULL: Boolean;
        TotalAmount: Decimal;
        AmazonOrderDateFrom: DateTime;

    local procedure "-----------Packages>"()
    begin
    end;

    local procedure WOS_CheckPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebCarrierService: Record "AJ Web Carrier Service";
    begin
        //currently only checking Insurance limit
        if AJWebCarrierService.Get(AJWebPackage."Shipping Web Service Code", AJWebPackage."Shipping Carrier Code",AJWebPackage."Shipping Carrier Service")
          and (AJWebCarrierService."Max Insurance Limit" <> 0)
          and (AJWebPackage."Insured Value" + AJWebPackage."Additional Insurance Value" > AJWebCarrierService."Max Insurance Limit")
        then
          if not Confirm('Package ' + AJWebPackage."No." + ': ' + StrSubstNo(Text003, AJWebPackage."Insured Value" + AJWebPackage."Additional Insurance Value", AJWebCarrierService."Max Insurance Limit"), false) then
            Error(Text004);
    end;

    [Scope('Internal')]
    procedure WOS_GetLabelForPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebOrderService: Record "AJ Web Service";
    begin
        if AJWebPackage."Label Created" then
          exit;
        WOS_CheckPackage(AJWebPackage);
        AJWebOrderService.Get(AJWebPackage."Shipping Web Service Code");

        case AJWebOrderService."Web Service Type" of
          AJWebOrderService."Web Service Type"::ShipStation :
            ShipStation_GetLabelForPackage(AJWebPackage);
          else
            Error('Web Service Type %1 does not support package Labels.',AJWebOrderService.Code)
        end;

        WOS_UpdateSHAmountFromPackage(AJWebPackage);
    end;

    [Scope('Internal')]
    procedure WOS_CancelLabelForPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebOrderService: Record "AJ Web Service";
    begin
        if not AJWebPackage."Label Created" then
          exit;
        AJWebOrderService.Get(AJWebPackage."Shipping Web Service Code");
        case AJWebOrderService."Web Service Type" of
          AJWebOrderService."Web Service Type"::ShipStation :
            ShipStation_CancelLabelForPackage(AJWebPackage);
          else
            Error('Web Service Type %1 does not support package Labels.',AJWebOrderService.Code)
        end;

        WOS_UpdateSHAmountFromPackage(AJWebPackage); // SK 5/11/2017
    end;

    [Scope('Internal')]
    procedure WOS_PrintLabelForPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebService: Record "AJ Web Service";
    begin
        AJWebService.Get(AJWebPackage."Shipping Web Service Code");
        case AJWebService."Web Service Type" of
          AJWebService."Web Service Type"::ShipStation: ShipStation_PrintLabelForPackage(AJWebPackage);
          else
            Error('Web Service Type %1 does not support Print Label For Packages.',AJWebService.Code)
        end;
    end;

    [Scope('Internal')]
    procedure WOS_SaveLabelForPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebService: Record "AJ Web Service";
    begin
        AJWebService.Get(AJWebPackage."Shipping Web Service Code");
        case AJWebService."Web Service Type" of
          AJWebService."Web Service Type"::ShipStation: ShipStation_SaveLabelForPackage(AJWebPackage);
          else
            Error('Web Service Type %1 does not support Saving of Labels for packages',AJWebService.Code)
        end;
    end;

    local procedure ShipStation_GetLabelForPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebMarketplace: Record "AJ Web Marketplace (Mailbox)";
        HttpWebRequest: DotNet HttpWebRequest;
        HttpWebHeaders: DotNet WebHeaderCollection;
        MemoryStream: DotNet MemoryStream;
        Uri: DotNet Uri;
        XMLDoc: DotNet XmlDocument;
        StreamReader: DotNet StreamReader;
        Encoding: DotNet Encoding;
        Txt: Text;
        XmlNode: DotNet XmlNode;
        ErrorText: Text;
        JArray: DotNet JArray;
        JConvert: DotNet JsonConvert;
        JToken: DotNet JToken;
        JObject: DotNet JObject;
        i: Integer;
        ValueJToken: DotNet JToken;
        AJWebOrderService: Record "AJ Web Service";
        AddJObject: DotNet JObject;
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

        AJWebPackage.TestField("Label Created",false);
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


        AJWebOrderService.Get(AJWebPackage."Shipping Web Service Code");
        AJWebServiceWarehouse.Get(AJWebOrderService.Code,AJWebPackage."Shipping Warehouse ID");
        AJWebCarrier.Get(AJWebOrderService.Code,AJWebPackage."Shipping Carrier Code");
        AJWebCarrierPackageType.Get(AJWebOrderService.Code,AJWebPackage."Shipping Carrier Code",AJWebPackage."Shipping Package Type");

        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");
        Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'orders/createlabelfororder');

        HttpWebRequest := HttpWebRequest.Create(Uri);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.ContentType := 'application/json';

        HttpWebHeaders := HttpWebRequest.Headers;
        HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

        JObject := JObject.JObject();
        JSONAddTxtasDec(JObject,'orderId',AJWebPackage."Shipping Web Service Order No.");
        JSONAddTxt(JObject,'carrierCode',AJWebPackage."Shipping Carrier Code");
        JSONAddTxt(JObject,'serviceCode', AJWebPackage."Shipping Carrier Service");
        JSONAddTxt(JObject,'packageCode',AJWebPackage."Shipping Package Type");
        JSONAddTxt(JObject,'confirmation',AJWebPackage."Shipping Delivery Confirm");
        JSONAddTxt(JObject,'shipDate',Format(AJWebPackage."Ship Date",0,'<Standard Format,9>'));

        AddJObject := AddJObject.JObject();
        JSONAddDec(AddJObject,'value',AJWebPackage."Shp. Product Weight");
        JSONAddTxt(AddJObject,'units',AJWebPackage."Shp. Product Weight Unit");
        JSONAddObject(JObject,'weight',AddJObject);

        if AJWebPackage."Shp. Product Dimension Unit" <> '' then begin
          AddJObject := AddJObject.JObject();
          if AJWebPackage."Shp. Product Dimension Unit" <> '' then begin
            JSONAddTxt(AddJObject,'units',AJWebPackage."Shp. Product Dimension Unit");
            JSONAddDec(AddJObject,'length',AJWebPackage."Shp. Product Length");
            JSONAddDec(AddJObject,'width',AJWebPackage."Shp. Product Width");
            JSONAddDec(AddJObject,'height',AJWebPackage."Shp. Product Height");
            JSONAddObject(JObject,'dimensions',AddJObject);
          end else
            JSONAddNULL(JObject,'dimensions');
        end;

        if AJWebPackage."Insure Shipment" then begin
          AddJObject := AddJObject.JObject();
          JSONAddTxt(AddJObject,'provider','carrier');// "shipsurance" or "carrier"
          JSONAddBool(AddJObject,'insureShipment',true);
          JSONAddDec(AddJObject,'insuredValue', AJWebPackage."Insured Value" + AJWebPackage."Additional Insurance Value");
          JSONAddObject(JObject,'insuranceOptions',AddJObject);
        end else begin
          JSONAddNULL(JObject,'insuranceOptions');
        end;

        JSONAddNULL(JObject,'internationalOptions');

        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject,'warehouseId',AJWebPackage."Shipping Warehouse ID");
        JSONAddBool(AddJObject,'nonMachinable',AJWebPackage."Non Machinable");
        JSONAddBool(AddJObject,'saturdayDelivery',AJWebPackage."Saturday Delivery");
        JSONAddBool(AddJObject,'containsAlcohol',AJWebPackage."Contains Alcohol");
        //JSONAddTxt(AddJObject,'storeId',AJWebStore.Code); //MBS commented 12.09.2019

        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.",AJWebPackage."Source No.");
        if SalesHeader.FindFirst then begin
          JSONAddTxt(AddJObject,'customField1',SalesHeader."No.");   //sales order #
          JSONAddTxt(AddJObject,'customField2',SalesHeader."External Document No.");  //external document #
          Customer.Get(SalesHeader."Sell-to Customer No.");
        end;

        JSONAddNULL(AddJObject,'customField3');

        // 3rd party billing
        if AJWebPackage."Bill-to Type" <> 0 then begin
          JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebPackage."Bill-to Type"));
          if AJWebPackage."Bill-to Type" = AJWebPackage."Bill-to Type"::my_other_account then
            JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebPackage."Bill-To Account")
          else
            JSONAddTxt(AddJObject,'billToAccount', AJWebPackage."Bill-To Account");
          JSONAddTxt(AddJObject,'billToPostalCode', AJWebPackage."Bill-To Postal Code");
          JSONAddTxt(AddJObject,'billToCountryCode', AJWebPackage."Bill-To Country Code");
        end else
          if AJWebOrderHeader."Bill-to Type" <> 0 then begin
            AJWebPackage."Bill-to Type" := AJWebOrderHeader."Bill-to Type";
            AJWebPackage."Bill-To Account" := AJWebOrderHeader."Bill-To Account";
            AJWebPackage."Bill-To Postal Code" := AJWebOrderHeader."Bill-To Postal Code";
            AJWebPackage."Bill-To Country Code" := AJWebOrderHeader."Bill-To Country Code";
            AJWebPackage.Modify;

            JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebOrderHeader."Bill-to Type"));
            if AJWebOrderHeader."Bill-to Type" = AJWebOrderHeader."Bill-to Type"::my_other_account then
              JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebOrderHeader."Bill-To Account")
            else
              JSONAddTxt(AddJObject,'billToAccount', AJWebOrderHeader."Bill-To Account");
            JSONAddTxt(AddJObject,'billToPostalCode', AJWebOrderHeader."Bill-To Postal Code");
            JSONAddTxt(AddJObject,'billToCountryCode', AJWebOrderHeader."Bill-To Country Code");

          end else if Customer."Bill-to Type" <> 0 then begin
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

            JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebPackage."Bill-to Type"));
            if AJWebPackage."Bill-to Type" = AJWebPackage."Bill-to Type"::my_other_account then
              JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebPackage."Bill-To Account")
            else
              JSONAddTxt(AddJObject,'billToAccount', AJWebPackage."Bill-To Account");
            JSONAddTxt(AddJObject,'billToPostalCode', AJWebPackage."Bill-To Postal Code");
            JSONAddTxt(AddJObject,'billToCountryCode', AJWebPackage."Bill-To Country Code");

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

                    JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebCarrier2."Bill-to Type"));
                    if AJWebCarrier2."Bill-to Type" = AJWebCarrier2."Bill-to Type"::my_other_account then
                      JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebCarrier2."Bill-to Account No.")
                    else
                      JSONAddTxt(AddJObject,'billToAccount', AJWebCarrier2."Bill-to Account No.");
                    JSONAddTxt(AddJObject,'billToPostalCode', AJWebCarrier2."Bill-to Account Post Code");
                    JSONAddTxt(AddJObject,'billToCountryCode', AJWebCarrier2."Bill-to Account Country Code");
              end;
          end;
        JSONAddObject(JObject,'advancedOptions',AddJObject);

        // "Fedex does not support test labels at this time."
        if LowerCase(AJWebPackage."Shipping Carrier Code") <> 'fedex' then
          JSONAddBool(JObject,'testLabel',false);
        Txt := JObject.ToString();

        HttpWebRequest.ContentLength := StrLen(Txt);

        MemoryStream := HttpWebRequest.GetRequestStream();
        StreamWriter := StreamWriter.StreamWriter(MemoryStream);
        StreamWriter.Write(Txt);
        StreamWriter.Flush();
        StreamWriter.Close();
        MemoryStream.Flush();
        MemoryStream.Close();

        if not Http_GetResponse(HttpWebRequest,Txt) then begin
          JObject := JObject.Parse(Txt);
          if JObject.TryGetValue('ExceptionMessage',ValueJToken) then
            Error('Web service error:\%1',ValueJToken.ToString())
          else
            Error('Web service error:\%1',Txt);
        end;

        JObject := JObject.Parse(Txt);;
        if JObject.TryGetValue('labelData',ValueJToken) then begin
          LabelPdf := ValueJToken.ToString();
          LabelBytes := base64Converter.FromBase64String(LabelPdf);
          LabelMemoryStream := LabelMemoryStream.MemoryStream(LabelBytes);
          AJWebPackage.Label.CreateOutStream(LabelOutSteram);
          LabelMemoryStream.WriteTo(LabelOutSteram);
          LabelMemoryStream.Flush();
          LabelMemoryStream.Close();
          AJWebPackage."Carier Shipping Charge" := JSONGetDec(JObject,'shipmentCost');
          AJWebPackage."Carier Tracking Number" :=  JSONGetTxt(JObject,'trackingNumber',MaxStrLen(AJWebPackage."Carier Tracking Number"));
          AJWebPackage."Carier Insurance Cost" :=  JSONGetDec(JObject,'insuranceCost');
        end;
        if LowerCase(AJWebPackage."Shipping Carrier Code") = 'fedex' then begin
          AJWebPackage."Shipping Web Service Shipm. ID" := JSONGetTxt(JObject,'shipmentId',MaxStrLen(AJWebPackage."Shipping Web Service Shipm. ID"));
          AJWebPackage."Label Created" := true;
          AJWebPackage."Label Printed" := false;
        end;

        AJWebCarrierService.Get(AJWebPackage."Shipping Web Service Code",AJWebPackage."Shipping Carrier Code",AJWebPackage."Shipping Carrier Service");

        // MBS commented 12.09.2019 >>
        // AJWebCarierAddCharge.RESET;
        // AJWebCarierAddCharge.SETRANGE("Web Service Code",AJWebPackage."Shipping Web Service Code");
        // AJWebCarierAddCharge.SETRANGE("Carier Code",AJWebPackage."Shipping Carrier Code");
        // AJWebCarierAddCharge.SETFILTER("Package Value",'<%1',AJWebPackage."Insured Value" + AJWebPackage."Additional Insurance Value");
        // IF NOT AJWebCarierAddCharge.FINDLAST THEN
        //  AJWebCarierAddCharge.INIT;
        // AJWebPackage."Shipping & Handling Amount" := ROUND(
        //  AJWebPackage."Carier Shipping Charge" * (1 + AJWebCarrierService."Additional Charge %"/100) + AJWebCarrierService."Additional Charge $" +
        //  AJWebPackage."Carier Insurance Cost" * (1 + AJWebCarierAddCharge."Add. Fee %"/100) + AJWebCarierAddCharge."Add Fee $",0.01);
        // ShipStation_CalcShippingHandlingAmount_ToCustomer(AJWebOrderHeader,AJWebCarierAddCharge);
        // MBS commented 12.09.2019 <<

        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
        if SalesHeader.FindFirst then begin
          if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            Customer.Init;
        end;

        AJWebPackage.Modify;
    end;

    local procedure ShipStation_CancelLabelForPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebOrderService: Record "AJ Web Service";
        HttpWebRequest: DotNet HttpWebRequest;
        HttpWebHeaders: DotNet WebHeaderCollection;
        MemoryStream: DotNet MemoryStream;
        StreamWriter: DotNet StreamWriter;
        Uri: DotNet Uri;
        Txt: Text;
        JObject: DotNet JObject;
        ValueJToken: DotNet JToken;
    begin

        if not AJWebPackage."Label Created" then
          exit;

        AJWebPackage.TestField("Shipping Web Service Order No.");
        AJWebPackage.TestField("Shipping Web Service Shipm. ID");

        AJWebOrderService.Get(AJWebPackage."Shipping Web Service Code");
        AJWebOrderService.TestField("Web Service Type",AJWebOrderService."Web Service Type"::ShipStation);

        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");
        Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'shipments/voidlabel');

        HttpWebRequest := HttpWebRequest.Create(Uri);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.ContentType := 'application/json';

        HttpWebHeaders := HttpWebRequest.Headers;
        HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

        JObject := JObject.JObject();
        JSONAddTxtasDec(JObject,'shipmentId',AJWebPackage."Shipping Web Service Shipm. ID");
        Txt := JObject.ToString();
        HttpWebRequest.ContentLength := StrLen(Txt);

        MemoryStream := HttpWebRequest.GetRequestStream();
        StreamWriter := StreamWriter.StreamWriter(MemoryStream);
        StreamWriter.Write(Txt);
        StreamWriter.Flush();
        StreamWriter.Close();
        MemoryStream.Flush();
        MemoryStream.Close();

        if not Http_GetResponse(HttpWebRequest,Txt) then begin
          JObject := JObject.Parse(Txt);
          if JObject.TryGetValue('ExceptionMessage',ValueJToken) then
            Error('Web service error:\%1',ValueJToken.ToString())
          else
            Error('Web service error:\%1',Txt);
        end;

        JObject := JObject.Parse(Txt);
        //MESSAGE(Txt);
        if JSONGetBool(JObject,'approved') then begin
          AJWebPackage."Shipping Web Service Shipm. ID" := '';
          AJWebPackage."Carier Shipping Charge" := 0;
          AJWebPackage."Carier Tracking Number" := '';
          AJWebPackage."Carier Insurance Cost" :=  0;
          AJWebPackage."Label Created" := false;
          AJWebPackage."Label Printed" := false;
          AJWebPackage."Shipping & Handling Amount" := 0;
          Clear(AJWebPackage.Label);
          AJWebPackage.Modify;
        end;
    end;

    local procedure ShipStation_PrintLabelForPackage(var AJWebPackage: Record "AJ Web Package")
    var
        WinShell: Automation ;
        FileManagement: Codeunit "File Management";
        ServerFile: Text;
        LocalFile: Text;
        WindowState: Boolean;
        WaitReturn: Boolean;
        Environment: DotNet Environment;
    begin
        if not AJWebPackage."Label Created" then
          exit;

        AJWebPackage.CalcFields(Label);
        if not AJWebPackage.Label.HasValue then
          exit;

        // MBS 12.09.2019 commented >>
        // LabelPrinter.GET(AJWebStore."Label Printer Code");
        // LabelPrinter.TESTFIELD("PDF Path");
        // LabelPrinter.TESTFIELD("Port/IP");
        //
        // //>> 5/28/2018
        // IF NOT FileManagement.ClientFileExists(LabelPrinter."PDF Path") THEN
        //  ERROR('Adobe Acrobat not found!\' + CONVERTSTR(LabelPrinter."PDF Path",'\','/'));
        // //<< 5/28/2018
        // MBS 12.09.2019 commented <<

        ServerFile := FileManagement.ServerTempFileName('pdf');
        AJWebPackage.Label.Export(ServerFile);
        LocalFile := FileManagement.ClientTempFileName('pdf');
        FileManagement.DownloadToFile(ServerFile,LocalFile);
        Create(WinShell,false,true);
        WaitReturn := false;
        //MBS 12.09.2019 COmmented
        //WinShell.Run(STRSUBSTNO('"%1" /h /t "%2" %3',LabelPrinter."PDF Path",LocalFile,LabelPrinter."Port/IP",Environment.SystemDirectory,'cmd.exe'),WindowState,WaitReturn);
        Clear(WinShell);

        Commit;
        Sleep(100);

        AJWebPackage.Find;
        AJWebPackage."Label Printed" := true;
        AJWebPackage.Modify;
    end;

    local procedure ShipStation_SaveLabelForPackage(AJWebPackage: Record "AJ Web Package")
    var
        WinShell: Automation ;
        FileManagement: Codeunit "File Management";
        TempBlob: Record TempBlob temporary;
        OS: OutStream;
        IS: InStream;
        ToFile: Text;
    begin
        if not AJWebPackage."Label Created" then
          exit;
        AJWebPackage.CalcFields(Label);
        if not AJWebPackage.Label.HasValue then
          exit;

        AJWebPackage.Label.CreateInStream(IS);
        ToFile := 'LBL-' + AJWebPackage."Source No." + '-' + AJWebPackage."No." + '.pdf';
        DownloadFromStream(IS,'Save label as','C:\','Adobe Acrobat file(*.pdf)|*.pdf',ToFile);
    end;

    local procedure ShipStation_CreateOrderForWeb(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebMarketplace: Record "AJ Web Marketplace (Mailbox)";
        AJWebCarrier: Record "AJ Web Carrier";
        HttpWebRequest: DotNet HttpWebRequest;
        HttpWebHeaders: DotNet WebHeaderCollection;
        HttpWebResponse: DotNet WebResponse;
        MemoryStream: DotNet MemoryStream;
        Uri: DotNet Uri;
        XMLDoc: DotNet XmlDocument;
        StreamReader: DotNet StreamReader;
        Encoding: DotNet Encoding;
        Txt: Text;
        XmlNode: DotNet XmlNode;
        ErrorText: Text;
        JArray: DotNet JArray;
        JConvert: DotNet JsonConvert;
        JToken: DotNet JToken;
        JObject: DotNet JObject;
        i: Integer;
        ValueJToken: DotNet JToken;
        AJWebOrderService: Record "AJ Web Service";
        AddJObject: DotNet JObject;
        AJWebOrderLine: Record "AJ Web Order Line";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
        StreamWriter: DotNet StreamWriter;
        LabelPdf: Text;
        base64Converter: DotNet Convert;
        LabelMemoryStream: DotNet MemoryStream;
        LabelBytes: DotNet Array;
        LabelOutSteram: OutStream;
        SystemTextUTF8Encoding: DotNet UTF8Encoding;
        AJWebService2: Record "AJ Web Service";
    begin
        if AJWebOrderHeader."Shipping Web Service Code" <> '' then
          AJWebOrderService.Get(AJWebOrderHeader."Shipping Web Service Code")
        else
          AJWebOrderService.Get(AJWebOrderHeader."Web Service Code");
        AJWebOrderService.TestField("Web Service Type",AJWebOrderService."Web Service Type"::ShipStation);
        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");

        //>> Additional Check
        if AJWebOrderHeader."Ship-To Customer Country" in ['USA',''] then
          AJWebOrderHeader."Ship-To Customer Country" := 'US';
        if AJWebOrderHeader."Bill-To Customer Country" in ['USA',''] then
          AJWebOrderHeader."Bill-To Customer Country" := 'US';

        AJWebCarrier.Get(AJWebOrderService.Code, AJWebOrderHeader."Shipping Carrier Code");
        if AJWebCarrier."2 Lines Address only" and ((AJWebOrderHeader."Bill-To Customer Address 3" <> '')
          or (AJWebOrderHeader."Ship-To Customer Address 3" <> ''))
        then
          Error(StrSubstNo(Text014, AJWebCarrier.Code));
        //<< Additional Check

        Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'orders/createorder');

        HttpWebRequest := HttpWebRequest.Create(Uri);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.ContentType := 'application/json';

        HttpWebHeaders := HttpWebRequest.Headers;
        HttpWebHeaders.Add('Authorization','Basic '+AJWebOrderService."API Encoded String");

        JObject := JObject.JObject();
        JSONAddTxt(JObject,'orderNumber',AJWebOrderHeader."Web Order No.");
        JSONAddTxt(JObject,'orderKey',AJWebOrderHeader."Web Order No.");
        JSONAddTxt(JObject,'orderDate',Format(DT2Date(AJWebOrderHeader."Order DateTime"),0,'<Standard Format,9>'));
        JSONAddTxt(JObject,'orderStatus','awaiting_shipment');// awaiting_payment, awaiting_shipment,shipped,on_hold,cancelled

        if AJWebOrderHeader."Ship-To E-mail" <> '' then
          JSONAddTxt(JObject,'customerEmail',AJWebOrderHeader."Ship-To E-mail");

        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject,'name',AJWebOrderHeader."Bill-To Customer Name");
        JSONAddTxt(AddJObject,'company',AJWebOrderHeader."Bill-To Company");
        JSONAddTxt(AddJObject,'street1',AJWebOrderHeader."Bill-To Customer Address 1");
        JSONAddTxt(AddJObject,'street2',AJWebOrderHeader."Bill-To Customer Address 2");
        JSONAddTxt(AddJObject,'street3',AJWebOrderHeader."Bill-To Customer Address 3");

        JSONAddTxt(AddJObject,'city',AJWebOrderHeader."Bill-To Customer City");
        JSONAddTxt(AddJObject,'state',AJWebOrderHeader."Bill-To Customer State");
        JSONAddTxt(AddJObject,'postalCode',AJWebOrderHeader."Bill-To Customer Zip");
        JSONAddTxt(AddJObject,'country',GetCountryCode(AJWebOrderHeader."Bill-To Customer Country"));
        JSONAddTxt(AddJObject,'phone',AJWebOrderHeader."Bill-To Customer Phone");
        JSONAddBool(AddJObject,'residential',AJWebOrderHeader."Bill-To Residential");
        JSONAddObject(JObject,'billTo',AddJObject);

        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject,'name',AJWebOrderHeader."Ship-To Customer Name");
        JSONAddTxt(AddJObject,'company',AJWebOrderHeader."Ship-To Company");
        JSONAddTxt(AddJObject,'street1',AJWebOrderHeader."Ship-To Customer Address 1");
        JSONAddTxt(AddJObject,'street2',AJWebOrderHeader."Ship-To Customer Address 2");
        JSONAddTxt(AddJObject,'street3',AJWebOrderHeader."Ship-To Customer Address 3");
        JSONAddTxt(AddJObject,'city',AJWebOrderHeader."Ship-To Customer City");
        JSONAddTxt(AddJObject,'state',AJWebOrderHeader."Ship-To Customer State");
        JSONAddTxt(AddJObject,'postalCode',AJWebOrderHeader."Ship-To Customer Zip");
        JSONAddTxt(AddJObject,'country',GetCountryCode(AJWebOrderHeader."Ship-To Customer Country"));
        JSONAddTxt(AddJObject,'phone',AJWebOrderHeader."Ship-To Customer Phone");
        JSONAddBool(AddJObject,'residential',AJWebOrderHeader."Ship-To Residential");
        JSONAddObject(JObject,'shipTo',AddJObject);

        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject,'warehouseId',AJWebOrderHeader."Ship-From Warehouse ID");
        JSONAddBool(AddJObject,'nonMachinable',AJWebOrderHeader."Non Machinable");
        JSONAddBool(AddJObject,'saturdayDelivery',AJWebOrderHeader."Saturday Delivery");
        JSONAddBool(AddJObject,'containsAlcohol',AJWebOrderHeader."Contains Alcohol");
        //JSONAddTxt(AddJObject,'storeId',AJWebStore.Code); // MBS 12.09.2019 commented

        // we fill CustomFields with spec values for JCP
        AJWebService2.Get(AJWebOrderHeader."Web Service Code");
        if (AJWebService2."Web Service Type" = AJWebService2."Web Service Type"::"2")
          and (AJWebOrderHeader."Custom Field 1" <> '') and (AJWebOrderHeader."Custom Field 2" <>'')
        then begin
          JSONAddTxt(AddJObject,'customField1',AJWebOrderHeader."Custom Field 1");
          JSONAddTxt(AddJObject,'customField2',AJWebOrderHeader."Custom Field 2");
        end else begin
        //<<
          JSONAddTxt(AddJObject,'customField1',AJWebOrderHeader."Web Service PO Number");   //sales order #
          JSONAddTxt(AddJObject,'customField2',AJWebOrderHeader."Customer Reference ID");  //external document #
        end;

        AJWebService2.Get(AJWebOrderHeader."Web Service Code");
        if AJWebService2."Reference 3" = AJWebService2."Reference 3"::PO then
          AJWebOrderHeader."Custom Field 3" := AJWebOrderHeader."Web Service PO Number"
        else

        //>> COD
          AJWebOrderHeader."Custom Field 3" := IsCOD(AJWebOrderHeader);
        JSONAddTxt(AddJObject,'customField3',AJWebOrderHeader."Custom Field 3");
        //<< COD

        if AJWebOrderHeader."International Shipment" then begin
        end;

        JSONAddObject(JObject,'advancedOptions',AddJObject);

        //>> COD
        if (IsCOD(AJWebOrderHeader) <> '') and (AJWebOrderHeader."COD Amount" <> 0) then begin
          // item
          AddJObject := AddJObject.JObject();
          JSONAddTxt(AddJObject,'sku','COD');
          JSONAddTxt(AddJObject,'name','COD amount');
          JSONAddDec(AddJObject,'quantity',1);
          JSONAddDec(AddJObject,'unitPrice',AJWebOrderHeader."COD Amount");

          JToken := AddJObject;
          JArray := JArray.JArray();
          JArray.Add(JToken);
          JObject.Add('items',JArray);
        end;
        //<< COD

        Txt := JObject.ToString();

        Encoding := SystemTextUTF8Encoding.UTF8Encoding(false);
        HttpWebRequest.ContentLength := Encoding.GetByteCount(Txt);
        MemoryStream := HttpWebRequest.GetRequestStream();
        StreamWriter := StreamWriter.StreamWriter(MemoryStream, Encoding);
        StreamWriter.Write(Txt);
        StreamWriter.Flush();
        StreamWriter.Close();
        MemoryStream.Flush();
        MemoryStream.Close();
        //<< SK 6/5/2017 ENCODING FIX


        if not Http_GetResponse(HttpWebRequest,Txt) then
          Error('Web service error:\%1',Txt);

        JObject := JObject.Parse(Txt);
        if JObject.TryGetValue('orderId',ValueJToken) then begin
          AJWebOrderHeader."Shipping Web Service Order No." := ValueJToken.ToString();
          AJWebOrderHeader.Modify;
        end;
    end;

    local procedure "----------Packages<"()
    begin
    end;

    local procedure "<JSON>"()
    begin
    end;

    [Scope('Internal')]
    procedure JSONAddTxt(var JObject: DotNet JObject;PropertyName: Text;PropertyValue: Text)
    var
        JToken: DotNet JToken;
        SystemWebHttpUtility: DotNet HttpUtility;
    begin

        if PropertyValue = '' then
        //>> 10/5/2018
          if ReplaceNULL then
            JObject.Add(PropertyName,JToken.Parse('""'))
          else
        //<< 10/5/2018
            JObject.Add(PropertyName,JToken.Parse('null'))
        else
        //  JObject.Add(PropertyName,JToken.Parse(''''+PropertyValue+''''));
          JObject.Add(PropertyName,JToken.Parse(SystemWebHttpUtility.JavaScriptStringEncode(PropertyValue,true)));
    end;

    [Scope('Internal')]
    procedure JSONAddDec(var JObject: DotNet JObject;PropertyName: Text;PropertyValue: Decimal)
    var
        JToken: DotNet JToken;
    begin

        JObject.Add(PropertyName,JToken.Parse(Format(PropertyValue,20,'<Sign><Integer><Decimals>')));
    end;

    [Scope('Internal')]
    procedure JSONAddBigInt(var JObject: DotNet JObject;PropertyName: Text;PropertyValue: BigInteger)
    var
        JToken: DotNet JToken;
    begin
        JObject.Add(PropertyName,JToken.Parse(Format(PropertyValue)));
    end;

    [Scope('Internal')]
    procedure JSONAddObject(var JObject: DotNet JObject;PropertyName: Text;AddJObject: DotNet JObject)
    var
        JToken: DotNet JToken;
    begin
        JObject.Add(PropertyName,JToken.Parse(AddJObject.ToString()));
    end;

    [Scope('Internal')]
    procedure JSONAddNULL(var JObject: DotNet JObject;PropertyName: Text)
    var
        JToken: DotNet JToken;
    begin
        JObject.Add(PropertyName,JToken.Parse('null'));
    end;

    [Scope('Internal')]
    procedure JSONAddBool(var JObject: DotNet JObject;PropertyName: Text;PropertyValue: Boolean)
    var
        JToken: DotNet JToken;
    begin
        if PropertyValue then
          JObject.Add(PropertyName,JToken.Parse('true'))
        else
          JObject.Add(PropertyName,JToken.Parse('false'));
    end;

    [Scope('Internal')]
    procedure JSONAddTxtasDec(var JObject: DotNet JObject;PropertyName: Text;PropertyValue: Text)
    var
        JToken: DotNet JToken;
    begin
        if PropertyValue = '' then
          JObject.Add(PropertyName,JToken.Parse('null'))
        else
          JObject.Add(PropertyName,JToken.Parse(PropertyValue));
    end;

    [Scope('Internal')]
    procedure JSONGetTxt(var JObject: DotNet JObject;PropertyName: Text;MaxLen: Integer): Text
    var
        JToken: DotNet JToken;
    begin
        if JObject.TryGetValue(PropertyName,JToken) then
          if MaxLen = 0 then
            exit(JToken.ToString)
          else
            exit(CopyStr(JToken.ToString,1,MaxLen));
    end;

    [Scope('Internal')]
    procedure JSONGetDec(var JObject: DotNet JObject;PropertyName: Text) RetValue: Decimal
    var
        JToken: DotNet JToken;
    begin
        if JObject.TryGetValue(PropertyName,JToken) then
          if Evaluate(RetValue,JToken.ToString) then;
    end;

    [Scope('Internal')]
    procedure JSONGetBool(var JObject: DotNet JObject;PropertyName: Text) RetValue: Boolean
    var
        JToken: DotNet JToken;
    begin
        if JObject.TryGetValue(PropertyName,JToken) then
          if Evaluate(RetValue,JToken.ToString) then;
    end;

    [Scope('Internal')]
    procedure JSONAddToArray(var JArray: DotNet JArray;AddJObject: DotNet JObject)
    var
        JToken: DotNet JToken;
    begin
        JArray.Add(JToken.Parse(AddJObject.ToString()));
    end;

    [Scope('Internal')]
    procedure JSONAddArray(var JObject: DotNet JObject;PropertyName: Text;var JArray: DotNet JArray)
    var
        JToken: DotNet JToken;
    begin
        JObject.Add(PropertyName,JToken.Parse(JArray.ToString()));
    end;

    [Scope('Internal')]
    procedure JSONSetReplaceNULL(NewReplaceNULL: Boolean)
    begin
        // 10/5/2018
        ReplaceNULL := NewReplaceNULL;
    end;

    local procedure "------------------------"()
    begin
    end;

    [Scope('Internal')]
    procedure WOS_UpdateSHAmountFromPackage(var AJWebPackage: Record "AJ Web Package")
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
    begin
        // 1388444 SK 5/11/2017
        if (AJWebPackage."Source Type" <> DATABASE::"AJ Web Order Header") then
          exit;
        AJWebOrderHeader.Get(AJWebPackage."Source No.");
        SalesHeader.SetRange("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
        if not SalesHeader.FindFirst then
          exit;

        AJWebOrderHeader.CalcFields("Packages Ship. & Hand. Amount");
        // MBS 12.09.2019 commented >>
        // IF SalesHeader."Shipping & Handling Amount" <> AJWebOrderHeader."Packages Ship. & Hand. Amount" THEN BEGIN
        //  SalesHeader."Shipping & Handling Amount" := AJWebOrderHeader."Packages Ship. & Hand. Amount";
        //  SalesHeader.MODIFY;
        // END;
        // MBS 12.09.2019 commented <<
    end;

    local procedure GetBillToTypeName(BillToType: Option) Txt: Text
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
    begin
        case BillToType of
          AJWebOrderHeader."Bill-to Type"::my_account : exit('my_account');
          AJWebOrderHeader."Bill-to Type"::my_other_account : exit('my_other_account');
          AJWebOrderHeader."Bill-to Type"::recipient : exit('recipient');
          AJWebOrderHeader."Bill-to Type"::third_party : exit('third_party');
          else
            Error('Unsupported bill-to type %1',BillToType);
        end;
    end;

    [Scope('Internal')]
    procedure Http_GetResponse(var HttpWebRequest: DotNet HttpWebRequest;var ResponseText: Text) Ok: Boolean
    var
        SystemException: DotNet Exception;
        HttpWebResponse: DotNet WebResponse;
        HttpWebException: DotNet WebException;
        HttpWebExceptionStatus: DotNet WebExceptionStatus;
        MemoryStream: DotNet MemoryStream;
        StreamReader: DotNet StreamReader;
        Encoding: DotNet Encoding;
    begin
        // SK 160706 HttpWebRequest.GetResponse call with error handling
        ResponseText := '';
        ClearLastError;
        if Http_TryGetResponse(HttpWebRequest,HttpWebResponse) then begin
          Ok := true;
        end else begin
          Ok := false;
          SystemException := GetLastErrorObject;
          //ERROR(FORMAT(GETLASTERROROBJECT));
          HttpWebException := HttpWebException.WebException;
          if not SystemException.InnerException.GetType.Equals(HttpWebException.GetType) then
            Error(SystemException.Message);
          HttpWebException := SystemException.InnerException;
          if HttpWebException.Status.Equals (HttpWebExceptionStatus.ProtocolError) then begin
            HttpWebResponse := HttpWebException.Response;
          end else
            Error(HttpWebException.Message);
        end;
        MemoryStream := HttpWebResponse.GetResponseStream;
        StreamReader := StreamReader.StreamReader(MemoryStream,Encoding.UTF8);
        ResponseText := StreamReader.ReadToEnd;
        MemoryStream.Close;
    end;

    [TryFunction]
    local procedure Http_TryGetResponse(var HttpWebRequest: DotNet HttpWebRequest;var HttpWebResponse: DotNet WebResponse)
    begin
        // SK 160706 HttpWebRequest.GetResponse call with error handling
        HttpWebResponse := HttpWebRequest.GetResponse;
    end;

    local procedure GetCountryCode("Code": Code[10]): Code[10]
    var
        CountryRegion: Record "Country/Region";
    begin
        if not CountryRegion.Get(Code) then
          exit(Code);
        // IF CountryRegion."ISO 2 char Country Code" <> '' THEN
        //  EXIT(CountryRegion."ISO 2 char Country Code");
        exit(Code);
    end;

    [Scope('Internal')]
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
        SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
        if not SalesHeader.FindFirst then begin
          SalesInvoiceHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
          if not SalesInvoiceHeader.FindFirst then
            exit;
          SalesHeader.TransferFields(SalesInvoiceHeader);
        end;
        if not PaymentTerms.Get(SalesHeader."Payment Terms Code") then
          exit;
        if not AJWebCarrier.Get(AJWebOrderHeader."Shipping Web Service Code",AJWebOrderHeader."Shipping Carrier Code") then
          exit;
        if not AJWebCarrier."Allow COD" then
          exit;
        if PaymentTerms."COD Type" = 0 then
          exit;
        case PaymentTerms."COD Type" of
          PaymentTerms."COD Type"::Any : exit('COD1');
          PaymentTerms."COD Type"::Cash : exit('COD2');
          PaymentTerms."COD Type"::MoneyOrderCheck : exit('COD3');
        end;
        //<< COD
    end;
}

