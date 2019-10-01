page 37072305 "AJ Web Carrier Services"
{
    PageType = List;
    SourceTable = "AJ Web Carrier Service";

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
                field("Web Carrier Code"; "Web Carrier Code")
                {
                    ApplicationArea = All;
                }
                field("Service  Code"; "Service  Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Shipping Service Code"; "Shipping Service Code")
                {
                    ApplicationArea = All;
                }
                field("Default Package Code"; "Default Package Code")
                {
                    ApplicationArea = All;
                }
                field("Default Package Name"; "Default Package Name")
                {
                    ApplicationArea = All;
                }
                field(Domestic; Domestic)
                {
                    ApplicationArea = All;
                }
                field(International; International)
                {
                    ApplicationArea = All;
                }
                field("Cross Reference Code"; "Cross Reference Code")
                {
                    ApplicationArea = All;
                }
                field("Cross Reference Code 2"; "Cross Reference Code 2")
                {
                    ApplicationArea = All;
                }
                field("Additional Charge %"; "Additional Charge %")
                {
                    ApplicationArea = All;
                }
                field("Additional Charge $"; "Additional Charge $")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
                field("Max Insurance Limit"; "Max Insurance Limit")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent Service Code"; "Shipping Agent Service Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Setup ")
            {
            }
        }
    }
}

