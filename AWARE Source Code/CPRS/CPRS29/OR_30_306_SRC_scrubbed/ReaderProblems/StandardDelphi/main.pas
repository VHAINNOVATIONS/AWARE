unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, Buttons, ComCtrls,
  VA508AccessibilityManager;

type
  TfrmMain = class(TForm)
    CheckListBox1: TCheckListBox;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    pnlTemplatesPanel: TPanel;
    btnTemplate: TSpeedButton;
    reNote: TRichEdit;
    tvTemplates: TTreeView;
    Button8: TButton;
    Button9: TButton;
    Memo1: TMemo;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure pnlTemplatesPanelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure pnlTemplatesPanelEnter(Sender: TObject);
    procedure btnTemplateClick(Sender: TObject);
    procedure tvTemplatesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure tvTemplatesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button9Click(Sender: TObject);
  private
  protected
    procedure Paint; override;
    procedure InsertText(txt: String);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  fSamplePopup, SampleTemplate, fVisitType, uMisc;

{$R *.dfm}

procedure TfrmMain.btnTemplateClick(Sender: TObject);
begin
  tvTemplates.Visible := btnTemplate.Down;
  pnlTemplatesPanel.SetFocus;
  Invalidate;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  frmSamplePopup.ShowModal;
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  frmVisitType.ShowModal;
end;

procedure TfrmMain.Button8Click(Sender: TObject);
begin
  reNote.Clear;
end;

procedure TfrmMain.Button9Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  PopupateTemplateTree(tvTemplates);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_LBUTTON, VK_RETURN, VK_SPACE:
      If ActiveControl = pnlTemplatesPanel then
      begin
        pnlTemplatesPanelClick(pnlTemplatesPanel);
        if btnTemplate.Down then
        begin
          Application.ProcessMessages;
          invalidate;
        end;
      end;
  end;
end;

procedure TfrmMain.InsertText(txt: String);
begin
  reNote.SelText := txt;

end;

type
  TCanvasExposedSpeedButton = class(TSpeedButton)
  public
    property Canvas;
  end;

procedure TfrmMain.Paint;
var
  Rect: TRect;
begin
  inherited;
  if pnlTemplatesPanel.Focused then
  begin
    Rect := btnTemplate.ClientRect;
    InflateRect(Rect, -3, -3);
    TCanvasExposedSpeedButton(btnTemplate).Canvas.Brush.Color :=
      TCanvasExposedSpeedButton(btnTemplate).Color;
    TCanvasExposedSpeedButton(btnTemplate).Canvas.DrawFocusRect(Rect);
  end
  else
    btnTemplate.Invalidate; 
end;

procedure TfrmMain.pnlTemplatesPanelClick(Sender: TObject);
begin
  btnTemplate.Down := not btnTemplate.Down;
  btnTemplateClick(btnTemplate);
end;

procedure TfrmMain.pnlTemplatesPanelEnter(Sender: TObject);
begin
  Invalidate;
end;

procedure TfrmMain.tvTemplatesDblClick(Sender: TObject);
var
  txt: string;
  node: TTreeNode;
  frmSampleTemplate : TfrmSampleTemplate;
  chkBox: boolean;
begin
  node := tvTemplates.Selected;
  if IsTemplateADialog(node) then
  begin
    frmSampleTemplate := TfrmSampleTemplate.Create(Application);
    try
      frmSampleTemplate.Caption := 'Template: ' + node.text;
      chkBox := false;
      InitDialogNoteText(node);
      repeat
        txt := GetDialogNoteText;
        if txt <> '' then
        begin
          if txt <> ' ' then
            frmSampleTemplate.Add(txt, chkBox);
          chkBox := TRUE;
        end;
      until txt = '';
      frmSampleTemplate.Invalidate;
      frmSampleTemplate.ShowModal;
    finally
      frmSampleTemplate.Free;
    end;
  end
  else
  begin
    txt := GetNoteText(tvTemplates.Selected);
    if txt <> '' then
      InsertText(txt);
  end;
end;

procedure TfrmMain.tvTemplatesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
  VK_SPACE, VK_RETURN:
    begin
      tvTemplatesDblClick(Sender);
      Key := 0;
    end;
  end;
end;

end.
