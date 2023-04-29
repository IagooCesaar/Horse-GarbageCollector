unit Controllers.Example;

interface

procedure Registry;

implementation

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Rest.Json,

  DTO.Arquivo,
  Model.Arquivo;

procedure PostCriarArquivo(Req: THorseRequest; Resp: THorseResponse);
var LPath : String; LDTOArquivo: TDTOArquivo;
begin
  LDTOArquivo := TJson.JsonToObject<TDTOArquivo>(Req.Body);
  LPath := TModelArquivo.New.CriarArquivo(LDTOArquivo);

  var LRetorno := TJSONObject.Create;
  LRetorno.AddPair('path', TJSONString.Create(LPath));
  LRetorno.AddPair('exists', TJSONBool.Create(FileExists(LPath)));

  Resp.Status(201).Send(LRetorno);
end;

procedure Registry;
begin
  THorse.Post('/criar-arquivo', PostCriarArquivo);
end;

end.
