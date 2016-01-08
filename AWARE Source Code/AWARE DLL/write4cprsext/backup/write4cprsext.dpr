library write4cprsext;

uses
  ComServ,
  CPRSChart_TLB,
  write4cprsext_TLB in 'write4cprsext_TLB.pas',
  FAT3_textok in 'FAT3_textok.pas' {FATForm},
  AlertIntercept1 in 'AlertIntercept1.pas',
  writecomobject in 'writecomobject.pas',
  FAT4_textok in 'FAT4_textok.pas' {FATFormS},
  FATHelpScreen in 'FATHelpScreen.pas' {HelpScreen};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;


{$R *.TLB}

{$R *.RES}

begin
end.
