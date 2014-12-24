unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.StdCtrls,
  Vcl.Grids, Vcl.DBGrids, System.Actions, Vcl.ActnList, Vcl.StdActns,
  Vcl.ActnMenus, Vcl.RibbonActnMenus, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.Ribbon, Vcl.RibbonLunaStyleActnCtrls, System.Generics.Collections,
  Cataurus.BibTeX.Types, Vcl.ImgList, dlgExportOptionenForBib,
  Cataurus.Komponenten.BibTeXDataSet;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Label1: TLabel;
    Allgemein: TRibbon;
    RibbonPage1: TRibbonPage;
    RibbonGroup1: TRibbonGroup;
    ActionManager1: TActionManager;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    Action1: TAction;
    Action2: TAction;
    ImageList1: TImageList;
    Button2: TButton;
    Button3: TButton;
    BibTeXDataSet1: TBibTeXDataSet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure EntferneKommantarZeilen_LeerZeilen(var Source : TStringList);
    procedure AnalysiereEndblock(Source : TStringList);
    procedure HinzufügenBlock(Source : TStringList);
    function GetTReferenzArt(Source :string) : TReferenzArt;
    function StringClearFromSpaces(Source : string) : string;
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Cataurus.BibTex.Utils,
  Cataurus.Allgemein.StrUtils;

procedure TForm1.AnalysiereEndblock(Source: TStringList);
var
  k: Integer;

  procedure ParseEintrag(Eintrag : string);
  var
    _Referenz : string;
    _ID : string;
    _EintragList : TStringList;
    _PosDelemiterElement : integer;
    Element, ElementValue : string;
    _PosEintragsBegrenzer : integer;
    _Eintrag : string;
    _idx : integer;
  begin
    _Eintrag := Eintrag;
    _idx := Pos('@', _Eintrag);
    if  _idx > 0 then
    begin
      Delete(_Eintrag, 1, 1);
    end;
    _PosEintragsBegrenzer := Pos('{', _Eintrag);
    _Referenz := Copy(_Eintrag, 1, _PosEintragsBegrenzer-1);
    Delete(_Eintrag, 1, _PosEintragsBegrenzer);
    _ID := Copy(_Eintrag, 1, Pos(',', _Eintrag)-1);
    Delete(_Eintrag, 1, Pos(',', _Eintrag));
    _EintragList := TStringList.Create;
    try
      _EintragList.Add('referenz='+_Referenz);
      _EintragList.Add('referenzid='+_id);
      _PosDelemiterElement := Pos('=', _Eintrag);
      repeat
        Element := Copy(_Eintrag, 1, _PosDelemiterElement-1);
        Element := StringClearFromSpaces(Element);
        Delete(_Eintrag, 1, _PosDelemiterElement);

        ElementValue := Copy(_Eintrag, 1, Pos('}', _Eintrag));
        ElementValue := StringClearFromGeschweiftenKlammern(ElementValue);
        Delete(_Eintrag, 1, Pos('}', _Eintrag)+1);

        _EintragList.Add(Element + '=' + ElementValue);
        _PosDelemiterElement := Pos('=', _Eintrag);
      until _PosDelemiterElement <= 0;
      HinzufügenBlock(_EintragList);
    finally
      _EintragList.Free;
    end;
  end;

begin
  for k := 0 to Source.Count - 1 do
  begin
    ParseEintrag(Source[k]);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  BibTexFile : TStringList;
  Eintrag : TStringList;
  I, k : integer;
  AnfangBlock, EndBlock : integer;
  BibTexQuelle : string;
  EintragList : TStringList;
begin
  BibTeXDataSet1.SaveBibTeXFile;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  BibTeXDataSet1.ExportOptions.ShowOption;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  I, K : integer;
