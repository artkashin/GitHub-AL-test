codeunit 37072301 "AJ Web Service Base"
{
    procedure CallWebService(AJWebService: Record "AJ Web Service"; URI: Text; Method: Text; ContentType: Text; Body: Text) ResponseTxt: Text
    begin
        IF not TryCallWebService(AJWebService, URI, Method, ContentType, Body) then
            Error(Body)
        else
            ResponseTxt := Body;
    end;

    [TryFunction]
    procedure TryCallWebService(AJWebService: Record "AJ Web Service"; URI: Text; Method: Text; ContentType: Text; var Body: Text)
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
    begin
        RequestMessage.Method(Method);
        RequestMessage.SetRequestUri(URI);
        RequestMessage.GetHeaders(Headers);

        Headers.Add('Authorization', StrSubstNo('Basic %1', AJWebService."API Encoded String"));

        if Body <> '' then begin
            Content.WriteFrom(Body);

            if ContentType <> '' then begin
                Content.GetHeaders(ContentHeaders);
                ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', ContentType);
            end;
            RequestMessage.Content := Content;
        end;

        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content.ReadAs(Body);

        if not ResponseMessage.IsSuccessStatusCode then begin
            Body := StrSubstNo('The web service returned an error message:\\' +
                'Status code: %1\' +
                'Description: %2',
                ResponseMessage.HttpStatusCode,
                ResponseMessage.ReasonPhrase);
            exit(false);
        end;
    end;
}
