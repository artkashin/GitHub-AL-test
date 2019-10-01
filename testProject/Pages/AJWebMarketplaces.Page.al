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
                }
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Marketplace Option"; "Marketplace Option")
                {
                }
                field("Item ID Type"; "Item ID Type")
                {
                }
                field("Table ID"; "Table ID")
                {
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

    var
    //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
}

