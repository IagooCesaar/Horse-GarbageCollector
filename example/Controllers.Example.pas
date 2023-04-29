unit Controllers.Example;

interface

procedure Registry;

implementation

uses
  Horse,

  System.SysUtils,
  System.Classes,
  System.JSON,
  Rest.Json,

  DTO.Arquivo;

procedure PostCriarArquivo(Req: THorseRequest; Resp: THorseResponse);
var LArquivo: TStringList; LPath : String; LDTOArquivo: TDTOArquivo;
begin
  LDTOArquivo := TJson.JsonToObject<TDTOArquivo>(Req.Body);

  LPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if not DirectoryExists(LPath)
  then CreateDir(LPath);

  LPath := Format('%s%s.txt', [LPath, LDTOArquivo.Nome]);
  LArquivo := TStringList.Create;
  try
    LArquivo.Add(LDTOArquivo.Conteudo);
    LArquivo.SaveToFile(LPath);
  finally
    if LArquivo <> nil
    then FreeAndNil(LArquivo);
    if LDTOArquivo <> nil
    then FreeAndNIl(LDTOArquivo);
  end;

  var LRetorno := TJSONObject.Create;
  LRetorno.AddPair('path', TJSONString.Create(LPath));
  Resp.Status(201).Send(LRetorno);
end;

procedure Registry;
begin
  THorse.Post('/criar-arquivo', PostCriarArquivo);
end;

end.
