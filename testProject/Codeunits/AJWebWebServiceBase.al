codeunit 37072301 "AJ Web Service Base"
{
    procedure CallWebService(var Parameters: Record "AJ Web Service Parameters" temporary): Boolean
    var
        Client: HttpClient;
        AuthHeaderValue: HttpHeaders;
        Headers: HttpHeaders;
        ContentHeaders: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: text;
        TempBlob: Record TempBlob temporary;
    begin
        RequestMessage.Method := Format(Parameters.Method);
        RequestMessage.SetRequestUri(Parameters.URI);
        RequestMessage.GetHeaders(Headers);

        if Parameters.Accept <> '' then
            Headers.Add('Accept', Parameters.Accept);

        if Parameters.UserName <> '' then begin
            AuthText := StrSubstNo('%1:%2', Parameters.UserName, Parameters.Password);
            TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
            Headers.Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));
        end;

        if Parameters.HasRequestContent then begin
            Parameters.GetRequestContent(Content);
            if Parameters.ContentType <> '' then begin
                Content.GetHeaders(ContentHeaders);
                ContentHeaders.Remove('Content-Type');
                ContentHeaders.Add('Content-Type', Parameters.ContentType);
            end;
            RequestMessage.Content := Content;
        end;

        Client.Send(RequestMessage, ResponseMessage);
<<<<<<< HEAD
        ResponseMessage.Content().ReadAs(Body);
=======
>>>>>>> parent of 7df33c2... Merge branch 'master' of https://github.com/artkashin/GitHub

        Headers := ResponseMessage.Headers;
        Parameters.SetResponseHeaders(Headers);

<<<<<<< HEAD
        if not ResponseMessage.IsSuccessStatusCode() then
            ErrorTxt := Body;
        // StrSubstNo('The web service returned an error message:\\' +
        //     'Status code: %1\' +
        //     'Description: %2',
        //     ResponseMessage.HttpStatusCode,
        //     ResponseMessage.ReasonPhrase);
=======
        Content := ResponseMessage.Content;
        Parameters.SetResponseContent(Content);
>>>>>>> parent of 7df33c2... Merge branch 'master' of https://github.com/artkashin/GitHub

        EXIT(ResponseMessage.IsSuccessStatusCode);
    end;
}
