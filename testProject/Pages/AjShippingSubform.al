page 37072323 "AJ Shipping Subform"
{
    DeleteAllowed = true;
    PageType = ListPart;
    SourceTable = "AJ Shipping Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Source Type"; "Source Type")
                {
                    ApplicationArea = All;
                }
                field("Source Document Type"; "Source Document Type")
                {
                    ApplicationArea = All;
                }
                field("Source ID"; "Source ID")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
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

    actions
    {
        area(processing)
        {
            action("Populate Header from Line")
            {
                ApplicationArea = All;
                Promoted = false;
                Caption = 'Populate Header from Line';
                trigger OnAction()
                var
                    AJFillShippingLine: Codeunit "AJ Fill Shipping Process";
                begin
                    if "Source Table" <> 0 then
                        AJFillShippingLine.PopulateShippingHeaderFromLine(Rec)
                    else
                        Error('This is empty line');
                    Message('Done');
                end;
            }
        }
    }
}
