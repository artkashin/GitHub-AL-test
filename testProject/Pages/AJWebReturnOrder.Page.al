page 37076043 "AJ Web Return Order"
{
    PageType = Document;
    PopulateAllFields = true;
    SourceTable = "AJ Web Order Header";
    SourceTableView = WHERE("Document Type"=CONST(Return));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Web Order No.";"Web Order No.")
                {
                    Caption = 'Web Return No.';
                }
                field("Web Service Order ID";"Web Service Order ID")
                {
                    Caption = 'Web Service Return ID';
                }
                field("Order DateTime";"Order DateTime")
                {
                    Caption = 'Return DateTime';
                }
                field("Apply-To Web Order No.";"Apply-To Web Order No.")
                {
                }
                field("Apply-To Web Service Order ID";"Apply-To Web Service Order ID")
                {
                }
                field(agree_to_return_charge;agree_to_return_charge)
                {
                    Caption = 'Agree To Return Charge';
                }
                field(merchant_return_charge;merchant_return_charge)
                {
                    Caption = 'Merchant Return Charge';
                }
                field(return_charge_feedback;return_charge_feedback)
                {
                    Caption = 'Return Charge Feedback';
                }
                field(refund_without_return;refund_without_return)
                {
                    Caption = 'Refund Without Return';
                }
            }
            part(Control1000000043;"AJ Web Return Order Subform")
            {
                SubPageLink = "Web Order No."=FIELD("Web Order No.");
            }
            group("Ship-To")
            {
                Caption = 'Return Location';
                field("Ship-To Customer Address 1";"Ship-To Customer Address 1")
                {
                    Caption = 'Address 1';
                }
                field("Ship-To Customer Address 2";"Ship-To Customer Address 2")
                {
                    Caption = 'Address 2';
                }
                field("Ship-To Customer Zip";"Ship-To Customer Zip")
                {
                    Caption = 'Zip';
                }
                field("Ship-To Customer Country";"Ship-To Customer Country")
                {
                    Caption = 'Country';
                }
                field("Ship-To Customer State";"Ship-To Customer State")
                {
                    Caption = 'State';
                }
                field("Ship-To Customer City";"Ship-To Customer City")
                {
                    Caption = 'City';
                }
            }
            group("Shipping Agent")
            {
                field("Shipping Carrier Code";"Shipping Carrier Code")
                {
                }
                field("Shipping Carrier Service";"Shipping Carrier Service")
                {
                }
                field("Carier Tracking Number";"Carier Tracking Number")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

