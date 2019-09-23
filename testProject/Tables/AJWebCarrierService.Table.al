table 37072305 "AJ Web Carrier Service"
{
    DrillDownPageID = "AJ Web Carrier Services";
    LookupPageID = "AJ Web Carrier Services";

    fields
    {
        field(1; "Web Service Code"; Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(2; "Web Carrier Code"; Text[50])
        {
        }
        field(3; "Service  Code"; Text[50])
        {
        }
        field(4; Name; Text[100])
        {
        }
        field(5; Domestic; Boolean)
        {
        }
        field(6; International; Boolean)
        {
        }
        field(20; "Cross Reference Code"; Text[30])
        {
            Caption = 'CommerceHUB Code';
            Description = '160426';
        }
        field(21; "Cross Reference Code 2"; Text[30])
        {
            Caption = 'JetCom Code';
            Description = '160705';
        }
        field(25; "Additional Charge %"; Decimal)
        {
        }
        field(26; "Additional Charge $"; Decimal)
        {
        }
        field(28; "Shipment Method Code"; Code[10])
        {
            TableRelation = "Shipment Method";
        }
        field(29; "Shipping Agent Code"; Code[10])
        {
            TableRelation = "Shipping Agent";
        }
        field(30; "Shipping Agent Service Code"; Code[10])
        {
            TableRelation = "Shipping Agent Services".Code WHERE ("Shipping Agent Code" = FIELD ("Shipping Agent Code"));
        }
        field(50; Blocked; Boolean)
        {
        }
        field(410; "Max Insurance Limit"; Decimal)
        {
        }
        field(411; "Default Package Code"; Text[50])
        {

            trigger OnLookup()
            begin
                GetPackageCodeAndPackageName;
            end;
        }
        field(412; "Default Package Name"; Text[100])
        {

            trigger OnLookup()
            begin
                GetPackageCodeAndPackageName;
            end;
        }
        field(419; "Shipping Service Code"; Code[20])
        {
            CalcFormula = Lookup ("AJ Web Service"."Shipping Service Code" WHERE (Code = FIELD ("Web Service Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Web Service Code", "Web Carrier Code", "Service  Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure GetPackageCodeAndPackageName()
    var
        AJWebCarrierPackage: Record "AJ Web Carrier Package Type";
    begin
        CalcFields("Shipping Service Code");
        TestField("Shipping Service Code");
        TestField("Web Carrier Code");
        AJWebCarrierPackage.SetRange("Web Service Code", "Shipping Service Code");
        AJWebCarrierPackage.SetRange("Web Carrier Code", "Web Carrier Code");
        if PAGE.RunModal(0, AJWebCarrierPackage) = ACTION::LookupOK then begin
            "Default Package Code" := AJWebCarrierPackage."Package Code";
            "Default Package Name" := AJWebCarrierPackage."Package Name";
        end;
    end;
}

