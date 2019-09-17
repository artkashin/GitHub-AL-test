table 37074945 "AJ Web Setup"
{

    fields
    {
        field(1;ID;Code[10])
        {
        }
        field(3;"Web Order No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4;"Web Package No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10;"Tax G/L Account No.";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50;Version;Option)
        {
            OptionMembers = " ","1";
        }
        field(60;"On Vacation Until";Date)
        {
            Description = 'to send zero inventory';
        }
        field(61;"Last Item Entry No.";Integer)
        {
            Description = 'Used for export incremental inventory';
        }
    }

    keys
    {
        key(Key1;ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

