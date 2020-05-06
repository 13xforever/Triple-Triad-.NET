object fSelectCard: TfSelectCard
  Left = 289
  Top = 158
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = 'Card Select'
  ClientHeight = 73
  ClientWidth = 137
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lLeft: TLabel
    Left = 0
    Top = 40
    Width = 17
    Height = 17
    AutoSize = False
  end
  object lup: TLabel
    Left = 16
    Top = 24
    Width = 17
    Height = 17
    AutoSize = False
  end
  object lRight: TLabel
    Left = 32
    Top = 40
    Width = 17
    Height = 17
    AutoSize = False
  end
  object lDown: TLabel
    Left = 16
    Top = 56
    Width = 17
    Height = 17
    AutoSize = False
  end
  object lElement: TLabel
    Left = 16
    Top = 40
    Width = 17
    Height = 17
    AutoSize = False
  end
  object pCardName: TComboBox
    Left = 0
    Top = 0
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    Sorted = True
    TabOrder = 0
    OnChange = pCardNameChange
    OnKeyPress = pCardNameKeyPress
    Items.Strings = (
      'Unknown')
  end
  object bOK: TButton
    Left = 56
    Top = 24
    Width = 81
    Height = 49
    Caption = 'OK'
    TabOrder = 1
    OnClick = bOKClick
  end
end
