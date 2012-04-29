SROCODE ;BIR/MAM - SET UP FLAG FOR ANESTHESIA AGENTS ;01/30/08
        ;;3.0; Surgery ;**72,41,114,151,166**;24 Jun 93;Build 7
        ;
        ; Reference to ENS^PSSGIU supported by DBIA #895
        ;
1       N SRTEST S SRTEST=50,SRTEST(0)="AEQSZ",SRTEST("A")="Enter the name of the drug you wish to flag: "
        D DIC^PSSDI(50,"SR",.SRTEST) G:+Y<1 DONE S SROIUDA=+Y,SROIRX=$P(Y,"^",2),SROIUX="S^SURGERY" D SROIU
        G 1
SROIU   Q:'$D(SROIUDA)!'$D(SROIUX)  Q:SROIUX'?1E1"^"1.E
        N SRRX D DATA^PSS50(SROIUDA,,,,,"SRRX") S SRRX=$G(^TMP($J,"SRRX",SROIUDA,63)) D
        .S SROIUY=$S($D(SRRX):SRRX,1:""),SROIUT=$P(SROIUX,"^",2),SROIUT=$E("N","AEIOU"[$E(SROIUT))_" "_SROIUT K ^TMP($J,"SRRX",SROIUDA)
        I SROIUY["S" W !!,"This drug is already flagged for SURGERY." K DIR S DIR("A")="Do you want to remove the flag (Y/N)",DIR(0)="Y" D ^DIR D:Y OFF D DONE Q
        W !! K DIR S DIR("A")="Do you want to flag this drug for SURGERY (Y/N)",DIR(0)="Y" D ^DIR D:Y FLAG
DONE    W @IOF K SROIRX D ^SRSKILL
        Q
FLAG    S PSIUDA=SROIUDA,PSIUX=SROIUX_"^1"
        S X="PSSGIU" X ^%ZOSF("TEST") I $T D ENS^PSSGIU
        ;HL7 master file update (addition) to anesthesia agent list
        N SRTBL,SRENT,FEC,REC S SRTBL="ANESTHESIA AGENT^50^.01",FEC="UPD",REC="MAD",SRENT=SROIUDA_U_SROIRX D MSG^SRHLMFN(SRTBL,FEC,REC,SRENT)
        ;A call to PDM to possibly generate an HL7 outgoing drug message
        S X="PSSHUIDG" X ^%ZOSF("TEST") I $T D DRG^PSSHUIDG(PSIUDA)
        K PSIUDA,PSIUX
        Q
OFF     S PSIUDA=SROIUDA,PSIUX=SROIUX_"^1"
        S X="PSSGIU" X ^%ZOSF("TEST") I $T D END^PSSGIU
        ;HL7 master file update (deletion) to anesthesia agent list
        N SRTBL,SRENT,FEC,REC S SRTBL="ANESTHESIA AGENT^50^.01",FEC="UPD",REC="MDL" D DATA^PSS50(SROIUDA,,,,,"SRRX")
        S SRENT=SROIUDA_U_$P($G(^TMP($J,"SRRX",SROIUDA,.01)),"^") K ^TMP($J,"SRRX",SROIUDA) D MSG^SRHLMFN(SRTBL,FEC,REC,SRENT)
        ;A call to PDM to possibly generate an HL7 outgoing drug message
        S X="PSSHUIDG" X ^%ZOSF("TEST") I $T D DRG^PSSHUIDG(PSIUDA)
        K PSIUDA,PSIUX
        Q
