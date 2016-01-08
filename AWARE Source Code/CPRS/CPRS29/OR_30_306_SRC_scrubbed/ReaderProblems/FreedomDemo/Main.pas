unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VA508AccessibilityManager, VA508AccessibilityRouter, CheckLst,
  ImgList, ComCtrls, Buttons, Grids, ExtCtrls, AppEvnts, VA508ImageListLabeler,
  ORCtrls;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    va508mgr: TVA508AccessibilityManager;
    ComboBox1: TComboBox;
    CheckListBox1: TCheckListBox;
    btnFruit: TButton;
    tvFruit: TTreeView;
    ImageList1: TImageList;
    RichEdit1: TRichEdit;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    Edit2: TEdit;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    ListView1: TListView;
    fldAccFruit: TVA508ComponentAccessibility;
    ListBox1: TListBox;
    fldAccEdit: TVA508ComponentAccessibility;
    labeler: TVA508ImageListLabeler;
    ImageList2: TImageList;
    ORCheckBox1: TORCheckBox;
    ImageList3: TImageList;
    ImageList4: TImageList;
    ORTreeView1: TORTreeView;
    ORListView1: TORListView;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    VA508ImageListLabeler1: TVA508ImageListLabeler;
    VA508ImageListLabeler2: TVA508ImageListLabeler;
    VA508ImageListLabeler3: TVA508ImageListLabeler;
    ORListBox1: TORListBox;
    Label12: TLabel;
    orlbMS: TCheckBox;
    orlbCB: TCheckBox;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    StringGrid1: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid2: TStringGrid;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    Button2: TButton;
    lv: TCaptionListView;
    procedure FormCreate(Sender: TObject);
    procedure btnFruitClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure tvFruitExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure tvFruitCollapsing(Sender: TObject; Node: TTreeNode;
      var AllowCollapse: Boolean);
    procedure fldAccFruitStateQuery(Sender: TObject;
      var Text: string);
    procedure fldAccEditCaptionQuery(Sender: TObject;
      var Text: string);
    procedure Button1Click(Sender: TObject);
    procedure orlbMSClick(Sender: TObject);
    procedure orlbCBClick(Sender: TObject);
    procedure VA508ComponentAccessibility1ValueQuery(Sender: TObject;
      var Text: string);
    procedure Button2Click(Sender: TObject);
    procedure lvSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses VA508DelphiCompatibility, fODMeds;

{$R *.dfm}

procedure TfrmMain.btnFruitClick(Sender: TObject);
begin
  tvFruit.Visible := not tvFruit.Visible;
//  if tvFruit.Visible then
//    GetScreenReader.Speak('Fruit Basket Open')
//  else
//    GetScreenReader.Speak('Fruit Basket Closed');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i,r,rstart,c,cstart,z: integer;
  grid: TStringGrid;

