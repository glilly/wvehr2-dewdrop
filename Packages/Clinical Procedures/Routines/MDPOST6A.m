MDPOST6A        ;HOIFO/NCA-Convert Existing Notes to New File ;11/28/07  14:31
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; Reference IA #2693 [Subscription] TIULQ call
        ;               2916 [Supported] DDMOD calls
EN1     ; Start Converting Notes
        D P1
        D P2
        Q
P1      ; Process multiple notes from Hemo.
        Q:'$D(^MDD(702,"C"))
        N MDCHK,MDCST,MDCTR,MDDL,MDFDA,MDK,MDSID,MDX1 S MDDL="",MDCTR=0
        S MDSID=0 F  S MDSID=$O(^MDD(702,"C",MDSID)) Q:MDSID<1  D
        .S MDK=0 F  S MDK=$O(^MDD(702,"C",MDSID,MDK)) Q:MDK<1  S MDX1=+MDK D
        ..N MDTIUER
        ..S MDTIUER="" K ^TMP("MDTIUST",$J)
        ..D EXTRACT^TIULQ(+MDX1,"^TMP(""MDTIUST"",$J)",MDTIUER,".01;.05;1201;1202;1205") Q:+MDTIUER
        ..I $G(^TMP("MDTIUST",$J,MDX1,.05,"E"))'="COMPLETED" Q
        ..S MDCHK=$O(^MDD(702.001,"ASTUDY",+MDSID,+MDX1,0)) Q:+MDCHK
        ..S MDFDA(702.001,"+1,",.01)=MDSID
        ..S MDFDA(702.001,"+1,",.02)=+MDX1
        ..S MDFDA(702.001,"+1,",.03)=$G(^TMP("MDTIUST",$J,MDX1,1201,"I"))
        ..D UPDATE^DIE("","MDFDA")
        ..S MDCTR=MDCTR+1
        ..K ^TMP("MDTIUST",$J),MDFDA
        ..Q
        I MDCTR=+$P($G(^MDD(702.001,0)),"^",4) D DELIXN^DDMOD(702,"C") K ^MDD(702,"C")
        Q
P2      ; Move existing TIU Notes in CP Transaction File
        N MDCHK,MDCST,MDCTR,MDDL,MDFDA,MDK,MDSID,MDX1 S MDDL="",MDCTR=0
        Q:+$P($G(^MDD(702.001,0)),"^",4)>0
        S MDK=0 F  S MDK=$O(^MDD(702,"ATIU",MDK)) Q:MDK<1  D
        .S MDSID=0 F  S MDSID=$O(^MDD(702,"ATIU",MDK,MDSID)) Q:MDSID<1  S MDX1=+MDK D
        ..N MDTIUER
        ..S MDTIUER="" K ^TMP("MDTIUST",$J)
        ..D EXTRACT^TIULQ(+MDX1,"^TMP(""MDTIUST"",$J)",MDTIUER,".01;.05;1201;1202;1205") Q:+MDTIUER
        ..S MDCHK=$O(^MDD(702.001,"ASTUDY",+MDSID,+MDX1,0)) Q:+MDCHK
        ..S MDFDA(702.001,"+1,",.01)=MDSID
        ..S MDFDA(702.001,"+1,",.02)=+MDX1
        ..S MDFDA(702.001,"+1,",.03)=$G(^TMP("MDTIUST",$J,MDX1,1201,"I"))
        ..S MDCTR=MDCTR+1
        ..D UPDATE^DIE("","MDFDA")
        ..K ^TMP("MDTIUST",$J),MDFDA
        ..Q
        Q
