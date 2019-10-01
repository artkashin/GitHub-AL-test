tableextension 37072304 TableExtansion291 extends "Shipping Agent"
{
    fields
    {
        field(37075200; "Shipping Web Service Code"; Code[10])
        {
            TableRelation = "AJ Web Service";
        }
        field(37075201; "Shipping Carrier Code"; text[50])
        {
            TableRelation = "AJ Web Carrier".Code WHERE("Web Service Code" = FIELD("Shipping Web Service Code"));
        }
    }

}