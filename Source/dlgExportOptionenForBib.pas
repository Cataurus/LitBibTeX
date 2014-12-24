unit dlgExportOptionenForBib;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, JvComponentBase,
  JvFormPlacement, JvExComCtrls, Vcl.StdCtrls;

type
  TdlgExportOptionenBibTeX = class(TForm)
    JvFormStorage1: TJvFormStorage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  dlgExportOptionenBibTeX: TdlgExportOptionenBibTeX;

implementation

{$R *.dfm}

uses
  cataurus.BibTeX.Types, cataurus.BibTeX.Utils, allgemein;

procedure TdlgExportOptionenBibTeX.FormCreate(Sender: TObject);
var
  i, l: Integer;
  EntriesSet: TBibTeXEntries;
  k: TBibTeXEntriesTypes;
  Referenz: string;
  GbOptional, GbRequired : TGroupBox;
  tsReferenz : TTabSheet;
  Entries : TCheckBox;
  Eintraege : TStringList;
begin
  inherited;
  Eintraege := TStringList.Create;
  for i:= 0 to BibTeXStructur.Count -1 do
  begin
    Referenz := GetStrFromReferenzArt( BibTeXStructur.Items[i].Referenz);
    tsReferenz := TTabSheet.Create(Self);
    tsReferenz.PageControl := PageControl1;
    tsReferenz.Name := 'PC'+Referenz;
    tsReferenz.Caption := Referenz;
    GbRequired := TGroupBox.Create(self);
    GbRequired.Parent := tsReferenz;
    GbRequired.Caption := 'Required';
    GbRequired.Name := 'gb'+Referenz+'Optional';
    GbRequired.Align := TAlign.alLeft;
    GbRequired.Visible := true;
    GbRequired.Width := 200;
    l := 0;
    EntriesSet := BibTeXStructur.Items[i].Required;
    for k in EntriesSet do
    begin
      Entries := TCheckBox.Create(nil);
      Entries.Parent := GbRequired;
      Entries.Top := 25 + l*25;
      Entries.Width := 190;
      Entries.Left := 10;
      Entries.Caption := GetStrForBibTeXEntriesTypes(k);
      Entries.Name := 'cb'+ GbRequired.Name +''+Entries.Caption;
      Entries.Visible := true;
      Entries.BringToFront;
      Eintraege.Add(Entries.Name+'.Checked');
      //JvFormStorage1.StoredProps. CreateStoredItem
      JvFormStorage1.StoredProps.Add(Entries.Name+'_Checked');
      //ShowMessage(Entries.Name+'_Checked');
      Inc(l);
    end;
//    Basis := JvCheckTreeView1.Items.Add(nil, GetStrFromReferenzArt( BibTeXStructur.Items[i].Referenz));
//    BasisRequired := JvCheckTreeView1.Items.AddChild(Basis, 'Required');
//    EntriesSet := BibTeXStructur.Items[i].Required;

//    BasisOptional := JvCheckTreeView1.Items.AddChild(Basis, 'Optional');
  end;
 // JvFormStorage1.StoredProps.Assign(Eintraege);
  Eintraege.Free;
end;

procedure TdlgExportOptionenBibTeX.FormHide(Sender: TObject);
begin
//  JvFormStorage1.AppStorage := allgemein.DataModule1.JvAppIniFileStorage1;
//  JvFormStorage1.Active := true;
//  JvFormStorage1.SetNotification;
  JvFormStorage1.SaveFormPlacement;
end;

end.
