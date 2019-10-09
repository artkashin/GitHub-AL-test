table 37072314 "AJ Shipping Line"
{

    fields
    {
        field(1; "Shipping No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Source Type"; Option)
        {
            OptionMembers = " ",Document,Item,Comments;
        }
        field(4; "Source Document Type"; Option)
        {
            OptionMembers = Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(5; "Source ID"; Text[32])
        {
            TableRelation = if ("Source Table" = const("36")) "Sales Header" where("Document Type" = field("Source Document Type")) else
            if ("Source Table" = const("110")) "Sales Invoice Header" else
            if ("Source Table" = const("112")) "Sales Shipment Header";
        }
        field(6; "Source Table"; Option)
        {
            OptionCaption = ' ,Sales Header,Sales Invoice Header,Sales Shipment Header,Purchase Header,Transfer Header,Transfer Shipment Header';
            OptionMembers = " ","36","110","112","38","5740","5744";
        }
        field(7; Description; Text[250])
        {
        }

        field(8; Quantity; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Shipping No.", "Line No.")
        {
            Clustered = true;
        }
    }
}

