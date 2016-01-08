unit writecomobject;

interface

uses
  Classes, ORfn, ORCtrls, ComObj, ActiveX, write4cprsext_TLB, StdVcl,CPRSChart_TLB,
     //Trpcb,
     Mfunstr,
     //FmCmpnts,
     //DiTypLib,
     Forms,Windows,ORSystem,extctrls,Messages, AlertIntercept1, StdCtrls,FAT4_textok;

type
    PMsg = ^TMsg;
{    TMsg = packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;                                                   f
    pt: TPoint;
  end;
}
  {$IFDEF GroupEncounter}
  TCPRSTimeoutTimerCondition = function: boolean;
  TCPRSTimeoutTimerAction = procedure;
{$ELSE}
  TCPRSTimeoutTimerCondition = function: boolean of object;
  TCPRSTimeoutTimerAction = procedure of object;
{$ENDIF}
  Twrite4comobject = class(TAutoObject, Iwrite4comobject, ICPRSExtension)
   protected
    function Execute(const CPRSBroker: ICPRSBroker;
      const CPRSState: ICPRSState; const Param1, Param2,
      Param3: WideString; var Data1, Data2: WideString): WordBool;
      safecall;
    procedure Free ();
    procedure AppMessage(var Msg: tagMSG; var Handled: Boolean);

    { Protected declarations }
  end;

  TCPRSTimeoutTimer = class(TTimer)
  private
    FHooked: boolean;
    FUserCondition: TCPRSTimeoutTimerCondition;
    FUserAction: TCPRSTimeoutTimerAction;
    uTimeoutInterval: Cardinal;
    uTimeoutKeyHandle, uTimeoutMouseHandle: HHOOK;
    uTimeoutJournalRecordProcHandle : HHOOK;
    uTimeoutJournalPlaybackProcHandle : HHOOK;
  protected
    //procedure ResetTimeout;
    //procedure timTimeoutTimer(Sender: TObject);    
  end;



//function TSample2COMObject.Execute(const CPRSBroker: ICPRSBroker;
//        const CPRSState: ICPRSState; const Param1, Param2, Param3: WideString;
//        var   Data1, Data2: WideString): WordBool;
//function recallAlerts(CPRSBroker: ICPRSBroker;CPRSState:ICPRSState) : Integer; StdCall;forward;
function ShowFATForm(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState) : Integer; StdCall;forward;
function ShowFATFormS(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState) : Integer; StdCall;forward;

procedure LoadNotifications(Dest: TStrings;const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState);
procedure LoadCritAlerts1(Dest: TStrings;const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState);
procedure LoadAlertsOrdersDoc(Dest: TStrings;const CPRSBroker: ICPRSBroker;const CPRSState: ICPRSState;Param1 : String);
procedure LoadAlertsFollowupsDoc(Dest: TStrings;const CPRSBroker: ICPRSBroker;const CPRSState: ICPRSState;Param1 : String);

//procedure LoadCritAlerts(Dest: Tstrings);
procedure tCallV(const CPRSBroker: ICPRSBroker; const CPRSState: ICPRSState;ReturnData: TStrings; const RPCName: string; const AParam: array of const);
procedure tCallV1(const CPRSBroker: ICPRSBroker;const CPRSState: ICPRSState;ReturnData: TStrings; const RPCName: string; Param1: String);
procedure FastAssign(source, destination: TStrings);
procedure SetParams(const CPRSBroker: ICPRSBroker; const RPCName: string; const AParam: array of const);
procedure SetList(const CPRSBroker: ICPRSBroker; AStringList: TStrings; ParamIndex: Integer);

var timTimeout: TCPRSTimeoutTimer;// external;
    bRecord:Boolean = False;
    bPlayback:Boolean = True;
    FormTake : Integer = 0; //means default as take   TFATFormS (short)
implementation

uses ComServ, Dialogs,SysUtils,db,comctrls, rMisc,Controls,FAT3_textok;

resourcestring
  //StrFPtSel_lstvAlerts_Co = 'C'+U+'FAT3_textok.lstvAlerts.Cols';
  StrFPtSel_lstvAlerts_Co = 'C'+'^'+'FAT3_textok.lstvAlerts.Cols';
const
  AliasString = ' -- ALIAS';




var
       icnt:Integer = 0;
       icntm1:Integer = 0;
       icntmsg:Integer = 0;
       uModal:Integer = 0;
       DateTimeA:PChar = nil;
       T1:TDateTimeField = nil;
       T2:TDateTimeField = nil;
       T11:DWORD = 0;
       T22:DWORD = 0;
       BASETIME:DWORD = 0;
       DELTA:DWORD = 0;
       T2REAL: Real;
       T1INT64: Int64;
       T1INT: Longword;
       T1REAL: Real;
       T2INT64: Int64;
       T2INT: Longword;
       TIDWORD:DWORD=0 ;
       TIDWORD1:DWORD=0;
       TDIFF:DWORD=0;
       eventptr:PEventMsg;//^EVENTMSG;
       threadIdptr:LPDWORD = NIL;
       threadID:DWORD;
       messagec:TMsg;
       msgptr:PMsg;// = ^messagec ;//@messagec;// = ^messagec;//^TMsg;
       ////FmGets1:TFMGets = nil;
       ////FmGets2:TFMGets = nil;
       ////FmGets3:TFMGets = nil;
       ////FmGets4:TFMGets = nil;


       NewItem: TListItem;
       I,J,K: Integer;
       Comment: String;
       ////lstvAlerts1: TCaptionListView;
       List: TStringList;
       ListCritAlertCategories:  TStringList;
       ListCritAlertOrders:  TStringList;
       ListCritAlertFollowups:  TStringList;
       FATForm: TFATForm;

       ////FmFiler1:TFMFiler = nil;
       ////FmFiler2:TFMFiler = nil;
       TControl1:TTabControl = nil;
       ////critalertlist: TFMLister = nil;
       FString1:string;
       //FmBroker : TRPCBroker;
       uTimeoutInterval :Cardinal ;
       uTimeoutKeyHandle : HHOOK ;
       uTimeoutMousehandle: HHOOK ;
       uInt:Integer = 0 ;
       bToggle:Boolean = False; //no record until complete exit with toggle
       bInit:Boolean = True; // start record or playback
       //uModal:Integer = 0 ;
       BufMessage: Array [0..8092] of TMsg; //tagEVENTMSG;
       uTimeoutJournalRecordProcHandle : HHOOK = 0;
       uTimeoutJournalPlaybackProcHandle : HHOOK = 0;
       uTimeoutSysMsgProcHandle : HHOOK = 0;
       //bRecord:Boolean = False;
       //bPlayback:Boolean = True;
       counter1:Integer = 0;
       first:Boolean = False;
       lastmessage:Integer = 0;
       lastcode:integer = 0;
       isee:Integer = 0;
       ToF:File;
       icntot:Integer = 0;
       iflagptr:Integer = 0;

       bResult:Boolean;
       counter:Integer;
       Zero:TMsg;

       icnt9:Integer ;
       CntStr,Iens1:String;
       x,y:longint;
       itestcase:Integer = 0;
       irepeat1:Integer = -1;
       iTestRequest,iTestRequestIen,itestpatient,iprovider:Integer;
       sRequestType,sTcpIpAdrPort:String;
       iskip1:Integer = 0;
       OrdersCount,FollowupCount: Integer;

     //  FormTake : Integer = 0; //means default as take   TFATFormS (short)





