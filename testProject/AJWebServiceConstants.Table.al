table 37074949 "AJ Web Service Constants"
{
    LookupPageID = "AJ Web Service Constants";

    fields
    {
        field(1;"Web Order Service Code";Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(2;Type;Option)
        {
            OptionMembers = " ",Confirmation,Weight,Dimension,Insurance,Option;
        }
        field(3;"Option Value";Text[30])
        {
        }
        field(4;Description;Text[100])
        {
        }
        field(10;Blocked;Boolean)
        {
        }
        field(11;"Second Value";Text[30])
        {
        }
        field(15;"For Web Carrier Codes";Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Web Order Service Code",Type,"Option Value")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

