object frmMain: TfrmMain
  Left = 53
  Top = 67
  Caption = 'Custom VA CPRS Components'
  ClientHeight = 493
  ClientWidth = 637
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ORListBox1: TORListBox
    Left = 8
    Top = 240
    Width = 121
    Height = 97
    Style = lbOwnerDrawFixed
    ItemHeight = 16
    Items.Strings = (
      'Red'
      'Green'
      'Blue')
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ItemTipColor = clWindow
    LongList = False
    CheckBoxes = True
  end
  object cbCheckboxesTrue: TCheckBox
    Left = 8
    Top = 217
    Width = 121
    Height = 17
    Caption = 'CheckBoxes True'
    Checked = True
    State = cbChecked
    TabOrder = 1
    OnClick = cbCheckboxesTrueClick
  end
  object ORCheckBox1: TORCheckBox
    Left = 255
    Top = 16
    Width = 97
    Height = 17
    AllowGrayed = True
    Caption = 'ORCheckBox1'
    State = cbGrayed
    TabOrder = 2
    GrayedStyle = gsBlueQuestionMark
  end
  object ORCheckBox2: TORCheckBox
    Left = 255
    Top = 39
    Width = 97
    Height = 17
    AllowGrayed = True
    Caption = 'ORCheckBox2'
    State = cbGrayed
    TabOrder = 3
  end
  object ORCheckBox3: TORCheckBox
    Left = 255
    Top = 62
    Width = 97
    Height = 17
    Caption = 'ORCheckBox3'
    TabOrder = 4
  end
  object Button1: TButton
    Left = 239
    Top = 168
    Width = 106
    Height = 33
    Caption = 'Swap Components'
    TabOrder = 5
    WordWrap = True
    OnClick = Button1Click
  end
  object Panel2: TPanel
    Left = 8
    Top = 8
    Width = 209
    Height = 193
    Caption = 'Panel2'
    TabOrder = 6
    object Panel1: TPanel
      Left = 16
      Top = 20
      Width = 169
      Height = 157
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 404
    Top = 28
    Width = 225
    Height = 241
    Caption = 'Panel3'
    TabOrder = 7
  end
  object Button2: TButton
    Left = 239
    Top = 217
    Width = 82
    Height = 25
    Caption = 'Swap Panels'
    TabOrder = 8
    OnClick = Button2Click
  end
  object ORComboBox1: TORComboBox
    Left = 144
    Top = 304
    Width = 89
    Height = 137
    Style = orcsSimple
    AutoSelect = True
    Color = clWindow
    DropDownCount = 8
    Items.Strings = (
      'one'
      'two'
      'three'
      'four')
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 9
    TabStop = True
    CharsNeedMatch = 1
  end
  object ComboBox1: TComboBox
    Left = 264
    Top = 304
    Width = 97
    Height = 145
    Style = csSimple
    ItemHeight = 13
    TabOrder = 10
    Text = 'ComboBox1'
    Items.Strings = (
      'one'
      'two'
      'three'
      'four'
      'five')
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 151
    Top = 224
    Data = (
      (
        'Component = frmMain'
        'Status = stsDefault')
      (
        'Component = ORCheckBox3'
        'Text = Whatever'
        'Status = stsOK')
      (
        'Component = ORListBox1'
        'Text = Smile'
        'Status = stsOK')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = cbCheckboxesTrue'
        'Status = stsDefault')
      (
        'Component = ORCheckBox1'
        'Status = stsDefault')
      (
        'Component = ORCheckBox2'
        'Status = stsDefault')
      (
        'Component = Button1'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = Button2'
        'Status = stsDefault')
      (
        'Component = ORComboBox1'
        'Text = whatever'
        'Status = stsOK')
      (
        'Component = ComboBox1'
        'Text = testing'
        'Status = stsOK'))
  end
end
