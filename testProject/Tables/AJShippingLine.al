table 37072314 "AJ Shipping Line"
{

    fields
    {
        field(1; "Log No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Order Item ID"; Text[32])
        {
            Editable = false;
        }
        field(4; "Line Item Key"; Text[30])
        {
            Editable = false;
        }
        field(5; "Web Service Code"; Code[10])
        {
        }
        field(6; "Web Service Store ID"; Code[10])
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
        field(13; Name; Text[250])
        {
            Editable = false;
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
                                                                            "Source No." = FIELD("Log No."),
                                                                            "Source Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1201; "Package Quantity"; Decimal)
        {
            CalcFormula = Sum ("AJ Web Package Line".Quantity WHERE("Source Type" = CONST(37074834),
                                                                    "Source No." = FIELD("Log No."),
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
    }

    keys
    {
        key(Key1; "Log No.", "Line No.", "Order Item ID")
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

