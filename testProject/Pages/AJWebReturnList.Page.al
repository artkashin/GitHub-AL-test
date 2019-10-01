page 37072318 "AJ Web Return List"
{
    CardPageID = "AJ Web Return Order";
    Editable = false;
    PageType = List;
    SourceTable = "AJ Web Order Header";
    SourceTableView = WHERE("Document Type" = CONST(Return));

    layout
    {
        area(content)
        {
            repeater(Group)
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
                }
                field("Apply-To Web Order No."; "Apply-To Web Order No.")
                {
                    ApplicationArea = All;
                }
                field("Apply-To Web Service Order ID"; "Apply-To Web Service Order ID")
                {
                    ApplicationArea = All;
                }
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                    ApplicationArea = All;
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                    ApplicationArea = All;
                }
                field("NAV Order Status"; "NAV Order Status")
                {
                    ApplicationArea = All;
                }
                field("NAV Order Count"; "NAV Order Count")
                {
                    ApplicationArea = All;
                }
                field("NAV Error Text"; "NAV Error Text")
                {
                    ApplicationArea = All;
                }
                field(agree_to_return_charge; agree_to_return_charge)
                {
                    ApplicationArea = All;
                }
                field(refund_without_return; refund_without_return)
                {
                    ApplicationArea = All;
                }
                field(return_charge_feedback; return_charge_feedback)
                {
                    ApplicationArea = All;
                }
                field(merchant_return_charge; merchant_return_charge)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

