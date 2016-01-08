unit AlertIntercept;
interface

uses
  ComObj, ActiveX, StdVcl, CPRSChart_TLB,
   write4cprsext_TLB;

type
//  TSample2COMObject = class(TAutoObject, ISample2COMObject, ICPRSExtension)
  TSample2COMObject = class(TAutoObject, Iwrite4comobject, ICPRSExtension)
   protected
    function Execute(const CPRSBroker: ICPRSBroker;
      const CPRSState: ICPRSState; const Param1, Param2,
      Param3: WideString; var Data1, Data2: WideString): WordBool;
      safecall;
  end;

implementation

uses ComServ, Dialogs;

function TSample2COMObject.Execute(const CPRSBroker: ICPRSBroker;
        const CPRSState: ICPRSState; const Param1, Param2, Param3: WideString;
        var   Data1, Data2: WideString): WordBool;
begin
        {ShowMessage('Patient Selected: ' + CPRSState.PatientName);
        ShowMessage('Patient DFN: ' + CPRSState.PatientDFN);

        ShowMessage('DUZ of User logging on: ' + CPRSState.UserDUZ);}
       {setting up RPC call to Vista}
//       If CPRSBroker.SetContext('AJJ2 ABNORMAL ALERT CHECK') = True
        If True
        then
         begin
            {ShowMessage('context changed' );  }
           CPRSBroker.ClearParameters := True;
           CPRSBroker.ClearResults := True;
           CPRSBroker.ParamType[0] := 0 ;
           CPRSBroker.Param[0]:= CPRSState.PatientDFN + '^' + CPRSState.UserDUZ + 'Abnormal Rad';

           CPRSBroker.CallRPC('AJJ2 ABNORMAL RAD ALERT');
           {ShowMessage('Result of RPC1 call:' + CPRSBroker.Results[1]);}
           If  CPRSBroker.Results[1] = '0'
            then ShowMessage('This patient has NO Abnormal Imaging Results Alert unacknowledged');
           If  CPRSBroker.Results[1] <> '0'
            then ShowMessage('This patient has some Abnormal Imaging Results Alert unacknowledged' );
          end;
end;
initialization
  TAutoObjectFactory.Create(ComServer, TSample2COMObject, Class_write4comobject,
    ciMultiInstance, tmApartment);
end.

