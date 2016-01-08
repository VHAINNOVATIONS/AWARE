inherited frmVisitType: TfrmVisitType
  Left = 128
  Top = 159
  Caption = 'Encounter VisitType'
  ClientHeight = 474
  ClientWidth = 634
  ExplicitWidth = 642
  ExplicitHeight = 501
  PixelsPerInch = 96
  TextHeight = 13
  object lblVType: TLabel [0]
    Left = 150
    Top = 6
    Width = 67
    Height = 13
    Caption = 'Section Name'
  end
  object lblSCDisplay: TLabel [1]
    Left = 6
    Top = 123
    Width = 186
    Height = 13
    Caption = 'Service Connection && Rated Disabilities'
  end
  object lblVTypeSection: TLabel [2]
    Left = 6
    Top = 6
    Width = 58
    Height = 13
    Caption = 'Type of Visit'
  end
  object lblCurrentProv: TLabel [3]
    Left = 277
    Top = 289
    Width = 165
    Height = 13
    Caption = 'Current providers for this encounter'
  end
  object lblProvider: TLabel [4]
    Left = 6
    Top = 289
    Width = 89
    Height = 13
    Caption = 'Available providers'
  end
  object lblMod: TLabel [5]
    Left = 358
    Top = 6
    Width = 42
    Height = 13
    Hint = 'Modifiers'
    Caption = 'Modifiers'
    ParentShowHint = False
    ShowHint = True
  end
  inherited btnOK: TBitBtn
    Left = 477
    Top = 451
    TabOrder = 7
    ExplicitLeft = 477
    ExplicitTop = 451
  end
  inherited btnCancel: TBitBtn
    Left = 557
    Top = 451
    TabOrder = 8
    ExplicitLeft = 557
    ExplicitTop = 451
  end
  object pnlMain: TPanel
    Left = 2
    Top = 19
    Width = 615
    Height = 92
    BevelOuter = bvNone
    TabOrder = 0
    object splLeft: TSplitter
      Left = 145
      Top = 0
      Height = 92
      OnMoved = splLeftMoved
    end
    object splRight: TSplitter
      Left = 352
      Top = 0
      Height = 92
      Align = alRight
      OnMoved = splRightMoved
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 145
      Height = 92
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lstVTypeSection: TListBox
        Tag = 10
        Left = 0
        Top = 0
        Width = 145
        Height = 92
        Align = alTop
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
    end
    object lbxVisits: TCheckListBox
      Tag = 10
      Left = 148
      Top = 0
      Width = 204
      Height = 92
      Align = alClient
      ItemHeight = 16
      ParentShowHint = False
      ShowHint = True
      Style = lbOwnerDrawFixed
      TabOrder = 1
      OnClick = lbxVisitsClick
    end
    object lbMods: TCheckListBox
      Left = 355
      Top = 0
      Width = 260
      Height = 92
      Align = alRight
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 14
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Style = lbOwnerDrawFixed
      TabOrder = 2
    end
  end
  object memSCDisplay: TMemo
    Left = 6
    Top = 137
    Width = 403
    Height = 136
    Color = clBtnFace
    Lines.Strings = (
      '')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    OnEnter = memSCDisplayEnter
  end
  object lbProviders: TListBox
    Left = 277
    Top = 305
    Width = 183
    Height = 126
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
  end
  object cboPtProvider: TComboBox
    Left = 6
    Top = 305
    Width = 183
    Height = 136
    Style = csSimple
    ItemHeight = 13
    TabOrder = 2
    OnChange = cboPtProviderChange
  end
  object btnAdd: TButton
    Left = 196
    Top = 347
    Width = 75
    Height = 21
    Caption = 'Add'
    TabOrder = 3
  end
  object btnDelete: TButton
    Left = 196
    Top = 379
    Width = 75
    Height = 21
    Caption = 'Remove'
    TabOrder = 4
  end
  object btnPrimary: TButton
    Left = 196
    Top = 411
    Width = 75
    Height = 21
    Caption = 'Primary'
    TabOrder = 5
  end
end
