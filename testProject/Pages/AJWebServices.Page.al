page 37072302 "AJ Web Services"
{
    CardPageID = "AJ Web Service Card";
    DeleteAllowed = false;
    LinksAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = "AJ Web Service";
    UsageCategory = Lists;
    Caption = 'Aj Web Services';
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("# Error and New Web Orders"; "# Error and New Web Orders")
                {
                    ApplicationArea = All;
                }
                field("# New Web Orders"; "# New Web Orders")
                {
                    ApplicationArea = All;
                }
                field("# Error Web Orders"; "# Error Web Orders")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("# Pending Web Orders"; "# Pending Web Orders")
                {
                    ApplicationArea = All;
                }
                field("# New Web Returns"; "# New Web Returns")
                {
                    ApplicationArea = All;
                }
                field("# Error Web Returns"; "# Error Web Returns")
                {
                    ApplicationArea = All;
                }
                field("# Shipped Web Orders"; "# Shipped Web Orders")
                {
                    ApplicationArea = All;
                }
                field("# Completed Web Orders"; "# Completed Web Orders")
                {
                    ApplicationArea = All;
                }
                field("# Open NAV Orders"; "# Open NAV Orders")
                {
                    ApplicationArea = All;
                }
                field("Last 60 Days Orders"; "Last60dyyOrd Qnt"())
                {
                    ApplicationArea = All;
                }
                field("Last 30 Days Orders"; QtyOrders30Day)
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
            group(Setup)
            {
                Image = Setup;
                group(Import)
                {
                    action("Init Tables")
                    {
                        ApplicationArea = All;
                        Image = ImportDatabase;
                        trigger OnAction()
                        var
                            AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            AJWebShipstationMgmt.InitRecords();
                        end;
                    }

                    action("Import Marketplaces")
                    {
                        ApplicationArea = All;
                        Image = ImportDatabase;
                        trigger OnAction()
                        var
                            AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            AJWebShipstationMgmt.GetMarketlaces(Rec);
                        end;
                    }
                    action("Import Warehouses")
                    {
                        ApplicationArea = All;
                        Image = ImportDatabase;
                        trigger OnAction()
                        var
                            AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                            AJWebShipstationMgmt.GetWarehouses(Rec);
                        end;
                    }
                    action("Import Carriers")
                    {
                        ApplicationArea = All;
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
                        ApplicationArea = All;
                        Image = Relationship;
                        RunObject = Page "AJ Web Marketplaces";
                        RunPageLink = "Web Service Code" = FIELD(Code);
                    }
                    action(Warehouses)
                    {
                        ApplicationArea = All;
                        RunObject = Page "AJ Web Service Warehouse Setup";
                        RunPageLink = "Web Service Code" = FIELD(Code);
                    }
                    action("Shipping Carriers")
                    {
                        ApplicationArea = All;
                        Image = Delivery;
                        RunObject = Page "AJ Web Carriers";
                        RunPageLink = "Web Service Code" = FIELD("Shipping Service Code");
                    }
                    action("Carrier services")
                    {
                        ApplicationArea = All;
                        RunObject = Page "AJ Web Carrier Services";
                        RunPageLink = "Web Service Code" = FIELD(Code);
                    }
                    action("Shipping Constants")
                    {
                        ApplicationArea = All;
                        Image = VariableList;
                        RunObject = Page "AJ Web Service Constants";
                        RunPageLink = "Web Order Service Code" = FIELD("Shipping Service Code");
                        RunPageView = SORTING("Web Order Service Code", Type, "Option Value");
                    }
                    group("Service functions")
                    {
                        action("Delete Curr Record")
                        {
                            ApplicationArea = All;
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
                    action("Web Orders")
                    {
                        ApplicationArea = All;
                        RunObject = Page "AJ Web Order List";
                        RunPageLink = "Web Service Code" = FIELD(Code),
                                  "Document Type" = CONST(Order);

                        trigger OnAction()
                        var
                        //AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        begin
                        end;
                    }
                    action("Web Returns")
                    {
                        ApplicationArea = All;
                        RunObject = Page "AJ Web Return List";
                        RunPageLink = "Web Service Code" = FIELD(Code),
                                  "Document Type" = CONST(Return);
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

