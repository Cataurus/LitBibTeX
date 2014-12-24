unit Cataurus.Komponenten.BibTeXDataSet.DlgBibTeXOption;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Cataurus.BibTeX.Types, Vcl.StdCtrls;

type
  TfrDlgBibTeX = class(TForm)
    Button1: TButton;
    procedure CheckBoxClick(Sender: TObject);
  private
    FOptionen: TBibTeXEntrieList;
    procedure SetOptionen(const Value: TBibTeXEntrieList);
    { Private-Deklarationen }
  public
    constructor Create(AOwner: TComponent); override;
    property Optionen : TBibTeXEntrieList read FOptionen write SetOptionen;
  end;

procedure Execute_frDlgBibTeXOption(AOwner : TComponent; Source : TBibTeXEntrieList);

implementation

{$R *.dfm}

uses
  Cataurus.BibTeX.Utils;

procedure Execute_frDlgBibTeXOption(AOwner : TComponent; Source : TBibTeXEntrieList);
var
  frDlgBibTeX: TfrDlgBibTeX;
begin
  frDlgBibTeX:= TfrDlgBibTeX.Create(AOwner);
  try
    frDlgBibTeX.Optionen := Source;
    frDlgBibTeX.ShowModal;
    Source := frDlgBibTeX.Optionen;
  finally
    frDlgBibTeX.Free;
  end;
end;

{ TfrDlgBibTeX }

procedure TfrDlgBibTeX.CheckBoxClick(Sender: TObject);
var
  Eintrag : TBibTeXEntrie;
begin
  Eintrag := Optionen.Items[(Sender as TCheckBox).Tag];
  Eintrag.IsExport := (Sender as TCheckBox).Checked;
  Optionen.Items[(Sender as TCheckBox).Tag] := Eintrag;
end;

constructor TfrDlgBibTeX.Create(AOwner: TComponent);
  procedure CreateCheckBox(Idx : integer);
  var
    CheckBox : TCheckBox;
  begin
    CheckBox := TCheckBox.Create(self);
    CheckBox.Parent := self;
    CheckBox.Name := 'CheckBox_' + GetDelphiKonformStr(
                       GetStrForBibTeXEntriesTypes( TBibTExEntriesTypes(Idx) ));
    CheckBox.Caption := GetStrForBibTeXEntriesTypes( TBibTExEntriesTypes(Idx) );
    CheckBox.Tag := Idx;
    CheckBox.OnClick := CheckBoxClick;
    CheckBox.Left := 5;
    CheckBox.Top := 22 * Idx + 5;
    CheckBox.Width := 170;
    CheckBox.Height := 17;
  end;
var
  I : integer;
begin
  inherited;
  for I := 0 to cBibTeXEntriesTypesCount - 1 do
  begin
    CreateCheckBox(I);
  end;
end;

procedure TfrDlgBibTeX.SetOptionen(const Value: TBibTeXEntrieList);
var
  I: Integer;
  CheckBox : TCheckBox;
begin
  FOptionen := Value;
  for I := 0 to cBibTeXEntriesTypesCount - 1 do
  begin
    CheckBox := FindComponent('CheckBox_' + GetDelphiKonformStr(GetStrForBibTeXEntriesTypes(TBibTExEntriesTypes(I))) ) as TCheckBox;
    CheckBox.Checked := Foptionen[I].IsExport;
  end;
end;

end.
