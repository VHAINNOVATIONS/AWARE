unit writecomobject20101022;

interface

uses
  ComObj, ActiveX, write4cprsext_TLB, StdVcl,CPRSChart_TLB,Trpcb,Mfunstr,FmCmpnts,DiTypLib,Forms,Windows,ORSystem,extctrls,Messages;

type
    PMsg = ^TMsg;
{    TMsg = packed record
    hwnd: HWND;
    message: UINT;
    wParam: WPARAM;
    lParam: LPARAM;
    time: DWORD;
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

function TimeoutSysMsgProcHook(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall;forward;
function TimeoutJournalRecordProcHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall;forward;
function TimeoutJournalPlaybackProcHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; forward;
function TimeoutMouseHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall;forward;

var timTimeout: TCPRSTimeoutTimer;// external;
    bRecord:Boolean = False;
    bPlayback:Boolean = True;
implementation

uses ComServ, Dialogs,Sysutils,db,comctrls;

//function TimeoutJournalRecordProcHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;StdCall; forward;

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
       FmGets1:TFMGets = nil;
       FmGets2:TFMGets = nil;
       FmGets3:TFMGets = nil;
       FmFiler1:TFMFiler = nil;
       FmFiler2:TFMFiler = nil;
       TControl1:TTabControl = nil;
       FString1:string;
       FmBroker : TRPCBroker;
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

       ///////function TimeoutKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; forward;
//function TimeoutMouseHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT; StdCall; forward;
procedure TMsgToEventMsg(msgptr:PMsg;eventptr:PEventMsg);
begin
//here
//ShowMessage(IntToStr(Integer(msgptr)));
eventptr^.message := msgptr^.message;
eventptr^.time := msgptr^.time;
eventptr^.paramL := msgptr^.lParam;
eventptr^.paramH := msgptr^.wParam;
eventptr^.hwnd := msgptr^.hwnd;


end;


procedure EventMsgToTMsg(eventptr:PEventMsg;msgptr:PMsg);
begin
//here

msgptr^.message := eventptr^.message;
msgptr^.time := eventptr^.time;
msgptr^.lParam := eventptr^.paramL;
msgptr^.wParam := eventptr^.paramH;
msgptr^.hwnd := eventptr^.hwnd;
msgptr^.pt.x := 0;
msgptr^.pt.y := 0;

end;


function TimeoutSysMsgProcHook(nCode: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
begin
          msgptr := Ptr(lparam) ;
          Move (msgptr,BufMessage[icnt],Sizeof(TMsg));
          TIDWORD1 := (msgptr^.time);
          T11 := TIDWORD1;
          //BASETIME := T11 ;
          BufMessage[icnt].time := T11 -BASETIME; // 2 second delay to get out of execute object
          icnt := icnt + 1;
          Result := 0;
          if nCode < 0 then Result :=  CallNextHookEx(uTimeoutSysMsgProcHandle,nCode,wParam, lParam);
end;


function TimeoutJournalRecordProcHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every message event that occurs while running CPRS }
begin

        ShowMessage('Patient selected now: ');
        if (Code = HC_SYSMODALON) then
        begin
                uModal := 1;
       ShowMessage('HC_SYSMODALON1');
                //set hook to capture , but mot process all messages in dialog
                //boxes, message boxes, scroll bars, menus
                uTimeoutSysMsgProcHandle := 0;
                if uTimeoutSysMsgProcHandle = 0  then uTimeoutSysMsgProcHandle := SetWindowsHookEx(WH_SYSMSGFILTER,TimeoutSysMsgProcHook,HInstance,0);
        ShowMessage('HC_SYSMODALON2');
        end;
        if (Code = HC_SYSMODALOFF) then
        begin
       ShowMessage('HC_SYSMODALOFF');
                UnhookWindowsHookEx(uTimeoutSysMsgProcHandle);
                uModal := 0;
        end;
        ShowMessage('incnt=1');
        if (Code = HC_ACTION)and (uModal = 0) then
        begin
                //timTimeout.ResetTimeout;             //also save lparam later
                eventptr := Ptr(lparam) ;//or case PEventMsg as pointer to EVENTMSG, or tagEVENTMSG  (which are the same in windows.pas)Addr(lParam) ;
                msgptr := @messagec;
                EventMsgToTMsg(eventptr,msgptr);

                //T2REAL := Int( Frac(Now)*86400*1000); //NUMBER OF MILLSEC IN DAY
                //T2INT64 := Trunc(T2REAL);
                //T2INT   := Integer (T2INT64);

                //T22 := DWORD (Now) ;
                //Move (lParam,BufMessage[icnt],Sizeof(tagEVENTMSG));
                Move (messagec,BufMessage[icnt],Sizeof(TMsg));
                //BufMessage[icnt].time := DWORD (Now);//DWORD((T22.Value-T11.Value)*86400*1000);
                if icnt = 0 then
                begin
                   TIDWORD1 := (eventptr^.time);
                   T11 := TIDWORD1;
                   //BASETIME := T11 ;
                   BufMessage[icnt].time := T11 -BASETIME; // 2 second delay to get out of execute object
                   //when mouse unsteady during startup before BASETIME defined then reject
                   //any of these intial mouse movements
                   if T11 < BASETIME then icnt := icnt -1;

                   //if BufMessage[icnt].time >4000000000 then ShowMessage (IntToStr(BufMessage[icnt].time));
                end
                else
                begin

                   TIDWORD := (eventptr^.time);
                   T22 := TIDWORD;
                   BufMessage[icnt].time := T22 -BASETIME ;
                   //when mouse unsteady during startup before BASETIME defined then reject
                   //any of these intial mouse movements
                   if T22 < BASETIME then icnt := icnt -1;
                end;
                //if icnt = 0 then ShowMessage(IntToStr(TIDWORD));
                //if icnt = 0 then ShowMessage(IntToStr(BufMessage[icnt].time)+' ' + IntToStr(GetTickCount())+ ' '+ IntToStr(DELTA)+ ' ' + IntToStr(eventptr^.time) + ' ' + IntToStr(BASETIME));
                //if icnt = 0 then ShowMessage(IntToStr(BufMessage[icnt].time));
                icnt :=icnt+1;
                //Canvas.TextOut(10,10,'message = '+IntoStr(lparam.message);
        end;
        //icnt :=icnt+1;
        ShowMessage('incnt=2');

  ////////if (Code <> HC_ACTION )  then Result := CallNextHookEx(uTimeoutJournalRecordProcHandle, Code, wParam, lParam);
  if (Code = HC_ACTION)  then Result := 0;
  if (Code < 0 )  then Result := CallNextHookEx(uTimeoutJournalRecordProcHandle, Code, wParam, lParam);
{  if (Code >= 0) and (wParam > WM_MOUSEFIRST) and (wParam <= WM_MOUSELAST)
    then timTimeout.ResetTimeout;
  if (Code = HC_ACTION)and ( uModal = 0)and (bRecord = False) then
    begin
    timTimeout.ResetTimeout;             //also save lparam later
    Move (lParam,BufMessage[icnt],Sizeof(tagEVENTMSG));
    icnt :=icnt+1;
    end;                                            // all click events
  if ( Code <0 ) then Result := CallNextHookEx(timTimeout.uTimeoutMouseHandle, Code, wParam, lParam);
  if ( Code >=0 ) then Result := 0;
}
end;

{
function TimeoutJournalRecordProcHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every message event that occurs while running CPRS }
{begin
        //ShowMessage('Patient selected now: ');
        if (Code = HC_SYSMODALON) then uModal := 1;
        if (Code = HC_SYSMODALOFF) then uModal := 0;
        if (Code = HC_ACTION)and ( uModal = 0) then
        begin
                //timTimeout.ResetTimeout;             //also save lparam later
                Move (lParam,BufMessage[icnt],Sizeof(tagEVENTMSG));
                icnt :=icnt+1;
                //Canvas.TextOut(10,10,'message = '+IntoStr(lparam.message);
        end;
        //icnt :=icnt+1;

  if (Code <0 ) then Result := CallNextHookEx(uTimeoutJournalRecordProcHandle, Code, wParam, lParam);
  if ( Code >=0 ) then Result := 0;
} {real code end here}
{  if (Code >= 0) and (wParam > WM_MOUSEFIRST) and (wParam <= WM_MOUSELAST)
    then timTimeout.ResetTimeout;
  if (Code = HC_ACTION)and ( uModal = 0)and (bRecord = False) then
    begin
    timTimeout.ResetTimeout;             //also save lparam later
    Move (lParam,BufMessage[icnt],Sizeof(tagEVENTMSG));
    icnt :=icnt+1;
    end;                                            // all click events
  if ( Code <0 ) then Result := CallNextHookEx(timTimeout.uTimeoutMouseHandle, Code, wParam, lParam);
  if ( Code >=0 ) then Result := 0;
}
{end;}

function TimeoutJournalPlaybackProcHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
 label postagain;
{ this is called for every message event that occurs while running CPRS }
begin


       if Code = HC_NOREMOVE then
       begin

            Result := 0;

       end;

      if Code = HC_SYSMODALON then
      begin
          umodal := 1;
          //icntmsg := icntmsg +1;
          //if icntmsg >= icnt then
          //begin
          //      UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);

          Result := 0;
      end;
      if Code = HC_SYSMODALOFF then
      begin
          //icntmsg := icntmsg +1;
          //if icntmsg >= icnt then
          //begin
          //      UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);
          //
          //end;
          umodal := 0;
          Result := 0;
      end;



      if Code = HC_SKIP then
      begin
          //;get start to compute delta next
          icntmsg := icntmsg +1;
          if icntmsg >= icnt then
          begin
                UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);
                //ShowMessage ('got here');
          end;
          //get data for next HC_GETNEXT;
          Result := 0;
          //ShowMessage ('got here1');
      end;
      if Code = HC_GETNEXT then
      begin
           iflagptr := 0;
          //check for message for modal dialog box, message box, scroll bar, menu
          if (BufMessage[icntmsg].pt.x <> 0)or (BufMessage[icntmsg].pt.y <> 0) then
                begin
                      //HC_SKIP preceded this, so inctmsg incremented from
                      //last good event message (HC_SYSMODALON AND HC_SKIP already
                      //occurred ( either one first and other followed). umodal has
                      //been set =1 by this time
                      //ShowMessage('here');
                      eventptr := Ptr(lParam) ;
                      msgptr := @messagec; //Addr(messagec);
                      //if (lastcode = HC_ACTION) and ( lastmessage = BufMessage[icntmsg].message)and (isee = 2 ) then icntmsg := icntmsg +1;
                      Move (BufMessage[icntmsg],messagec,Sizeof(TMSG));
                      TMsgToEventMsg(msgptr,eventptr);
                      eventptr^.time := eventptr^.time + BASETIME ;
                      DELTA := eventptr^.time - GetTickCount();
                      if (DELTA > (0)) then
                      begin
                          Result := DELTA;
                          iflagptr := 0 ; //do not increment inctmsg until
                          //next pass after this delay .Only 1st message goes thru here

                      end
                      else
                      begin
                          Result := 0;
                          //upon delay counted down = 0 for this message then
                      //GetwindowthreADPROCESSID  from message handle
                      //sleep function for delta delay else do post immediately
                      //when delay = 0, then increment icntmsg
                      //then do posthreadmessage
                      //postthreadmessage if any to thread of window opened for next messages
                      //to post until pnt x y value = 0,0
                      //check for good return. if not sleep again.and repeat until
                      //good return. then delay this with 1 second delay, since
                      //delaying with zero delay would actually try to post eventmsg
                      //on queue, which cannot do since this is really a message
                      //to post, not an avent.

                       //threadIdptr := Addr(threadId);
                       //threadIdptr:LPDWORD = NIL;

                       threadID := GetWindowThreadProcessId(msgptr^.hWnd,threadIdptr);	// handle of window
                       postagain:  bResult := PostThreadMessage(threadID,msgptr^.message,msgptr^.wParam,msgptr^.lParam);
                       if bResult = False then sleep(100);
                       if bResult = False then goto postagain;


                          iflagptr := 1;
                          //all messages should get here including first one on 2nd pass with first pass with delay nonzero first

                      end;


                      if (iflagptr = 1) then
                      begin
                        icntmsg := icntmsg +1;
                        if icntmsg >= icnt then
                        begin
                                UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);
                                //ShowMessage ('got here');
                                iflagptr := 0;
                        end;

                      end;

                      if (iflagptr = 1 )then
                      begin
                          //get next message or eventmsg and calculate next delay
                          eventptr := Ptr(lParam) ;
                          msgptr := @messagec ; //Addr(messagec);
                          //if (lastcode = HC_ACTION) and ( lastmessage = BufMessage[icntmsg].message)and (isee = 2 ) then icntmsg := icntmsg +1;
                          Move (BufMessage[icntmsg],messagec,Sizeof(TMSG));
                          TMsgToEventMsg(msgptr,eventptr);
                          eventptr^.time := eventptr^.time + BASETIME ;
                          DELTA := eventptr^.time - GetTickCount();
                          if (DELTA > (0)) then
                          begin
                              Result := DELTA;
                          end
                          else
                          begin
                               Result := 0;
                               //should not happen for a message (or event)
                               //also events , messages should be recorded slowly with some
                               //delay between each event
                               //just in case set DELAY =100 MILLISECS
                               Result := 100;
                          end;

                      end;
                end
                else
                begin


                      //ShowMessage ('got here2');
                     //isee := isee + 1;
                     eventptr := Ptr(lParam) ;
                     msgptr := @messagec;//Addr(messagec);
                     //ShowMessage('pointer='+IntToStr(longint (msgptr))) ;
                     //if (lastcode = HC_ACTION) and ( lastmessage = BufMessage[icntmsg].message)and (isee = 2 ) then icntmsg := icntmsg +1;
                     Move (BufMessage[icntmsg],messagec,Sizeof(TMSG));
                     TMsgToEventMsg(msgptr,eventptr);
                     //TMsgToEventMsg(messagec,eventptr);
                     if first then
                     begin
                          TIDWORD := (eventptr^.time);
                          T1REAL := Int( Frac(Now)*86400*1000);
                          T1INT64 := Trunc(T1REAL);
                          T1INT   := Integer (T1INT64);
                          first := False;
                     end;
                     eventptr^.time := eventptr^.time + BASETIME ;
                     //T22 :=  GetTickCount();
                     {if eventptr^.time > T22 then
                     DELTA := eventptr^.time - T22
                     else
                     DELTA := 0;
                      }
                     DELTA := eventptr^.time - GetTickCount();
                     //
                     //if isee = 1 then DELTA := 0;
                     if (DELTA > (0)) then
                     begin
                     //if DELTA > 1000 THEN  DELTA := 1000;
                          Result := DELTA;
                          //if isee = 1 then ShowMessage(IntToStr(DELTA));
                         //if isee = 1 then ShowMessage(IntToStr(eventptr^.time));
                         //if isee = 1 then ShowMessage(IntToStr(BASETIME));
                         //if isee = 1 then ShowMessage(IntToStr(GetTickCount())+ ' '+ IntToStr(DELTA)+ ' ' + IntToStr(eventptr^.time) + ' ' + IntToStr(BASETIME));
                     end
                     else
                     begin
                         Result := 0;
                         if umodal = 1 then Result := 100 ;//must delay until return from modal box
                         //if isee = 1 then ShowMessage(IntToStr(DELTA));
                         //isee := 0 ;
                     end;
                      //lParam.time := T11+ lParam.time;
                      //if (lParam.time-T22)<= 0 then Result := 0
                      //if (T22-lParam.time)> 0 then Result := (T22 - lParam.time)*86400*1000 ;milliseconds
                end;
      end;
      //lastcode := Code;
      //lastmessage := eventptr^.message;
      //if (Code <> HC_SKIP) and ( Code <> HC_GETNEXT)and (Code <> HC_SYSMODALON) and (Code <> HC_SYSMODALON)and (Code = HC_NOREMOVE) then  Result := CallNextHookEx(uTimeoutJournalPlaybaam, lParam);
      if Code < 0 then Result :=  CallNextHookEx(uTimeoutJournalPlaybackProcHandle,Code,wParam, lParam);
