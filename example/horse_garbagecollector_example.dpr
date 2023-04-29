program horse_garbagecollector_example;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  App in 'App.pas';

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