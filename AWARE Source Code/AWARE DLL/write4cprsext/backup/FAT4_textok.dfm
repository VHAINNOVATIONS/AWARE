object FATFormS: TFATFormS
  Left = 0
  Top = 0
  Caption = 'Follow up action tracker'
  ClientHeight = 320
  ClientWidth = 922
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
    Left = 64
    Top = 57
    Width = 796
    Height = 100
    Caption = 
      'This patient has a critical alert, but it appears that no action' +
      's (e.g., medication ordering) have been taken to address this al' +
      'ert.                                                            ' +
      '                                                                ' +
      '                                                                ' +
      '                                                                ' +
      '                      If you have completed a follow-up action t' +
      'hat cannot be tracked (e.g., calling a patient, or wish to do so' +
      ' now, please document that action using the appropriate note tem' +
      'plate (e.g.,                            '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 5
    Top = 11
    Width = 115
    Height = 24
    Caption = ' Critical labs - '
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
  object PatientName: TLabel
    Left = 497
    Top = 11
    Width = 107
    Height = 24
    Caption = 'PatientName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 430
    Top = 11
    Width = 61
    Height = 24
    Caption = 'Patient:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ReminderInstructions: TLabel
    Left = 240
    Top = 155
    Width = 408
    Height = 60
    Caption = 
      'Click the "Address Now" Button below to complete and sign all Pe' +
      'rtinent Orders and Follow-up actions for Critical Alert above.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object Label9: TLabel
    Left = 88
    Top = 448
    Width = 206
    Height = 144
    Caption = 
      '*Click the "Address Now" Button below to Complete and Sign all P' +
      'ertinent Orders and Follow-up Actions for "Critical Alert" above' +
      '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
    WordWrap = True
  end
  object NoteTitle: TLabel
    Left = 176
    Top = 280
    Width = 573
    Height = 24
    Caption = 
      'When prompted, choose the following note title: Critical <Critic' +
      'al Alert'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object ButtonLeave: TButton
    Left = 445
    Top = 254
    Width = 213
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
  object Button1: TButton
    Left = 208
    Top = 255
    Width = 215
    Height = 49
    Caption = 'ADDRESS NOW'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 859
    Top = 336
    Width = 19
    Height = 25
    Caption = 'T'
    Enabled = False
    TabOrder = 2
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 776
    Top = 255
    Width = 49
    Height = 49
    Caption = 'Help'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = Button3Click
  end
end
