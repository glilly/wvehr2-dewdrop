SCRPW8  ;RENO/KEITH - Outpatient Encounter Workload Statistics ; 04 Feb 99  4:53 PM
        ;;5.3;Scheduling;**139,145,144,176,339,466,510**;AUG 13, 1993;Build 3
QS      ;Queue outpatient encounter workload report
        D PARM^SCRPW9 Q
        ;
PST     ;Print stats
        N X,Y,%
        D NOW^%DTC S Y=% X ^DD("DD") S SDPAGE=1,SDPNOW=$P(Y,":",1,2),SDDT=SDDTF,SDMC=$O(^DG(43,0)),SDMC=$G(^DG(43,+SDMC,"GL")),SDMD=$P(SDMC,U,2),(SDOUT,SDSTOP,SDFF)=0
        S SDDNAM=$P($G(^DG(40.8,+$$PRIM^VASITE(),0)),U,7),SDDNAM=$$GET1^DIQ(4,+SDDNAM,.01) S:'$L(SDDNAM) SDDNAM=$P($G(^DG(40.8,+$P(SDMC,U,3),0)),U)
        F I="SCRPW","SCRPWD","SCRPWC" K ^TMP(I,$J)
        F  S SDDT=$O(^SCE("B",SDDT)) Q:'SDDT!(SDDT>SDDTL)!SDOUT  S SDOE=0 D
        .F  S SDOE=$O(^SCE("B",SDDT,SDOE)) Q:'SDOE!SDOUT  S SDOE0=$$GETOE^SDOE(SDOE) I $L(SDOE0),'$P(SDOE0,U,6),$P(SDOE0,U,2),$P(SDOE0,U,11),$P(SDOE0,U,12) S SDDIV=$$DIV(),SDCG=$$CLGR() D COUNT
        .Q
        I '$D(^TMP("SCRPW",$J)) D XHDR S SDX="No activity found within the parameters specified." W !!?(80-$L(SDX)\2),SDX G EXIT
        F SDS1="SCRPW","SCRPWD","SCRPWC" S SDS2="" F  S SDS2=$O(^TMP(SDS1,$J,SDS2)) Q:SDS2=""!SDOUT  D STCT
        G:SDOUT EXIT D:$E(IOST)="C" DISP0^SCRPW23
        F SDS1="SCRPW","SCRPWD","SCRPWC" S SDS2="" F  S SDS2=$O(^TMP(SDS1,$J,SDS2)) Q:SDS2=""!SDOUT  D PRPT
        G:SDOUT EXIT
        D:SDZ(0) DPRT^SCRPW9("SCRPW",SDDNAM) G:SDOUT EXIT D:SDUL UNARL^SCRPW9("SCRPW",SDDNAM) G EXIT
        ;
STCT    S (SDUNCO,SDCT,DFN)=0 D STOP Q:SDOUT
        F  S DFN=$O(^TMP(SDS1,$J,SDS2,"VISIT","ACC",DFN)) Q:'DFN  S SDUNCO=SDUNCO+1,SDDT=0 F  S SDDT=$O(^TMP(SDS1,$J,SDS2,"VISIT","ACC",DFN,SDDT)) Q:'SDDT  S SDCT=SDCT+1
        S ^TMP(SDS1,$J,SDS2,"UNIQUE","UNCO")=SDUNCO,^TMP(SDS1,$J,SDS2,"VISIT","OWK")=SDCT,(SDUNAR,SDCT,DFN)=0
        S DFN=0 F  S DFN=$O(^TMP(SDS1,$J,SDS2,"VISIT","OWK",DFN)) Q:'DFN  D NCT1
        S DFN=0 F  S DFN=$O(^TMP(SDS1,$J,SDS2,"VISIT","NWK",DFN)) Q:'DFN  D CT1
        S ^TMP(SDS1,$J,SDS2,"UNIQUE","UNAR")=SDUNAR,^TMP(SDS1,$J,SDS2,"VISIT","NWK")=SDCT Q
        ;
