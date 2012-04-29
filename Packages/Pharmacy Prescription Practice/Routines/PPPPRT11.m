PPPPRT11 ;ALB/JFP - DISPLAY LOG FILE ENTRIES ; 3/20/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; -- This routine displays entries in the PPP Log file
 ;
DSPLOG(IDATE) ; -- List processor entry point
 ;
 ; This is the main entry point for calling the list manager
 ;
 ; Parameters:
 ;  IDATE - The the report will start displaying data from.
 ;
 N LSTARRAY,IDXARRAY,VALMCNT,STRTDTE
 ;
 ;
 S STRTDTE=IDATE
 S Y=STRTDTE D DD^%DT S BDATE=Y
 S Y=DT D DD^%DT S EDATE=Y
 ;
 K XQORS,VALMEVL
 D EN^VALM("PPP LOG DISPL")
 Q
 ;
INIT ; -- Collects all the data and builds the display array
 ;
 N X,Y,CNT,LOGDFN,LOGND,RTN,MSG,ICODE,CODE,DATE
 N IUSER,EUSER,USER,TXTLINE
 ;
 ;
 S LSTARRAY="^TMP(""PPPL5"",$J)"
 S IDXARRAY="^TMP(""PPPIDX"",$J)"
 ;
 K @LSTARRAY,@IDXARRAY
 ;
 S (VALMCNT,CNT)=0
 W !!,"Building display...this may take a moment"
 F  D  D:CNT=0 NUL Q:(IDATE="")
 .S IDATE=$O(^PPP(1020.4,"C",IDATE)) Q:IDATE=""
 .S LOGDFN=0
 .F  D  Q:(LOGDFN="")
 ..S LOGDFN=$O(^PPP(1020.4,"C",IDATE,LOGDFN)) Q:LOGDFN=""
 ..S LOGND(0)=$G(^PPP(1020.4,LOGDFN,0))
 ..S RTN=$G(^PPP(1020.4,LOGDFN,1))
 ..S MSG=$G(^PPP(1020.4,LOGDFN,2))
 ..S ICODE=$P(LOGND(0),"^",1),CODE=""
 ..S:ICODE'="" CODE=$P($G(^PPP(1020.6,ICODE,0)),"^",2)
 ..S Y=$P(LOGND(0),"^",3)
 ..D DD^%DT S DATE=Y
 ..S IUSER=$P(LOGND(0),"^",4),EUSER=""
 ..S:IUSER'="" USER=$P($G(^VA(200,IUSER,0)),"^",1)
 ..D SETD
 Q
 ;
HDR ; -- Builds Header
 S VALMHDR(1)=""
 S VALMHDR(2)="Data extracted for "_BDATE_" to "_EDATE
 Q
 ;
NUL ; -- Sets null message
 ;
 S @LSTARRAY@(1,0)=""
 S @LSTARRAY@(2,0)=" No entries found for "_BDATE_" to "_EDATE
 S @LSTARRAY@(3,0)=""
 S @LSTARRAY@(4,0)=" Press <RETURN> to continue"
 S VALMCNT=4
 Q
FNL ; -- Clean up
 ;
 K @LSTARRAY,@IDXARRAY
 K IDATE,BDATE,EDATE
 Q
 ;
SETD ; -- Sets up display for line for list processor
 S TXTLINE=" "
 S CNT=CNT+1
 S TXTLINE=$$SETFLD^VALM1(""_DATE,TXTLINE,"DATE")
 S TXTLINE=$$SETFLD^VALM1(USER,TXTLINE,"USER")
 S TXTLINE=$$SETFLD^VALM1(RTN,TXTLINE,"ROUTINE")
 D SETL
 S TXTLINE=$$SETSTR^VALM1(CODE_"  "_MSG,"",1,79)
 D SETL
 S TXTLINE=$$SETSTR^VALM1(" ","",1,79)
 D SETL
 Q
 ;
SETL ; -- Sets up list manager display array
 S VALMCNT=VALMCNT+1
 S @LSTARRAY@(VALMCNT,0)=$E(TXTLINE,1,79)
 S @LSTARRAY@("IDX",VALMCNT,CNT)=""
 S @IDXARRAY@(CNT)=VALMCNT
 Q
 ;
END ; -- End of code
 Q
 ;
