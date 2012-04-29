ORRDI2 ; SLC/JMH - RDI routine for user interface and data cleanup; 3/24/05 2:31 ; 1/11/07 8:12am
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**232**;Dec 17, 1997;Build 19
 ;
SET ;utility to set RDI related parameters
 I '$$PATCH^XPDUTL("OR*3.0*238") D  Q
 . W !,"This menu is locked until patch OR*3.0*238 is installed."
 N QUIT,QUITALL
 W !!,"Sets System wide parameters to control order checking against"
 W !,"  remote data",!
 F  Q:$G(QUIT)!($G(QUITALL))  D
 . N VAL,VALEXT,DIR,DTOUT,Y
 . S VAL=$$GET^XPAR("SYS","OR RDI HAVE HDR")
 . S VALEXT="NO" I VAL=1 S VALEXT="YES"
 . S DIR("A")="HAVE AN HDR"
 . S DIR("B")=VALEXT
 . S DIR("?")="^D HELP1^ORRDI2"
 . S DIR(0)="Y"
 . D ^DIR
 . I $G(Y)="^"!($G(DTOUT)) S QUITALL=1
 . I $G(Y)=1!($G(Y)=0) S QUIT=1 D
 . . D EN^XPAR("SYS","OR RDI HAVE HDR",,Y)
 I $G(QUITALL) Q
 I '$$GET^XPAR("SYS","OR RDI HAVE HDR") Q
 S QUIT=0
 F  Q:$G(QUIT)!($G(QUITALL))  D
 . N VAL,VALEXT,DIR,DTOUT,Y
 . S VAL=$$GET^XPAR("SYS","OR RDI CACHE TIME")
 . S VALEXT=$G(VAL,0)
 . S DIR("A")="CACHE TIME (Minutes)"
 . S DIR("B")=VALEXT
 . S DIR("?")="^D HELP3^ORRDI2"
 . S DIR(0)="N^0:9999:0"
 . D ^DIR
 . I $G(Y)="^"!($G(DTOUT)) S QUITALL=1
 . I $G(Y)>-1 S QUIT=1 D
 . . D EN^XPAR("SYS","OR RDI CACHE TIME",,Y)
 Q
HELP1 ;
 W "Set this to ""YES"" if this system has an HDR system that"
 W !,"  it uses to access remote data."
 Q
HELP3 ;
 W "Set this to the number of minutes that the retrieved data is "
 W !,"  to be considered valid for order checking purposes."
 Q
LIST ;
 W !
 W $$GET^XPAR("SYS","OR RDI HAVE HDR")," "
 W $$GET^XPAR("SYS","OR RDI CACHE TIME")
 Q
CLEANUP ;
 N VAL,NOW,THRESH,DOM,DFN,TIME
 S VAL=$$GET^XPAR("SYS","OR RDI CACHE TIME")
 S NOW=$$NOW^XLFDT
 S THRESH=$$FMADD^XLFDT(NOW,,,-VAL)
 S DFN=0
 F DOM="PSOO","ART" F  S DFN=$O(^XTMP("ORRDI",DOM,DFN)) Q:'DFN  D
 . S TIME=$G(^XTMP("ORRDI",DOM,DFN,0))
 . I TIME<THRESH K ^XTMP("ORRDI",DOM,DFN)
 ; checking if OUTAGE task crashed or hasn't completed successfully
 I $$DOWNXVAL D
 .I $$FMDIFF^XLFDT($$NOW^XLFDT,$$PINGXVAL,2)>($$PINGPVAL*2) D SPAWN^ORRDI2
 Q
PIECEOUT(Y,DATA,DEL) ;
 K Y
 N I,J,COUNT
 S I="",COUNT=0 F  S I=$O(DATA(I)) Q:I=""  D
 . S J=0 F  S J=J+1 Q:J>$L(DATA(I),DEL)  D
 .. I COUNT>0,J=1 S Y(COUNT)=Y(COUNT)_$P(DATA(I),DEL,J) Q
 .. S COUNT=COUNT+1,Y(COUNT)=$P(DATA(I),DEL,J)
 Q
DOWNRPC(ORY) ;can be used in an RPC to check if RDI is in an OUTAGE state (HDR DOWN)
 S ORY=$$DOWNXVAL
 Q
DICNPVAL() ;parameter value for dummy patient ICN
 Q $$GET^XPAR("ALL","ORRDI DUMMY ICN")
FAILPVAL() ;parameter value for failure threshold
 Q $$GET^XPAR("ALL","ORRDI FAIL THRESH")
