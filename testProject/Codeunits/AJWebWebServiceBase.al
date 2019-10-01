codeunit 37072301 "AJ Web Service Base"
{
    procedure CallWebService(AJWebService: Record "AJ Web Service"; URI: Text; Method: Text; ContentType: Text; var Body: Text) Result: Boolean
    var
        ErrorTxt: Text;
    begin
        if TryCallWebService(AJWebService, URI, Method, ContentType, Body, ErrorTxt) then
            if ErrorTxt <> '' then
                Message(Body)
            else
                exit(true)
        else
            exit(false);
    end;

    [TryFunction]
    procedure TryCallWebService(AJWebService: Record "AJ Web Service"; URI: Text; Method: Text; ContentType: Text; var Body: Text; var ErrorTxt: Text)
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
    begin
        RequestMessage.SetRequestUri(URI);
        RequestMessage.Method(Method);
        RequestMessage.GetHeaders(Headers);

        Headers.Remove('authorization');
        Headers.Add('Authorization', 'Basic ' + AJWebService."API Encoded String");

        if Body <> '' then begin
            Content.GetHeaders(ContentHeaders);
            Content.WriteFrom(Body);

            if ContentType <> '' then begin
                ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', ContentType);
            end;
            RequestMessage.Content(Content);
        end;

        Client.Send(RequestMessage, ResponseMessage);
        ResponseMessage.Content().ReadAs(Body);


        if not ResponseMessage.IsSuccessStatusCode() then
            ErrorTxt := Body;
        // StrSubstNo('The web service returned an error message:\\' +
        //     'Status code: %1\' +
        //     'Description: %2',
        //     ResponseMessage.HttpStatusCode,
        //     ResponseMessage.ReasonPhrase);

    end;
}