function Twrite4comobject.Execute(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState; const Param1, Param2, Param3: WideString;
  var Data1, Data2: WideString): WordBool;

  label again,over,REPEAT1,OVER2,NEXT,over3,OVER4,OVER5,OVER6,OVER9 ;

  var

        DateTimeV1: TDateTime;
        DateTimeV2: TDateTime;
        T1float,T2float:   comp;
        i,j,IS1,IS2:integer;
        sAVcode,istr: string;
        //fatal: boolean;
        ////err: TFMErrorObj;
        ival: integer;
        firstflag,CriticalAlert,rec: string;
        FATFormReturn: integer;
        recallAlertsReturn: String;
        result1: boolean;
        colSizes:string;
        CriticalLabName:TLabel;
        tmpstr,tmptyp,tmpi:string;
        ////orderdlglist:TFMLister;

        IEN:string;
        ////MyRecordObj:TFMRecordObj;
        ////MyFieldObj,MyFieldObj1,MyFieldObj2,MyFieldObj3:TFMFieldObj;
        IENfind,kindcrit:string;
        ////FmFindOne3 :TFMFindOne     ;
        JJ,JK: Integer;
        strtmp1,valueflag,valueflag1,valueflagu : String;
        KFIRST,JKK :Integer;
        ReminderDialog,TIUTemplate: String;
        alerttype: String;
        DateTime : String;
        asterisks: Integer;
        asterisks_first : Integer;
        class1: Integer;
        firstflag1,firstflag2,returnclass,firstflagc,firstflagt,firstflagcc: String;
        deletealert,notifytype : String;
        returnData: String;

begin
        //Showmessage('Enter ');
       uTimeoutInterval    := 120000;  // initially 2 minutes, will get DTIME after signon
       //ival := Integer (HInstance);
       //Data1 := IntToStr(ival);

// Call AlertIntercept function here.
// Quit.
       //Exit;
//       ShowMessage('Here we are');
       if DateTimeA = nil then
       begin
       GetMem(DateTimeA,Sizeof(DateTimeV1));
       //if uTimeoutJournalRecordProcHandle<>0  then uTimeoutJournalRecordProcHandle := SetWindowsHookEx(WH_JOURNALRECORD,TimeoutJournalRecordProcHook,HInstance,0) ; //Application.Handle, 0);
       //uTimeoutKeyHandle   := SetWindowsHookEx(WH_KEYBOARD, TimeoutKeyHook,   0, GetCurrentThreadID);
       //uTimeoutMouseHandle := SetWindowsHookEx(WH_MOUSE,    TimeoutMouseHook, 0, GetCurrentThreadID);
       //Application.OnMessage := AppMessage;
       end;
     //FMbroker code section here

       //Showmessage('icnt=0') ;
      //assuming each pass broker deallocated so one must be obtained as above ( unless
      //later only passsing thru without connection needed. for now assume need once
      //each pass thru dll
     //ShowMessage('Here we are two');
//         Showmessage('Cnt(0)')  ;
      //CHECK FOR TEST CASE REQUEST. STAY IN LOOP UNTIL REQUEST made with TEST CASE #, PATIENT, ETC
      /////////uTimeoutJournalRecordProcHandle := 0;

  // Load the items
//    CriticalLabName := TLabel.Create(nil);
   /// lstvAlerts1 := TCaptionListView.Create(nil);

    ListCritAlertCategories :=  TStringList.Create;
    //get crtitical alert categories ( up to 40)
    //Showmessage('Enter ');
    LoadCritAlerts1(ListCritAlertCategories ,CPRSBroker,CPRSState) ;
    //LoadCritAlerts(ListCritAlertCategories );
    deletealert := '' ;
    for I := 0 to ListCritAlertCategories.Count - 1 do
    begin
       //ShowMessage(ListCritAlertCategories[I]);
       if not (Piece(Param2,'Single',2)='') then
       begin
           if not (Data1='') then
           begin
             //look at XQAID
                //ShowMessage(Data1);
                notifytype := Piece(Data1,';',1) ;
                notifytype := Piece(notifytype,',',3);
                if notifytype = Piece(ListCritAlertCategories[I],'^',2) then deletealert:= 'No Delete';
           end;
           ListCritAlertCategories[I] := Piece(ListCritAlertCategories[I],'^',1) ;
       end
       else
       begin
           ListCritAlertCategories[I] := Piece(ListCritAlertCategories[I],'^',1) ;
       end;
     end;
     if not (Piece(Param2,'Single',2)='') then
       begin
         if deletealert ='' then
         begin
              ListCritAlertCategories.Free;
              //FmBroker.Connected := False;
              //FmBroker.Free;
              //FmBroker := nil;
              //ShowMessage('No Delete True');
              Result := True;
              Exit;
         end;
       end;
     FATForm := TFATForm.Create(Application);
     FATFormS := TFATFormS.Create(Application);
     //FATFormReturn := ShowFATForm(CPRSBroker,CPRSState);
     //FmBroker.Connected := False;
     //FmBroker.Free  ;
     //FmBroker := nil;
     //EXIT;
    //FATForm.lstvAlerts.Clear;
   /// lstvAlerts1.Items.Clear;

    List := TStringList.Create;


     NewItem := nil;
    // Showmessage('before Load Notifications.');
  try
    LoadNotifications(List,CPRSBroker,CPRSState);
    { FatForm.lstvAlerts.Columns.Add;
     FatForm.lstvAlerts.Columns.Items[0].Caption :='Info' ;
     FatForm.lstvAlerts.Columns.Add;
     FatForm.lstvAlerts.Columns.Items[1].Caption :='Patient' ;
     FatForm.lstvAlerts.Columns.Add;
     FatForm.lstvAlerts.Columns.Items[2].Caption :='Location' ;
     FatForm.lstvAlerts.Columns.Add;
     FatForm.lstvAlerts.Columns.Items[3].Caption :='Urgency' ;
     FatForm.lstvAlerts.Columns.Add;
     FatForm.lstvAlerts.Columns.Items[4].Caption :='Alert Date/Time' ;
     FatForm.lstvAlerts.Columns.Add;
     FatForm.lstvAlerts.Columns.Items[5].Caption :='Comment' ;  }
     colSizes := '';
     K := 0 ;
     firstflag := '0' ;
     KFIRST:= -1;
     asterisks := 0;
     asterisks_first:= 0 ; //firstline with orders needing signing 0 or 1
     for I := 0 to List.Count - 1 do
       begin
    //   List[i] := ConvertDate(List, i);  //cla commented out 8/9/04 CQ #4749

        //ShowMessage(List[I]);

          if Piece(List[I], U, 1) <> 'Forwarded by: ' then
           begin
               //ShowMessage(List[I]) ;
