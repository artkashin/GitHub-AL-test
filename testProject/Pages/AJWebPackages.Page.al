page 37072311 "AJ Web Packages"
{
    // 1388444 SK 5/11/2017

    CardPageID = "AJ Web Package";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "AJ Web Package";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Source Type"; "Source Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Source No."; "Source No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shipping Web Service Code"; "Shipping Web Service Code")
                {
                    Visible = false;
                }
                field("Shipping Web Service Store ID"; "Shipping Web Service Store ID")
                {
                    Visible = false;
                }
                field("Shipping Warehouse ID"; "Shipping Warehouse ID")
                {
                    Visible = false;
                }
                field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
                {
                    Visible = false;
                }
                field("Shipping Web Service Shipm. ID"; "Shipping Web Service Shipm. ID")
                {
                    Visible = false;
                }
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                    Visible = false;
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                    Visible = false;
                }
                field("Shipping Package Type"; "Shipping Package Type")
                {
                    Visible = false;
                }
                field("Shipping Delivery Confirm"; "Shipping Delivery Confirm")
                {
                    Visible = false;
                }
                field("Shp. Product Weight Unit"; "Shp. Product Weight Unit")
                {
                }
                field("Shp. Product Weight"; "Shp. Product Weight")
                {
                }
                field("Insure Shipment"; "Insure Shipment")
                {
                }
                field("Insured Value"; "Insured Value")
                {
                }
                field("Additional Insurance Value"; "Additional Insurance Value")
                {
                }
                field("Carier Shipping Charge"; "Carier Shipping Charge")
                {
                    Editable = false;
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                    Editable = false;
                }
                field("Carier Insurance Cost"; "Carier Insurance Cost")
                {
                    Editable = false;
                }
                field("Shipping & Handling Amount"; "Shipping & Handling Amount")
                {
                    Editable = false;
                }
                field("Label Created"; "Label Created")
                {
                    Editable = false;
                }
                field("Label Printed"; "Label Printed")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Labels")
            {

                trigger OnAction()
                var
                    AJWebPackage: Record "AJ Web Package";
                    AJWebOrderHeader: Record "AJ Web Order Header";
                    // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                    SalesHeader: Record "Sales Header";
                begin
                    if not Confirm('Confirm to create labels for selected packages') then
                        Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst then
                        repeat
                            AJWebPackage.TestField("Shipping Web Service Code");
                            AJWebPackage.TestField("Shipping Web Service Store ID");
                            AJWebPackage.TestField("Shipping Warehouse ID");
                            AJWebPackage.TestField("Shipping Carrier Code");
                            AJWebPackage.TestField("Shipping Carrier Service");
                            AJWebPackage.TestField("Shipping Package Type");
                            AJWebPackage.TestField("Shipping Delivery Confirm");
                            AJWebPackage.TestField("Shp. Product Weight");
                            AJWebPackage.TestField("Label Created", false);

                            // update web order
                            if AJWebPackage."Source Type" = DATABASE::"AJ Web Order Header" then begin
                                AJWebOrderHeader.Get(AJWebPackage."Source No.");
                                if not AJWebOrderHeader.Mark then begin
                                    if AJWebOrderHeader."Created From Sales Order" then begin
                                        SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
                                        SalesHeader.FindFirst;
                                        //AJWebOrderServiceMgmt.WOS_CreateWebOrderFromSalesOrder(SalesHeader,AJWebOrderHeader);
                                    end;
                                    AJWebOrderHeader.Mark(true);
                                end;
                            end;

                        until AJWebPackage.Next = 0;

                    CurrPage.Update(false);

                    Message('Done');
                end;
            }
            action("Cancel Labels")
            {

                trigger OnAction()
                var
                    AJWebPackage: Record "AJ Web Package";
                    //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                begin
                    if not Confirm('Confirm to cancel labels for selected packages') then
                        Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst then
                        repeat
                            AJWebPackage.TestField("Shipping Web Service Code");
                            AJWebPackage.TestField("Shipping Web Service Order No.");
                            AJWebPackage.TestField("Label Created", true);
                        until AJWebPackage.Next = 0;

                    if AJWebPackage.FindFirst then
                        repeat
                            //AJWebOrderServiceMgmt.WOS_CancelLabelForPackage(AJWebPackage);
                            Commit;
                        until AJWebPackage.Next = 0;

                    CurrPage.Update(false);

                    Message('Done');
                end;
            }
            action("Save Labels")
            {

                trigger OnAction()
                var
                    AJWebPackage: Record "AJ Web Package";
                    // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                begin
                    if not Confirm('Confirm to cancel labels for selected packages') then
                        Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst then
                        repeat
                            //AJWebOrderServiceMgmt.WOS_SaveLabelForPackage(AJWebPackage);
                            Commit;
                        until AJWebPackage.Next = 0;

                    CurrPage.Update(false);

                    Message('Done');
                end;
            }
        }
    }
}

