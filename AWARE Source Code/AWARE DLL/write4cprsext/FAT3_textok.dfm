object FATForm: TFATForm
  Left = 0
  Top = 0
  Caption = 'Follow up action tracker'
  ClientHeight = 670
  ClientWidth = 1028
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = OnShow
  PixelsPerInch = 96
  TextHeight = 13
  object AlertLabel: TLabel
    Left = 24
    Top = 228
    Width = 826
    Height = 20
    Caption = 
      'The following actions not marked were looked for in the patient'#39 +
      's chart, but not found for selected alert:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object StaticNoFollowupNeeded: TLabel
    Left = 24
    Top = 429
    Width = 198
    Height = 23
    Caption = 'Other Follow-Up Entries'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 5
    Top = 11
    Width = 99
    Height = 24
    Caption = '          Alert- '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 628
    Width = 77
    Height = 16
    Caption = 'Comments:'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CriticalLabName: TLabel
    Left = 139
    Top = 10
    Width = 137
    Height = 24
    Caption = 'CriticalLabName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object PatientName: TLabel
    Left = 711
    Top = 8
    Width = 92
    Height = 20
    Caption = 'PatientName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 638
    Top = 8
    Width = 54
    Height = 20
    Caption = 'Patient:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 638
    Top = 78
    Width = 50
    Height = 20
    Caption = 'Phone:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 638
    Top = 53
    Width = 33
    Height = 20
    Caption = 'Age:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label6: TLabel
    Left = 638
    Top = 34
    Width = 67
    Height = 20
    Caption = 'Patient #:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object PatientNo: TLabel
    Left = 711
    Top = 34
    Width = 70
    Height = 20
    Caption = 'PatientNo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Age: TLabel
    Left = 711
    Top = 53
    Width = 29
    Height = 20
    Caption = 'Age'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Phone: TLabel
    Left = 711
    Top = 78
    Width = 46
    Height = 20
    Caption = 'Phone'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 24
    Top = 254
    Width = 56
    Height = 23
    Caption = 'Orders'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object ReminderInstructions: TLabel
    Left = 464
    Top = 296
    Width = 408
    Height = 96
    Caption = 
      'Click "PROCEED" Button below to Initiate Orders and Follow-up ac' +
      'tions among listed items to LEFT on Alert selected above to then' +
      ' use                                                       '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label8: TLabel
    Left = 48
    Top = 207
    Width = 42
    Height = 13
    Caption = 'Asterisks'
  end
  object Label9: TLabel
    Left = 464
    Top = 421
    Width = 467
    Height = 48
    Caption = 
      '*Click "PROCEED" Button below to Complete and Sign all  Pertinen' +
      't Orders on Alert selected above '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object ButtonLeave: TButton
    Left = 719
    Top = 511
    Width = 219
    Height = 51
    Caption = 'CLOSE AND ADDRESS LATER'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = ButtonLeaveClick
  end
  object lstvAlerts: TCaptionListView
    Left = -2
    Top = 104
    Width = 1043
    Height = 97
    Columns = <
      item
        AutoSize = True
        Caption = 'CritAlert'
      end
      item
        Caption = 'Patient'
      end
      item
        Caption = 'Location'
      end
      item
        Caption = 'Urgency'
      end
      item
        Caption = 'Alert Date/Time'
      end
      item
        Caption = 'Comment'
      end
      item
        Caption = 'Forwarded BY'
      end>
    DragCursor = crDefault
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    ParentFont = False
    ParentShowHint = False
    ShowWorkAreas = True
    ShowHint = True
    TabOrder = 1
    ViewStyle = vsReport
    Caption = 'Notifications'
  end
  object Button1: TButton
    Left = 464
    Top = 512
    Width = 215
    Height = 49
    Caption = 'PROCEED'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 952
    Top = 637
    Width = 17
    Height = 25
    Caption = 'T'
    TabOrder = 3
    OnClick = Button2Click
  end
end
