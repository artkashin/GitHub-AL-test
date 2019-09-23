page 37072303 "AJ Web Service Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "AJ Web Service";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Web Service Type"; "Web Service Type")
                {
                }
                field("Web Service SubType"; "Web Service SubType")
                {
                }
                field("# New Web Orders"; "# New Web Orders")
                {
                }
                field("Allow to Delete WebOrder"; "Allow to Delete WebOrder")
                {
                }
            }
            group(Connection)
            {
                field("API Endpoint Domain"; "API Endpoint Domain")
                {
                }
                field("API User ID (Key)"; "API User ID (Key)")
                {
                }
                field("API Password (Secret)"; "API Password (Secret)")
                {
                }
                field("API Encoded String"; "API Encoded String")
                {
                }
                field("API Sellier ID"; "API Sellier ID")
                {
                }
                field("API Token"; "API Token")
                {
                    ExtendedDatatype = Masked;
                }
                field("HMAC Key"; "HMAC Key")
                {
                }
                field("Secure FTP"; "Secure FTP")
                {
                }
                field("FTP Address"; "FTP Address")
                {
                }
                field("FTP Port"; "FTP Port")
                {
                }
            }
            group(Integration)
            {
                field("Shipping Service Code"; "Shipping Service Code")
                {
                }
                field("Default MarketPlace id"; "Default MarketPlace id")
                {
                }
                field("Ship-From Warehouse ID"; "Ship-From Warehouse ID")
                {
                }
            }
            group(Processing)
            {
                field("Shipping Service"; "Shipping Service")
                {
                }
            }
            group("Custom Fields")
            {
                field("Reference 1"; "Reference 1")
                {
                }
                field("Reference 2"; "Reference 2")
                {
                }
                field("Reference 3"; "Reference 3")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Get Setup")
            {
                action("Load Marketplaces")
                {
                    Image = ImportDatabase;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                    //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                    begin
                        //AJWebOrderServiceMgmt.WOS_GetMarketlaces(Rec);
                    end;
                }
                action("Load Carriers")
                {
                    Image = ExportShipment;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                    // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                    begin
                        //AJWebOrderServiceMgmt.WOS_GetShipAgentInfo(Rec);
                    end;
                }
            }
            group("Setup ")
            {
                action(Marketplaces)
                {
                    Image = Relationship;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    RunObject = Page "AJ Web Marketplaces";
                    RunPageLink = "Web Service Code" = FIELD (Code);
                }
                action(Carriers)
                {
                    Image = Delivery;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    RunObject = Page "AJ Web Carriers";
                    RunPageLink = "Web Service Code" = FIELD (Code);
                }
                action("Shipping Carriers")
                {
                    Image = Delivery;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    RunObject = Page "AJ Web Carriers";
                    RunPageLink = "Web Service Code" = FIELD ("Shipping Service Code");
                }
                action("Shipping Constants")
                {
                    Image = VariableList;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    RunObject = Page "AJ Web Service Constants";
                    RunPageLink = "Web Order Service Code" = FIELD ("Shipping Service Code");
                    RunPageView = SORTING ("Web Order Service Code", Type, "Option Value");
                }
                action("Copy-to Company")
                {
                    Caption = 'Copy-to Company';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        Company: Record Company;
                        AJWebService: Record "AJ Web Service";
                        AJWebService2: Record "AJ Web Service";
                        AJWebMarketplaceMailbox: Record "AJ Web Marketplace (Mailbox)";
                        AJWebMarketplaceMailbox2: Record "AJ Web Marketplace (Mailbox)";
                        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                        AJWebServiceWarehouse2: Record "AJ Web Service Warehouse";
                        AJWebCarrier: Record "AJ Web Carrier";
                        AJWebCarrier2: Record "AJ Web Carrier";
                    begin
                        Company.SetFilter(Name, '<>%1', CompanyName);
                        if PAGE.RunModal(357, Company) <> ACTION::LookupOK then
                            Company.Name := '';

                        if Company.Name <> '' then
                            if not Confirm('Confirm to copy to %1', true, Company.Name) then
                                Error('Cancelled');

                        AJWebService2.ChangeCompany(Company.Name);
                        AJWebMarketplaceMailbox2.ChangeCompany(Company.Name);
                        AJWebServiceWarehouse2.ChangeCompany(Company.Name);
                        AJWebCarrier2.ChangeCompany(Company.Name);

                        AJWebService2 := Rec;
                        AJWebService2.Insert;

                        AJWebMarketplaceMailbox.SetRange("Web Service Code", Rec.Code);
                        if AJWebMarketplaceMailbox.FindFirst then
                            repeat
                                AJWebMarketplaceMailbox2 := AJWebMarketplaceMailbox;
                                AJWebMarketplaceMailbox2.Insert;
                            until AJWebMarketplaceMailbox.Next = 0;

                        AJWebServiceWarehouse.SetRange("Web Service Code", Rec.Code);
                        if AJWebServiceWarehouse.FindFirst then
                            repeat
                                AJWebServiceWarehouse2 := AJWebServiceWarehouse;
                                AJWebServiceWarehouse2.Insert;
                            until AJWebServiceWarehouse.Next = 0;

                        AJWebCarrier.SetRange("Web Service Code", Rec.Code);
                        if AJWebCarrier.FindFirst then
                            repeat
                                AJWebCarrier2 := AJWebCarrier;
                                AJWebCarrier2.Insert;
                            until AJWebCarrier.Next = 0;

                        Message('Done');
                    end;
                }
                action("Delete Record")
                {
                    Caption = 'Delete Record';

                    trigger OnAction()
                    var
                        WebService: Record "AJ Web Service";
                    begin
                        if Confirm('Do you want to delete current record?') then begin
                            WebService := Rec;
                            WebService.Delete;
                        end;
                    end;
                }
            }
        }
    }

    var
        // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
        AJWebService: Record "AJ Web Service";
}

