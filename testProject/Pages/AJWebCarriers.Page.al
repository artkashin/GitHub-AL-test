page 37072304 "AJ Web Carriers"
{
    PageType = List;
    SourceTable = "AJ Web Carrier";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Service Code"; "Web Service Code")
                {
                }
                field("Code"; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Requires Funded Account"; "Requires Funded Account")
                {
                }
                field(Balance; Balance)
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Def. Shipping Carrier Service"; "Def. Shipping Carrier Service")
                {
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                }
                field("Shipping Agent  Code"; "Shipping Agent  Code")
                {
                }
                field("Bill-to Type"; "Bill-to Type")
                {
                }
                field("Bill-to Account No."; "Bill-to Account No.")
                {
                }
                field("Bill-to Account Post Code"; "Bill-to Account Post Code")
                {
                }
                field("Bill-to Account Country Code"; "Bill-to Account Country Code")
                {
                }
                field("2 Lines Address only"; "2 Lines Address only")
                {
                }
                field("Def. Shipping Package Type"; "Def. Shipping Package Type")
                {
                }
                field("Def. Shipping Delivery Confirm"; "Def. Shipping Delivery Confirm")
                {
                }
                field("Def. Shipping Option"; "Def. Shipping Option")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Pakage Types")
            {
                Image = InventorySetup;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "AJ Web Carier Package Types";
                RunPageLink = "Web Service Code" = FIELD ("Web Service Code"),
                              "Web Carrier Code" = FIELD (Code);
            }
            action(Services)
            {
                Image = ShipmentLines;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Page "AJ Web Carrier Services";
                RunPageLink = "Web Service Code" = FIELD ("Web Service Code"),
                              "Web Carrier Code" = FIELD (Code);
            }
        }
    }
}

