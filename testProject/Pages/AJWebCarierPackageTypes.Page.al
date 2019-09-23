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
                }
                field("Web Carrier Code"; "Web Carrier Code")
                {
                }
                field("Package Code"; "Package Code")
                {
                }
                field("Package Name"; "Package Name")
                {
                }
                field(Domestic; Domestic)
                {
                }
                field(International; International)
                {
                }
                field("Shipping Service Code"; "Shipping Service Code")
                {
                }
                field("Def. Weight Unit"; "Def. Weight Unit")
                {
                }
                field("Def. Weight"; "Def. Weight")
                {
                }
                field("Def. Dimension Unit"; "Def. Dimension Unit")
                {
                }
                field("Def. Width"; "Def. Width")
                {
                }
                field("Def. Length"; "Def. Length")
                {
                }
                field("Def. Height"; "Def. Height")
                {
                }
                field("Shipping Delivery Confirm"; "Shipping Delivery Confirm")
                {
                }
                field("Def. Insure Shipment"; "Def. Insure Shipment")
                {
                }
                field("Def. Insured Value"; "Def. Insured Value")
                {
                }
                field("Def.Additional Insurance Value"; "Def.Additional Insurance Value")
                {
                }
                field(Blocked; Blocked)
                {
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