end;



function Twrite4comobject.Execute(const CPRSBroker: ICPRSBroker;
  const CPRSState: ICPRSState; const Param1, Param2, Param3: WideString;
  var Data1, Data2: WideString): WordBool;

  label again,over,REPEAT1,OVER2,NEXT,over3;

  var

        DateTimeV1: TDateTime;
        DateTimeV2: TDateTime;
        T1float,T2float:   comp;
        i,j,IS1,IS2:integer;
        sAVcode,istr: string;
        //fatal: boolean;
        err: TFMErrorObj;
        ival: integer;
begin
       uTimeoutInterval    := 120000;  // initially 2 minutes, will get DTIME after signon
       //ival := Integer (HInstance);
       //Data1 := IntToStr(ival);


       if DateTimeA = nil then
       begin
       GetMem(DateTimeA,Sizeof(DateTimeV1));
       //if uTimeoutJournalRecordProcHandle<>0  then uTimeoutJournalRecordProcHandle := SetWindowsHookEx(WH_JOURNALRECORD,TimeoutJournalRecordProcHook,HInstance,0) ; //Application.Handle, 0);
       //uTimeoutKeyHandle   := SetWindowsHookEx(WH_KEYBOARD, TimeoutKeyHook,   0, GetCurrentThreadID);
       //uTimeoutMouseHandle := SetWindowsHookEx(WH_MOUSE,    TimeoutMouseHook, 0, GetCurrentThreadID);
       //Application.OnMessage := AppMessage;
       end;

       FmBroker:= nil;
         if (FmBroker = nil) then FmBroker := TRPCBroker.Create(nil);
         FmBroker.ClearParameters :=True;
         FmBroker.Server := '127.0.0.1'; //'580dm3.houston.va.gov';
         sAVcode :='vhaino321;verify123.'; // '224mgw;flames2';
         FmBroker.AccessVerifyCodes := sAVCode;
         FmBroker.Connected := True;
       //  Showmessage('icnt=0') ;
      //assuming each pass broker deallocated so one must be obtained as above ( unless
      //later only passsing thru without connection needed. for now assume need once
      //each pass thru dll

         Showmessage('Cnt(0)')  ;
      //CHECK FOR TEST CASE REQUEST. STAY IN LOOP UNTIL REQUEST made with TEST CASE #, PATIENT, ETC

        if irepeat1 = 0 then goto OVER2; //temporary new stay in record/playback loop
        if (FmGets3 = nil) then FmGets3 := TFMGets.Create(nil);
