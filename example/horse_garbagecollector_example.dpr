program horse_garbagecollector_example;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'App.pas',
  Controllers.Example in 'Controllers.Example.pas',
  DTO.Arquivo in 'DTO.Arquivo.pas',
  Horse.GarbageCollector in '..\src\Horse.GarbageCollector.pas',
  Horse.GarbageCollector.Interfaces in '..\src\Horse.GarbageCollector.Interfaces.pas',
  Model.Interfaces in 'Model.Interfaces.pas',
  Model.Arquivo in 'Model.Arquivo.pas';

begin
  try
    var App : TApp;
    App := TApp.Create;
    App.Start;

    App.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
