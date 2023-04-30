unit Test.Horse.GarbageCollector.API;

interface

uses
  DUnitX.TestFramework,
  App,
  RESTRequest4D;

type
  [TestFixture]
  TMyTestObject = class
  private
    FApp: TApp;
    function BaseRequest: IRequest;
  public
    [SetupFixture]
    procedure SetupFixture;

    [TearDownFixture]
    procedure TearDownFixture;

    [Test]
    procedure Test_ArquivoCriadoSeraDeletado;

  end;

implementation

uses
  System.JSON,
  System.SysUtils,
  REST.Json,
  DTO.Arquivo;

{ TMyTestObject }

function TMyTestObject.BaseRequest: IRequest;
begin
  Result := TRequest.New
    .BaseURL(FApp.BaseURL);
end;

procedure TMyTestObject.SetupFixture;
begin
  FApp := TApp.Create;
  FApp.Start;
end;

procedure TMyTestObject.TearDownFixture;
begin
  FApp.Stop;
  FApp.Free;
end;

procedure TMyTestObject.Test_ArquivoCriadoSeraDeletado;
var LResponse : IResponse; LBody: TJSONObject; LDTOArquivo: TDTOArquivo;
begin
  try
    LDTOArquivo := TDTOArquivo.Create;
    LDTOArquivo.Nome := 'teste-auto';
    LDTOArquivo.Conteudo := 'teste automatizado';

    LResponse := BaseRequest
      .Resource('/criar-arquivo')
      .AddBody(TJson.ObjectToJsonString(LDTOArquivo))
      .Post();

  finally
    LDTOArquivo.Free;
  end;

  Assert.AreEqual(201, LResponse.StatusCode);

  LBody := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
  try
    // Indica que quando ainda no controller o arquivo existia
    Assert.IsTrue(LBody.GetValue<Boolean>('exists'));

    // Após Response.Send no controller, o Middleware deletará o arquivo
    Assert.IsFalse(
      FileExists(LBody.GetValue<string>('path'))
    );
  finally
    LBody.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
