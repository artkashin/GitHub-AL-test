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
                    ApplicationArea = All;
                }
                field("Code"; Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Requires Funded Account"; "Requires Funded Account")
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
                field("Def. Shipping Carrier Service"; "Def. Shipping Carrier Service")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Agent  Code"; "Shipping Agent  Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Type"; "Bill-to Type")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Account No."; "Bill-to Account No.")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Account Post Code"; "Bill-to Account Post Code")
                {
                    ApplicationArea = All;
                }
                field("Bill-to Account Country Code"; "Bill-to Account Country Code")
                {
                    ApplicationArea = All;
                }
                field("2 Lines Address only"; "2 Lines Address only")
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
                field("Def. Shipping Option"; "Def. Shipping Option")
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
            action("Pakage Types")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
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

