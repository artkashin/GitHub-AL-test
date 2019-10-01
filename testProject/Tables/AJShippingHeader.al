table 37072307 "AJ Shipping Header"
{
    fields
    {
        field(1; "Log No."; Code[20])
        {
        }
        field(2; "Web Service Order ID"; Code[50])
        {
        }
        field(3; "Web Service Code"; Code[10])
        {
            TableRelation = "AJ Web Service";

            trigger OnValidate()
            var
                AJWebService: Record "AJ Web Service";
            begin
                if AJWebService.Get("Web Service Code") then begin
                    if AJWebService."Shipping Service Code" <> '' then
                        Validate("Shipping Web Service Code", AJWebService."Shipping Service Code");
                end;
            end;
        }
        field(5; "Shipping Web Service Order No."; Text[30])
        {
        }
        field(6; "Order DateTime"; DateTime)
        {
        }
        field(7; "Created DateTime"; DateTime)
        {
            Caption = 'Nav Created DateTime';
        }
        field(8; "Modify DateTime"; DateTime)
        {
        }
        field(9; "Payment DateTime"; DateTime)
        {
        }
        field(10; "Web Service Shipment ID"; Text[30])
        {
        }
        field(11; "Web Service Marketplace ID"; Code[10])
        {
        }
        field(12; "Web Service PO Number"; Text[30])
        {
        }
        field(14; "Shipped DateTime"; DateTime)
        {
        }
        field(20; "Shipping Web Service Code"; Code[10])
        {
            TableRelation = "AJ Web Service";

            trigger OnValidate()
            var
                AJWebService: Record "AJ Web Service";
            begin

                if "Shipping Web Service Code" <> xRec."Shipping Web Service Code" then
                    TestLabelCreated;
            end;
        }
        field(21; "Shp. Product Dimension Unit"; Text[30])
        {
        }
        field(22; "Shp. Product Weight Unit"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code" = FIELD ("Shipping Web Service Code"),
                                                                             Type = CONST (Weight));
        }
        field(23; "Shp. Product Weight"; Decimal)
        {
        }
        field(24; "Shp. Product Width"; Decimal)
        {
        }
        field(25; "Shp. Product Length"; Decimal)
        {
        }
        field(26; "Shp. Product Height"; Decimal)
        {
        }
        field(27; "Shp. Incoterms"; Text[30])
        {
        }
        field(28; "Shp. 3PL Warehouse"; Text[20])
        {
        }
        field(29; "Shp. 3PL Name"; Text[20])
        {
        }
        field(30; "Shipping Carrier Code"; Text[50])
        {

            trigger OnValidate()
            var
                AJWebCarrier: Record "AJ Web Carrier";
            begin
                TestField("Shipping Web Service Code");

                if "Shipping Carrier Code" <> xRec."Shipping Carrier Code" then
                    TestLabelCreated;

                TestMerchant;

                if AJWebCarrier.Get("Shipping Web Service Code", "Shipping Carrier Code") then begin
                    if AJWebCarrier."Def. Shipping Carrier Service" <> '' then
                        Validate("Shipping Carrier Service", AJWebCarrier."Def. Shipping Carrier Service");
                    if AJWebCarrier."Def. Shipping Package Type" <> '' then
                        Validate("Shipping Package Type", AJWebCarrier."Def. Shipping Package Type");
                    if AJWebCarrier."Def. Shipping Delivery Confirm" <> '' then
                        Validate("Shipping Delivery Confirm", AJWebCarrier."Def. Shipping Delivery Confirm");
                    if AJWebCarrier."Def. Shipping Option" <> '' then
                        Validate("Shipping Options", AJWebCarrier."Def. Shipping Option");
                end;
            end;
        }
        field(31; "Shp. Hts Code"; Text[30])
        {
        }
        field(32; "Shp. Method"; Text[30])
        {
        }
        field(33; "Shipping Package Type"; Text[30])
        {

            trigger OnValidate()
            var
                AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
            begin
                if "Shipping Package Type" <> xRec."Shipping Package Type" then
                    TestLabelCreated;

                TestField("Shipping Web Service Code");

                if AJWebCarrierPackageType.Get("Shipping Web Service Code", "Shipping Carrier Code", "Shipping Package Type") then begin
                    if "Shipping Delivery Confirm" = '' then
                        Validate("Shipping Delivery Confirm", AJWebCarrierPackageType."Shipping Delivery Confirm");
                    Validate("Shp. Product Weight Unit", AJWebCarrierPackageType."Def. Weight Unit");
                    Validate("Shp. Product Weight", AJWebCarrierPackageType."Def. Weight");
                    Validate("Shp. Product Dimension Unit", AJWebCarrierPackageType."Def. Dimension Unit");
                    Validate("Shp. Product Width", AJWebCarrierPackageType."Def. Width");
                    Validate("Shp. Product Length", AJWebCarrierPackageType."Def. Length");
                    Validate("Shp. Product Height", AJWebCarrierPackageType."Def. Height");
                    Validate("Insure Shipment", AJWebCarrierPackageType."Def. Insure Shipment");
                    Validate("Insured Value", AJWebCarrierPackageType."Def. Insured Value");
                    Validate("Additional Insurance Value", AJWebCarrierPackageType."Def.Additional Insurance Value");
                end;
            end;
        }
        field(34; "Shipping Carrier Service"; Text[50])
        {

            trigger OnValidate()
            var
                AJWebCarrierServices: Record "AJ Web Carrier Service";
                AJWebService: Record "AJ Web Service";
            begin
                if "Shipping Carrier Service" <> xRec."Shipping Carrier Service" then
                    TestLabelCreated;

                TestMerchant;

                TestField("Shipping Web Service Code");

                if AJWebCarrierServices.Get("Shipping Web Service Code", "Shipping Carrier Code", "Shipping Carrier Service") then begin
                    Validate("Shipping Package Type", AJWebCarrierServices."Default Package Code");
                    if AJWebCarrierServices.International then
                        "International Shipment" := true;
                end;
            end;
        }
        field(40; "Bill-To Customer Name"; Text[100])
        {
        }
        field(41; "Bill-To Customer Zip"; Text[10])
        {
        }
        field(42; "Bill-To Customer Country"; Text[10])
        {
        }
        field(43; "Bill-To Customer State"; Text[20])
        {
        }
        field(44; "Bill-To Customer City"; Text[50])
        {
        }
        field(45; "Bill-To Customer Address 1"; Text[100])
        {
        }
        field(46; "Bill-To Customer Address 2"; Text[80])
        {
        }
        field(47; "Bill-To Customer Phone"; Text[30])
        {
        }
        field(48; "Bill-To Company"; Text[80])
        {
        }
        field(49; "Bill-To Residential"; Boolean)
        {
        }
        field(50; "Bill-To Verified"; Text[30])
        {
        }
        field(51; "Bill-To Customer Address 3"; Text[100])
        {
        }
        field(52; "Bill-To E-mail"; Text[35])
        {
        }
        field(60; "Ship-To Customer Name"; Text[100])
        {
        }
        field(61; "Ship-To Customer Zip"; Text[10])
        {
        }
        field(62; "Ship-To Customer Country"; Text[10])
        {
        }
        field(63; "Ship-To Customer State"; Text[20])
        {
        }
        field(64; "Ship-To Customer City"; Text[50])
        {
        }
        field(65; "Ship-To Customer Address 1"; Text[100])
        {
        }
        field(66; "Ship-To Customer Address 2"; Text[100])
        {
        }
        field(67; "Ship-To Customer Phone"; Text[30])
        {
        }
        field(68; "Ship-To Company"; Text[100])
        {
        }
        field(69; "Ship-To Residential"; Boolean)
        {
        }
        field(70; "Ship-To Address Verified"; Text[30])
        {
        }
        field(71; "Ship-To Customer Address 3"; Text[50])
        {
        }
        field(72; "Ship-To E-mail"; Text[35])
        {
        }
        field(73; "Ship-To First Name"; Text[20])
        {
        }
        field(74; "Ship-To Last Name"; Text[20])
        {
        }
        field(80; "Ship-From Warehouse ID"; Code[40])
        {
            TableRelation = IF ("Shipping Web Service Code" = CONST ('')) "AJ Web Service Warehouse"."Warehouse ID" WHERE ("Web Service Code" = FIELD ("Web Service Code"))
            ELSE
            IF ("Shipping Web Service Code" = FILTER (<> '')) "AJ Web Service Warehouse"."Warehouse ID" WHERE ("Web Service Code" = FIELD ("Shipping Web Service Code"));

            trigger OnValidate()
            var
                AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                AJWebService: Record "AJ Web Service";
            begin
                TestField("Shipping Web Service Code");

                if "Ship-From Warehouse ID" <> xRec."Ship-From Warehouse ID" then
                    TestLabelCreated;

                if AJWebServiceWarehouse.Get("Shipping Web Service Code", "Ship-From Warehouse ID") then begin
                    "Shipping Carrier Code" := AJWebServiceWarehouse."Def. Shipping Carrier Code";
                    if AJWebServiceWarehouse."Def. Shipping Carrier Service" <> '' then
                        Validate("Shipping Carrier Service", AJWebServiceWarehouse."Def. Shipping Carrier Service");
                    if AJWebServiceWarehouse."Def. Shipping Package Type" <> '' then
                        Validate("Shipping Package Type", AJWebServiceWarehouse."Def. Shipping Package Type");
                    if AJWebServiceWarehouse."Def. Shipping Delivery Confirm" <> '' then
                        "Shipping Delivery Confirm" := AJWebServiceWarehouse."Def. Shipping Delivery Confirm";
                    "Insure Shipment" := AJWebServiceWarehouse."Def. Insure Shipment";
                    if AJWebServiceWarehouse."Def. Insurance Value" <> 0 then
                        "Insured Value" := AJWebServiceWarehouse."Def. Insurance Value";
                    if AJWebServiceWarehouse."Def. Product Weight Unit" <> '' then
                        "Shp. Product Weight Unit" := AJWebServiceWarehouse."Def. Product Weight Unit";
                    if AJWebServiceWarehouse."Free Shipping" then
                        "Free Shipping" := true;
                end;
            end;
        }
        field(81; "Ship-From Warehouse ID ext."; Code[40])
        {
            TableRelation = IF ("Shipping Web Service Code" = CONST ('')) "AJ Web Service Warehouse"."Warehouse ID" WHERE ("Web Service Code" = FIELD ("Web Service Code"))
            ELSE
            IF ("Shipping Web Service Code" = FILTER (<> '')) "AJ Web Service Warehouse"."Warehouse ID" WHERE ("Web Service Code" = FIELD ("Shipping Web Service Code"));

            trigger OnValidate()
            var
                AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
            begin
                if AJWebServiceWarehouse.Get("Shipping Web Service Code", "Ship-From Warehouse ID") then begin
                    Validate("Shipping Carrier Code", AJWebServiceWarehouse."Def. Shipping Carrier Code");
                    Validate("Shipping Carrier Service", AJWebServiceWarehouse."Def. Shipping Carrier Service");
                    Validate("Shipping Package Type", AJWebServiceWarehouse."Def. Shipping Package Type");
                end;
            end;
        }
        field(100; "Web Service Order Status"; Text[30])
        {
        }
        field(101; "Web Service Customer ID"; Text[50])
        {
        }
        field(102; "Web Service Customer Name"; Text[100])
        {
        }
        field(103; "Web Service Customer Email"; Text[50])
        {
        }
        field(110; "Cancel After Date"; Date)
        {
        }
        field(111; "Customer Reference ID"; Text[35])
        {
        }
        field(112; "Merchandise Amount"; Decimal)
        {
        }
        field(113; "Batch ID"; Code[40])
        {
        }
        field(114; "Web Service Customer ID2"; Text[30])
        {
        }
        field(200; "Total Amount"; Decimal)
        {
        }
        field(201; "Paid Amount"; Decimal)
        {
        }
        field(202; "Tax Amount"; Decimal)
        {
        }
        field(203; "Shipping Amount"; Decimal)
        {
        }
        field(204; Gift; Boolean)
        {
        }
        field(205; "Gift Message"; Text[100])
        {
        }
        field(206; "Payment Method"; Text[10])
        {
        }
        field(207; "Handling Amount"; Decimal)
        {
        }
        field(210; "Shipping Options"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code" = FIELD ("Shipping Web Service Code"),
                                                                             Type = CONST (Option),
                                                                             Blocked = CONST (false));

            trigger OnValidate()
            begin
                TestMerchant;
            end;
        }
        field(211; "Shipping Delivery Confirm"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code" = FIELD ("Shipping Web Service Code"),
                                                                             Type = CONST (Confirmation),
                                                                             Blocked = CONST (false));

            trigger OnValidate()
            begin
                TestMerchant;
            end;
        }
        field(212; "Ship Date"; Date)
        {
        }
        field(213; "Hold Until Date"; Date)
        {
        }
        field(214; "Thermal Printer"; Boolean)
        {
        }
        field(215; "Return Label"; Boolean)
        {
        }
        field(217; "Insure Shipment"; Boolean)
        {
        }
        field(218; "Shipping Insutance Provider"; Text[30])
        {
        }
        field(219; "Insured Value"; Decimal)
        {
        }
        field(220; "International Content"; Text[1])
        {
        }
        field(221; "Customs Items"; Text[20])
        {
        }
        field(222; "Non Delivery"; Text[20])
        {
        }
        field(223; "International Shipment"; Boolean)
        {
        }
        field(230; "Ship-to Type"; Option)
        {
            OptionCaption = ' ,Customer,Store,XStore';
            OptionMembers = " ",D2C,D2S,X2S;
        }
        field(300; "Warehouse Wate ID"; Text[30])
        {
        }
        field(301; "Non Machinable"; Boolean)
        {
        }
        field(302; "Saturday Delivery"; Boolean)
        {
        }
        field(303; "Contains Alcohol"; Boolean)
        {
        }
        field(304; "Merged or Split"; Boolean)
        {
        }
        field(305; "Merged Or Split IDs"; Text[50])
        {
        }
        field(306; "Parent ID"; Text[30])
        {
        }
        field(400; "Custom Field 1"; Text[100])
        {
        }
        field(401; "Custom Field 2"; Text[100])
        {
        }
        field(402; "Custom Field 3"; Text[50])
        {
        }
        field(403; Source; Text[30])
        {
        }
        field(404; "Bill-to Type"; Option)
        {
            OptionCaption = 'My Account,Recipient,Third Party,My Other Account';
            OptionMembers = my_account,recipient,third_party,my_other_account;
        }
        field(405; "Bill-To Account"; Text[30])
        {
        }
        field(406; "Bill-To Postal Code"; Text[10])
        {
        }
        field(407; "Bill-To Country Code"; Text[30])
        {
        }
        field(408; "Customer Notes"; Text[100])
        {
        }
        field(409; "Internal Notes"; Text[50])
        {
        }
        field(500; Tags; Text[50])
        {
        }
        field(501; "User ID"; Text[50])
        {
        }
        field(502; "Externally Fulfilled"; Boolean)
        {
        }
        field(503; "Externally Fulfilled By"; Text[15])
        {
        }
        field(900; "Labels Created"; Boolean)
        {
        }
        field(901; "Labels Printed"; Boolean)
        {
        }
        field(902; "Shipment Confirmed"; Boolean)
        {
        }
        field(903; "Packing List Created"; Boolean)
        {
        }
        field(904; "Packing List Printed"; Boolean)
        {
        }
        field(905; "Shipping Advice"; Option)
        {
            OptionMembers = " ",Require,Sent;
        }
        field(906; "Invoice No."; Code[20])
        {
        }
        field(907; "Invoice Advice"; Option)
        {
            OptionMembers = " ",Require,Sent;
        }
        field(908; "Invoice Send DateTime"; DateTime)
        {
        }
        field(909; "PO Ackn. Advice"; Option)
        {
            OptionMembers = " ",Require,Sent;
        }
        field(910; "Shipment No."; Code[20])
        {
        }
        field(911; "FA Advice"; Option)
        {
            OptionMembers = " ",Require,Sent;
        }
        field(960; "COD Amount"; Decimal)
        {
        }
        field(961; "Has Tags"; Boolean)
        {
        }
        field(962; "COD Status"; Option)
        {
            OptionMembers = " ",Requested,Received;
        }
        field(964; "COD Additional Amount"; Decimal)
        {
        }
        field(1000; "Acknowlegement Sent"; Boolean)
        {
        }
        field(1001; "NAV Order Status"; Option)
        {
            OptionMembers = "New Order",Errors,Created,Shipped,"Shipment Confirmed",,,,,,,,Cancelled,"Partially Shipped",Pending;

            trigger OnValidate()
            var
                AJShippingHeader: Record "AJ Shipping Line";
            begin
                AJShippingHeader.SetRange("Log No.", "Log No.");
                if AJShippingHeader.FindFirst then
                    repeat
                        AJShippingHeader."NAV Order Status" := "NAV Order Status";
                        AJShippingHeader.Modify;
                    until AJShippingHeader.Next = 0;
            end;
        }
        field(1002; "Created Order Text"; BLOB)
        {
        }
        field(1003; "Last Load TExt"; BLOB)
        {
        }
        field(1004; "Oder Modified"; Boolean)
        {
        }
        field(1005; "Packing List"; BLOB)
        {
        }
        field(1006; "Shipping Agent Label"; BLOB)
        {
        }
        field(1007; "NAV Order Count"; Integer)
        {
            CalcFormula = Count ("Sales Header" WHERE ("Web Order No." = FIELD ("Log No."),
                                                      "Document Type" = CONST (Order)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1008; "NAV Error Text"; Text[100])
        {
        }
        field(1009; "Carier Shipping Charge"; Decimal)
        {
        }
        field(1010; "Carier Tracking Number"; Text[30])
        {
        }
        field(1011; "Carier Insurance Cost"; Decimal)
        {
        }
        field(1052; "Created From Sales Order"; Boolean)
        {
        }
        field(1053; "Additional Insurance Value"; Decimal)
        {
        }
        field(1054; "Shipping & Handling Amount"; Decimal)
        {
        }
        field(1060; "Payment Gateway"; Text[20])
        {
        }
        field(1063; "Financial Status"; Text[20])
        {
        }
        field(1065; "Card Type"; Text[20])
        {
        }
        field(1066; "Payment Id"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(1070; "Order Level Discount"; Decimal)
        {
        }
        field(1200; Packages; Boolean)
        {
            CalcFormula = Exist ("AJ Web Package" WHERE ("Source Type" = CONST (37074833),
                                                        "Source No." = FIELD ("Log No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1201; "Packages Ship. & Hand. Amount"; Decimal)
        {
            CalcFormula = Sum ("AJ Web Package"."Shipping & Handling Amount" WHERE ("Source Type" = CONST (37074833),
                                                                                   "Source No." = FIELD ("Log No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1202; "Packages Count"; Integer)
        {
            CalcFormula = Count ("AJ Web Package" WHERE ("Source Type" = CONST (37074833),
                                                        "Source No." = FIELD ("Log No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1300; "Enclousure Card Text"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(1301; "Order Instructions"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(1302; "Authorized Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1303; "Captured Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(1304; "Customer is Guest"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(2000; "Document Type"; Option)
        {
            OptionMembers = "Order",Return;
        }
        field(2001; "Apply-To Web Order No."; Code[20])
        {
        }
        field(2002; "Apply-To Web Service Order ID"; Code[50])
        {
        }
        field(2003; agree_to_return_charge; Boolean)
        {
            Caption = 'Agree To Return Charge';
        }
        field(2004; refund_without_return; Boolean)
        {
            Caption = 'Refund Without Return';
        }
        field(2005; return_charge_feedback; Option)
        {
            Caption = 'Return Charge Feedback';
            OptionMembers = other,outsideMerchantPolicy,notMerchantError;
        }
        field(2006; merchant_return_charge; Decimal)
        {
            Caption = 'Merchant Return Charge>';
        }
        field(3000; "Free Shipping"; Boolean)
        {
        }
        field(5001; "Latest Delivery Date"; DateTime)
        {
        }
        field(5002; "Shipping Service Criterion"; Option)
        {
            OptionMembers = " ",Optimal,PriceOnly;
        }
        field(5003; "Shipment Id"; Text[50])
        {
        }
        field(5005; "Cancel Reason"; Option)
        {
            OptionMembers = " ",NoInventory,ShippingAddressUndeliverable,CustomerExchange,BuyerCanceled,GeneralAdjustment,CarrierCreditDecision,RiskAssessmentInformationNotValid,CarrierCoverageFailure,CustomerReturn,MerchandiseNotReceived;

            trigger OnValidate()
            var
                WebOrdLine: Record "AJ Shipping Line";
            begin
            end;
        }
        field(5007; "Latest Ship Date"; DateTime)
        {
        }
        field(5008; "Total Quantity"; Decimal)
        {
            CalcFormula = Sum ("AJ Shipping Line".Quantity WHERE ("Log No." = FIELD ("Log No.")));
            DecimalPlaces = 0 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5009; Lines; Integer)
        {
            CalcFormula = Count ("AJ Shipping Line" WHERE ("Log No." = FIELD ("Log No."),
                                                           Quantity = FILTER (<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5010; "Send Ship Confirmation"; Boolean)
        {
        }
        field(6000; "Special Customer Account"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(6001; "Set Customer No. To"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(6002; "Fraud Filter Triggered"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Log No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        AJShippingHeader: Record "AJ Shipping Line";
        SalesHeader: Record "Sales Header";
        AJWebPackage: Record "AJ Web Package";
    begin
        if CurrFieldNo <> 0 then
            if AJWebService.Get("Web Service Code") then
                if not AJWebService."Allow to Delete WebOrder" then
                    Error('You cannot delete Web Order!');

        SalesHeader.Reset;
        SalesHeader.SetRange("Web Order No.", "Log No.");
        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice);
        if SalesHeader.FindFirst then
            if not "Created From Sales Order" then begin
                SalesHeader.DeleteAll(true);
            end else begin
                SalesHeader."Web Order No." := '';
                SalesHeader.Modify;
            end;

        AJWebPackage.SetRange("Source Type", DATABASE::"AJ Web Order Header");
        AJWebPackage.SetRange("Source No.", "Log No.");
        if not AJWebPackage.IsEmpty then
            AJWebPackage.DeleteAll(true);

        AJShippingHeader.SetRange("Log No.", "Log No.");
        if not AJShippingHeader.IsEmpty then
            AJShippingHeader.DeleteAll(true);
    end;

    trigger OnInsert()
    var
        AJWebSetup: Record "AJ Web Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        if "Log No." = '' then begin
            AJWebSetup.Get;
            AJWebSetup.TestField("Web Order No. Series");
            "Log No." := NoSeriesManagement.GetNextNo(AJWebSetup."Web Order No. Series", WorkDate, true);
        end;
    end;

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        AJWebService: Record "AJ Web Service";

    procedure InitRecord(ShippingAgentCode: Code[10])
    var
        ShippingAgent: Record "Shipping Agent";
        AJWebService: Record "AJ Web Service";
        AJWebCarrier: Record "AJ Web Carrier";
        AJShippingHeader: Record "AJ Shipping Header";
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
    begin
        SalesReceivablesSetup.Get;

        AJShippingHeader := Rec;

        AJShippingHeader.Init;
        AJShippingHeader."Log No." := '';
        AJShippingHeader."Created From Sales Order" := true;
        AJShippingHeader."Created DateTime" := CurrentDateTime;
        AJShippingHeader."Order DateTime" := CurrentDateTime;
        AJShippingHeader.Insert(true);

        if not ShippingAgent.Get(ShippingAgentCode) then
            ShippingAgent.Init;
        if ShippingAgent."Shipping Web Service Code" <> '' then begin
            AJWebService.Get(ShippingAgent."Shipping Web Service Code");
        end else begin
            AJWebService.SetRange(AJWebService."Web Service Type", AJWebService."Web Service Type"::ShipStation);
            if AJWebService.FindFirst then;
        end;
        AJShippingHeader.Validate("Shipping Web Service Code", AJWebService.Code);

        if AJShippingHeader."Web Service Code" = '' then
            AJShippingHeader.Validate("Web Service Code", AJWebService.Code);

        if ShippingAgent."Shipping Carrier Code" <> '' then begin
            AJWebCarrier.Get(ShippingAgent."Shipping Web Service Code", ShippingAgent."Shipping Carrier Code");
            AJShippingHeader."Shipping Carrier Code" := ShippingAgent."Shipping Carrier Code";
        end;

        AJShippingHeader.Modify;

        Rec := AJShippingHeader;
    end;

    local procedure TestLabelCreated()
    begin
    end;

    local procedure TestMerchant()
    var
        AJWebService: Record "AJ Web Service";
        Customer: Record Customer;
        AJWebPackage: Record "AJ Web Package";
    begin
        if not AJWebService.Get("Web Service Code") then
            exit;
        if AJWebService."Shipping Service" = AJWebService."Shipping Service"::Merchant then
            Error('Shipping parameters specified by Merchant!');
    end;

    [Scope('Internal')]
    procedure InitRecord2(ShipmentMethodCode: Code[10]; StoreNo: Code[10])
    var
        AJWebService: Record "AJ Web Service";
        AJWebCarrier: Record "AJ Web Carrier";
        AJShippingHeader: Record "AJ Shipping Header";
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
        ShipmentMethod: Record "Shipment Method";
        AJWebCarrierService: Record "AJ Web Carrier Service";
    begin
        AJShippingHeader := Rec;

        AJShippingHeader.Init;
        AJShippingHeader."Log No." := '';
        AJShippingHeader."Created From Sales Order" := true;
        AJShippingHeader."Created DateTime" := CurrentDateTime;
        AJShippingHeader."Order DateTime" := CurrentDateTime;
        AJShippingHeader.Insert(true);

        if not ShipmentMethod.Get(ShipmentMethodCode) then
            ShipmentMethod.Init;
        AJWebCarrierService.SetFilter("Shipment Method Code", ShipmentMethod.Code);
        if AJWebCarrierService.FindFirst then begin
            AJWebService.Get(AJWebCarrierService."Web Service Code");

            AJShippingHeader.Validate("Web Service Code", AJWebService.Code);
            AJShippingHeader.Validate("Shipping Web Service Code", AJWebService.Code);
            AJShippingHeader.Validate("Shipping Carrier Code", AJWebCarrierService."Web Carrier Code");
            AJShippingHeader.Validate("Shipping Carrier Service", AJWebCarrierService."Service  Code");
            AJShippingHeader.Validate("Shipping Package Type", AJWebCarrierService."Default Package Code");

        end else begin
            AJWebService.SetRange(AJWebService."Web Service Type", AJWebService."Web Service Type"::ShipStation);
            if not AJWebService.FindFirst then
                Error('Web Service not found!');
            if AJShippingHeader."Web Service Code" = '' then
                AJShippingHeader.Validate("Web Service Code", AJWebService.Code);
            AJShippingHeader.Validate("Shipping Web Service Code", AJWebService.Code);
        end;

        AJShippingHeader.Modify;

        Rec := AJShippingHeader;
    end;

    procedure SetResponseContent(var value: HttpContent)
    var
        InStr: InStream;
        OutStr: OutStream;
    begin
        "Shipping Agent Label".CreateInStream(InStr);
        value.ReadAs(InStr);

        "Shipping Agent Label".CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);

    end;
}

