codeunit 37072300 "AJ Web Json Helper"
{
    var
        ReplaceNULL: Boolean;

    procedure GetJsonToken(JObject: JsonObject; TokenKey: text) JToken: JsonToken;
    begin
        if not JObject.Get(TokenKey, JToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure GetJsonValueAsDec(var JObject: JsonObject; Property: Text) Value: Decimal
    var
        JValue: JsonValue;
    begin
        if not GetJsonValue(JObject, Property, JValue) then
            exit;
        Value := JValue.AsDecimal();
    end;

    procedure GetJsonValueAsBool(var JObject: JsonObject; Property: Text) Value: Boolean
    var
        JValue: JsonValue;
    begin
        if not GetJsonValue(JObject, Property, JValue) then
            exit;
        if not JValue.IsNull() then
            Value := JValue.AsBoolean();
    end;

    procedure GetJsonValueAsText(var JObject: JsonObject; Property: Text) Value: text
    var
        JValue: JsonValue;
    begin
        if not GetJsonValue(JObject, Property, JValue) then
            exit;
        if not JValue.IsNull() then
            Value := JValue.AsText();
    end;

    procedure GetJsonValue(var JObject: JsonObject; Property: Text; var JValue: JsonValue): Boolean
    var
        JToken: JsonToken;
    begin
        if not JObject.Get(Property, JToken) then
            exit;
        JValue := JToken.AsValue();
        exit(true);
    end;

    procedure GetJsonObjFromArray(var JArray: JsonArray; i: Integer) JObject: JsonObject
    var
        JToken: JsonToken;
    begin
        JArray.Get(i - 1, JToken);
        JObject := JToken.AsObject();
    end;

    procedure JsonReadArrayFrom(var JArray: JsonArray; Txt: Text)
    begin
        if not JArray.ReadFrom(Txt) then
            Error('Bad response');
    end;

    procedure JSONAddArray(var JObject: JsonObject; PropertyName: Text; var JArray: JsonArray)
    begin
        JObject.Add(PropertyName, JArray.AsToken());
    end;

    procedure JSONAddObject(var JObject: JsonObject; PropertyName: Text; AddJObject: JsonObject)
    begin
        JObject.Add(PropertyName, AddJObject.AsToken());
    end;

    procedure JSONAddDec(var JObject: JsonObject; PropertyName: Text; PropertyValue: Decimal)
    begin
        JObject.Add(PropertyName, Format(PropertyValue, 20, '<Sign><Integer><Decimals>'));
    end;

    procedure JSONAddBigInt(var JObject: JsonObject; PropertyName: Text; PropertyValue: BigInteger)
    var
        JToken: JsonToken;
    begin
        JToken.ReadFrom(Format(PropertyValue));
        JObject.Add(PropertyName, JToken.AsValue());
    end;

    procedure JSONAddBool(var JObject: JsonObject; PropertyName: Text; PropertyValue: Boolean)
    begin
        if PropertyValue then
            JObject.Add(PropertyName, 'true')
        else
            JObject.Add(PropertyName, 'false');
    end;

    procedure JSONAddTxt(var JObject: JsonObject; PropertyName: Text; PropertyValue: Text)
        jvalue: JsonValue
    begin
        if PropertyValue = '' then begin
            jvalue.SetValueToNull();
            if ReplaceNULL then
                JObject.Add(PropertyName, '""')
            else
                JObject.Add(PropertyName, jvalue.AsToken())
        end else
            JObject.Add(PropertyName, PropertyValue);
    end;

    procedure JSONAddTxtasDec(var JObject: JsonObject; PropertyName: Text; PropertyValue: Text)
    var
        DecValue: Decimal;
        jvalue: JsonValue;

    begin
        if PropertyValue = '' then begin
            jvalue.SetValueToNull();
            JObject.Add(PropertyName, jvalue.AsToken())
        end else
            if Evaluate(DecValue, PropertyValue) then
                JObject.Add(PropertyName, Format(DecValue, 20, '<Sign><Integer><Decimals>'));
    end;

    procedure JSONSetReplaceNULL(NewReplaceNULL: Boolean)
    begin
        ReplaceNULL := NewReplaceNULL;
    end;

    procedure JSONAddNULL(var JObject: JsonObject; PropertyName: Text)
    var
        jvalue: JsonValue;
    begin
        jvalue.SetValueToNull();
        JObject.Add(PropertyName, jvalue.AsToken());
    end;
}