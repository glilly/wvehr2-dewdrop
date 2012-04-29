PSSP138  ;BIR/RJS-DOSAGE FORM NOUN & LOCAL POSSIBLE DOSAGE "&" CLEANUP
        ;;1.0; PHARMACY DATA MANAGEMENT;**138**;9/30/97;Build 5
        ;;Reference to $$SETSTR^VALM1 is covered by DBIA #10116
        ;;Reference to $$TRIM^XLFSTR is covered by DBIA #10104
        ;;Reference to ^XMD is covered by DBIA #10070
        ;;
NOUN    ;CONVERY & TO AND
        N X
        S PSSIEN=0 F  S PSSIEN=$O(^PS(50.606,PSSIEN)) Q:'PSSIEN  D
        .S PSSNN=0 F  S PSSNN=$O(^PS(50.606,PSSIEN,"NOUN",PSSNN)) Q:'PSSNN  D
        ..S PSSNNN=$G(^PS(50.606,PSSIEN,"NOUN",PSSNN,0))
        ..I PSSNNN["&" S PSLOCV=$P(PSSNNN,"^",1) D
        ...D AMP^PSSORPH1
        ...S PSSNNN=$$TRIM^XLFSTR(PSLOCV,"LR"," ") K PSLOCV
        ...S ^TMP($J,"PSSP138-1",PSSIEN,PSSNN)=PSSNNN
        S XMSUB="PSS*1*138 Dosage Form Repair Report",PSSRPT="PSSP138-N"
        S ^TMP($J,PSSRPT,1)="PSS*1*138 Dosage Form Repair"
        S ^TMP($J,PSSRPT,2)="The following Dosage Form NOUNS have been converted"
        S ^TMP($J,PSSRPT,3)=""
        I '$D(^TMP($J,"PSSP138-1")) S ^TMP($J,"PSSP138",4)="No NOUNS found containing &.",^TMP($J,PSSRPT,5)="",PSSCNT=5 D MAIL G DOS2
        S X="" D TXT("DOSAGE FORM",1),TXT("IEN",40),TXT("NOUN",48)
        S ^TMP($J,PSSRPT,4)=X,^TMP($J,PSSRPT,5)="",PSSCNT=5
        S PSSIEN=0 F  S PSSIEN=$O(^TMP($J,"PSSP138-1",PSSIEN)) Q:'PSSIEN  D
        .S PSSNN=0 F  S PSSNN=$O(^TMP($J,"PSSP138-1",PSSIEN,PSSNN)) Q:'PSSNN  D
        ..N DIE,DA,DR
        ..S PSSNM=$G(^TMP($J,"PSSP138-1",PSSIEN,PSSNN)),DA(1)=PSSIEN,DA=PSSNN
        ..S DIE="^PS(50.606,"_DA(1)_","_"""NOUN"""_",",DR=".01////^S X=PSSNM" D ^DIE
        ..S X="" D TXT($P(^PS(50.606,PSSIEN,0),"^"),1),TXT(PSSIEN,40),TXT(PSSNM,48)
        ..S PSSCNT=PSSCNT+1,^TMP($J,PSSRPT,PSSCNT)=X
        S PSSCNT=PSSCNT+1,^TMP($J,PSSRPT,PSSCNT)=""
        D MAIL
        ;
DOS2    ; Check and replace the "&" with "AND".
        N X
        S PSSDRG=0 F  S PSSDRG=$O(^PSDRUG(PSSDRG)) Q:'PSSDRG!(PSSDRG>999999999)  D
        .S PSSDOS=0 F  S PSSDOS=$O(^PSDRUG(PSSDRG,"DOS2",PSSDOS)) Q:'PSSDOS!(PSSDOS>9999)  D
        ..S PSSDOS2=$G(^PSDRUG(PSSDRG,"DOS2",PSSDOS,0))
        ..I PSSDOS2["&" S PSLOCV=$P(PSSDOS2,"^",1) D
        ...D AMP^PSSORPH1
        ...S PSSDOS2=$$TRIM^XLFSTR(PSLOCV,"LR"," ")
        ...S ^TMP($J,"PSSP138-2",PSSDRG,PSSDOS)=PSSDOS2
        S XMSUB="PSS*1*138 Local Possible Dosage Repair Report",PSSRPT="PSSP138-D"
        S ^TMP($J,PSSRPT,1)="PSS*1*138 Local Possible Dosage Repair"
        S ^TMP($J,PSSRPT,2)="The following Local Possible Dosages have been fixed"
        S ^TMP($J,PSSRPT,3)=""
        I '$D(^TMP($J,"PSSP138-2")) S ^TMP($J,PSSRPT,4)="No Local Possible Dosages found containing &.",^TMP($J,PSSRPT,5)="",PSSCNT=5 D MAIL G EXIT
        S X="" D TXT("Drug",1),TXT("IEN",40),TXT("Local Possible Dosage",48)
        S ^TMP($J,PSSRPT,4)=X,^TMP($J,PSSRPT,5)="",PSSCNT=5
        S PSSDRG=0 F  S PSSDRG=$O(^TMP($J,"PSSP138-2",PSSDRG)) Q:'PSSDRG  D
        .S PSSIEN=0 F  S PSSIEN=$O(^TMP($J,"PSSP138-2",PSSDRG,PSSIEN)) Q:'PSSIEN  D
        ..N DIE,DA,DR
        ..S PSSNM=$G(^TMP($J,"PSSP138-2",PSSDRG,PSSIEN)),DA(1)=PSSDRG,DA=PSSIEN
        ..S DIE="^PSDRUG("_DA(1)_","_"""DOS2"",",DR=".01////^S X=PSSNM" D ^DIE
        ..S X="" D TXT($P(^PSDRUG(PSSDRG,0),"^"),1),TXT(PSSIEN,40),TXT(PSSNM,48)
        ..S PSSCNT=PSSCNT+1,^TMP($J,PSSRPT,PSSCNT)=X
        S PSSCNT=PSSCNT+1,^TMP($J,PSSRPT,PSSCNT)=""
MAIL    N DIFROM
        S PSSCNT=PSSCNT+1,^TMP($J,PSSRPT,PSSCNT)="***** End Of Report *****"
        S XMTEXT="^TMP($J,PSSRPT,",XMDUZ="PSS*1*138 Post Install"
        S XMY(DUZ)=""
        D ^XMD
EXIT    ; CLEAN UP
        K ^TMP($J),PSSCNT,PSSIEN,PSSDRG,PSSDOS,PSSDOS2,XMDUZ,XMSUB,XMTEXT,XMY,PSSNN,PSSNM,PSSNNN,PSSRPT
        Q
TXT(VAL,COL)    S:'$D(X) X="" S X=$$SETSTR^VALM1(VAL,X,COL,$L(VAL))
        Q
