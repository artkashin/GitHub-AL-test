pageextension 37072304 PageExtansion132 extends "Posted Sales Invoice"
{
    var
        AJShippingLine: Record "AJ Shipping Line";
        LookupforAJShipping: Boolean;

    procedure SetLookupForAJShipping(AJShippingLine2: Record "AJ Shipping Line")
    begin
        LookupforAJShipping := true;
        AJShippingLine := AJShippingLine2;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        FromSalesInvHeader: Record "Sales Invoice Header";
        AJShippingHeader: Record "AJ Shipping Header";
        AJFillShippingLine: Codeunit "AJ Fill Shipping Process";
    begin
        if LookupforAJShipping and (CloseAction = Action::LookupOK) then begin
            AJShippingHeader.Get(AJShippingLine."Shipping No.");
            FromSalesInvHeader.Copy(Rec);
            CurrPage.SetSelectionFilter(FromSalesInvHeader);
            if FromSalesInvHeader.FindSet() then
                repeat
                    Clear(AJFillShippingLine);
                    AJFillShippingLine.CreateLineFromSalesInvHeader(FromSalesInvHeader, AJShippingHeader, AJShippingLine);
                until FromSalesInvHeader.Next() = 0;
        end;
    end;
}