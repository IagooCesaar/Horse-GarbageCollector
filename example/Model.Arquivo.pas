unit Model.Arquivo;

interface

uses
  System.Classes,
  System.SysUtils,

  Model.Interfaces,
  Horse.GarbageCollector.Interfaces,
  Horse.GarbageCollector,
  DTO.Arquivo;

type
  TModelArquivo = class(TInterfacedObject,
    IModelArquivo,
    IHorseGarbageCollectorObserver)
  private
    FPodeDeletar: Boolean;
    FListaArquivos: TStringList;
  public
    class function New: IModelArquivo;
    constructor Create;
    destructor Destroy; override;

    { IModelArquivo }
    function CriarArquivo(ADTOArquivo: TDTOArquivo): String;

    { IHorseGarbageCollectorObserver }
    function CanCollectGarbage: Boolean;
    function GetFileListToDelete: TStringList;
  end;

implementation

{ TModelArquivo }

function TModelArquivo.CanCollectGarbage: Boolean;
begin
  Result := FPodeDeletar;
end;

constructor TModelArquivo.Create;
begin
  FPodeDeletar := False;
  FListaArquivos := TStringList.Create;

  THorseGarbageCollector.GetCollector.Add(Self);
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
  FPodeDeletar := True;
  FListaArquivos.Add(LPath);
end;

destructor TModelArquivo.Destroy;
begin

  inherited;
end;

function TModelArquivo.GetFileListToDelete: TStringList;
begin
  Result := FListaArquivos;
end;

class function TModelArquivo.New: IModelArquivo;
begin
  Result := Self.Create;
end;

end.
