table 37072309 "AJ Web Package"
{
    DrillDownPageID = "AJ Web Packages";
    LookupPageID = "AJ Web Packages";

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(5; "Source Type"; Integer)
        {
        }
        field(6; "Source No."; Code[20])
        {
        }
        field(7; "Source Subtype"; Integer)
        {
        }
        field(10; "Shipping Web Service Code"; Code[10])
        {
        }
        field(12; "Shipping Web Service Store ID"; Code[10])
        {
        }
        field(13; "Shipping Warehouse ID"; Code[40])
        {
            TableRelation = "AJ Web Service Warehouse"."Warehouse ID" WHERE ("Web Service Code" = FIELD ("Shipping Web Service Code"));

            trigger OnValidate()
            var
                AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
            begin
                TestField("Shipping Web Service Code");
                if AJWebServiceWarehouse.Get("Shipping Web Service Code", "Shipping Warehouse ID") then begin
                    Validate("Shipping Carrier Code", AJWebServiceWarehouse."Def. Shipping Carrier Code");
                    Validate("Shipping Carrier Service", AJWebServiceWarehouse."Def. Shipping Carrier Service");
                    Validate("Shipping Package Type", AJWebServiceWarehouse."Def. Shipping Package Type");

                    Validate("Shipping Delivery Confirm", AJWebServiceWarehouse."Def. Shipping Delivery Confirm");
                    Validate("Insure Shipment", AJWebServiceWarehouse."Def. Insure Shipment");
                    Validate("Insured Value", AJWebServiceWarehouse."Def. Insurance Value");
                    Validate("Shp. Product Weight Unit", AJWebServiceWarehouse."Def. Product Weight Unit");
                end;
            end;
        }
        field(15; "Shipping Web Service Order No."; Text[30])
        {
        }
        field(16; "Shipping Web Service Shipm. ID"; Text[30])
        {
        }
        field(21; "Shipping Carrier Code"; Text[50])
        {

            trigger OnValidate()
            var
                AJWebCarrier: Record "AJ Web Carrier";
            begin
            end;
        }
        field(22; "Shipping Carrier Service"; Text[50])
        {

            trigger OnValidate()
            var
                AJWebCarrierServices: Record "AJ Web Carrier Service";
            begin
            end;
        }
        field(23; "Shipping Package Type"; Text[30])
        {

            trigger OnValidate()
            var
                AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
            begin
            end;
        }
        field(24; "Shipping Delivery Confirm"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code" = FIELD ("Shipping Web Service Code"),
                                                                             Type = CONST (Confirmation),
                                                                             Blocked = CONST (false));
        }
        field(31; "Shp. Product Dimension Unit"; Text[30])
        {
        }
        field(32; "Shp. Product Weight Unit"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code" = FIELD ("Shipping Web Service Code"),
                                                                             Type = CONST (Weight));
        }
        field(33; "Shp. Product Weight"; Decimal)
        {
        }
        field(34; "Shp. Product Width"; Decimal)
        {
        }
        field(35; "Shp. Product Length"; Decimal)
        {
        }
        field(36; "Shp. Product Height"; Decimal)
        {
        }
        field(41; "Insure Shipment"; Boolean)
        {
        }
        field(42; "Insured Value"; Decimal)
        {
        }
        field(43; "Additional Insurance Value"; Decimal)
        {
        }
        field(50; "Bill-to Type"; Option)
        {
            OptionCaption = 'My Account,Recipient,Third Party,My Other Account';
            OptionMembers = my_account,recipient,third_party,my_other_account;
        }
        field(51; "Bill-To Account"; Text[30])
        {
        }
        field(52; "Bill-To Postal Code"; Text[10])
        {
        }
        field(53; "Bill-To Country Code"; Text[30])
        {
        }
        field(70; "Ship Date"; Date)
        {
        }
        field(71; "Shipment No."; Code[20])
        {
        }
        field(72; "Invoice No."; Code[20])
        {
        }
        field(73; "Shipping Advice"; Option)
        {
            OptionMembers = " ",Require,Sent;
        }
        field(74; "Invoice Advice"; Option)
        {
            OptionMembers = " ",Require,Sent;
        }
        field(75; "Invoice Send DateTime"; DateTime)
        {
        }
        field(76; "Shipment Send DateTime"; DateTime)
        {
        }
        field(80; "Non Machinable"; Boolean)
        {
        }
        field(81; "Saturday Delivery"; Boolean)
        {
        }
        field(82; "Contains Alcohol"; Boolean)
        {
        }
        field(90; "Container ID"; Text[30])
        {
        }
        field(101; "Carier Shipping Charge"; Decimal)
        {
        }
        field(102; "Carier Tracking Number"; Text[30])
        {
        }
        field(103; "Carier Insurance Cost"; Decimal)
        {
        }
        field(110; "Shipping & Handling Amount"; Decimal)
        {
        }
        field(120; Label; BLOB)
        {
        }
        field(121; "Label Created"; Boolean)
        {
        }
        field(122; "Label Printed"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Source Type", "Source No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ("Shipment No." <> '') or ("Invoice No." <> '') then
            Error('Package %1 has been shipped already!', "No.");

        TestField("Label Created", false);

        AJWebPackageLine.Reset;
        AJWebPackageLine.SetRange("Package No.", "No.");
        if not AJWebPackageLine.IsEmpty then
            AJWebPackageLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            AJWebSetup.Get;
            AJWebSetup.TestField("Web Package No. Series");
            "No." := NoSeriesManagement.GetNextNo(AJWebSetup."Web Package No. Series", WorkDate, true);
        end;
    end;

    var
        AJWebService: Record "AJ Web Service";
        AJWebSetup: Record "AJ Web Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        AJWebPackageLine: Record "AJ Web Package Line";

    [Scope('Internal')]
    procedure UpdateShippingParameters()
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebCarrier: Record "AJ Web Carrier";
    begin
        if "Source Type" = DATABASE::"AJ Web Order Header" then begin
            AJWebOrderHeader.Get("Source No.");
            "Shipping Web Service Code" := AJWebOrderHeader."Shipping Web Service Code";
            "Shipping Warehouse ID" := AJWebOrderHeader."Ship-From Warehouse ID";
            "Shipping Carrier Code" := AJWebOrderHeader."Shipping Carrier Code";
            "Shipping Carrier Service" := AJWebOrderHeader."Shipping Carrier Service";
            "Shipping Package Type" := AJWebOrderHeader."Shipping Package Type";
            "Shipping Delivery Confirm" := AJWebOrderHeader."Shipping Delivery Confirm";
            "Insure Shipment" := AJWebOrderHeader."Insure Shipment";
            "Insured Value" := AJWebOrderHeader."Insured Value";
            "Additional Insurance Value" := AJWebOrderHeader."Additional Insurance Value";
            "Bill-to Type" := AJWebOrderHeader."Bill-to Type";
            "Bill-To Account" := AJWebOrderHeader."Bill-To Account";
            "Bill-To Postal Code" := AJWebOrderHeader."Bill-To Postal Code";
            "Bill-To Country Code" := AJWebOrderHeader."Bill-To Country Code";
            if "Bill-to Type" = 0 then begin
                AJWebCarrier.Get("Shipping Web Service Code", "Shipping Carrier Code");
                if AJWebCarrier."Bill-to Type" = AJWebCarrier."Bill-to Type"::third_party then begin
                    "Bill-to Type" := AJWebCarrier."Bill-to Type";
                    "Bill-To Account" := AJWebCarrier."Bill-to Account No.";
                    "Bill-To Postal Code" := AJWebCarrier."Bill-to Account Post Code";
                    "Bill-To Country Code" := AJWebCarrier."Bill-to Account Country Code";
                end;
            end;

            "Non Machinable" := AJWebOrderHeader."Non Machinable";
            "Saturday Delivery" := AJWebOrderHeader."Saturday Delivery";
            "Contains Alcohol" := AJWebOrderHeader."Contains Alcohol";
        end;
    end;

    [Scope('Internal')]
    procedure UpdateBoxParameters()
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
    begin
        if "Source Type" = DATABASE::"AJ Web Order Header" then begin
            AJWebOrderHeader.Get("Source No.");
            "Shp. Product Dimension Unit" := AJWebOrderHeader."Shp. Product Dimension Unit";
            "Shp. Product Weight Unit" := AJWebOrderHeader."Shp. Product Weight Unit";
            "Shp. Product Weight" := AJWebOrderHeader."Shp. Product Weight";
            "Shp. Product Width" := AJWebOrderHeader."Shp. Product Width";
            "Shp. Product Length" := AJWebOrderHeader."Shp. Product Length";
            "Shp. Product Height" := AJWebOrderHeader."Shp. Product Height";
        end;
    end;

    [Scope('Internal')]
    procedure CalcBoxWeight()
    var
        AJWebPackageLine: Record "AJ Web Package Line";
        AJWebOrderLine: Record "AJ Web Order Line";
        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
    begin
        "Shp. Product Weight" := 0;
        "Shp. Product Weight Unit" := '';

        AJWebPackageLine.Reset;
        AJWebPackageLine.SetRange("Package No.", "No.");
        if AJWebPackageLine.FindFirst then
            repeat
                if AJWebPackageLine."Source Type" = DATABASE::"AJ Web Order Line" then begin
                    AJWebOrderLine.Get(AJWebPackageLine."Source No.", AJWebPackageLine."Source Line No.");
                    if AJWebOrderLine.Weight = 0 then begin
                        AJWebCarrierPackageType.Get("Shipping Web Service Code", "Shipping Carrier Code", "Shipping Package Type");
                        AJWebOrderLine.Weight := AJWebCarrierPackageType."Def. Weight";
                        AJWebOrderLine."Weigh Unit" := AJWebCarrierPackageType."Def. Weight Unit";
                    end;
                    AJWebOrderLine.TestField("Weigh Unit");
                    if "Shp. Product Weight Unit" = '' then
                        "Shp. Product Weight Unit" := AJWebOrderLine."Weigh Unit";
                    if "Shp. Product Weight Unit" = AJWebOrderLine."Weigh Unit" then
                        "Shp. Product Weight" += AJWebOrderLine.Weight
                    else
                        AJWebOrderLine.FieldError("Weigh Unit");
                end;
            until AJWebPackageLine.Next = 0;
    end;

    [Scope('Internal')]
    procedure FindPackageToShip(AJWebOrderLine: Record "AJ Web Order Line"): Boolean
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebPackageLine: Record "AJ Web Package Line";
        AJWebPackage: Record "AJ Web Package";
    begin

        AJWebOrderHeader.Get(AJWebOrderLine."Web Order No.");
        AJWebOrderHeader.CalcFields(Packages);
        if not AJWebOrderHeader.Packages then
            exit(false);

        AJWebPackageLine.SetRange("Source Type", DATABASE::"AJ Web Order Line");
        AJWebPackageLine.SetRange("Source No.", AJWebOrderLine."Web Order No."); // fixed 4/27/2017
        AJWebPackageLine.SetRange("Source Line No.", AJWebOrderLine."Line No."); // fixed 4/27/2017
        if AJWebPackageLine.FindFirst then begin
            repeat
                AJWebPackage.Get(AJWebPackageLine."Package No.");
                if AJWebPackage."Shipment No." <> '' then begin
                    AJWebPackageLine.SetFilter("Package No.", '>%1', AJWebPackage."No.");
                    if not AJWebPackageLine.FindFirst then
                        exit(false);
                end;
            until AJWebPackage."Shipment No." = '';
            Rec := AJWebPackage;
            exit(true);
        end else
            Clear(Rec);
        exit(false);
    end;

    [Scope('Internal')]
    procedure FindPackageForShipConf(AJWebOrderLine: Record "AJ Web Order Line"): Boolean
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebPackageLine: Record "AJ Web Package Line";
        AJWebPackage: Record "AJ Web Package";
    begin

        AJWebOrderHeader.Get(AJWebOrderLine."Web Order No.");
        AJWebOrderHeader.CalcFields(Packages);
        if not AJWebOrderHeader.Packages then
            exit(false);

        AJWebPackageLine.SetRange("Source Type", DATABASE::"AJ Web Order Line");
        AJWebPackageLine.SetRange("Source No.", AJWebOrderLine."Web Order No."); // fixed 4/27/2017
        AJWebPackageLine.SetRange("Source Line No.", AJWebOrderLine."Line No."); // fixed 4/27/2017
        if AJWebPackageLine.FindFirst then begin
            repeat
                AJWebPackage.Get(AJWebPackageLine."Package No.");
                if AJWebPackage."Shipping Advice" <> AJWebPackage."Shipping Advice"::" " then begin
                    AJWebPackageLine.SetFilter("Package No.", '>%1', AJWebPackage."No.");
                    if not AJWebPackageLine.FindFirst then
                        exit(false);
                end;
            until AJWebPackage."Shipping Advice" = AJWebPackage."Shipping Advice"::" ";
            Rec := AJWebPackage;
            exit(true);
        end else
            Clear(Rec);
        exit(false);
    end;

    [Scope('Internal')]
    procedure FindPackageToInvoice(AJWebOrderLine: Record "AJ Web Order Line"): Boolean
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebPackageLine: Record "AJ Web Package Line";
        AJWebPackage: Record "AJ Web Package";
    begin

        AJWebOrderHeader.Get(AJWebOrderLine."Web Order No.");
        AJWebOrderHeader.CalcFields(Packages);
        if not AJWebOrderHeader.Packages then
            exit(false);

        AJWebPackageLine.SetRange("Source Type", DATABASE::"AJ Web Order Line");
        AJWebPackageLine.SetRange("Source No.", AJWebOrderLine."Web Order No."); // fixed 4/27/2017
        AJWebPackageLine.SetRange("Source Line No.", AJWebOrderLine."Line No."); // fixed 4/27/2017
        if AJWebPackageLine.FindFirst then begin
            repeat
                AJWebPackage.Get(AJWebPackageLine."Package No.");
                if AJWebPackage."Invoice No." <> '' then begin
                    AJWebPackageLine.SetFilter("Package No.", '>%1', AJWebPackage."No.");
                    if not AJWebPackageLine.FindFirst then
                        exit(false);
                end;
            until AJWebPackage."Invoice No." = '';
            Rec := AJWebPackage;
            exit(true);
        end else
            Clear(Rec);
        exit(false);
    end;

    [Scope('Internal')]
    procedure FindPackage(AJWebOrderLine: Record "AJ Web Order Line"): Boolean
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        AJWebPackageLine: Record "AJ Web Package Line";
        AJWebPackage: Record "AJ Web Package";
    begin

        AJWebOrderHeader.Get(AJWebOrderLine."Web Order No.");
        AJWebOrderHeader.CalcFields(Packages);
        if not AJWebOrderHeader.Packages then
            exit(false);

        AJWebPackageLine.SetRange("Source Type", DATABASE::"AJ Web Order Line");
        AJWebPackageLine.SetRange("Source No.", AJWebOrderLine."Web Order No."); // fixed 4/27/2017
        AJWebPackageLine.SetRange("Source Line No.", AJWebOrderLine."Line No."); // fixed 4/27/2017
        if AJWebPackageLine.FindFirst then begin
            AJWebPackage.Get(AJWebPackageLine."Package No.");
            Rec := AJWebPackage;
            exit(true);
        end else
            Clear(Rec);
        exit(false);
    end;

    [Scope('Internal')]
    procedure FindPackageForSalesInvHeader(SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        AJWebPackage: Record "AJ Web Package";
    begin
        AJWebPackage.Reset;
        AJWebPackage.SetCurrentKey("Source Type", "Source No.");

        if SalesInvoiceHeader."Web Order No." <> '' then begin
            AJWebPackage.SetRange("Source Type", DATABASE::"AJ Web Order Header");
            AJWebPackage.SetRange("Source No.", SalesInvoiceHeader."Web Order No.");
        end else begin
            AJWebPackage.SetRange("Source Type", DATABASE::"Sales Invoice Header");
            AJWebPackage.SetRange("Source No.", SalesInvoiceHeader."No.");
        end;

        if AJWebPackage.FindFirst then begin
            Rec.Copy(AJWebPackage);
            exit(true);
        end;
    end;

    [Scope('Internal')]
    procedure FindPackageForSalesHeader(SalesHeader: Record "Sales Header"): Boolean
    var
        AJWebPackage: Record "AJ Web Package";
    begin
        AJWebPackage.Reset;
        AJWebPackage.SetCurrentKey("Source Type", "Source No.");

        if SalesHeader."Web Order No." <> '' then begin
            AJWebPackage.SetRange("Source Type", DATABASE::"AJ Web Order Header");
            AJWebPackage.SetRange("Source No.", SalesHeader."Web Order No.");
            AJWebPackage.SetRange("Source Subtype", SalesHeader."Document Type");
        end else begin
            AJWebPackage.SetRange("Source Type", DATABASE::"Sales Header");
            AJWebPackage.SetRange("Source No.", SalesHeader."No.");
            AJWebPackage.SetRange("Source Subtype", SalesHeader."Document Type");
        end;

        if AJWebPackage.FindFirst then begin
            Rec.Copy(AJWebPackage);
            exit(true);
        end;
    end;

    [Scope('Internal')]
    procedure FindPackageForSalesCrMemoHeader(SalesCrMemoHeader: Record "Sales Cr.Memo Header"): Boolean
    var
        AJWebPackage: Record "AJ Web Package";
    begin
        AJWebPackage.Reset;
        AJWebPackage.SetCurrentKey("Source Type", "Source No.");

        //if SalesCrMemoHeader."Web Order No." <> '' then begin
        //  AJWebPackage.SetRange("Source Type", DATABASE::"Sales Cr.Memo Header");
        //  AJWebPackage.SetRange("Source No.",SalesCrMemoHeader."Web Order No.");
        //end else begin
        //  AJWebPackage.SetRange("Source Type", DATABASE::"Sales Cr.Memo Header");
        //  AJWebPackage.SetRange("Source No.",SalesCrMemoHeader."No.");
        //end;

        if AJWebPackage.FindFirst then begin
            Rec.Copy(AJWebPackage);
            exit(true);
        end;
    end;

    [Scope('Internal')]
    procedure FindPackageForReturnReceiptHeader(ReturnReceiptHeader: Record "Return Receipt Header"): Boolean
    var
        AJWebPackage: Record "AJ Web Package";
    begin
        AJWebPackage.Reset;
        AJWebPackage.SetCurrentKey("Source Type", "Source No.");

        //if ReturnReceiptHeader."Web Order No." <> '' then begin
        // AJWebPackage.SetRange("Source Type", DATABASE::"Return Receipt Header");
        // AJWebPackage.SetRange("Source No.",ReturnReceiptHeader."Web Order No.");
        //end else begin
        //  AJWebPackage.SetRange("Source Type", DATABASE::"Return Receipt Header");
        // AJWebPackage.SetRange("Source No.",ReturnReceiptHeader."No.");
        // end;

        if AJWebPackage.FindFirst then begin
            Rec.Copy(AJWebPackage);
            exit(true);
        end;
    end;

    [Scope('Internal')]
    procedure FindPackageForPurchaseHeader(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        AJWebPackage: Record "AJ Web Package";
    begin
        AJWebPackage.Reset;
        AJWebPackage.SetCurrentKey("Source Type", "Source No.");


        //if PurchaseHeader."Web Order No." <> '' then begin
        //AJWebPackage.SetRange("Source Type", DATABASE::"AJ Web Order Header");
        //AJWebPackage.SetRange("Source No.",PurchaseHeader."Web Order No.");
        //AJWebPackage.SetRange("Source Subtype", PurchaseHeader."Document Type");
        //end else begin
        // AJWebPackage.SetRange("Source Type", DATABASE::"Purchase Header");
        //  AJWebPackage.SetRange("Source No.",PurchaseHeader."No.");
        // AJWebPackage.SetRange("Source Subtype", PurchaseHeader."Document Type");
        // end;

        if AJWebPackage.FindFirst then begin
            Rec.Copy(AJWebPackage);
            exit(true);
        end;
    end;

    [Scope('Internal')]
    procedure FindPackageForReturnShipmentHeader(ReturnShipmentHeader: Record "Return Shipment Header"): Boolean
    var
        AJWebPackage: Record "AJ Web Package";
    begin
        AJWebPackage.Reset;
        AJWebPackage.SetCurrentKey("Source Type", "Source No.");

        begin
            AJWebPackage.SetRange("Source Type", DATABASE::"Return Shipment Header");
            AJWebPackage.SetRange("Source No.", ReturnShipmentHeader."No.");
        end;

        if AJWebPackage.FindFirst then begin
            Rec.Copy(AJWebPackage);
            exit(true);
        end;
    end;
}

