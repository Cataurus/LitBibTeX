object dlgExportOptionenBibTeX: TdlgExportOptionenBibTeX
  Left = 0
  Top = 0
  Caption = 'Exporteinstellungen f'#252'r BibTeX'
  ClientHeight = 529
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 387
    Height = 529
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 24
        Top = 16
        Width = 185
        Height = 481
        Caption = 'GroupBox1'
        TabOrder = 0
        object CheckBox1: TCheckBox
          Left = 24
          Top = 24
          Width = 97
          Height = 17
          Caption = 'CheckBox1'
          TabOrder = 0
        end
      end
    end
  end
  object JvFormStorage1: TJvFormStorage
    AppStorage = DataModule1.JvAppIniFileStorage1
    AppStoragePath = '%FORM_NAME%\'
    StoredProps.Strings = (
      'CheckBox1.Checked')
    StoredValues = <>
    Left = 624
    Top = 536
  end
end
