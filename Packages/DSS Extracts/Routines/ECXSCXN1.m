ECXSCXN1        ;ALB/JAP  Clinic Extract No Shows; 8/28/02 1:11pm ;9/10/10  10:13
        ;;3.0;DSS EXTRACTS;**71,105,127**;Dec 22, 1997;Build 36
NOSHOW(ECXSD,ECXED)     ;get noshows from file #44
        ;      ECXSD  = start date, ECXED  = end date
        N ALEN,CLIN,JDATE,JJ,NODE,NOSHOW,PP,STAT,MDIV
        S CLIN=0
        F  S CLIN=$O(^TMP($J,"ECXCL",CLIN)) Q:'CLIN  D
        .Q:$P($G(^TMP($J,"ECXCL",CLIN)),U,3)'="C"
        .S (P1,P2,P3)=""
        .D FEEDER^ECXSCX1(CLIN,ECXSD,.P1,.P2,.P3,.TOSEND,.ECXDIV)
        .Q:TOSEND=6
        .;find appts in date range
        .S JDATE=ECXSD,(ALEN,NOSHOW)=""
        .F  S JDATE=$O(^SC(CLIN,"S",JDATE)) Q:'JDATE  Q:JDATE>ECXED  D
        ..S ECXDATE=JDATE,JJ=0,ECXTI=$P($$FMTE^XLFDT(JDATE,1),"@",2)
        ..S ECXTI=$E(($TR(ECXTI,":","")_"000000"),1,6)
        ..S:ECXTI="000000" ECXTI="000300"
        ..;get noshows only - no data in check-in/check-out node
        ..F  S JJ=$O(^SC(CLIN,"S",JDATE,JJ)) Q:'JJ  D
        ...S K=0
        ...F  S K=$O(^SC(CLIN,"S",JDATE,JJ,K)) Q:'K  D
        ....S PP=$G(^SC(CLIN,"S",JDATE,JJ,K,0)),ECXDFN=$P(PP,U) Q:ECXDFN=""
        ....S ECXPATCAT=$$PATCAT^ECXUTL(ECXDFN) ;added in patch 127
        ....S NODE=$G(^DPT(ECXDFN,"S",JDATE,0)),MDIV=$P($G(^SC(CLIN,0)),U,15)
        ....Q:(NODE="")!($P(NODE,U)'=CLIN)
        ....S ECXSHAD=$$GETSHAD ;added in patch 127, finds shad status for appt
        ....S ECXOBI=$G(^SC(CLIN,"S",JDATE,JJ,K,"OB")),STAT=$P(NODE,U,2)
        ....S NOSHOW=$S(STAT="N":"N",STAT="NA":"N",1:"")
        ....Q:NOSHOW=""  D INTPAT^ECXSCX2 S ECXERR=0
        ....D PAT1^ECXSCX2(ECXDFN,ECXDATE,.ECXERR) Q:ECXERR
        ....S ALEN=$P(PP,U,2),ALEN=$$RJ^XLFSTR(ALEN,3,0)
        ....D PAT2^ECXSCX2(ECXDFN,ECXDATE)
        ....S ECXPVST=$P(NODE,U,7),ECXATYP=$P(NODE,U,16)  ;Get POV & appt type
        ....S:+ALEN=0 ALEN=$P($G(^TMP($J,"ECXCL",CLIN)),U,2)
        ....S ECXCLIN=CLIN,ECXSTOP=P1
        ....S:ECXCPT1="" ECXCPT1="9919901"
        ....S ECXCBOC=$S(MDIV'="":$$CBOC^ECXSCX2(.MDIV),1:"")
        ....S (ECXDSSD,ECXENEL,ECXIR,ECXAO,ECXMIL,ECXPROV,ECXPROVP,ECXPROVN)=""
        ....I TOSEND'=3 D
        .....S ECXKEY=P1_P2_ALEN_P3_NOSHOW,ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS,ECXKEY)
        .....S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,ECXDATE,ECXTS,ECXOBS,ECHEAD,ECXKEY,) D:ECXENC'="" FILE^ECXSCXN
        ....I TOSEND=3 D
        .....S ECXKEY=P1_"000"_ALEN_P3_NOSHOW,ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS,ECXKEY)
        .....S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,ECXDATE,ECXTS,ECXOBS,ECHEAD,ECXKEY,) D:ECXENC'="" FILE^ECXSCXN
        ....I TOSEND=3 D
        .....S ECXKEY=P2_"000"_ALEN_P3_NOSHOW,ECXOBS=$$OBSPAT^ECXUTL4(ECXA,ECXTS,ECXKEY)
        .....S ECXENC=$$ENCNUM^ECXUTL4(ECXA,ECXSSN,ECXADMDT,ECXDATE,ECXTS,ECXOBS,ECHEAD,ECXKEY,) D:ECXENC'="" FILE^ECXSCXN
        ....;create a record for noshow appended ekg. The code was removed for CTX-0604-70970 CLI Extract Problem EXPANDED to NoShows
        Q
        ;GETSHAD section added with patch 127
GETSHAD()       ;Function returns shad value
        N DIC,LOCARR,DA,DR,SHAD,ECXERR,ECXVIST
        S SHAD=""
        I '+$P($G(NODE),U,20) Q SHAD  ;Quit if no visit pointer
        S DIC=409.68,DA=$P(NODE,U,20),DR=.05,DIQ(0)="I",DIQ="LOCARR"
        D EN^DIQ1
        I $G(LOCARR(409.68,DA,.05,"I")) D
        .S ECXERR=0
        .D VISIT^ECXSCX1(ECXDFN,LOCARR(409.68,DA,.05,"I"),.ECXVIST,.ECXERR)
        .I 'ECXERR S SHAD=ECXVIST("SHAD")
        Q SHAD