//              NewItem := FATForm.lstvAlerts.Items.Add;
//              ShowMessage('here2') ;
              tmpstr := Piece(List[I], U, 8);
              tmptyp := Piece(tmpstr,',',1) ;  // "OR" OR "TIU"
              tmpi := Piece(List[I], U, 1) ;  //  I FOR INFO for aceepable crit unacknow with crit lab value
              tmpstr := Piece(tmpstr, ',',2);
              //ShowMessage('tmptyp: '+ tmptyp + ' pDFN: ' + CPRSState.PatientDFN);
              if (tmpstr = CPRSState.PatientDFN) AND (tmptyp = 'OR') then
              begin
               // ShowMessage('Show666') ;
               //FOR CRITICAL LAB ALERTS
               { if (firstflag='0')and (tmpi ='I') then
                begin
                firstflag := Piece(List[I], U, 6);
                for JJ := 1 to DelimCount(firstflag,' ')+1 do
                begin
                   strtmp1 :=Piece(firstflag,' ',JJ) ; //ie. Critical Lab: PSA or Critical Lab: OCC BLD
                   if Piece(strtmp1,'/',2)>'' then   //see date
                   begin
                   //Determine Critical lab: name positions ;
                   JK :=JJ-2    ;
                   ////firstflag := Piece(firstflag,' ',1,JK);     NO FIRST CRITICAL ALERTS FOR "I" TYPE
                   ////KFIRST := K ;  //LINE # FOR 1 ST CRIT
                   end;
                end;
                //ShowMessage('firstflag='+firstflag);
                end; }
                //FOR ALERTS BELOW
                 if (firstflag='0')and NOT (tmpi ='I') then
                begin
                //ShowMessage(List[I]) ;
                firstflagt := Piece(List[I], U, 6);
                for JJ := 1 to DelimCount(firstflag,' ')+1 do
                begin
                   strtmp1 :=Piece(firstflag,' ',JJ) ; //ie. Critical Lab: PSA or Critical Lab: OCC BLD
                   if Piece(strtmp1,'/',2)>'' then   //see date
                   begin
                   //Determine Critical lab: name positions ;
                   JK :=JJ-2    ;
                   //firstflag := Piece(firstflag,' ',1,JK);
                   //KFIRST := K ;  //LINE # FOR 1 ST CRIT
                   end;
                end;
                   KFIRST:= K;
                  //SET FIRST FLAG to ATTN: CHEST 2V etc. or here "CHEST 2 V" or [PROSTATE SPECIFIC ANITGEN"]  or "[OCCULT BLOOD]"
                  //ShowMessage(List[I]) ;
                  for class1 := 0 to ListCritAlertCategories.Count - 1 do
                  begin
                  ////ShowMessage('firstflag in class ='+firstflag);
                  if (firstflag ='0')then
                  begin
                  firstflag1 :=ListCritAlertCategories[class1]   ;
                  firstflagcc := firstflag1 ;
                  ////firstflag :='Attn: ' + Piece(firstflag,'Attn: ',2) ;
                  firstflag2 := Piece(firstflagt,firstflag1+ ' ',2); //specific alert type in a class
                  ////ShowMessage('firstflag2='+ firstflag2);
                  firstflag := firstflag1 + Piece(firstflagt,firstflag1+ ' ',2) ;
                  //check if VEFA Tracking Alerts record entry found   (specific alert type in a class)
                  returnclass :='0' ;
                  if (not (firstflag = firstflag1)) and (Piece(firstflagt,firstflag1+ ' ',2)>'') then
                  begin
                  ////ShowMessage('hereclass');
                  returnclass := CKAlertType(CPRSBroker,CPRSState,firstflag2,firstflagcc);
                  ////ShowMessage('hereclass1');
                  end;
                  //if firstflag= 'Attn: ' then
                  ////ShowMessage('firstflag='+ firstflag +' firstflag1=' + firstflag1 +' returnclass=' + returnclass);
                  if (firstflag = firstflag1) OR (returnclass = '0') then
                  begin
                  ////ShowMessage('out');
                   firstflag:='0' ; //'0'
                   KFIRST:=-1 ;
                   //ShowMessage(List[I]);
                  end
                  else
                  begin
                  firstflag := firstflag2 ;
                  KFIRST := K ;
                  end;
                  end;
                  end;
                  // ShowMessage('firstflag='+firstflag+ ' k=' + inttostr(K)+ ' KFIRST='+inttostr(KFIRST));
                  //ShowMessage('firstflag='+firstflag);
                end;
                ////ShowMessage('Continue') ;
                {if (tmpi ='I') then     //check for abnormal Critical lab
                begin
                valueflag := Piece(List[I], U, 6);
                for JJ := 1 to DelimCount(valueflag,' ')+1 do
                begin
                   strtmp1 :=Piece(valueflag,' ',JJ) ; //ie. Critical Lab: PSA or Critical Lab: OCC BLD
                   if Piece(strtmp1,'/',2)>'' then   //see date
                   begin
                   //Determine Critical lab: name positions ;
                   JK :=JJ-2    ;
                   valueflag := Piece(valueflag,' ',1,JK);

                   end;
                end;
                end; }
                valueflag1:= '' ;
                if not (tmpi ='I') then   //check for abnormal images
                begin
               { valueflag1 := Piece(List[I], U, 6);
                for JJ := 1 to DelimCount(valueflag1,' ')+1 do
                begin
                   strtmp1 :=Piece(valueflag1,' ',JJ) ; //ie. Critical IMAGE as ......Attn: CHEST 2 V
                   if Piece(strtmp1,'/',2)>'' then   //see date
                   begin
                   //Determine Abnl Imaging Reslt, Needs Attn: name positions ;
                   JK :=JJ-2    ;
                   valueflag1 := Piece(valueflag1,' ',1,JK);

                   end;
                end;  }
                ////valueflag1 :='Attn: ' + Piece(valueflag1,'Attn: ',2) ;

                firstflagt := Piece(List[I], U, 6);
                valueflag1 := '' ;
                for class1 := 0 to ListCritAlertCategories.Count - 1 do
                  begin
                  if valueflag1= '' then
                  begin

                  firstflag1 :=ListCritAlertCategories[class1]   ;
                  firstflagc := firstflag1 ;
                  ////firstflag :='Attn: ' + Piece(firstflag,'Attn: ',2) ;
                  firstflag2 := Piece(firstflagt,firstflag1+ ' ',2); //specific alert type in a class
                  ////ShowMessage('firstflag2='+ firstflag2);
                  valueflag1 := firstflag1 + Piece(firstflagt,firstflag1+ ' ',2) ;
                  //check if VEFA Tracking Alerts record entry found   (specific alert type in a class)
                  returnclass :='0' ;
                  if (not (valueflag1 = firstflag1)) and (Piece(firstflagt,firstflag1+ ' ',2)>'') then
                  begin
                  ////ShowMessage('hereclass');
                  returnclass := CKAlertType(CPRSBroker,CPRSState,firstflag2,firstflagc);
                  ////ShowMessage('hereclass1');
                  end;
                  //if firstflag= 'Attn: ' then
                  ////ShowMessage('firstflag='+ firstflag +' firstflag1=' + firstflag1 +' returnclass=' + returnclass);
                  if (valueflag1 = firstflag1) OR (returnclass = '0') then
                  begin
                  ////ShowMessage('out');
                  //// firstflag:='0' ; //'0'
                  valueflag1:='' ; //
                  //// KFIRST:=-1 ;
                   //ShowMessage(List[I]);
                  end
                  else
                  begin
                  valueflag1 := firstflag2 ;

                  end;  // end begin end else
                  end; // end valueflag1
                  ////ShowMessage('valueflag1=' + valueflag1);
                  end;  //end class







                //ShowMessage(valueflag1);
                end;    // not (tmpi ='I')
              kindcrit := Piece(List[I], U, 6);
              //imaging alerts next
              ////if (Piece(kindcrit,'Attn: ',2)>'') and (tmpi='I') then goto OVER5; // Skip [crit imaging alert
              ////if (Piece(kindcrit,'Attn: ',2)>'') and NOT(tmpi ='I') then goto OVER4;  //Keep print name crit imaging alert

               if (valueflag1>'') and (tmpi='I') then goto OVER5;
               if (valueflag1>'') and NOT(tmpi ='I') then goto OVER4;
              //critical labs next
             { if (Piece(kindcrit,'Critical lab',2)>'') and (tmpi='I') then goto OVER4;  //Keep print name CRIT ALERT LAB W ALERT VALUE
              if (Piece(kindcrit,'Critical lab',2)>'') and NOT(tmpi ='I') then goto OVER5;  // Skip [crit aLERT CRIT LAB] w/o alert value
              }
              goto OVER5;

 OVER4:         //NewItem := FATForm.lstvAlerts.Items.Add;
                //NewItem.Caption := Piece(List[I], U, 1);
                //
                //valueflagu is valueflag to use ( image alert or critical lab alert)
                //image alert first
                ////if (Piece(kindcrit,'Attn: ',2)>'') and NOT(tmpi ='I') then  valueflagu := valueflag1 ;
                ////if (Piece(kindcrit,'Attn: ',2)>'') and NOT(tmpi ='I') then  valueflagu := Piece(valueflag1,'Attn: ',2) ;
                if (valueflag1>'') and NOT(tmpi ='I') then  valueflagu := valueflag1 ;
                //next critical lab
                ////if (Piece(kindcrit,'Critical lab',2)>'') and (tmpi='I') then valueflagu := valueflag ;
                //ShowMessage(valueflagu);
                ////alerttype := Piece(valueflagu,'Critical lab: ',2) ;
                DateTime := Piece(List[I], U, 8) ;
                DateTime := Piece(DateTime,';',3) ;
                //ShowMessage(DateTime);
                //ShowMessage('valueflagu='+ valueflagu);
                recallAlertsReturn := CKAlert(CPRSBroker,CPRSState,valueflagu,DateTime);
                //ShowMessage(recallAlertsReturn);
                //if  Piece(recallAlertsReturn,'^',1)='0' then
                if  recallAlertsReturn[1]='0' then
                begin
                NewItem := FATForm.lstvAlerts.Items.Add;
                ////ShowMessage('Return='+  recallAlertsReturn) ;
                //critical lab next
                ////if (Piece(kindcrit,'Critical lab',2)>'') and (tmpi='I') then if Piece(List[I], U, 1)= 'I' then NewItem.Caption := Piece(valueflag,'Critical lab: ',2) ;
                //imaging alert below
                ////if (Piece(kindcrit,'Attn: ',2)>'') and NOT(tmpi ='I') then  if NOT (Piece(List[I], U, 1)= 'I') then NewItem.Caption := Piece(valueflag1,'Attn: ',2) ;
                if (valueflag1>'') and NOT(tmpi ='I') then  if NOT (Piece(List[I], U, 1)= 'I') then NewItem.Caption := valueflag1 ;
                if not (Piece(Param2,'Single',2)='') then    //deletealert='No Delete True' possible
                  begin
                   //set  ackalertflag = valueflag1
                       if Piece(List[I],'^',8)=Data1 then
                       begin
                              //ShowMessage(Data1);
                              //ShowMessage(List[I]) ;
                              Data2 := 'No Delete' ;

                       end;
                  end;
                //ShowMessage('x=' +  recallAlertsReturn);
                if recallAlertsReturn[3] = '3' then
                begin
                  //critical lab below
                 //// if (Piece(kindcrit,'Critical lab',2)>'') and (tmpi='I') then NewItem.Caption := '* ' + Piece(valueflag,'Critical lab: ',2) ;
                  //imaging alert below
                  ////if (Piece(kindcrit,'Attn: ',2)>'') and NOT(tmpi ='I') then   NewItem.Caption := '* ' + Piece(valueflag1,'Attn: ',2) ;
                  if (valueflag1>'') and NOT(tmpi ='I') then  if NOT (Piece(List[I], U, 1)= 'I') then NewItem.Caption := '* ' + valueflag1 ;
                  asterisks:= 1;
                  if KFIRST=K then
                    begin
                      asterisks_first:= 1;
                    end;
                end;
                for J := 2 to DelimCount(List[I], U) + 1 do
                  //NewItem.Owner.Add;
                  NewItem.SubItems.Add(Piece(List[I], U, J));
                if KFIRST=K then
                begin
                     NewItem.Selected := True;
                     //FATForm.lstvAlerts.Items[K].Selected := True;
                     NewItem.Focused := True;
                     NewItem.Selected := True;
                     NewItem.Focused := True;    //SetPosition();
                     for JKK := 2 to DelimCount(List[I], U) + 1 do
                       begin
                      // ShowMessage('now here');
                      // NewItem.Owner.Item[JKK-2].Selected := true ; // . Selected := True ;// Item.  listview.Selected.Owner.Item[JKK].Selected := True ; // = True; //  Owner.Item[JKK].Selected := True;  // Item[JKK].Index;
                       end;
                       // Showmessage('thru') ;
                end;
                K := K +1 ;
                 //ShowMessage('here3')
                end
                else
                begin
                    //ShowMessage('firstflag='+firstflag+ ' k=' + inttostr(KFIRST));
                     if KFIRST=K then
                     begin
                        KFIRST:= -1   ;
                        firstflag := '0'     ;
                        //ShowMessage('firstflagsss='+firstflag);
                        asterisks_first := 0 ;

                     end;
                end;

 OVER5:
              end;
           end
         else   //this list item is forwarding information
           begin
             //ShowMessage('else condition');
             //if NewItem<> nil then ShowMessage('Here0 I='+ IntToStr(I));
             if NewItem<> nil then NewItem.SubItems[5] := Piece(List[I], U, 2);
             Comment := Piece(List[I], U, 3);
             //ShowMessage('Here1');
             if NewItem<> nil then if Length(Comment) > 0 then NewItem.SubItems[8] := 'Fwd Comment: ' + Comment;
             //ShowMessage('Here2');
           end;
           //FATForm.lstvAlerts.Items.AddItem(NewItem,I);
           //K := K +1 ;
       end;
   finally
      List.Free;
   end;
   if Data2 = 'No Delete' then
   begin
      ListCritAlertCategories.Free;
      //FmBroker.Connected := False;
      //FmBroker.Free;
      //FmBroker := nil;
      FATForm.Free;
      FATFormS.Free;
      //ShowMessage('No Delete True');
      Result := True;
      Exit;
   end;
   with FATForm.lstvAlerts do
     begin
