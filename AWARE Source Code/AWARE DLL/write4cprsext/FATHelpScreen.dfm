object HelpScreen: THelpScreen
  Left = 0
  Top = 0
  Caption = 'Help Screen'
  ClientHeight = 342
  ClientWidth = 675
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 50
    Top = 8
    Width = 537
    Height = 80
    Caption = 
      'This prompt has appeared because this patient has a critical ale' +
      'rt but no trackable follow-up actions were found in the patient'#39 +
      's chart. To address this prompt you will need to create a new "c' +
      'ritical alert follow-up" note to document any follow-up actions.' +
      ' '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 50
    Top = 168
    Width = 214
    Height = 20
    Caption = '1. Click "Address Now" button.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 50
    Top = 187
    Width = 218
    Height = 20
    Caption = '2. Select a location for the visit.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 50
    Top = 206
    Width = 467
    Height = 20
    Caption = 
      '3. Select the following note title: "Critical <Critical Alert Fo' +
      'llow-Up>"'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 50
    Top = 225
    Width = 460
    Height = 40
    Caption = 
      '4. Indicate any follow-up actions you intend to perform, or alre' +
      'ady      have performed, and/or place any orders you may need.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label6: TLabel
    Left = 50
    Top = 267
    Width = 350
    Height = 20
    Caption = '5. Sign your note and any orders you have placed.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 50
    Top = 100
    Width = 542
    Height = 60
    Caption = 
      'By clicking "Address Now" you will be guided through the 5 steps' +
      ' listed below to create a new "critical alert follow-up" note an' +
      'd document any follow-up actions you have taken.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
end
