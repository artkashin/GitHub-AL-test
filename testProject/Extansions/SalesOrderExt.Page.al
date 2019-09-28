pageextension 37072300 PageExtansion42 extends "Sales Order"
{
    layout
    {
        addlast(General)
        {

            group("AJ Shipping")
            {

                field("Web Order No."; "Web Order No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Editable = false;
                    QuickEntry = false;
                    Visible = false;
                }
                field(AJWOH_WebOrderNo; AJWebOrderHeader."Web Order No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Caption = 'Web Order No.';
                    DrillDown = false;
                    Editable = false;
                    Lookup = false;
                    QuickEntry = false;
                    TableRelation = "AJ Web Order Header";

                    trigger OnAssistEdit()
                    var
                        SalesLine: Record "Sales Line";
                        lr_Customer: Record Customer;
                        ReleaseSalesDocument: Codeunit "Release Sales Document";
                        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                        AJWebPackage: Record "AJ Web Package";
                        PaymentTerms: Record "Payment Terms";
                        AJWebService: Record "AJ Web Service";
                        AJWebOrderHeader2: Record "AJ Web Order Header";
                        AJWebOrderServiceMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                        ShippingAgentServices: Record "Shipping Agent Services";
                    begin
                        if Status = Status::Released then begin
                            ReleaseSalesDocument.Reopen(Rec);
                            Commit;
                        end;

                        if AJWebOrderHeader."Web Order No." <> '' then
                            PAGE.Run(PAGE::"AJ Web Order", AJWebOrderHeader)
                        else begin
                            AJWebOrderHeader."Order DateTime" := CreateDateTime("Order Date", Time);
                            AJWebOrderHeader.InitRecord("Shipping Agent Code");
                            if not AJWebService.Get(AJWebOrderHeader."Shipping Web Service Code") then
                                AJWebService.Init;

                            if lr_Customer.Get("Sell-to Customer No.")
                              then
                                if lr_Customer."Bill-to Type" = lr_Customer."Bill-to Type"::third_party then begin
                                    AJWebOrderHeader."Bill-to Type" := lr_Customer."Bill-to Type";
                                    AJWebOrderHeader."Bill-To Account" := lr_Customer."Bill-to Account No.";
                                    AJWebOrderHeader."Bill-To Postal Code" := lr_Customer."Bill-to Account Post Code";
                                    AJWebOrderHeader."Bill-To Country Code" := lr_Customer."Bill-to Account Country Code";
                                end;
                            AJWebPackage.Reset;
                            AJWebPackage.SetRange("Source Type", DATABASE::Customer);
                            AJWebPackage.SetRange("Source No.", "Sell-to Customer No.");
                            if AJWebPackage.FindFirst then begin
                                AJWebOrderHeader."Shipping Web Service Code" := AJWebPackage."Shipping Web Service Code";
                                //AJWebOrderHeader."Shipping Web Service Store ID" := AJWebPackage."Shipping Web Service Store ID";
                                AJWebOrderHeader."Ship-From Warehouse ID" := AJWebPackage."Shipping Warehouse ID";
                                AJWebOrderHeader."Shipping Carrier Code" := AJWebPackage."Shipping Carrier Code";
                                AJWebOrderHeader."Shipping Carrier Service" := AJWebPackage."Shipping Carrier Service";
                                AJWebOrderHeader."Shipping Package Type" := AJWebPackage."Shipping Package Type";
                                AJWebOrderHeader."Shipping Delivery Confirm" := AJWebPackage."Shipping Delivery Confirm";
                                AJWebOrderHeader."Shp. Product Dimension Unit" := AJWebPackage."Shp. Product Dimension Unit";
                                AJWebOrderHeader."Shp. Product Weight Unit" := AJWebPackage."Shp. Product Weight Unit";
                                AJWebOrderHeader."Shp. Product Weight" := AJWebPackage."Shp. Product Weight";
                                AJWebOrderHeader."Shp. Product Width" := AJWebPackage."Shp. Product Width";
                                AJWebOrderHeader."Shp. Product Length" := AJWebPackage."Shp. Product Length";
                                AJWebOrderHeader."Shp. Product Height" := AJWebPackage."Shp. Product Height";
                                AJWebOrderHeader."Insure Shipment" := AJWebPackage."Insure Shipment";
                                AJWebOrderHeader."Insured Value" := AJWebPackage."Insured Value";
                                AJWebOrderHeader."Additional Insurance Value" := AJWebPackage."Additional Insurance Value";
                                AJWebOrderHeader.Modify;
                            end;
                            Rec."Web Order No." := AJWebOrderHeader."Web Order No.";

                            if not PaymentTerms.Get("Payment Terms Code") then
                                PaymentTerms.Init;
                            AJWebOrderHeader."COD Amount" := 0;

                            //  IF PaymentTerms."COD Type" <> PaymentTerms."COD Type"::" " THEN BEGIN
                            //    SalesLine.RESET;
                            //    SalesLine.SETRANGE("Document Type","Document Type");
                            //    SalesLine.SETRANGE("Document No.","No.");
                            //    IF SalesLine.FINDFIRST THEN REPEAT
                            //      IF NOT ((SalesLine.Type = SalesLine.Type::"G/L Account") AND (SalesLine."Web Line Type" = SalesLine."Web Line Type"::"S&H")) THEN
                            //        AJWebOrderHeader."COD Amount" += SalesLine."Unit Price" * SalesLine."Qty. to Ship";
                            //    UNTIL SalesLine.NEXT = 0;
                            //  END;

                            AJWebOrderHeader.Modify;
                            Rec.Modify;
                        end;
                    end;
                }
                field(AJWOH_WebServiceCode; AJWebOrderHeader."Web Service Code")
                {
                    ApplicationArea = All;
                    Caption = 'Web Service Code';
                    Editable = false;
                    Importance = Additional;
                    QuickEntry = false;
                }
                field(AJWOH_ShpWebServiceCode; AJWebOrderHeader."Shipping Web Service Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Web Service Code';
                    QuickEntry = false;
                    TableRelation = "AJ Web Service".Code;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebService: Record "AJ Web Service";
                        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                    begin

                        AJWebService.SetRange("Web Service Type", AJWebService."Web Service Type"::ShipStation);
                        if PAGE.RunModal(PAGE::"AJ Web Services", AJWebService) = ACTION::LookupOK then begin
                            AJWebOrderHeader."Shipping Web Service Code" := AJWebService.Code;
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        AJWebService: Record "AJ Web Service";
                    begin

                        if AJWebOrderHeader."Shipping Web Service Code" = '' then begin
                            AJWebOrderHeader.Init;
                        end;
                        if AJWebService.Get(AJWebOrderHeader."Shipping Web Service Code") then begin
                            if AJWebOrderHeader."Web Order No." = '' then begin
                                AJWebOrderHeader.InitRecord("Shipping Agent Code");
                                Rec."Web Order No." := AJWebOrderHeader."Web Order No.";
                                Rec.Modify;
                            end;
                            AJWebOrderHeader."Shipping Web Service Code" := AJWebService.Code;
                            if AJWebOrderHeader."Web Service Code" = '' then
                                AJWebOrderHeader."Web Service Code" := AJWebService.Code;
                        end;

                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_SipFromWhseID; AJWebOrderHeader."Ship-From Warehouse ID")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-From Warehouse ID';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebServiceWarehouse.SetRange("Web Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        if PAGE.RunModal(PAGE::"AJ Web Service Warehouses", AJWebServiceWarehouse) = ACTION::LookupOK then begin
                            AJWebOrderHeader.Validate("Ship-From Warehouse ID", AJWebServiceWarehouse."Warehouse ID");
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                    begin
                    end;
                }
                field(AJWOH_ShpCarrierCode; AJWebOrderHeader."Shipping Carrier Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Carrier Code';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebCarrier: Record "AJ Web Carrier";
                    begin

                        AJWebCarrier.SetRange("Web Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        if PAGE.RunModal(PAGE::"AJ Web Carriers", AJWebCarrier) = ACTION::LookupOK then begin
                            AJWebOrderHeader.Validate("Shipping Carrier Code", AJWebCarrier.Code);
                            AJWebOrderHeader.Modify;

                            // Update Sales Order
                            if (AJWebCarrier."Shipment Method Code" <> '') and ("Shipment Method Code" <> AJWebCarrier."Shipment Method Code") then begin
                                "Shipment Method Code" := AJWebCarrier."Shipment Method Code";
                                "Shipping Agent Code" := AJWebCarrier."Shipping Agent  Code";
                                Modify;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        AJWebCarrier: Record "AJ Web Carrier";
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;

                        // Update Sales Order
                        if AJWebCarrier.Get(AJWebOrderHeader."Shipping Web Service Code", AJWebOrderHeader."Shipping Carrier Code") then
                            if (AJWebCarrier."Shipment Method Code" <> '') and ("Shipment Method Code" <> AJWebCarrier."Shipment Method Code") then begin
                                "Shipment Method Code" := AJWebCarrier."Shipment Method Code";
                                "Shipping Agent Code" := AJWebCarrier."Shipping Agent  Code";
                                Modify;
                            end;
                    end;
                }
                field(AJWOH_ShpCarrierService; AJWebOrderHeader."Shipping Carrier Service")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Carrier Service';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebCarrierService: Record "AJ Web Carrier Service";
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebCarrierService.SetRange("Web Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        AJWebCarrierService.SetRange("Web Carrier Code", AJWebOrderHeader."Shipping Carrier Code");
                        AJWebCarrierService.SetRange(Blocked, false);
                        if PAGE.RunModal(PAGE::"AJ Web Carrier Services", AJWebCarrierService) = ACTION::LookupOK then begin
                            AJWebOrderHeader."Shipping Carrier Service" := AJWebCarrierService."Service  Code";
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_ShpPackageType; AJWebOrderHeader."Shipping Package Type")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Package Type';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebCarrierPackageType.SetRange("Web Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        AJWebCarrierPackageType.SetRange("Web Carrier Code", AJWebOrderHeader."Shipping Carrier Code");
                        AJWebCarrierPackageType.SetRange(Blocked, false);
                        if PAGE.RunModal(PAGE::"AJ Web Carier Package Types", AJWebCarrierPackageType) = ACTION::LookupOK then begin
                            AJWebOrderHeader."Shipping Package Type" := AJWebCarrierPackageType."Package Code";
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_ShpDeliveryConf; AJWebOrderHeader."Shipping Delivery Confirm")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Delivery Confirmation';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Confirmation);
                        AJWebServiceConstants.SetRange(Blocked, false);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJWebOrderHeader."Shipping Delivery Confirm" := AJWebServiceConstants."Option Value";
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_ShpOption; AJWebOrderHeader."Shipping Options")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Option';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Option);
                        AJWebServiceConstants.SetRange(Blocked, false);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJWebOrderHeader."Shipping Options" := AJWebServiceConstants."Option Value";
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_PrdWgt; AJWebOrderHeader."Shp. Product Weight")
                {
                    ApplicationArea = All;
                    Caption = 'Product Weight';
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_PrdDim; AJWebOrderHeader."Shp. Product Weight Unit")
                {
                    ApplicationArea = All;
                    Caption = 'Product Weight Unit';
                    Importance = Additional;
                    QuickEntry = false;
                    TableRelation = "AJ Web Service Constants"."Option Value" WHERE (Type = CONST (Weight));

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Weight);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJWebOrderHeader."Shp. Product Weight Unit" := AJWebServiceConstants."Option Value";
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_PrdDimUnit; AJWebOrderHeader."Shp. Product Dimension Unit")
                {
                    ApplicationArea = All;
                    Caption = 'Product Dimension Unit';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJWebOrderHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Dimension);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJWebOrderHeader."Shp. Product Dimension Unit" := AJWebServiceConstants."Option Value";
                            AJWebOrderHeader.Modify;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_PrdW; AJWebOrderHeader."Shp. Product Width")
                {
                    ApplicationArea = All;
                    Caption = 'Product Width';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_PrdL; AJWebOrderHeader."Shp. Product Length")
                {
                    ApplicationArea = All;
                    Caption = 'Product Length';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_PrdH; AJWebOrderHeader."Shp. Product Height")
                {
                    ApplicationArea = All;
                    Caption = 'Product Height';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_International; AJWebOrderHeader."International Shipment")
                {
                    ApplicationArea = All;
                    Caption = 'International';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_InsureShp; AJWebOrderHeader."Insure Shipment")
                {
                    ApplicationArea = All;
                    Caption = 'Insure Shipment';
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_InsuredValue; AJWebOrderHeader."Insured Value")
                {
                    ApplicationArea = All;
                    Caption = 'Insured Value';
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_AddInsValue; AJWebOrderHeader."Additional Insurance Value")
                {
                    ApplicationArea = All;
                    Caption = 'Additional Insurance Value';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin

                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_CODAmount; AJWebOrderHeader."COD Amount")
                {
                    ApplicationArea = All;
                    Caption = 'COD Amount';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.Modify;
                    end;
                }
                field(AJWOH_CarrierShpCharge; AJWebOrderHeader."Carier Shipping Charge")
                {
                    ApplicationArea = All;
                    Caption = 'Carrier Shipping Charge';
                    Editable = false;
                    QuickEntry = false;

                    trigger OnAssistEdit()
                    begin
                        GetShipLabels;
                    end;
                }
                field(AJWOH_CarrierTrackingNumber; AJWebOrderHeader."Carier Tracking Number")
                {
                    ApplicationArea = All;
                    Caption = 'Carrier Tracking#';
                    Editable = false;
                    QuickEntry = false;
                }
                field(AJWOH_CarrierInsuranceCost; AJWebOrderHeader."Carier Insurance Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Carrier Insurance Cost';
                    Editable = false;
                    QuickEntry = false;
                }
                field(AJWOH_PackagesShipHandAmount; AJWebOrderHeader."Packages Ship. & Hand. Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Packages S&H Amount';
                    Editable = false;
                    Importance = Additional;
                    QuickEntry = false;
                }
                field(AJWOH_PackagesCount; AJWebOrderHeader."Packages Count")
                {
                    ApplicationArea = Basic;
                    Caption = 'Packages';
                    Editable = false;
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnDrillDown()
                    var
                        AJWebPackage: Record "AJ Web Package";
                    begin

                        AJWebPackage.Reset;
                        AJWebPackage.SetCurrentKey("Source Type", "Source No.");
                        AJWebPackage.SetRange("Source Type", DATABASE::"AJ Web Order Header");
                        AJWebPackage.SetRange("Source No.", AJWebOrderHeader."Web Order No.");
                        PAGE.RunModal(0, AJWebPackage);
                    end;
                }
                field(AJWOH_CustomField2; AJWebOrderHeader."Customer Reference ID")
                {
                    ApplicationArea = basic, Suite;
                    Caption = 'Custom Field 2';

                    trigger OnValidate()
                    begin
                        AJWebOrderHeader.TestField("Shipping Web Service Code");
                        AJWebOrderHeader.TestField("Created From Sales Order", true);
                        AJWebOrderHeader.Modify;
                    end;
                }
            }
        }
    }
    var
        AJWebOrderHeader: Record "AJ Web Order Header";
        xAJWebOrderHeader: Record "AJ Web Order Header";

    local procedure GetShipLabels()
    var
        AJWebOrderServiceMgmt: Codeunit "AJ Web Shipstation Mgmt.";
        Wnd: Dialog;
        Customer: Record Customer;
        AJWebPackage: Record "AJ Web Package";
        Cnt: Integer;
        OrderCreated: Boolean;
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
    begin
        TestField(Status, Status::Open);
        Customer.Get("Sell-to Customer No.");
        Customer.TestField(Blocked, Customer.Blocked::" ");
        AJWebOrderHeader.TestField("Shipping Web Service Code");
        if not AJWebServiceWarehouse.Get(AJWebOrderHeader."Shipping Web Service Code", AJWebOrderHeader."Ship-From Warehouse ID") then
            Error('Web Order %1 does not have warehouse!', AJWebOrderHeader."Web Order No.");

        AJWebOrderHeader.TestField("Shipping Carrier Code");
        AJWebOrderHeader.TestField("Shipping Carrier Service");
        AJWebOrderHeader.TestField("Shipping Package Type");
        if AJWebOrderHeader."COD Status" = 0 then
            if ("Web Order No." = '') or (AJWebOrderHeader."Created From Sales Order") then begin
                AJWebOrderServiceMgmt.CreateWebOrderFromSalesOrder(Rec, AJWebOrderHeader);
                Commit;
                OrderCreated := true;
            end;
        AJWebOrderHeader.CalcFields(Packages);
        if AJWebOrderHeader.Packages then begin
            if Confirm('There are Packages. Do you want to create labels for them?') then begin
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
                        if not AJWebPackage."Label Created" then begin
                            //AJWebOrderServiceMgmt.GetLabelForPackage(AJWebPackage);
                            Commit;
                        end;
                    until AJWebPackage.Next = 0;
                Wnd.Close;
                Rec.Find;

                Message('Done');
                CurrPage.Update(false);
                exit;
            end else
                Error('Cancelled.');
        end;
        if AJWebOrderHeader."Labels Created" then
            if Confirm('Label already exists! Do you want to cancel it and create new one?') then begin
                Wnd.Open('Cancelling shipping label...');
                //AJWebOrderServiceMgmt.WOS_CancelOrderLabel(AJWebOrderHeader); // MBS commented            
                "Package Tracking No." := '';
                Modify;
                Commit;
                Wnd.Close;
            end else
                Error('Operation was cancelled');
        Wnd.Open('Requesting shipping label...');
        if AJWebOrderHeader.Get("Web Order No.") then begin
            AJWebOrderServiceMgmt.GetOrderLabelParam(OrderCreated);
            AJWebOrderServiceMgmt.GetOrderLabel(AJWebOrderHeader);
            "Package Tracking No." := AJWebOrderHeader."Carier Tracking Number";
            Validate("Posting Date", WorkDate);
            Modify(true);
        end;
        Wnd.Close;
        CurrPage.Update(false);
    end;
}