//        ShowMessage('here11');
        //colSizes := SizeHolder.GetSize(StrFPtSel_lstvAlerts_Co);
        colSizes :='' ;
//        ShowMessage('here22');
        if colSizes = '' then begin
          Columns[0].Width := 240;  //80        //Info                 Caption
          Columns[1].Width := 195;         //Patient              SubItems[0]
          Columns[2].Width := 75;          //Location             SubItems[1]
          Columns[3].Width := 95;          //Urgency              SubItems[2]
          Columns[4].Width := 150;         //Alert Date/Time      SubItems[3]
          Columns[5].Width := 310;         //Message Text         SubItems[4]
          Columns[6].Width := 290;         //Forwarded By/When    SubItems[5]
        end else begin
          Columns[0].Width := StrToInt(piece(colSizes,',',1));          //Info                 Caption
          Columns[1].Width := StrToInt(piece(colSizes,',',2));         //Patient              SubItems[0]
          Columns[2].Width := StrToInt(piece(colSizes,',',3));          //Location             SubItems[1]
          Columns[3].Width := StrToInt(piece(colSizes,',',4));          //Urgency              SubItems[2]
          Columns[4].Width := StrToInt(piece(colSizes,',',5));         //Alert Date/Time      SubItems[3]
          Columns[5].Width := StrToInt(piece(colSizes,',',6));         //Message Text         SubItems[4]
          Columns[6].Width := StrToInt(piece(colSizes,',',7));         //Forwarded By/When    SubItems[5]
        end;

     //Items not displayed in Columns:     XQAID                SubItems[6]
     //                                    Remove w/o process   SubItems[7]
     //                                    Forwarding comments  SubItems[8]
     end;
  //with lstvAlerts do      ca comment out 12/24/03 to prevent default selection of first alert on list
    //if (ItemIndex = -1) and (Items.Count > 0) then
      //ItemIndex := 0;


