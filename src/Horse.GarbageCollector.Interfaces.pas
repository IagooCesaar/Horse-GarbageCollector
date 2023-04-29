unit Horse.GarbageCollector.Interfaces;

interface

uses
  Horse,
  System.Classes;

type

  IHorseGarbageCollectorObserver = interface
    ['{B79B4A2F-2671-4591-AAA7-91D60BDAA7BC}']
    function CanCollectGarbage: Boolean;
    function GetFileListToDelete: TStringList;
  end;

  IHorseGarbageCollectorObservers = interface
    ['{53CBEBA9-D1AC-4C8F-98E6-1C97275028CB}']
    function Add(Observer: IHorseGarbageCollectorObserver): IHorseGarbageCollectorObservers;
    function Get(Index: Integer): IHorseGarbageCollectorObserver;
    function Count: Integer;

    procedure DoGarbageCollection;
  end;

implementation

end.
