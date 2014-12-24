unit Cataurus.BibTex.Utils;

interface

uses
  System.Classes, Cataurus.BibTeX.Types, System.Generics.Collections, System.SysUtils;

function GetStrFromReferenzArt(Source : TReferenzArt) : string;
function GetStrForBibTeXEntriesTypes(Source : TBibTeXEntriesTypes) : string;
procedure GetEintragListeFromBibTeXQuelle(Source : string; DestList : TStringList);
// Entfernt Kommentarzeilen aus einer BibTeX-File
procedure ClearBibTeXFileFromKommentare(Source : TStringList);
// entfernt leere Zeile aus einer BibTeX-File
procedure ClearBibTeXFileFromClearLine(Source : TStringList);
//
function GetDelphiKonformStr(Source : string) : string;
// analysiert einen String von Entries
procedure ParseEntries(Source : TStringList; Dest : TBibTeX);
//
procedure ParseBibTeXStr(Source : string; Dest : TBibTeX);
//
function LoadBibTeXFileToStr(Name : TFileName) : string;

implementation

uses
  Cataurus.Allgemein.StrUtils;

procedure ClearBibTeXFileFromKommentare(Source: TStringList);
var
  I: integer;
begin
  I := 0;
  while I < Source.Count - 1 do
  begin
    if (Pos('%', Source[I]) <> 0) then
    begin
      Source.Delete(I);
      I := I - 1;
    end;
    Inc(I);
  end;
end;

procedure ClearBibTeXFileFromClearLine(Source: TStringList);
var
  I: integer;
begin
  I := 0;
  while I < Source.Count - 1 do
  begin
    if (Source[I] = '') then
    begin
      Source.Delete(I);
      I := I - 1;
    end;
    Inc(I);
  end;
end;

function GetStrFromReferenzArt(Source : TReferenzArt) : string;
begin
  result := '';
  case Source of
    article: result := 'articel';
    book: result := 'book';
    booklet: result := 'booklet';
    conference: result := 'conferenz';
    inbook: result := 'inbook';
    incollection: result := 'incollection';
    inproceedings: result := 'inproceedings';
    manual: result := 'manual';
    mastersthesis: result := 'mastersthesis';
    misc: result := 'misc';
    phdthesis: result := 'phdthesis';
    proceedings: result := 'proceedings';
    techreport: result := 'techreport';
    unpublished: result := 'unpublished';
  end;
end;

function GetStrForBibTeXEntriesTypes(Source : TBibTeXEntriesTypes) : string;
begin
  result := '';
  case Source of
    author: result := 'author';
    title: result := 'title';
    journal: result := 'journal';
    year: result := 'year';
    editor: result := 'editor';
    publisher: result := 'publisher';
    booktitle: result := 'booktitle';
    chapter: result := 'chapter';
    pages: result := 'pages';
    address: result := 'address';
    school: result := 'school';
    institution: result := 'institution';
    note: result := 'note';
    volume: result := 'volume';
    number: result := 'number';
    month: result := 'month';
    series: result := 'series';
    edition: result := 'edition';
    isbn: result := 'isbn';
    howpublished: result := 'howpuplished';
    organization: result := 'organization';
    _type: result := 'type';
    keywords : result := 'keywords';
    url : result := 'url';
    added_at : result := 'added-at';
    biburl : result := 'biburl';
    interhash : result := 'interhash';
    crossref : result := 'crossref';
    _file : result := 'file';
    doi : result := 'doi';
    comment : result := 'comment';
    owner : result := 'owner';
    timestamp : result := 'timestamp';
    _abstract : result := 'abstract';
    review : result := 'review';
    intrahash : result := 'intrahash';
  end;
end;

procedure GetEintragListeFromBibTeXQuelle(Source : string; DestList : TStringList);
var
  FirstChar, NextChar : integer;
  NextCharIsLast : Boolean;
  Eintrag : string;