//      Showmessage('before FmGets4.');

        //goto OVER9 ;
        //PREVIOUS SECTION ON GETTING REMINDER DIALOG AND TIUTEMPLATE HERE

         //
         // NEW CODE HERE TO CALCULATE SPECIFIC CRITICAL ALERT'S REMINDER DIALOG AND TIU TEMPLATE
         //
         //
OVER9:    //
         if (K = 0) OR (firstflag = '0') then
          begin
          Result := False;
          goto OVER6; //no entries found  or no firstflag critical lab
          end;

         returnData := GetAlertData(CPRSBroker,CPRSState,firstflag);
         if not (returnData = '') then
         begin
           IEN := Piece(returnData,'^',1) ;
           ReminderDialog := Piece(returnData,'^',2) ;
           TIUTemplate := Piece(returnData,'^',3) ;
           //ShowMessage( 'dialog text: ' + ReminderDialog +  ' template text: ' + TIUTemplate ) ;
         end
         else
         begin
          FATForm.Free;
          FATFormS.Free;
          Result := False;
          goto OVER6 ; //Exit;
         end;
         //end new code
         //

         //previous orderdlglist orders code here

        SetLength(FATForm.ordercheckboxes, 10);
        //OrdersCount:= orderdlglist.Results.Count;
        ListCritAlertOrders :=  TStringList.Create;
        LoadAlertsOrdersDoc(ListCritAlertOrders,CPRSBroker,CPRSState,IEN);
        OrdersCount:= ListCritAlertOrders.Count  ;
        //ShowMessage( inttostr(ListCritAlertOrders.Count)) ;
        for i:=0 to OrdersCount-1 do begin
          FATForm.ordercheckboxes[i]:=TCheckBox.Create(FATForm);
          FATForm.ordercheckboxes[i].parent:=FATForm;
          FATForm.ordercheckboxes[i].Left:=99;     // 64
          FATForm.ordercheckboxes[i].Top:=23*i+283;
          FATForm.ordercheckboxes[i].Width:=250;     // 64
          FATForm.ordercheckboxes[i]. Enabled := False;
          //FATForm.ordercheckboxes[i].Font.Style[fsBold] := True;
          FATForm.ordercheckboxes[i].Font.Size := 10;
          //IENfind := orderdlglist.Results.Strings[i];
          //MyRecordObj := orderdlglist.GetRecord(IENfind);
          //MyFieldObj := MyRecordObj.GetField('.01');
          //FATForm.ordercheckboxes[i].Caption := MyFieldObj.FMDBExternal;
           FATForm.ordercheckboxes[i].Caption :=  ListCritAlertOrders[i] ;
        end;
        ListCritAlertOrders.Free ;
        //previous orderdlglist followups code here

        SetLength(FATForm.followupcheckboxes, 10);
        ListCritAlertFollowups :=  TStringList.Create;
        LoadAlertsFollowupsDoc(ListCritAlertFollowups,CPRSBroker,CPRSState,IEN);
        FollowupCount:= ListCritAlertFollowups.Count  ;
        //FollowupCount:= orderdlglist.Results.Count;
        for i:=0 to FollowupCount-1 do begin
          FATForm.followupcheckboxes[i]:=TCheckBox.Create(FATForm);
          FATForm.followupcheckboxes[i].parent:=FATForm;
          FATForm.followupcheckboxes[i].Left:=99;     // 64
          FATForm.followupcheckboxes[i].Top:=23*i+467;
          FATForm.followupcheckboxes[i].Width:=250;     // 64
          FATForm.followupcheckboxes[i].Enabled := False;
          //FATForm.followupcheckboxes[i].Font.Style[fsBold] := True;
          FATForm.followupcheckboxes[i].Font.Size := 10;
          //IENfind := orderdlglist.Results.Strings[i];
          //MyRecordObj := orderdlglist.GetRecord(IENfind);
          //MyFieldObj := MyRecordObj.GetField('.01');
          //FATForm.followupcheckboxes[i].Caption := MyFieldObj.FMDBExternal;
          FATForm.followupcheckboxes[i].Caption :=  ListCritAlertFollowups[i] ;
        end;
        //Fatform.CommentMemo.Enabled := False;
        ListCritAlertFollowups.Free ;

        FATform.PatientName.Caption := CPRSState.PatientName;
        FATform.PatientNo.Caption := CPRSState.PatientDFN;
        FATFormS.PatientName.Caption := CPRSState.PatientName;
        //FATFormS.PatientNo.Caption := CPRSState.PatientDFN;
        FATform.Age.Caption := CPRSState.PatientDOB;
        FATForm.Phone.Caption := '713-555-5555';
        //
        ////if NOT (Piece(firstflag,'Attn: ',2)='') then
        if NOT (Piece(firstflag,'Attn: ',2)='') then
        begin

        FatForm.CriticalLabname.Caption := firstflagcc + ' ' + firstflag;
        FATFormS.Label2.Caption := firstflagcc + ' ' + firstflag;   // 'Abnl Imaging Reslt, Needs Attn: '+ Piece(firstflag,'Attn: ',2) ;
        end
        else
        begin
         FatForm.CriticalLabname.Caption := firstflagcc + ' ' + firstflag;   //firstflag;
         FATFormS.Label2.Caption := firstflagcc + ' ' + firstflag; //firstflag;
        end;
       //result1 := CPRSBroker.SetContext('VEFAALRE');
       //recallAlertsReturn := recallAlerts(CPRSBroker,CPRSState);
       FATForm.ReminderInstructions.Caption := FATForm.ReminderInstructions.Caption + '"'+ Piece(TIUTemplate,'VEFA ',2) + '" Reminder Dialog '  ;  //and ' +  '"' + ReminderDialog + '" Reminder Dialog ' ;
       FATFormS.ReminderInstructions.Caption := FATFormS.ReminderInstructions.Caption + '"'+ Piece(TIUTemplate,'VEFA ',2) + '" Reminder Dialog '  ; // and ' +  '"' + ReminderDialog + '" Reminder Dialog ' ;
       FATForm.AlertLabel.Caption := FATForm.AlertLabel.Caption + '"'+ Piece(TIUTemplate,'VEFA ',1,2) + '"). To access the correct note template, click "Address Now" below.'  ;  //and ' +  '"' + ReminderDialog + '" Reminder Dialog ' ;
       FATFormS.AlertLabel.Caption := FATFormS.AlertLabel.Caption + '"'+ Piece(TIUTemplate,'VEFA ',1,2) + '"). To access the correct note template, click "Address Now" below.'  ; // and ' +  '"' + ReminderDialog + '" Reminder Dialog ' ;
       //ShowMessage( inttostr(asterisks_first)) ;
       if asterisks_first= 1 then
       begin
            //FATForm.ReminderInstructions.Visible := False;
            FATForm.ReminderInstructions.Caption := FATForm.Label9.Caption;
            //FATForm.Label9.Visible := True;
            FATFormS.ReminderInstructions.Visible := True; //False;
            FATFormS.AlertLabel.Caption := '                                                                                                                                                          This patient has a Critical Alert but no completed Follow-up Actions were found in the Patient Chart.' ;
            // have not yet been completed.' ; Visible:= False;
            FATFormS.ReminderInstructions.Caption := FATFormS.Label9.Caption;
            FATFormS.NoteTitle.Visible := False;
       end
       else
       begin
            //FATForm.ReminderInstructions.Visible := False;
            //FATForm.Label9.Visible := True;
       end;

       if asterisks = 1 then
       begin
       FATForm.Label8.Caption := '* with unsigned/uncompleted order(s)'  ;
       FATForm.Label8.Visible := True;
       end
       else
       begin
       FATForm.Label8.Caption := ''  ;
       FATForm.Label8.Visible := False;
       end;
       if FormTake=0 then
       begin
            If data1='' then
            begin
            FATFormReturn := ShowFATFormS(CPRSBroker,CPRSState);
            end
            else
            begin
                     FATFormS.Free;
                     FATForm.Free;
            end;
            FATFormS := nil;
            FATForm := nil;
       end;
     if not (FormTake=0) then
       begin
            if data1='' then
            begin
                   FATFormReturn := ShowFATForm(CPRSBroker,CPRSState);
            end
            else
            begin
              FATForm.Free;
              FATFormS.Free;
            end;
            FATForm := nil;
            FATFormS := nil;
       end;
       if FATFormReturn = 1  then
       begin
       //ShowMessage ('here33') ;
       Data1 := ReminderDialog + '^' +TIUTemplate ;
       Data2 := 'Yes, skip Patient Select' ;
       if (asterisks_first = 1 ) then Data2 := 'O Yes, skip Patient Select, but go to Orders Tab to complete/sign orders'      ;
       end;
       //Showmessage( 'dialog text: ');
       //orderdlglist.Free;
       //orderdlglist := nil;
       Result := True;