REPEAT1: FmGets3.RPCBroker := FmBroker;
       FmGets3.FileNumber :='580000105.05'; //WAS 80 WAS 2
       FmGets3.IENS :=  '1,1,'  ; //','+IEN; //later put in loop to check which request '1,IEN,' in multiple and client tcpip has to match
       FmGets3.GetsFlags :=[gfExternal,gfInternal];
       FmGets3.AddField('.01'); //test request ien 1 relative
       FmGets3.AddField('1');  // test request type ( 0: pLAY 1 : rECord)
       FmGets3.AddField('2');  //TcpIpAdr:Port of Client
       FmGets3.AddField('3');   //test patient
       FmGets3.AddField('4');   //provider
       FmGets3.AddField('6');   //primary test case #
       FmGets3.AddField('7'); //test request  (zero for no request, nonzero number for request)
       try
                        FmGets3.GetData;
       Except
                        FmGets3.DisplayErrors ;

       End;

          Showmessage('VA Alert Re-engineering Patient Selected!') ;

       //goto NEXT;
       iTestRequest:= 0;
       iTestRequest:= StrToInt( FmGets3.GetField('7').FMDBExternal) ;
       iTestRequestIen:= StrToInt( FmGets3.GetField('.01').FMDBExternal) ;
       sTcpIpAdrPort :=  FmGets3.GetField('2').FMDBExternal ;
       //if (iTestRequest > 0) and ( sTcpIpAdrPort := mine) then
       if iTestRequest > 0 then
       begin

            sRequestType := FmGets3.GetField('1').FMDBExternal ;
            if sRequestType = 'Record' then
            begin
                  bRecord := False;
                  bPlayback := True;
                  irepeat1 := 0;
            end
            else
            begin

                  bRecord := True;
                  bPlayback := False;
                  irepeat1 := -1;

            end;
            itestcase := StrToInt( FmGets3.GetField('6').FMDBInternal);
            itestpatient := StrToInt( FmGets3.GetField('3').FMDBInternal);
            iprovider := StrToInt( FmGets3.GetField('4').FMDBInternal);
            Showmessage('icnt=2') ;
            //irepeat1 := 0;
            //clear the request immediately
                if (FmFiler2 = nil) then FmFiler2 := TFMFiler.Create(nil);
                FmFiler2.RPCBroker := FmBroker;
                FmFiler2.Clear ;
                //Iens1 := '?+2,' + IntToStr(itestcase)+',' ; // fill into test case # 1 now
                istr :=  IntToStr(1)+ ',';  //alway 1st record has test request
                Iens1 := '?+2,' + istr  ; // fill into test case # 1 now
                CntStr := IntToStr(iTestRequestIen); //message # + 1 record ( 1 relative)
                FmFiler2.AddFDA('580000105.05',Iens1,'.01',CntStr); //test request #.01 field
                FmFiler2.AddFDA('580000105.05',Iens1,'7',IntToStr(0)); //hwnd #1 field
                if NOT FmFiler2.Update then FmFiler2.DisplayErrors ;

                FmFiler2.Free;
                FmFiler2 := nil;

       end
       else
       begin
             sleep(1000); //1 SECOND
             if uTimeoutJournalPlaybackProcHandle > 0  then UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);
             irepeat1 := 1

       end;

                 Showmessage('icnt=3') ;


  NEXT:     if irepeat1 = 1 then goto REPEAT1;
       //irepeat1 := -1;

             FmGets3.Free;
             FmGets3 := nil;

      //temporarily below to allow continuous playback mode
      //bPlayback := False;
      //bRecord := True;


