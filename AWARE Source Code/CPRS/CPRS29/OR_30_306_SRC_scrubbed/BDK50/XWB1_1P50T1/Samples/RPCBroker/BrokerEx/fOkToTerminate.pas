unit fOkToTerminate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmOKToTerminate = class(TForm)
    frmOKToTerminate: TLabel;
    btnYes: TButton;
    btnNo: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOKToTerminate: TfrmOKToTerminate;

implementation

{$R *.DFM}

end.
