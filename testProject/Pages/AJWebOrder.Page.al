page 37072309 "AJ Web Order"
{
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "AJ Web Order Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Web Order No."; "Web Order No.")
                {
                }
                field("Web Service Order ID"; "Web Service Order ID")
                {
                }
                field("Order DateTime"; "Order DateTime")
                {
                    Editable = false;
                }
                field("Created DateTime"; "Created DateTime")
                {
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
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
                field("Handling Amount"; "Handling Amount")
                {
                }
                field("Latest Ship Date"; "Latest Ship Date")
                {
                }
                field("Ship Date"; "Ship Date")
                {

                    trigger OnValidate()
                    var
                        dtm: DateTime;
                    begin
                        //vadimb 08162018 >
                        Evaluate(dtm, Format("Latest Ship Date", 9));
                        if "Ship Date" > DT2Date(dtm) then
                            Message('Latest Ship date is ' + Format(DT2Date(dtm)));
                    end;
                }
                field("Hold Until Date"; "Hold Until Date")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Ship-to Type"; "Ship-to Type")
                {
                    Editable = false;
                }
                field("Special Customer Account"; "Special Customer Account")
                {
                }
                field("Set Customer No. To"; "Set Customer No. To")
                {
                }
            }
            part(Control1000000043; "AJ Web Order Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Web Order No." = field("Web Order No.");
            }
            group("Bill-to")
            {
                field("Bill-To Customer Name"; "Bill-To Customer Name")
                {
                }
                field("Bill-To Company"; "Bill-To Company")
                {
                }
                field("Bill-To Customer Address 1"; "Bill-To Customer Address 1")
                {
                }
                field("Bill-To Customer Address 2"; "Bill-To Customer Address 2")
                {
                }
                field("Bill-To Customer Address 3"; "Bill-To Customer Address 3")
                {
                }
                field("Bill-To Customer City"; "Bill-To Customer City")
                {
                }
                field("Bill-To Customer Zip"; "Bill-To Customer Zip")
                {
                }
                field("Bill-To Customer State"; "Bill-To Customer State")
                {
                }
                field("Bill-To Customer Country"; "Bill-To Customer Country")
                {
                }
                field("Bill-To Customer Phone"; "Bill-To Customer Phone")
                {
                }
                field("Bill-To E-mail"; "Bill-To E-mail")
                {
                }
                field("Bill-To Verified"; "Bill-To Verified")
                {
                }
            }
            group("Ship-To")
            {
                field("Ship-To Customer Name"; "Ship-To Customer Name")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Company"; "Ship-To Company")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Address 1"; "Ship-To Customer Address 1")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Address 2"; "Ship-To Customer Address 2")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Address 3"; "Ship-To Customer Address 3")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer City"; "Ship-To Customer City")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Zip"; "Ship-To Customer Zip")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer State"; "Ship-To Customer State")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Country"; "Ship-To Customer Country")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Phone"; "Ship-To Customer Phone")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To E-mail"; "Ship-To E-mail")
                {

                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Address Verified"; "Ship-To Address Verified")
                {
                }
            }
            group("Payment Info")
            {
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
            group("Other Info")
            {
                field(Gift; Gift)
                {
                }
                field("Gift Message"; "Gift Message")
                {
                    Visible = false;
                }
                field("Custom Field 1"; "Custom Field 1")
                {
                }
                field("Custom Field 2"; "Custom Field 2")
                {
                }
                field("Custom Field 3"; "Custom Field 3")
                {
                }
                field("Enclousure Card Text"; "Enclousure Card Text")
                {
                }
                field("Order Instructions"; "Order Instructions")
                {
                }
            }
            group("Shipping Agent")
            {
                Visible = false;
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                }
                field("Shp. Method"; "Shp. Method")
                {
                }
                field("Shp. 3PL Warehouse"; "Shp. 3PL Warehouse")
                {
                }
                field("Shp. 3PL Name"; "Shp. 3PL Name")
                {
                }
                field("Shp. Product Weight"; "Shp. Product Weight")
                {
                }
                field("Shp. Product Weight Unit"; "Shp. Product Weight Unit")
                {
                }
                field("Shp. Product Width"; "Shp. Product Width")
                {
                }
                field("Shp. Product Length"; "Shp. Product Length")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Height"; "Shp. Product Height")
                {
                }
                field("Shp. Product Dimension Unit"; "Shp. Product Dimension Unit")
                {
                }
                field("Shp. Incoterms"; "Shp. Incoterms")
                {
                }
                field("Shp. Hts Code"; "Shp. Hts Code")
                {
                }
            }
            group("AJ Shipping")
            {
                group(Control1000000081)
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    ShowCaption = false;
                    field("Web Service Code"; "Web Service Code")
                    {
                        Editable = false;
                    }
                    field(AJWOH_ShpWebServiceCode; "Shipping Web Service Code")
                    {
                        Caption = 'Shipping Web Service Code';
                        TableRelation = "AJ Web Service".Code;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebService: Record "AJ Web Service";
                        begin
                            AJWebService.SetRange("Web Service Type", AJWebService."Web Service Type"::ShipStation);
                            if PAGE.RunModal(PAGE::"AJ Web Services", AJWebService) = ACTION::LookupOK then
                                Validate("Shipping Web Service Code", AJWebService.Code);
                        end;
                    }
                    field(AJWOH_SipFromWhseID; "Ship-From Warehouse ID")
                    {
                        Caption = 'Ship-From Warehouse ID';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceWarehouse.SetRange("Web Service Code", "Shipping Web Service Code");
                            if PAGE.RunModal(PAGE::"AJ Web Service Warehouses", AJWebServiceWarehouse) = ACTION::LookupOK then
                                Validate("Ship-From Warehouse ID", AJWebServiceWarehouse."Warehouse ID");
                        end;
                    }
                    field("Latest Delivery Date"; "Latest Delivery Date")
                    {
                        Editable = false;
                    }
                    field(AJWOH_ShpCarrierCode; "Shipping Carrier Code")
                    {
                        Caption = 'Shipping Carrier Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebCarrier: Record "AJ Web Carrier";
                        begin
                            AJWebCarrier.SetRange("Web Service Code", "Shipping Web Service Code");
                            if PAGE.RunModal(PAGE::"AJ Web Carriers", AJWebCarrier) = ACTION::LookupOK then
                                Validate("Shipping Carrier Code", AJWebCarrier.Code);
                        end;
                    }
                    field(AJWOH_ShpCarrierService; "Shipping Carrier Service")
                    {
                        Caption = 'Shipping Carrier Service';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebCarrierService: Record "AJ Web Carrier Service";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebCarrierService.SetRange("Web Service Code", "Shipping Web Service Code");
                            AJWebCarrierService.SetRange("Web Carrier Code", "Shipping Carrier Code");
                            if PAGE.RunModal(PAGE::"AJ Web Carrier Services", AJWebCarrierService) = ACTION::LookupOK then
                                Validate("Shipping Carrier Service", AJWebCarrierService."Service  Code");
                        end;
                    }
                    field(AJWOH_ShpPackageType; "Shipping Package Type")
                    {
                        Caption = 'Shipping Package Type';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebCarrierPackageType.SetRange("Web Service Code", "Shipping Web Service Code");
                            AJWebCarrierPackageType.SetRange("Web Carrier Code", "Shipping Carrier Code");
                            if PAGE.RunModal(PAGE::"AJ Web Carier Package Types", AJWebCarrierPackageType) = ACTION::LookupOK then
                                Validate("Shipping Package Type", AJWebCarrierPackageType."Package Code");
                        end;
                    }
                    field(AJWOH_ShpDeliveryConf; "Shipping Delivery Confirm")
                    {
                        Caption = 'Shipping Delivery Confirmation';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceConstants: Record "AJ Web Service Constants";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceConstants.SetRange("Web Order Service Code", "Shipping Web Service Code");
                            AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Confirmation);
                            if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then
                                Validate("Shipping Delivery Confirm", AJWebServiceConstants."Option Value");
                        end;

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdWgt; "Shp. Product Weight")
                    {
                        Caption = 'Product Weight';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdDim; "Shp. Product Weight Unit")
                    {
                        Caption = 'Product Weight Unit';
                        TableRelation = "AJ Web Service Constants"."Option Value" WHERE(Type = CONST(Weight));

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceConstants: Record "AJ Web Service Constants";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceConstants.SetRange("Web Order Service Code", "Shipping Web Service Code");
                            AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Weight);
                            if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then
                                "Shp. Product Weight Unit" := AJWebServiceConstants."Option Value";
                        end;

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdDimUnit; "Shp. Product Dimension Unit")
                    {
                        Caption = 'Product Dimension Unit';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceConstants: Record "AJ Web Service Constants";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceConstants.SetRange("Web Order Service Code", "Shipping Web Service Code");
                            AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Dimension);
                            if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then
                                "Shp. Product Dimension Unit" := AJWebServiceConstants."Option Value";
                        end;

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdW; "Shp. Product Width")
                    {
                        Caption = 'Product Width';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdL; "Shp. Product Length")
                    {
                        Caption = 'Product Lenght';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdH; "Shp. Product Height")
                    {
                        Caption = 'Product Height';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                }
                group(Control1000000082)
                {
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Columns;
                    ShowCaption = false;
                    field("International Shipment"; "International Shipment")
                    {
                    }
                    field(AJWOH_InsureShp; "Insure Shipment")
                    {
                        Caption = 'Insure Shipment';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_InsuredValue; "Insured Value")
                    {
                        Caption = 'Insured Value';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_AddInsValue; "Additional Insurance Value")
                    {
                        Caption = 'Additional Insurance Value';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_CarrierShpCharge; "Carier Shipping Charge")
                    {
                        Caption = 'Carrier Shipping Charge';
                        Editable = false;

                        trigger OnAssistEdit()
                        begin
                            AJWebOrderList.GetShippingLabel(Rec);
                        end;
                    }
                    field(AJWOH_CarrierTrackingNumber; "Carier Tracking Number")
                    {
                        Caption = 'Carrier Tracking#';
                        Editable = vCarrierTrackingEditable;
                    }
                    field(AJWOH_CarrierInsuranceCost; "Carier Insurance Cost")
                    {
                        Caption = 'Carrier Insurance Cost';
                        Editable = false;
                    }
                    field("Bill-to Type"; "Bill-to Type")
                    {
                    }
                    field("Bill-To Account"; "Bill-To Account")
                    {
                    }
                    field("Bill-To Postal Code"; "Bill-To Postal Code")
                    {
                    }
                    field("Bill-To Country Code"; "Bill-To Country Code")
                    {
                    }
                    field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
                    {
                        Editable = false;
                    }
                    field("COD Amount"; "COD Amount")
                    {
                    }
                    field("Shipping Service Criterion"; "Shipping Service Criterion")
                    {

                        trigger OnDrillDown()
                        var
                            WebOH: Record "AJ Web Order Header";
                        begin
                            /*//vadimb 03/12/2018 Amazon>
                            CarrierForOrderRec.SETRANGE(CarrierForOrderRec."Web Order No.", "Web Order No.");
                            CarrierForOrderPage.SETTABLEVIEW(CarrierForOrderRec);
                            CarrierForOrderPage.LOOKUPMODE(TRUE);
                            IF CarrierForOrderPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                              CarrierForOrderPage.GETRECORD(CarrierForOrderRec);
                              WebOH.GET("Web Order No.");
                              WebOH.VALIDATE("Shipping Carrier Code", CarrierForOrderRec."Carrier Name");
                              WebOH.VALIDATE("Shipping Carrier Service", CarrierForOrderRec.ShippingServiceName);
                              WebOH.VALIDATE("Shp. Hts Code", CarrierForOrderRec."Shipping Service Id");
                              WebOH.VALIDATE("Carier Shipping Charge", CarrierForOrderRec."Amount (USD)");
                              WebOH.VALIDATE("Ship Date", CarrierForOrderRec."Ship Date");
                              WebOH.MODIFY;
                            END;
                            //vadimb 03/12/2018 <
                            */

                        end;
                    }
                }
            }
            part(Control1000000078; "AJ Web Package Part")
            {
<<<<<<< HEAD
                ApplicationArea = All;
                SubPageLink = "Source Type" = CONST(37074833),
                              "Source No." = FIELD("Web Order No.");
=======
                SubPageLink = "Source Type" = CONST (37074833),
                              "Source No." = FIELD ("Web Order No.");
>>>>>>> 6e91b92a1581846d2b492fa0c0622688712c68a3
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Send Ship Confirmation")
            {
            }
            action("Unlock Tracking#")
            {

                trigger OnAction()
                begin
                    PageUnlockTracking(true);
                end;
            }
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
<<<<<<< HEAD
                        AJWebOrderHeader.FindFirst();
                        AJWebShipstationMgmt.GetOrderLabel(AJWebOrderHeader);
=======

                        AJWebOrderList.GetShippingLabel(AJWebOrderHeader);

>>>>>>> 6e91b92a1581846d2b492fa0c0622688712c68a3
                        Message('Done');
                    end;
                }
                action("Save Shipping Label")
                {

                    trigger OnAction()
                    var
                        AJWebOrderHeader: Record "AJ Web Order Header";
                        //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                    begin
<<<<<<< HEAD
                        CurrPage.SETSELECTIONFILTER(AJWebOrderHeader);
                        AJWebOrderHeader.FindFirst();
                        AJWebShipstationMgmt.SaveLabel(AJWebOrderHeader);
=======
                        // CurrPage.SETSELECTIONFILTER(AJWebOrderHeader);
                        // AJWebOrderHeader.FINDFIRST;
                        // AJWebOrderServiceMgmt.WOS_MergeSaveLabel(AJWebOrderHeader);
                        if AJWebOrderHeader.FindFirst then
                            repeat
                            //AJWebOrderServiceMgmt.WOS_SaveLabel(AJWebOrderHeader);
                            until AJWebOrderHeader.Next = 0;
>>>>>>> 6e91b92a1581846d2b492fa0c0622688712c68a3
                    end;
                }
            }
            group(ShipStation)
            {
                action("Export Order Text")
                {

                    trigger OnAction()
                    var
                        TempBlob: Record TempBlob temporary;
                        FileManagement: Codeunit "File Management";
                    begin
                        CalcFields("Created Order Text");
                        if not Rec."Created Order Text".HasValue() then
                            Error('There is no Order Text loaded!');
                        TempBlob.Blob := "Created Order Text";
                        FileManagement.BLOBExport(TempBlob, "Web Service Order ID" + '.JSON', true);
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        //>> 3175415
        if AJWebService.Get("Web Service Code") then
            if not AJWebService."Allow to Delete WebOrder" then
                Error('You cannot delete Web Order!');
        //<< 3175415
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        PageUnlockTracking(false);

        ResultSteps := Rec.Next(Steps);

        exit(ResultSteps);
    end;

    trigger OnOpenPage()
    begin
        if not AJWebService.Get("Web Service Code") then
            AJWebService.Init();

        PageUnlockTracking(false);
    end;

    var
        // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
        AJWebService: Record "AJ Web Service";
        vCarrierTrackingEditable: Boolean;

    local procedure PageUnlockTracking(SetEnable: Boolean)
    begin
        vCarrierTrackingEditable := SetEnable;
    end;
}

