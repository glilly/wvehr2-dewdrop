LRBEBA3 ;DALOI/JAH/FHS - ORDERING AND RESULTING OUTPATIENT ;8/10/04
        ;;5.2;LAB SERVICE;**291,359,352**;Sep 27, 1994;Build 1
        ;
BLDAR(LRBEDFN,LRODT,LRSN,LRBEAR,LRBEY,LRBETEST,LRBEPAN,LRBEDEL) ; Build LRBEAR array with
        ; CIDC information
        N LRBEODT,LRBEIEN,LRBETST,LRBETS,LRJ,N,NX,P,X,XX,REQX,OK
        S LRBEAR(LRBEDFN,"DSS ID")=LROOS
        S LRBEAR(LRBEDFN,"ORDGX")="O"
        S LRBEAR(LRBEDFN,"DOS")=LRBECDT
        S LRBEAR(LRBEDFN,"PAT")=$G(LRBEDFN)
        S LRBEAR(LRBEDFN,"POS")=LROOS
        S LRBEAR(LRBEDFN,"DEL")=LRBEDEL
        S LRBEAR(LRBEDFN,"USR")=DUZ
        S LRBEIEN=LRSN_","_LRODT_","
        S LRBEAR(LRBEDFN,"ORDPRO")=$$GET1^DIQ(69.01,LRBEIEN,7,"I")
        S:'+$G(LRSAMP) LRSAMP=$$GET1^DIQ(69.01,LRBEIEN,3,"I")
        ;reset LRBETEST, LRBEY for panel tests
        S LRBETS="" F  S LRBETS=$O(^LRO(69,LRODT,1,LRSN,2,"B",LRBETS)) Q:'LRBETS  D
        .S LRJ=$O(^LRO(69,LRODT,1,LRSN,2,"B",LRBETS,0))
        .Q:($P(^LRO(69,LRODT,1,LRSN,2,LRJ,0),U,9)="CA")
        .I $G(ORIEN),$P(^LRO(69,LRODT,1,LRSN,2,LRJ,0),U,7)'=ORIEN Q
        .I ($G(^LAB(60,LRBETS,12))),($D(^LAB(60,LRBETS,0))#2),'$L($P($G(^LAB(60,LRBETS,0)),U,5)) S LRBEPAN(LRBETS)=""
        .S OK=0,N=0 F  S N=$O(LRBETEST(N)) Q:'N  I LRBETS=+LRBETEST(N) S OK=1
        .I 'OK S N=$O(LRBETEST(""),-1),N=N+1,LRBETEST(N)=LRBETS_U_^LAB(60,LRBETS,0),LRBETEST(N,"P")=LRBETS_U_$$NLT^LRVER1(LRBETS)
        .S NX=0 F  S NX=$O(^LAB(60,LRBETS,2,NX)) Q:'NX  D
        ..S X=+^LAB(60,LRBETS,2,NX,0)
        ..S XX=$P($P(^LAB(60,X,0),U,5),";",2),REQX=$P(^(0),U,17)
        ..I XX,$D(LRBESB(XX)) S P(LRBETS,XX,X)=""
        ..I XX,$D(LRBEPAN(LRBETS)),REQX S P(LRBETS,XX,X)="R"
        ..;if XX null, then possibly another panel
        ..I 'XX D PARRAY(X,LRBETS,.P)
        .;reset LRBEY array;
        .;1st subscript is panel test; 2nd subscript is data identifier of atomic test
        .I $D(P(LRBETS)) D
        ..;retain original LRBEY array node if atomic test exists as a separate accession
        ..I '$D(^LRO(68,$G(LRAA),1,$G(LRAD),1,$G(LRAN),4,LRBETS,0)) K LRBEY(LRBETS)
        ..S XX=0 F  S XX=$O(P(LRBETS,XX)) Q:'XX  D
        ...S LRBEY(LRBETS,XX)=""
        ...S X=$O(P(LRBETS,XX,0))
        ...I P(LRBETS,XX,X)="R" S LRBEY(LRBETS,XX,"R")=X
        ;continue
        S LRBETS="" F  S LRBETS=$O(LRBETEST(LRBETS)) Q:LRBETS=""  D
        .S LRBETST=$P(LRBETEST(LRBETS),U,1)
        .D BLDAR^LRBEBA2(LRBEDFN,LRODT,LRSN,LRBETS,LRSAMP,LRSPEC,LRBETST,.LRBEAR)
        Q
        ;
PARRAY(XTEST,PTEST,P)   ;
        N NX,X,XX,REQX
        S NX=0 F  S NX=$O(^LAB(60,XTEST,2,NX)) Q:'NX  D
        .S X=+^LAB(60,XTEST,2,NX,0)
        .S XX=$P($P(^LAB(60,X,0),U,5),";",2),REQX=$P(^(0),U,17)
        .I XX,$D(LRBESB(XX)) S P(PTEST,XX,X)=""
        .I XX,$D(LRBEPAN(PTEST)),REQX S P(PTEST,XX,X)="R"
        Q
        ;
QRYADD(LRODT,LRSN,LRTS,LRBEDFN,LRBESMP,LRBESPC,LRBETS,LRBEX,LRBEXD)     ; Query #69 for
        ; default LRBEDGX and SC/EI
        N LRBEA,LRDGX,LRDX,LRDGXD
        S LRDGX=0
        F  S LRDGX=$O(^LRO(69,LRODT,1,LRSN,2,LRTS,2,LRDGX)) Q:LRDGX<1  D
        .S LRDGXD=2
        .S LRBEPTDT=$G(^LRO(69,LRODT,1,LRSN,2,LRTS,2,LRDGX,0)) Q:'LRBEPTDT
        .S LRBEA=$P(LRBEPTDT,U,1)_"^^^"_$P(LRBEPTDT,U,4)_U_$P(LRBEPTDT,U,5)
        .S LRBEA=LRBEA_U_$P(LRBEPTDT,U,2)_U_$P(LRBEPTDT,U,6)_U_$P(LRBEPTDT,U,8)
        .S LRBEA=LRBEA_U_$P(LRBEPTDT,U,7)_U_$P(LRBEPTDT,U,3)_U_$P(LRBEPTDT,U,10)
        .I $P(LRBEPTDT,U,9)=1 S LRBEA=LRBEA_U_$P(LRBEPTDT,U,9),LRDGXD=1
        .S LRBEX(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETS,$P(LRBEA,U))=LRBEA
        .S LRBEXD(LRBEDFN,"LRBEDGX",LRBESMP,LRBESPC,LRBETS,LRDGXD,$P(LRBEA,U))=LRBEA
        Q
        ;
ELIG(DFN)       ; Display eligibility and disabilities
        D ELIG^VADPT W !," Eligibility: "_$P(VAEL(1),"^",2)_$S(+VAEL(3):"    SC%: "_$P(VAEL(3),"^",2),1:"")
        W !," Disabilities: " F I=0:0 S I=$O(^DPT(DFN,.372,I)) Q:'I  S I1=$S($D(^DPT(DFN,.372,I,0)):^(0),1:"") D:+I1
        .S LRDIS=$S($P($G(^DIC(31,+I1,0)),"^")]""&($P($G(^(0)),"^",4)']""):$P(^(0),"^"),$P($G(^DIC(31,+I1,0)),"^",4)]"":$P(^(0),"^",4),1:""),LRCNT=$P(I1,"^",2)
        .S LRDIS=$E(LRDIS,1,55)
        .I LRDIS]"" W ?15,LRDIS_" - "_LRCNT_"%("_$S($P(I1,"^",3):"SC",1:"NSC")_")",!
        K LRDIS,LRCNT,I,I1,VAEL
        Q
        ;
BALROW(LRODT,LRSN,LRTEST)       ; CIDC LROW
        N LRBEA,LRBEB,LRBEAT,LRBET,LRBESN,LRBETS,LRBETST,LRBEQT,LRBEOT,LRBEVAL
        S LRBEVAL=$D(^XUSEC("PROVIDER",DUZ)) Q:'LRBEVAL
        S LRBEVAL=$$CIDC^IBBAPI(DFN) Q:'LRBEVAL
        I '$D(DFN) S LRBEDFN=$$GET1^DIQ(63,LRDFN_",",.03,"I")
        S:$G(LRSN)="" LRSN=1
        D SLROT^LRBEBA3(.LRXST,.LRTEST,.LRBEOT) S:$G(LRSS)="" LRSS="CH"
        S LRBEAT=1,LRBEY=$$SBA^LRBEBA31(LRDFN,.LRBEX,.LRBEQT,.LRBEOT)
        Q
        ;
AQ1     ; Ask question from LRORD1
        N LRBEVAL
        S LRBEVAL=$D(^XUSEC("PROVIDER",DUZ)) Q:'LRBEVAL
        S LRBEVAL=$$CIDC^IBBAPI(DFN) Q:'LRBEVAL
        K LRBEODT D DT^LRX S LRBEODT=%
        S:$G(LRSS)="" LRSS="CH"
        S LRBEAT=1,LRBEY=$$SBA^LRBEBA31(LRDFN,.LRBEX,.LRBEQT,.LROT)
        Q
        ;
AQ2     ; from LROW2A
        N LRBEVAL
        S LRBEVAL=$$CIDC^IBBAPI(DFN) Q:'LRBEVAL
        D SACC^LRBEBA2(LRODT,LRSN,LRTN,LRSSP,LRSPEC,$P(LRTEST(LRI),U,1),.LRBEX)
        Q
        ;
SVST(ENUM,ETYP,LRODT,LRSN)      ; Set the Encounter # in #69
        S ^LRO(69,LRODT,1,LRSN,ETYP)=ENUM
        Q
        ;
BALROR(LRORD)   ; CIDC LRORD
        N LRBEA,LRBEAT,LRBEB,LRBET,LRBESN,LRBETS,LRBETST,LRBEQT,LRBEODT
        N LRBEOT,LRBEVAL,LRBEZ,LRBETN
        S LRBEVAL=$D(^XUSEC("PROVIDER",DUZ)) Q:'LRBEVAL
        S LRBEVAL=$$CIDC^IBBAPI(DFN) Q:'LRBEVAL
        I '$D(DFN) S LRBEDFN=$$GET1^DIQ(63,LRDFN_",",.03,"I")
        S LRBEAT=1,LRBEY=$$SBA^LRBEBA31(LRDFN,.LRBEX,.LRBEQT,.LROT)
        Q
        ;
SLROT(LRXST,LRTEST,LRBEOT)      ;LROT array
        N LRBEA,LRBESMP,LRBESPC
        S LRBESMP="" F  S LRBESMP=$O(LRXST(LRBESMP)) Q:LRBESMP=""  D
        .S LRBEA="" F  S LRBEA=$O(LRXST(LRBESMP,LRBEA)) Q:LRBEA=""  D
        ..S LRBESPC=$P(LRXST(LRBESMP,LRBEA),U,1)
        ..S LRBEOT(LRBESMP,LRBESPC,LRBEA)=$P(LRTEST(LRBEA),U,1)
        Q
        ;
MICRO1(LRODT,LRSN,LRTST,LRCNT)  ;get CIDC data for microbiology
        ;called from LRCAPPH1
        N LRBETM
        N AA,DX,DXCNT,FINAL,GOPRO,GEPRO,MOD,ORD,N,X
        S FINAL=$$FINAL^LRBEBA3(LRODT,LRSN,LRTST)
        I $P(FINAL,U)=0 K ^TMP("LRPXAPI",$J,"PROCEDURE",LRCNT) Q
        ;continue if micro test completed
        S DXCNT=+$O(^TMP("LRBEDX",$J,999),-1)
        S LRBETM=$P($G(^LRO(69,LRODT,1,LRSN,3)),U) I 'LRBETM S LRBETM=LRODT
        S LRBETM=$$PCETM^LRBEBAO(LRBETM)
        S ^TMP("LRPXAPI",$J,"PROCEDURE",LRCNT,"EVENT D/T")=LRBETM
        S AA=$P($P(FINAL,";",2),U,4)
        S GOPRO=$$GOPRO^LRBEBA4(LRODT,LRSN)
        S GEPRO=$$GEPRO^LRBEBA4(AA)
        S ^TMP("LRPXAPI",$J,"PROVIDER",1,"NAME")=GOPRO
        S ^TMP("LRPXAPI",$J,"PROVIDER",1,"PRIMARY")=1
        S ^TMP("LRPXAPI",$J,"PROCEDURE",LRCNT,"ORD PROVIDER")=GOPRO
        S ^TMP("LRPXAPI",$J,"PROCEDURE",LRCNT,"ENC PROVIDER")=GEPRO
        S ORD=$P($P(FINAL,";",2),U,7)
        S ^TMP("LRPXAPI",$J,"PROCEDURE",LRCNT,"ORD REFERENCE")=ORD
        S ^TMP("LRBEDX",$J,"ID")=LRODT_U_LRSN
        S N=0 F  S N=$O(^LRO(69,LRODT,1,LRSN,2,LRTST,2,N)) Q:'N  Q:N>4  D
        .S X=^LRO(69,LRODT,1,LRSN,2,LRTST,2,N,0)
        .S DXCNT=DXCNT+1,^TMP("LRBEDX",$J,DXCNT)=X
        .I N=1 S ^TMP("LRPXAPI",$J,"PROCEDURE",LRCNT,"DIAGNOSIS")=$P(X,U,1)
        .I N>1 S ^TMP("LRPXAPI",$J,"PROCEDURE",LRCNT,"DIAGNOSIS "_N)=$P(X,U,1)
        Q
        ;
MICRO2(LRODT,LRSN)      ;setup more CIDC data for microbiology
        ;called from LRCAPPH1
        N DXCNT,EI,EIX,X
        S X=$G(^TMP("LRBEDX",$J,"ID"))
        I ($P(X,U)'=LRODT)!($P(X,U,2)'=LRSN) Q
        S DXCNT=+$O(^TMP("LRBEDX",$J,999),-1)
        Q:'DXCNT
        S DXCNT=0 F  S DXCNT=$O(^TMP("LRBEDX",$J,DXCNT)) Q:'DXCNT  D
        .S X=^TMP("LRBEDX",$J,DXCNT)
        .S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"DIAGNOSIS")=$P(X,U,1)
        .I $P(X,U,2)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL SC")=$P(X,U,2),EIX("SC")=$G(EIX("SC"))+$P(X,U,2)
        .I $P(X,U,3)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL CV")=$P(X,U,3),EIX("CV")=$G(EIX("CV"))+$P(X,U,3)
        .I $P(X,U,4)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL AO")=$P(X,U,4),EIX("AO")=$G(EIX("AO"))+$P(X,U,4)
        .I $P(X,U,5)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL IR")=$P(X,U,5),EIX("IR")=$G(EIX("IR"))+$P(X,U,5)
        .I $P(X,U,6)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL EC")=$P(X,U,6),EIX("EC")=$G(EIX("EC"))+$P(X,U,6)
        .I $P(X,U,7)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL MST")=$P(X,U,7),EIX("MST")=$G(EIX("MST"))+$P(X,U,7)
        .I $P(X,U,8)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL HNC")=$P(X,U,8),EIX("HNC")=$G(EIX("HNC"))+$P(X,U,8)
        .I $P(X,U,10)'="" S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PL SHAD")=$P(X,U,10),EIX("SHAD")=$G(EIX("SHAD"))+$P(X,U,10)
        .I $P(X,U,9) S ^TMP("LRPXAPI",$J,"DX/PL",DXCNT,"PRIMARY")=$P(X,U,9)
        F EI="SC","CV","AO","IR","EC","MST","HNC","SHAD" D
        .I $G(EIX(EI))>1 S EIX(EI)=1
        .I $G(EIX(EI))'="" S ^TMP("LRPXAPI",$J,"ENCOUNTER",1,EI)=EIX(EI)
        Q
        ;
