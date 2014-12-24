program BibTexApp;

uses
  
  FastMM4 in 'Source\FastMM4.pas',
  FastMM4Messages in 'Source\FastMM4Messages.pas',
  Vcl.Forms,
  main in 'Source\main.pas' {Form1},
  dlgExportOptionenForBib in 'Source\dlgExportOptionenForBib.pas' {dlgExportOptionenBibTeX},
  allgemein in 'Source\allgemein.pas' {DataModule1: TDataModule},
  Cataurus.Allgemein.StrUtils in 'Source\Cataurus\Allgemein\Cataurus.Allgemein.StrUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdlgExportOptionenBibTeX, dlgExportOptionenBibTeX);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
