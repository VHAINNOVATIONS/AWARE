unit SampleTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs, StrUtils;

type
  TListFunc = function: string of object;

  TfrmSampleTemplate = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    sb: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fy: integer;
    FLists: TObjectList;
    FLines: integer;
    FPanels: TObjectList;
    procedure CheckBoxClick(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
  public
    procedure Add(Text: String; CheckBox: boolean = true);
  end;

implementation

uses uMisc;

{$R *.dfm}

const

  MAXLINES = 30;
  LEFTGAP = 4;
  TOPGAP = 5;
  CBWidth = 13;
  PANEL_COL = CBWidth + LEFTGAP + LEFTGAP;

  MEDLIST = DELIM + 'MEDLIST' + DELIM; // check boxes
  DOCLIST = DELIM + 'DOCLIST' + DELIM; // radio buttons
  DISEASELIST = DELIM + 'DISEASES' + DELIM; // check boxes

  YN = RBTN + 'Yes' + RBTN + 'No';
  YNSpecify = YN + EOL + 'Specify:' + EDTEOL;

type
  TCodeType = (ctNone, ctDone, ctEndOfLine, ctCheckBox, ctRadioButton, ctXXButton, ctEditButton, ctText);

procedure TfrmSampleTemplate.Add(Text: String; CheckBox: boolean = true);
var
  pnl: TPanel;
  cb: TCheckBox;
  cbx: TCheckBox;
  lbl: TLabel;
  txt: string;
  edit: TEdit;
  rad: TRadioButton;
  btn: TButton;
  ct: TCodeType;
  x, y, start, len, ht: integer;
  rbtnPending: boolean;
  cboxPending: boolean;

  procedure ProcessText;
  var
    p1, p2: integer;
    code: string;
  begin
    if start > len then
    begin
      ct := ctDone;
      exit;
    end;
    p1 := posex(DELIM, text, start);
    if p1 = start then
    begin
      p2 := posex(DELIM, text, p1+1);
      if p2 > 0 then
      begin
        code := copy(text, p1, p2 - p1 + 1);
        start := p2+1;
        if      code = EOL  then ct := ctEndOfLine
        else if code = RBTN then ct := ctRadioButton
        else if code = CBOX then ct := ctCheckBox
        else if code = EDT  then ct := ctEditButton
        else if code = NOTEXT then ct := ctNone
        else if code = XXBTN then ct := ctXXButton             
        else if (code = MEDLIST) or (code = DOCLIST) or (code = DISEASELIST) then
          raise Exception.Create('List not allowed')
        else
          raise Exception.Create('Illegal Code in Text = ' + text);
      end
      else
        raise Exception.Create('Illegal Text = ' + text);
    end
    else
    begin
      ct := ctText;
      if p1 = 0 then
      begin
        txt := copy(text, start, MaxInt);
        start := MaxInt;
      end
      else
        txt := copy(text, start, p1 - start);
        start := p1;
      begin
      end;
    end;
  end;

  procedure AddControl(ctrl: TControl);
  begin
    ctrl.Parent := pnl;
    ctrl.Left := x;
    ctrl.Top := y;
    if ht < ctrl.Height then
      ht := ctrl.Height;
    inc(x, ctrl.width + LEFTGAP);
  end;

begin
  if CheckBox then
  begin
    cb := TCheckBox.Create(Self);
    cb.Parent := sb;
    cb.height := CBWidth;
    cb.Width := CBWidth;
    cb.left := LEFTGAP;
    cb.Top := fy;
    cb.OnClick := CheckBoxClick;
  end
  else
    cb := nil;
  pnl := TPanel.Create(Self);
  pnl.Parent := sb;
  pnl.BevelOuter := bvNone;
  pnl.Left := PANEL_COL;
  pnl.top := fy;
  pnl.Caption := '';
  FPanels.Add(pnl);
  if assigned(cb) then
    cb.Tag := FPanels.Count-1;
  start := 1;
  ct := ctNone;
  rbtnPending := false;
  cboxPending := false;
  x := 0;
  y := 0;
  ht := 0;
  pnl.Width := Self.Width;
  pnl.Anchors := [akLeft, akRight];

  pnl.Height := TOPGAP;
  if RightStr(Text, EOLLEN) <> EOL then
    Text := Text + EOL;
  len := Length(text);
  repeat
    ProcessText;
    if cboxPending then
    begin
      cbx := TCheckBox.Create(Self);

      if ct = ctText then
      begin
        cbx.Caption := txt;
        cbx.Width := Canvas.TextWidth(txt) + cbx.Height;
      end
      else
        cbx.Width := cbx.Height;
      AddControl(cbx);
      ct := ctNone;
      cboxPending := false;
    end;
    if rbtnPending then
    begin
      rad := TRadioButton.Create(Self);
      rad.TabStop := TRUE;
      if ct = ctText then
      begin
        rad.Caption := txt;
        rad.Width := Canvas.TextWidth(txt) + rad.Height;
      end
      else
        rad.Width := rad.Height;
      AddControl(rad);
      ct := ctNone;
      rbtnPending := false;
    end;
    case ct of
      ctEndOfLine:
        begin
          x := 0;
          inc(y, ht + 2);
          pnl.Height := pnl.Height + ht + 2;
          ht := 0;
          inc(FLines);
        end;

      ctRadioButton:
        rbtnPending := true;

      ctCheckBox:
        cboxPending := true;

      ctXXButton:
        begin
          btn := TButton.Create(Self);
          btn.Height := 20;
          btn.Width := 33;
          btn.Caption := '[ ]';
          btn.OnClick := ButtonClick;
          AddControl(btn);
        end;

      ctEditButton:
        begin
          edit := TEdit.Create(Self);
          edit.BorderStyle := bsNone;
          if x > 300 then
            edit.Width := 600 - x
          else
            edit.Width := 300;
          if ht > 0 then
            edit.Height := ht;
          AddControl(edit);
        end;

      ctText:
        begin
          lbl := TLabel.Create(Self);
          lbl.Caption := txt;
          lbl.AutoSize := true;
          AddControl(lbl);
        end;
    end;
  until ct = ctDone;
  inc(fy, pnl.Height);
  if CheckBox then
    CheckBoxClick(cb); // disables the panel's controls;
end;

procedure TfrmSampleTemplate.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSampleTemplate.ButtonClick(Sender: TObject);
begin
  if TButton(Sender).Caption = '[ ]' then
    TButton(Sender).Caption := '[X]'
  else
    TButton(Sender).Caption := '[ ]';
end;

procedure TfrmSampleTemplate.CheckBoxClick(Sender: TObject);
var
  pnl: TPanel;
  cb: TCheckBox;
  i, idx: integer;
begin
  cb := Sender as TCheckBox;
  idx := cb.tag;
  pnl := FPanels[idx] as TPanel;
  for i := 0 to pnl.ControlCount - 1 do
  begin
    pnl.Controls[i].Enabled := cb.Checked;
  end;
end;

procedure TfrmSampleTemplate.FormCreate(Sender: TObject);
begin
  FLists := TObjectList.Create;
  FPanels := TObjectList.Create(false);
  FLists.Add(FPanels);
  FLines := 0;
  FY := TOPGAP;
  Randomize;
end;

procedure TfrmSampleTemplate.FormDestroy(Sender: TObject);
begin
  FLists.Free;
end;

end.
