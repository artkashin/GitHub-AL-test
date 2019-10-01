page 37072300 "AJ Web Services Setup"
{
    PageType = Card;
    SourceTable = "AJ Web Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Web Order No. Series"; "Web Order No. Series")
                {
                    ApplicationArea = All;
                }
                field("Web Package No. Series"; "Web Package No. Series")
                {
                    ApplicationArea = All;
                }
                field("Tax G/L Account No."; "Tax G/L Account No.")
                {
                    ApplicationArea = All;
                }
                field(Version; Version)
                {
                    ApplicationArea = All;
                }
                field("On Vacation Until"; "On Vacation Until")
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

