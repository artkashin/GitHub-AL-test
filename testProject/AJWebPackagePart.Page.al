page 37076138 "AJ Web Package Part"
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
                field("No.";"No.")
                {
                    DrillDownPageID = "AJ Web Package";
                    Editable = false;
                    LookupPageID = "AJ Web Package";
                    TableRelation = "AJ Web Package"."No.";

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        if AJWebPackage.Get("No.") then
                          PAGE.Run(PAGE::"AJ Web Package",AJWebPackage);
                    end;
                }
                field("Shipping Web Service Code";"Shipping Web Service Code")
                {
                    Visible = false;
                }
                field("Shipping Web Service Store ID";"Shipping Web Service Store ID")
                {
                    Visible = false;
                }
                field("Shipping Warehouse ID";"Shipping Warehouse ID")
                {
                    Visible = false;
                }
                field("Shipping Carrier Code";"Shipping Carrier Code")
                {
                    Visible = false;
                }
                field("Shipping Carrier Service";"Shipping Carrier Service")
                {
                    Visible = false;
                }
                field("Shipping Package Type";"Shipping Package Type")
                {
                    Visible = false;
                }
                field("Shipping Delivery Confirm";"Shipping Delivery Confirm")
                {
                    Visible = false;
                }
                field("Shp. Product Weight Unit";"Shp. Product Weight Unit")
                {
                }
                field("Shp. Product Weight";"Shp. Product Weight")
                {
                    BlankZero = true;
                }
                field("Shp. Product Dimension Unit";"Shp. Product Dimension Unit")
                {
                    Visible = false;
                }
                field("Shp. Product Width";"Shp. Product Width")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Shp. Product Length";"Shp. Product Length")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Shp. Product Height";"Shp. Product Height")
                {
                    BlankZero = true;
                    Visible = false;
                }
                field("Insure Shipment";"Insure Shipment")
                {
                }
                field("Insured Value";"Insured Value")
                {
                    BlankZero = true;
                }
                field("Additional Insurance Value";"Additional Insurance Value")
                {
                    BlankZero = true;
                }
                field("Bill-to Type";"Bill-to Type")
                {
                    Visible = false;
                }
                field("Bill-To Account";"Bill-To Account")
                {
                    Visible = false;
                }
                field("Bill-To Postal Code";"Bill-To Postal Code")
                {
                    Visible = false;
                }
                field("Bill-To Country Code";"Bill-To Country Code")
                {
                    Visible = false;
                }
                field("Carier Shipping Charge";"Carier Shipping Charge")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Carier Tracking Number";"Carier Tracking Number")
                {
                    Editable = false;
                }
                field("Carier Insurance Cost";"Carier Insurance Cost")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Shipping Web Service Order No.";"Shipping Web Service Order No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Shipping & Handling Amount";"Shipping & Handling Amount")
                {
                    BlankZero = true;
                    Editable = false;
                }
                field("Label Created";"Label Created")
                {
                    Editable = false;
                }
                field("Label Printed";"Label Printed")
                {
                    Editable = false;
                }
                field(Control1000000031;Label)
                {
                    Editable = false;
                }
                field("Container ID";"Container ID")
                {
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
                    AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                    SalesHeader: Record "Sales Header";
                begin

                    if not Confirm('Confirm to create labels for selected packages') then
                      Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst then repeat
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
                            SalesHeader.SetFilter("Document Type",'%1|%2',SalesHeader."Document Type"::Order,SalesHeader."Document Type"::"Return Order");
                            SalesHeader.SetRange("Web Order No.",AJWebOrderHeader."Web Order No.");
                            if SalesHeader.FindFirst then
                              if Confirm('Do you want to update Web Order from Sales %1?',false,SalesHeader."No.") then
                                AJWebOrderServiceMgmt.WOS_CreateWebOrderFromSalesOrder(SalesHeader,AJWebOrderHeader);
                          end;
                          AJWebOrderHeader.Mark(true);
                        end;
                      end;

                    until AJWebPackage.Next = 0;


                    if AJWebPackage.FindFirst then repeat
                      AJWebOrderServiceMgmt.WOS_GetLabelForPackage(AJWebPackage);
                      Commit;
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
                    AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                begin

                    if not Confirm('Confirm to cancel labels for selected packages') then
                      Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst then repeat
                      AJWebPackage.TestField("Shipping Web Service Code");
                      AJWebPackage.TestField("Shipping Web Service Order No.");
                      AJWebPackage.TestField("Shipping Web Service Shipm. ID");
                      AJWebPackage.TestField("Label Created", true);
                    until AJWebPackage.Next = 0;

                    if AJWebPackage.FindFirst then repeat
                      AJWebOrderServiceMgmt.WOS_CancelLabelForPackage(AJWebPackage);
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
                    AJWebOrderServiceMgmt: Codeunit "AJ Web Order Service Mgmt";
                begin

                    if not Confirm('Confirm to cancel labels for selected packages') then
                      Error('Cancelled');

                    CurrPage.SetSelectionFilter(AJWebPackage);
                    if AJWebPackage.FindFirst then repeat
                      AJWebOrderServiceMgmt.WOS_SaveLabelForPackage(AJWebPackage);
                      Commit;
                    until AJWebPackage.Next = 0;

                    CurrPage.Update(false);

                    Message('Done');
                end;
            }
        }
    }

    var
        AJWebPackage: Record "AJ Web Package";
}

