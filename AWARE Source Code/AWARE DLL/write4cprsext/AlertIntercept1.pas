unit AlertIntercept1;

interface

uses
  ComObj, ActiveX,Dialogs, StdVcl, write4cprsext_TLB, CPRSChart_TLB, Trpcb,SysUtils;



function CKAlert(CPRSBroker:ICPRSBroker; CPRSState:ICPRSState;alerttype:String;DateTime:String):String;
function CKAlertType(CPRSBroker:ICPRSBroker; CPRSState:ICPRSState;alerttype:String;class1:String):String;
function GetAlertData(CPRSBroker:ICPRSBroker; CPRSState:ICPRSState;alerttype:String) : String;

implementation

  function CKAlert(CPRSBroker:ICPRSBroker; CPRSState:ICPRSState;alerttype:String;DateTime:String) : String;
  var ref : Boolean   ;
  begin
        {ShowMessage('Patient Selected: ' + CPRSState.PatientName);
        ShowMessage('Patient DFN: ' + CPRSState.PatientDFN);

        ShowMessage('DUZ of User logging on: ' + CPRSState.UserDUZ);}
       {setting up RPC call to Vista}
//       If CPRSBroker.SetContext('VEFALKPORD') = True
//   CHECK IF CRITICAL ALERT TRACKING AGAINST ORDERS AND IF ORDER COMPLETED AND SIGNED AS FOLLOWUP
// ACTIONS. ALSO CHECK REMINDER DIALOG AND TIU TEMPLATE DEFINED.

  ref:= False;
  ref:= CPRSbroker.SetContext('VEFAALRE');
        If ref
        then
         begin
            {ShowMessage('context changed' );  }
           CPRSBroker.ClearParameters := True;
           CPRSBroker.ClearResults := True;
           CPRSBroker.ParamType[0] := 0 ;
           CPRSBroker.Param[0]:= CPRSState.PatientDFN + '^' + CPRSState.UserDUZ + '^'+ alerttype + '^' + DateTime ;
            //Showmessage(CPRSBroker.Param[0]);
           CPRSBroker.CallRPC('VEFALKPORD');


          Result :=  CPRSBroker.Results ;
      end;
  end;
function CKAlertType(CPRSBroker:ICPRSBroker; CPRSState:ICPRSState;alerttype:String;class1:String) : String;
  var ref : Boolean   ;
  begin
  // CHECK CRITICAL ALERT TYPE FOUND AMONG CRTICAL ALERT CATEGORY PASSED
//       If CPRSBroker.SetContext('VEFA CRIT ALERT TRACKED') = True
  ref:= False;
  ref:= CPRSbroker.SetContext('VEFAALRE');
        If ref
        then
         begin
            {ShowMessage('context changed' );  }
           CPRSBroker.ClearParameters := True;
           CPRSBroker.ClearResults := True;
           CPRSBroker.ParamType[0] := 0 ;
           CPRSBroker.Param[0]:= alerttype + '^' + class1 ;
            //Showmessage(CPRSBroker.Param[0]);
           CPRSBroker.CallRPC('VEFA CRIT ALERT TRACKED');


          Result :=  CPRSBroker.Results ;
      end;
  end;
function GetAlertData(CPRSBroker:ICPRSBroker; CPRSState:ICPRSState;alerttype:String) : String;
  var ref : Boolean   ;
  begin
   //   PASS NAME OF CRIT ALERT IN FILE 19007 AND RETURN REMINDER DIALOG AND TIU TEMPLATE
   ref:= False;
   ref:= CPRSbroker.SetContext('VEFAALRE');
        If ref
        then
         begin
            {ShowMessage('context changed' );  }
           CPRSBroker.ClearParameters := True;
           CPRSBroker.ClearResults := True;
           CPRSBroker.ParamType[0] := 0 ;
           CPRSBroker.Param[0]:= alerttype ;
            //Showmessage(CPRSBroker.Param[0]);
           CPRSBroker.CallRPC('VEFA CRIT ALERT VALUES');


          Result :=  CPRSBroker.Results ;
      end;
  end;
end.
