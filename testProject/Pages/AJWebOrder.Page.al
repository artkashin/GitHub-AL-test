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
                    ApplicationArea = All;
                }
                field("Web Service Order ID"; "Web Service Order ID")
                {
                    ApplicationArea = All;
                }
                field("Order DateTime"; "Order DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Created DateTime"; "Created DateTime")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Total Amount"; "Total Amount")
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
                field("Handling Amount"; "Handling Amount")
                {
                    ApplicationArea = All;
                }
                field("Latest Ship Date"; "Latest Ship Date")
                {
                    ApplicationArea = All;
                }
                field("Ship Date"; "Ship Date")
                {
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                }
                field("Invoice No."; "Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Ship-to Type"; "Ship-to Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Special Customer Account"; "Special Customer Account")
                {
                    ApplicationArea = All;
                }
                field("Set Customer No. To"; "Set Customer No. To")
                {
                    ApplicationArea = All;
                }
            }
            part(Control1000000043; "AJ Web Order Subform")
            {
                SubPageLink = "Web Order No." = FIELD ("Web Order No.");
            }
            group("Bill-to")
            {
                field("Bill-To Customer Name"; "Bill-To Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Company"; "Bill-To Company")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer Address 1"; "Bill-To Customer Address 1")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer Address 2"; "Bill-To Customer Address 2")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer Address 3"; "Bill-To Customer Address 3")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer City"; "Bill-To Customer City")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer Zip"; "Bill-To Customer Zip")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer State"; "Bill-To Customer State")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer Country"; "Bill-To Customer Country")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Customer Phone"; "Bill-To Customer Phone")
                {
                    ApplicationArea = All;
                }
                field("Bill-To E-mail"; "Bill-To E-mail")
                {
                    ApplicationArea = All;
                }
                field("Bill-To Verified"; "Bill-To Verified")
                {
                    ApplicationArea = All;
                }
            }
            group("Ship-To")
            {
                field("Ship-To Customer Name"; "Ship-To Customer Name")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Company"; "Ship-To Company")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer Address 1"; "Ship-To Customer Address 1")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer Address 2"; "Ship-To Customer Address 2")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer Address 3"; "Ship-To Customer Address 3")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer City"; "Ship-To Customer City")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer Zip"; "Ship-To Customer Zip")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer State"; "Ship-To Customer State")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer Country"; "Ship-To Customer Country")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Customer Phone"; "Ship-To Customer Phone")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To E-mail"; "Ship-To E-mail")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify;
                    end;
                }
                field("Ship-To Address Verified"; "Ship-To Address Verified")
                {
                    ApplicationArea = All;
                }
            }
            group("Payment Info")
            {
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
            group("Other Info")
            {
                field(Gift; Gift)
                {
                    ApplicationArea = All;
                }
                field("Gift Message"; "Gift Message")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Custom Field 1"; "Custom Field 1")
                {
                    ApplicationArea = All;
                }
                field("Custom Field 2"; "Custom Field 2")
                {
                    ApplicationArea = All;
                }
                field("Custom Field 3"; "Custom Field 3")
                {
                    ApplicationArea = All;
                }
                field("Enclousure Card Text"; "Enclousure Card Text")
                {
                    ApplicationArea = All;
                }
                field("Order Instructions"; "Order Instructions")
                {
                    ApplicationArea = All;
                }
            }
            group("Shipping Agent")
            {
                Visible = false;
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                    ApplicationArea = All;
                }
                field("Shp. Method"; "Shp. Method")
                {
                    ApplicationArea = All;
                }
                field("Shp. 3PL Warehouse"; "Shp. 3PL Warehouse")
                {
                    ApplicationArea = All;
                }
                field("Shp. 3PL Name"; "Shp. 3PL Name")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Weight"; "Shp. Product Weight")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Weight Unit"; "Shp. Product Weight Unit")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Width"; "Shp. Product Width")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Length"; "Shp. Product Length")
                {
                }
                field("Shp. Product Height"; "Shp. Product Height")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Dimension Unit"; "Shp. Product Dimension Unit")
                {
                    ApplicationArea = All;
                }
                field("Shp. Incoterms"; "Shp. Incoterms")
                {
                    ApplicationArea = All;
                }
                field("Shp. Hts Code"; "Shp. Hts Code")
                {
                    ApplicationArea = All;
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
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(AJWOH_ShpWebServiceCode; "Shipping Web Service Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Shipping Web Service Code';
                        TableRelation = "AJ Web Service".Code;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebService: Record "AJ Web Service";
                            AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                        begin
                            AJWebService.SetRange("Web Service Type", AJWebService."Web Service Type"::ShipStation);
                            if PAGE.RunModal(PAGE::"AJ Web Services", AJWebService) = ACTION::LookupOK then begin
                                Validate("Shipping Web Service Code", AJWebService.Code);
                            end;
                        end;
                    }
                    field(AJWOH_SipFromWhseID; "Ship-From Warehouse ID")
                    {
                        ApplicationArea = All;
                        Caption = 'Ship-From Warehouse ID';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceWarehouse.SetRange("Web Service Code", "Shipping Web Service Code");
                            if PAGE.RunModal(PAGE::"AJ Web Service Warehouses", AJWebServiceWarehouse) = ACTION::LookupOK then begin
                                Validate("Ship-From Warehouse ID", AJWebServiceWarehouse."Warehouse ID");
                            end;
                        end;

                        trigger OnValidate()
                        var
                            AJWebServiceWarehouse: Record "AJ Web Service Warehouse";
                            AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                        begin
                        end;
                    }
                    field("Latest Delivery Date"; "Latest Delivery Date")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field(AJWOH_ShpCarrierCode; "Shipping Carrier Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Shipping Carrier Code';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebCarrier: Record "AJ Web Carrier";
                        begin
                            AJWebCarrier.SetRange("Web Service Code", "Shipping Web Service Code");
                            if PAGE.RunModal(PAGE::"AJ Web Carriers", AJWebCarrier) = ACTION::LookupOK then begin
                                Validate("Shipping Carrier Code", AJWebCarrier.Code);
                            end;
                        end;
                    }
                    field(AJWOH_ShpCarrierService; "Shipping Carrier Service")
                    {
                        ApplicationArea = All;
                        Caption = 'Shipping Carrier Service';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebCarrierService: Record "AJ Web Carrier Service";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebCarrierService.SetRange("Web Service Code", "Shipping Web Service Code");
                            AJWebCarrierService.SetRange("Web Carrier Code", "Shipping Carrier Code");
                            if PAGE.RunModal(PAGE::"AJ Web Carrier Services", AJWebCarrierService) = ACTION::LookupOK then begin
                                Validate("Shipping Carrier Service", AJWebCarrierService."Service  Code");
                            end;
                        end;
                    }
                    field(AJWOH_ShpPackageType; "Shipping Package Type")
                    {
                        ApplicationArea = All;
                        Caption = 'Shipping Package Type';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebCarrierPackageType.SetRange("Web Service Code", "Shipping Web Service Code");
                            AJWebCarrierPackageType.SetRange("Web Carrier Code", "Shipping Carrier Code");
                            if PAGE.RunModal(PAGE::"AJ Web Carier Package Types", AJWebCarrierPackageType) = ACTION::LookupOK then begin
                                Validate("Shipping Package Type", AJWebCarrierPackageType."Package Code");
                            end;
                        end;

                        trigger OnValidate()
                        var
                            AJWebCarrierPackageType: Record "AJ Web Carrier Package Type";
                        begin
                        end;
                    }
                    field(AJWOH_ShpDeliveryConf; "Shipping Delivery Confirm")
                    {
                        ApplicationArea = All;
                        Caption = 'Shipping Delivery Confirmation';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceConstants: Record "AJ Web Service Constants";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceConstants.SetRange("Web Order Service Code", "Shipping Web Service Code");
                            AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Confirmation);
                            if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                                Validate("Shipping Delivery Confirm", AJWebServiceConstants."Option Value"); // SK 5/18/2017 change to validate
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdWgt; "Shp. Product Weight")
                    {
                        ApplicationArea = All;
                        Caption = 'Product Weight';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdDim; "Shp. Product Weight Unit")
                    {
                        ApplicationArea = All;
                        Caption = 'Product Weight Unit';
                        TableRelation = "AJ Web Service Constants"."Option Value" WHERE (Type = CONST (Weight));

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceConstants: Record "AJ Web Service Constants";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceConstants.SetRange("Web Order Service Code", "Shipping Web Service Code");
                            AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Weight);
                            if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                                "Shp. Product Weight Unit" := AJWebServiceConstants."Option Value";
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdDimUnit; "Shp. Product Dimension Unit")
                    {
                        ApplicationArea = All;
                        Caption = 'Product Dimension Unit';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AJWebServiceConstants: Record "AJ Web Service Constants";
                        begin
                            TestField("Shipping Web Service Code");
                            AJWebServiceConstants.SetRange("Web Order Service Code", "Shipping Web Service Code");
                            AJWebServiceConstants.SetRange(Type, AJWebServiceConstants.Type::Dimension);
                            if PAGE.RunModal(0, AJWebServiceConstants) = ACTION::LookupOK then begin
                                "Shp. Product Dimension Unit" := AJWebServiceConstants."Option Value";
                            end;
                        end;

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdW; "Shp. Product Width")
                    {
                        ApplicationArea = All;
                        Caption = 'Product Width';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdL; "Shp. Product Length")
                    {
                        ApplicationArea = All;
                        Caption = 'Product Lenght';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_PrdH; "Shp. Product Height")
                    {
                        ApplicationArea = All;
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
                        ApplicationArea = All;
                    }
                    field(AJWOH_InsureShp; "Insure Shipment")
                    {
                        ApplicationArea = All;
                        Caption = 'Insure Shipment';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_InsuredValue; "Insured Value")
                    {
                        ApplicationArea = All;
                        Caption = 'Insured Value';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }
                    field(AJWOH_AddInsValue; "Additional Insurance Value")
                    {
                        ApplicationArea = All;
                        Caption = 'Additional Insurance Value';

                        trigger OnValidate()
                        begin
                            TestField("Shipping Web Service Code");
                        end;
                    }

                    field(AJWOH_CarrierTrackingNumber; "Carier Tracking Number")
                    {
                        ApplicationArea = All;
                        Caption = 'Carrier Tracking#';
                        Editable = vCarrierTrackingEditable;
                    }
                    field(AJWOH_CarrierInsuranceCost; "Carier Insurance Cost")
                    {
                        ApplicationArea = All;
                        Caption = 'Carrier Insurance Cost';
                        Editable = false;
                    }
                    field("Bill-to Type"; "Bill-to Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Bill-To Account"; "Bill-To Account")
                    {
                        ApplicationArea = All;
                    }
                    field("Bill-To Postal Code"; "Bill-To Postal Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Bill-To Country Code"; "Bill-To Country Code")
                    {
                        ApplicationArea = All;
                    }
                    field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("COD Amount"; "COD Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Shipping Service Criterion"; "Shipping Service Criterion")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part(Control1000000078; "AJ Web Package Part")
            {
                ApplicationArea = All;
                SubPageLink = "Source Type" = CONST (37074833),
                              "Source No." = FIELD ("Web Order No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Unlock Tracking#")
            {
                ApplicationArea = All;
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
                    ApplicationArea = All;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    trigger OnAction()
                    var
                        AJWebOrderHeader: Record "AJ Web Order Header";
                        AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                    begin
                        CurrPage.SetSelectionFilter(AJWebOrderHeader);
                        AJWebShipstationMgmt.Run();
                        Message('Done');
                    end;
                }
                action("Save Shipping Label")
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        AJWebOrderHeader: Record "AJ Web Order Header";
                        AJWebShipstationMgmt: Codeunit "AJ Web Shipstation Mgmt.";
                    begin
                        CurrPage.SETSELECTIONFILTER(AJWebOrderHeader);
                        AJWebOrderHeader.FINDFIRST;
                        AJWebShipstationMgmt.ShipStation_SaveLabel(AJWebOrderHeader);
                    end;
                }
            }
            group(ShipStation)
            {
                action("Export Order Text")
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        FileManagement: Codeunit "File Management";
                        TempBlob: Record TempBlob temporary;
                    begin
                        CalcFields("Created Order Text");
                        if not Rec."Created Order Text".HasValue then
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
            AJWebService.Init;

        PageUnlockTracking(false);
    end;

    var
        // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
        vAmazonPrime: Boolean;
        AJWebService: Record "AJ Web Service";
        vCarrierTrackingEditable: Boolean;
        AJWebOrderList: Page "AJ Web Order List";

    local procedure PageUnlockTracking(SetEnable: Boolean)
    begin
        vCarrierTrackingEditable := SetEnable;
    end;
}

