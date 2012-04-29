PPPDSP3 ;ALB/DMB - MEDICATION PROFILE DISPLAY ROUTINE ;5/19/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**1,17**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; These routines control the display of the pharmacy medication
 ; profiles via the list processor from scheduling.
 ;
DSPMED(PATDFN,ARRAYNM,OBFLAG) ; List processor entry point
 ;
 ; This is the main entry point for calling the list processor.
 ;
 ; Parameters:
 ;  PATDFN - The patient internal entry number
 ;  ARRAYNM - An array containing the visit info (see GETVIS^PPPGET7).
 ;  OBFLAG - A flag containing "O" for profiles form only the other
 ;           facilities or "B" for profiles from both local and other.
 ;
 ;K XQORS,VALMEVL
 D EN^VALM("PPP PROFILE")
 Q
 ;
INIT ; Collect all of the data and build the display array
 ;
 S VALMMENU=0
 S VALMCNT=$$PRPROFIL(ARRAYNM)
 I VALMCNT<1 D NUL
 I OBFLAG="O" S VALM("TITLE")="Medication Profile - Other"
 I OBFLAG="B" S VALM("TITLE")="Medication Profile - Both"
INITQ Q
 ;
HDR ; Get header data and build it.
 ;
 N DIC,DA,DR,DIQ,DUOUT,DTOUT,PPPTMP
 S DIC="^DPT(",DA=PATDFN,DR=".01;.03;.09",DIQ="PPPTMP" D EN^DIQ1
 S VALMHDR(1)=""
 S VALMHDR(2)="Patient: "_PPPTMP(2,PATDFN,.01)_" ("_PPPTMP(2,PATDFN,.09)_")      DOB: "_PPPTMP(2,PATDFN,.03)
HDRQ Q
 ;
NUL ; Set null message
 ;
 ;I '$O(@ARRAYNM@(0)) S @ARRAYNM@(1,0)=" ",@ARRAYNM@(2,0)="    No Data Available.",VALMCNT=2
 S @ARRAYNM@(1,0)=" ",@ARRAYNM@(2,0)="    No Data Available.",VALMCNT=2
 Q
 ;
FNL ; Clean Up
 ;
 K ^TMP("PPP",$J,"LIST")
 Q
 ;
PRPROFIL(ARRAYNM) ; Print the med profile
 ;
 ; This function collects the medication profile data and formats it
 ; for display.
 ;
 ; Parameters:
 ;  ARRAYNM - An array containing the visit info (see GETVIS^PPPGET7).
 ;
 N ND,PHRMARRY,RVRSDT,RXIDX,STANAME,STAPTR,TMP,Y,LSTARRAY
 N TEXT,TXTLINE,U,LINE
 ;
 S PHRMARRY="^TMP(""PPP"",$J,""PHR"")"
 S LSTARRAY="^TMP(""PPP"",$J,""LIST"")"
 S U="^"
 S LINE=0
 ;
 ; Get the prescription data
 ;
 I OBFLAG="B" S TMP=$$GLPHRM^PPPGET8(PATDFN,PHRMARRY)
 S TMP=$$GETPDX^PPPGET2(ARRAYNM,PHRMARRY)
 ;
 ; If there is anything to print... print it.
 ;
 I $D(@PHRMARRY) D NARRATIV
 K @PHRMARRY
 Q LINE
 ;
NARRATIV ; Print the narratives
 ;
 S LINE=0
 S TEXT=""
 S STANAME=""
 I $D(@PHRMARRY@(0)) D
 .F  S STANAME=$O(@PHRMARRY@(0,STANAME)) Q:STANAME=""  D
 ..S LINE=LINE+1
 ..S @LSTARRAY@(LINE,0)=$$SETSTR^VALM1("NARRATIVE FROM "_STANAME,TEXT,1,80)
 ..S LINE=LINE+1
 ..I $L(@PHRMARRY@(0,STANAME))<70 D
 ...S @LSTARRAY@(LINE,0)=$$SETSTR^VALM1("  => "_@PHRMARRY@(0,STANAME),TEXT,1,80)
 ..E  D
 ...S @LSTARRAY@(LINE,0)=$$SETSTR^VALM1("  => "_$E(@PHRMARRY@(0,STANAME),1,70)_"...",TEXT,1,80)
 ..S LINE=LINE+1,@LSTARRAY@(LINE,0)=""
 ;
 S RVRSDT=0
 F  S RVRSDT=$O(@PHRMARRY@(RVRSDT)) Q:RVRSDT'>0  D
 .S STAPTR=0
 .F  S STAPTR=$O(@PHRMARRY@(RVRSDT,STAPTR)) Q:STAPTR=""  D
 ..S RXIDX=-1
 ..F  S RXIDX=$O(@PHRMARRY@(RVRSDT,STAPTR,RXIDX)) Q:RXIDX=""!(RXIDX="PID")  D
 ...S ND=$G(@PHRMARRY@(RVRSDT,STAPTR,RXIDX)) Q:ND=""
 ...S LINE=LINE+1
 ...S TXTLINE=$$SETFLD^VALM1($P(ND,U),TEXT,"RX#")
 ...S TXTLINE=$$SETFLD^VALM1($P(ND,U,2),TXTLINE,"DRUG")
 ...S TXTLINE=$$SETFLD^VALM1($P(ND,U,3),TXTLINE,"STATUS")
 ...S TXTLINE=$$SETFLD^VALM1($P(ND,U,4),TXTLINE,"QTY")
 ...S TXTLINE=$$SETFLD^VALM1($$SLASHDT^PPPCNV1($P(ND,U,5)),TXTLINE,"ISSUED")
 ...S TXTLINE=$$SETFLD^VALM1($$SLASHDT^PPPCNV1($P(ND,U,6)),TXTLINE,"LAST FILLED")
 ...S @LSTARRAY@(LINE,0)=TXTLINE
 ...S LINE=LINE+1
 ...S TXTLINE=$$SETSTR^VALM1("SIG: "_$E($P(ND,U,7),1,25),TEXT,9,30)
 ...S TXTLINE=$$SETSTR^VALM1("ISSUED AT "_$P(ND,U,8)_" ("_$P(ND,U,9)_")",TXTLINE,40,39)
 ...S @LSTARRAY@(LINE,0)=TXTLINE
 ...S LINE=LINE+1
 ...S @LSTARRAY@(LINE,0)=$$SETSTR^VALM1("PROVIDER: "_$P(ND,U,10),TEXT,9,70)
 K @PHRMARRY
 Q
 ;
