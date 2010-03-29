object fSelectElement: TfSelectElement
  Left = 388
  Top = 128
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsToolWindow
  Caption = #1042#1099#1073#1086#1088' '#1101#1083#1077#1084#1077#1085#1090#1072
  ClientHeight = 21
  ClientWidth = 161
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pElement: TComboBox
    Left = 0
    Top = 0
    Width = 137
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnKeyPress = pElementKeyPress
    Items.Strings = (
      ''
      'Fire'
      'Ice'
      'Thunder'
      'Water'
      'Wind'
      'Earth'
      'Poison'
      'Holy')
  end
  object bOK: TButton
    Left = 136
    Top = 0
    Width = 25
    Height = 21
    Caption = 'OK'
    TabOrder = 1
    OnClick = bOKClick
  end
end
