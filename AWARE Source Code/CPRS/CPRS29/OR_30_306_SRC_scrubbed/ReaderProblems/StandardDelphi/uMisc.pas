unit uMisc;

interface
uses
  SysUtils, Classes, ComCtrls;

function IsTemplateADialog(node: TTreeNode): boolean;
procedure PopupateTemplateTree(tv: TTreeView);
function GetNoteText(node: TTreeNode): string;
function InitDialogNoteText(node: TTreeNode): string;
function GetDialogNoteText: string;

const
  DELIM = '^';
  EOL = DELIM + 'EOL' + DELIM;
  EOLLEN = length(EOL);
  RBTN = DELIM + 'RADIO' + DELIM;
  CBOX = DELIM + 'CHKBOX' + DELIM;
  EDT = DELIM + 'EDT' + DELIM;
  EDTEOL = EDT + EOL;
  NOTEXT = DELIM + 'NOTEXT' + DELIM;
  EOL2 = EOL + ' ' + EOL;
  XXBTN = DELIM + 'BTN' + DELIM;


implementation

const
  SOAP_TEMPLATE = 1;
  NEPHROLOGY_CONSULT = 2;
  ER_T1_Detox = 3;
  HNP = 4;
  SPAT = 5;
  NEWP = 6;

procedure PopupateTemplateTree(tv: TTreeView);
var
  node: TTreeNode;
begin
  node := tv.Items.Add(nil, 'My Templates');
  tv.Items.AddChild(Node, 'SOAP Note').Data := Pointer(SOAP_TEMPLATE);
  node := tv.Items.Add(nil, 'Shared Templates');
  tv.Items.AddChild(Node, 'Nephrology Consult').Data := Pointer(NEPHROLOGY_CONSULT);
  tv.Items.AddChild(Node, 'ER T1 Detox').Data := Pointer(ER_T1_Detox);
  tv.Items.AddChild(Node, 'History and Physical').Data := Pointer(HNP);
  tv.Items.AddChild(Node, 'Speech Pathology').Data := Pointer(SPAT);
  tv.Items.AddChild(Node, 'New Patient Template').Data := Pointer(NEWP);

end;

