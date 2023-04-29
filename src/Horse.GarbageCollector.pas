unit Horse.GarbageCollector;

interface

uses
  System.Classes,
  System.SysUtils,

  Horse,
  Horse.GarbageCollector.Interfaces;

type
  THorseGarbageCollector = class(TInterfacedObject,
    IHorseGarbageCollectorObservers)
  private
    FList: IInterfaceList;

    class var FCollector: THorseGarbageCollector;

  public
    class function HorseCallback: THorseCallback;
    class function GetCollector: THorseGarbageCollector;
    class destructor UnInitialize;

    constructor Create;
    destructor Destroy; override;

    { IHorseGarbageCollectorObservers }
    function Add(Observer: IHorseGarbageCollectorObserver): IHorseGarbageCollectorObservers;
    function Get(Index: Integer): IHorseGarbageCollectorObserver;
    function Count: Integer;
    procedure DoGarbageCollection;


  end;

implementation

procedure DefaultHorseCallback(AReq: THorseRequest; ARes: THorseResponse; ANext: TNextProc);
begin
  try
    ANext();
  finally
    THorseGarbageCollector.GetCollector.DoGarbageCollection;
  end;
end;

{ THorseGarbageCollectorCore }

function THorseGarbageCollector.Add(
  Observer: IHorseGarbageCollectorObserver): IHorseGarbageCollectorObservers;
begin
  Result := Self;
  FList.Add(Observer);
end;

function THorseGarbageCollector.Count: Integer;
begin
  Result := FList.Count;
end;

constructor THorseGarbageCollector.Create;
begin
  FList := TInterfaceList.Create;
end;

destructor THorseGarbageCollector.Destroy;
begin

  inherited;
end;

procedure THorseGarbageCollector.DoGarbageCollection;
var LFileList : TStringList; LObserver : IHorseGarbageCollectorObserver;
begin
  for var i := Pred(FList.Count) downto 0 do
  begin
    LObserver := FList.Items[i] as IHorseGarbageCollectorObserver;

    if LObserver.CanCollectGarbage
    then begin
      LFileList := LObserver.GetFileListToDelete;
      try
        for var f := 0 to Pred(LFileList.Count) do
          if FileExists(LFileList.Strings[f])
          then DeleteFile(LFileList.Strings[f]);
      finally
        LFileList.Free;
      end;
      FList.Remove(LObserver);
    end;
  end;
end;

function THorseGarbageCollector.Get(
  Index: Integer): IHorseGarbageCollectorObserver;
begin
  Result := FList.Items[Index] as IHorseGarbageCollectorObserver;
end;

class function THorseGarbageCollector.GetCollector: THorseGarbageCollector;
begin
  if not Assigned(FCollector) then
  begin
    FCollector := THorseGarbageCollector.Create;
  end;
  Result := FCollector;
end;

class function THorseGarbageCollector.HorseCallback: THorseCallback;
begin
  Result := DefaultHorseCallback;
end;


class destructor THorseGarbageCollector.UnInitialize;
begin
  if FCollector <> nil
  then FreeAndNil(FCollector);
end;

end.
