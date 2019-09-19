codeunit 37075095 "AJ Web Order Service Mgmt"
{

    trigger OnRun()
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebOrderService: Record "AJ Web Service";
        Uri: DotNet Uri;
        HttpWebRequest: DotNet HttpWebRequest;
        AddJObject: JsonObject;
        HttpWebHeaders: DotNet WebHeaderCollection;
        JObject: JsonObject;
        SystemTextUTF8Encoding: DotNet UTF8Encoding;
        Encoding: DotNet Encoding;
        MemoryStream: DotNet MemoryStream;
        StreamWriter: DotNet StreamWriter;
        ValueJToken: JsonToken;
        Txt: Text;
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

    [Scope('Internal')]
    procedure WOS_GetOrderLabelParam(NewDoNotSendOrder: Boolean)
    begin
        DoNotSendOrder := NewDoNotSendOrder;
    end;

    [Scope('Internal')]
    procedure WOS_GetMarketlaces(AJWebOrderService: Record "AJ Web Service")
    begin
        case AJWebOrderService."Web Service Type" of
          AJWebOrderService."Web Service Type"::ShipStation: ShipStation_GetMarketlaces(AJWebOrderService);
          else
            Error('Web Service Type %1 does not support Marketplaces.',AJWebOrderService.Code)
        end;
    end;

    [Scope('Internal')]
    procedure WOS_GetWarehouses(AJWebOrderService: Record "AJ Web Service")
    begin
        case AJWebOrderService."Web Service Type" of
          AJWebOrderService."Web Service Type"::ShipStation: ShipStation_GetWarehouses(AJWebOrderService);
          else
            Error('Web Service Type %1 does not support Warehouses.')
            // Test from new comp
        end;
    end;

    [Scope('Internal')]
    procedure WOS_GetShipAgentInfo(AJWebOrderService: Record "AJ Web Service")
    begin
        case AJWebOrderService."Web Service Type" of
          AJWebOrderService."Web Service Type"::ShipStation: ShipStation_GetShipAgentInfo(AJWebOrderService);
          else
            Error('Web Service Type %1 does not support Shipping Agents.',AJWebOrderService.Code)
        end;
    end;

    [Scope('Internal')]
    procedure WOS_GetOrderLabel(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebOrderService: Record "AJ Web Service";
    begin
        if AJWebOrderHeader."Labels Created" then
          exit;
        AJWebOrderService.Get(AJWebOrderHeader."Web Service Code");

        // MBS commented >>
        //WOS_CheckOrder(AJWebOrderHeader);
        // IF (AJWebOrderHeader."Sum WHSE Pick No." <> '') AND (NOT AJWebOrderService."Fixed Carrier and Carrier Serv") THEN BEGIN
        //  AJWHSESumPickHeader.GET(AJWebOrderHeader."Sum WHSE Pick No.");
        //  AJWebOrderService.GET(AJWHSESumPickHeader."Shipping Web Service Code");
        // END ELSE
        // MBS commented <<

          if AJWebOrderHeader."Shipping Web Service Code" <> '' then
            AJWebOrderService.Get(AJWebOrderHeader."Shipping Web Service Code")
          else

          ShipStation_GetOrderLabel(AJWebOrderHeader);

        // MBS commented >>
        // COMMIT;
        // AJWebOrderService.GET(AJWebOrderHeader."Web Service Code");
        // IF AJWebOrderService."PO Acknowledge" IN [AJWebOrderService."PO Acknowledge"::CreateNotSend,AJWebOrderService."PO Acknowledge"::CreateSend] THEN BEGIN
        //  WOS_CreatePOAcknowledgement(AJWebOrderHeader,AJWebOrderService."PO Acknowledge" = AJWebOrderService."PO Acknowledge"::CreateSend);
        // END;
        // MBS commented <<
    end;

    [Scope('Internal')]
    procedure WOS_GetOrdersLabels(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebOrderService: Record "AJ Web Service";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        FileManagement: Codeunit "File Management";
    begin
        // CHECK
        if AJWebOrderHeader.FindFirst then repeat
          if not AJWebOrderHeader."Labels Created" then begin
            AJWebOrderService.Get(AJWebOrderHeader."Web Service Code");
            //WOS_CheckOrder(AJWebOrderHeader); // mbs commented
          end;
        until AJWebOrderHeader.Next = 0;

        // CREATE LABELS
        if AJWebOrderHeader.FindFirst then repeat
          if not AJWebOrderHeader."Labels Created" then begin
            if AJWebOrderHeader."Shipping Web Service Code" <> '' then
              AJWebOrderService.Get(AJWebOrderHeader."Shipping Web Service Code")
            else
              AJWebOrderService.Get(AJWebOrderHeader."Web Service Code");
          end;

          Commit;
        until AJWebOrderHeader.Next = 0;
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

        WOS_UpdateSHAmountFromPackage(AJWebPackage);
    end;

    [Scope('Internal')]
    procedure WOS_SaveLabel(AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebService: Record "AJ Web Service";
    begin
        AJWebService.Get(AJWebOrderHeader."Web Service Code");
        if AJWebOrderHeader."Shipping Web Service Code" <> '' then
          AJWebService.Get(AJWebOrderHeader."Shipping Web Service Code")
        else
          AJWebService.Get(AJWebOrderHeader."Web Service Code");

        case AJWebService."Web Service Type" of
          AJWebService."Web Service Type"::ShipStation: ShipStation_SaveLabel(AJWebOrderHeader);
          else
            Error('Web Service Type %1 does not support Saving of Labels',AJWebService.Code)
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

    [Scope('Internal')]
    procedure WOS_MergeSaveLabel(var pvr_AJWebOrderHeader: Record "AJ Web Order Header")
    var
        lr_AJWebOrderHeader: Record "AJ Web Order Header";
        LocalFile: Text;
        AJWebService: Record "AJ Web Service";
        [RunOnClient]
        PdfDoc: DotNet PdfDocument;
        FileManagement: Codeunit "File Management";
    begin
        lr_AJWebOrderHeader.Copy(pvr_AJWebOrderHeader);
        AJWebService.Get(lr_AJWebOrderHeader."Web Service Code");
        if lr_AJWebOrderHeader."Shipping Web Service Code" <> '' then
          AJWebService.Get(lr_AJWebOrderHeader."Shipping Web Service Code")
        else
          AJWebService.Get(lr_AJWebOrderHeader."Web Service Code");

        ShipStation_MergeLabels(lr_AJWebOrderHeader, PdfDoc, true, false);
        LocalFile := FileManagement.SaveFileDialog('Save label as','C:\','Adobe Acrobat file(*.pdf)|*.pdf');
        if LocalFile = ''
          then Error(Text004);
        PdfDoc.Save(LocalFile);
        Message(Text011);
    end;

    [Scope('Internal')]
    procedure WOS_CheckResponce(var AJWebOrderService: Record "AJ Web Service";var HttpWebResponse: DotNet WebResponse)
    begin
        case AJWebOrderService."Web Service Type" of
          AJWebOrderService."Web Service Type"::ShipStation: ShipStation_CheckResponce(HttpWebResponse,AJWebOrderService);
          else
            Error('Web Service Type %1 does not support Check Responce.')
        end;
    end;

    local procedure ShipStation_GetShipAgentInfo(AJWebOrderService: Record "AJ Web Service")
    var
        AJWebCarrier: Record "AJ Web Carrier";
        AJWebCarrierService: Record "AJ Web Carrier Service";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
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
        ErrorText: Text ; 
        JArray: DotNet JArray;
        JConvert: DotNet JsonConvert;
        JToken: JsonToken;
        JObject:  JsonObject;
        i: Integer;
        ValueJToken: JsonToken;
        StreamWriter: DotNet StreamWriter;
    begin
        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");
        Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'carriers');

        HttpWebRequest := HttpWebRequest.Create(Uri);
        HttpWebRequest.ContentLength := 0;
        HttpWebRequest.Method := 'GET';


        HttpWebHeaders := HttpWebRequest.Headers;
        HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

        if not Http_GetResponse(HttpWebRequest,Txt) then
          Error(Txt);

        JArray := JArray.Parse(Txt);
        for i := 1 to JArray.Count do begin
          JObject := JArray.Item(i-1);

          if JObject.TryGetValue('code',ValueJToken) then begin
            AJWebCarrier."Web Service Code" := AJWebOrderService.Code;
            AJWebCarrier.Code := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrier.Code));
            if AJWebCarrier.Find then;
            if JObject.TryGetValue('name',ValueJToken) then
              AJWebCarrier.Name := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrier.Name));
            if JObject.TryGetValue('accountNumber',ValueJToken) then
              AJWebCarrier."Account No." := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrier."Account No."));

            if JObject.TryGetValue('requiresFundedAccount',ValueJToken) then
              if Evaluate(AJWebCarrier."Requires Funded Account",ValueJToken.ToString) then;
            if JObject.TryGetValue('balance',ValueJToken) then
              if Evaluate(AJWebCarrier.Balance,ValueJToken.ToString) then;
            if not AJWebCarrier.Insert then
              AJWebCarrier.Modify;
          end;

        end;

        AJWebCarrier.SetRange("Web Service Code",AJWebOrderService.Code);
        if AJWebCarrier.FindFirst then repeat
          Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'carriers/listpackages?carrierCode='+AJWebCarrier.Code);

          HttpWebRequest := HttpWebRequest.Create(Uri);
          HttpWebRequest.ContentLength := 0;
          HttpWebRequest.Method := 'GET';

          HttpWebHeaders := HttpWebRequest.Headers;
          HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

          if not Http_GetResponse(HttpWebRequest,Txt) then
            Error(Txt);

          JArray := JArray.Parse(Txt);
          for i := 1 to JArray.Count do begin
            JObject := JArray.Item(i-1);

            if JObject.TryGetValue('code',ValueJToken) then begin
              AJWebCarrierPackageType."Web Service Code" := AJWebOrderService.Code;
              AJWebCarrierPackageType."Package Code" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrierPackageType."Package Code"));
              if JObject.TryGetValue('carrierCode',ValueJToken) then
                AJWebCarrierPackageType."Web Carrier Code" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrierPackageType."Web Carrier Code"));

              if AJWebCarrierPackageType.Find then;
              if JObject.TryGetValue('name',ValueJToken) then
                AJWebCarrierPackageType."Package Name":= CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrierPackageType."Package Name"));

              if JObject.TryGetValue('domestic',ValueJToken) then
                if Evaluate(AJWebCarrierPackageType.Domestic,ValueJToken.ToString) then;
              if JObject.TryGetValue('international',ValueJToken) then
                if Evaluate(AJWebCarrierPackageType.International,ValueJToken.ToString) then;
              if not AJWebCarrierPackageType.Insert then
                AJWebCarrierPackageType.Modify;
            end;
          end;

          Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'carriers/listservices?carrierCode='+AJWebCarrier.Code);
          Clear(HttpWebRequest);
          HttpWebRequest := HttpWebRequest.Create(Uri);
          HttpWebRequest.ContentLength := 0;
          HttpWebRequest.Method := 'GET';

          HttpWebHeaders := HttpWebRequest.Headers;
          HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

          if not Http_GetResponse(HttpWebRequest,Txt) then
            Error(Txt);

          JArray := JArray.Parse(Txt);
          for i := 1 to JArray.Count do begin
            JObject := JArray.Item(i-1);

            if JObject.TryGetValue('code',ValueJToken) then begin
              AJWebCarrierService."Web Service Code" := AJWebOrderService.Code;
              AJWebCarrierService."Service  Code" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrierService."Web Carrier Code"));
              if JObject.TryGetValue('carrierCode',ValueJToken) then
                AJWebCarrierService."Web Carrier Code" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrierService."Web Carrier Code"));

              if AJWebCarrierService.Find then;
              if JObject.TryGetValue('name',ValueJToken) then
                AJWebCarrierService.Name := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebCarrierService.Name));

              if JObject.TryGetValue('domestic',ValueJToken) then
                if Evaluate(AJWebCarrierService.Domestic,ValueJToken.ToString) then;
              if JObject.TryGetValue('international',ValueJToken) then
                if Evaluate(AJWebCarrierService.International,ValueJToken.ToString) then;
              if not AJWebCarrierService.Insert then
                AJWebCarrierService.Modify;
            end;
          end;
        until AJWebCarrier.Next = 0;
    end;

    local procedure ShipStation_CheckResponce(var HttpWebResponse: DotNet WebResponse;var AJWebService: Record "AJ Web Service")
    var
        HttpWebHeaders: DotNet WebHeaderCollection;
    begin
        HttpWebHeaders := HttpWebResponse.Headers;
        if Evaluate(AJWebService."Rate Limit",HttpWebHeaders.Get('X-Rate-Limit-Limit')) then;
        if Evaluate(AJWebService."Limit Remaining",HttpWebHeaders.Get('X-Rate-Limit-Remaining')) then;
        if Evaluate(AJWebService."Limit Reset",HttpWebHeaders.Get('X-Rate-Limit-Reset')) then;
        AJWebService.Modify;
        if (AJWebService."Limit Remaining" = 0) and (AJWebService."Limit Reset" <> 0) then begin
          Message('Web Service request limit reached. Reset in %1 seconds.',AJWebService."Limit Reset");
          Sleep(1000*AJWebService."Limit Reset");
        end;
    end;

    local procedure ShipStation_GetMarketlaces(AJWebOrderService: Record "AJ Web Service")
    var
        AJWebMarketplace: Record "AJ Web Marketplace (Mailbox)";
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
        JToken: JsonToken;
        JObject: JsonObject;
        i: Integer;
        ValueJToken: JsonToken;
    begin
        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");
        Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'stores/marketplaces');

        HttpWebRequest := HttpWebRequest.Create(Uri);
        HttpWebRequest.ContentLength := 0;
        HttpWebRequest.Method := 'GET';


        HttpWebHeaders := HttpWebRequest.Headers;
        HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

        HttpWebResponse := HttpWebRequest.GetResponse;
        MemoryStream := HttpWebResponse.GetResponseStream;
        StreamReader := StreamReader.StreamReader(MemoryStream,Encoding.UTF8);
        Txt := StreamReader.ReadToEnd;

        MemoryStream.Close;
        JArray := JArray.Parse(Txt);;
        for i := 1 to JArray.Count do begin
          JObject := JArray.Item(i-1);

          if JObject.TryGetValue('marketplaceId',ValueJToken) then begin
            AJWebMarketplace."Web Service Code" := AJWebOrderService.Code;
            AJWebMarketplace.Code := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebMarketplace.Code));
            if AJWebMarketplace.Find then;
            if JObject.TryGetValue('name',ValueJToken) then
              AJWebMarketplace.Description := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebMarketplace.Description));
            if JObject.TryGetValue('canRefresh',ValueJToken) then
              if Evaluate(AJWebMarketplace."Can Refresh",ValueJToken.ToString) then;
            if JObject.TryGetValue('supportsCustomMappings',ValueJToken) then
              if Evaluate(AJWebMarketplace."Supports Custom Mappings",ValueJToken.ToString) then;
            if JObject.TryGetValue('supportsCustomStatuses',ValueJToken) then
              if Evaluate(AJWebMarketplace."Supports Custom Statuses",ValueJToken.ToString) then;
            if JObject.TryGetValue('canConfirmShipments',ValueJToken) then
              if Evaluate(AJWebMarketplace."Can Confirm Shipments",ValueJToken.ToString) then;
            if not AJWebMarketplace.Insert then
              AJWebMarketplace.Modify;
          end;

        end;
        WOS_CheckResponce(AJWebOrderService,HttpWebResponse);
    end;

    local procedure ShipStation_GetWarehouses(AJWebOrderService: Record "AJ Web Service")
    var
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
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
        JToken: JsonToken;
        JObject: JsonObject;
        i: Integer;
        ValueJToken: JsonToken;
        JObject2: JsonObject;
    begin
        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");
        Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'warehouses');

        HttpWebRequest := HttpWebRequest.Create(Uri);
        HttpWebRequest.ContentLength := 0;
        HttpWebRequest.Method := 'GET';


        HttpWebHeaders := HttpWebRequest.Headers;
        HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

        HttpWebResponse := HttpWebRequest.GetResponse;
        MemoryStream := HttpWebResponse.GetResponseStream;
        StreamReader := StreamReader.StreamReader(MemoryStream,Encoding.UTF8);
        Txt := StreamReader.ReadToEnd;

        MemoryStream.Close;

        JArray := JArray.Parse(Txt);;
        for i := 1 to JArray.Count do begin
          JObject := JArray.Item(i-1);

          if JObject.TryGetValue('warehouseId',ValueJToken) then begin
            AJWebServiceWarehouse."Web Service Code" := AJWebOrderService.Code;
            AJWebServiceWarehouse."Warehouse ID" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Warehouse ID"));
            if AJWebServiceWarehouse.Find then;
            if JObject.TryGetValue('warehouseName',ValueJToken) then
              AJWebServiceWarehouse.Description := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse.Description));

            if JObject.TryGetValue('originAddress',ValueJToken) then
              JObject2 := JObject.SelectToken('originAddress');
            if JObject2.HasValues then begin
              if JObject2.TryGetValue('name',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Name" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Name"));
              if JObject2.TryGetValue('company',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Company" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Company"));
              if JObject2.TryGetValue('street1',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Address 1" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Address 1"));
              if JObject2.TryGetValue('street2',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Address 2" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Address 2"));
              if JObject2.TryGetValue('street3',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Address 3" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Address 3"));
              if JObject2.TryGetValue('city',ValueJToken) then
                AJWebServiceWarehouse."Ship-From City" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From City"));
              if JObject2.TryGetValue('state',ValueJToken) then
                AJWebServiceWarehouse."Ship-From State" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From State"));
              if JObject2.TryGetValue('postalCode',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Zip" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Zip"));
              if JObject2.TryGetValue('country',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Country" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Country"));
              if JObject2.TryGetValue('phone',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Phone" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Phone"));
              if JObject2.TryGetValue('residential',ValueJToken) then
                if Evaluate(AJWebServiceWarehouse."Ship-From Residential",ValueJToken.ToString) then;
              if JObject2.TryGetValue('addressVerified',ValueJToken) then
                AJWebServiceWarehouse."Ship-From Address Verified" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Ship-From Address Verified"));
            end;

            if JObject.TryGetValue('returnAddress',ValueJToken) then
              JObject2 := JObject.SelectToken('returnAddress');
            if JObject2.HasValues then begin
              if JObject2.TryGetValue('name',ValueJToken) then
                AJWebServiceWarehouse."Return Name" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Name"));
              if JObject2.TryGetValue('company',ValueJToken) then
                AJWebServiceWarehouse."Return Company" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Company"));
              if JObject2.TryGetValue('street1',ValueJToken) then
                AJWebServiceWarehouse."Return Address 1" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Address 1"));
              if JObject2.TryGetValue('street2',ValueJToken) then
                AJWebServiceWarehouse."Return Address 2" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Address 2"));
              if JObject2.TryGetValue('street3',ValueJToken) then
                AJWebServiceWarehouse."Return Address 3" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Address 3"));
              if JObject2.TryGetValue('city',ValueJToken) then
                AJWebServiceWarehouse."Return City" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return City"));
              if JObject2.TryGetValue('state',ValueJToken) then
                AJWebServiceWarehouse."Return State" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return State"));
              if JObject2.TryGetValue('postalCode',ValueJToken) then
                AJWebServiceWarehouse."Return Zip" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Zip"));
              if JObject2.TryGetValue('country',ValueJToken) then
                AJWebServiceWarehouse."Return Country" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Country"));
              if JObject2.TryGetValue('phone',ValueJToken) then
                AJWebServiceWarehouse."Return Phone" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Phone"));
              if JObject2.TryGetValue('residential',ValueJToken) then
                if Evaluate(AJWebServiceWarehouse."Return Residential",ValueJToken.ToString) then;
              if JObject2.TryGetValue('addressVerified',ValueJToken) then
                AJWebServiceWarehouse."Return Address Verified" := CopyStr(ValueJToken.ToString,1,MaxStrLen(AJWebServiceWarehouse."Return Address Verified"));
            end;

            if JObject.TryGetValue('createDate',ValueJToken) then
              if Evaluate(AJWebServiceWarehouse."Created At",ValueJToken.ToString) then;
            if JObject.TryGetValue('isDefault',ValueJToken) then
              if Evaluate(AJWebServiceWarehouse.Default,ValueJToken.ToString) then;

            if not AJWebServiceWarehouse.Insert then
              AJWebServiceWarehouse.Modify;
          end;

        end;
    end;

    local procedure ShipStation_GetOrderLabel(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
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
        JToken: JsonToken;
        JObject: JsonObject;
        i: Integer;
        ValueJToken: JsonToken;
        AJWebOrderService: Record "AJ Web Service";
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
          (AJWebOrderHeader."Shipping Web Service Code" <>  AJWebOrderHeader."Web Service Code")
        then begin
          ShipStation_CreateOrderForWeb(AJWebOrderHeader);
          Commit;

        end;

        if AJWebOrderHeader."Shipping Web Service Order No." = '' then begin
          ShipStation_CreateOrder(AJWebOrderHeader);
          Commit;
        end;

        AJWebOrderHeader.TestField("Shipping Web Service Order No.");

        AJWebOrderService.Get(AJWebOrderHeader."Web Service Code");

        AJWebOrderHeader.TestField("Shipping Carrier Code");
        AJWebOrderHeader.TestField("Shipping Carrier Service");
        AJWebOrderHeader.TestField("Shipping Package Type");
        AJWebOrderHeader.TestField("Shipping Delivery Confirm");

        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");
        Uri := Uri.Uri(AJWebOrderService."API Endpoint Domain"+'orders/createlabelfororder');

        HttpWebRequest := HttpWebRequest.Create(Uri);
        HttpWebRequest.Method := 'POST';
        HttpWebRequest.ContentType := 'application/json';

        HttpWebHeaders := HttpWebRequest.Headers;
        HttpWebHeaders.Add('authorization','Basic '+AJWebOrderService."API Encoded String");

        JObject := JObject.JObject(); //asd
        JSONAddTxtasDec(JObject,'orderId',AJWebOrderHeader."Shipping Web Service Order No.");
        JSONAddTxt(JObject,'carrierCode',AJWebOrderHeader."Shipping Carrier Code");
        JSONAddTxt(JObject,'serviceCode', AJWebOrderHeader."Shipping Carrier Service");
        JSONAddTxt(JObject,'packageCode',AJWebOrderHeader."Shipping Package Type");
        JSONAddTxt(JObject,'confirmation',AJWebOrderHeader."Shipping Delivery Confirm");

        if AJWebOrderHeader."Ship Date" = 0D then
          AJWebOrderHeader."Ship Date" := WorkDate;
        JSONAddTxt(JObject,'shipDate',Format(AJWebOrderHeader."Ship Date",0,'<Standard Format,9>'));

        if AJWebOrderHeader."Shp. Product Weight" = 0 then begin
            AJWebOrderLine.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
            if AJWebOrderLine.FindFirst then repeat
              if AJWebOrderLine.Weight = 0 then begin
                AJWebCarrierPackageType.Get(AJWebOrderService.Code,AJWebOrderHeader."Shipping Carrier Code",AJWebOrderHeader."Shipping Package Type");
                AJWebOrderHeader."Shp. Product Weight" := AJWebCarrierPackageType."Def. Weight";
                AJWebOrderHeader."Shp. Product Weight Unit" := AJWebCarrierPackageType."Def. Weight Unit";
              end else if (AJWebOrderHeader."Shp. Product Weight Unit" = '') then begin
                AJWebOrderLine.TestField("Weigh Unit");
                AJWebOrderHeader."Shp. Product Weight" := AJWebOrderLine.Weight;
                AJWebOrderHeader."Shp. Product Weight Unit" := AJWebOrderLine."Weigh Unit";
              end else if AJWebOrderHeader."Shp. Product Weight Unit" = AJWebOrderLine."Weigh Unit" then
                AJWebOrderHeader."Shp. Product Weight" += AJWebOrderLine.Weight
              else
                AJWebOrderHeader.TestField("Shp. Product Weight");
            until AJWebOrderLine.Next = 0;
        end;

        AJWebOrderHeader.TestField("Shp. Product Weight");
        AJWebOrderHeader.TestField("Shp. Product Weight Unit");
        AddJObject := AddJObject.JObject();
        JSONAddDec(AddJObject,'value',AJWebOrderHeader."Shp. Product Weight");
        JSONAddTxt(AddJObject,'units',AJWebOrderHeader."Shp. Product Weight Unit");
        JSONAddObject(JObject,'weight',AddJObject);

        if AJWebOrderHeader."Shp. Product Dimension Unit" = '' then
          if not SkipDefaultDimensions then begin
            AJWebCarrierPackageType.Get(AJWebOrderService.Code,AJWebOrderHeader."Shipping Carrier Code",AJWebOrderHeader."Shipping Package Type");
            AJWebOrderHeader."Shp. Product Dimension Unit" := AJWebCarrierPackageType."Def. Dimension Unit";
            AJWebOrderHeader."Shp. Product Width" := AJWebCarrierPackageType."Def. Width";
            AJWebOrderHeader."Shp. Product Length" := AJWebCarrierPackageType."Def. Length";
            AJWebOrderHeader."Shp. Product Height" := AJWebCarrierPackageType."Def. Height";
          end;

        if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
          AddJObject := AddJObject.JObject();
          if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
            JSONAddTxt(AddJObject,'units',AJWebOrderHeader."Shp. Product Dimension Unit");
            JSONAddDec(AddJObject,'length',AJWebOrderHeader."Shp. Product Length");
            JSONAddDec(AddJObject,'width',AJWebOrderHeader."Shp. Product Width");
            JSONAddDec(AddJObject,'height',AJWebOrderHeader."Shp. Product Height");
            JSONAddObject(JObject,'dimensions',AddJObject);
          end else
            JSONAddNULL(JObject,'dimensions');
        end;

        if AJWebOrderHeader."Insure Shipment" then begin
          AddJObject := AddJObject.JObject();
          JSONAddTxt(AddJObject,'provider','carrier');// "shipsurance" or "carrier"
          JSONAddBool(AddJObject,'insureShipment',true);
          JSONAddDec(AddJObject,'insuredValue', AJWebOrderHeader."Insured Value"+AJWebOrderHeader."Additional Insurance Value");
          JSONAddObject(JObject,'insuranceOptions',AddJObject);
        end else
          JSONAddNULL(JObject,'insuranceOptions');

        if AJWebOrderHeader."International Shipment" then begin

          SalesHeader.Reset;
          SalesHeader.SetFilter("Document Type",'%1|%2',
            SalesHeader."Document Type"::Order,SalesHeader."Document Type"::Invoice);
          SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
          if SalesHeader.FindFirst then begin

            JArray := JArray.JArray();

            SalesLine.Reset;
            SalesLine.SetRange("Document Type",SalesHeader."Document Type");
            SalesLine.SetRange("Document No.",SalesHeader."No.");
            SalesLine.SetRange(Type,SalesLine.Type::Item);
            SalesLine.SetFilter("No.",'<>%1','');
            SalesLine.SetFilter(Quantity,'<>%1',0);
            SalesLine.SetFilter("Qty. to Ship",'<>0');
            if SalesLine.FindFirst then repeat

              Item.Get(SalesLine."No.");

              AddJObject := AddJObject.JObject();
              JSONAddTxt(AddJObject,'description',Item.Description);
              JSONAddDec(AddJObject,'quantity', SalesLine."Qty. to Ship");
              JSONAddDec(AddJObject,'value', SalesLine."Unit Price");

              JToken := AddJObject;
              JArray.Add(JToken);
            until SalesLine.Next = 0
            else
              Error('No items to ship has been found!');

            AddJObject := AddJObject.JObject();
            JSONAddTxt(AddJObject,'contents','merchandise');
            AddJObject.Add('customsItems',JArray);
            JObject.Add('internationalOptions',AddJObject);
          end;

        end else
          JSONAddNULL(JObject,'internationalOptions');

        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject,'warehouseId',AJWebOrderHeader."Ship-From Warehouse ID");
        JSONAddBool(AddJObject,'nonMachinable',AJWebOrderHeader."Non Machinable");
        JSONAddBool(AddJObject,'saturdayDelivery',AJWebOrderHeader."Saturday Delivery");
        JSONAddBool(AddJObject,'containsAlcohol',AJWebOrderHeader."Contains Alcohol");
        //JSONAddTxt(AddJObject,'storeId', '51791'); // MBS commented

        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
        if SalesHeader.FindFirst then begin
          JSONAddTxt(AddJObject,'customField1',SalesHeader."No.");   //sales order #
          JSONAddTxt(AddJObject,'customField2',SalesHeader."External Document No.");  //external document #
        end;

        JSONAddTxt(AddJObject,'customField3',AJWebOrderHeader."Custom Field 3");

        //for third party billing
        if AJWebOrderHeader."Bill-to Type" <> 0 then begin
          JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebOrderHeader."Bill-to Type"));
          if AJWebOrderHeader."Bill-to Type" = AJWebOrderHeader."Bill-to Type"::my_other_account then
            JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebOrderHeader."Bill-To Account")
          else
            JSONAddTxt(AddJObject,'billToAccount', AJWebOrderHeader."Bill-To Account");
          JSONAddTxt(AddJObject,'billToPostalCode', AJWebOrderHeader."Bill-To Postal Code");
          JSONAddTxt(AddJObject,'billToCountryCode', AJWebOrderHeader."Bill-To Country Code");
        end else begin
          // take Bill-to default from WEB SERVICE, NOT SHIPPING WEB SERVICE
          AJWebCarrier.Get(AJWebOrderHeader."Web Service Code", AJWebOrderHeader."Shipping Carrier Code");
          if AJWebCarrier."Bill-to Type" <> 0 then begin
              JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebCarrier."Bill-to Type"));
              if AJWebCarrier."Bill-to Type" = AJWebCarrier."Bill-to Type"::my_other_account then
                JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebCarrier."Bill-to Account No.")
              else
              JSONAddTxt(AddJObject,'billToAccount', AJWebCarrier."Bill-to Account No.");
              JSONAddTxt(AddJObject,'billToPostalCode', AJWebCarrier."Bill-to Account Post Code");
              JSONAddTxt(AddJObject,'billToCountryCode', AJWebCarrier."Bill-to Account Country Code");
              AJWebOrderHeader."Bill-to Type" := AJWebCarrier."Bill-to Type";
              AJWebOrderHeader."Bill-To Account" := AJWebCarrier."Bill-to Account No.";
              AJWebOrderHeader."Bill-To Postal Code" := AJWebCarrier."Bill-to Account Post Code";
              AJWebOrderHeader."Bill-To Country Code" := AJWebCarrier."Bill-to Account Country Code";
          end;
        end;
        JSONAddObject(JObject,'advancedOptions',AddJObject);

        // "Fedex does not support test labels at this time."
        if LowerCase(AJWebOrderHeader."Shipping Carrier Code") <> 'fedex' then
          JSONAddBool(JObject,'testLabel', true);

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
          AJWebOrderHeader."Shipping Agent Label".CreateOutStream(LabelOutSteram);
          LabelMemoryStream.WriteTo(LabelOutSteram);
          LabelMemoryStream.Flush();
          LabelMemoryStream.Close();
          AJWebOrderHeader."Carier Shipping Charge" := JSONGetDec(JObject,'shipmentCost');
          AJWebOrderHeader."Carier Tracking Number" :=  JSONGetTxt(JObject,'trackingNumber',MaxStrLen(AJWebOrderHeader."Carier Tracking Number"));
          AJWebOrderHeader."Carier Insurance Cost" :=  JSONGetDec(JObject,'insuranceCost');
        end;

        // Test CASE?
          AJWebOrderHeader."Web Service Shipment ID" := JSONGetTxt(JObject,'shipmentId',MaxStrLen(AJWebOrderHeader."Web Service Shipment ID"));
          AJWebOrderHeader."Labels Created" := true;
          AJWebOrderHeader."Labels Printed" := false;
        // Test CASE?

        AJWebOrderHeader.Modify;
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
        JToken: JsonToken;
        JObject: JsonObject;
        i: Integer;
        ValueJToken: JsonToken;
        AJWebOrderService: Record "AJ Web Service";
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
        JObject: JsonObject;
        ValueJToken: JsonToken;
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

    local procedure ShipStation_SaveLabel(AJWebOrderHeader: Record "AJ Web Order Header")
    var
        WinShell: Automation ;
        FileManagement: Codeunit "File Management";
        TempBlob: Record TempBlob temporary;
        OS: OutStream;
        IS: InStream;
        ToFile: Text;
        AJWebCarrier: Record "AJ Web Carrier";
        [RunOnClient]
        PdfDocInput: DotNet PdfDocument;
        [RunOnClient]
        PdfPage: DotNet PdfPage;
        [RunOnClient]
        PdfReader: DotNet PdfReader;
        [RunOnClient]
        PdfOpenMode: DotNet PdfDocumentOpenMode;
        [RunOnClient]
        PdfDPageGfx: DotNet XGraphics;
        [RunOnClient]
        PdfXPDFForm: DotNet XPdfForm;
        [RunOnClient]
        PdfDrRect: DotNet XRect;
        [RunOnClient]
        pvDN_PdfDocOutput: DotNet PdfDocument;
        ServerFile: Text;
        LocalFile: Text;
        LabelFileOut: Text;
    begin
        AJWebOrderHeader.Find;
        AJWebOrderHeader.CalcFields("Shipping Agent Label");
        if AJWebOrderHeader."Shipping Agent Label".HasValue then begin
          if AJWebCarrier.Get(AJWebOrderHeader."Shipping Web Service Code" , AJWebOrderHeader."Shipping Carrier Code") then
            if AJWebCarrier."Shipping Label to A5 format" then
            begin
                ServerFile := FileManagement.ServerTempFileName('pdf');
                LocalFile := FileManagement.ClientTempFileName('pdf');

                AJWebOrderHeader."Shipping Agent Label".Export(ServerFile);
                FileManagement.DownloadToFile(ServerFile,LocalFile);

                PdfDocInput := PdfReader.Open(LocalFile, PdfOpenMode.Import);

                PdfPage := PdfDocInput.Pages.Item(0);
                PdfPage.Rotate(90);

                pvDN_PdfDocOutput := pvDN_PdfDocOutput.PdfDocument;
                pvDN_PdfDocOutput.AddPage(PdfPage);
                LocalFile := FileManagement.ClientTempFileName('pdf');
                pvDN_PdfDocOutput.Save(LocalFile);

                pvDN_PdfDocOutput := pvDN_PdfDocOutput.PdfDocument;
                PdfPage := pvDN_PdfDocOutput.AddPage();
                PdfDPageGfx := PdfDPageGfx.FromPdfPage(PdfPage);
                PdfXPDFForm := PdfXPDFForm.FromFile(LocalFile);
                PdfDrRect  := PdfDrRect.XRect(140,36,430,289);
                PdfDPageGfx.DrawImage(PdfXPDFForm, PdfDrRect);

                LabelFileOut := FileManagement.ClientTempFileName('pdf');
                pvDN_PdfDocOutput.Save(LabelFileOut);

                ServerFile := FileManagement.UploadFile('Serv', LabelFileOut);
                AJWebOrderHeader."Shipping Agent Label".Import(ServerFile);
            end;
          AJWebOrderHeader."Shipping Agent Label".CreateInStream(IS);
          ToFile := 'LBL-' + AJWebOrderHeader."Web Order No." + '.pdf';
          DownloadFromStream(IS,'Save label as','C:\','Adobe Acrobat file(*.pdf)|*.pdf',ToFile);
        end;
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
        JToken: JsonToken;
        JObject: JsonObject;
        i: Integer;
        ValueJToken: JsonToken;
        AJWebOrderService: Record "AJ Web Service";
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

    [Scope('Internal')]
    procedure ShipStation_CreateOrder(var AJWebOrderHeader: Record "AJ Web Order Header")
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
        JToken: JsonToken;
        JObject: JsonObject;
        i: Integer;
        ValueJToken: JsonToken;
        AJWebOrderService: Record "AJ Web Service";
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
        SystemTextUTF8Encoding: DotNet UTF8Encoding;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        CountryRegion: Record "Country/Region";
        AJWebService2: Record "AJ Web Service";
    begin
        if AJWebOrderHeader."Shipping Web Service Code" <> '' then
          AJWebOrderService.Get(AJWebOrderHeader."Shipping Web Service Code")
        else
          AJWebOrderService.Get(AJWebOrderHeader."Web Service Code");

        AJWebOrderService.TestField("API Endpoint Domain");
        AJWebOrderService.TestField("API Encoded String");

        AJWebServiceWarehouse.Get(AJWebOrderService.Code,AJWebOrderHeader."Ship-From Warehouse ID");

        if AJWebServiceWarehouse."Ship-From Country" = '' then
          AJWebServiceWarehouse."Ship-From Country" := 'US';
        if AJWebOrderHeader."Shipping Carrier Code" = '' then
          AJWebOrderHeader."Shipping Carrier Code" := AJWebServiceWarehouse."Def. Shipping Carrier Code";
        if AJWebOrderHeader."Shipping Carrier Service" = '' then
          AJWebOrderHeader."Shipping Carrier Service" := AJWebServiceWarehouse."Def. Shipping Carrier Service";
        if AJWebOrderHeader."Shipping Package Type" = '' then
          AJWebOrderHeader."Shipping Package Type" := AJWebServiceWarehouse."Def. Shipping Package Type";
        if AJWebOrderHeader."Shipping Delivery Confirm" = '' then
          AJWebOrderHeader."Shipping Delivery Confirm" := AJWebServiceWarehouse."Def. Shipping Delivery Confirm";
        if AJWebOrderHeader."Shipping Insutance Provider" = '' then
          AJWebOrderHeader."Shipping Insutance Provider" := AJWebServiceWarehouse."Def. Shipping Insutance Provd";
        if (AJWebOrderHeader."Ship Date" = 0D) or (AJWebOrderHeader."Ship Date" < WorkDate) then
          AJWebOrderHeader."Ship Date" := WorkDate;
        if AJWebOrderHeader."Ship-To Customer Country" = '' then
          AJWebOrderHeader."Ship-To Customer Country" := 'US';

        if AJWebOrderHeader."Bill-To Customer Country" = 'USA'
          then AJWebOrderHeader."Bill-To Customer Country" := 'US';
        if AJWebOrderHeader."Bill-To Customer Country" = '' then
          AJWebOrderHeader."Bill-To Customer Country" := 'US';

        AJWebOrderHeader."International Shipment" := AJWebOrderHeader."Ship-To Customer Country" <> 'US';

        AJWebOrderHeader.TestField("Ship-From Warehouse ID");
        AJWebOrderHeader.TestField("Shipping Carrier Code");
        AJWebOrderHeader.TestField("Shipping Carrier Service");
        AJWebOrderHeader.TestField("Shipping Package Type");
        AJWebOrderHeader.TestField("Shipping Delivery Confirm");

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

        //>> LABEL INFO

        JSONAddTxt(JObject,'carrierCode',AJWebOrderHeader."Shipping Carrier Code");
        JSONAddTxt(JObject,'serviceCode',AJWebOrderHeader."Shipping Carrier Service");
        JSONAddTxt(JObject,'packageCode',AJWebOrderHeader."Shipping Package Type");
        JSONAddTxt(JObject,'confirmation',AJWebOrderHeader."Shipping Delivery Confirm");

        if AJWebOrderHeader."Ship Date" = 0D then
          AJWebOrderHeader."Ship Date" := WorkDate;
        JSONAddTxt(JObject,'shipDate',Format(AJWebOrderHeader."Ship Date",0,'<Standard Format,9>'));

        if AJWebOrderHeader."Shp. Product Weight" = 0 then begin
            AJWebOrderLine.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
            if AJWebOrderLine.FindFirst then repeat
              if AJWebOrderLine.Weight = 0 then begin
                AJWebCarrierPackageType.Get(AJWebOrderService.Code,AJWebOrderHeader."Shipping Carrier Code",AJWebOrderHeader."Shipping Package Type");
                AJWebOrderHeader."Shp. Product Weight" := AJWebCarrierPackageType."Def. Weight";
                AJWebOrderHeader."Shp. Product Weight Unit" := AJWebCarrierPackageType."Def. Weight Unit";
              end else if (AJWebOrderHeader."Shp. Product Weight Unit" = '') then begin
                AJWebOrderLine.TestField("Weigh Unit");
                AJWebOrderHeader."Shp. Product Weight" := AJWebOrderLine.Weight;
                AJWebOrderHeader."Shp. Product Weight Unit" := AJWebOrderLine."Weigh Unit";
              end else if AJWebOrderHeader."Shp. Product Weight Unit" = AJWebOrderLine."Weigh Unit" then
                AJWebOrderHeader."Shp. Product Weight" += AJWebOrderLine.Weight
              else
                AJWebOrderHeader.TestField("Shp. Product Weight");
            until AJWebOrderLine.Next = 0;
        end;

        AJWebOrderHeader.TestField("Shp. Product Weight");
        AJWebOrderHeader.TestField("Shp. Product Weight Unit");
        AddJObject := AddJObject.JObject();
        JSONAddDec(AddJObject,'value',AJWebOrderHeader."Shp. Product Weight");
        JSONAddTxt(AddJObject,'units',AJWebOrderHeader."Shp. Product Weight Unit");
        JSONAddObject(JObject,'weight',AddJObject);

        if AJWebOrderHeader."Shp. Product Dimension Unit" = '' then
          if false then begin
            AJWebCarrierPackageType.Get(AJWebOrderService.Code,AJWebOrderHeader."Shipping Carrier Code",AJWebOrderHeader."Shipping Package Type");
            AJWebOrderHeader."Shp. Product Dimension Unit" := AJWebCarrierPackageType."Def. Dimension Unit";
            AJWebOrderHeader."Shp. Product Width" := AJWebCarrierPackageType."Def. Width";
            AJWebOrderHeader."Shp. Product Length" := AJWebCarrierPackageType."Def. Length";
            AJWebOrderHeader."Shp. Product Height" := AJWebCarrierPackageType."Def. Height";
          end;

        if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
          AddJObject := AddJObject.JObject();
          if AJWebOrderHeader."Shp. Product Dimension Unit" <> '' then begin
            JSONAddTxt(AddJObject,'units',AJWebOrderHeader."Shp. Product Dimension Unit");
            JSONAddDec(AddJObject,'length',AJWebOrderHeader."Shp. Product Length");
            JSONAddDec(AddJObject,'width',AJWebOrderHeader."Shp. Product Width");
            JSONAddDec(AddJObject,'height',AJWebOrderHeader."Shp. Product Height");
            JSONAddObject(JObject,'dimensions',AddJObject);
          end else
            JSONAddNULL(JObject,'dimensions');
        end;

        if AJWebOrderHeader."Insure Shipment" then begin
          AddJObject := AddJObject.JObject();
          JSONAddTxt(AddJObject,'provider','carrier');// "shipsurance" or "carrier"
          JSONAddBool(AddJObject,'insureShipment',true);
          JSONAddDec(AddJObject,'insuredValue', AJWebOrderHeader."Insured Value");
          JSONAddObject(JObject,'insuranceOptions',AddJObject);
        end else begin
          AddJObject := AddJObject.JObject();
          JSONAddTxt(AddJObject,'provider','carrier');
          JSONAddBool(AddJObject,'insureShipment',false);
          JSONAddDec(AddJObject,'insuredValue',0);
          JSONAddObject(JObject,'insuranceOptions',AddJObject);
        end;


        if AJWebOrderHeader."International Shipment" then begin
          SalesHeader.Reset;
          SalesHeader.SetFilter("Document Type",'%1|%2',
            SalesHeader."Document Type"::Order,SalesHeader."Document Type"::Invoice);
          SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
          if SalesHeader.FindFirst then begin

            JArray := JArray.JArray();

            SalesLine.Reset;
            SalesLine.SetRange("Document Type",SalesHeader."Document Type");
            SalesLine.SetRange("Document No.",SalesHeader."No.");
            SalesLine.SetRange(Type,SalesLine.Type::Item);
            SalesLine.SetFilter("No.",'<>%1','');
            SalesLine.SetFilter(Quantity,'<>%1',0);
            SalesLine.SetFilter("Qty. to Ship",'<>0');
            if SalesLine.FindFirst then repeat

              Item.Get(SalesLine."No.");

              AddJObject := AddJObject.JObject();
              JSONAddTxt(AddJObject,'description',Item.Description);
              JSONAddDec(AddJObject,'quantity', SalesLine."Qty. to Ship");
              JSONAddDec(AddJObject,'value', SalesLine."Unit Price");

              JToken := AddJObject;
              JArray.Add(JToken);
            until SalesLine.Next = 0
            else
              Error('No items to ship has been found!');

            AddJObject := AddJObject.JObject();
            JSONAddTxt(AddJObject,'contents','merchandise');
            AddJObject.Add('customsItems',JArray);
            JObject.Add('internationalOptions',AddJObject);
          end;


        end else
          JSONAddNULL(JObject,'internationalOptions');

        //<< LABEL INFO

        AddJObject := AddJObject.JObject();
        JSONAddTxt(AddJObject,'name',AJWebOrderHeader."Bill-To Customer Name");
        JSONAddTxt(AddJObject,'company',AJWebOrderHeader."Bill-To Company");
        JSONAddTxt(AddJObject,'street1',AJWebOrderHeader."Bill-To Customer Address 1");
        JSONAddTxt(AddJObject,'street2',AJWebOrderHeader."Bill-To Customer Address 2");
        JSONAddTxt(AddJObject,'street3',AJWebOrderHeader."Bill-To Customer Address 3");

        AJWebCarrier.Get(AJWebOrderService.Code, AJWebOrderHeader."Shipping Carrier Code");

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
        //JSONAddTxt(AddJObject,'storeId','51791'); //MBS commented wtf?
        JSONAddTxt(AddJObject,'customField1',AJWebOrderHeader."Web Service PO Number");   //sales order #
        JSONAddTxt(AddJObject,'customField2',AJWebOrderHeader."Customer Reference ID");  //external document #

        AJWebService2.Get(AJWebOrderHeader."Web Service Code");
        if AJWebService2."Reference 3" <> AJWebService2."Reference 3"::PO then

        //>> COD
        AJWebOrderHeader."Custom Field 3" := IsCOD(AJWebOrderHeader);

        if StrPos(UpperCase(UserId),'SK') > 0 then
          JSONAddTxt(AddJObject,'customField3','CUSTOM3')
        else

        JSONAddTxt(AddJObject,'customField3',AJWebOrderHeader."Custom Field 3");

        // take Bill-to default from WEB SERVICE, NOT SHIPPING WEB SERVICE
        AJWebCarrier.Get(AJWebOrderHeader."Web Service Code", AJWebOrderHeader."Shipping Carrier Code");
        if AJWebOrderHeader."Bill-to Type" <> 0 then begin
          JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebOrderHeader."Bill-to Type"));
          if AJWebOrderHeader."Bill-to Type" = AJWebOrderHeader."Bill-to Type"::my_other_account then
            JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebOrderHeader."Bill-To Account")
          else
            JSONAddTxt(AddJObject,'billToAccount', AJWebOrderHeader."Bill-To Account");
          JSONAddTxt(AddJObject,'billToPostalCode', AJWebOrderHeader."Bill-To Postal Code");
          JSONAddTxt(AddJObject,'billToCountryCode', AJWebOrderHeader."Bill-To Country Code");
        end else begin
          if AJWebCarrier."Bill-to Type" <> 0 then begin
              JSONAddTxt(AddJObject,'billToParty', GetBillToTypeName(AJWebCarrier."Bill-to Type"));
              if AJWebCarrier."Bill-to Type" = AJWebCarrier."Bill-to Type"::my_other_account then
                JSONAddTxt(AddJObject,'billToMyOtherAccount', AJWebCarrier."Bill-to Account No.")
              else
              JSONAddTxt(AddJObject,'billToAccount', AJWebCarrier."Bill-to Account No.");
              JSONAddTxt(AddJObject,'billToPostalCode', AJWebCarrier."Bill-to Account Post Code");
              JSONAddTxt(AddJObject,'billToCountryCode', AJWebCarrier."Bill-to Account Country Code");
          end;
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

        if not Http_GetResponse(HttpWebRequest,Txt) then
          Error('Web service error:\%1',Txt);

        JObject := JObject.Parse(Txt);
        if JObject.TryGetValue('orderId',ValueJToken) then begin
          AJWebOrderHeader."Shipping Web Service Order No." := ValueJToken.ToString();
          AJWebOrderHeader.Modify;
        end;
    end;

    local procedure ShipStation_MergeLabels(var pvr_AJWebOrderHeader: Record "AJ Web Order Header";var pvDN_PdfDocOutput: DotNet PdfDocument;pb_CreateNew: Boolean;pb_Print: Boolean)
    var
        lr_AJWebOrderHeader: Record "AJ Web Order Header";
        WinShell: Automation ;
        FileManagement: Codeunit "File Management";
        ServerFile: Text;
        LocalFile: Text;
        MergedFile: Text;
        WinShellCommand: Text;
        WindowState: Boolean;
        WaitReturn: Boolean;
        Environment: DotNet Environment;
        i: Integer;
        [RunOnClient]
        PdfDocInput: DotNet PdfDocument;
        [RunOnClient]
        PdfPage: DotNet PdfPage;
        [RunOnClient]
        PdfReader: DotNet PdfReader;
        [RunOnClient]
        PdfOpenMode: DotNet PdfDocumentOpenMode;
    begin
        lr_AJWebOrderHeader.Copy(pvr_AJWebOrderHeader);
        lr_AJWebOrderHeader.CalcFields("Shipping Agent Label");

        if not FileManagement.ClientFileExists('D:\Users') then
          Error('Adobe Acrobat not found!\' + ConvertStr('D:\Users','\','/'));

        if lr_AJWebOrderHeader.FindSet then begin
          if pb_CreateNew then begin
            pvDN_PdfDocOutput := pvDN_PdfDocOutput.PdfDocument;
          end;

          repeat
            if lr_AJWebOrderHeader."Shipping Agent Label".HasValue then begin
              lr_AJWebOrderHeader.CalcFields("Shipping Agent Label");
              ServerFile := FileManagement.ServerTempFileName('pdf');
              LocalFile := FileManagement.ClientTempFileName('pdf');

              lr_AJWebOrderHeader."Shipping Agent Label".Export(ServerFile);
              FileManagement.DownloadToFile(ServerFile,LocalFile);

              PdfDocInput := PdfReader.Open(LocalFile, PdfOpenMode.Import);

              for i := 0 to PdfDocInput.Pages.Count - 1 do begin
                PdfPage := PdfDocInput.Pages.Item(i);
                pvDN_PdfDocOutput.AddPage(PdfPage);
              end;

            end else Error(StrSubstNo(Text009, lr_AJWebOrderHeader."Web Order No."));
            FileManagement.DeleteClientFile(LocalFile);
          until lr_AJWebOrderHeader.Next = 0;

        end;

        if pb_Print then begin
          LocalFile := FileManagement.ClientTempFileName('pdf');

          pvDN_PdfDocOutput.Save(LocalFile);

          Create(WinShell,false,true);
          WinShellCommand := StrSubstNo('"%1" /h /t "%2" %3','D:\Users',LocalFile,'\\BORW1-DEVONL\DYMO-DEVON',Environment.SystemDirectory,'cmd.exe');
          WinShell.Run(WinShellCommand);

          pvr_AJWebOrderHeader.ModifyAll("Labels Printed", true);
        end;
    end;

    local procedure "----------Packages<"()
    begin
    end;

    local procedure "<JSON>"()
    begin
    end;

    [Scope('Internal')]
    procedure JSONAddTxt(var JObject: JsonObject;PropertyName: Text;PropertyValue: Text)
    var
        JToken: JsonToken;
        SystemWebHttpUtility: DotNet HttpUtility;
    begin

        if PropertyValue = '' then
          if ReplaceNULL then
            JObject.Add(PropertyName,JToken.Parse('""'))
          else
            JObject.Add(PropertyName,JToken.Parse('null'))
        else
          JObject.Add(PropertyName,JToken.Parse(SystemWebHttpUtility.JavaScriptStringEncode(PropertyValue,true)));
    end;

    [Scope('Internal')]
    procedure JSONAddDec(var JObject: JsonObject;PropertyName: Text;PropertyValue: Decimal)
    var
        JToken: JsonToken;
    begin

        JObject.Add(PropertyName,JToken.Parse(Format(PropertyValue,20,'<Sign><Integer><Decimals>')));
    end;

    [Scope('Internal')]
    procedure JSONAddBigInt(var JObject: JsonObject;PropertyName: Text;PropertyValue: BigInteger)
    var
        JToken: JsonToken;
    begin
        JObject.Add(PropertyName,JToken.Parse(Format(PropertyValue)));
    end;

    [Scope('Internal')]
    procedure JSONAddObject(var JObject: JsonObject;PropertyName: Text;AddJObject: JsonObject)
    var
        JToken: JsonToken;
    begin
        JObject.Add(PropertyName,JToken.Parse(AddJObject.ToString()));
    end;

    [Scope('Internal')]
    procedure JSONAddNULL(var JObject: JsonObject;PropertyName: Text)
    var
        JToken: JsonToken;
    begin
        JObject.Add(PropertyName,JToken.Parse('null'));
    end;

    [Scope('Internal')]
    procedure JSONAddBool(var JObject: JsonObject;PropertyName: Text;PropertyValue: Boolean)
    var
        JToken: JsonToken;
    begin
        if PropertyValue then
          JObject.Add(PropertyName,JToken.Parse('true'))
        else
          JObject.Add(PropertyName,JToken.Parse('false'));
    end;

    [Scope('Internal')]
    procedure JSONAddTxtasDec(var JObject: JsonObject;PropertyName: Text;PropertyValue: Text)
    var
        JToken: JsonToken;
    begin
        if PropertyValue = '' then
          JObject.Add(PropertyName,JToken.Parse('null'))
        else
          JObject.Add(PropertyName,JToken.Parse(PropertyValue));
    end;

    [Scope('Internal')]
    procedure JSONGetTxt(var JObject: JsonObject;PropertyName: Text;MaxLen: Integer): Text
    var
        JToken: JsonToken;
    begin
        if JObject.TryGetValue(PropertyName,JToken) then
          if MaxLen = 0 then
            exit(JToken.ToString)
          else
            exit(CopyStr(JToken.ToString,1,MaxLen));
    end;

    [Scope('Internal')]
    procedure JSONGetDec(var JObject: JsonObject;PropertyName: Text) RetValue: Decimal
    var
        JToken: JsonToken;
    begin
        if JObject.TryGetValue(PropertyName,JToken) then
          if Evaluate(RetValue,JToken.ToString) then;
    end;

    [Scope('Internal')]
    procedure JSONGetBool(var JObject: JsonObject;PropertyName: Text) RetValue: Boolean
    var
        JToken: JsonToken;
    begin
        if JObject.TryGetValue(PropertyName,JToken) then
          if Evaluate(RetValue,JToken.ToString) then;
    end;

    [Scope('Internal')]
    procedure JSONAddToArray(var JArray: DotNet JArray;AddJObject: JsonObject)
    var
        JToken: JsonToken;
    begin
        JArray.Add(JToken.Parse(AddJObject.ToString()));
    end;

    [Scope('Internal')]
    procedure JSONAddArray(var JObject: JsonObject;PropertyName: Text;var JArray: DotNet JArray)
    var
        JToken: JsonToken;
    begin
        JObject.Add(PropertyName,JToken.Parse(JArray.ToString()));
    end;

    [Scope('Internal')]
    procedure JSONSetReplaceNULL(NewReplaceNULL: Boolean)
    begin
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
        if (AJWebPackage."Source Type" <> DATABASE::"AJ Web Order Header") then
          exit;
        AJWebOrderHeader.Get(AJWebPackage."Source No.");
        SalesHeader.SetRange("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
        if not SalesHeader.FindFirst then
          exit;

        AJWebOrderHeader.CalcFields("Packages Ship. & Hand. Amount");
        if SalesHeader."Shipping & Handling Amount" <> AJWebOrderHeader."Packages Ship. & Hand. Amount" then begin
          SalesHeader."Shipping & Handling Amount" := AJWebOrderHeader."Packages Ship. & Hand. Amount";
          SalesHeader.Modify;
        end;
    end;

    [Scope('Internal')]
    procedure WOS_CreateWebOrderFromSalesOrder(var SalesHeader: Record "Sales Header";var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        SalesLine: Record "Sales Line";
        AJWebOrderLine: Record "AJ Web Order Line";
        ShiptoAddress: Record "Ship-to Address";
        Customer: Record Customer;
        Currency: Record Currency;
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        AJWebService: Record "AJ Web Service";
        ShippingAgentServices: Record "Shipping Agent Services";
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
        AJWebOrderHeader."Custom Field 1" := 'ID: ' +SalesHeader."Sell-to Customer No." + ' DOC: ' + SalesHeader."No.";
        AJWebOrderHeader."Custom Field 2" := SalesHeader."Your Reference";

        AJWebOrderHeader."Custom Field 3" := SalesHeader."External Document No.";

        AJWebOrderHeader."Order DateTime" := CreateDateTime(SalesHeader."Order Date",0T);

        AJWebOrderHeader."Bill-To Customer Name" := SalesHeader."Bill-to Name";
        AJWebOrderHeader."Bill-To Company" := SalesHeader."Bill-to Name";
        AJWebOrderHeader."Bill-To Customer Address 1" := SalesHeader."Bill-to Address";
        AJWebOrderHeader."Bill-To Customer Address 2" := SalesHeader."Bill-to Address 2";
        AJWebOrderHeader."Bill-To Customer Address 3" := '';
        AJWebOrderHeader."Bill-To Customer City" := SalesHeader."Bill-to City";
        AJWebOrderHeader."Bill-To Customer State" := SalesHeader."Bill-to County";
        AJWebOrderHeader."Bill-To Customer Zip" := SalesHeader."Bill-to Post Code";
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
        AJWebOrderHeader."Ship-To Customer State" := SalesHeader."Ship-to County";
        AJWebOrderHeader."Ship-To Customer Zip" := SalesHeader."Ship-to Post Code";
        AJWebOrderHeader."Ship-To Customer Country" := SalesHeader."Ship-to Country/Region Code";
        //AJWebOrderHeader."Ship-To Customer Phone" := SalesHeader."Ship-to Phone No.";
        AJWebOrderHeader."Ship-To Residential" := false;
        //AJWebOrderHeader."Ship-To E-mail" := SalesHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesHeader."Salesperson Code") then
          SalespersonPurchaser.Init;
        if SalespersonPurchaser."E-Mail" <> '' then
          if StrLen(AJWebOrderHeader."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJWebOrderHeader."Ship-To E-mail") then
            if AJWebOrderHeader."Ship-To E-mail" = '' then
              AJWebOrderHeader."Ship-To E-mail" := SalespersonPurchaser."E-Mail"
            else
              AJWebOrderHeader."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";


        if not AJWebService.Get(AJWebOrderHeader."Shipping Web Service Code") then
          AJWebService.Init;

        AJWebOrderHeader."Merchandise Amount" := 0;
        // MBS commented >>
        // IF (SalesHeader."Shipping Agent Code" <> '') AND (SalesHeader."Shipping Agent Service Code" <> '') THEN
        //  IF ShippingAgentServices.GET(SalesHeader."Shipping Agent Code", SalesHeader."Shipping Agent Service Code") THEN
        //     AJWebOrderHeader."Saturday Delivery" := ShippingAgentServices."Saturday Delivery";
        // MBS commented <<
        AJWebOrderHeader.Modify;

        AJWebOrderHeader.TestField("Ship-To Customer Address 1");

        if AJWebOrderHeader."Created From Sales Order" then begin
          AJWebOrderLine.Reset;
          AJWebOrderLine.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
          if not AJWebOrderLine.IsEmpty then
            AJWebOrderLine.DeleteAll(true);

          Currency.InitRoundingPrecision;
          AJWebOrderHeader."Merchandise Amount" := 0;
          if SalesHeader."Document Type" = -1 then begin
            SalesInvoiceLine.Reset;
            SalesInvoiceLine.SetRange("Document No.",SalesHeader."No.");
            SalesInvoiceLine.SetRange(Type,SalesLine.Type::Item);
            SalesInvoiceLine.SetFilter("No.",'<>%1','');
            SalesInvoiceLine.SetFilter(Quantity,'<>%1',0);
            if SalesInvoiceLine.FindFirst then repeat
              AJWebOrderLine.Init;
              AJWebOrderLine."Web Order No." := AJWebOrderHeader."Web Order No.";
              AJWebOrderLine."Line No." := SalesInvoiceLine."Line No.";
              AJWebOrderLine."Order Item ID"  := SalesInvoiceLine."No.";
              AJWebOrderLine.Quantity := SalesInvoiceLine.Quantity;
              AJWebOrderLine."Unit Price" := Round(SalesInvoiceLine."Amount Including VAT" / SalesInvoiceLine.Quantity,0.001);
              AJWebOrderLine.Insert;
              AJWebOrderHeader."Merchandise Amount" += AJWebOrderLine.Quantity * AJWebOrderLine."Unit Price";
            until SalesInvoiceLine.Next = 0;
          end else begin
            SalesLine.Reset;
            SalesLine.SetRange("Document Type",SalesHeader."Document Type");
            SalesLine.SetRange("Document No.",SalesHeader."No.");
            SalesLine.SetRange(Type,SalesLine.Type::Item);
            SalesLine.SetFilter("No.",'<>%1','');
            SalesLine.SetFilter("Qty. to Ship",'<>%1',0);
            if SalesLine.FindFirst then repeat
              AJWebOrderLine.Init;
              AJWebOrderLine."Web Order No." := AJWebOrderHeader."Web Order No.";
              AJWebOrderLine."Line No." := SalesLine."Line No.";
              AJWebOrderLine."Order Item ID"  := SalesLine."No.";
              AJWebOrderLine.Quantity := SalesLine."Qty. to Ship";
              AJWebOrderLine."Unit Price" := Round(SalesLine."Amount Including VAT"/SalesLine.Quantity,Currency."Unit-Amount Rounding Precision");
              AJWebOrderLine.Name := SalesLine.Description;
              AJWebOrderLine.Insert;

              AJWebOrderHeader."Merchandise Amount" += AJWebOrderLine.Quantity * AJWebOrderLine."Unit Price";
            until SalesLine.Next = 0;
          end;
          AJWebOrderHeader."Merchandise Amount" := Round(AJWebOrderHeader."Merchandise Amount",Currency."Amount Rounding Precision"); // 4/12/2018
          AJWebOrderHeader."NAV Order Status" := AJWebOrderHeader."NAV Order Status"::Created; // 4/12/2018
          AJWebOrderHeader.Modify;
        end;

          ShipStation_CreateOrder(AJWebOrderHeader);
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