begin
  FirstChar := Pos('@', Source);
  NextChar := Pos('@', Source, FirstChar+1);
  repeat
    Eintrag := Copy(Source, FirstChar, NextChar-FirstChar);
    DestList.Add(Eintrag);
    FirstChar := NextChar;
    NextChar := Pos('@', Source, FirstChar+1);
    NextCharIsLast := NextChar = 0;
  until NextCharIsLast;
  Eintrag := Copy(Eintrag, FirstChar);
  DestList.Add(Eintrag);
end;

procedure ParseEntries(Source : TStringList; Dest : TBibTeX);

  procedure ParseLine(SourceStr : string);
  var
    Referenz : string;
    ReferenzID : string;
    _EintragList : TStringList;
    _PosDelemiterElement : integer;
    Element, ElementValue : string;
    _Eintrag : string;
    idx : integer;
  begin
    _Eintrag := SourceStr;
    idx := Pos(cBibTeXEintragStart, _Eintrag);
    if  idx > 0 then
    begin
      Delete(_Eintrag, 1, 1);
    end;

    idx := Pos(cBibTeXEntriesStart, _Eintrag);
    Referenz := Copy(_Eintrag, 1, idx-1);
    Delete(_Eintrag, 1, idx);

    idx := Pos(cBibTeXEntriesDel, _Eintrag);
    ReferenzID := Copy(_Eintrag, 1, idx-1);
    Delete(_Eintrag, 1, idx);

    _EintragList := Dest[Dest.Add(TStringList.Create)];
    _EintragList.Add('referenz='+Referenz);
    _EintragList.Add('referenzid='+ReferenzID);

    idx := Pos(cBibTeXEntriesSep, _Eintrag);
    repeat
        Element := Copy(_Eintrag, 1, idx-1);
        Element := StrClearFromAllSpaces(Element);
        Element := LowerCase(Element);
        Delete(_Eintrag, 1, idx);

        ElementValue := Copy(_Eintrag, 1, Pos('}', _Eintrag));
        ElementValue := StringClearFromGeschweiftenKlammern(ElementValue);
        Delete(_Eintrag, 1, Pos('}', _Eintrag)+1);

        _EintragList.Add(Element + '=' + ElementValue);
        _PosDelemiterElement := Pos(cBibTeXEntriesSep, _Eintrag);
    until _PosDelemiterElement <= 0;
  end;
var
  k : integer;
begin
  for k := 0 to Source.Count - 1 do
  begin
    ParseLine(Source[k]);
  end;
end;

procedure ParseBibTeXStr(Source : string; Dest : TBibTeX);
var
  EntriesListe : TStringList;
  I : Integer;
begin
  // BibTeX parsen
  // Liste von Einträge aus der BibTexQuelle erstellen
  EntriesListe := TStringList.Create;
  try
    // erstellen einer Liste von Entries
    GetEintragListeFromBibTeXQuelle(Source, EntriesListe);
    ParseEntries(EntriesListe, Dest);
  finally
    EntriesListe.Free;
  end;
end;

//
function LoadBibTeXFileToStr(Name : TFileName) : string;
var
  BibTeXFile : TStringList;
  I : integer;
begin
  result := '';
  // Datei laden
  BibTeXFile := TStringList.Create;
  try
    BibTeXFile.LoadFromFile(Name);
   // zum Parsen vorbereiten
   ClearBibTeXFileFromKommentare(BibTeXFile);
   ClearBibTeXFileFromClearLine(BibTeXFile);
   // BibTeX in eine Zeile schreiben
   for I := 0 to BibTeXFile.Count - 1 do
   begin
     result := result + ' ' + BibTeXFile[I];
   end;
  finally
    BibTeXFile.Free;
  end;
end;

function GetDelphiKonformStr(Source : string) : string;
var
  StrBuilder : TStringBuilder;
begin
  StrBuilder := TStringBuilder.Create;
  try
  StrBuilder.Append(Source);
  StrBuilder.Replace('-', '_');
  StrBuilder.Replace('file', '_file');
  StrBuilder.Replace('abstract', '_abstract');
  result := StrBuilder.ToString;
  finally
    StrBuilder.Free;
  end;
end;

end.
