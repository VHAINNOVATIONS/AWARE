unit write4cprsext_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 4/13/2014 6:38:48 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: S:\i082 - AWARE\src\write4cprsext\write4cprsext\write4cprsext.tlb (1)
// LIBID: {12DFC781-0612-11D6-88B8-009027AACCF2}
// LCID: 0
// Helpfile: 
// HelpString: write4cprsext Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
//   (2) v1.0 CPRSChart, (\\vaphsvfin\sandbox\i20082\bin\CPRSChart29_AWARE.exe)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, CPRSChart_TLB, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  write4cprsextMajorVersion = 1;
  write4cprsextMinorVersion = 0;

  LIBID_write4cprsext: TGUID = '{12DFC781-0612-11D6-88B8-009027AACCF2}';

  IID_Iwrite4comobject: TGUID = '{12DFC782-0612-11D6-88B8-009027AACCF2}';
  CLASS_write4comobject: TGUID = '{12DFC784-0612-11D6-88B8-009027AACCF2}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  Iwrite4comobject = interface;
  Iwrite4comobjectDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  write4comobject = Iwrite4comobject;


// *********************************************************************//
// Interface: Iwrite4comobject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {12DFC782-0612-11D6-88B8-009027AACCF2}
// *********************************************************************//
  Iwrite4comobject = interface(IDispatch)
    ['{12DFC782-0612-11D6-88B8-009027AACCF2}']
  end;

// *********************************************************************//
// DispIntf:  Iwrite4comobjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {12DFC782-0612-11D6-88B8-009027AACCF2}
// *********************************************************************//
  Iwrite4comobjectDisp = dispinterface
    ['{12DFC782-0612-11D6-88B8-009027AACCF2}']
  end;

// *********************************************************************//
// The Class Cowrite4comobject provides a Create and CreateRemote method to          
// create instances of the default interface Iwrite4comobject exposed by              
// the CoClass write4comobject. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  Cowrite4comobject = class
    class function Create: Iwrite4comobject;
    class function CreateRemote(const MachineName: string): Iwrite4comobject;
  end;

implementation

uses ComObj;

class function Cowrite4comobject.Create: Iwrite4comobject;
begin
  Result := CreateComObject(CLASS_write4comobject) as Iwrite4comobject;
end;

class function Cowrite4comobject.CreateRemote(const MachineName: string): Iwrite4comobject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_write4comobject) as Iwrite4comobject;
end;

end.
