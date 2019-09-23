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
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Container ID"; "Container ID")
                {
                }
                field("Carier Shipping Charge"; "Carier Shipping Charge")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                    Editable = false;
                }
                field("Carier Insurance Cost"; "Carier Insurance Cost")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Shipping & Handling Amount"; "Shipping & Handling Amount")
                {
                    Editable = false;
                }
                field("Label Created"; "Label Created")
                {
                    Editable = false;
                }
                field("Label Printed"; "Label Printed")
                {
                    Editable = false;
                }
            }
            group(Carrier)
            {
                field("Shipping Web Service Code"; "Shipping Web Service Code")
                {
                }
                field("Shipping Web Service Store ID"; "Shipping Web Service Store ID")
                {
                }
                field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
                {
                }
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                }
                field("Shipping Delivery Confirm"; "Shipping Delivery Confirm")
                {
                }
                field("Insure Shipment"; "Insure Shipment")
                {
                }
                field("Insured Value"; "Insured Value")
                {
                }
                field("Additional Insurance Value"; "Additional Insurance Value")
                {
                }
            }
            group(Package)
            {
                field("Shipping Package Type"; "Shipping Package Type")
                {
                }
                field("Shp. Product Weight Unit"; "Shp. Product Weight Unit")
                {
                }
                field("Shp. Product Weight"; "Shp. Product Weight")
                {
                }
                field("Shp. Product Dimension Unit"; "Shp. Product Dimension Unit")
                {
                }
                field("Shp. Product Width"; "Shp. Product Width")
                {
                }
                field("Shp. Product Length"; "Shp. Product Length")
                {
                }
                field("Shp. Product Height"; "Shp. Product Height")
                {
                }
            }
            group("Bill-to")
            {
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
            }
            group(Other)
            {
                field("Ship Date"; "Ship Date")
                {
                }
                field("Shipment No."; "Shipment No.")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Shipping Advice"; "Shipping Advice")
                {
                }
                field("Invoice Advice"; "Invoice Advice")
                {
                }
                field("Invoice Send DateTime"; "Invoice Send DateTime")
                {
                }
                field("Shipment Send DateTime"; "Shipment Send DateTime")
                {
                }
            }
            part(Items; "AJ Web Package Sub")
            {
                SubPageLink = "Package No." = FIELD ("No.");
            }
        }
    }

    actions
    {
    }
}

