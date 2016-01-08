program TechTalk;

uses
  Forms,
  TechTalkMain in 'TechTalkMain.pas' {frmTechTalk},
  DataM in 'DataM.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTechTalk, frmTechTalk);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
