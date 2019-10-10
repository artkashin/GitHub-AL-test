page 37072322 "AJ Shipping"
{
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "AJ Shipping Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Shipping No."; "Shipping No.")
                {
                    ApplicationArea = All;
                }
                field("Web Service Order ID"; "Web Service Order ID")
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
            }
            group("Ship-from")
            {
                field("Ship-from Location Code"; "Ship-from Location Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Name"; "Ship-from Name")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Company"; "Ship-from Company")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Address 1"; "Ship-from Address 1")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Address 2"; "Ship-from Address 2")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Address 3"; "Ship-from Address 3")
                {
                    ApplicationArea = All;
                }
                field("Ship-from City"; "Ship-from City")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Zip"; "Ship-from Zip")
                {
                    ApplicationArea = All;
                }
                field("Ship-from State"; "Ship-from State")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Country"; "Ship-from Country Code")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Phone"; "Ship-from Phone")
                {
                    ApplicationArea = All;
                }
                field("Ship-from E-mail"; "Ship-from E-mail")
                {
                    ApplicationArea = All;
                }
                field("Ship-from Verified"; "Ship-from Verified")
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
                        Modify();
                    end;
                }
                field("Ship-To Company"; "Ship-To Company")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Address 1"; "Ship-To Customer Address 1")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Address 2"; "Ship-To Customer Address 2")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Address 3"; "Ship-To Customer Address 3")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer City"; "Ship-To Customer City")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Zip"; "Ship-To Customer Zip")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer State"; "Ship-To Customer State")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Country"; "Ship-To Customer Country")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Customer Phone"; "Ship-To Customer Phone")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To E-mail"; "Ship-To E-mail")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Modify();
                    end;
                }
                field("Ship-To Address Verified"; "Ship-To Address Verified")
                {
                    ApplicationArea = All;
                }
            }

            part(Control1000000043; "AJ Shipping Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Shipping No." = field("Shipping No.");
            }

            group("Other Info")
            {
                Visible = false;
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
                    }
                    field(AJWOH_ShpWebServiceCode; "Shipping Web Service Code")
                    {
                        ApplicationArea = All;
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
                        ApplicationArea = All;
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
                            if PAGE.RunModal(PAGE::"AJ Web Carriers", AJWebCarrier) = ACTION::LookupOK then
                                Validate("Shipping Carrier Code", AJWebCarrier.Code);
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
                            if PAGE.RunModal(PAGE::"AJ Web Carrier Services", AJWebCarrierService) = ACTION::LookupOK then
                                Validate("Shipping Carrier Service", AJWebCarrierService."Service  Code");
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
                            if PAGE.RunModal(PAGE::"AJ Web Carier Package Types", AJWebCarrierPackageType) = ACTION::LookupOK then
                                Validate("Shipping Package Type", AJWebCarrierPackageType."Package Code");
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
                        ApplicationArea = All;
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
                    field("Ship-from Type"; "Ship-from Type")
                    {
                        ApplicationArea = All;
                    }
                    field("Ship-from Account"; "Ship-from Account")
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
        }
    }

    actions
    {
        area(processing)
        {
            group("Filling")
            {
                action("Get Sales Header")
                {
                    ApplicationArea = All;
                    Promoted = false;
                    Caption = 'Get Lines From Sales Hader';
                    trigger OnAction()
                    var
                        AJShippingLine: Record "AJ Shipping Line";
                        SalesList: Page "Sales List";
                    begin
                        AJShippingLine."Shipping No." := Rec."Shipping No.";
                        SalesList.SetLookupForAJShipping(AJShippingLine);
                        SalesList.LookupMode(true);
                        SalesList.RunModal();
                        Message('Done');
                    end;
                }
            }
            group("Shipping Label")
            {
                Caption = 'Shipping Label';
                action("Get Shipping Label")
                {
                    ApplicationArea = All;
                    Promoted = false;
                    Caption = 'Get Shipping Label';
                    trigger OnAction()
                    var
                        AjShippingHeader: Record "AJ Shipping Header";
                        AJShippingMgmt: Codeunit "AJ Shipping Mgmt.";
                    begin
                        CurrPage.SetSelectionFilter(AjShippingHeader);
                        AjShippingHeader.FindFirst();
                        AJShippingMgmt.GetLabel(AjShippingHeader);
                        Message('Done');
                    end;
                }
                action("Save Shipping Label")
                {
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        AjShippingHeader: Record "AJ Shipping Header";
                        AJShippingMgmt: Codeunit "AJ Shipping Mgmt.";
                    begin
                        CurrPage.SETSELECTIONFILTER(AjShippingHeader);
                        AjShippingHeader.FindFirst();
                        AJShippingMgmt.SaveLabel(AjShippingHeader);
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
        if AJWebService.Get("Web Service Code") then
            if not AJWebService."Allow to Delete WebOrder" then
                Error('You cannot delete Web Order!');
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
        AJWebService: Record "AJ Web Service";
        vCarrierTrackingEditable: Boolean;

    local procedure PageUnlockTracking(SetEnable: Boolean)
    begin
        vCarrierTrackingEditable := SetEnable;
    end;
}

