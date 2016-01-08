object frmPCEBase: TfrmPCEBase
  Left = 194
  Top = 170
  Caption = 'Basic Page'
  ClientHeight = 400
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  DesignSize = (
    624
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TBitBtn
    Left = 467
    Top = 376
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
    NumGlyphs = 2
  end
  object btnCancel: TBitBtn
    Left = 547
    Top = 376
    Width = 75
    Height = 21
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
    NumGlyphs = 2
  end
end
