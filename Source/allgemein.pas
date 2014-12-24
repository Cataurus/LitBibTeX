unit allgemein;

interface

uses
  System.SysUtils, System.Classes, JvAppStorageSelectList, JvComponentBase,
  JvAppIniStorage, JvFormPlacementSelectList, JvAppStorage,
  dlgExportOptionenForBib;

type
  TDataModule1 = class(TDataModule)
    JvAppIniFileStorage1: TJvAppIniFileStorage;
    JvFormStorageSelectList1: TJvFormStorageSelectList;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