const
  CRLF = #13#10;
  CRLF2 = CRLF + CRLF;
  CRLF4 = CRLF+CRLF+CRLF+CRLF;

  SOAP_NOTE = 'Subjective:' + CRLF4 + 'Ojective:' + CRLF4 + 'Assessment:' + CRLF4 + 'Plan:';

  NEPHROLOGY_CONSULT_NOTE =
  'Chief Complaint:' + CRLF +
  '' + CRLF +
  '' + CRLF +
  'Review of systems:' + CRLF +
  '' + CRLF +
  'Constitutional:	(   ) normal' + CRLF +
  'Skin:			(   ) normal' + CRLF +
  'HEENT:			(   ) normal' + CRLF +
  'Cardiovascular: 	(   ) normal' + CRLF +
  'Respiratory:		(   ) normal' + CRLF +
  'Gastrointestinal:	(   ) normal' + CRLF +
  'Musculoskeletal:	(   ) normal' + CRLF +
  'Neurologic:		(   ) normal' + CRLF +
  'Psychiatric:		(   ) normal' + CRLF +
  'Endocrine: 		(   ) normal' + CRLF +
  'Allergic		(   ) normal' + CRLF +
  '' + CRLF +
  'Past Personal:' + CRLF +
  '(prior illnesses/hospitalizations not covered above):' + CRLF +
  '' + CRLF +
  'Active Outpatient Medications (including Supplies):' + CRLF +
  '' + CRLF +
  '     Pending Outpatient Medications                         Status' + CRLF +
  '=========================================================================' + CRLF +
  '1)   ALLOPURINOL 100MG TAB TAKE ONE TABLET BY MOUTH TWICE   PENDING' + CRLF +
  '       A DAY --TAKE WITH FOOD TO DECREASE GI' + CRLF +
  '       IRRITATION/AVOID ANTACIDS--' + CRLF +
  '2)   IBUPROFEN 800MG TAB TAKE TWO TABLETS BY MOUTH TWICE A  PENDING' + CRLF +
  '       DAY --TAKE WITH FOOD IF GI UPSET OCCURS/DO NOT' + CRLF +
  '       CRUSH OR CHEW--' + CRLF +
  '' + CRLF +
  'Family History:' + CRLF +
  '' + CRLF +
  'Social History: (occupation, drugs, alcohol, marital):' + CRLF +
  '' + CRLF +
  'PHYSICAL EXAM:' + CRLF +
  '' + CRLF +
  'General: 	BP:' + CRLF +
  '	(appearance):' + CRLF +
  'Eyes: 	(conjunctiva/lids):' + CRLF +
  '	(ophthalmoscopy):' + CRLF +
  'Neck:	(masses, symmetry):' + CRLF +
  '	(thyroid):' + CRLF +
  'Lungs: (effort, percussion):' + CRLF +
  '	(auscultation):' + CRLF +
  'Heart: (auscultation):' + CRLF +
  '	(pulses):' + CRLF +
  '	(edema):' + CRLF +
  'GI:	(masses)' + CRLF +
  '	(liver, spleen):' + CRLF +
  'Lymph:	(nodes):' + CRLF +
  'GU: 	(male, prostate):' + CRLF +
  '	(female):' + CRLF +
  'Skin:	(lesions):' + CRLF +
  'Neuro:' + CRLF +
  'Musculoskeletal:' + CRLF +
  'Psychiatric: (   ) alert, oriented to time place and person' + CRLF +
  '' + CRLF +
  'LABORATORY EXAMS:' + CRLF +
  '' + CRLF +
  'RADIOLOGIC EXAMS:' + CRLF +
  '' + CRLF +
  'ASSESSMENT:' + CRLF +
  '' + CRLF +
  'PLAN/ RECOMMENDATIONS:';


  ER_T1_Detox_NOTE:Array[0..2] of string = (
  'EMERGENCY ROOM VISIT' + EOL +
  '' + EOL +
  'TEMPLATE:  ALCOHOL / DRUG' + EOL +
  '' + EOL +
  '==========================================================================' + EOL +
  'Not every box needs to be checked or question answered. It is suggested to' + EOL +
  'first do focused history, physical, test ordering and assessment, then use' + EOL +
  'template for similar focused documentation.' + EOL +
  '==========================================================================',
  '18) Impression' + EOL +
  CBOX + 'intoxicated' + EOL +
  CBOX + 'organic medical syndrome' + EOL +
  CBOX + 'mood disorder' + EOL +
  CBOX + 'schizophrenia' + EOL +
  CBOX + 'psychosis' + EOL +
  CBOX + 'acute narcotic withdrawal' + EOL +
  CBOX + 'acute ETOH withdrawal' + EOL +
  CBOX + 'acute benzodiazepine withdrawal' + EOL +
  CBOX + 'stimulant abuse' + EOL +
  CBOX + 'solvent abuse ("glue sniffer")' + EOL +
  CBOX + 'cocaine abuse' + EOL +
  CBOX + 'marijuana abuse' + EOL +
  CBOX + 'polysubstance abuse' + EOL +
  CBOX + 'Other: ' + EDTEOL +
  'The following criteria are used to decide disposition:' + EOL +
  '     1) Medicine service:  ETOH > 300, significant co-morbidity (angina, CHF, pneumonia,' + EOL +
  '        history of siezures or delirium tremens, liver disease, ETC), CIWA > 20' + EOL +
  '     2) 7S psychiatry:  at risk for harming self or others, accompanying psychiatric' + EOL +
  '        condition also requiring care (note: vet should not have criteria requiring' + EOL +
  '        medicine admission. If so, psychiatry consultation in ER needed)' + EOL +
  '     3) ED continuation unit:  ETOH 100 - 300, no significant co-morbidity, no history' + EOL +
  '        of delirium tremens or siezures, no significant psychiatric disorders, no risk to' + EOL +
  '        harm self or others' + EOL +
  '     4) Discharge from ED:  Only if responsible party can accompany vet. In addition,' + EOL +
  '        vet should have ETOH < 100 and not be at risk for serious withdrawal' + EOL, '');

  HNP_NOTE :Array[0..1] of string = (
  '1. Chief Complaint: ' + EDTEOL + ' ' + EOL +
  '2. History of Present Illness: ' + EDTEOL + ' ' + EOL +
  '   Allergies: Drugs,Foods/Substances (ex. Latex) PENICCILIN' + EOL + '  ' + EDTEOL + ' ' + EOL +
  '    Current Medications:' + EOL +
  '    Active Outpatient Medications (including Supplies):' + EOL2 + 
  '     Pending Outpatient Medications                         Status' + EOL +
  '=========================================================================' + EOL +
  '1)   ALLOPURINOL 100MG TAB TAKE ONE TABLET BY MOUTH TWICE   PENDING' + EOL +
  '       A DAY --TAKE WITH FOOD TO DECREASE GI' + EOL +
  '       IRRITATION/AVOID ANTACIDS--' + EOL +
  '2)   IBUPROFEN 800MG TAB TAKE TWO TABLETS BY MOUTH TWICE A  PENDING' + EOL +
  '       DAY --TAKE WITH FOOD IF GI UPSET OCCURS/DO NOT' + EOL +
  '       CRUSH OR CHEW--' + EOL2 +
  '3. PAST MEDICAL HISTORY' + EOL +
  '  a. Patient History:  ' + CBOX + ' N/A' + EOL +
  '  ' + CBOX + 'Surgeries: ' + EDTEOL +
  '  ' + CBOX + 'Injuries: ' + EDTEOL, '');

  SPAT_NOTE :Array[0..1] of string = (
  'Assessment:' + EOL2 +
  XXBTN + ' Level 1 Individual attempts to speak, but verbalizations are not' + EOL +
  'meaningful to familiar or unfamiliar individuals at any time.' + EOL +
  ' ' + EOL +
  XXBTN + ' Level 2 Individual attempts to speak, although few attempts are' + EOL +
  'accurate or appropriate.  The communication partner must assume' + EOL +
  'responsibility for structuring the communication exchange, and with' + EOL +
  'consistent and maximal cueing the individual can only occasionally produce' + EOL +
  'automatic and/or imitative words and phrases that are rarely meaningful in' + EOL +
  'context.' + EOL +
  ' ' + EOL +
  XXBTN + ' Level 3 The communication partner must assume responsibility for' + EOL +
  'structuring the communication exchange, and with consistent and moderate' + EOL +
  'cueing the individual can produce words and phrases that are appropriate' + EOL +
  'and meaningful in context.' + EOL, '');

  NEWP_NOTE :Array[0..4] of string = (
  ' ',
  'MEDICATIONS (as listed in Vista):' + EOL +
  '  Active Outpatient Medications (including Supplies):' + EOL2 +
  '     Pending Outpatient Medications                         Status' + EOL +
  '=========================================================================' + EOL +
  '1)   ALLOPURINOL 100MG TAB TAKE ONE TABLET BY MOUTH TWICE   PENDING' + EOL +
  '       A DAY --TAKE WITH FOOD TO DECREASE GI' + EOL +
  '       IRRITATION/AVOID ANTACIDS--' + EOL +
  '2)   IBUPROFEN 800MG TAB TAKE TWO TABLETS BY MOUTH TWICE A  PENDING' + EOL +
  '       DAY --TAKE WITH FOOD IF GI UPSET OCCURS/DO NOT' + EOL +
  '       CRUSH OR CHEW--' + EOL,
  'Review of Systems'+ EOL +
  '(Include at least ONE system from one of the following: Constitutional,' + EOL +
  'Eyes, Ears/Nose/Mouth/Throat, Cardiovascular, Respiratory, GI, GU,' + EOL +
  'Musculoskeletal, Skin/Hair, Neuro, Psych, Endocrine, Hematologic/' + EOL +
  'Lymphatic, Allergy/Immune System)' + EOL +
  'Review of Systems: ' + CBOX + 'Constitutional' + CBOX + 'Eyes' + CBOX + 'Ears' + CBOX + 'Nose' +
  'Mouth-Dental' + CBOX + 'Breast'+EOL+'Cardiac' + CBOX + 'Respiratory'+CBOX+'Endocrine'+CBOX+'Musculoskeletal'+CBOX+
  'Neurologic'+CBOX+'Skin'+EOL+'Comments:'+EDT,
  'IMPRESSION/ASSESSMENT:' + EOL +
  '(List: All symptoms or definitive diagnosis evaluated during this encounter.' + EOL +
  'Include stability and management options.)' + EOL + '  ' + EDTEOL + ' ' + EOL +
  'MANAGEMENT/PLAN:' + EOL +
  '(Include:' + EOL +
  '    Tests and diagnostic procedures ordered - including indications' + EOL +
  '    New medications and changes to existing medications' + EOL +
  '    Follow up appointments and consults to be scheduled)' + EOL +
  '  ' + EDT,'');


type
  TNoteArray = array[0..0] of string;

var
  nodeIndex: integer;
  PNoteArray: ^TNoteArray;

function InitDialogNoteText(node: TTreeNode): string;
begin
  nodeIndex := 0;
  case Integer(node.Data) of
    ER_T1_Detox:  PNoteArray := @ER_T1_Detox_NOTE;
    HNP: PNoteArray := @HNP_NOTE;
    SPAT: PNoteArray := @SPAT_NOTE;
    NEWP: PNoteArray := @NEWP_NOTE;
    else
      raise Exception.Create('oops');
  end;
end;

function GetDialogNoteText: string;
begin
  Result := PNoteArray^[nodeIndex];
  inc(nodeIndex);
end;

function IsTemplateADialog(node: TTreeNode): boolean;
begin
  case Integer(node.Data) of
    ER_T1_Detox, HNP, SPAT, NEWP:        Result := TRUE;
    else
      Result := FALSE;
  end;
end;

function GetNoteText(node: TTreeNode): string;
begin
  case Integer(node.Data) of
    SOAP_TEMPLATE:      Result := SOAP_NOTE;
    NEPHROLOGY_CONSULT: Result := NEPHROLOGY_CONSULT_NOTE;
    else
      Result := '';
  end;
end;

end.
