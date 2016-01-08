program CustomVACPRS;

uses
  Forms,
  main in 'main.pas' {frmMain},
  ORCtrls in '..\..\CPRS-Lib\ORCtrls.pas',
  Accessibility_TLB in '..\..\CPRS-Chart\Accessibility_TLB.pas',
  uAccessAPI in '..\..\CPRS-Lib\uAccessAPI.pas',
  ORCtrlsVA508Compatibility in '..\..\CPRS-Lib\ORCtrlsVA508Compatibility.pas',
  VA508AccessibilityManager in '..\..\VA\VA508Accessibility\VA508AccessibilityManager.pas',
  VAUtils in '..\..\VA\VAUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