OVER2: if bPlayback = True then
       begin
                bRecord := True ;
                bPlayback := False;

                first := True;
                UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);
                Zero.message := 0;
                Zero.time := 0;
                Zero.lParam := 0;
                Zero.wParam := 0;
                Zero.hwnd := 0;
                Zero.pt.x := 0;
                Zero.pt.y := 0;
                counter1 := 0;
                while counter1 <= icnt do
                begin
                        Move (Zero,BufMessage[counter1],Sizeof(TMSG));
                        counter1 := counter1 +1;
                end;
                icnt :=0;
                icntmsg := 0;
       end
       else
       begin
                bRecord := False;
                bPlayback := True;
                icntmsg := 0;
                //icnt := 0;
                first := True;
                UnhookWindowsHookEx(uTimeoutJournalRecordProcHandle);
                //DeleteFile('c:\output.bin');
                //AssignFile(ToF,'c:\output.bin');
                //ReWrite(ToF,Sizeof(TMSG));
                //Reset(ToF);
                //BlockWrite(ToF,BufMessage[0],icnt-1,icntot);
                //Close(ToF);

                //itestcase := itestcase + 1;
                //if itestcase > 12 then itestcase := 1;


                //temporaily below commented out .playback continuous ( skip over save)
                istr :=  IntToStr(itestcase)+ ',';
                //check playback below
                if irepeat1 = -1 then goto over;
                //irpeat1  must be zero here for end of record
                //do filing and reset irepeat1 = -1

                //WRITE TO VISTA THIS RECORDING
                if (FmFiler1 = nil) then FmFiler1 := TFMFiler.Create(nil);
                FmFiler1.RPCBroker := FmBroker;
                icnt9 := 0;
                while icnt9 <icnt do
                begin
                FmFiler1.Clear ;
                //Iens1 := '?+2,' + IntToStr(itestcase)+',' ; // fill into test case # 1 now
                istr :=  IntToStr(itestcase)+ ',';
                Iens1 := '?+2,' + istr  ; // fill into test case # 1 now
                CntStr := IntToStr(icnt9+1); //message # + 1 record ( 1 relative)
                FmFiler1.AddFDA('580000105.03',Iens1,'.01',CntStr); //new #.01 field
                FmFiler1.AddFDA('580000105.03',Iens1,'1',IntToStr(BufMessage[icnt9].hwnd)); //hwnd #1 field
                FmFiler1.AddFDA('580000105.03',Iens1,'2',IntToStr(BufMessage[icnt9].message)); //message #2 field
                FmFiler1.AddFDA('580000105.03',Iens1,'3',IntToStr(BufMessage[icnt9].wParam)); //wParam #4 field
                FmFiler1.AddFDA('580000105.03',Iens1,'4',IntToStr(BufMessage[icnt9].lParam));// lParam #5 field
                FmFiler1.AddFDA('580000105.03',Iens1,'5',IntToStr(BufMessage[icnt9].time)); //time #6 field
                x := BufMessage[icnt9].pt.x;
                y := BufMessage[icnt9].pt.y;
                FmFiler1.AddFDA('580000105.03',Iens1,'6',IntToStr(x)); //pt.x #7 field
                FmFiler1.AddFDA('580000105.03',Iens1,'7',IntToStr(y)); //pt.y #8 field
                if NOT FmFiler1.Update then FmFiler1.DisplayErrors ;
                icnt9 := icnt9 + 1;
                end;
                FmFiler1.Clear;
                //FmFiler1.AddFDA('580000105',IntToStr(itestcase)+',','4',IntToStr(icnt)); //cnt #4 field

                FmFiler1.AddFDA('580000105',istr,'4',IntToStr(icnt)); //cnt #4 field
                if NOT FmFiler1.Update then FmFiler1.DisplayErrors ;

                FmFiler1.Free;
                FmFiler1 := nil;
                goto over3; //finish record
                //zero out data
  over:         Zero.message := 0;
                Zero.time := 0;
                Zero.lParam := 0;
                Zero.wParam := 0;
                Zero.hwnd := 0;
                Zero.pt.x := 0;
                Zero.pt.y := 0;
                counter1 := 0;
                while counter1 <= icnt do
                begin
                        Move (Zero,BufMessage[counter1],Sizeof(TMSG));
                        counter1 := counter1 +1;
                end;
   //over:        icnt :=0 ;
                icnt := 0;
                //read data from file



                 //GET IN LOOP
                if (FmGets2 = nil) then FmGets2 := TFMGets.Create(nil);
                FmGets2.RPCBroker := FmBroker;
                icnt9 := 0;
                //read icnt 1st
                FmGets2.FileNumber :='580000105'; //WAS 80 WAS 2
                //FmGets2.IENS :=  IntToStr(itestcase)+','  ; //','+IEN;
                FmGets2.IENS := istr ;// '10'+','  ; //','+IEN;
                FmGets2.GetsFlags :=[gfExternal,gfInternal];
                FmGets2.AddField('4'); //icnt

                try
                 FmGets2.GetData;
                Except

                End;
                icnt := StrtoInt( FmGets2.GetField('4').FMDBExternal );
                //FmGets2.Clear ;
                while icnt9 <icnt do
                begin


                                 //get data from fields form fmlister not fmgets
                FmGets2.FileNumber :='580000105.03'; //WAS 80 WAS 2
                //FmGets2.IENS :=  IntToStr(icnt9+1)+',' + IntToStr(itestcase)+','  ; //','+IEN;
                //FmGets2.IENS :=  IntToStr(icnt9+1)+',' + '10'+','  ; //','+IEN;
                FmGets2.IENS :=  IntToStr(icnt9+1)+',' + istr  ; //','+IEN;
                FmGets2.GetsFlags :=[gfExternal,gfInternal];
                FmGets2.AddField('.01');
                FmGets2.AddField('1');
                FmGets2.AddField('2');
                FmGets2.AddField('3');
                FmGets2.AddField('4');
                FmGets2.AddField('5');
                FmGets2.AddField('6');
                FmGets2.AddField('7');
                //FmGets2.RPCBroker := FmBroker;
                try
                        FmGets2.GetData;
                Except
                        FmGets2.DisplayErrors ;

                End;

                BufMessage[icnt9].hwnd := StrToInt( FmGets2.GetField('1').FMDBExternal) ;
                BufMessage[icnt9].message := StrToInt (FmGets2.GetField('2').FMDBExternal) ;
                BufMessage[icnt9].wParam := StrToInt (FMGets2.GetField('3').FMDBExternal) ;
                BufMessage[icnt9].lParam := StrToInt (FMGets2.GetField('4').FMDBExternal) ;
                BufMessage[icnt9].time := StrToInt (FmGets2.GetField('5').FMDBExternal) ;
                BufMessage[icnt9].pt.x := StrToInt (FmGets2.GetField('6').FMDBExternal) ;
                BufMessage[icnt9].pt.y := StrToInt (FmGets2.GetField('7').FMDBExternal) ;

                icnt9 := icnt9 + 1;
                //FmGets2.Clear ;
                end;
                FmGets2.Free;
                FmGets2 := nil;
                //UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);
