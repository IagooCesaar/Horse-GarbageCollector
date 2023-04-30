unit Model.Interfaces;

interface

uses
  DTO.Arquivo,
  Horse.OctetStream;

type
  IModelArquivo = interface
    ['{C41AC801-A2F9-41DA-B327-57560AD1716C}']
    function CriarArquivo(ADTOArquivo: TDTOArquivo): String;
    function ObterArquivo(ADTOArquivo: TDTOArquivoStream): TFileReturn;
  end;

implementation

end.
