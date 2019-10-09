pageextension 37072300 PageExtansion42 extends "Sales Order"
{
    layout
    {
        addafter("Foreign Trade")
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
                field(AJWOH_WebShippingNo; AJShippingHeader."Shipping No.")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Caption = 'Web Shipping No.';
                    DrillDown = false;
                    Editable = false;
                    Lookup = false;
                    QuickEntry = false;
                    TableRelation = "AJ Shipping Header";

                    /*trigger OnAssistEdit()
                    var
                        lr_Customer: Record Customer;
                        AJWebPackage: Record "AJ Web Package";
                        PaymentTerms: Record "Payment Terms";
                        AJWebService: Record "AJ Web Service";
                        AJShippingHeader2: Record "AJ Shipping Header";
                        ReleaseSalesDocument: Codeunit "Release Sales Document";
                    begin
                        if Status = Status::Released then begin
                            ReleaseSalesDocument.Reopen(Rec);
                            Commit();
                        end;

                        if AJShippingHeader2."Shipping No." <> '' then
                            PAGE.Run(PAGE::"AJ Web Order", AJShippingHeader2)
                        else begin
                            AJShippingHeader2."Order DateTime" := CreateDateTime("Order Date", Time());
                            AJShippingHeader2.InitRecord("Shipping Agent Code");
                            if not AJWebService.Get(AJShippingHeader2."Shipping Web Service Code") then
                                AJWebService.Init();

                            if lr_Customer.Get("Sell-to Customer No.")
                              then
                                if lr_Customer."Bill-to Type" = lr_Customer."Bill-to Type"::third_party then begin
                                    AJShippingHeader2."Bill-to Type" := lr_Customer."Bill-to Type";
                                    AJShippingHeader2."Bill-To Account" := lr_Customer."Bill-to Account No.";
                                    AJShippingHeader2."Bill-To Postal Code" := CopyStr(lr_Customer."Bill-to Account Post Code", 1, MaxStrLen(AJShippingHeader2."Bill-To Postal Code"));
                                    AJShippingHeader2."Bill-To Country Code" := lr_Customer."Bill-to Account Country Code";
                                end;
                            AJWebPackage.Reset();
                            AJWebPackage.SetRange("Source Type", DATABASE::Customer);
                            AJWebPackage.SetRange("Source No.", "Sell-to Customer No.");
                            if AJWebPackage.FindFirst() then begin
                                AJShippingHeader2."Shipping Web Service Code" := AJWebPackage."Shipping Web Service Code";
                                //AJShippingHeader2."Shipping Web Service Store ID" := AJWebPackage."Shipping Web Service Store ID";
                                AJShippingHeader2."Ship-From Warehouse ID" := AJWebPackage."Shipping Warehouse ID";
                                AJShippingHeader2."Shipping Carrier Code" := AJWebPackage."Shipping Carrier Code";
                                AJShippingHeader2."Shipping Carrier Service" := AJWebPackage."Shipping Carrier Service";
                                AJShippingHeader2."Shipping Package Type" := AJWebPackage."Shipping Package Type";
                                AJShippingHeader2."Shipping Delivery Confirm" := AJWebPackage."Shipping Delivery Confirm";
                                AJShippingHeader2."Shp. Product Dimension Unit" := AJWebPackage."Shp. Product Dimension Unit";
                                AJShippingHeader2."Shp. Product Weight Unit" := AJWebPackage."Shp. Product Weight Unit";
                                AJShippingHeader2."Shp. Product Weight" := AJWebPackage."Shp. Product Weight";
                                AJShippingHeader2."Shp. Product Width" := AJWebPackage."Shp. Product Width";
                                AJShippingHeader2."Shp. Product Length" := AJWebPackage."Shp. Product Length";
                                AJShippingHeader2."Shp. Product Height" := AJWebPackage."Shp. Product Height";
                                AJShippingHeader2."Insure Shipment" := AJWebPackage."Insure Shipment";
                                AJShippingHeader2."Insured Value" := AJWebPackage."Insured Value";
                                AJShippingHeader2."Additional Insurance Value" := AJWebPackage."Additional Insurance Value";
                                AJShippingHeader2.Modify();
                            end;
                            Rec."Web Order No." := AJShippingHeader2."Shipping No.";

                            if not PaymentTerms.Get("Payment Terms Code") then
                                PaymentTerms.Init();
                            AJShippingHeader2."COD Amount" := 0;

                            //  IF PaymentTerms."COD Type" <> PaymentTerms."COD Type"::" " THEN BEGIN
                            //    SalesLine.Reset();
                            //    SalesLine.SETRANGE("Document Type","Document Type");
                            //    SalesLine.SETRANGE("Document No.","No.");
                            //    IF SalesLine.FindFirst() tHEN REPEAT
                            //      IF NOT ((SalesLine.Type = SalesLine.Type::"G/L Account") AND (SalesLine."Web Line Type" = SalesLine."Web Line Type"::"S&H")) THEN
                            //        AJShippingHeader2."COD Amount" += SalesLine."Unit Price" * SalesLine."Qty. to Ship";
                            //    UNTIL SalesLine.NEXT = 0;
                            //  END;

                            AJShippingHeader2.Modify();
                            Rec.Modify();
                        end;
                    end;
                    */
                }
                field(AJWOH_WebServiceCode; AJShippingHeader."Web Service Code")
                {
                    ApplicationArea = All;
                    Caption = 'Web Service Code';
                    Editable = false;
                    Importance = Additional;
                    QuickEntry = false;
                }
                field(AJWOH_ShpWebServiceCode; AJShippingHeader."Shipping Web Service Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Web Service Code';
                    QuickEntry = false;
                    TableRelation = "AJ Web Service".Code;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebService: Record "AJ Web Service";
                    begin

                        AJWebService.SetRange("Web Service Type", AJWebService."Web Service Type"::ShipStation);
                        if PAGE.RunModal(PAGE::"AJ Web Services", AJWebService) = ACTION::LookupOK then begin
                            AJShippingHeader."Shipping Web Service Code" := AJWebService.Code;
                            AJShippingHeader.Modify();
                        end;
                    end;

                    trigger OnValidate()
                    var
                        AJWebService: Record "AJ Web Service";
                    begin

                        if AJShippingHeader."Shipping Web Service Code" = '' then
                            AJShippingHeader.Init();
                        if AJWebService.Get(AJShippingHeader."Shipping Web Service Code") then begin
                            if AJShippingHeader."Shipping No." = '' then begin
                                AJShippingHeader.InitRecord("Shipping Agent Code");
                                Rec."Web Order No." := AJShippingHeader."Shipping No.";
                                Rec.Modify();
                            end;
                            AJShippingHeader."Shipping Web Service Code" := AJWebService.Code;
                            if AJShippingHeader."Web Service Code" = '' then
                                AJShippingHeader."Web Service Code" := AJWebService.Code;
                        end;

                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_SipFromWhseID; AJShippingHeader."Ship-From Warehouse ID")
                {
                    ApplicationArea = All;
                    Caption = 'Ship-From Warehouse ID';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJWebServiceWarehouse.SetRange("Web Service Code", AJShippingHeader."Shipping Web Service Code");
                        if PAGE.RunModal(PAGE::"AJ Web Service Warehouses", AJWebServiceWarehouse) = ACTION::LookupOK then begin
                            AJShippingHeader.Validate("Ship-From Warehouse ID", AJWebServiceWarehouse."Warehouse ID");
                            AJShippingHeader.Modify();
                        end;
                    end;

                }
                field(AJWOH_ShpCarrierCode; AJShippingHeader."Shipping Carrier Code")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Carrier Code';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebCarrier: Record "AJ Web Carrier";
                    begin

                        AJWebCarrier.SetRange("Web Service Code", AJShippingHeader."Shipping Web Service Code");
                        if PAGE.RunModal(PAGE::"AJ Web Carriers", AJWebCarrier) = ACTION::LookupOK then begin
                            AJShippingHeader.Validate("Shipping Carrier Code", AJWebCarrier.Code);
                            AJShippingHeader.Modify();

                            // Update Sales Order
                            if (AJWebCarrier."Shipment Method Code" <> '') and ("Shipment Method Code" <> AJWebCarrier."Shipment Method Code") then begin
                                "Shipment Method Code" := AJWebCarrier."Shipment Method Code";
                                "Shipping Agent Code" := AJWebCarrier."Shipping Agent  Code";
                                Modify();
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    var
                        AJWebCarrier: Record "AJ Web Carrier";
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();

                        // Update Sales Order
                        if AJWebCarrier.Get(AJShippingHeader."Shipping Web Service Code", AJShippingHeader."Shipping Carrier Code") then
                            if (AJWebCarrier."Shipment Method Code" <> '') and ("Shipment Method Code" <> AJWebCarrier."Shipment Method Code") then begin
                                "Shipment Method Code" := AJWebCarrier."Shipment Method Code";
                                "Shipping Agent Code" := AJWebCarrier."Shipping Agent  Code";
                                Modify();
                            end;
                    end;
                }
                field(AJWOH_ShpCarrierService; AJShippingHeader."Shipping Carrier Service")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Carrier Service';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebCarrierService: Record "AJ Web Carrier Service";
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJWebCarrierService.SetRange("Web Service Code", AJShippingHeader."Shipping Web Service Code");
                        AJWebCarrierService.SetRange("Web Carrier Code", AJShippingHeader."Shipping Carrier Code");
                        AJWebCarrierService.SetRange(Blocked, false);
                        if PAGE.RunModal(PAGE::"AJ Web Carrier Services", AJWebCarrierService) = ACTION::LookupOK then begin
                            AJShippingHeader."Shipping Carrier Service" := AJWebCarrierService."Service  Code";
                            AJShippingHeader.Modify();
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_ShpPackageType; AJShippingHeader."Shipping Package Type")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Package Type';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJWebCarrierPackageType.SetRange("Web Service Code", AJShippingHeader."Shipping Web Service Code");
                        AJWebCarrierPackageType.SetRange("Web Carrier Code", AJShippingHeader."Shipping Carrier Code");
                        AJWebCarrierPackageType.SetRange(Blocked, false);
                        if PAGE.RunModal(PAGE::"AJ Web Carier Package Types", AJWebCarrierPackageType) = ACTION::LookupOK then begin
                            AJShippingHeader."Shipping Package Type" := CopyStr(AJWebCarrierPackageType."Package Code", 1, MaxStrLen(AJShippingHeader."Shipping Package Type"));
                            AJShippingHeader.Modify();
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_ShpDeliveryConf; AJShippingHeader."Shipping Delivery Confirm")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Delivery Confirmation';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJShippingHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Confirmation);
                        AJWebServiceConstants.SetRange(Blocked, false);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJShippingHeader."Shipping Delivery Confirm" := AJWebServiceConstants."Option Value";
                            AJShippingHeader.Modify();
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_ShpOption; AJShippingHeader."Shipping Options")
                {
                    ApplicationArea = All;
                    Caption = 'Shipping Option';
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJShippingHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Option);
                        AJWebServiceConstants.SetRange(Blocked, false);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJShippingHeader."Shipping Options" := AJWebServiceConstants."Option Value";
                            AJShippingHeader.Modify();
                        end;
                    end;

                    trigger OnValidate()
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_PrdWgt; AJShippingHeader."Shp. Product Weight")
                {
                    ApplicationArea = All;
                    Caption = 'Product Weight';
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_PrdDim; AJShippingHeader."Shp. Product Weight Unit")
                {
                    ApplicationArea = All;
                    Caption = 'Product Weight Unit';
                    Importance = Additional;
                    QuickEntry = false;
                    TableRelation = "AJ Web Service Constants"."Option Value" WHERE(Type = CONST(Weight));

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJShippingHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Weight);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJShippingHeader."Shp. Product Weight Unit" := AJWebServiceConstants."Option Value";
                            AJShippingHeader.Modify();
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_PrdDimUnit; AJShippingHeader."Shp. Product Dimension Unit")
                {
                    ApplicationArea = All;
                    Caption = 'Product Dimension Unit';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        AJWebServiceConstants: Record "AJ Web Service Constants";
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJWebServiceConstants.SetRange("Web Order Service Code", AJShippingHeader."Shipping Web Service Code");
                        AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Dimension);
                        if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                            AJShippingHeader."Shp. Product Dimension Unit" := AJWebServiceConstants."Option Value";
                            AJShippingHeader.Modify();
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_PrdW; AJShippingHeader."Shp. Product Width")
                {
                    ApplicationArea = All;
                    Caption = 'Product Width';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_PrdL; AJShippingHeader."Shp. Product Length")
                {
                    ApplicationArea = All;
                    Caption = 'Product Length';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_PrdH; AJShippingHeader."Shp. Product Height")
                {
                    ApplicationArea = All;
                    Caption = 'Product Height';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_International; AJShippingHeader."International Shipment")
                {
                    ApplicationArea = All;
                    Caption = 'International';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                /*field(AJWOH_InsureShp; AJShippingHeader."Insure Shipment")
                {
                    ApplicationArea = All;
                    Caption = 'Insure Shipment';
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_InsuredValue; AJShippingHeader."Insured Value")
                {
                    ApplicationArea = All;
                    Caption = 'Insured Value';
                    QuickEntry = false;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                */
                field(AJWOH_AddInsValue; AJShippingHeader."Additional Insurance Value")
                {
                    ApplicationArea = All;
                    Caption = 'Additional Insurance Value';
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnValidate()
                    begin

                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_CODAmount; AJShippingHeader."COD Amount")
                {
                    ApplicationArea = All;
                    Caption = 'COD Amount';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.Modify();
                    end;
                }
                field(AJWOH_CarrierShpCharge; AJShippingHeader."Carier Shipping Charge")
                {
                    ApplicationArea = All;
                    Caption = 'Carrier Shipping Charge';
                    Editable = false;
                    QuickEntry = false;
                }
                field(AJWOH_CarrierTrackingNumber; AJShippingHeader."Carier Tracking Number")
                {
                    ApplicationArea = All;
                    Caption = 'Carrier Tracking#';
                    Editable = false;
                    QuickEntry = false;
                }
                field(AJWOH_CarrierInsuranceCost; AJShippingHeader."Carier Insurance Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Carrier Insurance Cost';
                    Editable = false;
                    QuickEntry = false;
                }
                field(AJWOH_PackagesShipHandAmount; AJShippingHeader."Packages Ship. & Hand. Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Packages S&H Amount';
                    Editable = false;
                    Importance = Additional;
                    QuickEntry = false;
                }
                field(AJWOH_PackagesCount; AJShippingHeader."Packages Count")
                {
                    ApplicationArea = All;
                    Caption = 'Packages';
                    Editable = false;
                    Importance = Additional;
                    QuickEntry = false;

                    trigger OnDrillDown()
                    var
                        AJWebPackage: Record "AJ Web Package";
                    begin

                        AJWebPackage.Reset();
                        AJWebPackage.SetCurrentKey("Source Type", "Source No.");
                        AJWebPackage.SetRange("Source Type", DATABASE::"AJ Shipping Header");
                        AJWebPackage.SetRange("Source No.", AJShippingHeader."Shipping No.");
                        PAGE.RunModal(0, AJWebPackage);
                    end;
                }
                field(AJWOH_CustomField2; AJShippingHeader."Customer Reference ID")
                {
                    ApplicationArea = All;
                    Caption = 'Custom Field 2';

                    trigger OnValidate()
                    begin
                        AJShippingHeader.TestField("Shipping Web Service Code");
                        AJShippingHeader.TestField("Created From Sales Order", true);
                        AJShippingHeader.Modify();
                    end;
                }
            }
        }
    }
    var
        AJShippingHeader: Record "AJ Shipping Header";

    /*local procedure GetShipLabels()
    var
        Customer: Record Customer;
        AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
        AJShippingMgmt: Codeunit "AJ Shipping Mgmt.";
        Wnd: Dialog;
        OrderCreated: Boolean;
    begin
        TestField(Status, Status::Open);
        Customer.Get("Sell-to Customer No.");
        Customer.TestField(Blocked, Customer.Blocked::" ");
        AJShippingHeader.TestField("Shipping Web Service Code");
        if not AJWebServiceWarehouse.Get(AJShippingHeader."Shipping Web Service Code", AJShippingHeader."Ship-From Warehouse ID") then
            Error('Web Order %1 does not have warehouse!', AJShippingHeader."Shipping No.");

        AJShippingHeader.TestField("Shipping Carrier Code");
        AJShippingHeader.TestField("Shipping Carrier Service");
        AJShippingHeader.TestField("Shipping Package Type");
        if AJShippingHeader."COD Status" = 0 then
            if ("Web Order No." = '') or (AJShippingHeader."Created From Sales Order") then begin
                AJShippingMgmt.CreateWebOrderFromSalesOrder(Rec, AJShippingHeader);
                Commit();
                OrderCreated := true;
            end;
        AJShippingHeader.CalcFields(Packages);
        if AJShippingHeader."Labels Created" then
            if Confirm('Label already exists! Do you want to cancel it and create new one?') then begin
                Wnd.Open('Cancelling shipping label...');
                //AJShippingMgmt.WOS_CancelOrderLabel(AJShippingHeader); // MBS commented            
                "Package Tracking No." := '';
                Modify();
                Commit();
                Wnd.Close();
            end else
                Error('Operation was cancelled');
        Wnd.Open('Requesting shipping label...');
        if AJShippingHeader.Get("Web Order No.") then begin
            AJShippingMgmt.GetOrderLabelParam(OrderCreated);
            AJShippingMgmt.GetOrderLabel(AJShippingHeader);
            "Package Tracking No." := AJShippingHeader."Carier Tracking Number";
            Validate("Posting Date", WorkDate());
            Modify(true);
        end;
        Wnd.Close();
        CurrPage.Update(false);
    end;

    var
        AJShippingSetup: Record "AJ Shipping Setup";
        AJShippingVisible: Boolean;

    trigger OnOpenPage()
    begin
        AJShippingSetup.Get();
        AJShippingVisible := AJShippingSetup."B2C Shipping";
    end;
    */
}

