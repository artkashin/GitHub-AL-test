table 37074948 "AJ Web Carrier Package Type"
{
    DrillDownPageID = "AJ Web Carier Package Types";
    LookupPageID = "AJ Web Carier Package Types";

    fields
    {
        field(1;"Web Service Code";Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(2;"Web Carrier Code";Text[50])
        {
        }
        field(3;"Package Code";Text[50])
        {
        }
        field(4;"Package Name";Text[50])
        {
        }
        field(5;Domestic;Boolean)
        {
        }
        field(6;International;Boolean)
        {
        }
        field(7;"Def. Weight Unit";Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Shipping Service Code"),
                                                                             Type=CONST(Weight));
        }
        field(8;"Def. Weight";Decimal)
        {
        }
        field(10;"Def. Dimension Unit";Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Shipping Service Code"),
                                                                             Type=CONST(Dimension));
        }
        field(11;"Def. Width";Decimal)
        {
        }
        field(12;"Def. Length";Decimal)
        {
        }
        field(13;"Def. Height";Decimal)
        {
        }
        field(14;Blocked;Boolean)
        {
        }
        field(413;"Shipping Delivery Confirm";Text[30])
        {
            Description = 'ShipStation: no confirmation,delivery,signature,adult signature';
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Shipping Service Code"),
                                                                             Type=CONST(Confirmation),
                                                                             Blocked=CONST(false));
        }
        field(416;"Def. Insure Shipment";Boolean)
        {
        }
        field(417;"Def. Insured Value";Decimal)
        {
        }
        field(418;"Def.Additional Insurance Value";Decimal)
        {
        }
        field(419;"Shipping Service Code";Code[20])
        {
            CalcFormula = Lookup("AJ Web Service"."Shipping Service Code" WHERE (Code=FIELD("Web Service Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Web Service Code","Web Carrier Code","Package Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

