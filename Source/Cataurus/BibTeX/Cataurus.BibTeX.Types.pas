unit Cataurus.BibTeX.Types;

interface

uses
  System.Classes,
  System.Generics.Collections;

const
   cBibTeXEntriesTypesCount = 36;
   cBibTeXEintragStart = '@';
   cBibTeXEntriesStart ='{';
   cBibTeXEntriesEnd = '}';
   cBibTeXEntriesDel = ',';
   cBibTeXEntriesSep = '=';

type
  TReferenzArt = (article, book, booklet, conference, inbook, incollection,
                  inproceedings, manual, mastersthesis, misc, phdthesis,
                  proceedings, techreport, unpublished);

  TBibTeXEntriesTypes = (author, title, journal, year, editor,
                         publisher, booktitle, chapter, pages,
                         address, school, institution, note,
                         volume, number, month, series, edition, isbn,
                         howpublished, organization, _type, keywords, url,
                         added_at, biburl, interhash, crossref, _file,
                         doi, comment, owner, timestamp, _abstract, review,
                         intrahash);

  TBibTeXEntries = set of TBibTeXEntriesTypes;

  TBibTeXStructurRec = record
    Referenz : TReferenzArt;
    Required : TBibTeXEntries;
    Optional : TBibTeXEntries;
  end;

  TBibTeXEntrie = record
    Entrie : TBibTeXEntriesTypes;
    IsExport : Boolean;
  end;

  TBibTeXEntrieList = TList<TBibTeXEntrie>;

  TBibTeXStructur = TList<TBibTeXStructurRec>;

  TBibTeX = TList<TStringList>;

var
  BibTeXStructur : TBibTexStructur;



implementation

var
  _BibTeXStruc : TBibTeXStructurRec;


{ TBibTeX }

initialization

  BibTeXStructur := TBibTeXStructur.Create;
  _BibTeXStruc.Referenz := TReferenzArt.article;
  _BibTeXStruc.Required := [author, title, journal, year];
  _BibTeXStruc.Optional := [volume, number, pages, month, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.book;
  _BibTeXStruc.Required := [author, editor, title, publisher, year];
  _BibTeXStruc.Optional := [volume, number, series, address, edition, month, note, isbn];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.booklet;
  _BibTeXStruc.Required := [title];
  _BibTeXStruc.Optional := [author, howpublished, address, month, year, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.conference;
  _BibTeXStruc.Required := [author, title, booktitle, year];
  _BibTeXStruc.Optional := [editor, volume, number, series, pages, address, month, organization, publisher, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.inbook;
  _BibTeXStruc.Required := [author, editor, title, chapter, pages, publisher, year];
  _BibTeXStruc.Optional := [volume, number, series, _type, address, edition, month, note];
  BibTeXStructur.Add( _BibTeXStruc );
   _BibTeXStruc.Referenz := TReferenzArt.incollection;
  _BibTeXStruc.Required := [author, title, booktitle, publisher, year];
  _BibTeXStruc.Optional := [editor, volume, number, series, _type, chapter, pages, address, edition, month, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.inproceedings;
  _BibTeXStruc.Required := [author, title, booktitle, year];
  _BibTeXStruc.Optional := [editor, volume, number, series, pages, address, month, organization, publisher, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.manual;
  _BibTeXStruc.Required := [address, title, year];
  _BibTeXStruc.Optional := [author, organization, edition, month, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.mastersthesis;
  _BibTeXStruc.Required := [author, title, school, year];
  _BibTeXStruc.Optional := [_type, address, month, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.misc;
  _BibTeXStruc.Required := [];
  _BibTeXStruc.Optional := [author, title, howpublished, month, year, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.phdthesis;
  _BibTeXStruc.Required := [author, title, school, year];
  _BibTeXStruc.Optional := [_type, address, month, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.proceedings;
  _BibTeXStruc.Required := [title, year];
  _BibTeXStruc.Optional := [editor, volume, number, series, address, month, organization, publisher, note];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.techreport;
  _BibTeXStruc.Required := [author, title, institution, year];
  _BibTeXStruc.Optional := [_type, note, number, address, month];
  BibTeXStructur.Add( _BibTeXStruc );
  _BibTeXStruc.Referenz := TReferenzArt.unpublished;
  _BibTeXStruc.Required := [author, title, note];
  _BibTeXStruc.Optional := [month, year];
  BibTeXStructur.Add( _BibTeXStruc );

finalization
  if Assigned(BibTeXStructur) then BibTeXStructur.Free;

end.
