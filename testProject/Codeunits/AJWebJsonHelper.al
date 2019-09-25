codeunit 37072300 "AJ Web Json Helper"
{
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
        if not JValue.IsNull then
            Value := JValue.AsBoolean();
    end;

    procedure GetJsonValueAsText(var JObject: JsonObject; Property: Text) Value: text
    var
        JValue: JsonValue;
    begin
        if not GetJsonValue(JObject, Property, JValue) then
            exit;
        if not JValue.IsNull then
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

    procedure JSONAddArray(var JObject: JsonObject; PropertyName: Text; var JArray: JsonArray)
    begin
        JObject.Add(PropertyName, JArray.AsToken());
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

    procedure JSONAddDec(var JObject: JsonObject; PropertyName: Text; PropertyValue: Decimal)
    var
        JToken: JsonToken;
    begin
        JObject.Add(PropertyName, JToken.ReadFrom(Format(PropertyValue, 20, '<Sign><Integer><Decimals>')));
    end;

    procedure JSONAddBigInt(var JObject: JsonObject; PropertyName: Text; PropertyValue: BigInteger)
    var
        JToken: JsonToken;
    begin
        JObject.Add(PropertyName, JToken.ReadFrom(Format(PropertyValue)));
    end;

    procedure JSONAddObject(var JObject: JsonObject; PropertyName: Text; AddJObject: JsonObject)
    var
        JToken: JsonToken;
    begin
        JObject.Add(PropertyName, JObject.AsToken());
    end;

    procedure JSONAddBool(var JObject: JsonObject; PropertyName: Text; PropertyValue: Boolean)
    var
        JToken: JsonToken;
    begin
        if PropertyValue then
            JObject.Add(PropertyName, JToken.ReadFrom('true'))
        else
            JObject.Add(PropertyName, JToken.ReadFrom('false'));
    end;

    procedure JSONAddTxtasDec(var JObject: JsonObject; PropertyName: Text; PropertyValue: Text)
    var
        JToken: JsonToken;
    begin
        if PropertyValue = '' then
            JObject.Add(PropertyName, JToken.ReadFrom('null'))
        else
            JObject.Add(PropertyName, JToken.ReadFrom(PropertyValue));
    end;
}