unit TechTalkMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, StdCtrls, Grids, CheckLst, ORCtrls,
  VA508AccessibilityManager, VA508ImageListLabeler, DataM;

type
  TfrmTechTalk = class(TForm)
    CheckListBox1: TCheckListBox;
    StringGrid1: TStringGrid;
    btnForward: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    btnDrawer: TButton;
    TreeView1: TTreeView;
    Label2: TLabel;
    ListView1: TListView;
    bntBack: TButton;
    Button4: TButton;
    VA508StaticText1: TVA508StaticText;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    VA508ImageListLabeler1: TVA508ImageListLabeler;
    VA508ComponentAccessibility1: TVA508ComponentAccessibility;
    ImageList1: TImageList;
    VA508ComponentAccessibility2: TVA508ComponentAccessibility;
    procedure FormCreate(Sender: TObject);
    procedure btnDrawerClick(Sender: TObject);
    procedure VA508ComponentAccessibility1InstructionsQuery(Sender: TObject;
      var Text: string);
    procedure Button4Click(Sender: TObject);
    procedure VA508ComponentAccessibility2ValueQuery(Sender: TObject;
      var Text: string);
    procedure VA508ComponentAccessibility2ItemQuery(Sender: TObject;
      var Item: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTechTalk: TfrmTechTalk;

implementation

{$R *.dfm}

uses VA508AccessibiliyRouter;

procedure TfrmTechTalk.btnDrawerClick(Sender: TObject);
begin
  TreeView1.Visible := not TreeView1.Visible;
  if TreeView1.Visible then
    GetScreenReader.Speak('Titles Drawer Open')
  else
    GetScreenReader.Speak('Titles Drawer Closed') 
end;

procedure TfrmTechTalk.Button4Click(Sender: TObject);
begin
  GetScreenReader.Speak(button4.Caption);
end;

procedure TfrmTechTalk.FormCreate(Sender: TObject);
var
  i,j: integer;
  data: string;
begin
 // ListView1.SmallImages := ImageList1;
  for i := 0 to 4 do
  begin
    for j := 0 to 4 do
    begin
      if i = 0 then
      begin
        if j = 0 then
          data := ''
        else
          data := char(68 + j);
      end
      else
      if j = 0 then
        data := char (64 + i)
      else
        data := inttostr(10 + i + (j*10));
      StringGrid1.Cells[i,j] := data;        


    end;
  end;
end;

procedure TfrmTechTalk.VA508ComponentAccessibility1InstructionsQuery(
  Sender: TObject; var Text: string);
begin
  if TreeView1.Visible then
    Text := 'To close drawer press space bar'
  else
    Text := 'To open drawer press space bar';
end;

procedure TfrmTechTalk.VA508ComponentAccessibility2ItemQuery(
  Sender: TObject; var Item: TObject);
begin
  Item := TObject(TStringGrid(Sender).Selection.Top + TStringGrid(Sender).Selection.Left);
end;

procedure TfrmTechTalk.VA508ComponentAccessibility2ValueQuery(
  Sender: TObject; var Text: string);
begin
  Text := 'Image Text' + Text;
end;

initialization

//SpecifyFormIsNotADialog(TfrmTechTalk);

end.
