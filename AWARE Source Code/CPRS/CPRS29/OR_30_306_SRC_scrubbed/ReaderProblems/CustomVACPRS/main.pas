unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ORCtrls, VA508AccessibilityManager, ORCtrlsVA508Compatibility,
  ExtCtrls, Buttons;

type
  TfrmMain = class(TForm)
    ORListBox1: TORListBox;
    cbCheckboxesTrue: TCheckBox;
    ORCheckBox1: TORCheckBox;
    ORCheckBox2: TORCheckBox;
    ORCheckBox3: TORCheckBox;
    VA508AccessibilityManager1: TVA508AccessibilityManager;
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Button2: TButton;
    ORComboBox1: TORComboBox;
    ComboBox1: TComboBox;
    procedure cbCheckboxesTrueClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses VAUtils;

{$R *.dfm}

procedure TfrmMain.Button1Click(Sender: TObject);
var
  l1, l2: integer;
  p1, p2: TWinControl;
begin
  l1 := ORListBox1.Left;
  l2 := ORCheckBox1.Left;
  p1 := ORListBox1.Parent;
  p2 := ORCheckBox1.Parent;

  ORListBox1.Parent := p2;
  cbCheckboxesTrue.Parent := p2;
  ORListBox1.left := l2;
  cbCheckboxesTrue.left := l2;

  ORCheckBox1.Parent := p1;
  ORCheckBox1.Left := l1;
  ORCheckBox2.Parent := p1;
  ORCheckBox2.Left := l1;
  ORCheckBox3.Parent := p1;
  ORCheckBox3.Left := l1;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  if panel1.parent = panel2 then
    panel1.parent := panel3
  else
    panel1.parent := panel2
end;

procedure TfrmMain.cbCheckboxesTrueClick(Sender: TObject);
begin
  ORListBox1.CheckBoxes := cbCheckboxesTrue.Checked;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  cbCheckboxesTrue.Parent := panel1;
  cbCheckboxesTrue.top := 10;
  ORListBox1.Parent := panel1;
  ORListBox1.top := 33;

end;

end.
