table 37074950 "AJ Web Service Warehouse"
{

    fields
    {
        field(1;"Web Service Code";Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(2;"Warehouse ID";Code[20])
        {
        }
        field(3;Description;Text[100])
        {
        }
        field(10;"Created At";DateTime)
        {
        }
        field(11;Default;Boolean)
        {
        }
        field(20;"Def. Shipping Web Service Code";Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(21;"Def. Shipping Carrier Code";Text[50])
        {
            TableRelation = "AJ Web Carrier".Code WHERE ("Web Service Code"=FIELD("Def. Shipping Web Service Code"));
        }
        field(22;"Def. Shipping Package Type";Text[50])
        {
            TableRelation = "AJ Web Carrier Package Type"."Package Code" WHERE ("Web Service Code"=FIELD("Def. Shipping Web Service Code"),
                                                                                "Web Carrier Code"=FIELD("Def. Shipping Carrier Code"));

            trigger OnLookup()
            begin
                GetPackageCodeAndPackageName;
            end;
        }
        field(23;"Def. Shipping Delivery Confirm";Text[50])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Def. Shipping Web Service Code"),
                                                                             Type=CONST(Confirmation));
        }
        field(24;"Def. Shipping Insutance Provd";Text[50])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE ("Web Order Service Code"=FIELD("Def. Shipping Web Service Code"),
                                                                             Type=CONST(Insurance));
        }
        field(25;"Def. Shipping Carrier Service";Text[50])
        {
            TableRelation = "AJ Web Carrier Service"."Service  Code" WHERE ("Web Service Code"=FIELD("Def. Shipping Web Service Code"),
                                                                            "Web Carrier Code"=FIELD("Def. Shipping Carrier Code"));
        }
        field(26;"Def. Insure Shipment";Boolean)
        {
        }
        field(27;"Def. Insurance Value";Option)
        {
            OptionMembers = Manual,Cost,Price;
        }
        field(28;"Def. Product Weight Unit";Text[30])
        {
            TableRelation = "AJ Web Service Constants"."Option Value" WHERE (Type=CONST(Weight),
                                                                             "Web Order Service Code"=FIELD("Def. Shipping Web Service Code"));
        }
        field(60;"Ship-From Name";Text[100])
        {
        }
        field(61;"Ship-From Company";Text[100])
        {
        }
        field(62;"Ship-From Address 1";Text[100])
        {
        }
        field(63;"Ship-From Address 2";Text[100])
        {
        }
        field(64;"Ship-From Address 3";Text[100])
        {
        }
        field(65;"Ship-From City";Text[50])
        {
        }
        field(66;"Ship-From State";Text[30])
        {
        }
        field(67;"Ship-From Zip";Text[10])
        {
        }
        field(68;"Ship-From Country";Text[30])
        {
        }
        field(69;"Ship-From Phone";Text[30])
        {
        }
        field(70;"Ship-From Residential";Boolean)
        {
        }
        field(71;"Ship-From Address Verified";Text[100])
        {
        }
        field(80;"Return Name";Text[100])
        {
        }
        field(81;"Return Company";Text[100])
        {
        }
        field(82;"Return Address 1";Text[100])
        {
        }
        field(83;"Return Address 2";Text[100])
        {
        }
        field(84;"Return Address 3";Text[100])
        {
        }
        field(85;"Return City";Text[50])
        {
        }
        field(86;"Return State";Text[30])
        {
        }
        field(87;"Return Zip";Text[10])
        {
        }
        field(88;"Return Country";Text[30])
        {
        }
        field(89;"Return Phone";Text[30])
        {
        }
        field(90;"Return Residential";Boolean)
        {
        }
        field(91;"Return Address Verified";Text[100])
        {
        }
        field(92;"Free Shipping";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(100;"AJ Store No.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Table37076004;
        }
        field(2000;"Location Code Filter";Code[200])
        {
            TableRelation = Location;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1;"Web Service Code","Warehouse ID")
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
        TestField("Web Service Code");
        TestField("Def. Shipping Carrier Code");
        AJWebCarrierPackage.SetRange("Web Service Code", "Web Service Code");
        AJWebCarrierPackage.SetRange("Web Carrier Code", "Def. Shipping Carrier Code");
        if PAGE.RunModal(0, AJWebCarrierPackage) = ACTION::LookupOK then begin
          "Def. Shipping Package Type" := AJWebCarrierPackage."Package Code";
        end;
    end;
}

