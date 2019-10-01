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
                field("Last 60 Days Orders"; "Last60dyyOrd Qnt"())
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
                    action("Import Marketplaces")
                    {
                        Image = ImportDatabase;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;

                        trigger OnAction()
                        var
                        // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                        begin
                            //AJWebOrderServiceMgmt.WOS_GetMarketlaces(Rec);
                        end;
                    }
                    action("Import Warehouses")
                    {
                        Image = ImportDatabase;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;

                        trigger OnAction()
                        var
                        //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                        begin
                            //AJWebOrderServiceMgmt.WOS_GetWarehouses(Rec);
                        end;
                    }
                    action("Import Carriers")
                    {
                        Image = ExportShipment;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;

                        trigger OnAction()
                        var
                        //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                        begin
                            //AJWebOrderServiceMgmt.WOS_GetShipAgentInfo(Rec);
                        end;
                    }
                }
                group("Setup tables")
                {
                    action(Marketplaces)
                    {
                        Image = Relationship;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category4;
                        RunObject = Page "AJ Web Marketplaces";
                        RunPageLink = "Web Service Code" = FIELD(Code);
                    }
                    action(Warehouses)
                    {
                        RunObject = Page "AJ Web Service Warehouse Setup";
                        RunPageLink = "Web Service Code" = FIELD(Code);
                    }
                    action("Shipping Carriers")
                    {
                        Image = Delivery;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category4;
                        RunObject = Page "AJ Web Carriers";
                        RunPageLink = "Web Service Code" = FIELD("Shipping Service Code");
                    }
                    action("Carrier services")
                    {
                        RunObject = Page "AJ Web Carrier Services";
                        RunPageLink = "Web Service Code" = FIELD(Code);
                    }
                    action("Shipping Constants")
                    {
                        Image = VariableList;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category4;
                        RunObject = Page "AJ Web Service Constants";
                        RunPageLink = "Web Order Service Code" = FIELD("Shipping Service Code");
                        RunPageView = SORTING("Web Order Service Code", Type, "Option Value");
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
                                    WebService.Delete();
                                end;
                            end;
                        }
                    }
                }
                group("Web Operations")
                {
<<<<<<< HEAD
=======
                    action("Check Connection")
                    {
                        Visible = false;

                        trigger OnAction()
                        var
                        // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                        begin
                            //AJWebOrderServiceMgmt.WOS_CheckConnection(Rec);
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
                            //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                        begin
                            // IF NOT CONFIRM('Get Web Orders?') THEN
                            //  ERROR('Cancelled');
                            //
                            // CurrPage.SETSELECTIONFILTER(AJWebService);
                            // IF AJWebService.FINDFIRST THEN REPEAT
                            //  CLEAR(AJWebOrderServiceMgmt);
                            //  AJWebOrderServiceMgmt.WOS_GetOrders(AJWebService);
                            //  COMMIT;
                            // UNTIL AJWebService.NEXT = 0;
                            //
                            // MESSAGE('Done');
                        end;
                    }
>>>>>>> parent of 7df33c2... Merge branch 'master' of https://github.com/artkashin/GitHub
                    action("Web Orders")
                    {
                        RunObject = Page "AJ Web Order List";
                        RunPageLink = "Web Service Code" = FIELD(Code),
                                  "Document Type" = CONST(Order);

                        trigger OnAction()
                        var
                        //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                        begin
                        end;
                    }
                    action("Web Returns")
                    {
                        RunObject = Page "AJ Web Return List";
<<<<<<< HEAD
                        RunPageLink = "Web Service Code" = FIELD(Code),
                                  "Document Type" = CONST(Return);
=======
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
                            //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                            AJWebOrderHeader: Record "AJ Web Order Header";
                        begin
                            // AJWebOrderHeader.SETRANGE("Web Service Code",Code);
                            // AJWebOrderServiceMgmt.WOS_CreateOrders(AJWebOrderHeader);
                        end;
>>>>>>> parent of 7df33c2... Merge branch 'master' of https://github.com/artkashin/GitHub
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        dt: Date;
        tm: Time;
    begin
        dt := Today();
        dt30 := CalcDate('<-30D>', dt);
        dt60 := CalcDate('<-60D>', dt);
        tm := 000000T;
        dtm60 := CreateDateTime(dt60, tm);
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
        if WebOrderHeader.FindSet() then
            repeat
                if SalInvHead.Get(WebOrderHeader."Invoice No.") then
                    if SalInvHead."Posting Date" >= dt60 then begin
                        QtyOrders60Day += 1;
                        if SalInvHead."Posting Date" >= dt30 then
                            QtyOrders30Day += 1;
                    end;
            until WebOrderHeader.Next() = 0;
    end;
}

