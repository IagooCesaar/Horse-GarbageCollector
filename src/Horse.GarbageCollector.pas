unit Horse.GarbageCollector;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,

  Horse,
  Horse.GarbageCollector.Interfaces;

type
  THorseGarbageCollector = class(TNoRefCountObject,
    IHorseGarbageCollectorObservers)
  private
    //FObservers: TInterfaceList;
    FObservers: TList<IHorseGarbageCollectorObserver>;

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
  FObservers.Add(Observer);
end;

function THorseGarbageCollector.Count: Integer;
begin
  FObservers.TrimExcess;
  Result := FObservers.Count;
end;

constructor THorseGarbageCollector.Create;
begin
  //FObservers := TInterfaceList.Create;
  FObservers := TList<IHorseGarbageCollectorObserver>.Create;
end;

destructor THorseGarbageCollector.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure THorseGarbageCollector.DoGarbageCollection;
var LFileList : TStringList; LObserver : IHorseGarbageCollectorObserver;
begin
  for var i := Pred(Self.Count) downto 0 do
  begin
    if not Assigned(Self.Get(i))
    then Continue;

    LObserver := Self.Get(i) as IHorseGarbageCollectorObserver;

    if LObserver.CanCollectGarbage
    then begin
      LFileList := LObserver.GetFileListToDelete;
      if Assigned(LFileList)
      then try
        for var f := 0 to Pred(LFileList.Count) do
          if FileExists(LFileList.Strings[f])
          then DeleteFile(LFileList.Strings[f]);
      finally
        LFileList.Free;
      end;
      FObservers.Remove(LObserver);
    end;
  end;
end;

function THorseGarbageCollector.Get(
  Index: Integer): IHorseGarbageCollectorObserver;
begin
  Result := FObservers.Items[Index] as IHorseGarbageCollectorObserver;
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
