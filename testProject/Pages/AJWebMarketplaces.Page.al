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
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Upload Inventory")
            {

                trigger OnAction()
                var
                    UploadToFTP: Boolean;
                    Wnd: Dialog;
                begin
                    //
                    // UploadToFTP := CONFIRM('Upload files to ftp? Otherwise files will be created in local directory.');
                    //
                    // Wnd.OPEN('Creating Inventory status');
                    //
                    // AJWebOrderServiceMgmt.CommerceHUB_CreateInventoryStatus(Rec, UploadToFTP);
                    //
                    // Wnd.CLOSE;
                    //
                    // MESSAGE('Done');
                end;
            }
            action("Delete Line")
            {

                trigger OnAction()
                var
                    MarketplaceL: Record "AJ Web Marketplace (Mailbox)";
                begin
                    if Confirm('Do you wont delete line?') then begin
                        MarketplaceL := Rec;
                        MarketplaceL.Delete;
                    end;
                end;
            }
        }
    }


}