PRPT    ;Print statistics page
        D STOP Q:SDOUT
        S SDCT=0 F SDI=1,2,3,11,14,"8-CC" S SDCT=SDCT+$G(^TMP(SDS1,$J,SDS2,SDI))
        D XHDR Q:SDOUT  D SHDR("O U T P A T I E N T   E N C O U N T E R   W O R K L O A D") Q:SDOUT  F SDI=11,14,3,1 D LIST(SDI) Q:SDOUT
        I $D(^TMP(SDS1,$J,SDS2,2)) D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?10,"CHECKED OUT" S SDI=0 F  S SDI=$O(^TMP(SDS1,$J,SDS2,2,SDI)) Q:'SDI!SDOUT  S SDSTAT=$O(^TMP(SDS1,$J,SDS2,2,SDI,"")) D COT
        I $D(^TMP(SDS1,$J,SDS2,"8-CC")) D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?10,"INPATIENT APPOINTMENT" S SDI=0 F  S SDI=$O(^TMP(SDS1,$J,SDS2,"8-CC",SDI)) Q:'SDI!SDOUT  S SDSTAT=$O(^TMP(SDS1,$J,SDS2,"8-CC",SDI,"")) D IAP
        D TOT S (SDI,SDCT)=0 F SDI=4,5,6,7,"8-NC",9,12,13 S SDCT=SDCT+$G(^TMP(SDS1,$J,SDS2,SDI))
        W !! D SHDR("N O N - W O R K L O A D") Q:SDOUT  F SDI="8-NC",12,4,6,5,7,9,10,13 D LIST(SDI) Q:SDOUT
        D TOT W !! D SHDR(($$HD2()_"   O U T P A T I E N T   V I S I T S")) Q:SDOUT  S SDCT=^TMP(SDS1,$J,SDS2,"VISIT","NWK")+^TMP(SDS1,$J,SDS2,"VISIT","OWK")
        D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?10,"Act. Req./not accepted visits",?47,$J(^TMP(SDS1,$J,SDS2,"VISIT","NWK"),12),?62,$J($S(SDCT=0:0,1:(^TMP(SDS1,$J,SDS2,"VISIT","NWK")*100/SDCT)),8,2)
        D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?10,"Transmitted, accepted visits",?47,$J(^TMP(SDS1,$J,SDS2,"VISIT","OWK"),12),?62,$J($S(SDCT=0:0,1:(^TMP(SDS1,$J,SDS2,"VISIT","OWK")*100/SDCT)),8,2)
        D TOT
        W !! D SHDR(($$HD2()_"   O U T P A T I E N T   U N I Q U E S")) Q:SDOUT
        S SDUNCO=^TMP(SDS1,$J,SDS2,"UNIQUE","UNCO"),SDUNAR=^TMP(SDS1,$J,SDS2,"UNIQUE","UNAR"),SDCT=SDUNCO+SDUNAR
        D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?10,"Act. Req./not accepted unique pts.",?47,$J(SDUNAR,12),?62,$J($S(SDCT=0:0,1:SDUNAR*100/SDCT),8,2)
        D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?10,"Transmitted, accepted unique pts.",?47,$J(SDUNCO,12),?62,$J($S(SDCT=0:0,1:SDUNCO*100/SDCT),8,2) D TOT
        Q
        ;
XHDR    I $E(IOST)="C",SDPAGE>1 N DIR S DIR(0)="E" D ^DIR S SDOUT=Y'=1 Q:SDOUT
        S SDLINE="",$P(SDLINE,"-",81)="" W:SDPAGE>1!($E(IOST)="C") $$XY^SCRPW50(IOF,1,0) W:$X $$XY^SCRPW50("",0,0) W SDLINE,!?15,"<*>  OUTPATIENT ENCOUNTER WORKLOAD STATISTICS  <*>"
        I $D(^TMP("SCRPW",$J)) S X=$$HD1() W !?(80-$L(X)\2),X
        W !,SDLINE,!,"For encounter dates ",SDDTPF," to ",SDDTPL,!,"Date printed: ",SDPNOW,?(74-$L(SDPAGE)),"Page: ",SDPAGE,!,SDLINE,! S SDPAGE=SDPAGE+1
        Q
        ;