FINAL(LRODT,LRSN,LRTST) ;is microbiology test complete/final?
        ;called from MICRO1 only
        ;returns 1_";"_<0-node of order>, if test completed
        ;        otherwise returns 0
        N AA,AI,AY,NODEO,NODEA,NOKILL,RETURN,TST,TT,X
        S RETURN=0,NODEA=""
        S NODEO=$G(^LRO(69,LRODT,1,LRSN,2,LRTST,0))
        S TST=$P(NODEO,U),AY=$P(NODEO,U,3),AA=$P(NODEO,U,4),AI=$P(NODEO,U,5)
        I TST,AA,AI,AY S NODEA=$G(^LRO(68,AA,1,AY,1,AI,4,TST,0))
        ;does complete date exist?
        I $P(NODEA,U,5) S RETURN=1_";"_NODEO
        I RETURN'=0 D
        .S $P(^LRO(69,LRODT,1,LRSN,2,LRTST,0),U,12)=1
        .S NOKILL=0
        .S TT=0 F  S TT=$O(^LRO(69,LRODT,1,LRSN,2,TT)) Q:'TT  D
        ..S NODEO=^LRO(69,LRODT,1,LRSN,2,TT,0),AA=$P(NODEO,U,4)
        ..I AA,$P(NODEO,U,12)'=1,$P($G(^LRO(68,AA,0)),U,2)="MI" S NOKILL=1
        .I NOKILL=0 S ^LRO(69,"AA",LRCEX,LROA)=""
        Q RETURN
