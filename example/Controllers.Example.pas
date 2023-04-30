unit Controllers.Example;

interface

procedure Registry;

implementation

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Rest.Json,

  Horse.OctetStream,

  DTO.Arquivo,
  Model.Arquivo;

procedure PostCriarArquivo(Req: THorseRequest; Resp: THorseResponse);
var LPath : String; LDTOArquivo: TDTOArquivo;
begin
  LDTOArquivo := TJson.JsonToObject<TDTOArquivo>(Req.Body);
  LPath := TModelArquivo.New.CriarArquivo(LDTOArquivo);
  LDTOArquivo.Free;

  var LRetorno := TJSONObject.Create;
  LRetorno.AddPair('path', TJSONString.Create(LPath));
  LRetorno.AddPair('exists', TJSONBool.Create(FileExists(LPath)));

  Sleep(2000);
  Resp.Status(201).Send(LRetorno);
end;

procedure ObterArquivo(Req: THorseRequest; Resp: THorseResponse);
var LArquivo: TFileReturn;  LDTOArquivo: TDTOArquivoStream;
begin
  LDTOArquivo := TJson.JsonToObject<TDTOArquivoStream>(Req.Body);
  LArquivo := TModelArquivo.New.ObterArquivo(LDTOArquivo);
  LDTOArquivo.Free;

  Sleep(2000);
  Resp.Status(201).Send<TFileReturn>(LArquivo);
end;

procedure Registry;
begin
  THorse.Post('/criar-arquivo', PostCriarArquivo);
  THorse.Get('/obter-arquivo', ObterArquivo)
end;

end.
