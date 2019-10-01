page 37072313 "AJ Web Package Part"
{
    Caption = 'AJ Packages';
    CardPageID = "AJ Web Package";
    InsertAllowed = false;
    PageType = ListPart;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "AJ Web Package";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "AJ Web Package";
                    Editable = false;
                    LookupPageID = "AJ Web Package";
                    TableRelation = "AJ Web Package"."No.";

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        if AJWebPackage.Get("No.") then
                            PAGE.Run(PAGE::"AJ Web Package", AJWebPackage);
                    end;
                }
                field("Shipping Web Service Code"; "Shipping Web Service Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Web Service Store ID"; "Shipping Web Service Store ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Warehouse ID"; "Shipping Warehouse ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Carrier Code"; "Shipping Carrier Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Carrier Service"; "Shipping Carrier Service")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Package Type"; "Shipping Package Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shipping Delivery Confirm"; "Shipping Delivery Confirm")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shp. Product Weight Unit"; "Shp. Product Weight Unit")
                {
                    ApplicationArea = All;
                }
                field("Shp. Product Weight"; "Shp. Product Weight")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Shp. Product Dimension Unit"; "Shp. Product Dimension Unit")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shp. Product Width"; "Shp. Product Width")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Visible = false;
                }
                field("Shp. Product Length"; "Shp. Product Length")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Visible = false;
                }
                field("Shp. Product Height"; "Shp. Product Height")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Visible = false;
                }
                field("Insure Shipment"; "Insure Shipment")
                {
                    ApplicationArea = All;
                }
                field("Insured Value"; "Insured Value")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Additional Insurance Value"; "Additional Insurance Value")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Bill-to Type"; "Bill-to Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bill-To Account"; "Bill-To Account")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bill-To Postal Code"; "Bill-To Postal Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bill-To Country Code"; "Bill-To Country Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Carier Shipping Charge"; "Carier Shipping Charge")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("Carier Tracking Number"; "Carier Tracking Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Carier Insurance Cost"; "Carier Insurance Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("Shipping Web Service Order No."; "Shipping Web Service Order No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Shipping & Handling Amount"; "Shipping & Handling Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Editable = false;
                }
                field("Label Created"; "Label Created")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Label Printed"; "Label Printed")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Control1000000031; Label)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Container ID"; "Container ID")
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
            action("Create Labels")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    AJWebPackage: Record "AJ Web Package";
                    AJWebOrderHeader: Record "AJ Web Order Header";
                    //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                    SalesHeader: Record "Sales Header";
                begin

                    if not Confirm('Confirm to create labels for selected packages') then
                        Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst() then
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
                                if not AJWebOrderHeader.Mark() then begin
                                    if AJWebOrderHeader."Created From Sales Order" then begin
                                        SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."Document Type"::Order, SalesHeader."Document Type"::"Return Order");
                                        SalesHeader.SetRange("Web Order No.", AJWebOrderHeader."Web Order No.");
                                        if SalesHeader.FindFirst() then
                                            if Confirm('Do you want to update Web Order from Sales %1?', false, SalesHeader."No.") then
                                                MESSAGE('MBS COMMENTED');
                                        //AJWebOrderServiceMgmt.WOS_CreateWebOrderFromSalesOrder(SalesHeader,AJWebOrderHeader);
                                    end;
                                    AJWebOrderHeader.Mark(true);
                                end;
                            end;

                        until AJWebPackage.Next() = 0;


                    if AJWebPackage.FindFirst() then
                        repeat
                            //AJWebOrderServiceMgmt.WOS_GetLabelForPackage(AJWebPackage);
                            Commit();
                        until AJWebPackage.Next() = 0;

                    CurrPage.Update(false);

                    Message('Done');
                end;
            }
            action("Cancel Labels")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    AJWebPackage: Record "AJ Web Package";
                // AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                begin

                    if not Confirm('Confirm to cancel labels for selected packages') then
                        Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst() then
                        repeat
                            AJWebPackage.TestField("Shipping Web Service Code");
                            AJWebPackage.TestField("Shipping Web Service Order No.");
                            AJWebPackage.TestField("Shipping Web Service Shipm. ID");
                            AJWebPackage.TestField("Label Created", true);
                        until AJWebPackage.Next() = 0;

                    if AJWebPackage.FindFirst() then
                        repeat
                            //AJWebOrderServiceMgmt.WOS_CancelLabelForPackage(AJWebPackage);
                            Commit();
                        until AJWebPackage.Next() = 0;

                    CurrPage.Update(false);

                    Message('Done');
                end;
            }
            action("Save Labels")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    AJWebPackage: Record "AJ Web Package";
                //AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                begin

                    if not Confirm('Confirm to cancel labels for selected packages') then
                        Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst() then
                        repeat
                            //AJWebOrderServiceMgmt.WOS_SaveLabelForPackage(AJWebPackage);
                            Commit();
                        until AJWebPackage.Next() = 0;

                    CurrPage.Update(false);

                    Message('Done');
                end;
            }
        }
    }

    var
        AJWebPackage: Record "AJ Web Package";
}

