page 37072302 "AJ Web Services"
{
    CardPageID = "AJ Web Service Card";
    DeleteAllowed = false;
    LinksAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "AJ Web Service";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("# Error and New Web Orders"; "# Error and New Web Orders")
                {
                }
                field("# New Web Orders"; "# New Web Orders")
                {
                }
                field("# Error Web Orders"; "# Error Web Orders")
                {
                    BlankZero = true;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("# Pending Web Orders"; "# Pending Web Orders")
                {
                }
                field("# New Web Returns"; "# New Web Returns")
                {
                }
                field("# Error Web Returns"; "# Error Web Returns")
                {
                }
                field("# Shipped Web Orders"; "# Shipped Web Orders")
                {
                }
                field("# Completed Web Orders"; "# Completed Web Orders")
                {
                }
                field("# Open NAV Orders"; "# Open NAV Orders")
                {
                }
                field("Last 60 Days Orders"; "Last60dyyOrd Qnt")
                {
                }
                field("Last 30 Days Orders"; QtyOrders30Day)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Setup)
            {
                Image = Setup;
                group(Import)
                {
                    action("Create Wev Service & Get Label")
                    {
                        Image = ImportDatabase;
                        trigger OnAction()
                        var
                            AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            AJWebShipstationMgmt.Run();
                        end;
                    }

                    action("Import Marketplaces")
                    {
                        Image = ImportDatabase;
                        trigger OnAction()
                        var
                            AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            AJWebShipstationMgmt.ShipStation_GetMarketlaces(Rec);
                        end;
                    }
                    action("Import Warehouses")
                    {
                        Image = ImportDatabase;
                        trigger OnAction()
                        var
                            AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            AJWebShipstationMgmt.ShipStation_GetWarehouses(Rec);
                        end;
                    }
                    action("Import Carriers")
                    {
                        Image = ExportShipment;
                        trigger OnAction()
                        var
                            AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            AJWebShipstationMgmt.GetShipAgentInfo(Rec);
                        end;
                    }
                }
                group("Setup tables")
                {
                    action(Marketplaces)
                    {
                        Image = Relationship;

                        RunObject = Page "AJ Web Marketplaces";
                        RunPageLink = "Web Service Code" = FIELD (Code);
                    }
                    action(Warehouses)
                    {
                        RunObject = Page "AJ Web Service Warehouse Setup";
                        RunPageLink = "Web Service Code" = FIELD (Code);
                    }
                    action("Shipping Carriers")
                    {
                        Image = Delivery;

                        RunObject = Page "AJ Web Carriers";
                        RunPageLink = "Web Service Code" = FIELD ("Shipping Service Code");
                    }
                    action("Carrier services")
                    {
                        RunObject = Page "AJ Web Carrier Services";
                        RunPageLink = "Web Service Code" = FIELD (Code);
                    }
                    action("Shipping Constants")
                    {
                        Image = VariableList;

                        RunObject = Page "AJ Web Service Constants";
                        RunPageLink = "Web Order Service Code" = FIELD ("Shipping Service Code");
                        RunPageView = SORTING ("Web Order Service Code", Type, "Option Value");
                    }
                    group("Service functions")
                    {
                        action("Delete Curr Record")
                        {

                            trigger OnAction()
                            var
                                WebService: Record "AJ Web Service";
                            begin
                                if Confirm('Do you want delete current record?') then begin
                                    WebService := Rec;
                                    WebService.Delete;
                                end;
                            end;
                        }
                    }
                }
                group("Web Operations")
                {
                    action("Check Connection")
                    {
                        Visible = false;

                        trigger OnAction()
                        var
                        // AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            //AJWebShipstationMgmt.WOS_CheckConnection(Rec);
                        end;
                    }
                    action("Get Orders")
                    {
                        Image = Import;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;

                        trigger OnAction()
                        var
                            AJWebService: Record "AJ Web Service";
                            //AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            // IF NOT CONFIRM('Get Web Orders?') THEN
                            //  ERROR('Cancelled');
                            //
                            // CurrPage.SETSELECTIONFILTER(AJWebService);
                            // IF AJWebService.FINDFIRST THEN REPEAT
                            //  CLEAR(AJWebShipstationMgmt);
                            //  AJWebShipstationMgmt.WOS_GetOrders(AJWebService);
                            //  COMMIT;
                            // UNTIL AJWebService.NEXT = 0;
                            //
                            // MESSAGE('Done');
                        end;
                    }
                    action("Web Orders")
                    {
                        RunObject = Page "AJ Web Order List";
                        RunPageLink = "Web Service Code" = FIELD (Code),
                                  "Document Type" = CONST (Order);

                        trigger OnAction()
                        var
                        //AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                        end;
                    }
                    action("Web Returns")
                    {
                        RunObject = Page "AJ Web Return List";
                        RunPageLink = "Web Service Code" = FIELD (Code),
                                  "Document Type" = CONST (Return);
                    }
                }
                group("NAV Operations")
                {
                    action("Create Orders")
                    {
                        Image = CreateDocument;
                        Promoted = true;
                        PromotedIsBig = true;

                        trigger OnAction()
                        var
                            //AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                            AJWebOrderHeader: Record "AJ Web Order Header";
                        begin
                            // AJWebOrderHeader.SETRANGE("Web Service Code",Code);
                            // AJWebShipstationMgmt.WOS_CreateOrders(AJWebOrderHeader);
                        end;
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        dt: Date;
        tm: Time;
        ShipMgt: Codeunit "AJ Web Shipstation Mgmt.";
    begin
        dt := Today;
        dt30 := CalcDate('-30D', dt);
        dt60 := CalcDate('-60D', dt);
        tm := 000000T;
        dtm60 := CreateDateTime(dt60, tm);
        ShipMgt.Run();
    end;

    var
        QtyOrders30Day: Integer;
        dt30: Date;
        dt60: Date;
        dtm60: DateTime;

    local procedure "Last60dyyOrd Qnt"() QtyOrders60Day: Integer
    var
        WebOrderHeader: Record "AJ Web Order Header";
        SalInvHead: Record "Sales Invoice Header";
    begin
        QtyOrders30Day := 0;
        WebOrderHeader.SetRange(WebOrderHeader."Web Service Code", Code);
        WebOrderHeader.SetRange(WebOrderHeader."NAV Order Status", WebOrderHeader."NAV Order Status"::Shipped);
        WebOrderHeader.SetFilter(WebOrderHeader."Order DateTime", '>=%1', dtm60);
        if WebOrderHeader.FindSet then
            repeat
                if SalInvHead.Get(WebOrderHeader."Invoice No.") then
                    if SalInvHead."Posting Date" >= dt60 then begin
                        QtyOrders60Day += 1;
                        if SalInvHead."Posting Date" >= dt30 then
                            QtyOrders30Day += 1;
                    end;
            until WebOrderHeader.Next = 0;
    end;
}

