table 37072306 "AJ Web Marketplace (Mailbox)"
{

    fields
    {
        field(1; "Web Service Code"; Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; "Marketplace Option"; Option)
        {
            OptionMembers = " ",Groupon,CommerceHUB,JetCOM;
        }
        field(5; "Item ID Type"; Option)
        {
            OptionMembers = " ","NAV No.",UPC,Barcode,"Def. Customer Cross-Reference";
        }
        field(100; "Can Refresh"; Boolean)
        {
        }
        field(101; "Supports Custom Mappings"; Boolean)
        {
        }
        field(102; "Supports Custom Statuses"; Boolean)
        {
        }
        field(103; "Can Confirm Shipments"; Boolean)
        {
        }
        field(37075080; "Table ID"; Integer)
        {
            TableRelation = Object.ID WHERE (Type = CONST (Table));
        }
    }

    keys
    {
        key(Key1; "Web Service Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

