pageextension 50100 CustomerListExt extends "Customer List"
{

    trigger OnOpenPage();
    var
        AJWebServices: Page "AJ Web Services";
    begin
        AJWebServices.Run();
    end;
}