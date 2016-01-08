unit rEventHooks;
 //AWARE 1/23/14
interface

uses
  Classes, ORNet;
  
function GetPatientChangeGUIDs: string;
function GetOrderAcceptGUIDs(DisplayGroup: integer): string;
function GetAllActiveCOMObjects: TStrings;
function GetCOMObjectDetails(IEN: integer): string;
  //AWARE change
function GetPatientChartCloseout: string;
//end AWARE change

implementation

function GetPatientChangeGUIDs: string;
begin
  Result := sCallV('ORWCOM PTOBJ', []);
end;

function GetOrderAcceptGUIDs(DisplayGroup: integer): string;
begin
  Result := sCallV('ORWCOM ORDEROBJ', [DisplayGroup]);
end;

function GetAllActiveCOMObjects: TStrings;
begin
  CallV('ORWCOM GETOBJS', []);
  Result := RPCBrokerV.Results;
end;

function GetCOMObjectDetails(IEN: integer): string;
begin
  Result := sCallV('ORWCOM DETAILS', [IEN]);
end;

   //VEFA changes below
function GetPatientChartCloseout: string;
begin
  Result := sCallV('ORWCOM VEFA PT CLSCHART', []);  //Longbeach VEFA ORWCOM PT CLSCHART and //Charleston ORWCOM VEFA PT CLSCHART
end;
end.
