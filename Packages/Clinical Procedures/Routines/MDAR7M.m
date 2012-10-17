MDAR7M  ; HOIFO/NCA - Get Text Impression ;2/27/09  12:38
        ;;1.0;Clinical Procedures;**21**;Apr 01, 2004;Build 30
        ; Integration Agreement:
        ;       IA #  2263 [Supported] XPAR Calls
        ;            10103 [Supported] XLFDT Calls
        ;            10104 [Supported] Calls to XLFSTR
        ;
GETTXT(MDTXR,RECID)     ; Get text impression
        N CCNT,CNT,CODE,ICNT,LAST,LL,LNE,MDAR,MDC,MDCH,MDFG,MDHLST,MDK,MDMUSE,MDNAD,MDOBR,MDPENT,MDPN,MDRESL,MDSY,MDX,SEG,TXT,UNITS,VAL,X,XN S (ICNT,MDFG,MDPENT)=0,(MDOBR,MDPN)=""
        Q:'+$G(RECID)
        S MDRESL=+$P($G(^MDD(703.1,+RECID,0)),"^",6)
        S MDSY=+$P($G(^MDD(703.1,+RECID,0)),"^",5) Q:'MDSY
        D GETLST^XPAR(.MDHLST,"SYS","MD GET HIGH VOLUME")
        F MDK=0:0 S MDK=$O(MDHLST(MDK)) Q:MDK<1  I $P($G(MDHLST(MDK)),"^")=+$P(^MDD(702,+MDSY,0),U,4) S MDFG=$P($G(MDHLST(MDK)),"^",2) Q
        S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="** DOCUMENT IN VISTA IMAGING **"
        S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="SEE FULL REPORT IN VISTA IMAGING",ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=""
        I '$P(MDFG,";",2) S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="SIGNATURE NOT REQUIRED"
        I '$P(MDFG,";",2) S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="SEE SIGNATURE IN VISTA IMAGING",ICNT=ICNT+1
        S MDTXR("TEXT",ICNT,0)=""
        Q:'+MDFG
        Q:+$P($G(^MDS(702.01,+$P(^MDD(702,+MDSY,0),U,4),0)),"^",6)=2
        Q:+$P($G(^MDS(702.01,+$P(^MDD(702,+MDSY,0),U,4),0)),"^",11)=2
        S (MDNAD,MDMUSE,MDPENT)=0
        I +$$GET^XPAR("SYS","MD NOT ADMN CLOSE MUSE NOTE",1) S MDNAD=1
        S:$$UP^XLFSTR($$GET1^DIQ(702,+MDSY_",",".11","E"))["PENTAX" MDPENT=1
        S:$$UP^XLFSTR($$GET1^DIQ(702,+MDSY_",",".11","E"))["MUSE" MDMUSE=1
        Q:'MDRESL
        Q:'$D(^TMP($J,"MDHL7A"))
        S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="** ("_$$GET1^DIQ(702,+MDSY_",",".11","E")_")  AUTO-INSTRUMENT DIAGNOSIS **",ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=""
        S LAST=$O(^TMP($J,"MDHL7A",""),-1)
        F MDK=1:1:LAST S XN=$G(^TMP($J,"MDHL7A",MDK)),TXT="" D
        .I $P(XN,"|",1)="OBR" S SEG=XN S (MDOBR,TXT)=$$OBR(SEG) I TXT'="" D
        ..S MDPN=$P(TXT,";",5) I MDPN["99999" S MDPN=$P(MDPN,"99999",2)
        ..I MDPN'="" S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="Procedure: "_MDPN
        ..S LNE=""
        ..I $P(TXT,";",2)'="" S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="",ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="Release Status: "_$P(TXT,";",2)
        ..I $P(TXT,";")'="" S LNE="Date Verified: "_$P(TXT,";"),ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=LNE
        ..I $P(TXT,";",3)'=""&(+MDMUSE) S LNE="Interpreter: "_$P(TXT,";",3),ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=LNE
        ..I $P(TXT,";",3)'=""&(+MDMUSE)&(+MDNAD) S MDTXR(1202)=$P(TXT,";",6),MDTXR(1204)=$P(TXT,";",6),MDTXR(1302)=$P(TXT,";",6)
        ..S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="" Q
        .I $P(XN,"|",1)="OBX" S SEG=XN Q:$P(SEG,"|",3)="ST"&($P(SEG,"|",6)["^")  Q:'MDPENT&($P(MDOBR,";")="")&($P(MDOBR,";",4)="")  S TXT=$$OBX(SEG) D
        ..I $P(SEG,"|",3)'="ST" S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=TXT Q
        ..S CODE=$P(SEG,"|",4),VAL=$P(SEG,"|",6),UNITS=$P(SEG,"|",7),CCNT=$L(VAL),CNT=0
        ..I CODE["^" S CODE=$S(+$P(CODE,"^",1):+$P(CODE,"^",1)_"  "_$P(CODE,"^",2),1:$P(CODE,"^",2))
        ..Q:CODE=""!(VAL="")
        ..Q:VAL["\\"
        ..I $L(VAL)<50 S LNE=$E(CODE_":"_$J("",30),1,30)_VAL S:UNITS'="" LNE=$E(LNE_$J("",10),1,38)_UNITS S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=LNE Q
        ..E  K MDAR S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=$E(CODE_":"_$J("",30),1,30) D WP(.MDAR,VAL,CNT) F MDC=0:0 S MDC=$O(MDAR(MDC)) Q:MDC<1  S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)=$G(MDAR(MDC))
        ..S ICNT=ICNT+1,MDTXR("TEXT",ICNT,0)="" Q
        .Q
        Q
OBR(SEGM)       ; Get OBR
        N EXAM,LINE,X,XNM
        S EXAM=$P($P(SEGM,"|",5),"^",1) S:EXAM="" EXAM=99999
        S EXAM=EXAM_"  "_$P($P(SEGM,"|",5),"^",2)
        ; S SGET=Date verified;Release status;Interpreter;Result status;Interpreter ien
        S X=$P(SEGM,"|",23) I X>0 S SGET=$$HL7TFM^XLFDT(X)_";"_"Released Off-Line Verified" ;
        S X=$P($P(SEGM,"|",33),"^",1)
        S XNM=$$GET1^DIQ(200,X,.01,"I")
        I +X,XNM'="" S $P(SGET,";",3)=XNM,$P(SGET,";",6)=+X
        S X=$P($G(SGET),";")
        I X'="" S $P(SGET,";")=$$FMTE^XLFDT(X)
        S:$P(SEGM,"|",26)="F" $P(SGET,";",4)="F"
        S:$P(SEGM,"|",26)="C" $P(SGET,";",4)="C"
        S $P(SGET,";",5)=EXAM
        Q SGET
OBX(SEGM)       ; Process OBX
        N CODE,LINE,STYP,VAL,X1
        S X1=$G(SEGM)
        S STYP=$P(X1,"|",3) Q:STYP="ST" ""
        S CODE=$P(X1,"|",4),VAL=$P(X1,"|",6),UNITS=$P(X1,"|",7) I CODE["^" S CODE=$S(+$P(CODE,"^",1):+$P(CODE,"^",1)_"  "_$P(CODE,"^",2),1:$P(CODE,"^",2))
        I CODE=""!(VAL="") Q ""
        I STYP="CE" S VAL=$P(VAL,"^",2)
        Q:VAL["\\" ""
        I STYP="TX"!(STYP="FT") Q VAL
        I STYP="CE" S LINE=$E(CODE_":"_$J("",30),1,30)_VAL Q LINE
        I STYP="XCN" S VAL=$P(VAL,"^",3)_" "_$P(VAL,"^",4)_" "_$P(VAL,"^",2)_" "_$P(VAL,"^",7),LINE=$E(CODE_":"_$J("",30),1,30)_VAL Q LINE
        I STYP="DT"!(STYP="TS") S VAL=$$HL7TFM^XLFDT(VAL),VAL=$$FMTE^XLFDT(VAL) S LINE=$E(CODE_":"_$J("",30),1,30)_VAL Q LINE
        S LINE=$E(CODE_":"_$J("",30),1,30)_VAL
        I UNITS'="" S LINE=$E(LINE_$J("",10),1,38)_UNITS
        Q LINE
WP(MDGAR,LTXT,MDJ)      ; Process Word Process lines
        N LOP
LOOP    I $L(LTXT)<70 S MDJ=MDJ+1,MDGAR(MDJ)=$J("",10)_LTXT Q
        F LOP=70:-1:1 Q:$E(LTXT,LOP)?1P
        S MDJ=MDJ+1,MDGAR(MDJ)=$J("",10)_$E(LTXT,1,LOP-1)
        S LTXT=$E(LTXT,LOP+1,999) G LOOP