OVER6:  //FmBroker.Connected := False;
       //FmBroker.Free;
       //FmBroker := nil;
       ListCritAlertCategories.Free;

      { for I := 0 to 5 - 1 do
       begin
         FATForm.ordercheckboxes[I].Free;
         FATForm.followupcheckboxes[I].Free;
       end;  }

       Exit ;
       //////end of logic here


end;
 procedure Twrite4comobject.Free();
 begin
      FreeMem(DateTimeA);
      //T1.Free;
      //T2.Free;
      //TControl1.Free;
      //FmGets1.free;

 end;
procedure Twrite4comobject.AppMessage(var Msg:tagMSG; var Handled: Boolean);
begin
  if Msg.message = 258 then   //WM_CHAR
  begin
  //
  //  Application.MessageBox(
  //      'get text Message found',
  //      'Get Text ',
  //      MB_OKCANCEL);
    Handled := True;

  end;

  { for all other messages, Handled remains False }
  { so that other message handlers can respond }
end;

procedure LoadNotifications(Dest: TStrings;const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState);
var
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
//   Showmessage('Before Load Notifications.');
  try
    //UpdateUnsignedOrderAlerts(Patient.DFN);      //moved to AFTER signature and DC actions
    tCallV(CPRSBroker,CPRSState,tmplst,'ORWORB FASTUSER',[nil]);
    Dest.Assign(tmplst);
  finally
    tmplst.Free;
  end;
