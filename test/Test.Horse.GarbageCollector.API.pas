unit Test.Horse.GarbageCollector.API;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TMyTestObject = class
  public
  end;

implementation

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