SUCCPVAL() ;parameter value for success threshold
 Q $$GET^XPAR("ALL","ORRDI SUCCEED THRESH")
PINGPVAL() ;parameter value for ping frequency
 Q $$GET^XPAR("ALL","ORRDI PING FREQ")
DOWNXVAL() ;xtmp value for OUTAGE state
 Q $G(^XTMP("ORRDI","OUTAGE INFO","DOWN"))
FAILXVAL() ;xtmp value for number of failed reads
 Q $G(^XTMP("ORRDI","OUTAGE INFO","FAILURES"))
SUCCXVAL() ;xtmp value for number of successful reads
 Q $G(^XTMP("ORRDI","OUTAGE INFO","SUCCEEDS"))
PINGXVAL() ;xtmp value for last ping time
 Q $G(^XTMP("ORRDI","OUTAGE INFO","DOWN","LAST PING"))
LDPTTVAL(DFN) ;tmp value for if the local data only message has been shown to the user during ordering session
 Q $G(^TMP($J,"ORRDI",DFN))
SPAWN ;subroutine to spawn the DOWNTSK task
 K ^XTMP("ORRDI","ART"),^XTMP("ORRDI","PSOO")
 N ZTDESC,ZTRTN,ZTSAVE,ZTIO,ZTSK,ZTDTH
 S ZTDESC="RDI TASK TO CHECK IF HDR IS UP"
 S ZTRTN="DOWNTSK^ORRDI2"
 S ZTIO=""
 S ZTDTH=$$NOW^XLFDT+.000001
 D ^%ZTLOAD
 Q
DOWNTSK ;subroutine to check if HDR is back up
 F  Q:(($$SUCCXVAL'<$$SUCCPVAL)!('$$DOWNXVAL))  D
 .N WAIT,RSLT
 .S WAIT=$$FMDIFF^XLFDT($$NOW^XLFDT,$$PINGXVAL,2)
 .S WAIT=$$PINGPVAL-WAIT
 .;wait until the proper # of seconds has expired before retrying
 .I WAIT>0 H WAIT
 .S ^XTMP("ORRDI","OUTAGE INFO","DOWN","LAST PING")=$$NOW^XLFDT
 .;send dummy message
 .S RSLT=$$TESTCALL
 .;if successful increment success counter
 .I RSLT S ^XTMP("ORRDI","OUTAGE INFO","SUCCEEDS")=1+$$SUCCXVAL
 .;if failure set success counter to 0
 .I 'RSLT S ^XTMP("ORRDI","OUTAGE INFO","SUCCEEDS")=0
 K ^XTMP("ORRDI","OUTAGE INFO")
 Q
TESTCALL() ;call to send a test call to CDS...returns 1 if successful, 0 if not
 N START,END,HLL,HLA,ORFS,ORCS,ORRS,ORES,ORSS
 N Y,ORRSLT,ICN,WHATOUT,HLNEXT,HLNODE,HLQUIT,ORHLP,RET,HL,HLDOM,HLDONE1,HLECH,HLFS,HLINSTN,HLMTIEN,HLPARAM,HLQ,STATUS,PRE
 S (ORFS,ORCS,ORRS,ORES,ORSS)=""
 S START=$P($$NOW^XLFDT,".")
 ;build HLA array with request HL7
 S HLA("HLS",1)="SPR^XWBDRPC845-569716_0^T^ZREMOTE RPC^@SPR.4.2~003RPC017ORWRP REPORT TEXT&006RPCVER0010&007XWBPCNT0017&007XWBESSO066321214321\F\\F\\F\657\F"
 S HLA("HLS",1,1)="\48102&007XWBDVER0011&006XWBSEC0043.14&002P10187369543;"_$$DICNPVAL_"&002P2039OC_AL:ALLERGIES;1\S\RXOP;ORDV06;28;200&002P3000&002P4000&002P5000&002P600"_$L($G(START))_$G(START)_"&002P700"_$L($G(END))_$G(END)
 S HLA("HLS",2)="RDF^1^@DSP.3~TX~300"
 ;set HLL("LINKS") node to specify receiver location
 S HLL("LINKS",1)="ORRDI SUBSCRIBER^ORHDR"
 S ORHLP("OPEN TIMEOUT")=10
 S ORHLP("SUBSCRIBER")="^OR RDI SENDER^"_$P($$SITE^VASITE,U,3)_"^OR RDI RECEIVER^^^"
 ;call DIRECT^HLMA to send request
 D DIRECT^HLMA("ORRDI EVENT","LM",1,.ORRSLT,,.ORHLP)
 ;check if call failed
 I $P($G(ORRSLT),U,2) Q 0
 Q 1
