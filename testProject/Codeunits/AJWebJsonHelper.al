codeunit 50105 "AJ Web Json Helper"
{
    procedure GetJsonToken(JObject: JsonObject; TokenKey: text) JToken: JsonToken;
    begin
        if not JObject.Get(TokenKey, JToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    procedure GetJsonValueAsText(var JObject: JsonObject; Property: Text) Value: text
    var
        JValue: JsonValue;
    begin
        if not GetJsonValue(JObject, Property, JValue) then
            exit;
        Value := JValue.AsText;
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
}