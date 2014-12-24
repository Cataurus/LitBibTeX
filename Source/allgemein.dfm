object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 665
  Width = 856
  object JvAppIniFileStorage1: TJvAppIniFileStorage
    StorageOptions.BooleanStringTrueValues = 'TRUE, YES, Y'
    StorageOptions.BooleanStringFalseValues = 'FALSE, NO, N'
    FileName = 'BibTexApp.ini'
    DefaultSection = 'Allgemein'
    SubStorages = <>
    Left = 208
    Top = 24
  end
  object JvFormStorageSelectList1: TJvFormStorageSelectList
    AppStorage = JvAppIniFileStorage1
    FormStorage = dlgExportOptionenBibTeX.JvFormStorage1
    SelectPath = 'teset'
    Left = 64
    Top = 24
  end
end
