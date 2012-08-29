MDHL7BH ; HOIFO/WAA -Bi-directional interface (HL7) routine ;7/23/01  11:41
 ;;1.0;CLINICAL PROCEDURES;;Apr 01, 2004
 ;
 ; This routine will build the HL7 Message and store that message.
 ; After the message has been created then it will call the
 ; The actual HL7package to start the processing of the message
 ;
 ; Reference DBIA #2161 [Supported] for HL7 calls.
 ; Reference DBIA #2164 [Supported] for HL7 calls.
 ; Reference DBIA #3065 [Supported]  call to HLFNAME.
 Q
EN1 ;Main Entry point.
 N MDMSG,MD101,CNT,HLA,LINE,MDHL,DFN,MDLINK
 Q:RESULT<1  ; This tells the study is not a BDi
 S MDLINK=$$GET1^DIQ(702.09,DEVIEN,.18,"E")
 I MDLINK="" S RESULT=-1,MSG="No HL Logical Link has been defined." Q  ; No no link has been defined 
 S MDERROR="0"
 D INIT^HLFNC2("MCAR ORM SERVER",.MDMSG)
 I +$G(MDMSG)>0 S RESULT=-1,MSG="Unable to produce a message." Q  ; something is wrong and no MSH was created
 S DFN=$$GET1^DIQ(702,MDD702,.01,"I")
 S DEVNAME=$$GET1^DIQ(702.09,DEVIEN,.16,"I")
 S CNT=0
 D PID S CNT=CNT+1,HLA("HLS",CNT)=LINE
 D PV1 S CNT=CNT+1,HLA("HLS",CNT)=LINE
 D ORC S CNT=CNT+1,HLA("HLS",CNT)=LINE
 D OBR I LINE'="" S CNT=CNT+1,HLA("HLS",CNT)=LINE
 S HLP("SUBSCRIBER")="^^VISTA^^"_DEVNAME_"^M"
 S HLL("LINKS",1)="MCAR ORM CLIENT"_"^"_MDLINK
 D GENERATE^HLMA("MCAR ORM SERVER","LM",1,.MDHL,,.HLP)
 I $P(MDHL,U,2) S MDERROR=MDHL
 Q
OBR ; Send the procedure to the correct device
 S LINE="OBR|"
 S DEVIEN=$$GET1^DIQ(702,MDD702,.11,"I")
 S USC=$$GET1^DIQ(702.09,DEVIEN,.17,"I")
 I USC="" S LINE="" Q
 E  S USC=$TR(USC,"=","^")
 S $P(LINE,"|",5)=USC_"|"
 Q
PID ;get the patient information and build the PID
 ;PID|||SSN||Last^First||DOB|SEX|||||||||||SSN
 N MDSSN,NAME,DOB,ADDR,TMP
 S LINE="PID|",$P(LINE,"|",21)=""
 S MDSSN=$$GET1^DIQ(702,MDD702,.011) ; Get the ssn for the patient
 S NAME=$$GET1^DIQ(702,MDD702,.01,"E") ; get the patient name
 S NAME=$$HLNAME^XLFNAME($P(NAME,"^"),"",$E(HLECH,1))
 I $P(NAME,$E(HLECH,1),7)'="L" S $P(NAME,$E(HLECH,1),7)="L"
 S DOB=$$GET1^DIQ(2,DFN,.03,"I") S DOB=$$FTOHL7^MDHL7U2(DOB)
 S ADDR=$$GET1^DIQ(2,DFN,.111,"E")_"^" ; Address 1
 S TMP=$$GET1^DIQ(2,DFN,.112,"E") I TMP'="" S ADDR=ADDR_TMP ; Add 2
 S TMP=$$GET1^DIQ(2,DFN,.113,"E") I TMP'="" S ADDR=ADDR_" "_TMP ; Add 3
 S ADDR=ADDR_"^"_$$GET1^DIQ(2,DFN,.114,"E") ; City
 S ADDR=ADDR_"^"_$$GET1^DIQ(5,$$GET1^DIQ(2,DFN,.115,"I"),1,"E") ; State
 S ADDR=ADDR_"^"_$$GET1^DIQ(2,DFN,.116,"E") ; Zip
 S $P(LINE,"|",2)="1"
 S $P(LINE,"|",4)=MDSSN
 S $P(LINE,"|",6)=NAME
 S $P(LINE,"|",8)=DOB
 S $P(LINE,"|",9)=$$GET1^DIQ(2,DFN,.02,"I")
 S $P(LINE,"|",12)=ADDR
 S $P(LINE,"|",20)=MDSSN
 Q
PV1 ;Get the ward location for PV1
 ;PV1||In or out|Ward location
 N WARD,INOUT,CONSULT,REF,NREF
 S WARD=$$GET1^DIQ(2,DFN,.1,"E")
 S INOUT=$S(WARD'="":"I",1:"O")
 S:WARD'="" WARD=WARD_U_WARD
 S LINE="PV1||"_INOUT_"|"_WARD
 S CONSULT=$$GET123^MDHL7U2(MDD702) Q:CONSULT<1
 S NREF=$$GETREF^MDHL7U2(CONSULT) Q:NREF="-1"
 S $P(LINE,"|",9)=NREF
 Q
ORC ;get ORC onformation
 ;ORC|NA|Order Number|||||||date/time ordered
 N DATE,SDATE
 S DATE=$$GET1^DIQ(702,MDD702,.02,"I")
 S DATE=$$FTOHL7^MDHL7U2(DATE)
 S SDATE=$$GET1^DIQ(702,MDD702,.07,"I")
 I SDATE[";" S SDATE=$P(SDATE,";",2)
 S SDATE=$$FTOHL7^MDHL7U2(SDATE)
 S LINE="ORC|"_$S(MDORFLG=1:"NW",MDORFLG=0:"CA",1:"")_"|"_MDIORD
 S $P(LINE,"|",6)=$S(MDORFLG=1:"NW",MDORFLG=0:"CA",1:"")
 S $P(LINE,"|",10)=DATE,$P(LINE,"|",16)=SDATE
 Q
