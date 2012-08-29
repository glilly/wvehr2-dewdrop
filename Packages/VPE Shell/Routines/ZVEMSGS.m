ZVEMSGS ;DJB,VSHL**VShell Global - System QWIKs ; 12/15/00 10:44pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
SYSTEM ;Load the System QWIKs
 NEW I,QWIK,TYPE,TXT,VEN
 KILL ^%ZVEMS("QS")
 S ^%ZVEMS("QS")="System QWIK COMMANDs"
 S ^%ZVEMS("QU")="User QWIK COMMANDs"
 F I=1:1 S TXT=$T(QWIK+I) Q:$P(TXT,";",3)="***"  S QWIK=$P(TXT,";",3),TYPE=$P(TXT,";",4) D
 . I TYPE="D" S ^%ZVEMS("QS",QWIK,"DSC")=$P(TXT,";",5,999)
 . I TYPE="C" S ^%ZVEMS("QS",QWIK)=$P(TXT,";",5,999) ;Code
 . I TYPE?1.N S ^%ZVEMS("QS",QWIK,TYPE)=$P(TXT,";",5,999) ;Vendor specific code
 Q
 ;
QWIK ;System QWIK Commands
 ;;ASCII;D;ASCII Table^^3
 ;;ASCII;C;D ASCII^%ZVEMST
 ;;CAL;D;Calendar Display^%1=Number of Starting Month^3
 ;;CAL;C;D CALENDAR^%ZVEMST
 ;;CLH;D;Resequence Command Line History^^2
 ;;CLH;C;D CLH^%ZVEMSY1
 ;;DIC;D;Fileman DIC Look-up Template^^4
 ;;DIC;C;D DICCALL^%ZVEMSU1
 ;;DTMVT;D;Reset VT-100 in DataTree^^2
 ;;DTMVT;C;Q:VEE("OS")'=9  Q:VEE("IO")'=1  U 1:VT=1
 ;;E;D;Routine Editor^%1=Rtn Name^3
 ;;E;C;X ^%ZVEMS("E")
 ;;FMC;D;Fileman Calls^^4
 ;;FMC;C;D ^%ZVEMSF
 ;;FMTI;D;Fileman Input Template Display^^4
 ;;FMTI;C;D DIET^%ZVEMSU1
 ;;FMTP;D;Fileman Print Template Display^^4
 ;;FMTP;C;D DIPT^%ZVEMSU1
 ;;FMTS;D;Fileman Sort Template Display^^4
 ;;FMTS;C;D DIBT^%ZVEMSU1
 ;;KEY;D;Display Escape Sequence for any Key^^3
 ;;KEY;C;D KEY^%ZVEMSU1
 ;;LBRY;D;Routine Library^%1=ON/OFF %2=Module (L/V)^3
 ;;LBRY;C;D ^%ZVEMRLM
 ;;LF;D;VA KERNEL Library Functions^^4
 ;;LF;C;D ^%ZVEMSL
 ;;NOTES;D;VPE Programmer Notes^^3
 ;;NOTES;C;D HELP^%ZVEMKT("NOTES")
 ;;PARAM;D;System Parameters^^2
 ;;PARAM;C;D ^%ZVEMSP
 ;;PUR;D;Purge VShell Temp Storage Area - %ZVEMS("%")^%1=Number of days to preserve^2
 ;;PUR;C;D PURGE^%ZVEMSU
 ;;PURVGL;D;Purge Command Line History (VGL)^^2
 ;;PURVGL;C;KILL ^%ZVEMS("CLH",VEE("ID"),"VGL")
 ;;PURVRR;D;Purge Command Line History (VRR)^^2
 ;;PURVRR;C;KILL ^%ZVEMS("CLH",VEE("ID"),"VRR")
 ;;PURVEDD;D;Purge Command Line History (VEDD)^^2
 ;;PURVEDD;C;KILL ^%ZVEMS("CLH",VEE("ID"),"VEDD")
 ;;PURVSHL;D;Purge Command Line History (VShell)^^2
 ;;PURVSHL;C;KILL ^%ZVEMS("CLH",VEE("ID"),"VSHL")
 ;;QB;D;Assign QWIK to Display Box^^1
 ;;QB;C;D BOX^%ZVEMSQU
 ;;QC;D;Copy a QWIK^^1
 ;;QC;C;D COPY^%ZVEMSQU
 ;;QD;D;Delete a QWIK^^1
 ;;QD;C;D DELETE^%ZVEMSQU
 ;;QE;D;Add/Edit a QWIK^^1
 ;;QE;C;S VEESHC="<TAB>" D ^%ZVEMSQ
 ;;QL1;D;List User QWIKs & Description^^1
 ;;QL1;C;S VEESHC="<F1-1>" D ^%ZVEMSQ
 ;;QL2;D;List User QWIKs & Code^^1
 ;;QL2;C;S VEESHC="<F1-2>" D ^%ZVEMSQ
 ;;QL3;D;List System QWIKs & Description^^1
 ;;QL3;C;S VEESHC="<F1-3>" D ^%ZVEMSQ
 ;;QL4;D;List System QWIKs & Code^^1
 ;;QL4;C;S VEESHC="<F1-4>" D ^%ZVEMSQ
 ;;QSAVE;D;Save/Restore User QWIKs^^1
 ;;QSAVE;C;D SAVE^%ZVEMSS
 ;;QV;D;Add Vendor Specific Code^^1
 ;;QV;C;D VENDOR^%ZVEMSQV
 ;;QVL;D;List Vendor Specific Code^^1
 ;;QVL;C;D VENLIST^%ZVEMSQW
 ;;UL;D;List Users DUZ/ID^^2
 ;;UL;C;D LIST^%ZVEMSID
 ;;VEDD;D;VElectronic Data Dictionary^^3
 ;;VEDD;C;D PARAM^%ZVEMD(%1,%2,%3)
 ;;VER;D;VShell Version Information^^2
 ;;VER;C;D VERSION^%ZVEMSU2
 ;;VGL;D;VGlobal Lister^^3
 ;;VGL;C;D PARAM^%ZVEMG(%1)
 ;;VRR;D;VRoutine Reader^^3
 ;;VRR;C;D PARAM^%ZVEMR(%1)
 ;;XQH;D;Help Text for Kernel Menu Options^%1=Kernel Menu Option^4
 ;;XQH;C;D XQH^%ZVEMST
 ;;ZD;D;KILL variables whose names start with these letters^%1=letters %2=letters ...^3
 ;;ZD;C;D ^%ZVEMSD
 ;;ZP;D;ZPrint a Routine^%1=Rtn Name^3
 ;;ZP;C;D ZPRINT^%ZVEMSU2
 ;;ZR;D;ZRemove 1 to 9 Routines^%1=Rtn Name  %2=Rtn Name ...^3
 ;;ZR;C;Q:'$$ZREMOVE^%ZVEMSU2()  NEW I,X F I=1:1:9 S X=@("%"_I) Q:X']""  ZR  ZS @X W !?2,X," Removed..."
 ;;ZW;D;ZWrite Symbol Table^%1=Starting letter^3
 ;;ZW;C;D WRITE^%ZVEMSPS(%1)
 ;;***
