pageextension 37072302 PageExtansion54 extends "Purchase List"
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
        FromPurchaseHeader: Record "Purchase Header";
        AJShippingHeader: Record "AJ Shipping Header";
        AJFillShippingLine: Codeunit "AJ Fill Shipping Process";
    begin
        if LookupforAJShipping and (CloseAction = Action::LookupOK) then begin
            AJShippingHeader.Get(AJShippingLine."Shipping No.");
            FromPurchaseHeader.Copy(Rec);
            CurrPage.SetSelectionFilter(FromPurchaseHeader);
            if FromPurchaseHeader.FindSet() then
                repeat
                    Clear(AJFillShippingLine);
                    AJFillShippingLine.CreateLineFromPurchaseHeader(FromPurchaseHeader, AJShippingHeader, AJShippingLine);
                until FromPurchaseHeader.Next() = 0;
        end;
    end;
}