page 37075202 "AJ Web Order List"
{
    CardPageID = "AJ Web Order";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "AJ Web Order Header";
    SourceTableView = ORDER(Descending)
                      WHERE ("Document Type" = CONST (Order));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Web Service Code"; "Web Service Code")
                {
                    Visible = false;
                }
                field("Acknowlegement Sent"; "Acknowlegement Sent")
                {
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
                {
                    DecimalPlaces = 0 : 2;
                }
                field("Total Quantity"; "Total Quantity")
                {
                }
                field(Lines; Lines)
                {
                }
                field("Latest Delivery Date"; "Latest Delivery Date")
                {
                    Editable = false;
                }
                field("Web Order No."; "Web Order No.")
                {
                }
                field("Web Service Order ID"; "Web Service Order ID")
                {
                }
                field("Web Service PO Number"; "Web Service PO Number")
                {
                }
                field("NAV Order Status"; "NAV Order Status")
                {
                }
                field("NAV Order Count"; "NAV Order Count")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        lr_SH: Record "Sales Header";
                    begin
                        lr_SH.SetRange("Web Order No.", "Web Order No.");
                        lr_SH.SetRange("Document Type", lr_SH."Document Type"::Order);
                        if lr_SH.FindFirst
                          then
                            PAGE.RunModal(42, lr_SH);
                    end;
                }
                field("Posted Orders"; SalesInvoiceHeader.Count)
                {
                    Caption = 'Posted Orders';
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SalesInvoiceHeader.SetRange(SalesInvoiceHeader."Web Order No.", "Web Order No.");
                        if SalesInvoiceHeader.FindFirst then
                            PAGE.RunModal(132, SalesInvoiceHeader);
                    end;
                }
                field("NAV Error Text"; "NAV Error Text")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // gcd_WebOrderMgt.WOS_GetWebOrderNotDefinedItemList(Rec); // MBS commented
                    end;
                }
                field("Warehouse Wate ID"; "Warehouse Wate ID")
                {
                }
                field("Shipping Web Service Code"; "Shipping Web Service Code")
                {
                    Editable = false;
                }
                field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
                {
                    Caption = 'Web Shipping Order No.';
                    Editable = false;
                }
                field("Ship-From Warehouse ID"; "Ship-From Warehouse ID")
                {
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                }
                field("Carier Shipping Charge"; "Carier Shipping Charge")
                {
                    Visible = false;
                }
                field("Carier Insurance Cost"; "Carier Insurance Cost")
                {
                    Visible = false;
                }
                field("Labels Created"; "Labels Created")
                {
                }
                field("Labels Printed"; "Labels Printed")
                {
                }
                field("Packing List Created"; "Packing List Created")
                {
                }
                field("Packing List Printed"; "Packing List Printed")
                {
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                }
                field("Invoice Advice"; "Invoice Advice")
                {
                }
                field("Shipment Id"; "Shipment Id")
                {
                }
                field("Paid Amount"; "Paid Amount")
                {
                }
                field("Tax Amount"; "Tax Amount")
                {
                }
                field("Shipping Amount"; "Shipping Amount")
                {
                }
                field("Send Ship Confirmation"; "Send Ship Confirmation")
                {
                    Visible = false;
                }
                field("Latest Ship Date"; "Latest Ship Date")
                {
                }
                field("Ship Date"; "Ship Date")
                {
                }
                field("Hold Until Date"; "Hold Until Date")
                {
                }
                field("Order DateTime"; "Order DateTime")
                {
                }
                field("Created DateTime"; "Created DateTime")
                {
                }
                field("Modify DateTime"; "Modify DateTime")
                {
                }
                field("Payment DateTime"; "Payment DateTime")
                {
                }
                field("Ship-To Address Verified"; "Ship-To Address Verified")
                {
                }
                field("Ship-To Customer Name"; "Ship-To Customer Name")
                {
                }
                field("Ship-To Company"; "Ship-To Company")
                {
                }
                field("Ship-To Customer Zip"; "Ship-To Customer Zip")
                {
                }
                field("Ship-To Customer Country"; "Ship-To Customer Country")
                {
                }
                field("Ship-To Customer State"; "Ship-To Customer State")
                {
                }
                field("Ship-To Customer City"; "Ship-To Customer City")
                {
                }
                field("Ship-To Customer Address 1"; "Ship-To Customer Address 1")
                {
                }
                field("Ship-To Customer Address 2"; "Ship-To Customer Address 2")
                {
                }
                field("Ship-To Customer Phone"; "Ship-To Customer Phone")
                {
                }
                field("""Shipping Agent Label"".HASVALUE"; "Shipping Agent Label".HasValue)
                {
                    Caption = 'Label Imported';
                    Editable = false;
                }
                field("Web Service Customer ID"; "Web Service Customer ID")
                {
                }
                field("Web Service Customer ID2"; "Web Service Customer ID2")
                {
                }
                field("First SKU"; gc_FirstSKU)
                {
                }
                field("Shipping Service Criterion"; "Shipping Service Criterion")
                {

                    trigger OnDrillDown()
                    var
                        WebOH: Record "AJ Web Order Header";
                    begin
                        //vadimb 03/06/2018 >
                        // CarrierForOrderRec.SETRANGE(CarrierForOrderRec."Web Order No.", "Web Order No.");
                        // CarrierForOrderPage.SETTABLEVIEW(CarrierForOrderRec);
                        // CarrierForOrderPage.LOOKUPMODE(TRUE);
                        // IF CarrierForOrderPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        //  CarrierForOrderPage.GETRECORD(CarrierForOrderRec);
                        //  WebOH.GET("Web Order No.");
                        //  WebOH.VALIDATE("Shipping Carrier Code", CarrierForOrderRec."Carrier Name");
                        //  WebOH.VALIDATE("Shipping Carrier Service", CarrierForOrderRec.ShippingServiceName);
                        //  WebOH.VALIDATE("Shp. Hts Code", CarrierForOrderRec."Shipping Service Id");
                        //  WebOH.VALIDATE("Carier Shipping Charge", CarrierForOrderRec."Amount (USD)");
                        //  WebOH.VALIDATE("Ship Date", CarrierForOrderRec."Ship Date");
                        //  WebOH.MODIFY;
                        // END;
                        //vadimb 03/06/2018 <
                    end;
                }
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                }
                field("Cancel Reason"; "Cancel Reason")
                {
                }
                field("Authorized Amount"; "Authorized Amount")
                {
                }
                field("Captured Amount"; "Captured Amount")
                {
                }
                field("Payment Id"; "Payment Id")
                {
                }
                field("Payment Gateway"; "Payment Gateway")
                {
                }
                field("Card Type"; "Card Type")
                {
                }
                field("Payment Method"; "Payment Method")
                {
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
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;

                        trigger OnAction()
                        var
                            AJWebOrderHeader: Record "AJ Web Order Header";
                        begin
                            CurrPage.SetSelectionFilter(AJWebOrderHeader);

                            GetShippingLabel(AJWebOrderHeader);

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
        //kvb 1035097 1/11/17 ->
        lr_WOL.SetRange("Web Order No.", "Web Order No.");
        if lr_WOL.FindFirst
          then
            gc_FirstSKU := lr_WOL.SKU
        else
            gc_FirstSKU := '';
        //kvb 1035097 1/11/17 <-


        SalesInvoiceHeader.SetRange("Web Order No.", "Web Order No.");
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        exit(false);
    end;

    var
        Text001: Label 'Are you sure you want to post %1 orders?';
        Text002: Label 'Operation cancelled by user.';
        Text003: Label 'NAV orders not found.';
        Text004: Label 'Access Denied.';
        gcd_WebOrderMgt: Codeunit "AJ Web Order Service Mgmt";
        gc_FirstSKU: Code[30];
        vAmazonPrime: Boolean;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesFilter: Text;

    local procedure GetShipLabels(var AJWebOrderHeader: Record "AJ Web Order Header"; GetLabelLocal: Boolean)
    var
        AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
        Wnd: Dialog;
        Customer: Record Customer;
        AJWebPackage: Record "AJ Web Package";
        Cnt: Integer;
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        WebOrdLine: Record "AJ Web Order Line";
        ShippingAmount: Decimal;
        WebService: Record "AJ Web Service";
        NotAmazonShipping: Boolean;
    begin
        SalesHeader.Reset;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
        if not SalesHeader.FindFirst then
            Clear(SalesHeader);

        WebService.Get(AJWebOrderHeader."Web Service Code");

        if SalesHeader."No." <> '' then begin
            SalesHeader.TestField(Status, SalesHeader.Status::Open);
            Customer.Get(SalesHeader."Sell-to Customer No.");
            Customer.TestField(Blocked, Customer.Blocked::" ");
        end;

        if SalesHeader."No." = '' then begin
            SalesInvoiceHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
            if not SalesInvoiceHeader.FindFirst then
                Clear(SalesInvoiceHeader);
        end;

        AJWebOrderHeader.TestField("Shipping Web Service Code");
        AJWebOrderHeader.TestField("Ship-From Warehouse ID");
        AJWebOrderHeader.TestField("Shipping Carrier Code");
        AJWebOrderHeader.TestField("Shipping Carrier Service");
        AJWebOrderHeader.TestField("Shipping Package Type");

        // update web order
        if (SalesHeader."No." <> '') and (AJWebOrderHeader."Created From Sales Order") then
            AJWebOrderServiceMgmt.WOS_CreateWebOrderFromSalesOrder(SalesHeader, AJWebOrderHeader);

        AJWebOrderHeader.CalcFields(Packages);
        if AJWebOrderHeader.Packages then begin
            if Confirm('There are Packages for Web Order %1. Do you want to create labels for packages?', true, AJWebOrderHeader."Web Order No.") then begin

                Cnt := 0;
                Wnd.Open('Requesting shipping label #1##...');

                AJWebPackage.Reset;
                AJWebPackage.SetCurrentKey("Source Type", "Source No.");
                AJWebPackage.SetRange("Source Type", DATABASE::"AJ Web Order Header");
                AJWebPackage.SetRange("Source No.", AJWebOrderHeader."Web Order No.");
                if AJWebPackage.FindFirst then
                    repeat
                        Cnt += 1;
                        Wnd.Update(1, Cnt);

                        if GetLabelLocal then begin
                            if AJWebPackage."Label Created" then begin
                                if Confirm('Label for package %1 already created! Cancel it and create new one?', true, AJWebPackage."No.") then begin
                                    AJWebOrderServiceMgmt.WOS_CancelLabelForPackage(AJWebPackage);
                                    Commit;
                                end;
                            end;

                            if not AJWebPackage."Label Created" then begin
                                AJWebOrderServiceMgmt.WOS_GetLabelForPackage(AJWebPackage);
                                Commit;
                            end;
                        end;

                    until AJWebPackage.Next = 0;

                Wnd.Close;

                exit;
            end else
                Error('Cancelled.');
        end;

        if GetLabelLocal then begin
            if AJWebOrderHeader."Labels Created" then
                if Confirm('Label already exists! Do you want to cancel it and create new one?') then begin
                    Wnd.Open('Cancelling shipping label...');
                    // AJWebOrderServiceMgmt.WOS_CancelOrderLabel(AJWebOrderHeader); // MBS commented

                    if (SalesHeader."No." <> '') then begin // 8/17/2017
                        SalesHeader."Shipping & Handling Amount" := 0; // MBS commented
                        SalesHeader."Package Tracking No." := '';
                        SalesHeader.Modify;
                        Commit;
                    end;
                    Wnd.Close;
                end else
                    Error('Operation was cancelled');

            Wnd.Open('Requesting shipping label...');
            AJWebOrderServiceMgmt.WOS_GetOrderLabel(AJWebOrderHeader);
            Wnd.Close;
        end;

        if SalesHeader."No." <> '' then begin
            SalesHeader."Shipping & Handling Amount" := AJWebOrderHeader."Shipping & Handling Amount";
            SalesHeader."Package Tracking No." := AJWebOrderHeader."Carier Tracking Number";
            SalesHeader.Validate("Posting Date", WorkDate);
            SalesHeader.Modify(true);
            //AJSalesMgt.On_SalesReleased(SalesHeader); // Insert G/L lines
            Commit;
        end;
        SalesHeader."Shipping & Handling Amount" := AJWebOrderHeader."Shipping & Handling Amount";

        if SalesInvoiceHeader."No." <> '' then begin
            //SalesInvoiceHeader."Shipping & Handling Amount" := AJWebOrderHeader."Shipping & Handling Amount"; // MBS commented
            SalesInvoiceHeader."Package Tracking No." := AJWebOrderHeader."Carier Tracking Number";
            SalesInvoiceHeader.Modify;
        end;
    end;

    [Scope('Internal')]
    procedure GetShippingLabel(var AJWebOrderHeader: Record "AJ Web Order Header")
    var
        AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
        Wnd: Dialog;
        AJWebOrderService: Record "AJ Web Service";
        ActionType: Option "Order Header","Order Line","Eligible Shipping service","Create Shipment","Cancel Shipment",Status,"Label Again","Order Acknowelege Feed","Feed Submission Result","Feed Submission List","Order fulfillment feed","Order Adjustments feed";
        Completeness: Option All,GELL,Shipment;
    begin
        Wnd.Open('Checking Acknowledgement status');

        if AJWebOrderHeader.FindFirst then
            repeat
                AJWebOrderHeader.TestField("Acknowlegement Sent", true);
            until AJWebOrderHeader.Next = 0;

        Wnd.Close;
        Wnd.Open('Requesting Shipping Labels');

        if AJWebOrderHeader.FindFirst then
            repeat
                GetShipLabels(AJWebOrderHeader, true);
                Commit;
            until AJWebOrderHeader.Next = 0;

        Wnd.Close;
    end;
}

