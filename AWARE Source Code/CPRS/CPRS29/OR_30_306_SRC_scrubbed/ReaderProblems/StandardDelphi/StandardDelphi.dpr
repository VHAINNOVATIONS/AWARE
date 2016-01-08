program StandardDelphi;

uses
  Forms,
  main in 'main.pas' {frmMain},
  SampleTemplate in 'SampleTemplate.pas' {frmSampleTemplate},
  fSamplePopup in 'fSamplePopup.pas' {frmSamplePopup},
  fPCEBase in 'fPCEBase.pas' {frmPCEBase},
  uMisc in 'uMisc.pas',
  ORFn in 'ORFn.pas',
  fVisitType in 'fVisitType.pas' {frmVisitType},
  VA508DelphiCompatibility in '..\..\VA\VA508Accessibility\VA508DelphiCompatibility.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSamplePopup, frmSamplePopup);
  Application.CreateForm(TfrmPCEBase, frmPCEBase);
  Application.CreateForm(TfrmVisitType, frmVisitType);
  Application.Run;
end.
