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

  end;

implementation

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

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