EXIT    K SDTOE0,SDUNCO,SDUNAR,SDCT,DFN,SDDT,SDDTF,SDDTL,SDDTPF,SDDTPL,SDI,SDLINE,SDOE,SDOE0,SDPNOW,SDSTAT,SDSTX,SDTOE,SDTOEE,SDTOE1,SDTX,SDTXS,SDX,SDZ,DTOUT,X,Y,ZTDESC,ZTRTN,ZTSAVE
        D KVA^VADPT K X1,X2,SDH,SDHL,SDPNAM,SDSSN,SDPAGE,SDPT0,SDUL,DUOUT,SDARCT,SDST,SDPNOW,SDMD,SDMC,SDDIV,SDDNAM,SDS1,SDS2,SDCG,SDCLGR F I="SCRPW","SCRPWD","SCRPWC" K ^TMP(I,$J)
        K I,SDFF,SDOUT,SDSTOP,SDNCOU D END^SCRPW50 Q
        ;
HD1()   ;Report subheader 1
        Q $S(SDS1="SCRPW":"For station: ",SDS1="SCRPWD":"For division: ",1:"For clinic group: ")_SDS2
        ;
HD2()   ;Report subheader 2
        Q $S(SDS1="SCRPW":"F A C I L I T Y",SDS1="SCRPWD":"D I V I S I O N",1:"C L I N I C   G R O U P")
        ;
