object frmODMeds: TfrmODMeds
  Left = 321
  Top = 183
  Width = 584
  Height = 572
  HorzScrollBar.Range = 558
  VertScrollBar.Range = 399
  Caption = 'Medication Order'
  Color = clBtnFace
  Constraints.MinHeight = 325
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    576
    545)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMeds: TPanel
    Left = 6
    Top = 34
    Width = 580
    Height = 470
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'pnlMeds'
    TabOrder = 1
    object sptSelect: TSplitter
      Left = 0
      Top = 133
      Width = 580
      Height = 4
      Cursor = crVSplit
      Align = alTop
    end
    object lstQuick: TCaptionListView
      Left = 0
      Top = 0
      Width = 580
      Height = 133
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvSpace
      Columns = <
        item
          Width = 420
        end>
      ColumnClick = False
      HideSelection = False
      HotTrack = True
      HoverTime = 2147483647
      OwnerData = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = lstChange
      OnClick = ListViewClick
      OnData = lstQuickData
      OnDataHint = lstQuickDataHint
      OnEditing = ListViewEditing
      OnEnter = ListViewEnter
      OnKeyUp = ListViewKeyUp
      OnResize = ListViewResize
      Caption = 'Quick Orders'
    end
    object lstAll: TCaptionListView
      Left = 0
      Top = 137
      Width = 580
      Height = 333
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Columns = <
        item
          Width = 420
        end>
      ColumnClick = False
      HideSelection = False
      HotTrack = True
      HoverTime = 2147483647
      OwnerData = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 1
      ViewStyle = vsReport
      OnChange = lstChange
      OnClick = ListViewClick
      OnData = lstAllData
      OnDataHint = lstAllDataHint
      OnEditing = ListViewEditing
      OnEnter = ListViewEnter
      OnKeyUp = ListViewKeyUp
      OnResize = ListViewResize
      Caption = 'All Medication orders'
    end
  end
  object txtMed: TEdit
    Left = 6
    Top = 6
    Width = 580
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    AutoSelect = False
    TabOrder = 0
    Text = '(Type a medication name or select from the orders below)'
    OnChange = txtMedChange
    OnExit = txtMedExit
    OnKeyDown = txtMedKeyDown
    OnKeyUp = txtMedKeyUp
  end
  object btnSelect: TButton
    Left = 515
    Top = 505
    Width = 72
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 3
    OnClick = btnSelectClick
  end
  object pnlFields: TPanel
    Left = 6
    Top = 34
    Width = 580
    Height = 470
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    Visible = False
    OnResize = pnlFieldsResize
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 580
      Height = 216
      Align = alClient
      Constraints.MinHeight = 80
      TabOrder = 3
      DesignSize = (
        580
        216)
      object lblRoute: TLabel
        Left = 280
        Top = 23
        Width = 29
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Route'
        Visible = False
      end
      object lblSchedule: TLabel
        Left = 394
        Top = 22
        Width = 43
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Schedule'
        Visible = False
        WordWrap = True
      end
      object txtNSS: TLabel
        Left = 442
        Top = 22
        Width = 71
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '(Day-Of-Week)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        OnClick = txtNSSClick
      end
      object grdDoses: TCaptionStringGrid
        Left = 0
        Top = 36
        Width = 580
        Height = 175
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 7
        DefaultColWidth = 76
        DefaultRowHeight = 21
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs]
        ScrollBars = ssVertical
        TabOrder = 8
        OnDrawCell = grdDosesDrawCell
        OnEnter = grdDosesEnter
        OnExit = grdDosesExit
        OnKeyDown = grdDosesKeyDown
        OnKeyPress = grdDosesKeyPress
        OnMouseDown = grdDosesMouseDown
        OnMouseUp = grdDosesMouseUp
        Caption = 'Complex Dosage'
        JustToTab = True
        ColWidths = (
          76
          76
          76
          76
          76
          76
          76)
      end
      object lblGuideline: TStaticText
        Left = 0
        Top = 1
        Width = 181
        Height = 17
        Caption = 'Display Restrictions/Guidelines'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentColor = False
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 0
        TabStop = True
        Visible = False
        OnClick = lblGuidelineClick
      end
      object tabDose: TTabControl
        Left = 1
        Top = 19
        Width = 175
        Height = 17
        TabOrder = 3
        Tabs.Strings = (
          'Dosage'
          'Complex')
        TabIndex = 0
        TabStop = False
        TabWidth = 86
        OnChange = tabDoseChange
      end
      object cboDosage: TORComboBox
        Left = 1
        Top = 36
        Width = 279
        Height = 174
        Anchors = [akLeft, akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Dosage'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '5,3,6'
        Sorted = False
        SynonymChars = '<>'
        TabPositions = '27,32'
        TabOrder = 4
        OnChange = cboDosageChange
        OnClick = cboDosageClick
        OnExit = cboDosageExit
        OnKeyUp = cboDosageKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object cboRoute: TORComboBox
        Left = 280
        Top = 36
        Width = 113
        Height = 175
        Anchors = [akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Route'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        ParentShowHint = False
        Pieces = '2'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 5
        OnChange = cboRouteChange
        OnClick = ControlChange
        OnExit = cboRouteExit
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object cboSchedule: TORComboBox
        Left = 394
        Top = 36
        Width = 178
        Height = 175
        Anchors = [akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = False
        Caption = 'Schedule'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = True
        SynonymChars = '<>'
        TabOrder = 6
        OnChange = cboScheduleChange
        OnClick = cboScheduleClick
        OnEnter = cboScheduleEnter
        OnExit = cboScheduleExit
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object chkPRN: TCheckBox
        Left = 530
        Top = 37
        Width = 42
        Height = 18
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 7
        OnClick = chkPRNClick
      end
      object btnXInsert: TButton
        Left = 403
        Top = 3
        Width = 79
        Height = 17
        Caption = 'Insert Row'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnXInsertClick
      end
      object btnXRemove: TButton
        Left = 488
        Top = 3
        Width = 79
        Height = 17
        Caption = 'Remove Row'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnXRemoveClick
      end
      object pnlXAdminTime: TPanel
        Left = 432
        Top = 149
        Width = 65
        Height = 17
        Caption = 'pnlXAdminTime'
        TabOrder = 9
        Visible = False
        OnClick = pnlXAdminTimeClick
      end
    end
    object cboXDosage: TORComboBox
      Left = 49
      Top = 122
      Width = 72
      Height = 21
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Dosage'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '5'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Visible = False
      OnChange = cboXDosageChange
      OnClick = cboXDosageClick
      OnEnter = cboXDosageEnter
      OnExit = cboXDosageExit
      OnKeyDown = memMessageKeyDown
      OnKeyUp = cboXDosageKeyUp
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cboXRoute: TORComboBox
      Left = 122
      Top = 122
      Width = 72
      Height = 21
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Route'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Visible = False
      OnChange = cboXRouteChange
      OnClick = cboXRouteClick
      OnEnter = cboXRouteEnter
      OnExit = cboXRouteExit
      OnKeyDown = memMessageKeyDown
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object pnlXDuration: TPanel
      Left = 300
      Top = 122
      Width = 72
      Height = 21
      BevelOuter = bvNone
      TabOrder = 4
      Visible = False
      OnEnter = pnlXDurationEnter
      OnExit = pnlXDurationExit
      DesignSize = (
        72
        21)
      object pnlXDurationButton: TKeyClickPanel
        Left = 39
        Top = 1
        Width = 33
        Height = 19
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Duration'
        TabOrder = 2
        TabStop = True
        OnClick = btnXDurationClick
        object btnXDuration: TSpeedButton
          Left = 0
          Top = 0
          Width = 33
          Height = 19
          Caption = 'days'
          Flat = True
          Glyph.Data = {
            AE000000424DAE0000000000000076000000280000000E000000070000000100
            0400000000003800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            330033333333333333003330333333733300330003333F87330030000033FFFF
            F30033333333333333003333333333333300}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 0
          Transparent = False
          OnClick = btnXDurationClick
        end
      end
      object txtXDuration: TCaptionEdit
        Left = 0
        Top = 0
        Width = 25
        Height = 21
        Anchors = [akLeft, akTop, akBottom]
        TabOrder = 0
        Text = '0'
        OnChange = txtXDurationChange
        OnKeyDown = memMessageKeyDown
        Caption = 'Duration'
      end
      object spnXDuration: TUpDown
        Left = 25
        Top = 0
        Width = 15
        Height = 21
        Anchors = [akLeft, akTop, akBottom]
        Associate = txtXDuration
        Max = 999
        TabOrder = 1
      end
    end
    object pnlXSchedule: TPanel
      Left = 195
      Top = 122
      Width = 106
      Height = 21
      BevelOuter = bvNone
      TabOrder = 2
      Visible = False
      OnEnter = pnlXScheduleEnter
      OnExit = pnlXScheduleExit
      DesignSize = (
        106
        21)
      object cboXSchedule: TORComboBox
        Left = 0
        Top = 0
        Width = 63
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = False
        Caption = 'Schedule'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        TabStop = True
        OnChange = cboXScheduleChange
        OnClick = cboXScheduleClick
        OnEnter = cboXScheduleEnter
        OnExit = cboXScheduleExit
        OnKeyDown = memMessageKeyDown
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object chkXPRN: TCheckBox
        Left = 63
        Top = 4
        Width = 42
        Height = 11
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        TabOrder = 1
        OnClick = chkXPRNClick
        OnKeyDown = memMessageKeyDown
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 216
      Width = 580
      Height = 254
      Align = alBottom
      TabOrder = 5
      DesignSize = (
        580
        254)
      object lblComment: TLabel
        Left = 4
        Top = 5
        Width = 52
        Height = 16
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Comments:'
      end
      object lblDays: TLabel
        Left = 4
        Top = 65
        Width = 59
        Height = 13
        Caption = 'Days Supply'
      end
      object lblQuantity: TLabel
        Left = 84
        Top = 65
        Width = 42
        Height = 13
        Caption = 'Quantity'
        ParentShowHint = False
        ShowHint = True
      end
      object lblRefills: TLabel
        Left = 164
        Top = 65
        Width = 28
        Height = 13
        Caption = 'Refills'
      end
      object lblPriority: TLabel
        Left = 500
        Top = 61
        Width = 34
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Priority'
      end
      object Image1: TImage
        Left = 5
        Top = 202
        Width = 31
        Height = 31
        Anchors = [akLeft, akBottom]
        Visible = False
        ExplicitTop = 177
      end
      object chkDoseNow: TCheckBox
        Left = 3
        Top = 104
        Width = 247
        Height = 21
        Caption = 'Give additional dose now'
        TabOrder = 8
        OnClick = chkDoseNowClick
      end
      object memComment: TCaptionMemo
        Left = 57
        Top = 2
        Width = 513
        Height = 43
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = ControlChange
        OnClick = memCommentClick
        Caption = 'Comments'
      end
      object lblQtyMsg: TStaticText
        Left = 4
        Top = 47
        Width = 218
        Height = 17
        Caption = '>> Quantity Dispensed: Multiples of 100 <<'
        TabOrder = 13
      end
      object txtSupply: TCaptionEdit
        Left = 2
        Top = 78
        Width = 60
        Height = 21
        AutoSize = False
        TabOrder = 1
        Text = '0'
        OnChange = txtSupplyChange
        OnClick = txtSupplyClick
        Caption = 'Days Supply'
      end
      object spnSupply: TUpDown
        Left = 62
        Top = 78
        Width = 15
        Height = 21
        Associate = txtSupply
        TabOrder = 2
      end
      object txtQuantity: TCaptionEdit
        Left = 83
        Top = 78
        Width = 60
        Height = 21
        AutoSize = False
        TabOrder = 3
        Text = '0'
        OnChange = txtQuantityChange
        OnClick = txtQuantityClick
        Caption = 'Quantity'
      end
      object spnQuantity: TUpDown
        Left = 143
        Top = 78
        Width = 16
        Height = 21
        Associate = txtQuantity
        Max = 32766
        TabOrder = 4
      end
      object txtRefills: TCaptionEdit
        Left = 164
        Top = 78
        Width = 30
        Height = 21
        AutoSize = False
        TabOrder = 5
        Text = '0'
        OnChange = txtRefillsChange
        OnClick = txtRefillsClick
        Caption = 'Refills'
      end
      object spnRefills: TUpDown
        Left = 194
        Top = 78
        Width = 15
        Height = 21
        Associate = txtRefills
        Max = 11
        TabOrder = 6
      end
      object grpPickup: TGroupBox
        Left = 283
        Top = 66
        Width = 172
        Height = 36
        Anchors = [akTop, akRight]
        Caption = 'Pick Up'
        TabOrder = 7
        object radPickWindow: TRadioButton
          Left = 105
          Top = 14
          Width = 58
          Height = 17
          Caption = '&Window'
          TabOrder = 2
          OnClick = ControlChange
        end
        object radPickMail: TRadioButton
          Left = 58
          Top = 14
          Width = 38
          Height = 17
          Caption = '&Mail'
          TabOrder = 1
          OnClick = ControlChange
        end
        object radPickClinic: TRadioButton
          Left = 7
          Top = 14
          Width = 44
          Height = 17
          Caption = '&Clinic'
          TabOrder = 0
          OnClick = ControlChange
        end
      end
      object cboPriority: TORComboBox
        Left = 499
        Top = 76
        Width = 72
        Height = 21
        Anchors = [akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Priority'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 13
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 9
        OnChange = ControlChange
        CharsNeedMatch = 1
      end
      object stcPI: TStaticText
        Left = 2
        Top = 123
        Width = 93
        Height = 17
        Caption = 'Patient Instruction'
        TabOrder = 17
        Visible = False
      end
      object chkPtInstruct: TCheckBox
        Left = 4
        Top = 137
        Width = 14
        Height = 21
        Color = clBtnFace
        ParentColor = False
        TabOrder = 18
        Visible = False
        OnClick = chkPtInstructClick
      end
      object memPI: TMemo
        Left = 23
        Top = 139
        Width = 547
        Height = 35
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 19
        Visible = False
        OnClick = memPIClick
        OnKeyDown = memPIKeyDown
      end
      object memDrugMsg: TMemo
        Left = 37
        Top = 201
        Width = 533
        Height = 51
        Anchors = [akLeft, akRight, akBottom]
        Color = clCream
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 20
        Visible = False
      end
      object lblAdminSch: TVA508StaticText
        Name = 'lblAdminSch'
        Left = 344
        Top = 120
        Width = 66
        Height = 15
        Caption = 'LblAdminTime'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        TabStop = True
        ShowAccelChar = True
      end
      object lblAdminTime: TVA508StaticText
        Name = 'lblAdminTime'
        Left = 164
        Top = 116
        Width = 63
        Height = 15
        Caption = 'lblAdminTime'
        TabOrder = 11
        TabStop = True
        ShowAccelChar = True
      end
    end
    object cboXSequence: TORComboBox
      Left = 438
      Top = 122
      Width = 64
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Sequence'
      Color = clWindow
      DropDownCount = 8
      Items.Strings = (
        'and'
        'then')
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 6
      Visible = False
      OnChange = cboXSequenceChange
      OnEnter = cboXSequenceEnter
      OnExit = cboXSequenceExit
      OnKeyDown = memMessageKeyDown
      CharsNeedMatch = 1
    end
  end
  object dlgStart: TORDateTimeDlg
    FMDateTime = 3001101.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 444
    Top = 336
  end
  object timCheckChanges: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timCheckChangesTimer
    Left = 477
    Top = 336
  end
  object popDuration: TPopupMenu
    AutoHotkeys = maManual
    Left = 380
    Top = 145
    object popBlank: TMenuItem
      Caption = '(no selection)'
      OnClick = popDurationClick
    end
    object months1: TMenuItem
      Tag = 5
      Caption = 'months'
      OnClick = popDurationClick
    end
    object weeks1: TMenuItem
      Tag = 4
      Caption = 'weeks'
      OnClick = popDurationClick
    end
    object popDays: TMenuItem
      Tag = 3
      Caption = 'days'
      OnClick = popDurationClick
    end
    object hours1: TMenuItem
      Tag = 2
      Caption = 'hours'
      OnClick = popDurationClick
    end
    object minutes1: TMenuItem
      Tag = 1
      Caption = 'minutes'
      OnClick = popDurationClick
    end
  end
  object VA508AccessibilityManager1: TVA508AccessibilityManager
    Left = 128
    Top = 512
    Data = (
      (
        'Component = frmODMeds'
        'Status = stsDefault'))
  end
end
