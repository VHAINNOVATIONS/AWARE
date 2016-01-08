unit FAT4_textok;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ORCtrls,ORfn,ComCtrls,FATHelpScreen;

type
  TFATFormS = class(TForm)
    AlertLabel: TLabel;
    ButtonLeave: TButton;
    Label2: TLabel;
    Label3: TLabel;
    PatientName: TLabel;
    Label4: TLabel;
    ReminderInstructions: TLabel;
    Button1: TButton;
    Label9: TLabel;
    Button2: TButton;
    NoteTitle: TLabel;
    Button3: TButton;
    procedure OnShow(Sender: TObject);
    procedure ButtonLeaveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
   { procedure OnClick(Sender: TObject); }
  private
    { Private declarations }

  public
    { Public declarations }
   ordercheckboxes: array of TCheckBox;
   followupcheckboxes: array of TCheckBox;
  end;
 function ShowFATHelpScreenFormS() : Integer; StdCall;forward;
var
  FATFormS: TFATFormS;
  //List: TStringList;

implementation

{$R *.dfm}

uses   writecomobject;

resourcestring
  StrFPtSel_lstvAlerts_Co = 'C'+U+'FAT3_textok.lstvAlerts.Cols';

const
  AliasString = ' -- ALIAS';

{procedure TFATForm.OnClick(Sender: TObject);
 var
      NewItem: TListItem;
       I,J: Integer;
       Comment: String;
       colSizes : String;
begin
  // Load the items
  colSizes := '';

           //List := TStringList.Create;
  NewItem := nil;
  lstvAlerts.Clear;
  lstvAlerts.Items.Clear;
     //Showmessage('before Load Notifications.');
  try
     //LoadNotifications(List,CPRSBroker,CPRSState);

    { for I := 0 to List.Count - 1 do
       begin
    //   List[i] := ConvertDate(List, i);  //cla commented out 8/9/04 CQ #4749

       //  ShowMessage(List[I]);

          if Piece(List[I], U, 1) <> 'Forwarded by: ' then
           begin
             NewItem := lstvAlerts.Items.Add;
             NewItem.Caption := Piece(List[I], U, 1);
             for J := 2 to DelimCount(List[I], U) + 1 do
                NewItem.SubItems.Add(Piece(List[I], U, J));
           end
         else   //this list item is forwarding information
           begin
             NewItem.SubItems[5] := Piece(List[I], U, 2);
             Comment := Piece(List[I], U, 3);
             if Length(Comment) > 0 then NewItem.SubItems[8] := 'Fwd Comment: ' + Comment;
           end;
       end;
   finally
      //List.Free;
       lstvAlerts.Refresh;
   end;
   {with lstvAlerts do
     begin
        colSizes := SizeHolder.GetSize(StrFPtSel_lstvAlerts_Co);
        if colSizes = '' then begin
          Columns[0].Width := 40;          //Info                 Caption
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
      lstvAlerts.Refresh;  }
//end;

procedure TFATFormS.Button1Click(Sender: TObject);
begin
     // FATform.CloseModal  ;
     ModalResult := mrOk  ;
     Release;
end;

procedure TFATFormS.Button2Click(Sender: TObject);
begin
writecomobject.FormTake := 1  ; //back to next time as long form
end;

procedure TFATFormS.Button3Click(Sender: TObject);
begin
 ShowFATHelpScreenFormS();
end;

procedure TFATFormS.ButtonLeaveClick(Sender: TObject);
begin
      //FatForm.CloseModal ;
      ModalResult := mrCancel  ;
      Release;
end;

procedure TFATFormS.OnShow(Sender: TObject);
var
     NewItem: TListItem;


       I,J: Integer;
       Comment: String;
begin
    {  lstvAlerts.Items.Clear ;
           //List := TStringList.Create;
      NewItem := nil;
     //Showmessage('before Load Notifications.');
  try
     //LoadNotifications(List,CPRSBroker,CPRSState);
      for I := 0 to List.Count - 1 do
       begin
    //   List[i] := ConvertDate(List, i);  //cla commented out 8/9/04 CQ #4749

 //      ShowMessage(List[I]);

          if Piece(List[I], U, 1) <> 'Forwarded by: ' then
           begin
              NewItem := lstvAlerts.Items.Add;
              NewItem.Caption := Piece(List[I], U, 1);
              for J := 2 to DelimCount(List[I], U) + 1 do
                 NewItem.SubItems.Add(Piece(List[I], U, J));
           end
         else   //this list item is forwarding information
           begin
             NewItem.SubItems[5] := Piece(List[I], U, 2);
             Comment := Piece(List[I], U, 3);
             if Length(Comment) > 0 then NewItem.SubItems[8] := 'Fwd Comment: ' + Comment;
           end;
       end;
   finally
      List.Free;
   end;   }

end;
Function ShowFATHelpScreenFormS() : Integer;
var
    iResult,I: Integer      ;
    //FATFormS: TFATFormS;
//  frmSystemModal: TfrmSystemModal;
begin
  HelpScreen := THelpScreen.Create(Application);

  with HelpScreen do
    try
      {...}

//      DisableWindows;
      iResult := ShowModal;
      //Showmessage( 'return fatform dialog text: ');
//      EnableWindows;
    finally
    if ModalResult = mrCancel then Result:= 0;
    if ModalResult = mrOk then Result:= 1;


      //Free;
      HelpScreen.Free;
      //Showmessage( 'free fatform dialog text: ');
    end;
end;
end.
