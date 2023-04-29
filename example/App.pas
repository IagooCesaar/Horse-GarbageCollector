unit App;

interface

type
  TApp = class
  public
    procedure Start;
    procedure Stop;

    function BaseURL: String;
  end;


implementation

uses
  System.SyncObjs,
  System.SysUtils,

  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.GarbageCollector,

  Controllers.Example;

function TApp.BaseURL: String;
begin
  Result := Format('http://localhost:%d', [THorse.Port]);
end;

procedure TApp.Start;
begin
  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  THorse.Use(Jhonson('UTF-8'))
        .Use(HandleException)
        .Use(THorseGarbageCollector.GetCollector.HorseCallback);

  Controllers.Example.Registry;

  THorse.Listen(StrToIntDef(GetEnvironmentVariable('SERVER_PORT'), 9000),
    procedure
    begin
      {$IF (not defined(TEST))}
      Writeln(Format('Server is runing on %s:%d', [THorse.Host, THorse.Port]));
      Readln;
      {$ENDIF}
    end);
end;

procedure TApp.Stop;
begin
  THorse.StopListen;
end;

end.