//   Showmessage('After Load Notifications.');
end;

procedure LoadCritAlerts1(Dest: TStrings;const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState);
var
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
//   Showmessage('Before Load Notifications.');
  try
    //UpdateUnsignedOrderAlerts(Patient.DFN);      //moved to AFTER signature and DC actions
    tCallV(CPRSBroker,CPRSState,tmplst,'VEFAALERTCAT',[nil]);
    Dest.Assign(tmplst);
  finally
    tmplst.Free;
  end;
//   Showmessage('After Load Notifications.');
end;

procedure tCallV(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState;ReturnData: TStrings; const RPCName: string; const AParam: array of const);
{ calls the broker and returns TStrings data }
var
 // SavedCursor: TCursor;
  strings: TStringList;
  ref : Boolean ;
begin

  ref:= False;
  //Showmessage('Before Call Context: ' + RPCNAME);
  ref:= CPRSbroker.SetContext('VEFAALRE');
  //Showmessage('After Call Context: ' + RPCNAME);
  If ref then  //CPRSbroker.SetContext('VEFAALRE') then //checks for access to RPCs
     begin
           //SavedCursor := Screen.Cursor;
           //Screen.Cursor := GetRPCCursor;
           //SetParams(RPCName, AParam);
           //CallBroker;  //RPCBrokerV.Call;
           strings := TStringList.Create;
           if ReturnData = nil then raise Exception.Create('TString not created');
             {ShowMessage('context changed' );  }
           CPRSBroker.ClearParameters := True;
           CPRSBroker.ClearResults := True;

           //SetParams(CPRSBroker,RPCName, AParam);

           //CPRSBroker.ParamType[0] := bptlist;
           //CPRSBroker.Param[0] := '0';
           //CPRSBroker.Param[0]:= CPRSState.PatientDFN + '^' + CPRSState.UserDUZ + '^'+ 'PROSTATE';
           //  Showmessage('Paramtype: ' + CPRSBroker.ParamType[0] + ' Param:' + CPRSBroker.Param[0]);
//           Showmessage('Before CallRPC: ' + RPCNAME);

           CPRSBroker.CallRPC(RPCNAME) ;//RPCNAME);//CPRSBroker.CallRPC('VEFAALRE') ;//RPCNAME);
//           Showmessage('After CallRPC');
           {ShowMessage('Result of RPC1 call:' + CPRSBroker.Results[1]);}

           strings.Text := CPRSBroker.Results;
//           Showmessage('Before FastAssign.');
           FastAssign(strings, ReturnData);
           strings.Free;
           //Screen.Cursor := SavedCursor;
     end
     else
	            ShowMessage('Error, user is not assigned the RPC Context option VEFAALRE');
end;



procedure SetParams(const CPRSBroker: ICPRSBroker; const RPCName: string; const AParam: array of const);
{ takes the params (array of const) passed to xCallV and sets them into RPCBrokerV.Param[i] }
const
  BoolChar: array[boolean] of char = ('0', '1');
var
  i: integer;
  TmpExt: Extended;
  nnString:String;
