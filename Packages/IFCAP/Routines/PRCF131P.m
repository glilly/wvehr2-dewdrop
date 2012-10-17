PRCF131P        ;VMP/RB - PURGE FILE ^PRCF(421.9 IF 442 ENTRY PURGED #410 ;03/09/09
        ;;5.1;IFCAP;**131**;02/09/09;Build 13
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;;
        Q
FIX     ;
        ;1. Post install to delete entries in file ^PRCF(421.9) that have .01
        ;   field with no existing ^PRC(442) corresponding endtry for PO number
        ;
BUILD   K ^XTMP("PRCF131P") D NOW^%DTC S RMSTART=%
        S ^XTMP("PRCF131P","START COMPILE")=RMSTART
        S ^XTMP("PRCF131P","END COMPILE")="RUNNING"
        S ^XTMP("PRCF131P",0)=$$FMADD^XLFDT(RMSTART,120)_"^"_RMSTART
0       ;FIND ^PRCF(421.9) entries with no ^PRC(442) matching rec for po#
        S IEN4219=0,IEN442=0,U="^"
1       S IENREC0="",PRCFPO="",IEN442=0
        S IEN4219=$O(^PRCF(421.9,IEN4219)) G EXIT:IEN4219=""!(IEN4219]"@")
        S IENREC0=$G(^PRCF(421.9,IEN4219,0)) I IENREC0="" S ERTYP=1,IENREC0="MISSING 0 NODE" G 3
        S PRCFPO=$P(IENREC0,U) I PRCFPO="" S ERTYP=2 G 3
        S IEN442=$O(^PRC(442,"B",PRCFPO,0)) I IEN442="" S ERTYP=3 G 3
        I '$D(^PRC(442,IEN442,0)) S ERTYP=4 G 3
        G 1
3       S ^XTMP("PRCF131P",421.9,IEN4219,ERTYP)=IENREC0
        S $P(^XTMP("PRCF131P",421.9,IEN4219,ERTYP),U,5)=$G(IEN442)
        S DA=IEN4219,DIK="^PRCF(421.9," D ^DIK K DA,DIK
        G 1
EXIT    ;
        D NOW^%DTC S RMEND=%
        S ^XTMP("PRCF131P","END COMPILE")=RMEND
        K IEN4219,IENREC0,PRCFPO,IEN442,ERTYP,%,DA,RMEND,RMSTART
        Q
