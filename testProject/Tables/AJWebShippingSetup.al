table 37072315 "AJ Shipping Setup"
{

    fields
    {
        field(1; ID; Code[10])
        {
        }
        field(2; "Shipping No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "B2C Shipping"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }
}

