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
                }
                field(Name; Name)
                {
                }
                field(Quantity; Quantity)
                {
                    Caption = 'Return Quantity';
                    Editable = false;
                }
                field(Status; Status)
                {
                    Caption = 'Reason';
                }
                field("Custom Text 1"; "Custom Text 1")
                {
                    Caption = 'Notes';
                }
            }
        }
    }

    actions
    {
    }
}

