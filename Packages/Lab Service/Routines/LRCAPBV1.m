LRCAPBV1        ;DALOI/FHS - PROCESS VBEC PCE WORKLOAD API ; 4/3/07 3:31am
        ;;5.2;LAB SERVICE;**325**;Sep 27,1994;Build 34
        ;Reference to $$FIND1^DIC supported by IA #2051
        ;Reference to FILE^DID supported by IA #2052
        ;Reference to FILE^DIE supported by IA #2053
        ;Reference to UPDATE^DIE supported by IA #2053
        ;Reference to GETS^DIQ supported by IA #2056
        ;Reference to $$GET^XUA4A72 supported by IA #1625
        Q
EN(LREDT,LRDUZ,LRTSTP,LRDSSLOC,LRDSSID,LRNINS,DFN,LRPRO,LRCNT)  ;Call LRCAPPH1 to send PCE workload
        ;LREDT = Encounter Date
        ;LRDUZ = User
        ;LRTSTP = ^LAB(60 IEN
        ;LRDSSLOC = DSS LOCATION
        ;LRDSSID = DSS ID
        ;LRNINIS = Instution
        ;DFN = Patient
        ;LRPRO = Provider
        ;LRCNT = set negative if the test is cancelled.
        I LRCNT<1 S LRNP=1
        K ^TMP("LRPXAPI",$J),LROK,LRXTST
        K LRICPT,CPT,LRCEX,LRREL,LRINA,LRNOP,EDATE
        S (LROA,LRCEX)=0,ERR=699,EDATE=$P(LREDT,".")
        S LRESCPT=0,LRTST=LRTSTP
        I $$GET^XUA4A72(LRPRO)<1 D
        . S LRPRO=LRDPRO
EN6     D EN6^LRCAPPH1
        I $G(LRNOP) D  Q
        . S ERR="PCE+"_LRNOP D EUPDATE^LRCAPBV
        S ERR=0
        I $D(^LRO(69,LRCDT,1,LRSN,0)) S ^("PCE")=""
        I $D(^TMP("LRPXAPI",$J,"PROCEDURE")) D SEND^LRCAPPH1
        K LRFDA(3)
        I $G(LROK)>0 D  Q
        . S LRFDA(3,6002.01,LRIEN_",",99)=LRVSITN
        . D FILE
PCEERR  ;PCE error logging
        Q:'$G(LROK)
        S LRFDA(3,6002.01,LRIEN_",",21)="PCE "_LROK_" Error"
        S LRFDA(3,6002.01,LRIEN_",",5)="E"
FILE    ;
        D FILE^DIE("S","LRFDA(3)","ERR")
        Q
NLT(LRP,LRSUF)  ;Lookup or create new NLT code
        N ANS,FDA,LRFDA,FLD,ERR,LRPN,LRLRT,LRLRTN
        I '$D(^LAM(+$G(LRP),0))#2 S ERR="No NLT Code" Q 0
        I '$G(LRSUF) Q +$G(LRP)
        D GETS^DIQ(64,LRP_",",".01:16","IEN","ANS","ERR")
        D GETS^DIQ(64.2,LRSUF_",",".01;1","IEN","ANS","ERR")
        S LRLRT=$G(ANS(64,LRP_",",.01,"I"))_"~"_$G(ANS(64.2,LRSUF_",",.01,"I"))
        S LRLRTN=$P($G(ANS(64,LRP_",",1,"I")),".")_$G(ANS(64.2,LRSUF_",",1,"I"))
NLT1    ;Lookup
        S LRPN=$$FIND1^DIC(64,"","O",LRLRTN_" ","C","","ERR")
        I LRPN>0 Q LRPN
        S FLD="" F  S FLD=$O(ANS(64,LRP_",",FLD)) Q:FLD=""  D
        . S LRFDA(1,64,"+1,",FLD)=$G(ANS(64,LRP_",",FLD,"I"))
        S LRFDA(1,64,"+1,",.01)=LRLRT
        S LRFDA(1,64,"+1,",1)=LRLRTN
        D UPDATE^DIE("S","LRFDA(1)","FDA","ERR")
        S LRPN=FDA(1)
        Q LRPN
        Q
