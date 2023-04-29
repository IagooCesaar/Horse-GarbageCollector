unit DTO.Arquivo;

interface

type
  TDTOArquivo = class
  private
    FNome: String;
    FConteudo: String;
  public
    property Nome: String read FNome write FNome;
    property Conteudo: String read FConteudo write FConteudo;
  end;

implementation

end.
