table 37074946 "AJ Web Carrier"
{

    fields
    {
        field(1;"Web Service Code";Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(2;"Code";Text[50])
        {
        }
        field(3;Name;Text[100])
        {
        }
        field(4;"Account No.";Text[50])
        {
        }
        field(5;"Requires Funded Account";Boolean)
        {
        }
        field(6;Balance;Decimal)
        {
        }
        field(10;Blocked;Boolean)
        {
        }
        field(22;"Def. Shipping Package Type";Text[50])
        {
            TableRelation = "AJ Web Carrier Package Type"."Package Code" WHERE ("Web Service Code"=FIELD("Web Service Code"),
                                                                                "Web Carrier Code"=FIELD(Code));
        }
        field(23;"Def. Shipping Delivery Confirm";Text[50])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Web Service Code"),
                                                                             Type=CONST(Confirmation));
        }
        field(24;"Def. Shipping Insutance Provd";Text[50])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Web Service Code"),
                                                                             Type=CONST(Insurance));
        }
        field(25;"Def. Shipping Carrier Service";Text[50])
        {
            TableRelation = "AJ Web Carrier Service"."Service  Code" WHERE ("Web Service Code"=FIELD("Web Service Code"),
                                                                            "Web Carrier Code"=FIELD(Code));
        }
        field(26;"Shipment Method Code";Code[10])
        {
            TableRelation = "Shipment Method";
        }
        field(27;"Shipping Agent  Code";Code[10])
        {
            TableRelation = "Shipping Agent";
        }
        field(28;"Def. Insure Shipment";Boolean)
        {
        }
        field(405;"Bill-to Type";Option)
        {
            OptionCaption = 'My Account,Recipient,Third Party,My Other Account';
            OptionMembers = my_account,recipient,third_party,my_other_account;
        }
        field(406;"Bill-to Account No.";Code[20])
        {
        }
        field(407;"Bill-to Account Post Code";Code[20])
        {
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(408;"Bill-to Account Country Code";Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(409;"Fixed Carrier and Carrier Serv";Boolean)
        {
        }
        field(410;"2 Lines Address only";Boolean)
        {
        }
        field(501;"Def. Shipping Option";Text[50])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Web Service Code"),
                                                                             Type=CONST(Option));
        }
        field(37075200;"Shipping Label to A5 format";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(37075202;"Allow COD";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Web Service Code","Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

