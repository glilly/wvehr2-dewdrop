PPPEDT13 ;ALB/JFP - EDIT FF XREF ROUTINE ;5/19/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; These routines control the display of foreign facility 
 ; data via the list processor (Expand Entry).
 ;
EXPAND ; -- Displays FFX data for entry
 ;
 N VALMY,SDI,SDAT,FFXIFN,ERR,TMP
 ;
 D EN^VALM2($G(XQORNOD(0)),"S")
 Q:'$D(VALMY)
 S SDI=""
 S SDI=$O(VALMY(SDI))  Q:SDI=""
 S SDAT=$G(@IDXARRAY@(SDI))
 S FFXIFN=$P(SDAT,U,2)
 S ERR=$$EXP^PPPEDT13(FFXIFN)
 S VALMBCK="R"
 Q
 ;
EXP(FFXIFN) ; List processor entry point
 ;
 ; This is the main entry point for calling the list processor.
 ;
 ; Parameters:
 ;  FFXIFN - The FFX internal entry number
 ;
 N ARRAYNM,LSTARRAY,VALMCNT
 ;
 ; K XQORS,VALMEVL ; (only kill on the first screen in)
 D EN^VALM("PPP FFX DISPLAY")
 Q 1
 ;
INIT ; Collect all of the data and build the display array
 ;
 N PPPCNT,ERR,PARMERR
 ;
 S PARMERR=-9001
 S ARRAYNM="^TMP(""PPPTMP"",$J)"
 S LSTARRAY="^TMP(""PPPL2"",$J)"
 ;
 K @ARRAYNM,@LSTARRAY
 ;
 S (VALMCNT)=0
 S ERR=$$GETFFX^PPPGET1(FFXIFN,ARRAYNM)
 I ERR<0 D  Q
 .W !,*7,"An Unexpected Error Occurred...check error log"
 .R !,"Press <RETURN> to exit...",TMP:DTIME
 .S TMP=$$LOGEVNT^PPPMSC1(ERR,"INIT_PPPEDT13","GETFFX")
 E  D
 .; - Format data for display 
 .S VALMCNT=$$SETD(FFXIFN,ARRAYNM,VALMCNT)
 .I VALMCNT<1 D NUL
 Q
 ;
NUL ; Set null message
 S @LSTARRAY@(1,0)=" "
 S @LSTARRAY@(2,0)=" No Data found for the patient entered...<RETURN> to exit"
 S VALMCNT=2
 Q
 ;
FNL ; Clean Up
 ;
 K @ARRAYNM,@LSTARRAY
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
 S TXTLINE=""
 ;S @LSTARRAY@(1,0)="IFN         : "_FFXIFN
 S @LSTARRAY@(1,0)=" "
 S @LSTARRAY@(2,0)="Entry Date  : "_$G(@TARRY@(FFXIFN,"ED"))
 S @LSTARRAY@(3,0)="Entry Source: "_$G(@TARRY@(FFXIFN,"SOURCE"))
 S @LSTARRAY@(4,0)=""
 S TXTLINE=$$SETSTR^VALM1("Patient Name: "_$G(@TARRY@(FFXIFN,"NAME")),"",1,38)
 S TXTLINE=$$SETSTR^VALM1("SSN: "_$G(@TARRY@(FFXIFN,"SSN")),TXTLINE,40,39)
 S @LSTARRAY@(5,0)=TXTLINE,TXTLINE=""
 S TXTLINE=$$SETSTR^VALM1("Station: "_$G(@TARRY@(FFXIFN,"POV")),"",1,38)
 S TXTLINE=$$SETSTR^VALM1("Domain: "_$G(@TARRY@(FFXIFN,"DOMAIN")),TXTLINE,40,39)
 S @LSTARRAY@(6,0)=TXTLINE,TXTLINE=""
 S TXTLINE=$$SETSTR^VALM1("Last Visit Date: "_$G(@TARRY@(FFXIFN,"LVD")),"",1,40)
 S TXTLINE=$$SETSTR^VALM1("Last Batch Request: "_$G(@TARRY@(FFXIFN,"LBRD")),TXTLINE,40,39)
 S @LSTARRAY@(7,0)=TXTLINE,TXTLINE=""
 S TXTLINE=$$SETSTR^VALM1("Last PDX Date: "_$G(@TARRY@(FFXIFN,"LPDX")),"",1,40)
 S TXTLINE=$$SETSTR^VALM1("Status: "_$G(@TARRY@(FFXIFN,"STATUS")),TXTLINE,40,39)
 S @LSTARRAY@(8,0)=TXTLINE
 S CNT=CNT+8
 Q CNT
 ;
SETL ; -- Sets up list manager display array
 S VALMCNT=VALMCNT+1
 S @LSTARRAY@(VALMCNT,0)=$E(TXTLINE,1,79)
 Q
 ;
