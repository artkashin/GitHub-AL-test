page 37072323 "AJ Shipping Subform"
{
    DeleteAllowed = true;
    PageType = ListPart;
    SourceTable = "AJ Shipping Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source ID"; "Source ID")
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


                field(SKU; SKU)
                {
                    ApplicationArea = All;
                }
                field(UPC; UPC)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fulfillment Lineitem Id"; "Fulfillment Lineitem Id")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }

                field("Qty. to Pack"; "Qty. to Pack")
                {
                    ApplicationArea = All;
                }
                field("Quantity Packed"; "Quantity Packed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. to Cancel"; "Qty. to Cancel")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quantity Cancelled"; "Quantity Cancelled")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Qty. to Return"; "Qty. to Return")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Quantity Returned"; "Quantity Returned")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
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
                field(Weight; Weight)
                {
                    ApplicationArea = All;
                }
                field("Weigh Unit"; "Weigh Unit")
                {
                    ApplicationArea = All;
                }
                field("Warehouse Location"; "Warehouse Location")
                {
                    ApplicationArea = All;
                }
                field("Retail Unit Price"; "Retail Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Gift Message"; "Gift Message")
                {
                    ApplicationArea = All;
                }
                field("Item Option 1"; "Item Option 1")
                {
                    ApplicationArea = All;
                }
                field("Item Option 1 Value"; "Item Option 1 Value")
                {
                    ApplicationArea = All;
                }
                field("Item Option 2"; "Item Option 2")
                {
                    ApplicationArea = All;
                }
                field("Item Option 2 Value"; "Item Option 2 Value")
                {
                    ApplicationArea = All;
                    Caption = '<Item Option 2 Value>';
                }
            }
        }
    }

    actions
    {
    }
}

