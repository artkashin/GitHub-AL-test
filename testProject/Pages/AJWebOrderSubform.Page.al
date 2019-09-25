page 37072310 "AJ Web Order Subform"
{
    // 3/31/2017 SK replace "Cancel Reason (CommerceHUB)" with "Cancel Reason"

    DeleteAllowed = true;
    PageType = ListPart;
    SourceTable = "AJ Web Order Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SKU; SKU)
                {
                }
                field(UPC; UPC)
                {
                    Editable = false;
                }
                field("Fulfillment Lineitem Id"; "Fulfillment Lineitem Id")
                {
                }
                field(Name; Name)
                {
                }
                field(Quantity; Quantity)
                {
                }

                field("Qty. to Pack"; "Qty. to Pack")
                {
                }
                field("Quantity Packed"; "Quantity Packed")
                {
                    Editable = false;
                }
                field("Qty. to Cancel"; "Qty. to Cancel")
                {
                    Visible = false;
                }
                field("Quantity Cancelled"; "Quantity Cancelled")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Qty. to Return"; "Qty. to Return")
                {
                    Visible = false;
                }
                field("Quantity Returned"; "Quantity Returned")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Tax Amount"; "Tax Amount")
                {
                }
                field("Shipping Amount"; "Shipping Amount")
                {
                }
                field(Weight; Weight)
                {
                }
                field("Weigh Unit"; "Weigh Unit")
                {
                }
                field("Warehouse Location"; "Warehouse Location")
                {
                }
                field("Retail Unit Price"; "Retail Unit Price")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field("Gift Message"; "Gift Message")
                {
                }
                field("Item Option 1"; "Item Option 1")
                {
                }
                field("Item Option 1 Value"; "Item Option 1 Value")
                {
                }
                field("Item Option 2"; "Item Option 2")
                {
                }
                field("Item Option 2 Value"; "Item Option 2 Value")
                {
                    Caption = '<Item Option 2 Value>';
                }
            }
        }
    }

    actions
    {
    }
}

