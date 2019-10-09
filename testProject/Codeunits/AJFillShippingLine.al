codeunit 37072305 "AJ Fill Shipping Line"
{
    procedure CreateLineFromSalesOrder(var SalesHeader: Record "Sales Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
        Customer: Record Customer;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        AJWebService: Record "AJ Web Service";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := SalesHeader."No.";
        AJShippingLine."Source Table ID" := 36;
        AJShippingLine.Insert();


        AJShippingLine."Shipping Carrier Code" := AJShippingHeader."Shipping Carrier Code";
        AJShippingLine."Shipping Package Type" := AJShippingHeader."Shipping Package Type";
        AJShippingLine."Shipping Delivery Confirm" := AJShippingHeader."Shipping Delivery Confirm";
        AJShippingLine."Shipping Carrier Service" := AJShippingHeader."Shipping Carrier Service";
        AJShippingLine."Shp. Product Weight" := AJShippingHeader."Shp. Product Weight";
        AJShippingLine."Shp. Product Weight Unit" := AJShippingHeader."Shp. Product Weight Unit";
        AJShippingLine."Shp. Product Dimension Unit" := AJShippingHeader."Shp. Product Dimension Unit";
        AJShippingLine."Shp. Product Length" := AJShippingHeader."Shp. Product Length";
        AJShippingLine."Shp. Product Width" := AJShippingHeader."Shp. Product Width";
        AJShippingLine."Shp. Product Height" := AJShippingHeader."Shp. Product Height";


        if AJShippingLine."Customer Reference ID" = '' then
            AJShippingLine."Customer Reference ID" := SalesHeader."External Document No.";
        AJShippingLine."Custom Field 1" := 'ID: ' + SalesHeader."Sell-to Customer No." + ' DOC: ' + SalesHeader."No.";
        AJShippingLine."Custom Field 2" := SalesHeader."Your Reference";
        AJShippingLine."Custom Field 3" := SalesHeader."External Document No.";

        //AJShippingLine."Order DateTime" := CreateDateTime(SalesHeader."Order Date", 0T);

        AJShippingLine."Bill-To Customer Name" := SalesHeader."Bill-to Name";
        AJShippingLine."Bill-To Company" := CopyStr(SalesHeader."Bill-to Name", 1, MaxStrLen(AJShippingLine."Bill-To Company"));
        AJShippingLine."Bill-To Customer Address 1" := SalesHeader."Bill-to Address";
        AJShippingLine."Bill-To Customer Address 2" := SalesHeader."Bill-to Address 2";
        AJShippingLine."Bill-To Customer Address 3" := '';
        AJShippingLine."Bill-To Customer City" := SalesHeader."Bill-to City";
        AJShippingLine."Bill-To Customer State" := CopyStr(SalesHeader."Bill-to County", 1, MaxStrLen(AJShippingLine."Bill-To Customer State"));
        AJShippingLine."Bill-To Customer Zip" := CopyStr(SalesHeader."Bill-to Post Code", 1, MaxStrLen(AJShippingLine."Bill-To Customer Zip"));
        AJShippingLine."Bill-To Customer Country" := SalesHeader."Bill-to Country/Region Code";
        AJShippingLine."Bill-To Customer Phone" := '';
        if Customer.Get(SalesHeader."Bill-to Customer No.") then
            AJShippingLine."Bill-To Customer Phone" := Customer."Phone No.";
        AJShippingLine."Bill-To Residential" := false;

        AJShippingLine."Ship-To Customer Name" := SalesHeader."Ship-to Name";
        AJShippingLine."Ship-To Company" := SalesHeader."Ship-to Name";
        AJShippingLine."Ship-To Customer Address 1" := SalesHeader."Ship-to Address";
        if AJShippingLine."Ship-To Customer Address 1" = '' then
            AJShippingLine."Ship-To Customer Address 1" := SalesHeader."Ship-to Address 2"
        else
            AJShippingLine."Ship-To Customer Address 2" := SalesHeader."Ship-to Address 2";
        AJShippingLine."Ship-To Customer Address 3" := '';
        AJShippingLine."Ship-To Customer City" := SalesHeader."Ship-to City";
        AJShippingLine."Ship-To Customer State" := CopyStr(SalesHeader."Ship-to County", 1, MaxStrLen(AJShippingLine."Ship-To Customer State"));
        AJShippingLine."Ship-To Customer Zip" := CopyStr(SalesHeader."Ship-to Post Code", 1, MaxStrLen(AJShippingLine."Ship-To Customer Zip"));
        AJShippingLine."Ship-To Customer Country" := SalesHeader."Ship-to Country/Region Code";
        //AJShippingLine."Ship-To Customer Phone" := SalesHeader."Ship-to Phone No.";
        AJShippingLine."Ship-To Residential" := false;
        //AJShippingLine."Ship-To E-mail" := SalesHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesHeader."Salesperson Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJShippingLine."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJShippingLine."Ship-To E-mail") then
                if AJShippingLine."Ship-To E-mail" = '' then
                    AJShippingLine."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJShippingLine."Ship-To E-mail"))
                else
                    AJShippingLine."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";


        if not AJWebService.Get(AJShippingLine."Shipping Web Service Code") then
            AJWebService.Init();

        AJShippingLine.TestField("Ship-To Customer Address 1");
        AJShippingLine."NAV Order Status" := AJShippingLine."NAV Order Status"::Created;
        AJShippingLine.Modify();
    end;

    procedure CreateLineFromSalesInvHeader(var SalesInvHeader: Record "Sales Invoice Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
        Customer: Record Customer;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        AJWebService: Record "AJ Web Service";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := SalesInvHeader."No.";
        AJShippingLine."Source Table ID" := 112;
        AJShippingLine.Insert();


        AJShippingLine."Shipping Carrier Code" := AJShippingHeader."Shipping Carrier Code";
        AJShippingLine."Shipping Package Type" := AJShippingHeader."Shipping Package Type";
        AJShippingLine."Shipping Delivery Confirm" := AJShippingHeader."Shipping Delivery Confirm";
        AJShippingLine."Shipping Carrier Service" := AJShippingHeader."Shipping Carrier Service";
        AJShippingLine."Shp. Product Weight" := AJShippingHeader."Shp. Product Weight";
        AJShippingLine."Shp. Product Weight Unit" := AJShippingHeader."Shp. Product Weight Unit";
        AJShippingLine."Shp. Product Dimension Unit" := AJShippingHeader."Shp. Product Dimension Unit";
        AJShippingLine."Shp. Product Length" := AJShippingHeader."Shp. Product Length";
        AJShippingLine."Shp. Product Width" := AJShippingHeader."Shp. Product Width";
        AJShippingLine."Shp. Product Height" := AJShippingHeader."Shp. Product Height";


        if AJShippingLine."Customer Reference ID" = '' then
            AJShippingLine."Customer Reference ID" := SalesInvHeader."External Document No.";
        AJShippingLine."Custom Field 1" := 'ID: ' + SalesInvHeader."Sell-to Customer No." + ' DOC: ' + SalesInvHeader."No.";
        AJShippingLine."Custom Field 2" := SalesInvHeader."Your Reference";
        AJShippingLine."Custom Field 3" := SalesInvHeader."External Document No.";

        //AJShippingLine."Order DateTime" := CreateDateTime(SalesInvHeader."Order Date", 0T);

        AJShippingLine."Bill-To Customer Name" := SalesInvHeader."Bill-to Name";
        AJShippingLine."Bill-To Company" := CopyStr(SalesInvHeader."Bill-to Name", 1, MaxStrLen(AJShippingLine."Bill-To Company"));
        AJShippingLine."Bill-To Customer Address 1" := SalesInvHeader."Bill-to Address";
        AJShippingLine."Bill-To Customer Address 2" := SalesInvHeader."Bill-to Address 2";
        AJShippingLine."Bill-To Customer Address 3" := '';
        AJShippingLine."Bill-To Customer City" := SalesInvHeader."Bill-to City";
        AJShippingLine."Bill-To Customer State" := CopyStr(SalesInvHeader."Bill-to County", 1, MaxStrLen(AJShippingLine."Bill-To Customer State"));
        AJShippingLine."Bill-To Customer Zip" := CopyStr(SalesInvHeader."Bill-to Post Code", 1, MaxStrLen(AJShippingLine."Bill-To Customer Zip"));
        AJShippingLine."Bill-To Customer Country" := SalesInvHeader."Bill-to Country/Region Code";
        AJShippingLine."Bill-To Customer Phone" := '';
        if Customer.Get(SalesInvHeader."Bill-to Customer No.") then
            AJShippingLine."Bill-To Customer Phone" := Customer."Phone No.";
        AJShippingLine."Bill-To Residential" := false;

        AJShippingLine."Ship-To Customer Name" := SalesInvHeader."Ship-to Name";
        AJShippingLine."Ship-To Company" := SalesInvHeader."Ship-to Name";
        AJShippingLine."Ship-To Customer Address 1" := SalesInvHeader."Ship-to Address";
        if AJShippingLine."Ship-To Customer Address 1" = '' then
            AJShippingLine."Ship-To Customer Address 1" := SalesInvHeader."Ship-to Address 2"
        else
            AJShippingLine."Ship-To Customer Address 2" := SalesInvHeader."Ship-to Address 2";
        AJShippingLine."Ship-To Customer Address 3" := '';
        AJShippingLine."Ship-To Customer City" := SalesInvHeader."Ship-to City";
        AJShippingLine."Ship-To Customer State" := CopyStr(SalesInvHeader."Ship-to County", 1, MaxStrLen(AJShippingLine."Ship-To Customer State"));
        AJShippingLine."Ship-To Customer Zip" := CopyStr(SalesInvHeader."Ship-to Post Code", 1, MaxStrLen(AJShippingLine."Ship-To Customer Zip"));
        AJShippingLine."Ship-To Customer Country" := SalesInvHeader."Ship-to Country/Region Code";
        //AJShippingLine."Ship-To Customer Phone" := SalesInvHeader."Ship-to Phone No.";
        AJShippingLine."Ship-To Residential" := false;
        //AJShippingLine."Ship-To E-mail" := SalesInvHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesInvHeader."Salesperson Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJShippingLine."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJShippingLine."Ship-To E-mail") then
                if AJShippingLine."Ship-To E-mail" = '' then
                    AJShippingLine."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJShippingLine."Ship-To E-mail"))
                else
                    AJShippingLine."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";


        if not AJWebService.Get(AJShippingLine."Shipping Web Service Code") then
            AJWebService.Init();


        AJShippingLine.TestField("Ship-To Customer Address 1");
        AJShippingLine."NAV Order Status" := AJShippingLine."NAV Order Status"::Created;
        AJShippingLine.Modify();
    end;

    procedure CreateLineFromSalesInvHeader(var SalesShpHeader: Record "Sales Shipment Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
        Customer: Record Customer;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        AJWebService: Record "AJ Web Service";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := SalesShpHeader."No.";
        AJShippingLine."Source Table ID" := 110;
        AJShippingLine.Insert();


        AJShippingLine."Shipping Carrier Code" := AJShippingHeader."Shipping Carrier Code";
        AJShippingLine."Shipping Package Type" := AJShippingHeader."Shipping Package Type";
        AJShippingLine."Shipping Delivery Confirm" := AJShippingHeader."Shipping Delivery Confirm";
        AJShippingLine."Shipping Carrier Service" := AJShippingHeader."Shipping Carrier Service";
        AJShippingLine."Shp. Product Weight" := AJShippingHeader."Shp. Product Weight";
        AJShippingLine."Shp. Product Weight Unit" := AJShippingHeader."Shp. Product Weight Unit";
        AJShippingLine."Shp. Product Dimension Unit" := AJShippingHeader."Shp. Product Dimension Unit";
        AJShippingLine."Shp. Product Length" := AJShippingHeader."Shp. Product Length";
        AJShippingLine."Shp. Product Width" := AJShippingHeader."Shp. Product Width";
        AJShippingLine."Shp. Product Height" := AJShippingHeader."Shp. Product Height";


        if AJShippingLine."Customer Reference ID" = '' then
            AJShippingLine."Customer Reference ID" := SalesShpHeader."External Document No.";
        AJShippingLine."Custom Field 1" := 'ID: ' + SalesShpHeader."Sell-to Customer No." + ' DOC: ' + SalesShpHeader."No.";
        AJShippingLine."Custom Field 2" := SalesShpHeader."Your Reference";
        AJShippingLine."Custom Field 3" := SalesShpHeader."External Document No.";

        //AJShippingLine."Order DateTime" := CreateDateTime(SalesShpHeader."Order Date", 0T);

        AJShippingLine."Bill-To Customer Name" := SalesShpHeader."Bill-to Name";
        AJShippingLine."Bill-To Company" := CopyStr(SalesShpHeader."Bill-to Name", 1, MaxStrLen(AJShippingLine."Bill-To Company"));
        AJShippingLine."Bill-To Customer Address 1" := SalesShpHeader."Bill-to Address";
        AJShippingLine."Bill-To Customer Address 2" := SalesShpHeader."Bill-to Address 2";
        AJShippingLine."Bill-To Customer Address 3" := '';
        AJShippingLine."Bill-To Customer City" := SalesShpHeader."Bill-to City";
        AJShippingLine."Bill-To Customer State" := CopyStr(SalesShpHeader."Bill-to County", 1, MaxStrLen(AJShippingLine."Bill-To Customer State"));
        AJShippingLine."Bill-To Customer Zip" := CopyStr(SalesShpHeader."Bill-to Post Code", 1, MaxStrLen(AJShippingLine."Bill-To Customer Zip"));
        AJShippingLine."Bill-To Customer Country" := SalesShpHeader."Bill-to Country/Region Code";
        AJShippingLine."Bill-To Customer Phone" := '';
        if Customer.Get(SalesShpHeader."Bill-to Customer No.") then
            AJShippingLine."Bill-To Customer Phone" := Customer."Phone No.";
        AJShippingLine."Bill-To Residential" := false;

        AJShippingLine."Ship-To Customer Name" := SalesShpHeader."Ship-to Name";
        AJShippingLine."Ship-To Company" := SalesShpHeader."Ship-to Name";
        AJShippingLine."Ship-To Customer Address 1" := SalesShpHeader."Ship-to Address";
        if AJShippingLine."Ship-To Customer Address 1" = '' then
            AJShippingLine."Ship-To Customer Address 1" := SalesShpHeader."Ship-to Address 2"
        else
            AJShippingLine."Ship-To Customer Address 2" := SalesShpHeader."Ship-to Address 2";
        AJShippingLine."Ship-To Customer Address 3" := '';
        AJShippingLine."Ship-To Customer City" := SalesShpHeader."Ship-to City";
        AJShippingLine."Ship-To Customer State" := CopyStr(SalesShpHeader."Ship-to County", 1, MaxStrLen(AJShippingLine."Ship-To Customer State"));
        AJShippingLine."Ship-To Customer Zip" := CopyStr(SalesShpHeader."Ship-to Post Code", 1, MaxStrLen(AJShippingLine."Ship-To Customer Zip"));
        AJShippingLine."Ship-To Customer Country" := SalesShpHeader."Ship-to Country/Region Code";
        //AJShippingLine."Ship-To Customer Phone" := SalesShpHeader."Ship-to Phone No.";
        AJShippingLine."Ship-To Residential" := false;
        //AJShippingLine."Ship-To E-mail" := SalesShpHeader."Ship-to E-Mail";

        //>> add salesperson e-mail
        if not SalespersonPurchaser.Get(SalesShpHeader."Salesperson Code") then
            SalespersonPurchaser.Init();
        if SalespersonPurchaser."E-Mail" <> '' then
            if StrLen(AJShippingLine."Ship-To E-mail" + ';' + SalespersonPurchaser."E-Mail") <= MaxStrLen(AJShippingLine."Ship-To E-mail") then
                if AJShippingLine."Ship-To E-mail" = '' then
                    AJShippingLine."Ship-To E-mail" := CopyStr(SalespersonPurchaser."E-Mail", 1, MaxStrLen(AJShippingLine."Ship-To E-mail"))
                else
                    AJShippingLine."Ship-To E-mail" += ';' + SalespersonPurchaser."E-Mail";


        if not AJWebService.Get(AJShippingLine."Shipping Web Service Code") then
            AJWebService.Init();

        AJShippingLine.TestField("Ship-To Customer Address 1");
        AJShippingLine."NAV Order Status" := AJShippingLine."NAV Order Status"::Created;
        AJShippingLine.Modify();
    end;

    procedure CreateLineFromTransferHeader(var TransferHeader: Record "Transfer Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
        AJWebService: Record "AJ Web Service";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := TransferHeader."No.";
        AJShippingLine."Source Table ID" := 5740;
        AJShippingLine.Insert();


        AJShippingLine."Shipping Carrier Code" := AJShippingHeader."Shipping Carrier Code";
        AJShippingLine."Shipping Package Type" := AJShippingHeader."Shipping Package Type";
        AJShippingLine."Shipping Delivery Confirm" := AJShippingHeader."Shipping Delivery Confirm";
        AJShippingLine."Shipping Carrier Service" := AJShippingHeader."Shipping Carrier Service";
        AJShippingLine."Shp. Product Weight" := AJShippingHeader."Shp. Product Weight";
        AJShippingLine."Shp. Product Weight Unit" := AJShippingHeader."Shp. Product Weight Unit";
        AJShippingLine."Shp. Product Dimension Unit" := AJShippingHeader."Shp. Product Dimension Unit";
        AJShippingLine."Shp. Product Length" := AJShippingHeader."Shp. Product Length";
        AJShippingLine."Shp. Product Width" := AJShippingHeader."Shp. Product Width";
        AJShippingLine."Shp. Product Height" := AJShippingHeader."Shp. Product Height";


        if AJShippingLine."Customer Reference ID" = '' then
            AJShippingLine."Customer Reference ID" := TransferHeader."External Document No.";
        AJShippingLine."Custom Field 1" := 'ID: ' + TransferHeader."Transfer-to Code" + ' DOC: ' + TransferHeader."No.";
        //AJShippingLine."Custom Field 2" := TransferHeader."Your Reference";
        AJShippingLine."Custom Field 3" := TransferHeader."External Document No.";

        //AJShippingLine."Order DateTime" := CreateDateTime(TransferHeader."Order Date", 0T);

        AJShippingLine."Bill-To Customer Name" := TransferHeader."Transfer-to Name";
        AJShippingLine."Bill-To Company" := CopyStr(TransferHeader."Transfer-to Name", 1, MaxStrLen(AJShippingLine."Bill-To Company"));
        AJShippingLine."Bill-To Customer Address 1" := TransferHeader."Transfer-to Address";
        AJShippingLine."Bill-To Customer Address 2" := TransferHeader."Transfer-to Address 2";
        AJShippingLine."Bill-To Customer Address 3" := '';
        AJShippingLine."Bill-To Customer City" := TransferHeader."Transfer-to City";
        AJShippingLine."Bill-To Customer State" := CopyStr(TransferHeader."Transfer-to City", 1, MaxStrLen(AJShippingLine."Bill-To Customer State"));
        AJShippingLine."Bill-To Customer Zip" := CopyStr(TransferHeader."Transfer-to Post Code", 1, MaxStrLen(AJShippingLine."Bill-To Customer Zip"));
        AJShippingLine."Bill-To Customer Country" := TransferHeader."Trsf.-to Country/Region Code";
        AJShippingLine."Bill-To Customer Phone" := '';
        AJShippingLine."Bill-To Residential" := false;

        AJShippingLine."Ship-To Customer Name" := TransferHeader."Transfer-to Name";
        AJShippingLine."Ship-To Company" := TransferHeader."Transfer-to Name";
        AJShippingLine."Ship-To Customer Address 1" := TransferHeader."Transfer-to Address";
        if AJShippingLine."Ship-To Customer Address 1" = '' then
            AJShippingLine."Ship-To Customer Address 1" := TransferHeader."Transfer-to Address 2"
        else
            AJShippingLine."Ship-To Customer Address 2" := TransferHeader."Transfer-to Address 2";
        AJShippingLine."Ship-To Customer Address 3" := '';
        AJShippingLine."Ship-To Customer City" := TransferHeader."Transfer-to City";
        AJShippingLine."Ship-To Customer State" := CopyStr(TransferHeader."Transfer-to City", 1, MaxStrLen(AJShippingLine."Bill-To Customer State"));
        AJShippingLine."Ship-To Customer Zip" := CopyStr(TransferHeader."Transfer-to Post Code", 1, MaxStrLen(AJShippingLine."Bill-To Customer Zip"));
        AJShippingLine."Ship-To Customer Country" := TransferHeader."Trsf.-to Country/Region Code";
        //AJShippingLine."Ship-To Customer Phone" := TransferHeader."Ship-to Phone No.";
        AJShippingLine."Ship-To Residential" := false;
        //AJShippingLine."Ship-To E-mail" := TransferHeader."Ship-to E-Mail";      

        if not AJWebService.Get(AJShippingLine."Shipping Web Service Code") then
            AJWebService.Init();

        AJShippingLine.TestField("Ship-To Customer Address 1");
        AJShippingLine."NAV Order Status" := AJShippingLine."NAV Order Status"::Created;
        AJShippingLine.Modify();
    end;

    procedure CreateLineFromTransferShpHeader(var TransferShpHeader: Record "Transfer Shipment Header"; AJShippingHeader: Record "AJ Shipping Header"; var AJShippingLine: Record "AJ Shipping Line")
    var
        AJShippingLine2: Record "AJ Shipping Line";
        AJWebService: Record "AJ Web Service";
    begin
        AJShippingLine2.reset();
        AJShippingLine2.SetRange("Shipping No.", AJShippingHeader."Shipping No.");
        if AJShippingLine2.FindLast() then
            AJShippingLine."Line No." := AJShippingLine2."Line No." + 1000
        else
            AJShippingLine."Line No." := 1000;
        AJShippingLine."Shipping No." := AJShippingHeader."Shipping No.";
        AJShippingLine."Source ID" := TransferShpHeader."No.";
        AJShippingLine."Source Table ID" := 5740;
        AJShippingLine.Insert();


        AJShippingLine."Shipping Carrier Code" := AJShippingHeader."Shipping Carrier Code";
        AJShippingLine."Shipping Package Type" := AJShippingHeader."Shipping Package Type";
        AJShippingLine."Shipping Delivery Confirm" := AJShippingHeader."Shipping Delivery Confirm";
        AJShippingLine."Shipping Carrier Service" := AJShippingHeader."Shipping Carrier Service";
        AJShippingLine."Shp. Product Weight" := AJShippingHeader."Shp. Product Weight";
        AJShippingLine."Shp. Product Weight Unit" := AJShippingHeader."Shp. Product Weight Unit";
        AJShippingLine."Shp. Product Dimension Unit" := AJShippingHeader."Shp. Product Dimension Unit";
        AJShippingLine."Shp. Product Length" := AJShippingHeader."Shp. Product Length";
        AJShippingLine."Shp. Product Width" := AJShippingHeader."Shp. Product Width";
        AJShippingLine."Shp. Product Height" := AJShippingHeader."Shp. Product Height";


        if AJShippingLine."Customer Reference ID" = '' then
            AJShippingLine."Customer Reference ID" := TransferShpHeader."External Document No.";
        AJShippingLine."Custom Field 1" := 'ID: ' + TransferShpHeader."Transfer-to Code" + ' DOC: ' + TransferShpHeader."No.";
        //AJShippingLine."Custom Field 2" := TransferShpHeader."Your Reference";
        AJShippingLine."Custom Field 3" := TransferShpHeader."External Document No.";

        //AJShippingLine."Order DateTime" := CreateDateTime(TransferShpHeader."Order Date", 0T);

        AJShippingLine."Bill-To Customer Name" := TransferShpHeader."Transfer-to Name";
        AJShippingLine."Bill-To Company" := CopyStr(TransferShpHeader."Transfer-to Name", 1, MaxStrLen(AJShippingLine."Bill-To Company"));
        AJShippingLine."Bill-To Customer Address 1" := TransferShpHeader."Transfer-to Address";
        AJShippingLine."Bill-To Customer Address 2" := TransferShpHeader."Transfer-to Address 2";
        AJShippingLine."Bill-To Customer Address 3" := '';
        AJShippingLine."Bill-To Customer City" := TransferShpHeader."Transfer-to City";
        AJShippingLine."Bill-To Customer State" := CopyStr(TransferShpHeader."Transfer-to City", 1, MaxStrLen(AJShippingLine."Bill-To Customer State"));
        AJShippingLine."Bill-To Customer Zip" := CopyStr(TransferShpHeader."Transfer-to Post Code", 1, MaxStrLen(AJShippingLine."Bill-To Customer Zip"));
        AJShippingLine."Bill-To Customer Country" := TransferShpHeader."Trsf.-to Country/Region Code";
        AJShippingLine."Bill-To Customer Phone" := '';
        AJShippingLine."Bill-To Residential" := false;

        AJShippingLine."Ship-To Customer Name" := TransferShpHeader."Transfer-to Name";
        AJShippingLine."Ship-To Company" := TransferShpHeader."Transfer-to Name";
        AJShippingLine."Ship-To Customer Address 1" := TransferShpHeader."Transfer-to Address";
        if AJShippingLine."Ship-To Customer Address 1" = '' then
            AJShippingLine."Ship-To Customer Address 1" := TransferShpHeader."Transfer-to Address 2"
        else
            AJShippingLine."Ship-To Customer Address 2" := TransferShpHeader."Transfer-to Address 2";
        AJShippingLine."Ship-To Customer Address 3" := '';
        AJShippingLine."Ship-To Customer City" := TransferShpHeader."Transfer-to City";
        AJShippingLine."Ship-To Customer State" := CopyStr(TransferShpHeader."Transfer-to City", 1, MaxStrLen(AJShippingLine."Bill-To Customer State"));
        AJShippingLine."Ship-To Customer Zip" := CopyStr(TransferShpHeader."Transfer-to Post Code", 1, MaxStrLen(AJShippingLine."Bill-To Customer Zip"));
        AJShippingLine."Ship-To Customer Country" := TransferShpHeader."Trsf.-to Country/Region Code";
        //AJShippingLine."Ship-To Customer Phone" := TransferShpHeader."Ship-to Phone No.";
        AJShippingLine."Ship-To Residential" := false;
        //AJShippingLine."Ship-To E-mail" := TransferShpHeader."Ship-to E-Mail";      

        if not AJWebService.Get(AJShippingLine."Shipping Web Service Code") then
            AJWebService.Init();

        AJShippingLine.TestField("Ship-To Customer Address 1");
        AJShippingLine."NAV Order Status" := AJShippingLine."NAV Order Status"::Created;
        AJShippingLine.Modify();
    end;
}