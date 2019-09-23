page 37072315 "AJ Web Service Warehouses"
{
    CardPageID = "AJ Web Service Warehouse Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "AJ Web Service Warehouse";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Service Code"; "Web Service Code")
                {
                }
                field("Warehouse ID"; "Warehouse ID")
                {
                }
                field(Description; Description)
                {
                }
                field(Default; Default)
                {
                }
                field("Created At"; "Created At")
                {
                }
                field("Def. Shipping Carrier Code"; "Def. Shipping Carrier Code")
                {
                }
                field("Def. Shipping Carrier Service"; "Def. Shipping Carrier Service")
                {
                }
                field("Def. Shipping Package Type"; "Def. Shipping Package Type")
                {
                }
                field("Def. Shipping Delivery Confirm"; "Def. Shipping Delivery Confirm")
                {
                }
                field("Def. Shipping Insutance Provd"; "Def. Shipping Insutance Provd")
                {
                    Visible = false;
                }
                field("Def. Insure Shipment"; "Def. Insure Shipment")
                {
                }
                field("Def. Insurance Value"; "Def. Insurance Value")
                {
                }
                field("Def. Product Weight Unit"; "Def. Product Weight Unit")
                {
                }
                field("Free Shipping"; "Free Shipping")
                {
                }
            }
        }
    }

    actions
    {
    }
}

