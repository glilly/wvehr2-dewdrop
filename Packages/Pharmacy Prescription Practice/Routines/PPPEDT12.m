PPPEDT12 ;ALB/JFP - EDIT FF XREF ROUTINE ;5/19/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; These routines control the display of foreign facility 
 ; data via the list processor.
 ;
DSPFF(PATDFN) ; List processor entry point
 ;
 ; This is the main entry point for calling the list processor.
 ;
 ; Parameters:
 ;  PATDFN - The patient internal entry number
 ;
 N ARRAYNM,LSTARRAY,IDXARRAY,VALMCNT
 ;
 K XQORS,VALMEVL
 D EN^VALM("PPP XREF EDIT")
 Q
 ;
INIT ; Collect all of the data and build the display array
 ;
 N FFXIFN,PPPCNT,ERR
 ;
 S ARRAYNM="^TMP(""PPPTMP"",$J)"
 S LSTARRAY="^TMP(""PPPL1"",$J)"
 S IDXARRAY="^TMP(""PPPIDX"",$J)"
 ;
 K @ARRAYNM,@LSTARRAY,@IDXARRAY
 ;
 S (VALMCNT,PPPCNT)=0
 S FFXIFN=""
 I '$D(^PPP(1020.2,"B",PATDFN)) D NUL Q
 F  S FFXIFN=$O(^PPP(1020.2,"B",PATDFN,FFXIFN))  Q:FFXIFN=""  D
 .S ERR=$$GETFFX^PPPGET1(FFXIFN,ARRAYNM)
 .I ERR<0 D  Q
 ..W !,*7,"An Unexpected Error Occurred...check error log"
 ..R !,"Press <RETURN> to exit...",TMP:DTIME
 ..S TMP=$$LOGEVNT^PPPMSC1(ERR,"INIT_PPPEDT12","GETFFX")
 .E  D
 ..; - Format data for display 
 ..S PPPCNT=$$SETD(FFXIFN,ARRAYNM,PPPCNT)
 ..I PPPCNT<1 D NUL
 Q
 ;
HDR ; Get header data and build it.
 ;
 N DIC,DA,DR,DIQ,DUOUT,DTOUT,PPPTMP
 S DIC="^DPT(",DA=PATDFN,DR=".01;.03;.09",DIQ="PPPTMP" D EN^DIQ1
 S VALMHDR(1)=""
 S VALMHDR(2)="Patient: "_PPPTMP(2,PATDFN,.01)_" ("_PPPTMP(2,PATDFN,.09)_")      DOB: "_PPPTMP(2,PATDFN,.03)
 Q
 ;
NUL ; Set null message
 ;
 S @LSTARRAY@(1,0)=" "
 S @LSTARRAY@(2,0)=" No Data found for the patient entered..."
 S @LSTARRAY@(3,0)=""
 S @LSTARRAY@(4,0)=" Select <AE> - Add Entry to make a NEW entry or <RETURN> to quit"
 S VALMCNT=4
 Q
 ;
FNL ; Clean Up
 ;
 K @ARRAYNM,@LSTARRAY,@IDXARRAY
 K PPPPNM
 K DIC,DIE,DR,DA
 Q
 ;
SETD(FFXIFN,TARRY,CNT) ; Sets up display line for list processor
 ;
 N PARMERR,TXTLINE
 ;
 S PARMERR=-9001
 ;
 I '$D(TARRY) Q PARMERR
 I '$D(CNT) Q PARMERR
 I '$D(@TARRY@(FFXIFN)) Q PARMERR
 ;
 S TXTLINE=" "
 S CNT=CNT+1
 S TXTLINE=$$SETFLD^VALM1(CNT,TXTLINE,"ENTRY")
 S TXTLINE=$$SETFLD^VALM1($G(@TARRY@(FFXIFN,"POV")),TXTLINE,"INST")
 S TXTLINE=$$SETFLD^VALM1($G(@TARRY@(FFXIFN,"DOMAIN")),TXTLINE,"DOMAIN")
 S TXTLINE=$$SETFLD^VALM1($G(@TARRY@(FFXIFN,"LVD")),TXTLINE,"LDATE")
 ;S TXTLINE=$$SETFLD^VALM1($G(@TARRY@(FFXIFN,"ED")),TXTLINE,"EDATE")
 D SETL
 Q CNT
 ;
SETL ; -- Sets up list manager display array
 S VALMCNT=VALMCNT+1
 S @LSTARRAY@(VALMCNT,0)=$E(TXTLINE,1,79)
 S @LSTARRAY@("IDX",VALMCNT,CNT)=""
 S @IDXARRAY@(CNT)=VALMCNT_"^"_FFXIFN_"^"_$G(@TARRY@(FFXIFN,"NAME"))_"^"_$G(@TARRY@(FFXIFN,"STANO"))
 Q
 ;
END ; -- End of code
 Q
 ;
