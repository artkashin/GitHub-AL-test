page 37072312 "AJ Web Package"
{
    PageType = Card;
    SourceTable = "AJ Web Package";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source No."; "Source No.")
                {
                    ApplicationArea = All;
                }
                field("Container ID"; "Container ID")
                {
                    ApplicationArea = All;
                }
                field("Carier Shipping Charge"; "Carier Shipping Charge")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Carier Insurance Cost"; "Carier Insurance Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("Shipping & Handling Amount"; "Shipping & Handling Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Label Created"; "Label Created")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Label Printed"; "Label Printed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group(Carrier)
            {
                field("Shipping Web Service Code"; "Shipping Web Service Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Web Service Store ID"; "Shipping Web Service Store ID")
                {
                    ApplicationArea = All;
                }
                field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
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
                field("Shipping Delivery Confirm"; "Shipping Delivery Confirm")
                {
                    ApplicationArea = All;
                }
                field("Insure Shipment"; "Insure Shipment")
                {
                    ApplicationArea = All;
                }
                field("Insured Value"; "Insured Value")
                {
                    ApplicationArea = All;
                }
                field("Additional Insurance Value"; "Additional Insurance Value")
                {
                    ApplicationArea = All;
                }
            }
            group(Package)
            {
                field("Shipping Package Type"; "Shipping Package Type")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Weight Unit"; "Shp. Product Weight Unit")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Weight"; "Shp. Product Weight")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Dimension Unit"; "Shp. Product Dimension Unit")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Width"; "Shp. Product Width")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Length"; "Shp. Product Length")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Height"; "Shp. Product Height")
                {
                    ApplicationArea = All;
                }
            }
            group("Bill-to")
            {
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
            }
            group(Other)
            {
                field("Ship Date"; "Ship Date")
                {
                    ApplicationArea = All;
                }
                field("Shipment No."; "Shipment No.")
                {
                    ApplicationArea = All;
                }
                field("Invoice No."; "Invoice No.")
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
                field("Invoice Send DateTime"; "Invoice Send DateTime")
                {
                    ApplicationArea = All;
                }
                field("Shipment Send DateTime"; "Shipment Send DateTime")
                {
                    ApplicationArea = All;
                }
            }
            part(Items; "AJ Web Package Sub")
            {
                ApplicationArea = All;
                SubPageLink = "Package No." = FIELD("No.");
            }
        }
    }

    actions
    {
    }
}