begin
  OpenDialog1.Execute;
  BibTeXDataSet1.FileName := OpenDialog1.FileName;
  BibTeXDataSet1.LoadBibTeXFile;
  for I := 0 to BibTeXDataSet1.ListOfEntries.Count-1 do
  begin
    BibTeXDataSet1.Append;
    if not Assigned(BibTeXDataSet1.ListOfEntries) then ShowMessage('Test#');

    for k := 0 to BibTeXDataSet1.ListOfEntries[I].Count - 1 do
    begin
      try
        BibTeXDataSet1.FieldValues[BibTeXDataSet1.ListOfEntries[I].Names[k]] :=
           BibTeXDataSet1.ListOfEntries[I].ValueFromIndex[k];
      Except
        on Exception do
        begin
          ShowMessage('Beim Importieren des Feldes : '
            + BibTeXDataSet1.ListOfEntries[I].Names[k] + ' mit dem Wert: '
            + BibTeXDataSet1.ListOfEntries[I].ValueFromIndex[k]
            + ' ist ein Fehler aufgetreten.');
        end;
      end;
//              //(FindField(ListOfEntries[I].Names[k]) as TStringField).AsString := ListOfEntries[I].ValueFromIndex[k];
    end;
    BibTeXDataSet1.Post;
  end;
//      begin
//        try
//          Insert;
//        except
//
//        end;
//        for k := 0 to ListOfEntries[I].Count - 1 do
//        begin
//              FieldValues[ListOfEntries[I].Names[k]] := ListOfEntries[I].ValueFromIndex[k];
//              //(FindField(ListOfEntries[I].Names[k]) as TStringField).AsString := ListOfEntries[I].ValueFromIndex[k];
//        end;
//            Post;
//      end;
end;

procedure TForm1.EntferneKommantarZeilen_LeerZeilen(var Source: TStringList);
var
  I: integer;
begin
I := 0;
while I < Source.Count - 1 do
begin
  if (Pos('%', Source[I]) <> 0) or
     (Source[I] = '')
   then
  begin
     Source.Delete(I);
     I := I - 1;
  end;
  Inc(I);
end;
end;

function TForm1.GetTReferenzArt(Source: string): TReferenzArt;
begin
  if LowerCase(Source) = 'article' then
  begin
    result := TReferenzArt.article;
  end else
    if LowerCase(Source) = 'book' then
    begin
      result := TReferenzArt.book;
    end else
    if LowerCase(Source) = 'booklet' then
    begin
      result := TReferenzArt.booklet;
    end else
    if LowerCase(Source) = 'conference' then
    begin
      result := TReferenzArt.conference;
    end else
      if LowerCase(Source) = 'inbook' then
    begin
      result := TReferenzArt.inbook;
    end else
    if LowerCase(Source) = 'incollection' then
    begin
      result := TReferenzArt.incollection;
    end else
    if LowerCase(Source) = 'inproceedings' then
    begin
      result := TReferenzArt.inproceedings;
    end else
    if LowerCase(Source) = 'manual' then
    begin
      result := TReferenzArt.manual;
    end else
    if LowerCase(Source) = 'mastersthesis' then
    begin
      result := TReferenzArt.mastersthesis;
    end else
    if LowerCase(Source) = 'phdthesis' then
    begin
      result := TReferenzArt.phdthesis;
    end else
    if LowerCase(Source) = 'proceedings' then
    begin
      result := TReferenzArt.proceedings;
    end else
    if LowerCase(Source) = 'techreport' then
    begin
      result := TReferenzArt.techreport;
    end else
    if LowerCase(Source) = 'unpublished' then
    begin
      result := TReferenzArt.unpublished;
    end else
      result := TReferenzArt.misc;
end;

procedure TForm1.HinzufügenBlock(Source: TStringList);
begin

end;

function TForm1.StringClearFromSpaces(Source : string) : string;
var
  _Name : string;
begin
  _Name := Source;
  while Pos(' ', _Name) > 0 do
  begin
    Delete(_Name, Pos(' ', _Name), 1);
  end;
  result := _Name;
end;

end.
