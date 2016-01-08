unit fVisitType;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fPCEBase, StdCtrls, CheckLst, ExtCtrls, Buttons, ORFn, ComCtrls;

type
  TfrmVisitType = class(TfrmPCEBase)
    lblVType: TLabel;
    lblSCDisplay: TLabel;
    lblVTypeSection: TLabel;
    memSCDisplay: TMemo;
    lbProviders: TListBox;
    lblCurrentProv: TLabel;
    cboPtProvider: TComboBox;
    lblProvider: TLabel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnPrimary: TButton;
    lstVTypeSection: TListBox;
    lbxVisits: TCheckListBox;
    lbMods: TCheckListBox;
    lblMod: TLabel;
    pnlMain: TPanel;
    pnlLeft: TPanel;
    splLeft: TSplitter;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cboPtProviderChange(Sender: TObject);
    procedure lbProvidersChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure splLeftMoved(Sender: TObject);
    procedure splRightMoved(Sender: TObject);
    procedure lbxVisitsClick(Sender: TObject);
    procedure memSCDisplayEnter(Sender: TObject);
  protected
    FSplitterMove: boolean;
    procedure ShowModifiers;
    procedure CheckModifiers;
  private
    FLastCPTCodes: string;
    procedure UpdateProviderButtons;
  public
    procedure MatchVType;
  end;

var
  frmVisitType: TfrmVisitType;

const
  LBCheckWidthSpace = 18;

implementation

{$R *.DFM}

const
  FN_NEW_PERSON = 200;
  
procedure TfrmVisitType.MatchVType;
begin
end;

procedure TfrmVisitType.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  //process before closing

end;

(*function ExposureAnswered: Boolean;
begin
  result := false;
  //if SC answered set result = true
end;*)


procedure TfrmVisitType.FormCreate(Sender: TObject);

begin
  inherited;
end;

(*procedure TfrmVisitType.SynchEncounterProvider;
// add the Encounter.Provider if this note is for the current encounter
var
  ProviderFound, PrimaryFound: Boolean;
  i: Integer;
  AProvider: TPCEProvider;
begin
  if (FloatToStrF(uEncPCEData.DateTime, ffFixed, 15, 4) =      // compensate rounding errors
      FloatToStrF(Encounter.DateTime,   ffFixed, 15, 4)) and
     (uEncPCEData.Location = Encounter.Location) and
     (Encounter.Provider > 0) then
  begin
    ProviderFound := False;
    PrimaryFound := False;
    for i := 0 to ProviderLst.Count - 1 do
    begin
      AProvider := TPCEProvider(ProviderLst.Items[i]);
      if AProvider.IEN = Encounter.Provider then ProviderFound := True;
      if AProvider.Primary = '1' then PrimaryFound := True;
    end;
    if not ProviderFound then
    begin
      AProvider := TPCEProvider.Create;
      AProvider.IEN := Encounter.Provider;
      AProvider.Name := ExternalName(Encounter.Provider, FN_NEW_PERSON);
      if not PrimaryFound then
      begin
        AProvider.Primary := '1';
        uProvider := Encounter.Provider;
      end
      else AProvider.Primary := '0';
      AProvider.Delete := False;
      ProviderLst.Add(AProvider);
    end;
  end;
end;
*)

procedure TfrmVisitType.UpdateProviderButtons;
var
  ok: boolean;

begin
  ok := (lbProviders.ItemIndex >= 0);
  btnDelete.Enabled := ok;
  btnPrimary.Enabled := ok;
  btnAdd.Enabled := true;//(cboPtProvider.ItemIEN <> 0);
end;

procedure TfrmVisitType.cboPtProviderChange(Sender: TObject);
begin
  inherited;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.lbProvidersChange(Sender: TObject);
begin
  inherited;
  UpdateProviderButtons;
end;

procedure TfrmVisitType.FormResize(Sender: TObject);
var
  v, i: integer;
  s: string;
  ScrollBarWidth : integer;
begin
  ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL);
  if FSplitterMove then
    FSplitterMove := FALSE
  else
    begin
      inherited;
      FSectionTabs[0] := -(lbxVisits.width - LBCheckWidthSpace - MainFontWidth - ScrollBarWidth);
      FSectionTabs[1] := -(lbxVisits.width - (6*MainFontWidth) - ScrollBarWidth);
      if(FSectionTabs[0] <= FSectionTabs[1]) then FSectionTabs[0] := FSectionTabs[1]+2;
//      lbxVisits.TabPositions := SectionString;
      v := (lbMods.width - LBCheckWidthSpace - (4*MainFontWidth) - ScrollBarWidth);
      s := '';
      for i := 1 to 20 do
      begin
        if s <> '' then s := s + ',';
        s := s + inttostr(v);
        if(v<0) then
          dec(v,32)
        else
          inc(v,32);
      end;
//      lbMods.TabPositions := s;
    end;
end;

procedure TfrmVisitType.ShowModifiers;
const
  ModTxt = 'Modifiers';
  ForTxt = ' for ';
  Spaces = '    ';

var
  TopIdx: integer;
//  Needed,
  Codes, VstName, Hint, Msg: string;

begin
  Codes := '';
  VstName := '';
  Hint := '';
  if(Codes = '') and (lbxVisits.ItemIndex >= 0) then
  begin
    Codes := piece(lbxVisits.Items[lbxVisits.ItemIndex],U,1) + U;
    VstName := piece(lbxVisits.Items[lbxVisits.ItemIndex],U,2);
    Hint := VstName;
//    Needed := piece(lbxVisit.Items[lbxVisit.ItemIndex],U,4); Don't show expired codes!
  end;
  msg := ModTxt;
  if(VstName <> '') then
    msg := msg + ForTxt;
  lblMod.Caption := msg + VstName;
//  lbMods.Caption := lblMod.Caption;
  if(pos(CRLF,Hint)>0) then
    Hint := ':' + CRLF + Spaces + Hint;
  lblMod.Hint := msg + Hint;
  
  if(FLastCPTCodes = Codes) then
    TopIdx := lbMods.TopIndex
  else
  begin
    TopIdx := 0;
    FLastCPTCodes := Codes;
  end;
  lbMods.TopIndex := TopIdx;
  CheckModifiers;
end;

procedure TfrmVisitType.CheckModifiers;
begin
end;

procedure TfrmVisitType.splLeftMoved(Sender: TObject);
begin
  inherited;
  lblVType.Left := lbxVisits.Left + pnlMain.Left;
  FSplitterMove := TRUE;
  FormResize(Sender);
end;

procedure TfrmVisitType.splRightMoved(Sender: TObject);
begin
  inherited;
  lblMod.Left := lbMods.Left + pnlMain.Left;
  FSplitterMove := TRUE;
  FormResize(Sender);
end;

procedure TfrmVisitType.lbxVisitsClick(Sender: TObject);
begin
  inherited;
  ShowModifiers;
end;

procedure TfrmVisitType.memSCDisplayEnter(Sender: TObject);
begin
  inherited;
  memSCDisplay.SelStart := 0;
end;

initialization
//frmVisitType.CreateProviderList;

finalization
//frmVisitType.FreeProviderList;

end.
