unit Model.Arquivo;

interface

uses
  System.Classes,
  System.SysUtils,
  Windows,

  Model.Interfaces,
  Horse.GarbageCollector.Interfaces,
  Horse.GarbageCollector,

  Horse,
  Horse.OctetStream,

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
    function ObterArquivo(ADTOArquivo: TDTOArquivoStream): TFileReturn;

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

function TModelArquivo.ObterArquivo(ADTOArquivo: TDTOArquivoStream): TFileReturn;
var LStream: TMemoryStream; LPath : String;
begin
  if not FileExists(ADTOArquivo.Path)
  then raise EHorseException.New
    .Status(THTTPStatus.BadRequest)
    .Error('Arquivo não existe');

  LPath := ExtractFilePath(ADTOArquivo.Path)+
           ExtractFileName(ChangeFileExt(ADTOArquivo.Path, ''))+'_'+
           FormatDateTime('yyyymmddhhmmsszzz', Now)+
           ExtractFileExt(ADTOArquivo.Path);

  CopyFile(PWideChar(ADTOArquivo.Path), PWideChar(LPath), False);

  LStream := TMemoryStream.Create;
  LStream.LoadFromFile(LPath);

  Result := TFileReturn.Create(ExtractFileName(LPath), LStream);

  FPodeDeletar := True;
  FListaArquivos.Add(LPath);
end;

end.
