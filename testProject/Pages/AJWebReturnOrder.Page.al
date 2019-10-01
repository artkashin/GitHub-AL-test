page 37072319 "AJ Web Return Order"
{
    PageType = Document;
    PopulateAllFields = true;
    SourceTable = "AJ Web Order Header";
    SourceTableView = WHERE("Document Type" = CONST(Return));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Web Order No."; "Web Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Web Return No.';
                }
                field("Web Service Order ID"; "Web Service Order ID")
                {
                    ApplicationArea = All;
                    Caption = 'Web Service Return ID';
                }
                field("Order DateTime"; "Order DateTime")
                {
                    ApplicationArea = All;
                    Caption = 'Return DateTime';
                }
                field("Apply-To Web Order No."; "Apply-To Web Order No.")
                {
                    ApplicationArea = All;
                }
                field("Apply-To Web Service Order ID"; "Apply-To Web Service Order ID")
                {
                    ApplicationArea = All;
                }
                field(agree_to_return_charge; agree_to_return_charge)
                {
                    ApplicationArea = All;
                    Caption = 'Agree To Return Charge';
                }
                field(merchant_return_charge; merchant_return_charge)
                {
                    ApplicationArea = All;
                    Caption = 'Merchant Return Charge';
                }
                field(return_charge_feedback; return_charge_feedback)
                {
                    ApplicationArea = All;
                    Caption = 'Return Charge Feedback';
                }
                field(refund_without_return; refund_without_return)
                {
                    ApplicationArea = All;
                    Caption = 'Refund Without Return';
                }
            }
            part(Control1000000043; "AJ Web Return Order Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Web Order No." = FIELD("Web Order No.");
            }
            group("Ship-To")
            {
                Caption = 'Return Location';
                field("Ship-To Customer Address 1"; "Ship-To Customer Address 1")
                {
                    ApplicationArea = All;
                    Caption = 'Address 1';
                }
                field("Ship-To Customer Address 2"; "Ship-To Customer Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                }
                field("Ship-To Customer Zip"; "Ship-To Customer Zip")
                {
                    ApplicationArea = All;
                    Caption = 'Zip';
                }
                field("Ship-To Customer Country"; "Ship-To Customer Country")
                {
                    ApplicationArea = All;
                    Caption = 'Country';
                }
                field("Ship-To Customer State"; "Ship-To Customer State")
                {
                    ApplicationArea = All;
                    Caption = 'State';
                }
                field("Ship-To Customer City"; "Ship-To Customer City")
                {
                    ApplicationArea = All;
                    Caption = 'City';
                }
            }
            group("Shipping Agent")
            {
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                    ApplicationArea = All;
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                    ApplicationArea = All;
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}