over3:          irepeat1 := -1;
       end;

       //if TControl1 = nil then TControl1 := TTabControl.Create(nil);
       //if T1 = nil then T1 := TDateTimeField.Create(TControl1);
       //if T2 = nil then T2 := TDateTimeField.Create(TControl1);
       Move(DateTimeA^,DateTimeV1,Sizeof(DateTimeV1));
       DateTimeV2 := Now;
         //FmGets1:= nil;


         if (FmGets1 = nil) then FmGets1 := TFMGets.Create(nil);
         FmGets1.FileNumber :='3.7'; //WAS 80 WAS 2
         FmGets1.IENS :=CPRSState.UserDUZ;
         FmGets1.GetsFlags :=[gfExternal,gfInternal];
         FmGets1.AddField('.01');
         //FmGets1.AddField('.02');
         FmGets1.AddField('1.1');//.03
         //FmGets1.AddField('2');//.04
         //FmGets1.AddField('3');//.05
         //FmGets1.AddField('10');//.09
         //FmGets1.RPCBroker:= TRPCBroker (CPRSBroker);
         FmGets1.RPCBroker:= FmBroker;
         try
         FmGets1.GetData;
         except
          //fatal:=False;
         ShowMessage( String(FmGets1.ErrorList.Count));
         if FmGets1.ErrorList.Count>0 then
         begin
          {display errors to the user}
            //FmGets1.DisplayErrors;
          {loop through list of error objects}
          for i:=0 to (FmGets1.ErrorList.Count-1) do
           begin
               err:= FMGets1.ErrorList.Items[i];
               for j:=0 to (err.ErrorText.Count-1) do
               begin
               ShowMessage(err.ErrorText[j]);
               end;
               ShowMessage(err.FMField);
               //if err.ErrorNumber='601' then fatal:=True;
           end;
            //ShowMessage('Error on FmGets');
         end;
          Result := False;
          //FmBroker.Connected := False;
          FmBroker.Free;
          FmBroker := nil;
          FmGets1.free;
          FmGets1 := nil;
          Exit;
         end;
         FString1 :=FmGets1.GetField('1.1').FMDBExternal ;
         //FString2 :='';//FmGets1.GetField('.02').FMDBExternal ;
         //FString3 :=FmGets1.GetField('1').FMDBExternal ;
         //FString4 :=FmGets1.GetField('2').FMDBExternal ;
         //FString5 :=FmGets1.GetField('3').FMDBExternal ;
         //FString9 :=FmGets1.GetField('4').FMDBExternal ;
       //T1.Value := DateTimeV1;
       //T2.Value := DateTimeV2;
       //T1float:= T1.AsFloat ;
       //T2float:= T2.AsFloat;
       //ShowMessage('Here');
       IS1 := StrtoInt(FormatDateTime('h',DateTimeV1));
       IS2 :=StrToInt(FormatDateTime('h',DateTimeV2));
       if (DateTimeV1 = 0)or(IS1 <> IS2) then
       begin
         //if (DateTimeV1 = 0)or((DateTimeV2-DateTimeV1)>(1/24)) then
         //ShowMessage('XPatient selected now: ' +CPRSState.PatientName + ' at ' + DateTimetoStr(DateTimeV2)+' before '+ DateTimetoStr(DateTimeV1)+' diff='+FloatToStr(T2float-T1float)+'diff2='+DateTimeToStr(DateTimeV2-DateTimeV1));// + '. You have ' + FString1+' new GUI mail messages to read.' );
         //good   hereShowMessage('Patient selected now: ' +CPRSState.PatientName + ' at ' + DateTimetoStr(DateTimeV2)+ '. ' + ' You have ' + FString1+' new GUI mail messages to read.'); //' diff='+IntToStr(IS2-IS1));// + '. You have ' + FString1+' new GUI mail messages to read.' );
         Move(DateTimeV2,DateTimeA^,Sizeof(DateTimeV2));
       end;
        //ShowMessage('Patient selected now: ' +CPRSState.PatientName + ' at ' + DateTimetoStr(DateTimeV2)+ '. ' + ' You have ' + FString1+' new GUI mail messages to read.'+ ' message number = ' + InttoStr(uInt));
       if icnt = 0 then
          icntm1 := 0
       else
           icntm1 := icnt-1;


       //ShowMessage('Patient selected now: ' +CPRSState.PatientName + ' at ' + DateTimetoStr(DateTimeV2)+ '. ' + ' You have ' + FString1+' new GUI mail messages to read.'+ ' messages recorded  = '+Param2+ ' BufMessage = '+ IntToStr(BufMessage[icntm1].message)); // + InttoStr(icnt)); //+ Param2);
       Result := False;
       //FmBroker.Connected := False;
       FmBroker.Free;
       FmBroker := nil;
       FmGets1.free;
       FmGets1 := nil;
       bToggle := Not (bToggle);
       if bToggle = True  then Result := True ; //record and start
       if bToggle = False then Result := False; //playback and start
       ival := Integer (HInstance);
       Data1 := IntToStr(ival);
       Data2 := IntToStr(icnt);
       {if icnt > 2 then
                Data2 :=IntToStr(icnt) //TIDWORD1)
       else
                Data2 := IntToStr(icnt);
       }
       Data2 := IntToStr(icnt);


      { if bPlayback = True then
       begin
                if irepeat1 = 0 then
                begin
                      irepeat1 := -1;
                      goto REPEAT1;
                end;
       end;

       }



       if bRecord = True then
       begin
             uTimeoutJournalRecordProcHandle := 0;
             BASETIME := GetTickCount() ;
             umodal := 0;
             if uTimeoutJournalRecordProcHandle = 0  then uTimeoutJournalRecordProcHandle := SetWindowsHookEx(WH_JOURNALRECORD,TimeoutJournalRecordProcHook,HInstance,0);


       end;
       if (bPlayback = True) then
       begin
             if icnt <> 0 then
             begin
                 uTimeoutJournalPlaybackProcHandle := 0;
                 BASETIME := GetTickCount() ; //+4000
                 umodal := 0;

             again : if uTimeoutJournalPlaybackProcHandle = 0  then uTimeoutJournalPlaybackProcHandle := SetWindowsHookEx(WH_JOURNALPLAYBACK,TimeoutJournalPlaybackProcHook,HInstance,0);
                 if uTimeoutJournalPlaybackProcHandle = 0  then  sleep(500);
                 if uTimeoutJournalPlaybackProcHandle = 0  then   goto again;

             end
             else
                Showmessage('icnt=0');

       end;