begin
  //RPCLastCall := RPCName + ' (SetParam begin)';
  //if Length(RPCName) = 0 then raise Exception.Create('No RPC Name');
  //EnsureBroker;
  with CPRSBroker do
  begin
    //ClearParameters := True;
    //RemoteProcedure := RPCName;
    for i := 0 to High(AParam) do with AParam[i] do
    begin
      ParamType[i] := bptliteral;
      case VType of
      vtInteger:    Param[i] := IntToStr(VInteger);
      vtBoolean:    Param[i]:= BoolChar[VBoolean];
      vtChar:       if VChar = #0 then
                      Param[i] := ''
                    else
                      Param[i] := VChar;
      //vtExtended:   Param[i].Value := FloatToStr(VExtended^);
      vtExtended:   begin
                      TmpExt := VExtended^;
                      if(abs(TmpExt) < 0.0000000000001) then TmpExt := 0;
                      Param[i] := FloatToStr(TmpExt);
                    end;
      vtString:     with CPRSBroker do
                    begin
                      Param[i] := VString^;
                      if (Length(Param[i]) > 0) and (Param[1] = #1) then
                      begin
                        Param[i] := Copy(Param[i], 2, Length(Param[i]));
                        ParamType[i] := bptreference;
                      end;
                    end;
      vtPChar:      Param[i] := StrPas(VPChar);
      vtPointer:    if VPointer = nil
                      then ClearParameters := True {CPRSBroker.ParamType[i] or RPCbroker.Param[i].PType := null}
                      else raise Exception.Create('Pointer type must be nil.');
      vtObject:     if VObject is TStrings then SetList(CPRSBroker,TStrings(VObject), i);
      vtAnsiString: with CPRSBroker do
                    begin
                      Param[i] := string(VAnsiString);
                      nnString := Param[i] ;
                      if (Length(Param[i]) > 0) and (nnString[1] = #1) then
                      begin
                        Param[i] := Copy(param[i], 2, Length(Param[i]));
                        ParamType[i] := bptreference;
                      end;
                    end;
      vtInt64:      Param[i] := IntToStr(VInt64^);
        else raise Exception.Create('Unable to pass parameter type to Broker.');
      end; {case}
    end; {for}
    ShowMessage('param[0]=' + Param[0]) ;
  end; {with}
  //RPCLastCall := RPCName + ' (SetParam end)';

end;

procedure SetList(const CPRSBroker: ICPRSBroker; AStringList: TStrings; ParamIndex: Integer);
{ places TStrings into RPCBrokerV.Mult[n], where n is a 1-based (not 0-based) index }
var
  i: Integer;
  ssWideString :WideString;
  sOneString :String;
begin
  with CPRSBroker do
 begin
  with CPRSBroker do
  begin
    ParamType[ParamIndex] := bptlist;

    with AStringList do for i := 0 to Count - 1 do
       begin
       sOneString := AStringList.Strings[i] ;
       ssWideString := sOneString;
       CPRSBroker.ParamList[ParamIndex,IntToStr(i)] := ssWideString;
          //Mult[IntToStr(i+1)] := Strings[i];
       end;
  end;
 end;
end;

procedure FastAssign(source, destination: TStrings);
// do not use this with RichEdit Lines unless source is RichEdit with PlainText
var
  ms: TMemoryStream;
begin
  destination.Clear;
  if (source is TStringList) and (destination is TStringList) then
    destination.Assign(source)
  else
  if (CompareText(source.ClassName, 'TRichEditStrings') = 0) then
    destination.Assign(source)
  else
  begin
    ms := TMemoryStream.Create;
    try
      source.SaveToStream(ms);
      ms.Seek(0, soFromBeginning);
      destination.LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;
end;



function ShowFATForm(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState) : Integer;
var
    iResult,I: Integer      ;
    //FATForm: TFATForm;
//  frmSystemModal: TfrmSystemModal;
begin
  //FATForm := TFATForm.Create(Application);
  with FATForm do
    try
      {...}

//      DisableWindows;
      iResult := ShowModal;
      //Showmessage( 'return fatform dialog text: ');
//      EnableWindows;
    finally
    if ModalResult = mrCancel then Result:= 0;
    if ModalResult = mrOk then Result:= 1;

    for I := 0 to OrdersCount - 1 do
       begin
         FATForm.ordercheckboxes[I].Free;

       end;
    for I := 0 to FollowupCount - 1 do
       begin

         FATForm.followupcheckboxes[I].Free;
       end;
      Free;
      FATFormS.Free;
      //Showmessage( 'free fatform dialog text: ');
    end;
end;

function ShowFATFormS(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState) : Integer;
var
    iResult,I: Integer      ;
    //FATFormS: TFATFormS;
//  frmSystemModal: TfrmSystemModal;
begin
  //FATFormS := TFATFormS.Create(Application);
  with FATFormS do
    try
      {...}

//      DisableWindows;
      iResult := ShowModal;
      //Showmessage( 'return fatform dialog text: ');
//      EnableWindows;
    finally
    if ModalResult = mrCancel then Result:= 0;
    if ModalResult = mrOk then Result:= 1;


      Free;
      FATForm.Free;
      //Showmessage( 'free fatform dialog text: ');
    end;
end;

procedure tCallV1(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState;ReturnData: TStrings; const RPCName: string; Param1: String);
{ calls the broker and returns TStrings data }
var
 // SavedCursor: TCursor;
  strings: TStringList;
  ref : Boolean ;
begin

  ref:= False;
  ref:= CPRSbroker.SetContext('VEFAALRE');
  If ref then  //CPRSbroker.SetContext('VEFAALRE') then //checks for access to RPCs
     begin
           //SavedCursor := Screen.Cursor;
           //Screen.Cursor := GetRPCCursor;
           //SetParams(RPCName, AParam);
           //CallBroker;  //RPCBrokerV.Call;
           strings := TStringList.Create;
           if ReturnData = nil then raise Exception.Create('TString not created');
             {ShowMessage('context changed' );  }

           //SetParams(CPRSBroker,RPCName, AParam);
           CPRSBroker.ClearParameters := True;
           CPRSBroker.ClearResults := True;
           CPRSBroker.ParamType[0] := 0 ;
           CPRSBroker.Param[0]:= Param1 ;
           //CPRSBroker.Param[0] := '0';
           //CPRSBroker.Param[0]:= CPRSState.PatientDFN + '^' + CPRSState.UserDUZ + '^'+ 'PROSTATE';
           //  Showmessage('Paramtype: ' + CPRSBroker.ParamType[0] + ' Param:' + CPRSBroker.Param[0]);
           //Showmessage('Before CallRPC: ' + RPCNAME);

           CPRSBroker.CallRPC(RPCName) ;//RPCNAME);//CPRSBroker.CallRPC('VEFAALRE') ;//RPCNAME);
           //Showmessage('After CallRPC');
           {ShowMessage('Result of RPC1 call:' + CPRSBroker.Results[1]);}

           strings.Text := CPRSBroker.Results;
//           Showmessage('Before FastAssign.');
           FastAssign(strings, ReturnData);
           //ShowMessage(ReturnData[0]);
           strings.Free;
           //Screen.Cursor := SavedCursor;
     end
     else
	            ShowMessage('Error, user is not assigned the RPC context option VEFAALRE');
end;
procedure LoadAlertsOrdersDoc(Dest: TStrings;const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState;Param1 : String);
var
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
//   Showmessage('Before Load Notifications.');
  try
    //UpdateUnsignedOrderAlerts(Patient.DFN);      //moved to AFTER signature and DC actions
    tCallV1(CPRSBroker,CPRSState,tmplst,'VEFA ALERT DOC ORDERS',Param1);
    //Showmessage('here');
    Dest.Assign(tmplst);
  finally
    tmplst.Free;
  end;
//   Showmessage('After Load Notifications.');
end;


procedure LoadAlertsFollowupsDoc(Dest: TStrings;const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState;Param1 : String);
var
  tmplst: TStringList;
begin
  tmplst := TStringList.Create;
//   Showmessage('Before Load Notifications.');
  try
    //UpdateUnsignedOrderAlerts(Patient.DFN);      //moved to AFTER signature and DC actions
    tCallV1(CPRSBroker,CPRSState,tmplst,'VEFA ALERT DOC FOLLOWUPS',Param1);
    //Showmessage('here');
    Dest.Assign(tmplst);
  finally
    tmplst.Free;
  end;
//   Showmessage('After Load Notifications.');
end;
initialization
  TAutoObjectFactory.Create(ComServer, Twrite4comobject, Class_write4comobject,
    ciMultiInstance, tmApartment);
end.
