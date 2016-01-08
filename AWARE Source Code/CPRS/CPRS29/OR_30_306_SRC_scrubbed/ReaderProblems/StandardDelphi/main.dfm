object frmMain: TfrmMain
  Left = 171
  Top = 90
  Caption = 'Standard Delphi Components'
  ClientHeight = 607
  ClientWidth = 846
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    846
    607)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 65
    Caption = 'A Example of a multiline label'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 160
    Top = 8
    Width = 31
    Height = 13
    Caption = 'Oldest'
  end
  object Label3: TLabel
    Left = 240
    Top = 8
    Width = 41
    Height = 13
    Caption = 'Previous'
  end
  object Label4: TLabel
    Left = 325
    Top = 8
    Width = 23
    Height = 13
    Caption = 'Next'
  end
  object Label5: TLabel
    Left = 400
    Top = 8
    Width = 36
    Height = 13
    Caption = 'Newest'
  end
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 143
    Width = 121
    Height = 97
    AllowGrayed = True
    ItemHeight = 13
    Items.Strings = (
      'Goat'
      'Dragon'
      'Weasel')
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 8
    Top = 79
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 271
    Width = 75
    Height = 25
    Caption = 'Show Dialog'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 8
    Top = 327
    Width = 75
    Height = 49
    Caption = 'Show Form with No Read Labels'
    TabOrder = 3
    WordWrap = True
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 224
    Top = 27
    Width = 75
    Height = 25
    Caption = '<'
    TabOrder = 5
  end
  object Button5: TButton
    Left = 305
    Top = 27
    Width = 75
    Height = 25
    Caption = '>'
    TabOrder = 6
  end
  object Button6: TButton
    Left = 386
    Top = 27
    Width = 75
    Height = 25
    Caption = '>>'
    TabOrder = 7
  end
  object Button7: TButton
    Left = 143
    Top = 27
    Width = 75
    Height = 25
    Caption = '<<'
    TabOrder = 4
  end
  object pnlTemplatesPanel: TPanel
    Left = 143
    Top = 76
    Width = 138
    Height = 25
    BevelOuter = bvNone
    TabOrder = 8
    TabStop = True
    OnClick = pnlTemplatesPanelClick
    OnEnter = pnlTemplatesPanelEnter
    OnExit = pnlTemplatesPanelEnter
    object btnTemplate: TSpeedButton
      Left = 0
      Top = 0
      Width = 138
      Height = 25
      Align = alClient
      AllowAllUp = True
      GroupIndex = 1
      Caption = 'Templates'
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7CFF7FFF7F1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C10421042FF7FFF7F1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C10421F7C1F7CFF7F1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C104210421F7C1F7CFF7FFF7F1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C10421F7C1F7C1F7C1F7CFF7F1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C104210421F7C1F7C1F7C1F7CFF7FFF7F1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1042104210421042104210421042FF7F1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      OnClick = btnTemplateClick
      ExplicitLeft = 1
    end
  end
  object reNote: TRichEdit
    Left = 288
    Top = 76
    Width = 550
    Height = 492
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 10
  end
  object tvTemplates: TTreeView
    Left = 142
    Top = 99
    Width = 139
    Height = 234
    Indent = 19
    ReadOnly = True
    TabOrder = 9
    Visible = False
    OnDblClick = tvTemplatesDblClick
    OnKeyDown = tvTemplatesKeyDown
  end
  object Button8: TButton
    Left = 763
    Top = 45
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 11
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 763
    Top = 574
    Width = 75
    Height = 25
    Caption = 'Done'
    TabOrder = 12
    OnClick = Button9Click
  end
  object Memo1: TMemo
    Left = 97
    Top = 351
    Width = 185
    Height = 25
    Lines.Strings = (
      'Memo1'
      'Line2'
      'Line3')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 13
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 400
    Width = 75
    Height = 137
    Style = csSimple
    ItemHeight = 13
    TabOrder = 14
    Text = 'smile'
    Items.Strings = (
      'one'
      'two'
      'three'
      'four'
      'five')
  end
  object ComboBox2: TComboBox
    Left = 97
    Top = 400
    Width = 80
    Height = 21
    ItemHeight = 13
    TabOrder = 15
    Text = 'smile'
    Items.Strings = (
      'one'
      'two'
      'three'
      'four'
      'five')
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 504
    Top = 24
    Data = (
      (
        'Component = Button7'
        'Label = Label2'
        'Status = stsOK')
      (
        'Component = Button4'
        'Label = Label3'
        'Status = stsOK')
      (
        'Component = Button5'
        'Label = Label4'
        'Status = stsOK')
      (
        'Component = Button6'
        'Label = Label5'
        'Status = stsOK')
      (
        'Component = Edit1'
        'Label = Label1'
        'Status = stsOK')
      (
        'Component = CheckListBox1'
        'Text = whatever'
        'Status = stsOK')
      (
        'Component = Button1'
        'Status = stsDefault')
      (
        'Component = Memo1'
        'Status = stsDefault')
      (
        'Component = frmMain'
        'Status = stsDefault')
      (
        'Component = ComboBox1'
        'Text = Testing'
        'Status = stsOK')
      (
        'Component = ComboBox2'
        'Status = stsDefault'))
  end
end
