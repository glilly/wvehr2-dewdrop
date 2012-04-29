LA7QRY1 ;DALOI/JMC - Lab HL7 Query Utility ;01/19/99  13:48
        ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,61**;Sep 27, 1994;Build 38
        ;
        Q
        ;
CHKSC   ; Check search NLT/LOINC codes
        ;
        N J
        ;
        S J=0
        F  S J=$O(LA7SC(J)) Q:'J  D
        . N X
        . S X=LA7SC(J)
        . I $P(X,"^",2)="NLT",$D(^LAM("E",$P(X,"^"))) D  Q
        . . S ^TMP("LA7-NLT",$J,$P(X,"^"))=""
        . I $P(X,"^",2)="LN",$D(^LAB(95.3,$P($P(X,"^"),"-"))) D  Q
        . . S ^TMP("LA7-LN",$J,$P($P(X,"^"),"-"))=""
        . S LA7ERR(6)="Unknown search code "_$P(X,"^")_" passed"
        . K LA7SC(J)
        Q
        ;
        ;
SPEC    ; Convert HL7 Specimen Codes to File #61, Topography codes
        ; Find all topographies that use this HL7 specimen code
        N J,K,L
        ;
        S J=0
        F  S J=$O(LA7SPEC(J)) Q:'J  D
        . S K=LA7SPEC(J),L=0
        . F  S L=$O(^LAB(61,"HL7",K,L)) Q:'L  S ^TMP("LA7-61",$J,L)=""
        Q
        ;
        ;
BUILDMSG        ; Build HL7 message with result of query
        ;
        N HL,HLECH,HLFS,HLQ,LA,LA763,LA7ECH,LA7FS,LA7MSH,LA7NOMSG,LA7NTESN,LA7NVAF,LA7OBRSN,LA7OBXSN,LA7PIDSN,LA7ROOT,LA7X,X
        ;
        I $L($G(LA7HL7))'=5 S LA7HL7="|^\~&"
        S (HL("FS"),HLFS,LA7FS)=$E(LA7HL7),(HL("ECH"),HLECH,LA7ECH)=$E(LA7HL7,2,5)
        S (HLQ,HL("Q"))=""""""
        ; Set flag to not send HL7 message
        S LA7NOMSG=1
        ; Create dummy MSH to pass HL7 delimiters
        S LA7MSH(0)="MSH"_LA7FS_LA7ECH_LA7FS
        D FILESEG^LA7VHLU(GBL,.LA7MSH)
        ;
        F X="AUTO-INST","LRDFN","LRIDT","SUB","HUID","NLT","RUID","SITE" S LA(X)=""
        ;
        ; Take search results and put in HL7 message structure
        S LA7ROOT="^TMP(""LA7-QRY"",$J)",(LA7QUIT,LA7PIDSN)=0
        ; F  S LA7ROOT=$Q(@LA7ROOT) Q:LA7QUIT  D ;change per John M
        F  S LA7ROOT=$Q(@LA7ROOT) Q:LA7ROOT=""  D  Q:LA7QUIT
        . I $QS(LA7ROOT,1)'="LA7-QRY"!($QS(LA7ROOT,2)'=$J) S LA7QUIT=1 Q
        . I LA("LRDFN")'=$QS(LA7ROOT,3) D PID S LA7OBRSN=0
        . I LA("LRIDT")'=$QS(LA7ROOT,4) D ORC,OBR
        . I LA("SUB")'=$QS(LA7ROOT,5) D ORC,OBR
        . I LA("NLT")'=$P($QS(LA7ROOT,6),"!") D ORC,OBR
        . D OBX
        ;
        Q
        ;
        ;
PID     ; Build PID segment
        ;
        N LA7PID
        ;
        S (LA("LRDFN"),LRDFN)=$QS(LA7ROOT,3)
        S LRDPF=$P(^LR(LRDFN,0),"^",2),DFN=$P(^(0),"^",3)
        D DEM^LRX
        D PID^LA7VPID(LA("LRDFN"),"",.LA7PID,.LA7PIDSN,.HL)
        D FILESEG^LA7VHLU(GBL,.LA7PID)
        S (LA("LRIDT"),LA("SUB"))=""
        Q
        ;
        ;
ORC     ; Build ORC segment
        ;
        N X
        ;
        S LA("LRIDT")=$QS(LA7ROOT,4),LA("SUB")=$QS(LA7ROOT,5)
        S LA763(0)=$G(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),0))
        S X=$G(^LR(LA("LRDFN"),LA("SUB"),LA("LRIDT"),"ORU"))
        S LA("HUID")=$P(X,"^"),LA("SITE")=$P(X,"^",2),LA("RUID")=$P(X,"^",4)
        I LA("HUID")="" S LA("HUID")=$P(LA763(0),"^",6)
        S LA7NVAF=$$NVAF^LA7VHLU2(0),LA7NTESN=0
        D ORC^LA7VORU
        S LA("NLT")=""
        ;
        Q
        ;
        ;
OBR     ; Build OBR segment
        ;
        N LA764,LA7NLT
        ;
        S (LA("NLT"),LA7NLT)=$P($QS(LA7ROOT,6),"!"),(LA764,LA("ORD"))=""
        I $L(LA7NLT) D
        . S LA764=+$O(^LAM("E",LA7NLT,0))
        . I LA764 S LA("ORD")=$$GET1^DIQ(64,LA764_",",.01)
        I LA("SUB")="CH" D
        . D OBR^LA7VORU
        . D NTE^LA7VORU
        . S LA7OBXSN=0
        ;
        Q
        ;
        ;
OBX     ; Build OBX segment
        ;
        N LA7DATA,LA7VT
        ;
        S LA7NTESN=0
        I LA("SUB")="MI" D MI^LA7VORU1 Q
        I "CYEMSP"[LA("SUB") D AP^LA7VORU2 Q
        ;
        S LA7VT=$QS(LA7ROOT,7)
        D OBX^LA7VOBX(LA("LRDFN"),LA("SUB"),LA("LRIDT"),LA7VT,.LA7DATA,.LA7OBXSN,LA7FS,LA7ECH)
        I '$D(LA7DATA) Q
        D FILESEG^LA7VHLU(GBL,.LA7DATA)
        ; Send any test interpretation from file #60
        D INTRP^LA7VORUA
        ;
        Q
