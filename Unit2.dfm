object fCardEditor: TfCardEditor
  Left = 254
  Top = 157
  BorderStyle = bsToolWindow
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1082#1072#1088#1090
  ClientHeight = 89
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pName: TEdit
    Left = 8
    Top = 8
    Width = 161
    Height = 21
    TabOrder = 5
  end
  object bAddCard: TButton
    Left = 176
    Top = 8
    Width = 65
    Height = 73
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 6
    OnClick = bAddCardClick
  end
  object pElement: TComboBox
    Left = 64
    Top = 48
    Width = 105
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'Fire'
      'Ice'
      'Thunder'
      'Water'
      'Wind'
      'Earth'
      'Poison'
      'Holy')
  end
  object pRight: TEdit
    Left = 40
    Top = 48
    Width = 17
    Height = 17
    AutoSize = False
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 2
  end
  object pUp: TEdit
    Left = 24
    Top = 32
    Width = 17
    Height = 17
    AutoSize = False
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 1
  end
  object pLeft: TEdit
    Left = 8
    Top = 48
    Width = 17
    Height = 17
    AutoSize = False
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 0
  end
  object pDown: TEdit
    Left = 24
    Top = 64
    Width = 17
    Height = 17
    AutoSize = False
    CharCase = ecUpperCase
    MaxLength = 1
    TabOrder = 3
  end
end