DIV()   ;Return division name
        N X S X=$P($G(^DG(40.8,+$P(SDOE0,U,11),0)),U) Q $S('$L(X):"***UNKNOWN***",1:X)
        ;
CLGR()  ;Return CLINIC GROUP pointer
        N X S X=$P($G(^SC(+$P(SDOE0,U,4),0)),U,31),X=$P($G(^SD(409.67,+X,0)),U) Q $S('$L(X):"***NONE ASSIGNED***",1:X)
        ;
NCT1    I '$D(^TMP(SDS1,$J,SDS2,"VISIT","ACC",DFN)) S SDUNAR=SDUNAR+1 D:SDUL&(SDS1="SCRPW") UL("OWK")
        S SDDT=0 F  S SDDT=$O(^TMP(SDS1,$J,SDS2,"VISIT","OWK",DFN,SDDT)) Q:'SDDT  I '$D(^TMP(SDS1,$J,SDS2,"VISIT","ACC",DFN,SDDT)) S SDCT=SDCT+1
        Q
        ;
CT1     I '$D(^TMP(SDS1,$J,SDS2,"VISIT","OWK",DFN)),'$D(^TMP(SDS1,$J,SDS2,"VISIT","ACC",DFN)) S SDUNAR=SDUNAR+1 D:SDUL&(SDS1="SCRPW") UL("NWK")
        S SDDT=0 F  S SDDT=$O(^TMP(SDS1,$J,SDS2,"VISIT","NWK",DFN,SDDT)) Q:'SDDT  I '$D(^TMP(SDS1,$J,SDS2,"VISIT","OWK",DFN,SDDT)),'$D(^TMP(SDS1,$J,SDS2,"VISIT","ACC",DFN,SDDT)) S SDCT=SDCT+1
        Q
        ;
UL(SDI) D ^VADPT S SDDT=0 F  S SDDT=$O(^TMP(SDS1,$J,SDS2,"VISIT",SDI,DFN,SDDT)) Q:'SDDT  S ^TMP(SDS1,$J,SDS2,"VISIT","UNARL",VADM(1),DFN,$P(VADM(2),U),SDDT)=""
        Q
        ;
TOT     W !?47,"============  =========",!?39,"TOTAL:",?47,$J(SDCT,12),?64,"100.00" Q
        ;
SHDR(SDTX)      D:$Y>(IOSL-6) XHDR Q:SDOUT  W !!?(80-$L(SDTX)\2),SDTX,!?(80-$L(SDTX)\2) F SDX=1:1:$L(SDTX) W "-"
        W !!?39,"Status",?54,"Count",?63,"Percent",!?10,"-----------------------------------  ------------  ---------" Q
        ;
LIST(SDI)       Q:'$D(^TMP(SDS1,$J,SDS2,SDI))  D:$Y>(IOSL-4) XHDR Q:SDOUT
        W !?10,$P(^SD(409.63,+SDI,0),U),?47,$J(^TMP(SDS1,$J,SDS2,SDI),12),?62,$J($S(SDCT=0:0,1:(^TMP(SDS1,$J,SDS2,SDI)*100/SDCT)),8,2)
        Q
        ;
COT     D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?15,SDSTAT,?47,$J(^TMP(SDS1,$J,SDS2,2,SDI,SDSTAT),12),?62,$J($S(SDCT=0:0,1:(^TMP(SDS1,$J,SDS2,2,SDI,SDSTAT)*100/SDCT)),8,2) Q
        ;
IAP     D:$Y>(IOSL-4) XHDR Q:SDOUT  W !?15,SDSTAT,?47,$J(^TMP(SDS1,$J,SDS2,"8-CC",SDI,SDSTAT),12),?62,$J($S(SDCT=0:0,1:(^TMP(SDS1,$J,SDS2,"8-CC",SDI,SDSTAT)*100/SDCT)),8,2) Q
STOP    ;Check for stop task request
        S:$G(ZTQUEUED) (SDOUT,ZTSTOP)=$S($$S^%ZTLOAD:1,1:0) Q
        ;
COUNT   ;Count encounters
        S SDNCOU=$P($G(^SC(+$P(SDOE0,U,4),0)),U,17),SDNCOU=$S(SDNCOU="Y":1,1:0)
        S SDSTOP=SDSTOP+1 I SDSTOP#3000=0 D STOP Q:SDOUT
        D C1("SCRPW",SDDNAM) D:SDMD C1("SCRPWD",SDDIV) D:SDCLGR C1("SCRPWC",SDCG) Q
        ;
C1(SDS1,SDS2)   ;Set ^TMP global
        ;Required input: SDS1,SDS2=subscript values
        ;Because there is only 1 status (8) for INPATIENTS, 8-NC is used to
        ;distinguish the non-count clinics from the count clinics, 8-CC.
        S DFN=$P(SDOE0,U,2),SDSTAT=+$P(SDOE0,U,12) I SDSTAT=8 S SDSTAT=$S(SDNCOU:SDSTAT_"-NC",1:SDSTAT_"-CC")
        I SDZ(0),SDZ(4)=SDDIV,SDS1="SCRPW" D DETAIL
        S ^TMP(SDS1,$J,SDS2,SDSTAT)=$G(^TMP(SDS1,$J,SDS2,SDSTAT))+1
        Q:SDSTAT=4  Q:(+SDSTAT=8)&($P(SDSTAT,"-",2)="NC")  D:"114238"[+SDSTAT VIS Q
        ;
VIS     S ^TMP(SDS1,$J,SDS2,"VISIT",$S(SDSTAT=2:"OWK",(+SDSTAT=8)&('SDNCOU):"OWK",1:"NWK"),DFN,$P(SDDT,"."))="" Q:(+SDSTAT'=2)&(+SDSTAT'=8)
        I +SDSTAT=8,$P(SDOE0,U,7)="" D  Q
        .S ^TMP(SDS1,$J,SDS2,SDSTAT,10,"Action Required")=$G(^TMP(SDS1,$J,SDS2,SDSTAT,10,"Action Required"))+1
        S SDSTX=$$STX(SDOE,SDOE0),^TMP(SDS1,$J,SDS2,SDSTAT,$P(SDSTX,U),$P(SDSTX,U,2))=$G(^TMP(SDS1,$J,SDS2,SDSTAT,$P(SDSTX,U),$P(SDSTX,U,2)))+1
        Q:$P(SDSTX,U)'=8  S ^TMP(SDS1,$J,SDS2,"VISIT","ACC",DFN,$P(SDDT,"."))=""
        Q
        ;
STX(SDOE,SDOE0) ;Determine transmission status
        ;Required input: SDOE=OUTPATIENT ENCOUNTER record IFN
        ;Required input: SDOE0=zeroeth node of OUTPATIENT ENCOUNTER
        N SDTOE,SDTOEE
        Q:($P(SDOE0,U,12)'=2)&($P(SDOE0,U,12)'=8) "0^Not checked-out^Not checked-out"
        S SDTOE=$O(^SD(409.73,"AENC",SDOE,0)) Q:'SDTOE!'$D(^SD(409.73,+SDTOE,0)) "1^No transmission record^No tx. record"
        S SDTOE1=$G(^SD(409.73,SDTOE,1)),SDTOE0=^SD(409.73,SDTOE,0) I '$P(SDTOE0,U,4),'$P(SDTOE1,U) Q "2^Not required, not transmitted^Not req., not tx."
        ; SD*5.3*339 added second I SDTOEE below
        S SDTOEE=$O(^SD(409.75,"B",SDTOE,0)) I SDTOEE S SDTOEE=$P($G(^SD(409.75,SDTOEE,0)),U,2) I SDTOEE S SDTOEE=$P($G(^SD(409.76,SDTOEE,0)),U,2) Q:SDTOEE="V" "3^Rejected for transmission^Rejected for tx."
        Q:'$P(SDTOE1,U) "4^Awaiting transmission^Awaiting tx."
        S SDTXS=$P(SDTOE1,U,5) Q:'$L(SDTXS) "5^Transmitted, no acknowledgment^Tx., no ack."
        Q:SDTXS="R" "6^Transmitted, rejected^Tx., rejected"
        Q:SDTXS'="A" "7^Transmitted, error^Tx., error"
        Q "8^Transmitted, accepted^Tx., accepted"
        ;
DETAIL  ;Set global for detailed list
        N SDIF S SDIF=0
        D ^VADPT S SDPNAM=VADM(1),SDSSN=$P(VADM(2),U)
        I SDZ(1)="U",+SDSTAT'=4,'SDNCOU S:"114238"[+SDSTAT ^TMP(SDS1,$J,SDS2,"DETAIL",SDPNAM,DFN,SDSSN)="" Q
        I SDZ(1)="V",+SDSTAT'=4,'SDNCOU S:"114238"[+SDSTAT ^TMP(SDS1,$J,SDS2,"DETAIL",SDPNAM,DFN,SDSSN,$P(SDDT,"."))="" Q
        Q:'$D(SDZ(2))  ; SD*5.3*339
        I SDZ(2)'=2,SDZ(2)=+SDSTAT D  I SDIF Q
        .I (SDZ(2)=8) Q:$P(SDSTAT,"-",2)="CC"  I SDZ(3)'=9 S SDIF=1 Q
        .D DSET S SDIF=1
        Q:("28"'[SDZ(2))!("28"'[+SDSTAT)  Q:SDZ(2)'=+SDSTAT  D  I SDIF Q
        .I +SDSTAT=8,$P(SDSTAT,"-",2)="NC" S SDIF=1 Q
        .I 'SDZ(3) D DSET S SDIF=1
        D:+$$STX(SDOE,SDOE0)=SDZ(3) DSET Q
        ;
DSET    S ^TMP(SDS1,$J,SDS2,"DETAIL",SDPNAM,DFN,SDSSN,SDDT,SDOE)=+$P(SDOE0,U,4) Q
