table 37072314 "AJ Shipping Line"
{

    fields
    {
        field(1; "Shipping No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Source Type"; Option)
        {
            OptionMembers = " ",Document,Item,Comments;
        }
        field(4; "Source ID"; Text[32])
        {
        }
        field(5; "Web Service Code"; Code[10])
        {
        }
        field(6; "Web Service Store ID"; Code[10])
        {
        }
        field(7; "Source Table ID"; Integer)
        {
        }
        field(10; SKU; Text[30])
        {
            Editable = false;
        }
        field(11; Status; Text[30])
        {
            Editable = false;
        }
        field(12; Permalink; Text[250])
        {
            Editable = false;
        }
        field(13; Description; Text[250])
        {
        }
        field(14; Weight; Decimal)
        {
        }
        field(15; "GG Account Number"; Text[30])
        {
            Editable = false;
        }
        field(16; "PO Number"; Text[30])
        {
            Editable = false;
        }
        field(17; "Channel SKU Provided"; Text[30])
        {
            Editable = false;
        }
        field(18; "Fulfillment Lineitem Id"; Text[30])
        {
            Editable = false;
        }
        field(19; "Unit Price"; Decimal)
        {
            Editable = false;
        }
        field(20; "BOM SKU"; Text[250])
        {
            Editable = false;
        }
        field(21; "Opp Name"; Text[250])
        {
            Editable = false;
        }
        field(22; "Kitting Details"; Text[250])
        {
            Editable = false;
        }
        field(23; "Ci Lineitem Id"; Integer)
        {
            Editable = false;
        }
        field(24; "Gift Message"; Text[250])
        {
            Editable = false;
        }
        field(25; Quantity; Decimal)
        {
        }
        field(26; "Weigh Unit"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE("Web Order Service Code" = FIELD("Web Service Code"),
                                                                             Type = CONST(Weight));
        }
        field(28; "Qty. to Ship"; Decimal)
        {
        }
        field(29; "Quantity Shipped"; Decimal)
        {
        }
        field(30; "Qty. to Cancel"; Decimal)
        {
        }
        field(31; "Quantity Cancelled"; Decimal)
        {
        }
        field(32; "Qty. to Return"; Decimal)
        {
        }
        field(33; "Quantity Returned"; Decimal)
        {
        }
        field(40; "Qty. to Pack"; Decimal)
        {
        }
        field(41; "Quantity Packed"; Decimal)
        {
        }
        field(50; "Retail Unit Price"; Decimal)
        {
            Editable = false;
        }
        field(100; "Mark Exported"; Boolean)
        {
        }
        field(101; "Upd. Carrier"; Text[30])
        {
        }
        field(102; "Upd. Tracking"; Text[30])
        {
        }
        field(140; "Item Color"; Text[30])
        {
        }
        field(141; "Item Size"; Text[30])
        {
        }
        field(150; "Custom Text 1"; Text[50])
        {
        }
        field(151; "Custom Text 2"; Text[50])
        {
        }
        field(152; "Custom Text 3"; Text[50])
        {
        }
        field(153; "Custom Text 4"; Text[50])
        {
        }
        field(154; "Custom Text 5"; Text[50])
        {
        }
        field(200; "Image URL"; Text[100])
        {
        }
        field(201; "Tax Amount"; Decimal)
        {
        }
        field(202; "Shipping Amount"; Decimal)
        {
        }
        field(203; "Warehouse Location"; Text[30])
        {
        }
        field(204; Options; Text[250])
        {
        }
        field(205; "Web Service SKU ID"; Text[30])
        {
        }
        field(206; Adjustment; Boolean)
        {
        }
        field(207; UPC; Text[30])
        {
        }
        field(208; "Create DateTime"; DateTime)
        {
        }
        field(209; "Modify dateTime"; DateTime)
        {
        }
        field(210; "Shipping Tax Amount"; Decimal)
        {
        }
        field(211; "Options Long Text"; BLOB)
        {
        }
        field(1001; "NAV Order Status"; Option)
        {
            OptionMembers = "New Order",Errors,Created,Shipped,"Shipment Confirmed",,,,,,,,Cancelled;
        }
        field(1200; "Package No."; Code[20])
        {
            CalcFormula = Lookup ("AJ Web Package Line"."Package No." WHERE("Source Type" = CONST(37074834),
                                                                            "Source No." = FIELD("Shipping No."),
                                                                            "Source Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1201; "Package Quantity"; Decimal)
        {
            CalcFormula = Sum ("AJ Web Package Line".Quantity WHERE("Source Type" = CONST(37074834),
                                                                    "Source No." = FIELD("Shipping No."),
                                                                    "Source Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(2000; "Line Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(2001; "Item Option 1"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2002; "Item Option 1 Value"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(2003; "Item Option 2"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2004; "Item Option 2 Value"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(2005; "Gift Payment Line"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(2006; "Gift Card No."; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(2500; "Web Service Shipment ID"; Text[30])
        {
        }
        field(2501; "Shp. Product Dimension Unit"; Text[30])
        {
        }
        field(2502; "Shp. Product Weight Unit"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE("Web Order Service Code" = FIELD("Shipping Web Service Code"),
                                                                             Type = CONST(Weight));
        }
        field(2503; "Shp. Product Weight"; Decimal)
        {
        }
        field(2504; "Shp. Product Width"; Decimal)
        {
        }
        field(2505; "Shp. Product Length"; Decimal)
        {
        }
        field(2506; "Shp. Product Height"; Decimal)
        {
        }
        field(2507; "Shipping Delivery Confirm"; Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE("Web Order Service Code" = FIELD("Shipping Web Service Code"),
                                                                             Type = CONST(Confirmation),
                                                                             Blocked = CONST(false));
        }
        field(2508; "Shipping Carrier Code"; Text[50])
        {

            trigger OnValidate()
            var
                AJWebCarrier: Record "AJ Web Carrier";
            begin
                TestField("Shipping Web Service Code");

                if AJWebCarrier.Get("Shipping Web Service Code", "Shipping Carrier Code") then begin
                    if AJWebCarrier."Def. Shipping Carrier Service" <> '' then
                        Validate("Shipping Carrier Service", AJWebCarrier."Def. Shipping Carrier Service");
                    if AJWebCarrier."Def. Shipping Package Type" <> '' then
                        Validate("Shipping Package Type", AJWebCarrier."Def. Shipping Package Type");
                    if AJWebCarrier."Def. Shipping Delivery Confirm" <> '' then
                        Validate("Shipping Delivery Confirm", AJWebCarrier."Def. Shipping Delivery Confirm");
                end;
            end;
        }
        field(2509; "Shipping Carrier Service"; Text[50])
        {
            trigger OnValidate()
            var
                AJWebCarrierServices: Record "AJ Web Carrier Service";
            begin

                TestField("Shipping Web Service Code");

                if AJWebCarrierServices.Get("Shipping Web Service Code", "Shipping Carrier Code", "Shipping Carrier Service") then
                    Validate("Shipping Package Type", AJWebCarrierServices."Default Package Code");
            end;
        }
        field(2510; "Customer Reference ID"; Text[35])
        {
        }
        field(2511; "Custom Field 1"; Text[100])
        {
        }
        field(2512; "Custom Field 2"; Text[100])
        {
        }
        field(2513; "Custom Field 3"; Text[50])
        {
        }
        field(3000; "Bill-To Customer Name"; Text[100])
        {
        }
        field(3001; "Bill-To Customer Zip"; Text[10])
        {
        }
        field(3002; "Bill-To Customer Country"; Text[10])
        {
        }
        field(3003; "Bill-To Customer State"; Text[20])
        {
        }
        field(3004; "Bill-To Customer City"; Text[50])
        {
        }
        field(3005; "Bill-To Customer Address 1"; Text[100])
        {
        }
        field(3006; "Bill-To Customer Address 2"; Text[80])
        {
        }
        field(3007; "Bill-To Customer Phone"; Text[30])
        {
        }
        field(3008; "Bill-To Company"; Text[80])
        {
        }
        field(3009; "Bill-To Residential"; Boolean)
        {
        }
        field(3010; "Bill-To Verified"; Text[30])
        {
        }
        field(3011; "Bill-To Customer Address 3"; Text[100])
        {
        }
        field(3012; "Bill-To E-mail"; Text[35])
        {
        }
        field(3013; "Ship-To Customer Name"; Text[100])
        {
        }
        field(3014; "Ship-To Customer Zip"; Text[10])
        {
        }
        field(3015; "Ship-To Customer Country"; Text[10])
        {
        }
        field(3016; "Ship-To Customer State"; Text[20])
        {
        }
        field(3017; "Ship-To Customer City"; Text[50])
        {
        }
        field(3018; "Ship-To Customer Address 1"; Text[100])
        {
        }
        field(3019; "Ship-To Customer Address 2"; Text[100])
        {
        }
        field(3020; "Ship-To Customer Phone"; Text[30])
        {
        }
        field(3021; "Ship-To Company"; Text[100])
        {
        }
        field(3022; "Ship-To Residential"; Boolean)
        {
        }
        field(3023; "Ship-To Address Verified"; Text[30])
        {
        }
        field(3024; "Ship-To Customer Address 3"; Text[50])
        {
        }
        field(3025; "Ship-To E-mail"; Text[35])
        {
        }
        field(3026; "Ship-To First Name"; Text[20])
        {
        }
        field(3027; "Ship-To Last Name"; Text[20])
        {
        }
        field(3028; "Ship-From Warehouse ID"; Code[40])
        {
        }
        field(3029; "Ship-From Warehouse ID ext."; Code[40])
        {
        }

        field(3030; "Shipping Package Type"; Text[30])
        {

            trigger OnValidate()
            var
                AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
            begin
                //TestField("Shipping Web Service Code");

                if AJWebCarrierPackageType.Get("Shipping Web Service Code", "Shipping Carrier Code", "Shipping Package Type") then begin
                    if "Shipping Delivery Confirm" = '' then
                        Validate("Shipping Delivery Confirm", AJWebCarrierPackageType."Shipping Delivery Confirm");
                    Validate("Shp. Product Weight Unit", AJWebCarrierPackageType."Def. Weight Unit");
                    Validate("Shp. Product Weight", AJWebCarrierPackageType."Def. Weight");
                    Validate("Shp. Product Dimension Unit", AJWebCarrierPackageType."Def. Dimension Unit");
                    Validate("Shp. Product Width", AJWebCarrierPackageType."Def. Width");
                    Validate("Shp. Product Length", AJWebCarrierPackageType."Def. Length");
                    Validate("Shp. Product Height", AJWebCarrierPackageType."Def. Height");
                end;
            end;
        }
        field(3031; "Shipping Web Service Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Shipping No.", "Line No.", "Source ID")
        {
            Clustered = true;
        }
        key(Key2; "Web Service Code", "Web Service SKU ID", "NAV Order Status")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        AJWebPackageLine.Reset();
        AJWebPackageLine.SetRange("Source Type", DATABASE::"AJ Web Order Line");
        AJWebPackageLine.SetRange("Source No.", "Package No.");
        AJWebPackageLine.SetRange("Source Line No.", "Line No.");
        if AJWebPackageLine.FindFirst() then
            Error('Could not delete order line %1! Please delete package %2.', "Line No.", AJWebPackageLine."Package No.");
    end;

    var
        AJWebPackageLine: Record "AJ Web Package Line";

    [Scope('Internal')]
    procedure OutstandingQuantity() OutstandingQty: Decimal
    begin
        OutstandingQty := Quantity - "Quantity Shipped" - "Quantity Cancelled" + "Quantity Returned";
    end;
}

