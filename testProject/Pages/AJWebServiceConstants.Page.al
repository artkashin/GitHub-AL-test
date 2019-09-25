page 37072301 "AJ Web Service Constants"
{
    PageType = List;
    SourceTable = "AJ Web Service Constants";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Option Value"; "Option Value")
                {
                    ApplicationArea = All;
                }
                field("Second Value"; "Second Value")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

