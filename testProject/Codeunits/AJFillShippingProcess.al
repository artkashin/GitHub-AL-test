codeunit 37072305 "AJ Fill Shipping Process"
{
    procedure PopulateShippingHeaderFromLine(AJShippingLine: Record "AJ Shipping Line")
    begin
        case AJShippingLine."Source Table" of
            AJShippingLine."Source Table"::"36":
                PopulateFromSalesHeader(AJShippingLine);
            AJShippingLine."Source Table"::"110":
                PopulateFromSalesShipment(AJShippingLine);
            AJShippingLine."Source Table"::"112":
                PopulateFromSalesInvoice(AJShippingLine);
            AJShippingLine."Source Table"::"38":
                PopulateFromPurchaseHeader(AJShippingLine);
            AJShippingLine."Source Table"::"5740":
                PopulateFromTransferHeader(AJShippingLine);
            AJShippingLine."Source Table"::"5744":
                PopulateFromTransferShipment(AJShippingLine);
        end;
    end;

    procedure PopulateFromLocation(AJShippingHeader: Record "AJ Shipping Header")
    var
        Location: record Location;
    begin
        if Location.Get(AJShippingHeader."Ship-from Location Code") then begin
            AJShippingHeader."Ship-from Name" := Location.Name;
            AJShippingHeader."Ship-from Company" := CopyStr(Location.Name, 1, MaxStrLen(AJShippingHeader."Ship-from Company"));
            AJShippingHeader."Ship-from Address 1" := Location.Address;
            AJShippingHeader."Ship-from Address 2" := Location."Address 2";
            AJShippingHeader."Ship-from City" := Location.City;
            AJShippingHeader."Ship-from State" := CopyStr(Location.County, 1, MaxStrLen(AJShippingHeader."Ship-from State"));
            AJShippingHeader."Ship-from Zip" := CopyStr(Location."Post Code", 1, MaxStrLen(AJShippingHeader."Ship-from Zip"));
            AJShippingHeader."Ship-from Country Code" := Location."Country/Region Code";
            AJShippingHeader."Ship-from Phone" := Location."Phone No.";
            AJShippingHeader.Modify();
        end;
    end;

    local procedure PopulateFromSalesHeader(AJShippingLine: Record "AJ Shipping Line")
    var
        SalesHeader: Record "Sales Header";
        AJShippingHeader: Record "AJ Shipping Header";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Location: record Location;
    begin
        SalesHeader.Get(AJShippingLine."Source Document Type", AJShippingLine."Source ID");
        AJShippingHeader.get(AJShippingLine."Shipping No.");
        AJShippingHeader."Custom Field 1" := 'ID: ' + SalesHeader."Sell-to Customer No." + ' DOC: ' + SalesHeader."No.";
        AJShippingHeader."Custom Field 2" := SalesHeader."Your Reference";
        AJShippingHeader."Custom Field 3" := SalesHeader."External Document No.";
        AJShippingHeader."Ship Date" := SalesHeader."Order Date";

        if Location.Get(SalesHeader."Location Code") then begin
            AJShippingHeader."Ship-from Location Code" := Location.Code;
            AJShippingHeader."Ship-from Name" := Location.Name;
            AJShippingHeader."Ship-from Company" := CopyStr(Location.Name, 1, MaxStrLen(AJShippingHeader."Ship-from Company"));
            AJShippingHeader."Ship-from Address 1" := Location.Address;
            AJShippingHeader."Ship-from Address 2" := Location."Address 2";
            AJShippingHeader."Ship-from City" := Location.City;
            AJShippingHeader."Ship-from State" := CopyStr(Location.County, 1, MaxStrLen(AJShippingHeader."Ship-from State"));
            AJShippingHeader."Ship-from Zip" := CopyStr(Location."Post Code", 1, MaxStrLen(AJShippingHeader."Ship-from Zip"));
            AJShippingHeader."Ship-from Country Code" := Location."Country/Region Code";
            AJShippingHeader."Ship-from Phone" := Location."Phone No.";
        end;

        AJShippingHeader."Ship-from Residential" := false;

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
        //AJShippingHeader."Ship-To Phone" := SalesHeader."Ship-to Phone No.";
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

        AJShippingHeader.Modify();
    end;

    local procedure PopulateFromSalesInvoice(AJShippingLine: Record "AJ Shipping Line")
    var
        SalesInvHeader: Record "Sales Invoice Header";
        AJShippingHeader: Record "AJ Shipping Header";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Location: record Location;
    begin
        SalesInvHeader.Get(AJShippingLine."Source Document Type", AJShippingLine."Source ID");
        AJShippingHeader.get(AJShippingLine."Shipping No.");
        AJShippingHeader."Custom Field 1" := 'ID: ' + SalesInvHeader."Sell-to Customer No." + ' DOC: ' + SalesInvHeader."No.";
        AJShippingHeader."Custom Field 2" := SalesInvHeader."Your Reference";
        AJShippingHeader."Custom Field 3" := SalesInvHeader."External Document No.";
        AJShippingHeader."Ship Date" := SalesInvHeader."Order Date";

        if Location.Get(SalesInvHeader."Location Code") then begin
            AJShippingHeader."Ship-from Location Code" := Location.Code;
            AJShippingHeader."Ship-from Name" := Location.Name;
            AJShippingHeader."Ship-from Company" := CopyStr(Location.Name, 1, MaxStrLen(AJShippingHeader."Ship-from Company"));
            AJShippingHeader."Ship-from Address 1" := Location.Address;
            AJShippingHeader."Ship-from Address 2" := Location."Address 2";
            AJShippingHeader."Ship-from City" := Location.City;
            AJShippingHeader."Ship-from State" := CopyStr(Location.County, 1, MaxStrLen(AJShippingHeader."Ship-from State"));
            AJShippingHeader."Ship-from Zip" := CopyStr(Location."Post Code", 1, MaxStrLen(AJShippingHeader."Ship-from Zip"));
            AJShippingHeader."Ship-from Country Code" := Location."Country/Region Code";
            AJShippingHeader."Ship-from Phone" := Location."Phone No.";
        end;

        AJShippingHeader."Ship-from Residential" := false;

        AJShippingHeader."Ship-To Customer Name" := SalesInvHeader."Ship-to Name";
        AJShippingHeader."Ship-To Company" := SalesInvHeader."Ship-to Name";
        AJShippingHeader."Ship-To Customer Address 1" := SalesInvHeader."Ship-to Address";
        if AJShippingHeader."Ship-To Customer Address 1" = '' then
            AJShippingHeader."Ship-To Customer Address 1" := SalesInvHeader."Ship-to Address 2"
        else
            AJShippingHeader."Ship-To Customer Address 2" := SalesInvHeader."Ship-to Address 2";
        AJShippingHeader."Ship-To Customer Address 3" := '';
        AJShippingHeader."Ship-To Customer City" := SalesInvHeader."Ship-to City";
        AJShippingHeader."Ship-To Customer State" := CopyStr(SalesInvHeader."Ship-to County", 1, MaxStrLen(AJShippingHeader."Ship-To Customer State"));
        AJShippingHeader."Ship-To Customer Zip" := CopyStr(SalesInvHeader."Ship-to Post Code", 1, MaxStrLen(AJShippingHeader."Ship-To Customer Zip"));
        AJShippingHeader."Ship-To Customer Country" := SalesInvHeader."Ship-to Country/Region Code";
        //AJShippingHeader."Ship-To Phone" := SalesInvHeader."Ship-to Phone No.";
        AJShippingHeader."Ship-To Residential" := false;
        //AJShippingHeader."Ship-To E-mail" := SalesInvHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesInvHeader."Salesperson Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJShippingHeader."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJShippingHeader."Ship-To E-mail") then
                if AJShippingHeader."Ship-To E-mail" = '' then
                    AJShippingHeader."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJShippingHeader."Ship-To E-mail"))
                else
                    AJShippingHeader."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";

        AJShippingHeader.Modify();
    end;

    local procedure PopulateFromSalesShipment(AJShippingLine: Record "AJ Shipping Line")
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        AJShippingHeader: Record "AJ Shipping Header";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Location: record Location;
    begin
        SalesShipmentHeader.Get(AJShippingLine."Source Document Type", AJShippingLine."Source ID");
        AJShippingHeader.get(AJShippingLine."Shipping No.");
        AJShippingHeader."Custom Field 1" := 'ID: ' + SalesShipmentHeader."Sell-to Customer No." + ' DOC: ' + SalesShipmentHeader."No.";
        AJShippingHeader."Custom Field 2" := SalesShipmentHeader."Your Reference";

        AJShippingHeader."Custom Field 3" := SalesShipmentHeader."External Document No.";

        AJShippingHeader."Ship Date" := SalesShipmentHeader."Order Date";

        if Location.Get(SalesShipmentHeader."Location Code") then begin
            AJShippingHeader."Ship-from Location Code" := Location.Code;
            AJShippingHeader."Ship-from Name" := Location.Name;
            AJShippingHeader."Ship-from Company" := CopyStr(Location.Name, 1, MaxStrLen(AJShippingHeader."Ship-from Company"));
            AJShippingHeader."Ship-from Address 1" := Location.Address;
            AJShippingHeader."Ship-from Address 2" := Location."Address 2";
            AJShippingHeader."Ship-from City" := Location.City;
            AJShippingHeader."Ship-from State" := CopyStr(Location.County, 1, MaxStrLen(AJShippingHeader."Ship-from State"));
            AJShippingHeader."Ship-from Zip" := CopyStr(Location."Post Code", 1, MaxStrLen(AJShippingHeader."Ship-from Zip"));
            AJShippingHeader."Ship-from Country Code" := Location."Country/Region Code";
            AJShippingHeader."Ship-from Phone" := Location."Phone No.";
        end;

        AJShippingHeader."Ship-from Residential" := false;

        AJShippingHeader."Ship-To Customer Name" := SalesShipmentHeader."Ship-to Name";
        AJShippingHeader."Ship-To Company" := SalesShipmentHeader."Ship-to Name";
        AJShippingHeader."Ship-To Customer Address 1" := SalesShipmentHeader."Ship-to Address";
        if AJShippingHeader."Ship-To Customer Address 1" = '' then
            AJShippingHeader."Ship-To Customer Address 1" := SalesShipmentHeader."Ship-to Address 2"
        else
            AJShippingHeader."Ship-To Customer Address 2" := SalesShipmentHeader."Ship-to Address 2";
        AJShippingHeader."Ship-To Customer Address 3" := '';
        AJShippingHeader."Ship-To Customer City" := SalesShipmentHeader."Ship-to City";
        AJShippingHeader."Ship-To Customer State" := CopyStr(SalesShipmentHeader."Ship-to County", 1, MaxStrLen(AJShippingHeader."Ship-To Customer State"));
        AJShippingHeader."Ship-To Customer Zip" := CopyStr(SalesShipmentHeader."Ship-to Post Code", 1, MaxStrLen(AJShippingHeader."Ship-To Customer Zip"));
        AJShippingHeader."Ship-To Customer Country" := SalesShipmentHeader."Ship-to Country/Region Code";
        //AJShippingHeader."Ship-To Phone" := SalesShipmentHeader."Ship-to Phone No.";
        AJShippingHeader."Ship-To Residential" := false;
        //AJShippingHeader."Ship-To E-mail" := SalesShipmentHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesShipmentHeader."Salesperson Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJShippingHeader."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJShippingHeader."Ship-To E-mail") then
                if AJShippingHeader."Ship-To E-mail" = '' then
                    AJShippingHeader."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJShippingHeader."Ship-To E-mail"))
                else
                    AJShippingHeader."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";

        AJShippingHeader.Modify();
    end;

    local procedure PopulateFromPurchaseHeader(AJShippingLine: Record "AJ Shipping Line")
    var
        PurchaseHeader: Record "Purchase Header";
        AJShippingHeader: Record "AJ Shipping Header";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Location: record Location;
    begin
        PurchaseHeader.Get(AJShippingLine."Source Document Type", AJShippingLine."Source ID");
        AJShippingHeader.get(AJShippingLine."Shipping No.");
        AJShippingHeader."Custom Field 1" := 'ID: ' + PurchaseHeader."Sell-to Customer No." + ' DOC: ' + PurchaseHeader."No.";
        AJShippingHeader."Custom Field 2" := PurchaseHeader."Your Reference";
        AJShippingHeader."Custom Field 3" := PurchaseHeader."No.";
        AJShippingHeader."Ship Date" := PurchaseHeader."Order Date";

        if Location.Get(PurchaseHeader."Location Code") then begin
            AJShippingHeader."Ship-from Location Code" := Location.Code;
            AJShippingHeader."Ship-from Name" := Location.Name;
            AJShippingHeader."Ship-from Company" := CopyStr(Location.Name, 1, MaxStrLen(AJShippingHeader."Ship-from Company"));
            AJShippingHeader."Ship-from Address 1" := Location.Address;
            AJShippingHeader."Ship-from Address 2" := Location."Address 2";
            AJShippingHeader."Ship-from City" := Location.City;
            AJShippingHeader."Ship-from State" := CopyStr(Location.County, 1, MaxStrLen(AJShippingHeader."Ship-from State"));
            AJShippingHeader."Ship-from Zip" := CopyStr(Location."Post Code", 1, MaxStrLen(AJShippingHeader."Ship-from Zip"));
            AJShippingHeader."Ship-from Country Code" := Location."Country/Region Code";
            AJShippingHeader."Ship-from Phone" := Location."Phone No.";
        end;

        AJShippingHeader."Ship-from Residential" := false;

        AJShippingHeader."Ship-To Customer Name" := PurchaseHeader."Ship-to Name";
        AJShippingHeader."Ship-To Company" := PurchaseHeader."Ship-to Name";
        AJShippingHeader."Ship-To Customer Address 1" := PurchaseHeader."Ship-to Address";
        if AJShippingHeader."Ship-To Customer Address 1" = '' then
            AJShippingHeader."Ship-To Customer Address 1" := PurchaseHeader."Ship-to Address 2"
        else
            AJShippingHeader."Ship-To Customer Address 2" := PurchaseHeader."Ship-to Address 2";
        AJShippingHeader."Ship-To Customer Address 3" := '';
        AJShippingHeader."Ship-To Customer City" := PurchaseHeader."Ship-to City";
        AJShippingHeader."Ship-To Customer State" := CopyStr(PurchaseHeader."Ship-to County", 1, MaxStrLen(AJShippingHeader."Ship-To Customer State"));
        AJShippingHeader."Ship-To Customer Zip" := CopyStr(PurchaseHeader."Ship-to Post Code", 1, MaxStrLen(AJShippingHeader."Ship-To Customer Zip"));
        AJShippingHeader."Ship-To Customer Country" := PurchaseHeader."Ship-to Country/Region Code";
        //AJShippingHeader."Ship-To Phone" := PurchaseHeader."Ship-to Phone No.";
        AJShippingHeader."Ship-To Residential" := false;
        //AJShippingHeader."Ship-To E-mail" := PurchaseHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(PurchaseHeader."Purchaser Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJShippingHeader."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJShippingHeader."Ship-To E-mail") then
                if AJShippingHeader."Ship-To E-mail" = '' then
                    AJShippingHeader."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJShippingHeader."Ship-To E-mail"))
                else
                    AJShippingHeader."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";

        AJShippingHeader.Modify();
    end;

    local procedure PopulateFromTransferHeader(AJShippingLine: Record "AJ Shipping Line")
    var
        TransferHeader: Record "Transfer Header";
        AJShippingHeader: Record "AJ Shipping Header";
        Location: record Location;
    begin
        TransferHeader.Get(AJShippingLine."Source Document Type", AJShippingLine."Source ID");
        AJShippingHeader.get(AJShippingLine."Shipping No.");
        AJShippingHeader."Custom Field 1" := CopyStr('ID: ' + TransferHeader."Transfer-to Name" + ' DOC: ' + TransferHeader."No.", 1, StrLen(AJShippingHeader."Custom Field 1"));
        //AJShippingHeader."Custom Field 2" := TransferHeader."Your Reference";
        AJShippingHeader."Custom Field 3" := TransferHeader."External Document No.";
        AJShippingHeader."Ship Date" := TransferHeader."Posting Date";

        AJShippingHeader."Ship-from Name" := TransferHeader."Transfer-from Name";
        AJShippingHeader."Ship-from Company" := CopyStr(TransferHeader."Transfer-from Name", 1, MaxStrLen(AJShippingHeader."Ship-from Company"));
        AJShippingHeader."Ship-from Address 1" := TransferHeader."Transfer-from Address";
        AJShippingHeader."Ship-from Address 2" := TransferHeader."Transfer-from Address 2";
        AJShippingHeader."Ship-from City" := TransferHeader."Transfer-from City";
        AJShippingHeader."Ship-from State" := CopyStr(TransferHeader."Transfer-from County", 1, MaxStrLen(AJShippingHeader."Ship-from State"));
        AJShippingHeader."Ship-from Zip" := CopyStr(TransferHeader."Transfer-from Post Code", 1, MaxStrLen(AJShippingHeader."Ship-from Zip"));
        //AJShippingHeader."Ship-from Country Code" := Location."Country/Region Code";
        AJShippingHeader."Ship-from Phone" := Location."Phone No.";

        AJShippingHeader."Ship-from Residential" := false;

        AJShippingHeader."Ship-To Customer Name" := TransferHeader."Transfer-to Name";
        AJShippingHeader."Ship-To Company" := TransferHeader."Transfer-to Name";
        AJShippingHeader."Ship-To Customer Address 1" := TransferHeader."Transfer-to Address";
        if AJShippingHeader."Ship-To Customer Address 1" = '' then
            AJShippingHeader."Ship-To Customer Address 1" := TransferHeader."Transfer-to Address 2"
        else
            AJShippingHeader."Ship-To Customer Address 2" := TransferHeader."Transfer-to Address 2";
        AJShippingHeader."Ship-To Customer Address 3" := '';
        AJShippingHeader."Ship-To Customer City" := TransferHeader."Transfer-to City";
        AJShippingHeader."Ship-To Customer State" := CopyStr(TransferHeader."Transfer-to County", 1, MaxStrLen(AJShippingHeader."Ship-To Customer State"));
        AJShippingHeader."Ship-To Customer Zip" := CopyStr(TransferHeader."Transfer-to Post Code", 1, MaxStrLen(AJShippingHeader."Ship-To Customer Zip"));
        //AJShippingHeader."Ship-To Customer Country" := TransferHeader.transf "Transfer-to Country/Region Code";
        //AJShippingHeader."Ship-To Phone" := TransferHeader."Transfer-to Phone No.";
        AJShippingHeader."Ship-To Residential" := false;
        //AJShippingHeader."Ship-To E-mail" 

        AJShippingHeader.Modify();
    end;

    local procedure PopulateFromTransferShipment(AJShippingLine: Record "AJ Shipping Line")
    var
        TransferShipHeader: Record "Transfer Shipment Header";
        AJShippingHeader: Record "AJ Shipping Header";
        Location: record Location;
    begin
        TransferShipHeader.Get(AJShippingLine."Source Document Type", AJShippingLine."Source ID");
        AJShippingHeader.get(AJShippingLine."Shipping No.");
        AJShippingHeader."Custom Field 1" := CopyStr('ID: ' + TransferShipHeader."Transfer-to Name" + ' DOC: ' + TransferShipHeader."No.", 1, StrLen(AJShippingHeader."Custom Field 1"));
        //AJShippingHeader."Custom Field 2" := TransferShipHeader."Your Reference";
        AJShippingHeader."Custom Field 3" := TransferShipHeader."External Document No.";
        AJShippingHeader."Ship Date" := TransferShipHeader."Posting Date";

        AJShippingHeader."Ship-from Name" := TransferShipHeader."Transfer-from Name";
        AJShippingHeader."Ship-from Company" := CopyStr(TransferShipHeader."Transfer-from Name", 1, MaxStrLen(AJShippingHeader."Ship-from Company"));
        AJShippingHeader."Ship-from Address 1" := TransferShipHeader."Transfer-from Address";
        AJShippingHeader."Ship-from Address 2" := TransferShipHeader."Transfer-from Address 2";
        AJShippingHeader."Ship-from City" := TransferShipHeader."Transfer-from City";
        AJShippingHeader."Ship-from State" := CopyStr(TransferShipHeader."Transfer-from County", 1, MaxStrLen(AJShippingHeader."Ship-from State"));
        AJShippingHeader."Ship-from Zip" := CopyStr(TransferShipHeader."Transfer-from Post Code", 1, MaxStrLen(AJShippingHeader."Ship-from Zip"));
        //AJShippingHeader."Ship-from Country Code" := Location."Country/Region Code";
        AJShippingHeader."Ship-from Phone" := Location."Phone No.";

        AJShippingHeader."Ship-from Residential" := false;

        AJShippingHeader."Ship-To Customer Name" := TransferShipHeader."Transfer-to Name";
        AJShippingHeader."Ship-To Company" := TransferShipHeader."Transfer-to Name";
        AJShippingHeader."Ship-To Customer Address 1" := TransferShipHeader."Transfer-to Address";
        if AJShippingHeader."Ship-To Customer Address 1" = '' then
            AJShippingHeader."Ship-To Customer Address 1" := TransferShipHeader."Transfer-to Address 2"
        else
            AJShippingHeader."Ship-To Customer Address 2" := TransferShipHeader."Transfer-to Address 2";
        AJShippingHeader."Ship-To Customer Address 3" := '';
        AJShippingHeader."Ship-To Customer City" := TransferShipHeader."Transfer-to City";
        AJShippingHeader."Ship-To Customer State" := CopyStr(TransferShipHeader."Transfer-to County", 1, MaxStrLen(AJShippingHeader."Ship-To Customer State"));
        AJShippingHeader."Ship-To Customer Zip" := CopyStr(TransferShipHeader."Transfer-to Post Code", 1, MaxStrLen(AJShippingHeader."Ship-To Customer Zip"));
        //AJShippingHeader."Ship-To Customer Country" := TransferShipHeader.transf "Transfer-to Country/Region Code";
        //AJShippingHeader."Ship-To Phone" := TransferShipHeader."Transfer-to Phone No.";
        AJShippingHeader."Ship-To Residential" := false;
        //AJShippingHeader."Ship-To E-mail" 

        AJShippingHeader.Modify();
    end;

    procedure CreateLineFromSalesHeader(var SalesHeader: Record "Sales Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source Type" := AJShippingLine."Source Type"::Document;
        AJShippingLine."Source ID" := SalesHeader."No.";
        AJShippingLine."Source Document Type" := SalesHeader."Document Type";
        AJShippingLine."Source Table" := AJShippingLine."Source Table"::"36";
        AJShippingLine.Quantity := 1;
        AJShippingLine.Description := SalesHeader."Posting Description";
        AJShippingLine.Insert();
    end;

    procedure CreateLineFromPurchaseHeader(var PurchaseHeader: Record "Purchase Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source Type" := AJShippingLine."Source Type"::Document;
        AJShippingLine."Source ID" := PurchaseHeader."No.";
        AJShippingLine."Source Document Type" := PurchaseHeader."Document Type";
        AJShippingLine."Source Table" := AJShippingLine."Source Table"::"38";
        AJShippingLine.Quantity := 1;
        AJShippingLine.Description := PurchaseHeader."Posting Description";
        AJShippingLine.Insert();
    end;

    procedure CreateLineFromSalesInvHeader(var SalesInvHeader: Record "Sales Invoice Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := SalesInvHeader."No.";
        AJShippingLine."Source Type" := AJShippingLine."Source Type"::Document;
        AJShippingLine."Source Document Type" := AJShippingLine."Source Document Type"::Invoice;
        AJShippingLine."Source Table" := AJShippingLine."Source Table"::"112";
        AJShippingLine.Quantity := 1;
        AJShippingLine.Description := SalesInvHeader."Posting Description";
        AJShippingLine.Insert();

    end;

    procedure CreateLineFromSalesShipHeader(var SalesShpHeader: Record "Sales Shipment Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := SalesShpHeader."No.";
        AJShippingLine."Source Type" := AJShippingLine."Source Type"::Document;
        AJShippingLine."Source Document Type" := AJShippingLine."Source Document Type"::Invoice;
        AJShippingLine."Source Table" := AJShippingLine."Source Table"::"110";
        AJShippingLine.Quantity := 1;
        AJShippingLine.Description := SalesShpHeader."Posting Description";
        AJShippingLine.Insert();
    end;

    procedure CreateLineFromTransferHeader(var TransferHeader: Record "Transfer Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := TransferHeader."No.";
        AJShippingLine."Source Type" := AJShippingLine."Source Type"::Document;
        AJShippingLine."Source Document Type" := AJShippingLine."Source Document Type"::Invoice;
        AJShippingLine."Source Table" := AJShippingLine."Source Table"::"5740";
        AJShippingLine.Quantity := 1;
        AJShippingLine.Description := TransferHeader."Transaction Specification";
        AJShippingLine.Insert();
    end;

    procedure CreateLineFromTransferShpHeader(var TransferShpHeader: Record "Transfer Shipment Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := TransferShpHeader."No.";
        AJShippingLine."Source Type" := AJShippingLine."Source Type"::Document;
        AJShippingLine."Source Document Type" := AJShippingLine."Source Document Type"::Invoice;
        AJShippingLine."Source Table" := AJShippingLine."Source Table"::"5744";
        AJShippingLine.Quantity := 1;
        AJShippingLine.Description := TransferShpHeader."Transaction Specification";
        AJShippingLine.Insert();
    end;
}