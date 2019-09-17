page 37076137 "AJ Web Package Sub"
{
    PageType = ListPart;
    SourceTable = "AJ Web Package Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Package No.";"Package No.")
                {
                }
                field("Line No.";"Line No.")
                {
                }
                field(Quantity;Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }
}

