program FreedomDemo;

{%TogetherDiagram 'ModelSupport_FreedomDemo\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\fODMeds\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\ORCtrlsVA508Compatibility\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\VA508DelphiCompatibility\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\FreedomDemo\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\fSplash\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\Main\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\VA508AccessibilityConst\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\ORDtTm\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_FreedomDemo\default.txvpck'}

uses
  Forms,
  Controls,
  contnrs,
  SysUtils,
  Windows,
  DateUtils,
  Main in 'Main.pas' {frmMain},
  VA508DelphiCompatibility in '..\..\VA\VA508Accessibility\VA508DelphiCompatibility.pas',
  VA508AccessibilityConst in '..\..\VA\VA508Accessibility\VA508AccessibilityConst.pas',
  fSplash in 'fSplash.pas' {frmSplash},
  ORCtrlsVA508Compatibility in '..\..\CPRS-Lib\ORCtrlsVA508Compatibility.pas',
  ORDtTm in '..\..\CPRS-Lib\ORDtTm.pas' {ORfrmDtTm},
  fODMeds in 'fODMeds.pas' {frmODMeds};

{$R *.res}
procedure ShowSplash;
var
  res: TModalResult;
  list: TObjectList;
  start: TDateTime;
begin
  Randomize;
  repeat
    frmSplash := TfrmSplash.Create(Application);
    list := TObjectList.Create;
    try
      frmSplash.Show;
      while not frmSplash.ASk do
      begin
        start := now;
        repeat
          list.add(TObject.Create);
        until MilliSecondSpan(Now, start) > 100;
        Application.ProcessMessages;
      end;
      Res := Application.MessageBox(PChar('Retry Splash Screen?'), PChar('Retry'), MB_RETRYCANCEL);
    finally
      list.Free;
      frmSplash.Free;
    end;
  until res <> IDRETRY;
end;

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  //  ShowSplash;
  Application.Run;
end.
