unit fSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, VA508AccessibilityManager, VA508ImageListLabeler;

type
  TfrmSplash = class(TForm)
    pnlMain: TPanel;
    lblVersion: TLabel;
    lblCopyright: TLabel;
    pnlImage: TPanel;
    Image1: TImage;
    Memo1: TMemo;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    Timer1: TTimer;
    lblSplash: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    FAsk: boolean;
    { Private declarations }
  public
    property Ask: boolean read FAsk write FAsk;
  end;

var
  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

uses VAUtils;

{ TVA508MemoManager }

procedure TfrmSplash.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := 'version ' +
                        FileVersionValue(Application.ExeName, FILE_VER_FILEVERSION);
  lblSplash.Caption := lblSplash.Caption + ' ' + lblVersion.Caption;
  lblSplash.Invalidate;
end;

procedure TfrmSplash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := FALSe;
  FAsk := TRUE;
end;

end.
