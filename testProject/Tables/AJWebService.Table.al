table 37072302 "AJ Web Service"
{
    DrillDownPageID = "AJ Web Services";
    LookupPageID = "AJ Web Services";
    Caption = 'Aj Web Services';
    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; "API Endpoint Domain"; Text[250])
        {
        }
        field(5; "API User ID (Key)"; Text[100])
        {

            trigger OnValidate()
            begin
                CalcAPIEncodedString;
            end;
        }
        field(6; "API Password (Secret)"; Text[100])
        {
            ExtendedDatatype = Masked;

            trigger OnValidate()
            begin
                CalcAPIEncodedString;
            end;
        }
        field(7; "API Encoded String"; Text[250])
        {
        }
        field(8; "Web Service Type"; Option)
        {
            OptionMembers = " ",ShipStation;
        }
        field(10; "Web Service SubType"; Option)
        {
            OptionMembers = " ","JC Penny",Bluestem,BethMacri,Boscovs,KMart,Sears,Walmart,BJs,Evine,SMS,WhatsApp;
        }
        field(15; "Partner ID"; Text[32])
        {
            Caption = 'Partner ID (CommerceHUB)';
        }
        field(16; "Partner Name"; Text[30])
        {
            Caption = 'Partner Name (CommerceHUB)';
        }
        field(18; "Secure FTP"; Boolean)
        {
        }
        field(19; "FTP Port"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "FTP Address"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "# New Web Orders"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (.. Created),
                                                             "Document Type" = CONST (Order)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "# Error Web Orders"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Errors),
                                                             "Document Type" = CONST (Order)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "# Open NAV Orders"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Created)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(34; "# Ship Labels Created"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Created),
                                                             "Labels Created" = CONST (true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "# Packing Lists Created"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Created),
                                                             "Packing List Created" = CONST (true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(36; "# Ship Labels Printed"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Created),
                                                             "Labels Printed" = CONST (true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(37; "# Packing Lists Printed"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Created),
                                                             "Packing List Printed" = CONST (true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "# Shipped Web Orders"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Shipped),
                                                             "Shipping Advice" = CONST (Require)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "# Completed Web Orders"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Shipped),
                                                             "Shipping Advice" = FILTER (" " | Sent)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "# Pending Web Orders"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Pending),
                                                             "Document Type" = CONST (Order)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(44; "# Error and New Web Orders"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER ("New Order" | Errors),
                                                             "Document Type" = CONST (Order)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Shipping Service Code"; Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(60; "# New Web Returns"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (.. Created),
                                                             "Document Type" = CONST (Return)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                AJWebOrderHeader: Record "AJ Web Order Header";
            begin

                AJWebOrderHeader.Reset;
                AJWebOrderHeader.SetRange("Web Service Code", Code);
                AJWebOrderHeader.SetRange("Document Type", AJWebOrderHeader."Document Type"::Return);
                AJWebOrderHeader.SetFilter("NAV Order Status", '..Created');
                PAGE.RunModal(PAGE::"AJ Web Return List", AJWebOrderHeader);
            end;
        }
        field(61; "# Error Web Returns"; Integer)
        {
            CalcFormula = Count ("AJ Web Order Header" WHERE ("Web Service Code" = FIELD (Code),
                                                             "NAV Order Status" = FILTER (Errors),
                                                             "Document Type" = CONST (Return)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                AJWebOrderHeader: Record "AJ Web Order Header";
            begin
                AJWebOrderHeader.Reset;
                AJWebOrderHeader.SetRange("Web Service Code", Code);
                AJWebOrderHeader.SetRange("Document Type", AJWebOrderHeader."Document Type"::Return);
                AJWebOrderHeader.SetFilter("NAV Order Status", 'Errors');
                PAGE.RunModal(PAGE::"AJ Web Return List", AJWebOrderHeader);
            end;
        }
        field(62; "API Token"; Text[100])
        {
        }
        field(63; "API Sellier ID"; Text[30])
        {
        }
        field(402; "Rate Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(403; "Limit Remaining"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(404; "Limit Reset"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(405; "Bill-to Type"; Option)
        {
            OptionCaption = 'My Account,Recipient,Third Party';
            OptionMembers = MyAccount,Recipient,ThirdParty;
        }
        field(406; "Bill-to Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(407; "Bill-to Account Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(408; "Bill-to Account Country Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(412; "Ship-From Warehouse ID"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = "AJ Web Service Warehouse"."Warehouse ID";

            trigger OnValidate()
            var
                AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
            begin
            end;
        }
        field(510; "Shipping Service"; Option)
        {
            OptionMembers = " ",Merchant;
        }
        field(511; "Default MarketPlace id"; Code[10])
        {
            TableRelation = "AJ Web Marketplace (Mailbox)".Code WHERE ("Web Service Code" = FIELD (Code));
        }
        field(530; "Allow to Delete WebOrder"; Boolean)
        {
        }
        field(601; "Reference 1"; Option)
        {
            OptionMembers = " ","1";
        }
        field(602; "Reference 2"; Option)
        {
            OptionMembers = " ","1";
        }
        field(603; "Reference 3"; Option)
        {
            OptionMembers = " ",PO;
        }
        field(3002; "Shipping Charge Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "From Web Services Setup","G/L Account",Item;
        }
        field(3003; "Shipping Charge No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Shipping Charge Type" = CONST ("G/L Account")) "G/L Account"."No."
            ELSE
            IF ("Shipping Charge Type" = CONST (Item)) Item."No.";
        }
        field(31004; "HMAC Key"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CalcAPIEncodedString()
    var
        Base64Convert: Codeunit Base64Convert;
    begin
        if ("API User ID (Key)" = '') or ("API Password (Secret)" = '') then
            exit;
        "API Encoded String" := Base64Convert.TextToBase64String(StrSubstNo('%1:%2', "API User ID (Key)", "API Password (Secret)"));
    end;
}

