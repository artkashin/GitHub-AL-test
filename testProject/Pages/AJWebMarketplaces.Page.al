page 37072307 "AJ Web Marketplaces"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = "AJ Web Marketplace (Mailbox)";

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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Marketplace Option"; "Marketplace Option")
                {
                    ApplicationArea = All;
                }
                field("Item ID Type"; "Item ID Type")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Delete Line")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    MarketplaceL: Record "AJ Web Marketplace (Mailbox)";
                begin
                    if Confirm('Do you wont delete line?') then begin
                        MarketplaceL := Rec;
                        MarketplaceL.Delete();
                    end;
                end;
            }
        }
    }


}

