page 37076045 "AJ Web Return List"
{
    CardPageID = "AJ Web Return Order";
    Editable = false;
    PageType = List;
    SourceTable = "AJ Web Order Header";
    SourceTableView = WHERE("Document Type"=CONST(Return));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Order No.";"Web Order No.")
                {
                }
                field("Web Service Order ID";"Web Service Order ID")
                {
                }
                field("Order DateTime";"Order DateTime")
                {
                }
                field("Apply-To Web Order No.";"Apply-To Web Order No.")
                {
                }
                field("Apply-To Web Service Order ID";"Apply-To Web Service Order ID")
                {
                }
                field("Shipping Carrier Code";"Shipping Carrier Code")
                {
                }
                field("Carier Tracking Number";"Carier Tracking Number")
                {
                }
                field("NAV Order Status";"NAV Order Status")
                {
                }
                field("NAV Order Count";"NAV Order Count")
                {
                }
                field("NAV Error Text";"NAV Error Text")
                {
                }
                field(agree_to_return_charge;agree_to_return_charge)
                {
                }
                field(refund_without_return;refund_without_return)
                {
                }
                field(return_charge_feedback;return_charge_feedback)
                {
                }
                field(merchant_return_charge;merchant_return_charge)
                {
                }
            }
        }
    }

    actions
    {
    }
}

