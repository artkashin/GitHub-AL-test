page 37072317 "AJ Web Service Warehouse Setup"
{
    CardPageID = "AJ Web Service Warehouse Card";
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
                    ApplicationArea = All;
                }
                field("Warehouse ID"; "Warehouse ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Default; Default)
                {
                    ApplicationArea = All;
                }
                field("Created At"; "Created At")
                {
                    ApplicationArea = All;
                }
                field("Def. Shipping Carrier Code"; "Def. Shipping Carrier Code")
                {
                    ApplicationArea = All;
                }
                field("Def. Shipping Carrier Service"; "Def. Shipping Carrier Service")
                {
                    ApplicationArea = All;
                }
                field("Def. Shipping Package Type"; "Def. Shipping Package Type")
                {
                    ApplicationArea = All;
                }
                field("Def. Shipping Delivery Confirm"; "Def. Shipping Delivery Confirm")
                {
                    ApplicationArea = All;
                }
                field("Def. Shipping Insutance Provd"; "Def. Shipping Insutance Provd")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Def. Insure Shipment"; "Def. Insure Shipment")
                {
                    ApplicationArea = All;
                }
                field("Def. Insurance Value"; "Def. Insurance Value")
                {
                    ApplicationArea = All;
                }
                field("Def. Product Weight Unit"; "Def. Product Weight Unit")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

