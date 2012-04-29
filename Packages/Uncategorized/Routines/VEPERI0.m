VEPERI0 ;DAOU/WCJ - Incoming HL7 messages ;2-MAY-2005
 ;;1.0;VOEB;;Jun 12, 2005
 ;;;VISTA OFFICE/EHR;
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ;**Program Description**
 ;  This program parses each incoming HL7 message.
 ;
 Q
 ;
 ; Starting points - put message into a TMP global and also HLI array
 ; The first is when called from protocol.
 ; The second is when called from the PENDING tag below
 ;
EN N DFN,ADDPFLG,FE
EN2 N SEGCNT,CNT,DUZ,FE,HLI,EVENT,EVENTS,I,DEL,DELIM,SYS
 N SEGMT,PRTCL,HL,HLECH,HLFS,HLEID,HLEIDS,MSGEVNT,IEN
 N HLF,HLP
 ;
 S FE=0
 K ^TMP($J,"VEPERI0")
 F SEGCNT=1:1 X HLNEXT Q:HLQUIT'>0  D
 . S CNT=0
 . S (^TMP($J,"VEPERI0",SEGCNT,CNT),HLI(SEGCNT,CNT))=HLNODE
 . F  S CNT=$O(HLNODE(CNT)) Q:'CNT  D
 .. S (^TMP($J,"VEPERI0",SEGCNT,CNT),HLI(SEGCNT,CNT))=HLNODE(CNT)
 ;
TEP ; Test Entry Point will remove later
 ;
 ;  Get the user responsible for the interface
 D GETUSER^VEPERI4(.DUZ,.FE,HLMTIEN)
 ;
 ;   Determine which protocol to use
 S SEGMT=$G(HLI(1,0))
 I $E(SEGMT,1,3)'="MSH" D  Q
 . S FE=$$FATALERR^VEPERI6(1,"HL7","MSH Segment is not the first segment found",HLMTIEN)
 S DEL(1)=$E(SEGMT,4)
 S DELIM=$P(SEGMT,DEL(1),2)
 F I=1:1:$L(DELIM) S DEL(I+1)=$E(DELIM,I)
 ;
 D INIT
 I FE D CLEANUP Q
 ;
 S EVENT=$P(SEGMT,DEL(1),9) S:EVENT="" EVENT=" "
 ;  The event type determines protocol
 I '$D(EVENTS(EVENT)) S FE=$$FATALERR^VEPERI6(1,"HL7","Unsupported Event = "_EVENT,HLMTIEN) Q
 S PRTCL=EVENTS(EVENT)
 S MSGEVNT=$P(EVENT,DEL(2),2)
 S HLEID=$O(^ORD(101,"B",PRTCL,0))
 ;
 ;  Initialize the HL7 variables
 D INIT^HLFNC2(HLEID,.HL)
 ;
 ; Get the subscriber
 S HLEIDS=$O(^ORD(101,HLEID,775,"B",0))
 ;
 D LOADTBL^VEPERI1A(SYS,.FE,.HLF)
 I FE D CLEANUP Q
 ;
 D PARSE^VEPERI1(.HLI,.HLP,.HLF,.DEL,.FE,MSGEVNT,HLMTIEN)
 I FE D CLEANUP Q
 ;
 D VALIDATE^VEPERI1(.HLP,.HLF,.FE,.DEL,HLMTIEN)
 I FE D CLEANUP Q
 ;
 ; Find the patient if it wasn't already identified from the pending file
 I '$G(DFN) D FINDPAT^VEPERI3(.HLP,.FE,.DFN,ADDPTFLG,HLMTIEN)
 I FE D CLEANUP Q
 ;
 ; If DFN was not returned, then we have no business continuing.
 I '$G(DFN) D CLEANUP Q
 ;
 ; Returns IEN array of insurances
 D FILEINS^VEPERI2(.HLP,.HLF,DFN,.IEN,.FE,HLMTIEN)
 I FE D CLEANUP Q
 ;
 D FILEPAT^VEPERI5(.HLP,.HLF,DFN,.IEN,.FE,HLMTIEN)
 I FE D CLEANUP Q
 ;
CLEANUP ;
 K ^TMP($J,"VEPERIO"),HL,HLNEXT,HLNODE,HLQUIT
 Q
 ;
 ; Returns
 ; SYS
 ; EVENT ARRAY
 ; ADDPTLFG
INIT ;
 N SCREEN,TAR,MSG
 S SCREEN="I $P(^(0),U,2)=1"
 D LIST^DIC(19904,,".01;.03",,,,,,SCREEN,,"TAR","MSG")
 I $D(MSG) S FE=$$FATALERR^VEPERI6(1,"SETUP","NO ACTIVE SYSTEMS SET UP IN 19904") Q
 I TAR("DILIST",0)>1 S FE=$$FATALERR^VEPERI6(1,"SETUP","TOO MANY ACTIVE SYSTEMS SET UP IN 19904") Q
 S SYS=TAR("DILIST",1,1)
 S ADDPTFLG=+TAR("DILIST","ID",1,.03)
 S IEN=","_TAR("DILIST",2,1)_","
 ;
 D LIST^DIC(19904.01,IEN,".01;.02",,,,,,,,"TAR","MSG")
 I $D(MSG) S FE=$$FATALERR^VEPERI6(1,"SETUP","PROBLEM RETRIEVING PROTOCOLS FROM 19904") Q
 F I=1:1 Q:'$D(TAR("DILIST",1,I))  D
 .S EVENT=TAR("DILIST","ID",I,".02")
 .S EVENT=$TR(EVENT,"~","^")
 .S EVENT(EVENT)=TAR("DILIST","ID",I,".01")
 Q
 ;
 ; IENS is a string of internal entry numbers from file 772
 ; and DFN is an existing patient.  If DFN does not exist, it is a new
 ; patient.  We will need to pass that back to update the pending file
 ; This is called from VEPERI7
 ;
PENDING(IENS772,DFN) ;
 N HLQUIT,HLNODE,HLNEXT,HLMTIEN,IENSLOOP,ADDPTFLG,FE
 S FE=0
 I '$G(DFN) S ADDPTFLG=1   ; allow new patients to be added
 F IENSLOOP=1:1 S HLMTIEN=$P(IENS772,",",IENSLOOP) Q:'+HLMTIEN!(FE)  D
 . S HLQUIT=0,HLNODE="",HLNEXT="D HLNEXT^HLCSUTL"
 . D EN2
 Q
