tableextension 50101 TableExtansion36 extends "Sales Header"
{
    fields
    {
        field(37075111; "Web Order No."; Code[20])
        {
            TableRelation = "AJ Web Order Header";
        }
        field(37075112; "Web Service Code"; Code[10])
        {

        }
    }
}