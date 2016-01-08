object TreeGridFrame: TTreeGridFrame
  Left = 0
  Top = 0
  Width = 426
  Height = 400
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  TabStop = True
  object tv: TTreeView
    Left = 0
    Top = 24
    Width = 426
    Height = 296
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    Ctl3D = False
    HideSelection = False
    HotTrack = True
    Indent = 19
    ParentCtl3D = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    OnChange = tvChange
    OnCreateNodeClass = tvCreateNodeClass
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = pnlTopResize
    object stTitle: TStaticText
      Left = 8
      Top = 4
      Width = 32
      Height = 17
      Caption = 'stTitle'
      TabOrder = 0
    end
  end
  object pnlSpace: TPanel
    Left = 0
    Top = 392
    Width = 426
    Height = 8
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
  end
  object pnlHint: TPanel
    Left = 0
    Top = 320
    Width = 426
    Height = 72
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object pnlTarget: TPanel
      Left = 0
      Top = 48
      Width = 426
      Height = 24
      BevelOuter = bvNone
      TabOrder = 0
      object mmoTargetCode: TMemo
        Left = 65
        Top = 0
        Width = 361
        Height = 24
        TabStop = False
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        TabOrder = 0
      end
      object pnlTargetCodeSys: TPanel
        Left = 0
        Top = 0
        Width = 65
        Height = 24
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        VerticalAlignment = taAlignTop
      end
    end
    object pnlCode: TPanel
      Left = 0
      Top = 24
      Width = 426
      Height = 24
      BevelOuter = bvNone
      TabOrder = 1
      object mmoCode: TMemo
        Left = 65
        Top = 0
        Width = 361
        Height = 24
        TabStop = False
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        TabOrder = 0
      end
      object pnlCodeSys: TPanel
        Left = 0
        Top = 0
        Width = 65
        Height = 24
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        VerticalAlignment = taAlignTop
      end
    end
    object pnlDesc: TPanel
      Left = 0
      Top = 0
      Width = 426
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object mmoDesc: TMemo
        Left = 65
        Top = 0
        Width = 361
        Height = 24
        TabStop = False
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        Color = clBtnFace
        TabOrder = 0
      end
      object pnlDescText: TPanel
        Left = 0
        Top = 0
        Width = 65
        Height = 24
        Align = alLeft
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        VerticalAlignment = taAlignTop
      end
    end
  end
end