end;
 procedure Twrite4comobject.Free();
 begin
      FreeMem(DateTimeA);
      //T1.Free;
      //T2.Free;
      //TControl1.Free;
      //FmGets1.free;
      //UnhookWindowsHookEx(uTimeoutKeyHandle);
      //UnhookWindowsHookEx(uTimeoutMouseHandle);
      UnhookWindowsHookEx(uTimeoutJournalRecordProcHandle);
      UnhookWindowsHookEx(uTimeoutJournalPlaybackProcHandle);
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
function TimeoutKeyHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every keyboard event that occurs while running CPRS }
begin
  //if lParam shr 31 = 1 then timTimeout.ResetTimeout;                          // on KeyUp only
  uInt := uInt +1;
  Result := CallNextHookEx(uTimeoutKeyHandle, Code, wParam, lParam);
  //Result := 0;
  end;

function TimeoutMouseHook(Code: Integer; wParam: WPARAM; lParam: LPARAM): LRESULT;
{ this is called for every mouse event that occurs while running CPRS }
begin
//  if (Code >= 0) and (wParam > WM_MOUSEFIRST) and (wParam <= WM_MOUSELAST)
//    then timTimeout.ResetTimeout;

 ShowMessage('Patient selected now: ');
  uInt := uInt + 1;                                            // all click events
  Result := CallNextHookEx(uTimeoutMouseHandle, Code, wParam, lParam);
  //Result := 0;
  end;


initialization
  TAutoObjectFactory.Create(ComServer, Twrite4comobject, Class_write4comobject,
    ciMultiInstance, tmApartment);
end.
