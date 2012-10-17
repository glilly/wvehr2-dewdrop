PRCB139P        ;VMP/RB-MODIFY ALL FY01 THROUGH FY11 CEILING TRANSACTIONS TO 5 DIGIT SEQ NUMBER
        ;;5.1;IFCAP;**139**;Oct 01, 2009;Build 16
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;  Post install routine in patch PRC*5.1*139 that will modify all existing
        ;  ceiling Transaction in file #421 for FY 2001-2011 from 4 digit sequence 
        ;  number to 5 digit sequence number
        ;;
        Q
START   ;Modify ceiling tx sequence numbers from 4 to 5 digits for FY 2001-2011
        I $D(^XTMP("PRCB139P")) Q
        K ^XTMP("PRCB139P") D NOW^%DTC S RMSTART=%
        S ^XTMP("PRCB139P","START COMPILE")=RMSTART
        S ^XTMP("PRCB139P","END COMPILE")="RUNNING"
        S ^XTMP("PRCB139P",0)=$$FMADD^XLFDT(RMSTART,120)_"^"_RMSTART
        S U="^",IEN421=0
1       S IEN421=$O(^PRCF(421,IEN421)) G EXIT:'IEN421
        S R0=$G(^PRCF(421,IEN421,0)) I R0="" G 1
        S TX421=$P(R0,U) I $P(TX421,"-",2)<01!($P(TX421,"-",2)>11) G 1
        I $L($P(TX421,"-",3))=5 G 1
2       ;.01 FIELD IN 0 NODE
        S SEQ=$P(TX421,"-",3),WSEQ="0000"_SEQ,WSEQ=$E(WSEQ,$L(WSEQ)-4,$L(WSEQ))
        S WTX421=$P(TX421,"-",1,2)_"-"_WSEQ
        ;W !,IEN421,?10,TX421,?30,SEQ,?40,WSEQ,?50,WTX421
3       ;'B' X-REF
        S $P(R0,U)=WTX421,^PRCF(421,IEN421,0)=R0
        K ^PRCF(421,"B",TX421,IEN421) S ^PRCF(421,"B",WTX421,IEN421)=""
4       ;'AD' X-REF
        S RVSEQ=10000-SEQ,NRVSEQ=100000-SEQ
        S ^XTMP("PRCB139P",2,"AD",$P(TX421,"-",1,2),RVSEQ)=""
        S ^XTMP("PRCB139P",2,"B",TX421,IEN421)=""
        S ^XTMP("PRCB139P",2,"D",SEQ,IEN421)=""
        K ^PRCF(421,"AD",$P(TX421,"-",1,2),RVSEQ) S ^PRCF(421,"AD",$P(WTX421,"-",1,2),NRVSEQ)=""
        S ^XTMP("PRCB139P",1,IEN421,0)=TX421_U_WTX421_U_SEQ_U_WSEQ_U_RVSEQ_U_NRVSEQ
5       ;'AD' X-REF
        K ^PRCF(421,"D",SEQ,IEN421) S ^PRCF(421,"D",WSEQ,IEN421)=""
        G 1
EXIT    ;
        D NOW^%DTC S RMEND=%
        S ^XTMP("PRCB139P","END COMPILE")=RMEND
        K RMEND,RMSTART,%,IEN421,R0,TX421,SEQ,WSEQ,WTX421,RVSEQ,NRVSEQ
        Q
