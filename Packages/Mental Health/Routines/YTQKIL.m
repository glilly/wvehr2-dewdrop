YTQKIL  ;ASF/ALB MHA3 DELETES ; 10/31/07 12:54pm
        ;;5.01;MENTAL HEALTH;**85,100**;Dec 30, 1994;Build 2
        Q
EN      ;
        N DIR,DIRUT,YS71,YSAD,YSANS,YSASNOW,YSGIVEN,YSORD,YSORDID,YSSITE,YSTST,G,N,X,YSGIVEFM
        I '$D(^YTT(601.84,"C",YSDFN)) W !,"No MH administration/test data exists for this patient." H 4 Q
        K YSDATA
        S YS("DFN")=YSDFN,YS("COMPLETE")="Y" D ADMINS^YTQAPI5(.YSDATA,.YS)
        S N=2 F  S N=$O(YSDATA(N)) Q:N'>0!($G(DIRUT))  D
        . S G=YSDATA(N)
        . S YSAD=$P(G,U) Q:YSAD'?1N.N  ;-->out
        . S YSTST=$P(G,U,2)
        . S YSGIVEN=$$GET1^DIQ(601.84,YSAD_",",3)
        . S YSGIVEFM=$$GET1^DIQ(601.84,YSAD_",",3,"I")
        . S YSGIVEFM=$$FMTHL7^XLFDT(YSGIVEFM)
        . S YSORD=$$GET1^DIQ(601.84,YSAD_",",5)
        . S YSORDID=$$GET1^DIQ(601.84,YSAD_",",5,"I")
        . S YS71=$O(^YTT(601.71,"B",YSTST,0))
        . W !,YSTST_" on "_YSGIVEN_" by "_YSORD
        . S DIR(0)="Y",DIR("A")="Delete",DIR("B")="No" D ^DIR
        . D:Y EMAIL,DEL
        Q
DEL     ;delete admin
        S DIR(0)="Y",DIR("A")="Are you sure",DIR("B")="No" D ^DIR
        Q:'Y
        K DIK
        S DIK="^YTT(601.84,",DA=YSAD D ^DIK
        S YSANS=0 F  S YSANS=$O(^YTT(601.85,"AD",YSAD,YSANS)) Q:YSANS'>0  D
        . S DIK="^YTT(601.85,",DA=YSANS D ^DIK
        W "  ***Deleted"
        Q
EMAIL   ;send message
        N XMDUZ,XMTEXT,XMY,XMZ,XMSUB
        K ^TMP($J,"YTQKIL")
        S YSSITE=$$KSP^XUPARAM("INST")
        S ^TMP($J,"YTQKIL",1,0)="#Delete#"_U_YSSITE_U_YSAD_U_YSTST_U_YS71_U_YSGIVEN_U_YSGIVEFM_U_YSORD_U_YSORDID
        S ^TMP($J,"YTQKIL",2,0)=" "
        S ^TMP($J,"YTQKIL",3,0)="Please delete this entry."
        ;
XMIT    ;transmit
        K XMZ S %DT="T",X="NOW" D ^%DT,DD^%DT
        S YSASNOW=Y
        K XMY S XMY("mhadelete@mentalhealth.med.va.gov")=""
        S XMDUZ=DUZ,XMTEXT="^TMP($J,""YTQKIL"",",XMSUB="Delete mha3 Admin from: "_YSSITE_" on "_YSASNOW D ^XMD
        K ^TMP($J,"YTQKIL")
        Q
