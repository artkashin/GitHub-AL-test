tableextension 37072302 TableExtansion112 extends "Sales Invoice Header"
{
    fields
    {
        field(37075111; "Web Order No."; Code[20])
        {
            TableRelation = "AJ Web Order Header";
        }
    }

    var
        myInt: Integer;
}