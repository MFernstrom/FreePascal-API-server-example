program TinyApiExample;

{
  Copyright 2018, Marcus Fernstrom
  License MIT
}

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}cthreads, cmem,{$ENDIF}
  SysUtils, fphttpapp, httpdefs, httproute, fpjson;

procedure jsonEndpoint(aRequest : TRequest; aResponse : TResponse);
var
  jObject : TJSONObject;
begin
  jObject := TJSONObject.Create;
  try
    jObject.Booleans['success'] := true;
    jObject.Strings['data'] := 'This is a JSON object';
    jObject.Integers['numbers'] := 12345;

    aResponse.Content := jObject.AsJSON;
    aResponse.ContentType := 'application/json';
    aResponse.SendContent;
  finally
    jObject.Free;
  end;
end;

procedure textEndpoint(aRequest : TRequest; aResponse : TResponse);
begin
  aResponse.Content := 'This is the default response if no other routes match.';
  aResponse.ContentType := 'text/plain';
  aResponse.SendContent;
end;

begin
  Application.Port := 9080;
  HTTPRouter.RegisterRoute('/json', @jsonEndpoint);
  HTTPRouter.RegisterRoute('/text', @textEndpoint, true);
  Application.Threaded := true;
  Application.Initialize;
  WriteLn('Server is ready at http://localhost:' + IntToStr(Application.Port));
  Application.Run;
end.

