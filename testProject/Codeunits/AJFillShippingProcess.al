codeunit 37072305 "AJ Fill Shipping Process"
{
    procedure PopulateShippingHeaderFromLine(AJShippingLine: Record "AJ Shipping Line")
    begin
        case AJShippingLine."Source Table" of
            AJShippingLine."Source Table"::"36":
                PopulateFromSalesHeader(AJShippingLine);
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

        AJShippingHeader."Order DateTime" := CreateDateTime(SalesHeader."Order Date", 0T);

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

    procedure CreateLineFromSalesOrder(var SalesHeader: Record "Sales Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
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
        AJShippingLine."Source Table" := 112;
        AJShippingLine.Insert();

    end;

    procedure CreateLineFromSalesInvHeader(var SalesShpHeader: Record "Sales Shipment Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
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
        AJShippingLine."Source Table" := 110;
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
        AJShippingLine."Source Table" := 5740;
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
        AJShippingLine."Source Table" := 5740;
        AJShippingLine.Insert();
    end;
}