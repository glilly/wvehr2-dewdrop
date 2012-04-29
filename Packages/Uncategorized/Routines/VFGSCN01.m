VFGSCN01 ;voes/swo scan and view utils; 17 Jan 2007 12:28PM
 ;;2.1;VOES Scanning;****;8.7.2007;Build 4
 ;no entry from top
 Q
SERVER(VFGOUT) ;check server files
 ;
 ; RPC:
 ;   VFGS SCANNING SERVER INFO
 ;
 ; Input:
 ;   None
 ;
 ; Output:
 ;   VFGOUT message array. Returns status of Imaging Site Parameters and
 ;   Network Locations
 ;
 N VFG0,VFG00,VFG1,VFG2,VFG3,VFG4
 S U="^"
 S VFG0=$G(^MAG(2005.2,0))
 S VFG00=$G(^MAG(2006.1,0))
 I $P(VFG00,U,4)<1 D  Q
 .S VFG3(0)="Imaging Site Parameters Missing"
 .S VFG3(1)=""
 .S VFG3(2)="Contact Technical Assistance"
 .Q
 I ($P($G(^MAG(2006.1,1,0)),U)'?.N)&($O(^MAG(2006.1,"B",""))) D  Q
 .S VFG3(0)="Imaging Site Parameters Corrupted"
 .S VFG3(1)=""
 .S VFG3(2)="Contact Technical Assistance"
 .Q
 I $P(VFG0,U,4)<1 D  Q
 .S VFG3(0)="Network Locations are Undefined"
 .Q
 S VFG3(0)="Number of Network Locations Defined: "_$P(VFG0,U,4)
 S VFG3(1)="",VFG4=1
 S VFG1=0 F  S VFG1=$O(^MAG(2005.2,VFG1)) Q:'VFG1  D
 .S VFG2=$G(^MAG(2005.2,VFG1,0)) Q:VFG2=""  D
 .S VFG4=VFG4+1,VFG3(VFG4)="NETWORK LOCATION  : "_$P(VFG2,U)
 .S VFG4=VFG4+1,VFG3(VFG4)="PHYSICAL REFERENCE: "_$P(VFG2,U,2)
 .S VFG4=VFG4+1,VFG3(VFG4)="OPERATIONAL STATUS: "_$S($P(VFG2,U,6)=0:"Off-line",1:"On-line")
 .S VFG4=VFG4+1,VFG3(VFG4)="STORAGE DIRECTORY : "_$P(VFG2,U,7)
 .S VFG4=VFG4+1,VFG3(VFG4)="HASH SUBDIRECTORY : "_$P(VFG2,U,8)
 .S VFG4=VFG4+1,VFG3(VFG4)=""
 M VFGOUT=VFG3
 Q
ADDNL(RESULT,VFGADD) ;add new entry for 2005.2 Network Location
 ; **Under Construction**
 ; RPC:
 ;  VFGS SCANNING ADD NETLOC
 ; Input:
 ;  VFGSADD ARRAY FROM GUI
 ;
 ;  FILE    Field # Array Item          Value
 ;  2005.2  .01    VFGADD("NETLOC")       = FREE TEXT 3-30 alpha/numeric, no
 ;                                          spaces or punctuation
 ;  2005.2    1    VFGADD("PHYREF")       = FREE TEXT 1-120
 ;  2005.2    5    VFGADD("OSTAT")        = ""
 ;  2005.2    6    VFGADD("STYPE")        = "MAG"
 ;  2005.2    7    VFGADD("HASH")         = "Y"
 ;
 ;  Output
 ;     None
 ; setup the FDA
 K FDA
 S FDA("ADD",2005.2,"+1,",.01)=VFGADD("NETLOC")
 S FDA("ADD",2005.2,"+1,",1)=VFGADD("PHYREF")
 S FDA("ADD",2005.2,"+1,",5)=VFGADD("OSTAT")
 S FDA("ADD",2005.2,"+1,",6)=VFGADD("STYPE")
 S FDA("ADD",2005.2,"+1,",7)=VFGADD("HASH")
 ; passing external values to the call
 D UPDATE^DIE("E","FDA(""ADD"")")
 S RESULT=$NA(^TMP("DIERR",$J))
 Q
EDTSITE(RESULT,VFGEDT) ;
 ; **Under Construction**
 ; RPC:
 ;  VFGS SCANNING SITE EDIT
 ; Input:
 ;  VFGSEDT ARRAY FROM GUI
 ;
 ;  FILE    Field # Array Item          Value
 ;  2006.1  .03    VFGEDT("WRTLOC")       = the value entered for VFGEDT("NETLOC")
 ; Output
 ;   None
 ;
 ;  setup the FDA
 S FDA("EDT",2006.1,",1",.03)=VFGEDT("WRTLOC")
 ; passing external values to the call
 D FILE^DIE("E","FDA(""EDT"")")
 S RESULT=$NA(^TMP("DIERR",$J))
 Q
 ;voes/rgg added following function for patient date of birth lookups
DOBLKUP(RESULT,DOB)
 ; Lookup patients by date of birth
 ; RPC:
 ;  VFG DOB LOOKUP
 ; Input:
 ;  Birth date from GUI
 ; Output:
 ;  Listing of patients matching date of birth
 ; First convert date provided into Fileman format
 S %DT="",X=DOB
 D ^%DT
 S DOB=Y
 K %DT
 S XX="",I=0 F  S XX=$O(^DPT("ADOB",Y,XX)) Q:'XX  S I=I+1 S RESULT(I)=XX_"^"_^DPT(XX,0)
 Q
