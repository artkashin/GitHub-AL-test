tableextension 37072305 TableExtansion18 extends "Customer"
{
    fields
    {
        field(37074776; "Bill-to Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'MBS 12.09.2019 AJWeb';
            OptionCaption = 'My Account,Recipient,Third Party,My Other Account';
            OptionMembers = my_account,recipient,third_party,my_other_account;
        }
        field(37074777; "Bill-to Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MBS 12.09.2019 AJWeb';
        }
        field(37074778; "Bill-to Account Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'MBS 12.09.2019 AJWeb';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(37074779; "Bill-to Account Country Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'MBS 12.09.2019 AJWeb';
            TableRelation = "Country/Region";
        }
    }
}
