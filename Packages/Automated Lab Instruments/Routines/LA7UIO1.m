LA7UIO1 ;DALOI/JMC - Process Download Message for an entry in 62.48 ;May 20, 2008
        ;;5.2;AUTOMATED LAB INSTRUMENTS;**66**;Sep 27, 1994;Build 30
        Q
        ;
BUILD   ; Build one accession into an HL7 message
        ;
        N GBL,HL,LA760,LA761,LA7CDT,LA7CMT,LA7ERR,LA7FAC,LA7FS,LA7ECH,LA7HLP,LA7I,LA7ID
        N LA7LINK,LA7OBRSN,LA7PIDSN,LA7SID,LA7SPEC,LA7X,LA7Y
        S GBL="^TMP(""HLS"","_$J_")"
        ;
        I '$D(ZTQUEUED),$G(LRLL) W:$X+5>IOM !,$S($G(LRTYPE):"Cup",1:"Seq"),": " W LA76822,", "
        ;
        S LA7CNT=0
        F I=0,.1,.2,.3,3 S LA76802(I)=$G(^LRO(68,LA768,1,LA76801,1,LA76802,I))
        S LA7X=LA76802(3)
        ; Draw time
        S LA7CDT=+LA7X
        ; Specimen comment if any, strip "~"
        S LA7CMT=$TR($P(LA7X,"^",6),"~")
        ; Specimen
        S LA761=+$G(^LRO(68,LA768,1,LA76801,1,LA76802,5,1,0))
        ; Accession/unique ID - Long (UID) or short (accession #) sample ID
        S LA7ACC=$P(LA76802(.2),"^"),LA7UID=$P(LA76802(.3),"^"),LA7X=$G(^LRO(68,LA768,.4))
        I $P(LA7X,"^",2)="S" S LA7SID=$$RJ^XLFSTR(LA76802,+$P(LA7X,"^",3),"0")
        E  S LA7SID=LA7UID
        ;
        ; Start message
        D INIT Q:$G(HL)
        ;
        ; Setup links and subscriber array for HL7 message generation
        S LA76248(0)=$G(^LAHM(62.48,LA76248,0)),LA7Y=$P(LA76248(0),"^")
        I $E(LA7Y,1,5)'="LA7UI"!($P(LA76248(0),"^",9)'=1) Q
        S LA7LINK="LA7UI ORM-O01 SUBS 2.2^"_LA7Y
        S LA7FAC=$P($$SITE^VASITE(DT),"^",3)
        S LA7HLP("SUBSCRIBER")="^^"_LA7FAC_"^"_LA7Y_"^"
        ; Following line used when debugging
        ;S $P(LA7HLP("SUBSCRIBER"),"^",8)="1-1-2"
        ;
        ; Build segments PID, PV1, and ORC/OBR segment for each test to be sent
        D PID,PV1
        S (LA7I,LA7OBRSN)=0
        F  S LA7I=$O(LA7ACC(LA7I)) Q:'LA7I  D ORC,OBR
        ; Build entry in MESSAGE QUEUE file 62.49
        D SENDMSG
        L -^LAHM(62.49,LA76249)
        D KVAR^LRX
        Q
        ;
        ;
INIT    ; Create/initialize HL message
        ;
        K @GBL
        S (LA76249,LA7NVAF,LA7PIDSN)=0
        D STARTMSG^LA7VHLU("LA7UI ORM-O01 EVENT 2.2",.LA76249)
        S LA7ID=$P(LRAUTO,"^",1)_"-O-"_LA7UID
        I $G(HL) S LA7ERR=28 D UPDT6249^LA7VORM1
        Q
        ;
        ;
