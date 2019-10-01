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
                field(Name; Name)
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

