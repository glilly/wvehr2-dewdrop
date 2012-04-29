ENTIRS  ;WOIFO/LKG - SIGN RESPONSIBILITIES ;2/5/08  14:57
        ;;7.0;ENGINEERING;**87**;Aug 17, 1993;Build 16
IN      ;Entry point
        K ^TMP($J,"SCR"),^TMP($J,"INDX"),ENACL S:'$G(DT) DT=$$DT^XLFDT()
        S ENJ="",ENC=0
        F  S ENJ=$O(^ENG(6916.3,"AOA",DUZ,ENJ)) Q:ENJ=""  D
        . S ENI=""
        . F  S ENI=$O(^ENG(6916.3,"AOA",DUZ,ENJ,ENI)) Q:ENI=""  D
        . . S ENNOD0=$G(^ENG(6916.3,ENI,0)) Q:ENNOD0=""
        . . Q:$P(ENNOD0,U,8)'=""
        . . I $P(ENNOD0,U,5),$$FMDIFF^XLFDT(DT,$P(ENNOD0,U,5))<360 Q
        . . S ENIC=ENI_"," K END,ENERR D GETS^DIQ(6916.3,ENIC,".01;1;20","E","END","ENERR")
        . . S ENDAC=$P(ENNOD0,U)_"," D GETS^DIQ(6914,ENDAC,"3;4;5","E","END","ENERR")
        . . S ENC=ENC+1
        . . S ^TMP($J,"SCR",ENC)=$G(END(6916.3,ENIC,.01,"E"))_U_$E($G(END(6914,ENDAC,3,"E")),1,20)_U_$G(END(6914,ENDAC,4,"E"))_U_$G(END(6914,ENDAC,5,"E"))
        . . S ^TMP($J,"INDX",ENC)=ENI
        I 'ENC W !!,"There are no assignment to sign." K DIR S DIR(0)="E" D ^DIR K DIR G EX
        S ^TMP($J,"SCR")=ENC_"^IT RESPONSIBILITIES REQUIRING SIGNATURE BY "_$G(END(6916.3,ENIC,1,"E"))
        S ^TMP($J,"SCR",0)="5;9;ENTRY #^15;20;MFG EQUIP NAME^37;25;MODEL^65;14;SERIAL#"
        D EN2^ENPLS2(1) G:'$D(ENACL) EX
        K DIR S DIR(0)="Y",DIR("A")="OK to continue",DIR("B")="NO" D ^DIR K DIR
        G:'Y!$D(DIRUT) EX
        N L,DIC,FLDS,FR,TO,BY,IOP,DHD
        S ENDA=$O(^ENG(6916.2,"@"),-1)
        I '$$CMP^XUSESIG1($P($G(^ENG(6916.2,ENDA,0)),U,3),$NAME(^ENG(6916.2,ENDA,1))) W !!,"Hand receipt text is corrupted - Please contact EPS AEMS/MERS support" G EX
        S L=0,DIC=6916.2,FLDS=1,FR=ENDA,TO=ENDA,BY="@NUMBER",IOP="HOME",DHD="@"
        D EN1^DIP
        K DIR S DIR(0)="Y",DIR("A")="OK to sign",DIR("B")="NO" D ^DIR K DIR
        G:'Y!$D(DIRUT) EX
        D SIG^XUSESIG I X1="" W !,"<Invalid Electronic Signature> Signing Aborted." G EX
        S ENCNT=0,ENX=""
        F  S ENX=$O(ENACL(ENX)) Q:ENX=""  D
        . N ENXSTR S ENXSTR=$G(ENACL(ENX)) Q:ENXSTR=""
        . I $L(ENXSTR,",")>0 D
        . . F ENJ=1:1 S ENI=$P(ENXSTR,",",ENJ) Q:+ENI'>0  D
        . . . S ENDA=^TMP($J,"INDX",ENI) L +^ENG(6916.3,ENDA):$S($G(DILOCKTM)>5:DILOCKTM,1:5) E  D MSG^ENTIRT(ENDA,"Signature") Q
        . . . S ENZ=$$SIGN^ENTIUTL1(ENDA)
        . . . S:ENZ ENCNT=ENCNT+1 D:'ENZ MSG2(ENDA)
        . . . L -^ENG(6916.3,ENDA)
        W !!,ENCNT," assignment records were signed."
EX      ;
        K ^TMP($J,"SCR"),^TMP($J,"INDX"),DIROUT,DIRUT,DTOUT,DUOUT,ENACL,ENCNT,ENDA,ENDAC,ENI,ENIC,ENJ,ENC,END,ENERR,ENNOD0,ENX,ENZ,X,X1,Y
        Q
MSG2(ENDA)      ;error message on signing failure
        N END,ENERR,ENDAC S ENDAC=ENDA_","
        D GETS^DIQ(6916.3,ENDAC,".01;1","E","END","ENERR")
        W !,"Assignment Equip Entry# ",$G(END(6916.3,ENDAC,.01,"E"))," for ",$G(END(6916.3,ENDAC,1,"E"))," is not active ",!?5,"and was not signed."
        Q
        ;
        ;ENTIRS
