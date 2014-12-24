unit Cataurus.Komponenten.BibTeXDataSet;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Data.DB,
  Datasnap.DBClient, Cataurus.BibTeX.Types;

type
  TBibTeXExportOptions = class(TObject)
  private
    FList : TBibTeXEntrieList;
    FIniFile: TFileName;
    FAutoSave: Boolean;
    function GetEntrie(Idx : integer): TBibTeXEntriesTypes;
    function GetIsExport(Idx : integer): Boolean;
    procedure SetIsExport(Idx : integer; Value: Boolean);
    procedure SetIniFile(const Value: TFileName);
  public
    constructor Create(AOwner: TComponent); virtual;
    destructor Destroy; override;
    procedure ShowOption;
    procedure Save;
    procedure Load;
    property Entrie[Idx : integer] : TBibTeXEntriesTypes read GetEntrie;
    property IsExport[Idx : integer] : Boolean read GetIsExport write SetIsExport;
  published
    property IniFile : TFileName read FIniFile write SetIniFile;
    property AutoSave : Boolean read FAutoSave write FAutoSave;
  end;

  TBibTeXDataSet = class(TClientDataSet)
  private
    FFileName: TFileName;
    FExportOptions: TBibTeXExportOptions;
    procedure SetFileName(const Value: TFileName);
    { Private-Deklarationen }
  protected
    { Protected-Deklarationen }
  public
    { Public-Deklarationen }
    ListOfEntries : TBibTeX;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadBibTeXFile;
    procedure SaveBibTeXFile;
  published
    { Published-Deklarationen }
    property FileName : TFileName read FFileName write SetFileName;
    property ExportOptions : TBibTeXExportOptions  read FExportOptions write FExportOptions;
  end;

procedure Register;

implementation

uses
  System.IniFiles,
  Vcl.Forms,
  Cataurus.BibTeX.Utils,
  Cataurus.Komponenten.BibTeXDataSet.DlgBibTeXOption;

procedure Register;
begin
  RegisterComponents('Cataurus', [TBibTexDataSet]);
end;

{ TBibTeXDataSet }

constructor TBibTeXDataSet.Create(AOwner: TComponent);
var
  I: Integer;
begin
  inherited Create(AOwner);
  FExportOptions := TBibTeXExportOptions.Create(self);
  // Referenz
  FieldDefs.Add(
      'referenz',
      TFieldType.ftString,
      255
      );
  // Referenzid
  FieldDefs.Add(
      'referenzid',
      TFieldType.ftString,
      255
      );
  // Felder definieren gem‰ﬂ BibTex
  for I := 0 to cBibTeXEntriesTypesCount - 1 do
  begin
    FieldDefs.Add(
      GetStrForBibTeXEntriesTypes(TBibTExEntriesTypes(I)),
      TFieldType.ftString,
      255
      );
  end;
  ListOfEntries := TBibTeX.Create;
end;

destructor TBibTeXDataSet.Destroy;
begin
  ListOfEntries.Free;
  FExportOptions.Free;
  inherited;
end;

procedure TBibTeXDataSet.LoadBibTeXFile;
var
  BibTeXSource : string;
begin
  if Active and (not (EOF and Bof)) then
  begin
    repeat
      First;
      Delete;
    until EOF;
    Active := false;
  end;
  Active := true;
  if (FFileName <> '') and System.SysUtils.FileExists(FFileNAme) then
  begin
    BibTeXSource := LoadBibTeXFileToStr(FFileName);
    ParseBibTeXStr(BibTeXSource, ListOfEntries);
  end;
end;

procedure TBibTeXDataSet.SaveBibTeXFile;
var
  Source : TStringList;
  I : integer;
  Field : TStringField;
  strSource : string;
begin
  Source := TStringList.Create;
  try
    Source.Add('#Erzeugt von Literaturverwaltung 1.0 von Benjamin Kaiser & Ulf Prill');
    First;
    repeat
      Field := FieldByNumber(0) as TStringField;
      strSource := '@'+Field.AsString;
      Field := FieldByNumber(1) as TStringField;
      strSource := strSource+'{'+Field.Value+',';
      Source.Add(strSource);
      for I := 2 to Fields.Count - 1 do
      begin
        Field := FieldByNumber(I) as TStringField;
        strSource := '     {'+Field.FullName + '=' +Field.Value+'}';
        Source.Add(strSource);
      end;
      Source.Add('}');
      Next;
    until not EOF;
    Source.SaveToFile(FileName);
  finally
    Source.Free;
  end;
end;

procedure TBibTeXDataSet.SetFileName(const Value: TFileName);
begin
  FFileName := Value;
end;

{ TBibTeXExportOptions }

constructor TBibTeXExportOptions.Create(AOwner: TComponent);
  procedure CreateEintrie(Idx : Integer);
  var
    Eintrag : TBibTeXEntrie;
  begin
    Eintrag.Entrie := TBibTeXEntriesTypes(Idx);
    Eintrag.IsExport := true;
    FList.Add(Eintrag);
  end;
var
  I : integer;
begin
  inherited Create;
  FList := TBibTeXEntrieList.Create;
  for I := 0 to cBibTeXEntriesTypesCount - 1 do
    begin
      CreateEintrie(I);
    end;
  FIniFile := '';
  FAutoSave := true;
end;

destructor TBibTeXExportOptions.Destroy;
begin
  if FAutoSave then
  begin
    Save;
  end;
  FList.Free;
  inherited;
end;

function TBibTeXExportOptions.GetEntrie(Idx: integer): TBibTeXEntriesTypes;
begin
  result := FList[Idx].Entrie;
end;

function TBibTeXExportOptions.GetIsExport(Idx : integer): Boolean;
begin
  result := FList[Idx].IsExport;
end;

procedure TBibTeXExportOptions.Load;
var
  I : integer;
  MyIniFile : TIniFile;
  Eintrag : TBibTeXEntrie;
begin
  if FIniFile <> '' then
  begin
    MyIniFile := TIniFile.Create(FIniFile);
    try
      for I := 0 to cBibTeXEntriesTypesCount - 1 do
      begin
        Eintrag := FList[I];
        Eintrag.IsExport := MyIniFile.ReadBool('BibTeXExportOption', IntToStr(I), true);
        FList[I] := Eintrag;
      end;
    finally
      MyIniFile.Free;
    end;
  end;
end;

procedure TBibTeXExportOptions.Save;
var
  I : integer;
  MyIniFile : TIniFile;
  Eintrag : TBibTeXEntrie;
begin
  if FIniFile = '' then
  begin
    FIniFile := ExtractFilePath(Application.ExeName) + 'BibTeXOption.ini';
  end;
  if FIniFile <> '' then
  begin
    MyIniFile := TIniFile.Create(FIniFile);
    try
      for I := 0 to cBibTeXEntriesTypesCount - 1 do
      begin
        Eintrag := FList[I];
        MyIniFile.WriteBool('BibTeXExportOption', IntToStr(I), Eintrag.IsExport);
      end;
      MyIniFile.UpdateFile;
    finally
      MyIniFile.Free;
    end;
  end;
end;

procedure TBibTeXExportOptions.SetIniFile(const Value: TFileName);
begin
  FIniFile := Value;
end;

procedure TBibTeXExportOptions.SetIsExport(Idx : integer; Value: Boolean);
var
  Eintrag : TBibTeXEntrie;
begin
  Eintrag := FList.Items[Idx];
  Eintrag.IsExport := Value;
  FList.Items[Idx] := Eintrag;
end;

procedure TBibTeXExportOptions.ShowOption;
begin
  Execute_frDlgBibTeXOption(nil, FList);
end;

end.