begin
  ImageList1.Overlay(6, 1);
  ImageList1.Overlay(7, 2);
  ImageList4.Overlay(4, 1);
  ListView1.Items[0].OverlayIndex := 2;
  ListView1.Items[2].OverlayIndex := 1;
  ListView1.Items[4].OverlayIndex := 1;
  ORListView1.Items[0].OverlayIndex := 1;
  ORListView1.Items[1].OverlayIndex := 1;

  for I := 1 to 4 do
  begin
    case i of
      1: grid := StringGrid1;
      2: grid := StringGrid2;
      3: grid := StringGrid3;
      else grid := StringGrid4;
    end;

    if grid.FixedRows > 0 then
      rStart := 1
    else
      rStart := 0;

    if grid.FixedCols > 0 then
      cStart := 1
    else
      cStart := 0;

    for c := cStart to grid.ColCount-1 do
    begin
      z := c * 10;
      if (grid.FixedRows > 0) then
        grid.Cells[c,0] := char(ord('A') + c - cStart);
      for r := rstart to grid.RowCount-1 do
      begin
        if grid.FixedCols > 0 then
          grid.Cells[0,r] := char(ord('K') + r - rStart);
        if ((c <> 1) or ((r mod 2) = 0)) and (z <> 42) then
          grid.Cells[c,r] := inttostr(z);
        inc(z,1);
      end;
    end;
  end;

  with lv.Items.Add do
  begin
    Caption := '771';
    SubItems.Add('John Smith');
    SubItems.Add('27131 North Winchester Way');
    SubItems.Add('Suite 750');
    SubItems.Add('Austin');
    SubItems.Add('Texas');
    SubItems.Add('88776');
    SubItems.Add('Red');
    SubItems.Add('Customer is behind on his payments and should not be allowed credit');
  end;
  with lv.Items.Add do
  begin
    Caption := '';
    SubItems.Add('Susan R. Brown');
    SubItems.Add('2007 Granger Road');
    SubItems.Add('');
    SubItems.Add('Atlanta');
    SubItems.Add('Georga');
    SubItems.Add('12345-6789');
    SubItems.Add('');
    SubItems.Add('Customer is in good standing');
  end;
  with lv.Items.Add do
  begin
    Caption := '123';
    SubItems.Add('Alexander Robinson');
    SubItems.Add('123 West Pine Street');
    SubItems.Add('');
    SubItems.Add('Orlando');
    SubItems.Add('Florida');
    SubItems.Add('87654');
    SubItems.Add('Blue');
    SubItems.Add('Customer is in fair standing');
  end;
end;

procedure TfrmMain.lvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  Sleep(200); // represents RPC call that slows down selection and causes double speak
              // with first speak not using MSAA
end;

procedure TfrmMain.orlbCBClick(Sender: TObject);
begin
  ORListBox1.CheckBoxes := orlbCB.Checked;
  if ORListBox1.CheckBoxes then
  begin
    orlbMS.Checked := FALSE;
    Application.ProcessMessages;
    ORListBox1.Repaint;
  end;
end;

procedure TfrmMain.orlbMSClick(Sender: TObject);
begin
  ORListBox1.MultiSelect := orlbMS.Checked;
  if ORListBox1.MultiSelect then
    orlbCB.Checked := FALSE;
end;

procedure TfrmMain.SpeedButton1Click(Sender: TObject);
begin
  CheckListBox1.AllowGrayed := FALSE;
end;

procedure TfrmMain.SpeedButton2Click(Sender: TObject);
begin
  CheckListBox1.AllowGrayed := TRUE;
end;

procedure TfrmMain.tvFruitCollapsing(Sender: TObject; Node: TTreeNode;
  var AllowCollapse: Boolean);
begin
  Case Node.ImageIndex of
    9: Node.ImageIndex := 8;
    11: Node.ImageIndex := 10;
    13: Node.ImageIndex := 12;
  end;
  Node.SelectedIndex := Node.ImageIndex;
  AllowCollapse := TRUE;
end;

procedure TfrmMain.tvFruitExpanding(Sender: TObject; Node: TTreeNode;
  var AllowExpansion: Boolean);
begin
  Case Node.ImageIndex of
    8: Node.ImageIndex := 9;
    10: Node.ImageIndex := 11;
    12: Node.ImageIndex := 13;
  end;
  Node.SelectedIndex := Node.ImageIndex;
  AllowExpansion := TRUE;
end;

procedure TfrmMain.VA508ComponentAccessibility1ValueQuery(Sender: TObject;
  var Text: string);
begin
  Text := 'Testing ' + Text;
end;

procedure TfrmMain.fldAccFruitStateQuery(Sender: TObject;
  var Text: string);
begin
  Application.ProcessMessages;
  if tvFruit.Visible then
    Text := 'Open'
  else
    Text := 'Closed';
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  ORListBox1.FocusIndex := -1;
  ORListBox1.ItemIndex := -1;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  frmODMeds := TfrmODMeds.Create(Application);
  try
    frmODMeds.ShowModal;
  finally
    frmODMeds.Free;
  end;
end;

procedure TfrmMain.fldAccEditCaptionQuery(Sender: TObject;
  var Text: string);
begin
  Text := Text + ' testing';
end;

initialization
  SpecifyFormIsNotADialog(TfrmMain);

end.
