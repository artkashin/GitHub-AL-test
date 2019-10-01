table 37072310 "AJ Web Package Line"
{

    fields
    {
        field(1; "Package No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(5; "Source Type"; Integer)
        {
        }
        field(6; "Source No."; Code[20])
        {
        }
        field(7; "Source Line No."; Integer)
        {
        }
        field(20; Quantity; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Package No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // Unpack
        if ("Source Type" = DATABASE::"AJ Web Order Line") and (Quantity > 0) then begin
            AJWebOrderLine.Reset();
            AJWebOrderLine."Web Order No." := "Source No.";
            AJWebOrderLine."Line No." := "Source Line No.";
            if AJWebOrderLine.Find() then begin
                AJWebOrderLine."Quantity Packed" -= Quantity;
                AJWebOrderLine.Modify();
            end;
        end;
    end;

    var
        AJWebOrderLine: Record "AJ Web Order Line";
}

