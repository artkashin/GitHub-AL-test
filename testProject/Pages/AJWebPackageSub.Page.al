page 37072314 "AJ Web Package Sub"
{
    PageType = ListPart;
    SourceTable = "AJ Web Package Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package No."; "Package No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

