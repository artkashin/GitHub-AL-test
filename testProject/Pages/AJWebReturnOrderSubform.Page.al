page 37072320 "AJ Web Return Order Subform"
{
    PageType = ListPart;
    SourceTable = "AJ Web Order Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Web Service SKU ID"; "Web Service SKU ID")
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
                    Caption = 'Return Quantity';
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Caption = 'Reason';
                }
                field("Custom Text 1"; "Custom Text 1")
                {
                    ApplicationArea = All;
                    Caption = 'Notes';
                }
            }
        }
    }
}

