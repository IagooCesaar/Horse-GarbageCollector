unit Model.Arquivo;

interface

uses
  Model.Interfaces,
  DTO.Arquivo;

type
  TModelArquivo = class(TInterfacedObject, IModelArquivo)
  private
  public
    class function New: IModelArquivo;
    constructor Create;
    destructor Destroy; override;

    { IModelArquivo }
    function CriarArquivo(ADTOArquivo: TDTOArquivo): String;
  end;

implementation

uses
  System.SysUtils,
  System.Classes;

{ TModelArquivo }

constructor TModelArquivo.Create;
begin

end;

function TModelArquivo.CriarArquivo(ADTOArquivo: TDTOArquivo): String;
var LArquivo: TStringList; LPath : String;
begin
  LPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  if not DirectoryExists(LPath)
  then CreateDir(LPath);

  LPath := Format('%s%s.txt', [LPath, ADTOArquivo.Nome]);
  LArquivo := TStringList.Create;
  try
    LArquivo.Add(ADTOArquivo.Conteudo);
    LArquivo.SaveToFile(LPath);
  finally
    if LArquivo <> nil
    then FreeAndNil(LArquivo);
    if ADTOArquivo <> nil
    then FreeAndNIl(ADTOArquivo);
  end;
  Result := LPath;
end;

destructor TModelArquivo.Destroy;
begin

  inherited;
end;

class function TModelArquivo.New: IModelArquivo;
begin
  Result := Self.Create;
end;

end.
