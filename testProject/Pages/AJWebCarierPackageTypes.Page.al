page 37072306 "AJ Web Carier Package Types"
{
    PageType = List;
    SourceTable = "AJ Web Carrier Package Type";

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
                field("Package Code"; "Package Code")
                {
                    ApplicationArea = All;
                }
                field("Package Name"; "Package Name")
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
                field("Shipping Service Code"; "Shipping Service Code")
                {
                    ApplicationArea = All;
                }
                field("Def. Weight Unit"; "Def. Weight Unit")
                {
                    ApplicationArea = All;
                }
                field("Def. Weight"; "Def. Weight")
                {
                    ApplicationArea = All;
                }
                field("Def. Dimension Unit"; "Def. Dimension Unit")
                {
                    ApplicationArea = All;
                }
                field("Def. Width"; "Def. Width")
                {
                    ApplicationArea = All;
                }
                field("Def. Length"; "Def. Length")
                {
                    ApplicationArea = All;
                }
                field("Def. Height"; "Def. Height")
                {
                    ApplicationArea = All;
                }
                field("Shipping Delivery Confirm"; "Shipping Delivery Confirm")
                {
                    ApplicationArea = All;
                }
                field("Def. Insure Shipment"; "Def. Insure Shipment")
                {
                    ApplicationArea = All;
                }
                field("Def. Insured Value"; "Def. Insured Value")
                {
                    ApplicationArea = All;
                }
                field("Def.Additional Insurance Value"; "Def.Additional Insurance Value")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Package Types")
            {
                ApplicationArea = All;
                Image = InventorySetup;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "AJ Web Carier Package Types";
                RunPageLink = "Web Service Code" = FIELD ("Web Service Code"),
                              "Web Carrier Code" = FIELD ("Web Carrier Code");
            }
            action(Services)
            {
                ApplicationArea = All;
                Image = ShipmentLines;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "AJ Web Carrier Services";
                RunPageLink = "Web Service Code" = FIELD ("Web Service Code"),
                              "Web Carrier Code" = FIELD ("Web Carrier Code");
            }
        }
    }
}