PID     ; Build PID segment
        N LA7DATA,PID
        S LRDFN=+LA7ACC0,LRDPF=$P(^LR(LRDFN,0),"^",2),DFN=$P(^(0),"^",3)
        D DEM^LRX
        ;
        S PID(0)="PID"
        S PID(1)=1
        S PID(3)=$$M11^HLFNC(LRDFN)
        S PID(5)=$$HLNAME^HLFNC(PNM)
        S PID(8)=$S(SEX'="":SEX,1:"U")
        I SSN'="" S PID(19)=SSN
        I DOB S PID(7)=$$FMTHL7^XLFDT(DOB)
        D BUILDSEG^LA7VHLU(.PID,.LA7DATA,LA7FS)
        D FILESEG^LA7VHLU(GBL,.LA7DATA)
        D FILE6249^LA7VHLU(LA76249,.LA7DATA)
        Q
        ;
        ;
PV1     ; Build PV1 segment
        N LA7PV1,LA7X
        D PV1^LA7VPID(LRDFN,.LA7PV1,LA7FS,LA7ECH)
        ; If not inpatient use patient location from Accession
        I $P(LA7PV1(0),LA7FS,3)'="I" S LA7X=$P($G(LA76802(0)),"^",7) S LA7X=$$CHKDATA^LA7VHLU3(LA7X,LA7FS_LA7ECH) S $P(LA7PV1(0),LA7FS,4)=LA7X
        ;
        D FILESEG^LA7VHLU(GBL,.LA7PV1)
        D FILE6249^LA7VHLU(LA76249,.LA7PV1)
        Q
        ;
        ;
ORC     ; Build ORC segment
        N LA7DATA,ORC
        S ORC(0)="ORC"
        S ORC(1)="NW"
        ;
        ; Placer/filler order number - sample ID
        S ORC(2)=$$ORC2^LA7VORC(LA7SID,LA7FS,LA7ECH)
        S ORC(3)=$$ORC3^LA7VORC(LA7SID,LA7FS,LA7ECH)
        ;
        ; Order/draw time - if no order date/time then try draw time
        I $P(LA76802(0),"^",4) S ORC(9)=$$ORC9^LA7VORC($P(LA76802(0),"^",4))
        I '$P(LA76802(0),"^",4),$P(LA76802(3),"^") S ORC(9)=$$ORC9^LA7VORC($P(LA76802(3),"^"))
        ;
        ; Provider
        S LA7X=$$FNDOLOC^LA7VHLU2(LA7UID)
        S ORC(12)=$$ORC12^LA7VORC($P(LA76802(0),"^",8),$P(LA7X,"^",3),LA7FS,LA7ECH)
        D BUILDSEG^LA7VHLU(.ORC,.LA7DATA,LA7FS)
        D FILESEG^LA7VHLU(GBL,.LA7DATA)
        D FILE6249^LA7VHLU(LA76249,.LA7DATA)
        Q
        ;
        ;
OBR     ; Build OBR segment
        N LA764,LA7ALT,LA7CADR,LA7NLT
        K OBR
        ;
        S LA760=+LA7ACC(LA7I)
        S LA764=+$P($G(^LAB(60,LA760,64)),"^")
        S LA7NLT=$P($G(^LAM(LA764,0)),"^",2)
        S LA7TMP=$G(^TMP("LA7",$J,LA7INST,LA7I))
        Q:'LA7TMP
        ;
        S LA7CODE=$P(LA7TMP,"^",6),LA7DATA=$P(LA7TMP,"^",7)
        S OBR(0)="OBR"
        S OBR(1)=$$OBR1^LA7VOBR(.LA7OBRSN)
        ; Placer/filler order number - sample ID
        S OBR(2)=$$OBR2^LA7VOBR(LA7SID,LA7FS,LA7ECH)
        S OBR(3)=$$OBR3^LA7VOBR(LA7SID,LA7FS,LA7ECH)
        ; Test order code
        S LA7ALT=LA7CODE_"^"_$$GET1^DIQ(60,LA760_",",.01)_"^"_"99001"
        S OBR(4)=$$OBR4^LA7VOBR(LA7NLT,LA760,LA7ALT,LA7FS,LA7ECH)
        ; Draw time.
        I $G(LA7CDT) S OBR(7)=$$OBR7^LA7VOBR(LA7CDT)
        ; Infection warning.
        S OBR(12)=$$OBR12^LA7VOBR(LRDFN,LA7FS,LA7ECH)
        ; Specimen comment
        S OBR(13)=LA7CMT
        ; Lab Arrival Time
        S OBR(14)=$$OBR14^LA7VOBR($P(LA76802(3),"^",3))
        ; HL7 code from Topography
        S LA7X=$S(LRDPF=62.3:"^^^CONTROL",1:"")
        S OBR(15)=$$OBR15^LA7VOBR(LA761,"",LA7X,LA7FS,LA7ECH)
        ; Ordering provider
        S LA7X=$$FNDOLOC^LA7VHLU2(LA7UID)
        S OBR(16)=$$ORC12^LA7VORC($P(LA76802(0),"^",8),$P(LA7X,"^",3),LA7FS,LA7ECH)
        ; Placer's field #1 - instrument name^card address
        K LA7X
        S LA7X(1)=$P(LRAUTO,"^")
        S LA7CADR=$P($G(^LAB(62.4,LRINST,9)),U,9)
        I LA7CADR'="" S LA7X(2)=LA7CADR
        S OBR(18)=$$OBR18^LA7VOBR(.LA7X,LA7FS,LA7ECH)
        ; Placer's field #2 - tray^cup^lraa^lrad^lran^lracc^lruid
        K LA7X
        ; No tray/cup if don't send tray/cup flag.
        I $G(LRFORCE) S:LA76821 LA7X(1)=LA76821 S:LA76822 LA7X(2)=LA76822
        S LA7X(3)=LA768,LA7X(4)=LA76801,LA7X(5)=LA76802,LA7X(6)=LA7ACC,LA7X(7)=LA7UID
        S OBR(19)=$$OBR19^LA7VOBR(.LA7X,LA7FS,LA7ECH)
        ;
        ; Test urgency
        S OBR(27)=$$OBR27^LA7VOBR("","",+$P(LA7ACC(LA7I),"^",2),LA7FS,LA7ECH)
        ;
        K LA7DATA
        D BUILDSEG^LA7VHLU(.OBR,.LA7DATA,LA7FS)
        D FILESEG^LA7VHLU(GBL,.LA7DATA)
        D FILE6249^LA7VHLU(LA76249,.LA7DATA)
        Q
        ;
        ;
SENDMSG ; Send the HL7 message.
        N HLL,HLP
        S HLL("LINKS",1)=LA7LINK
        I $D(LA7HLP) M HLP=LA7HLP
        D GEN^LA7VHLU,UPDT6249^LA7VORM1
        Q
