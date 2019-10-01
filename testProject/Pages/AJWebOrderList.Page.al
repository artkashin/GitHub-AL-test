page 37072308 "AJ Web Order List"
{
    CardPageID = "AJ Web Order";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "AJ Web Order Header";
    SourceTableView = ORDER(Descending)
                      WHERE("Document Type" = CONST(Order));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Web Service Code"; "Web Service Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Acknowlegement Sent"; "Acknowlegement Sent")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
                {
                    ApplicationArea = All;
                    DecimalPlaces = 0 : 2;
                }
                field("Total Quantity"; "Total Quantity")
                {
                    ApplicationArea = All;
                }
                field(Lines; Lines)
                {
                    ApplicationArea = All;
                }
                field("Latest Delivery Date"; "Latest Delivery Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Web Order No."; "Web Order No.")
                {
                    ApplicationArea = All;
                }
                field("Web Service Order ID"; "Web Service Order ID")
                {
                    ApplicationArea = All;
                }
                field("Web Service PO Number"; "Web Service PO Number")
                {
                    ApplicationArea = All;
                }
                field("NAV Order Status"; "NAV Order Status")
                {
                    ApplicationArea = All;
                }
                field("NAV Order Count"; "NAV Order Count")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        lr_SH: Record "Sales Header";
                    begin
                        lr_SH.SetRange("Web Order No.", "Web Order No.");
                        lr_SH.SetRange("Document Type", lr_SH."Document Type"::Order);
                        if lr_SH.FindFirst() then
                            PAGE.RunModal(42, lr_SH);
                    end;
                }
                field("Posted Orders"; SalesInvoiceHeader.Count())
                {
                    ApplicationArea = All;
                    Caption = 'Posted Orders';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SalesInvoiceHeader.SetRange(SalesInvoiceHeader."Web Order No.", "Web Order No.");
                        if SalesInvoiceHeader.FindFirst() then
                            PAGE.RunModal(132, SalesInvoiceHeader);
                    end;
                }
                field("NAV Error Text"; "NAV Error Text")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // gcd_WebOrderMgt.WOS_GetWebOrderNotDefinedItemList(Rec); // MBS commented
                    end;
                }
                field("Warehouse Wate ID"; "Warehouse Wate ID")
                {
                    ApplicationArea = All;
                }
                field("Shipping Web Service Code"; "Shipping Web Service Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Web Shipping Order No.';
                    Editable = false;
                }
                field("Ship-From Warehouse ID"; "Ship-From Warehouse ID")
                {
                    ApplicationArea = All;
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                    ApplicationArea = All;
                }
                field("Carier Shipping Charge"; "Carier Shipping Charge")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Carier Insurance Cost"; "Carier Insurance Cost")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Labels Created"; "Labels Created")
                {
                    ApplicationArea = All;
                }
                field("Labels Printed"; "Labels Printed")
                {
                    ApplicationArea = All;
                }
                field("Packing List Created"; "Packing List Created")
                {
                    ApplicationArea = All;
                }
                field("Packing List Printed"; "Packing List Printed")
                {
                    ApplicationArea = All;
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                    ApplicationArea = All;
                }
                field("Invoice Advice"; "Invoice Advice")
                {
                    ApplicationArea = All;
                }
                field("Shipment Id"; "Shipment Id")
                {
                    ApplicationArea = All;
                }
                field("Paid Amount"; "Paid Amount")
                {
                    ApplicationArea = All;
                }
                field("Tax Amount"; "Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Shipping Amount"; "Shipping Amount")
                {
                    ApplicationArea = All;
                }
                field("Send Ship Confirmation"; "Send Ship Confirmation")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Latest Ship Date"; "Latest Ship Date")
                {
                    ApplicationArea = All;
                }
                field("Ship Date"; "Ship Date")
                {
                    ApplicationArea = All;
                }
                field("Hold Until Date"; "Hold Until Date")
                {
                    ApplicationArea = All;
                }
                field("Order DateTime"; "Order DateTime")
                {
                    ApplicationArea = All;
                }
                field("Created DateTime"; "Created DateTime")
                {
                    ApplicationArea = All;
                }
                field("Modify DateTime"; "Modify DateTime")
                {
                    ApplicationArea = All;
                }
                field("Payment DateTime"; "Payment DateTime")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Address Verified"; "Ship-To Address Verified")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer Name"; "Ship-To Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Company"; "Ship-To Company")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer Zip"; "Ship-To Customer Zip")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer Country"; "Ship-To Customer Country")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer State"; "Ship-To Customer State")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer City"; "Ship-To Customer City")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer Address 1"; "Ship-To Customer Address 1")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer Address 2"; "Ship-To Customer Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-To Customer Phone"; "Ship-To Customer Phone")
                {
                    ApplicationArea = All;
                }
                field("Web Service Customer ID"; "Web Service Customer ID")
                {
                    ApplicationArea = All;
                }
                field("Web Service Customer ID2"; "Web Service Customer ID2")
                {
                    ApplicationArea = All;
                }
                field("First SKU"; gc_FirstSKU)
                {
                    ApplicationArea = All;
                }
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                    ApplicationArea = All;
                }
                field("Cancel Reason"; "Cancel Reason")
                {
                    ApplicationArea = All;
                }
                field("Authorized Amount"; "Authorized Amount")
                {
                    ApplicationArea = All;
                }
                field("Captured Amount"; "Captured Amount")
                {
                    ApplicationArea = All;
                }
                field("Payment Id"; "Payment Id")
                {
                    ApplicationArea = All;
                }
                field("Payment Gateway"; "Payment Gateway")
                {
                    ApplicationArea = All;
                }
                field("Card Type"; "Card Type")
                {
                    ApplicationArea = All;
                }
                field("Payment Method"; "Payment Method")
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
            group("Web Services")
            {
                Caption = 'Web Services';
                group("Shipping Label")
                {
                    Caption = 'Shipping Label';
                    action("Get Shipping Label")
                    {
                        ApplicationArea = All;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;

                        trigger OnAction()
                        var
                            AJWebOrderHeader: Record "AJ Web Order Header";
                        begin
                            CurrPage.SetSelectionFilter(AJWebOrderHeader);

                            //GetShippingLabel(AJWebOrderHeader);

                            Message('Done');
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        lr_WOL: Record "AJ Web Order Line";
    begin
        lr_WOL.SetRange("Web Order No.", "Web Order No.");
        if lr_WOL.FindFirst() then
            gc_FirstSKU := lr_WOL.SKU
        else
            gc_FirstSKU := '';
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        exit(false);
    end;

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        //gcd_WebOrderMgt: Codeunit "AJ Web Order Service Mgmt";
        gc_FirstSKU: Code[30];

    procedure GetShipLabels(var AJWebOrderHeader: Record "AJ Web Order Header"; GetLabelLocal: Boolean)
    var
        WebService: Record "AJ Web Service";
        Customer: Record Customer;
        AJWebPackage: Record "AJ Web Package";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        Wnd: Dialog;
        Cnt: Integer;
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
        if not SalesHeader.FindFirst() then
            Clear(SalesHeader);

        WebService.Get(AJWebOrderHeader."Web Service Code");

        if SalesHeader."No." <> '' then begin
            SalesHeader.TestField(Status, SalesHeader.Status::Open);
            Customer.Get(SalesHeader."Sell-to Customer No.");
            Customer.TestField(Blocked, Customer.Blocked::" ");
        end;

        if SalesHeader."No." = '' then begin
            SalesInvHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if not SalesInvHeader.FindFirst() then
                Clear(SalesInvHeader);
        end;

        AJWebOrderHeader.TestField("Shipping Web Service Code");
        AJWebOrderHeader.TestField("Ship-From Warehouse ID");
        AJWebOrderHeader.TestField("Shipping Carrier Code");
        AJWebOrderHeader.TestField("Shipping Carrier Service");
        AJWebOrderHeader.TestField("Shipping Package Type");

        // update web order
        //if (SalesHeader."No." <> '') and (AJWebOrderHeader."Created From Sales Order") then
        //AJWebOrderServiceMgmt.WOS_CreateWebOrderFromSalesOrder(SalesHeader, AJWebOrderHeader);

        AJWebOrderHeader.CalcFields(Packages);
        if AJWebOrderHeader.Packages then
            if Confirm('There are Packages for Web Order %1. Do you want to create labels for packages?', true, AJWebOrderHeader."Web Order No.") then begin
                Cnt := 0;
                Wnd.Open('Requesting shipping label #1##...');

                AJWebPackage.Reset();
                AJWebPackage.SetCurrentKey("Source Type", "Source No.");
                AJWebPackage.SetRange("Source Type", DATABASE::"AJ Web Order Header");
                AJWebPackage.SetRange("Source No.", AJWebOrderHeader."Web Order No.");
                if AJWebPackage.FindFirst() then
                    repeat
                        Cnt += 1;
                        Wnd.Update(1, Cnt);

                    // if GetLabelLocal then begin
                    //     // if AJWebPackage."Label Created" then begin
                    //     //     if Confirm('Label for package %1 already created! Cancel it and create new one?', true, AJWebPackage."No.") then begin
                    //     //         AJWebOrderServiceMgmt.WOS_CancelLabelForPackage(AJWebPackage);
                    //     //         Commit();
                    //     //     end;
                    //     // end;

                    //     if not AJWebPackage."Label Created" then begin
                    //          AJWebOrderServiceMgmt.WOS_GetLabelForPackage(AJWebPackage);
                    //         Commit();
                    //     end;
                    // end;
                    until AJWebPackage.Next() = 0;

                Wnd.Close();

                exit;
            end else
                Error('Cancelled.');

        if GetLabelLocal then begin
            if AJWebOrderHeader."Labels Created" then
                if Confirm('Label already exists! Do you want to cancel it and create new one?') then begin
                    Wnd.Open('Cancelling shipping label...');
                    if (SalesHeader."No." <> '') then begin
                        SalesHeader."Package Tracking No." := '';
                        SalesHeader.Modify();
                        Commit();
                    end;
                    Wnd.Close();
                end else
                    Error('Operation was cancelled');

            Wnd.Open('Requesting shipping label...');
            //AJWebOrderServiceMgmt.WOS_GetOrderLabel(AJWebOrderHeader);
            Wnd.Close();
        end;

        if SalesHeader."No." <> '' then begin
            SalesHeader."Package Tracking No." := AJWebOrderHeader."Carier Tracking Number";
            SalesHeader.Validate("Posting Date", WorkDate());
            SalesHeader.Modify(true);
            //AJSalesMgt.On_SalesReleased(SalesHeader); // Insert G/L lines
            Commit();
        end;

        if SalesInvoiceHeader."No." <> '' then begin
            //SalesInvoiceHeader."Shipping & Handling Amount" := AJWebOrderHeader."Shipping & Handling Amount"; // MBS commented
            SalesInvoiceHeader."Package Tracking No." := AJWebOrderHeader."Carier Tracking Number";
            SalesInvoiceHeader.Modify();
        end;
    end;

    [Scope('Internal')]
    procedure GetShippingLabel(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        Wnd: Dialog;
    begin
        Wnd.Open('Checking Acknowledgement status');

        if AJWebOrderHeader.FindFirst() then
            repeat
                AJWebOrderHeader.TestField("Acknowlegement Sent", true);
            until AJWebOrderHeader.Next() = 0;

        Wnd.Close();
        Wnd.Open('Requesting Shipping Labels');

        if AJWebOrderHeader.FindFirst() then
            repeat
                GetShipLabels(AJWebOrderHeader, true);
                Commit();
            until AJWebOrderHeader.Next() = 0;

        Wnd.Close();
    end;
}

