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
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Web Service Type"; "Web Service Type")
                {
                    ApplicationArea = All;
                }
                field("Web Service SubType"; "Web Service SubType")
                {
                    ApplicationArea = All;
                }
                field("# New Web Orders"; "# New Web Orders")
                {
                    ApplicationArea = All;
                }
                field("Allow to Delete WebOrder"; "Allow to Delete WebOrder")
                {
                    ApplicationArea = All;
                }
            }
            group(Connection)
            {
                field("API Endpoint Domain"; "API Endpoint Domain")
                {
                    ApplicationArea = All;
                }
                field("API User ID (Key)"; "API User ID (Key)")
                {
                    ApplicationArea = All;
                }
                field("API Password (Secret)"; "API Password (Secret)")
                {
                    ApplicationArea = All;
                }
                field("API Encoded String"; "API Encoded String")
                {
                    ApplicationArea = All;
                }
                field("API Sellier ID"; "API Sellier ID")
                {
                    ApplicationArea = All;
                }
                field("API Token"; "API Token")
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
                field("HMAC Key"; "HMAC Key")
                {
                    ApplicationArea = All;
                }
                field("Secure FTP"; "Secure FTP")
                {
                    ApplicationArea = All;
                }
                field("FTP Address"; "FTP Address")
                {
                    ApplicationArea = All;
                }
                field("FTP Port"; "FTP Port")
                {
                    ApplicationArea = All;
                }
            }
            group(Integration)
            {
                field("Shipping Service Code"; "Shipping Service Code")
                {
                    ApplicationArea = All;
                }
                field("Default MarketPlace id"; "Default MarketPlace id")
                {
                }
                field("Ship-From Warehouse ID"; "Ship-From Warehouse ID")
                {
                    ApplicationArea = All;
                }
            }
            group(Processing)
            {
                field("Shipping Service"; "Shipping Service")
                {
                    ApplicationArea = All;
                }
            }
            group("Custom Fields")
            {
                field("Reference 1"; "Reference 1")
                {
                    ApplicationArea = All;
                }
                field("Reference 2"; "Reference 2")
                {
                    ApplicationArea = All;
                }
                field("Reference 3"; "Reference 3")
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
            group("Get Setup")
            {
                action("Load Marketplaces")
                {
                    ApplicationArea = All;
                    Image = ImportDatabase;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                    begin
                        AJWebShipstationMgmt.ShipStation_GetMarketlaces(Rec);
                    end;
                }
                action("Load Carriers")
                {
                    ApplicationArea = All;
                    Image = ExportShipment;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                    begin
                        AJWebShipstationMgmt.GetShipAgentInfo(Rec);
                    end;
                }
            }
            group("Setup ")
            {
                action(Marketplaces)
                {
                    ApplicationArea = All;
                    Image = Relationship;
                    RunObject = Page "AJ Web Marketplaces";
                    RunPageLink = "Web Service Code" = FIELD (Code);
                }
                action(Carriers)
                {
                    ApplicationArea = All;
                    Image = Delivery;
                    RunObject = Page "AJ Web Carriers";
                    RunPageLink = "Web Service Code" = FIELD (Code);
                }
                action("Shipping Carriers")
                {
                    ApplicationArea = All;
                    Image = Delivery;
                    RunObject = Page "AJ Web Carriers";
                    RunPageLink = "Web Service Code" = FIELD ("Shipping Service Code");
                }
                action("Shipping Constants")
                {
                    ApplicationArea = All;
                    Image = VariableList;
                    RunObject = Page "AJ Web Service Constants";
                    RunPageLink = "Web Order Service Code" = FIELD ("Shipping Service Code");
                    RunPageView = SORTING ("Web Order Service Code", Type, "Option Value");
                }
                action("Copy-to Company")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
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
        AJWebService: Record "AJ Web Service";
}

