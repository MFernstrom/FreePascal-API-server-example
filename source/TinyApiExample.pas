program TinyApiExample;

{
  Copyright 2018, Marcus Fernstrom
  License MIT
}

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}cthreads, cmem,{$ENDIF}
  SysUtils, fphttpapp, httpdefs, httproute, IniFiles;

procedure exampleEndpoint(aRequest : TRequest; aResponse : TResponse);
begin
  aResponse.Content := '{"success": true, "data": "This is a json object"}';
  aResponse.Code    := 200;
  aResponse.ContentType := 'application/json';
  aResponse.ContentLength := length(aResponse.Content);
  aResponse.SendContent;
end;

procedure docsEndpoint(aRequest : TRequest; aResponse : TResponse);
begin
  aResponse.Content := 'This is the default response if no other routes match.';
  aResponse.Code    := 200;
  aResponse.ContentType := 'text/plain';
  aResponse.ContentLength := length(aResponse.Content);
  aResponse.SendContent;
end;

begin
  Application.Port := 9080;
  HTTPRouter.RegisterRoute('/example', @exampleEndpoint);
  HTTPRouter.RegisterRoute('/docs', @docsEndpoint, true);
  Application.Threaded := true;
  Application.Initialize;
  WriteLn('Example HTTP server is ready at http://localhost:9080/');
  Application.Run;
end.
