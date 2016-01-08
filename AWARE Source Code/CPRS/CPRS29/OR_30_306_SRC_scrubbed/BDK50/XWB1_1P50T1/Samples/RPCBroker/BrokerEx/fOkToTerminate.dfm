object frmOKToTerminate: TfrmOKToTerminate
  Left = 325
  Top = 214
  Caption = 'Request To Close User Context'
  ClientHeight = 166
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object frmOKToTerminate: TLabel
    Left = 48
    Top = 48
    Width = 277
    Height = 20
    Caption = 'OK To Terminate This Application?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 37
    Top = 16
    Width = 296
    Height = 17
    Caption = 'User Context has been changed or cleared'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnYes: TButton
    Left = 80
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Yes'
    ModalResult = 1
    TabOrder = 0
  end
  object btnNo: TButton
    Left = 216
    Top = 104
    Width = 75
    Height = 25
    Caption = 'No'
    ModalResult = 7
    TabOrder = 1
  end
end
