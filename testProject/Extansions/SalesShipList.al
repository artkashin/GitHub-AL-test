pageextension 37072303 PageExtansion130 extends "Posted Sales Shipment"
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
        FromSalesShipHeader: Record "Sales Shipment Header";
        AJShippingHeader: Record "AJ Shipping Header";
        AJFillShippingLine: Codeunit "AJ Fill Shipping Process";
    begin
        if LookupforAJShipping and (CloseAction = Action::LookupOK) then begin
            AJShippingHeader.Get(AJShippingLine."Shipping No.");
            FromSalesShipHeader.Copy(Rec);
            CurrPage.SetSelectionFilter(FromSalesShipHeader);
            if FromSalesShipHeader.FindSet() then
                repeat
                    Clear(AJFillShippingLine);
                    AJFillShippingLine.CreateLineFromSalesShipHeader(FromSalesShipHeader, AJShippingHeader, AJShippingLine);
                until FromSalesShipHeader.Next() = 0;
        end;
    end;
}