IBCNERP9 ;DAOU/BHS - IIV STATISTICAL REPORT PRINT ;12-JUN-2002
 ;;2.0;INTEGRATED BILLING;**184,271**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; IIV - Insurance Identification and Verification Interface
 ;
 ; Input variables from IBCNERP7:
 ;  IBCNERTN = "IBCNERP7"
 ; **IBCNESPC array ONLY passed by reference
 ;  IBCNESPC("BEGDTM") = Start Date/Time for date/time report range
 ;  IBCNESPC("ENDDTM") = End Date/Time for date/time report range
 ;  IBCNESPC("SECTS") = 1 - All, includes all sections OR
 ;   list of one or more of the following:
 ;   2 - Outgoing Data, Inquiry Transmission data,
 ;   3 - Incoming Data, Inquiry Response data,
 ;   4 - General Data, Insurance Buffer data,
 ;   Communication Failures, Outstanding Inquiries
 ;   IBCNESPC("MM") = "", do not generate MailMan message OR
 ;                    MAILGROUP, mailgroup to send MailMan message to
 ;                               based on IB site parameter
 ;   Assumes report data exists in ^TMP($J,IBCNERTN,...)
 ;   Based on IBCNESPC("SECTS") parameter the following scratch globals
 ;   will be built
 ;   1 OR contains 2 --> 
 ;    ^TMP($J,RTN,"OUT")=TotInq^InsBufExtSubtotal^PreRegExtSubtotal^...
 ;                       NonVerifInsExtSubtotal^NoActInsExtSubtotal
 ;   1 OR contains 3 --> 
 ;    ^TMP($J,RTN,"IN")=TotResp^InsBufExtSubtotal^PreRegExtSubtotal^...
 ;                       NonVerifInsExtSubtotal^NoActInsExtSubtotal
 ;   1 OR contains 4 --> 
 ;    ^TMP($J,RTN,"CUR")=TotOutstandingInq^TotInqRetries^...
 ;                       TotInqCommFailure^TotInsBufVerified^...
 ;                       ManVerifedSubtotal^IIVProcessedSubtotal...
 ;                       TotInsBufUnverified^! InsBufSubtotal^...
 ;                       ? InsBufSubtotal^- InsBufSubtotal^...
 ;                       Other InsBufSubtotal^TQReadyToTransmit^...
 ;                       TQHold^TQRetry
 ;    and ^TMP($J,RTN","PYR",PAYER NAME,IEN of file 365.12)=""
 ;
 ; Must call at EN
 Q
 ;
EN(IBCNERTN,IBCNESPC) ; Entry pt
 ;
 ; Init vars
 N CRT,MAXCNT,IBPXT,IBPGC,IBBDT,IBEDT,IBSCT,IBMM,RETRY,OUTINQ,ATTEMPT
 N X,Y,DIR,DTOUT,DUOUT,LIN
 ;
 S IBBDT=$G(IBCNESPC("BEGDTM")),IBEDT=$G(IBCNESPC("ENDDTM"))
 S IBSCT=$G(IBCNESPC("SECTS")),IBMM=$G(IBCNESPC("MM"))
 ;
 S (IBPXT,IBPGC,CRT,MAXCNT)=0
 ;
 ; Determine IO parameters if output device is NOT MailMan message
 I IBMM="" D
 . I IOST["C-" S MAXCNT=IOSL-3,CRT=1 Q
 . S MAXCNT=IOSL-6,CRT=0
 ;
 D PRINT(IBCNERTN,IBBDT,IBEDT,IBSCT,IBMM,.IBPGC,.IBPXT,MAXCNT,CRT)
 I $G(ZTSTOP)!IBPXT G EXIT
 I CRT,IBPGC>0,'$D(ZTQUEUED) D  G EXIT
 . I MAXCNT<51 F LIN=1:1:(MAXCNT-$Y) W !
 . S DIR(0)="E" D ^DIR K DIR
 ;
EXIT ; Exit pt
 Q
 ;
 ;
PRINT(RTN,BDT,EDT,SCT,MM,PGC,PXT,MAX,CRT) ; Print data
 ; Init vars
 N EORMSG,NONEMSG,LINECT,DISPDATA,HDRDATA,OFFSET,TMP,DTMRNG,SITE
 ;
 S LINECT=0
 ;
 ; Build End-Of-Report Message for display
 S EORMSG="*** END OF REPORT ***"
 S OFFSET=80-$L(EORMSG)\2
 S EORMSG=$$FO^IBCNEUT1(EORMSG,OFFSET+$L(EORMSG),"R")
 ; Build No-Data-Found Message for display
 S NONEMSG="* * * N O  D A T A  F O U N D * * *"
 S OFFSET=80-$L(NONEMSG)\2
 S NONEMSG=$$FO^IBCNEUT1(NONEMSG,OFFSET+$L(NONEMSG),"R")
 ; Build Site for display
 S SITE=$P($$SITE^VASITE,U,2)
 ; Build Date/Time Range for display
 ;  Build Date/Time display for Starting date/time
 S TMP=$$FMTE^XLFDT(BDT,"5Z")
 S DTMRNG=$P(TMP,"@")_" "_$P(TMP,"@",2)
 ;  Calculate Date/Time display for Ending date/time
 S TMP=$$FMTE^XLFDT(EDT,"5Z")
 S DTMRNG=DTMRNG_" - "_$P(TMP,"@")_" "_$P(TMP,"@",2)
 ;
 ; Print header to DISPDATA for MailMan message ONLY
 D HEADER^IBCNERP0(.HDRDATA,.PGC,.PXT,MAX,CRT,SITE,DTMRNG,MM)
 I MM'="" M DISPDATA=HDRDATA S LINECT=+$O(DISPDATA(""),-1)
 I MM="" KILL HDRDATA
 ;
 ; If global does not exist - display No Data message
 I '$D(^TMP($J,RTN)) S LINECT=LINECT+1,DISPDATA(LINECT)=NONEMSG G PRINT2
 ;
 ; Display Outgoing Data - if selected
 I SCT=1!(SCT[2) D  I PXT!$G(ZTSTOP) G PRINTX
 . ; Build lines of data to display
 . D DATA(.DISPDATA,.LINECT,RTN,"OUT",MM)
 ;
 ; Display Incoming Data - if selected
 I SCT=1!(SCT[3) D  I PXT!$G(ZTSTOP) G PRINTX
 . ; Build lines of data to display
 . D DATA(.DISPDATA,.LINECT,RTN,"IN",MM)
 ;
 ; Display General Data - if selected
 I SCT=1!(SCT[4) D  I PXT!$G(ZTSTOP) G PRINTX
 . ; Build lines of data to display
 . D DATA(.DISPDATA,.LINECT,RTN,"CUR",MM)
 . D DATA(.DISPDATA,.LINECT,RTN,"PYR",MM)
 ;
PRINT2 S LINECT=LINECT+1
 S DISPDATA(LINECT)=EORMSG
 ;
 I MM="" D LINE(.DISPDATA,.PGC,.PXT,MAX,CRT,SITE,DTMRNG,MM)
 ; Generate MailMan message, if flag is set
 I MM'="" D MSG^IBCNEUT5(MM,"** IIV Statistical Rpt **","DISPDATA(")
 ;
PRINTX ; PRINT exit pt
 Q
 ;
LINE(DISPDATA,PGC,PXT,MAX,CRT,SITE,DTMRNG,MM) ; Print line of data
 ; Init vars
 N CT,II,ARRAY,NWPG
 ;
 S NWPG=0
 S CT=+$O(DISPDATA(""),-1)
 I $Y+1+CT>MAX,PGC>1 D HEADER^IBCNERP0(.ARRAY,.PGC,.PXT,MAX,CRT,SITE,DTMRNG,MM) S NWPG=1 I PXT!$G(ZTSTOP) G LINEX
 F II=1:1:CT D  Q:PXT!$G(ZTSTOP)
 . I $Y+1>MAX!('PGC) D HEADER^IBCNERP0(.ARRAY,.PGC,.PXT,MAX,CRT,SITE,DTMRNG,MM) S NWPG=1 I PXT!$G(ZTSTOP) Q
 . I 'NWPG!(NWPG&(DISPDATA(II)'="")) W !,?1,DISPDATA(II)
 . I NWPG S NWPG=0
 ;
LINEX ; LINE exit pt
 Q
 ;
DATA(DISPDATA,LINECT,RTN,TYPE,MM) ; Format lines of data to be printed
 ; Init vars
 N DASHES,DASHES2,PEND,RPTDATA,CT,DEFINQ,INSCOS,PAYERS,QUEINQ,TXT
 ;
 S $P(DASHES,"=",15)=""
 I LINECT>0,MM="" S LINECT=LINECT+1,DISPDATA(LINECT)=""
 S LINECT=LINECT+1
 S DISPDATA(LINECT)=$S(TYPE="OUT":"Outgoing Data",TYPE="IN":"Incoming Data",1:"Current Status")
 S LINECT=LINECT+1
 S DISPDATA(LINECT)=DASHES
 ; Copy report data to local variable
 S RPTDATA=$G(^TMP($J,RTN,TYPE))      ; does not work for "PYR"
 ; Outgoing and Incoming Totals
 I TYPE="OUT"!(TYPE="IN") D  G DATAX
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1($S(TYPE="OUT":"Inquiries Sent:",1:"Responses Received:"),36)_$$FO^IBCNEUT1(+$P(RPTDATA,U,1),9,"R")
 . F CT=1:1:4 D
 . . S TYPE="  "_$S(CT=1:"Insurance Buffer",CT=2:"Appointment",CT=3:"Non-verified Insurance",1:"No Active Insurance")
 . . S LINECT=LINECT+1
 . . S DISPDATA(LINECT)=$$FO^IBCNEUT1(TYPE,46)_$$FO^IBCNEUT1(+$P(RPTDATA,U,CT+1),9,"R")
 ;
 ; General Data
 I TYPE="CUR" D  G DATAX
 . ; Responses Pending
 . S PEND=+$P(RPTDATA,U,1)
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("Responses Pending:",36)_$$FO^IBCNEUT1(PEND,9,"R")
 . ; Queued Inqs
 . S QUEINQ=+$P(RPTDATA,U,2)
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("Queued Inquiries:",36)_$$FO^IBCNEUT1(QUEINQ,9,"R")
 . ; Deferred Inqs
 . S DEFINQ=+$P(RPTDATA,U,3)
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("Deferred Inquiries:",36)_$$FO^IBCNEUT1(DEFINQ,9,"R")
 . ; Ins Cos w/o Nat ID
 . S INSCOS=+$P(RPTDATA,U,4)
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("Insurance Companies w/o National ID:",36)_$$FO^IBCNEUT1(INSCOS,9,"R")
 . ; Payers disabled locally
 . S PAYERS=+$P(RPTDATA,U,5)
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("eIIV Payers Disabled Locally:",36)_$$FO^IBCNEUT1(PAYERS,9,"R")
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=""
 . ; Insurance Buffer statistics
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("Insurance Buffer Entries: ",36)_$$FO^IBCNEUT1(($P(RPTDATA,U,6)+$P(RPTDATA,U,9)),9,"R")
 . ; *,+,#,! or -  symbol entries - User action required
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("  User Action Required: ",46)_$$FO^IBCNEUT1(+$P(RPTDATA,U,6),9,"R")
 . F CT=7,8,13,10,11 D
 . . S LINECT=LINECT+1
 . . ; Added # to report
 . . S TYPE="    # of "
 . . I CT=7 S TXT="* entries (User Verified policy)"
 . . I CT=8 S TXT="+ entries (Payer indicated Active policy)"
 . . I CT=10 S TXT="# entries (Policy status undetermined)"
 . . I CT=11 S TXT="! entries (IIV needs user assistance for entry)"
 . . I CT=13 S TXT="- entries (Payer indicated Inactive policy)"
 . . S TYPE=TYPE_TXT
 . . S DISPDATA(LINECT)=$$FO^IBCNEUT1(TYPE,56)_$$FO^IBCNEUT1(+$P(RPTDATA,U,CT),9,"R")
 . ;
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("  Entries Awaiting Processing: ",46)_$$FO^IBCNEUT1(+$P(RPTDATA,U,9),9,"R")
 . ; Subtotal of ? entries (IIV is waiting for a response)
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("    # of ? entries (IIV is waiting for a response)",56)_$$FO^IBCNEUT1(+$P(RPTDATA,U,12),9,"R")
 . ; Subtotal of blank entries (yet to be processed or accepted)
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)=$$FO^IBCNEUT1("    # of blank entries (yet to be processed or accepted)",56)_$$FO^IBCNEUT1(+$P(RPTDATA,U,14),9,"R")
 ;
 ; New Payers added to File 365.12
 I TYPE="PYR" D  G DATAX
 . ; Payers added to file 365.12
 . D DATAX
 . S LINECT=LINECT+1
 . S DISPDATA(LINECT)="New eIIV Payers received during report date range:"
 . S LINECT=LINECT+1
 . I '$D(^TMP($J,RTN,TYPE)) S DISPDATA(LINECT)="    No new Payers added" Q
 . S DISPDATA(LINECT)="  Please link the associated active insurance companies to these payers at your"
 . S LINECT=LINECT+1,DISPDATA(LINECT)="  earliest convenience.  Locally activate the payers after you link insurance"
 . S LINECT=LINECT+1,DISPDATA(LINECT)="  companies to them.  For further details regarding this process, please refer"
 . S LINECT=LINECT+1,DISPDATA(LINECT)="  to the Integrated Billing IIV Interface User Guide."
 . N PYR,PIEN
 . S PYR="",PIEN="" F  S PYR=$O(^TMP($J,RTN,TYPE,PYR)) Q:PYR=""  D
 . . F  S PIEN=$O(^TMP($J,RTN,TYPE,PYR,PIEN)) Q:'PIEN  S LINECT=LINECT+1,DISPDATA(LINECT)="    "_PYR
 ;
DATAX ; DATA exit pt
 S LINECT=LINECT+1
 S DISPDATA(LINECT)=""
 Q
 ;
 ;
