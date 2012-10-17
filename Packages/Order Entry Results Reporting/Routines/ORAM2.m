ORAM2   ;POR/RSF - ANTICOAGULATION MANAGEMENT RPCS (3 of 4) ;01/29/10  21:37
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**307**;Dec 17, 1997;Build 60
        ;;Per VHA Directive 2004-038, this routine should not be modified
        Q
        ;
ALLGOAL(RESULT,DAYS,CLINIC)     ; last inr for all pts seen in last x days
        ;;RPC = ORAM2 ALLGOAL
        N ORAMDFN,ORAMNOW,ORAMCUT,ORAMCNT,ORAMPC,ORAMGOOD,ORAMBAD,ORAMBL
        S ORAMDFN=0,ORAMCNT=0,ORAMGOOD=0,ORAMBAD=0
        S ORAMNOW=$$NOW^XLFDT
        S ORAMCUT=$$FMADD^XLFDT(ORAMNOW,-DAYS)
        F  S ORAMDFN=$O(^ORAM(103,ORAMDFN)) Q:'ORAMDFN  D
        . N ORAMFS,ORAM3D0,ORAMDATE,ORAMCLIN
        . S ORAMFS=$O(^ORAM(103,ORAMDFN,3," "),-1) Q:$G(ORAMFS)=""
        . S ORAMCLIN=$P($G(^ORAM(103,ORAMDFN,6)),U,2)
        . I +$G(CLINIC),(ORAMCLIN'=CLINIC) Q
        . S ORAM3D0=$G(^ORAM(103,ORAMDFN,3,ORAMFS,0)),ORAMDATE=$P(ORAM3D0,"^")
        . I ($G(ORAMDATE)>$G(ORAMCUT)) D
        .. N ORAMINR,ORAMGOAL,ORAMGLO,ORAMGHI
        .. S ORAMINR=$P(ORAM3D0,"^",3),ORAMGOAL=$P(ORAM3D0,"^",12),ORAMGLO=$P(ORAMGOAL,"-"),ORAMGHI=$P(ORAMGOAL,"-",2) S:ORAMGHI[" " ORAMGHI=$P(ORAMGHI," ",2)
        .. S ORAMGLO=ORAMGLO-(.1*ORAMGLO),ORAMGHI=ORAMGHI+(.1*ORAMGHI)
        .. S ORAMCNT=ORAMCNT+1
        .. I (ORAMINR'<ORAMGLO)&(ORAMINR'>ORAMGHI) S ORAMGOOD=ORAMGOOD+1
        .. E  D
        ... N ORAMNAME,ORAMSSN,LINE
        ... S ORAMBAD=ORAMBAD+1,LINE=""
        ... S ORAMNAME=$P($P(^DPT(ORAMDFN,0),"^"),","),ORAMSSN=$E($P(^DPT(ORAMDFN,0),"^",9),6,9)
        ... S LINE=$$SETSTR^VALM1(ORAMNAME,LINE,1,15)
        ... S LINE=$$SETSTR^VALM1("("_ORAMSSN_")",LINE,17,6)
        ... S LINE=$$SETSTR^VALM1($S(+ORAMINR>0:ORAMINR,1:"N/A"),LINE,25,5)
        ... S LINE=$$SETSTR^VALM1("("_ORAMGOAL_")",LINE,32,9)
        ... S RESULT(ORAMBAD)=LINE
        I ORAMCNT>0 S ORAMPC=$J(((ORAMGOOD/ORAMCNT)*100),3,1)
        I ORAMBAD'="" S ORAMBL=$L(ORAMBAD,"^"),$P(ORAMBAD,"^",1)=ORAMBL
        S RESULT(0)=$G(ORAMPC)
        Q
        ;
PTAPPT(RESULT,CLINIC)   ; Counts # of pts/day next 45 days
        ;RPC=ORAM2 PTAPPT
        N ORAMFDT,ORAMRDT,ORAMCNT
        S ORAMFDT=$$FMADD^XLFDT(DT,45)_".2359",ORAMRDT=DT
        F  S ORAMRDT=$O(^ORAM(103,"L",ORAMRDT)) Q:(+ORAMRDT'>0)!(ORAMRDT>ORAMFDT)  D
        . N ORAMDT,ORAMRD,ORAMDFN
        . S ORAMDT=$P(ORAMRDT,"."),ORAMRD=$$FMTE^XLFDT(ORAMDT,"2DF"),ORAMDFN=0
        . F  S ORAMDFN=$O(^ORAM(103,"L",ORAMRDT,ORAMDFN)) Q:'ORAMDFN  D
        .. N ORAMCLIN S ORAMCLIN=$P($G(^ORAM(103,ORAMDFN,6)),U,2)
        .. Q:ORAMCLIN'=$G(CLINIC)
        .. S ORAMCNT(ORAMDT)=+$G(ORAMCNT(ORAMDT))+1
        .. S RESULT(ORAMDT)=ORAMRD_" - "_$G(ORAMCNT(ORAMDT))
PTAPPTQ Q
        ;
NOACT(RESULT,DAYS,CLINIC)       ; Finds pts w/o AC activity past X days
        ;RPC=ORAM2 NOACT
        N ORAMDT,ORAMFDT,ORAMVST,ORAMDFN,ORAMPT,ORAMSSN,ORAMSTAT,ORAMSORT,ORAMC,ORAMI
        S ORAMDT=$$NOW^XLFDT,ORAMFDT=$$FMADD^XLFDT(ORAMDT,-DAYS),ORAMDFN=0
        F  S ORAMDFN=$O(^ORAM(103,ORAMDFN)) Q:+ORAMDFN'>0  D
        . N ORAMFS,ORAMCLIN S ORAMCLIN=$P($G(^ORAM(103,ORAMDFN,6)),U,2)
        . Q:ORAMCLIN'=$G(CLINIC)
        . S ORAMFS=$O(^ORAM(103,ORAMDFN,3," "),-1) Q:ORAMFS']""
        . S ORAMSTAT=$P(^ORAM(103,ORAMDFN,0),"^",10),ORAMVST=$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),"^")
        . I ORAMSTAT'=2&(ORAMVST'>ORAMFDT) D
        . . N LINE S LINE=""
        . . S ORAMPT=$P(^DPT(ORAMDFN,0),"^"),ORAMPT=$P(ORAMPT,","),ORAMSSN=$E($P(^DPT(ORAMDFN,0),"^",9),6,9)
        . . S LINE=$$SETSTR^VALM1(ORAMPT,LINE,1,15)
        . . S LINE=$$SETSTR^VALM1("("_ORAMSSN_")",LINE,17,6)
        . . S LINE=$$SETSTR^VALM1("Last Seen: "_$$FMTE^XLFDT($P(ORAMVST,"."),"2DF"),LINE,25,19)
        . . S ORAMSORT($P(ORAMVST,"."),ORAMPT_ORAMSSN)=LINE
        S (ORAMC,ORAMI)=0
        F  S ORAMI=$O(ORAMSORT(ORAMI)) Q:+ORAMI'>0  D
        . N ORAMJ S ORAMJ=""
        . F  S ORAMJ=$O(ORAMSORT(ORAMI,ORAMJ)) Q:ORAMJ']""  D
        . . S ORAMC=ORAMC+1,RESULT(ORAMC)=$G(ORAMSORT(ORAMI,ORAMJ))
        I ORAMC=0 S RESULT(0)="No patients lost to follow-up "_DAYS_" days or longer."
NOACTQ  Q
        ;
SHOWRATE(RESULT,DFN)    ; CALCULATES SHOWRATE
        ;;RPC=ORAM2 NOSHOW
        N ORAMFSDT,ORAMFS,ORAMR,ORAMARR,ORAMPC,ORAMPTT0,ORAMRDT,ORAMRDT0
        S ORAMR=0,ORAMPTT0=0,ORAMRDT0=""
        S ORAMFSDT=0 F  S ORAMFSDT=$O(^ORAM(103,DFN,3,"B",ORAMFSDT)) Q:'ORAMFSDT  D
        . S ORAMFS=0 F  S ORAMFS=$O(^ORAM(103,DFN,3,"B",ORAMFSDT,ORAMFS)) Q:'ORAMFS  D
        .. N ORAMD0,ORAMSD,ORAMSCR,ORAMPTT,ORAMLCNT,ORAMLLN,ORAMDIFF
        .. S ORAMD0=$G(^ORAM(103,DFN,3,ORAMFS,0)),ORAMSCR=$P(ORAMD0,"^",13),ORAMSD=$P($P(ORAMD0,"^"),"."),ORAMPTT=$P(ORAMD0,"^",3)
        .. S ORAMLCNT=$P($G(^ORAM(103,DFN,3,ORAMFS,1,0)),"^",3) Q:'ORAMLCNT
        .. S ORAMLLN=$G(^ORAM(103,DFN,3,ORAMFS,1,ORAMLCNT,0))
        .. S ORAMRDT=$S($G(ORAMLLN)["Next draw:":$P($G(ORAMLLN)," ",3),$G(ORAMLLN)["Callback:":"C",$G(ORAMLLN)["Missed Appt;":"M",$G(ORAMLLN)["Edited by:":"E",1:$P($G(ORAMLLN)," "))
        .. I ORAMRDT="E" S ORAMLCNT=ORAMLCNT-1,ORAMLLN=$G(^ORAM(103,DFN,3,ORAMFS,1,ORAMLCNT,0))
        .. I  S ORAMRDT=$S($G(ORAMLLN)["Next draw:":$P($G(ORAMLLN)," ",3),$G(ORAMLLN)["Callback:":$P($G(ORAMLLN)," ",2),$G(ORAMLLN)["Missed Appt;":"Q",1:$P($G(ORAMLLN)," "))
        .. I ORAMRDT="M" S ORAMRDT=$P($G(ORAMLLN)," ",4),ORAMR=ORAMR+1 D DT^DILF("T",ORAMRDT,.ORAMRDT) S ORAMRDT0=ORAMRDT Q  ;NOTE PT MISSED DRAW, ADD ONE TO DENOMINATOR
        .. I $L(ORAMRDT)>1 D DT^DILF("T",ORAMRDT,.ORAMRDT)
        .. I ORAMRDT="C" S ORAMRDT=$P($G(ORAMLLN)," ",2) D DT^DILF("T",ORAMRDT,.ORAMRDT) S ORAMRDT=$$FMADD^XLFDT(ORAMRDT,-1)
        .. I 'ORAMPTT!($G(ORAMPTT0)=$G(ORAMPTT)) S ORAMRDT0=ORAMRDT Q
        .. S ORAMPTT0=ORAMPTT
        .. I ORAMRDT0'="" S ORAMDIFF=$$FMDIFF^XLFDT(ORAMSD,ORAMRDT0,2) S ORAMR=ORAMR+1 I ORAMDIFF>-172801&(ORAMDIFF<172801) S ORAMARR(0)=$G(ORAMARR(0))+1
        .. S ORAMRDT0=ORAMRDT
        I ORAMR>0 S ORAMPC=($G(ORAMARR(0))/ORAMR)*100,ORAMPC=$E(ORAMPC,1,4)
        S RESULT=$G(ORAMPC)_"^"_$G(ORAMR)
        Q
        ;
RPTSTART(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)     ;
        ;;
        D START^ORWRP(80,"RPT^ORAM2(.ROOT,.DFN,.ID,.ALPHA,.OMEGA,.DTRANGE,.REMOTE,.MAX,.ORFHIE)",999)
        Q
        ;
RPT(ROOT,DFN,ID,ALPHA,OMEGA,DTRANGE,REMOTE,MAX,ORFHIE)  ;
        N ORAMCNT,ORAMJ,ORAMHCT,ORAMCLIN,ORAMPIND
        I '$D(^ORAM(103,"B",DFN)) Q
        W $P(^DPT(DFN,0),"^"),"  ",$E($P(^DPT(DFN,0),"^",9),1,3),"-",$E($P(^DPT(DFN,0),"^",9),4,5),"-",$E($P(^DPT(DFN,0),"^",9),6,9)
        I $P(^ORAM(103,DFN,0),"^",10)=1 W !,?10,"******* COMPLEX PATIENT *******"
        S ORAMCLIN=$P($G(^ORAM(103,DFN,6)),U,2),ORAMPIND=""
        I +ORAMCLIN D
        . N ICDC
        . S ICDC=$$GET^XPAR(ORAMCLIN_";SC(","ORAM AUTO PRIMARY INDICATION",1,"E")
        . I ICDC]"" D
        . . N ICDD,ICDDL,ICDDESC
        . . S ICDDL=$$ICDD^ICDCODE(ICDC,"ICDDESC",DT)
        . . S ORAMPIND=ICDC_U_$$TITLE^XLFSTR($G(ICDDESC(1)))_" ("_ICDC_")"
        I ORAMPIND]"" D
        . W !!,"Primary Indication: ",$P(ORAMPIND,U,2)
        . W !,"  Add'l Indication: ",$P($P(^ORAM(103,DFN,0),"^",3),"=")," (",$P($P(^ORAM(103,DFN,0),"^",3),"=",2),")"
        . W !,"          Goal INR: ",$P(^ORAM(103,DFN,0),"^",2)
        E  D
        . W !!,"Primary Indication: ",$P($P(^ORAM(103,DFN,0),"^",3),"=")," (",$P($P(^ORAM(103,DFN,0),"^",3),"=",2),")",?38,"Goal INR: ",$P(^ORAM(103,DFN,0),"^",2)
        D HCT^ORAM(.ORAMHCT,DFN)
        I $L(ORAMHCT,U)>1 D  I 1
        . W !?10,"Last ",$S($$UP^XLFSTR($P(ORAMHCT,U,3))["HGB":"Hgb",$$UP^XLFSTR($P(ORAMHCT,U,3))["HEMOGLOBIN":"Hgb",1:"HCT"),": "
        . W $S($P(ORAMHCT,U)]"":$P(ORAMHCT,U),1:"No result")," on ",$S($P(ORAMHCT,U,2)]"":$P(ORAMHCT,U,2),1:"file")
        E  W !?10,ORAMHCT
        I +$P($G(^ORAM(103,DFN,6)),U,5)!+$O(^ORAM(103,DFN,7,0)) D
        . W !!,"Patient is Eligible for LMWH Bridging"
        . I +$O(^ORAM(103,DFN,7,0)) D
        .. N ORI S ORI=0
        .. W ":"
        .. F  S ORI=$O(^ORAM(103,DFN,7,ORI)) Q:+ORI'>0  W !?2,$G(^ORAM(103,DFN,7,ORI,0))
        . E  W "."
        I $P($G(^ORAM(103,DFN,1,0)),"^",3)>0 S ORAMCNT=$P(^ORAM(103,DFN,1,0),"^",3) D
        . W !!,"Special Instructions:"
        . F ORAMJ=1:1:ORAMCNT W !?2,^ORAM(103,DFN,1,ORAMJ,0)
        I $P(^ORAM(103,DFN,0),"^",11)=2 W !?2,"Pt has given permission to leave anticoag msg on msg machine."
        I $P($G(^ORAM(103,DFN,4,0)),"^",3)>0 S ORAMCNT=$P(^ORAM(103,DFN,4,0),"^",3) D
        . W !?2,"OK to leave anticoagulation message with:"
        . F ORAMJ=1:1:ORAMCNT W !?4,^ORAM(103,DFN,4,ORAMJ,0)
        I $P($G(^ORAM(103,DFN,2,0)),"^",3)>0 S ORAMCNT=$P(^ORAM(103,DFN,2,0),"^",3) D
        . W !!,"Secondary Indication(s)/Risk Factors:"
        . F ORAMJ=1:1:ORAMCNT W !?2,^ORAM(103,DFN,2,ORAMJ,0)
        W !
        I $P(^ORAM(103,DFN,0),"^",5)'="" W !,"Start Date: ",$P(^ORAM(103,DFN,0),"^",5)
        I $P(^ORAM(103,DFN,0),"^",7)'="" W ?35,"Duration: ",$P(^ORAM(103,DFN,0),"^",7)
         W !,"==========================================================================="
         W !,"DATE",?10,"INR",?18,"Notified",?30,"TWD",?36,"Comments:"
         W !,"---------------------------------------------------------------------------"
        I $D(^ORAM(103,DFN,3,"B")) D
        . N ORAMFSD S ORAMFSD=" ",ORAMCNT=0
        . F  S ORAMFSD=$O(^ORAM(103,DFN,3,ORAMFSD),-1) Q:$G(ORAMFSD)<1  D
        .. I $$DTCHK(DFN,ALPHA,OMEGA,ORAMFSD)=0 Q  ;need to change this to the new date
        .. N ORAMDD1,ORAMDOSE,ORAMPS,ORAMPNOT
        .. I '+$D(^ORAM(103,DFN,3,ORAMFSD,"LOG",0)) W !,$$FMTE^XLFDT($E($P(^ORAM(103,DFN,3,ORAMFSD,0),"^",9),1,7),2)  ;changed from $P(^ORAM(103,DFN,3,ORAMCNT,0),"^")
        .. I +$D(^ORAM(103,DFN,3,ORAMFSD,"LOG",0)) S ORAMDD1=$P($P(^ORAM(103,DFN,3,ORAMFSD,"LOG",1,0),"(",2),".") Q:'+$G(ORAMDD1)  W !,$$FMTE^XLFDT(ORAMDD1,2)
        .. S ORAMPNOT=$$WRAP^ORAMX($P(^ORAM(103,DFN,3,ORAMFSD,0),"^",8),11)
        .. W ?11,$P(^ORAM(103,DFN,3,ORAMFSD,0),"^",3) ;INR
        .. W ?18,$P(ORAMPNOT,"|") ;Pt Notified
        .. W ?30,$P(^ORAM(103,DFN,3,ORAMFSD,0),"^",6) ;TWD
        .. ; Comments
        .. I $P($G(^ORAM(103,DFN,3,ORAMFSD,1,0)),"^",3)>0 D  I 1
        ... N ORAMCC,ORAMCLN S (ORAMCC,ORAMCLN)=0
        ... F  S ORAMCLN=$O(^ORAM(103,DFN,3,ORAMFSD,1,ORAMCLN)) Q:+ORAMCLN'>0  D
        .... I $P(^ORAM(103,DFN,3,ORAMFSD,0),"^",3)'="",ORAMCLN=2 W ?10,$$FMTE^XLFDT($P(^ORAM(103,DFN,3,ORAMFSD,0),"^"),2)
        .... W:ORAMCLN>1 ?18,$P(ORAMPNOT,"|",ORAMCLN)
        .... W ?38,^ORAM(103,DFN,3,ORAMFSD,1,ORAMCLN,0),!
        .... S ORAMCC=ORAMCC+1
        ... I $L(ORAMPNOT,"|")>ORAMCC D
        .... N ORAMI S ORAMI=0 F ORAMI=ORAMCC+1:1:$L(ORAMPNOT,"|") W ?18,$P(ORAMPNOT,"|",ORAMI),!
        .. E  D  W !
        ... I $L(ORAMPNOT,"|")>1 D
        .... N ORAMI S ORAMI=0 F ORAMI=2:1:$L(ORAMPNOT,"|") W ?18,$P(ORAMPNOT,"|",ORAMI),!
        .. ; Patient Instructions
        .. I +$O(^ORAM(103,DFN,3,ORAMFSD,3,0)) D
        ... N ORI S ORI=0
        ... W !,"Patient Instructions (from Letter):"
        ... F  S ORI=$O(^ORAM(103,DFN,3,ORAMFSD,3,ORI)) Q:+ORI'>0  D
        .... N ORPILN,ORJ S ORPILN=$G(^ORAM(103,DFN,3,ORAMFSD,3,ORI,0))
        .... S:$L(ORPILN)>77 ORPILN=$$WRAP^ORAMX(ORPILN,77)
        .... F ORJ=1:1:$L(ORPILN,"|") W !?2,$P(ORPILN,"|",ORJ)
        ... W !
        .. ; Daily Dosing
        .. S ORAMDOSE=$P(^ORAM(103,DFN,3,ORAMFSD,0),"^",7)
        .. I $L(ORAMDOSE) D
        ... N ORAMTP,ORAMTM,ORI
        ... S ORAMPS=$P(^ORAM(103,DFN,3,ORAMFSD,0),"^",5),(ORAMTP,ORAMTM)=0
        ... W !,"Current Dosing (using ",ORAMPS," mg tab):",!
        ... W ?4,"Sun",?8,"Mon",?12,"Tue",?16,"Wed",?20,"Thu",?24,"Fri",?28,"Sat",?32,"Tot",!
        ... W "Tab" F ORI=1:1:$L(ORAMDOSE,"|") S ORAMTP=ORAMTP+($P(ORAMDOSE,"|",ORI)/ORAMPS) W ?(4*ORI),$J(($P(ORAMDOSE,"|",ORI)/ORAMPS),3)
        ... W ?32,$J(ORAMTP,3),!
        ... W "mgs" F ORI=1:1:$L(ORAMDOSE,"|") S ORAMTM=ORAMTM+$P(ORAMDOSE,"|",ORI) W ?(4*ORI),$J($P(ORAMDOSE,"|",ORI),3)
        ... W ?32,$J(ORAMTM,3),!
        .. ; Complications
        .. I +$P(^ORAM(103,DFN,3,ORAMFSD,0),"^",2) D
        ... N ORAMCTXT,ORAMCMPL
        ... S ORAMCTXT=$S($P(^ORAM(103,DFN,3,ORAMFSD,0),"^",2)=1:"Major Bleed ",$P(^(0),"^",2)=2:"Complication(s) ",$P(^(0),"^",2)=3:"Minor Bleed ",1:"")
        ... I $D(^ORAM(103,DFN,3,ORAMFSD,2)) N ORAMRSF S ORAMRSF=0 F  S ORAMRSF=$O(^ORAM(103,DFN,3,ORAMFSD,2,ORAMRSF)) Q:ORAMRSF<1  D
        .... N ORI
        .... I ORAMRSF=1 W ?38,ORAMCTXT,"noted: (",^ORAM(103,DFN,3,ORAMFSD,2,ORAMRSF,0),")",! Q
        .... S ORAMCMPL=^ORAM(103,DFN,3,ORAMFSD,2,ORAMRSF,0)
        .... I $S(ORAMCMPL["MB:":1,ORAMCMPL["C:":1,1:0) S ORAMCMPL=$P(ORAMCMPL,":",2)
        .... I $L(ORAMCMPL)>37 S ORAMCMPL=$$WRAP^ORAMX(ORAMCMPL,37)
        .... F ORI=1:1:$L(ORAMCMPL,"|") W ?$S(ORI=1:38,1:40),$P(ORAMCMPL,"|",ORI),!
        .. W ?38,"-------------------------------------",!
        Q
        ;
        ;
DTCHK(DFN,ALPHA,OMEGA,ORAMFSD)  ; CHECKS DATE RANGE WITH ALPHA AND OMEGA FROM CPRS
        N ORAMFDT,ORAMVAL
        S ORAMVAL=0
        S ORAMFDT=$P(^ORAM(103,DFN,3,ORAMFSD,0),"^")
        S:ORAMFDT'<ALPHA ORAMVAL=1
        S:ORAMFDT>OMEGA ORAMVAL=0
        Q ORAMVAL
        ;
TEAMCHK(RESULT,ORAMTMS) ; SET-UP VERIFY NAMES
        ;RPC=ORAM2 TEAM CHECK
        N ORAMSKIP,ORAMI,ORAMERR
        Q:$G(ORAMTMS)=""
        F ORAMI=1:1:20 S ORAMSKIP=$G(ORAMSKIP)_" "
        S ORAMERR=0
        F ORAMI=1:1:$L(ORAMTMS,"^") D
        . N ORAMN
        . I $P(ORAMTMS,"^",ORAMI)'="" S ORAMN=$P(ORAMTMS,"^",ORAMI) D
        .. S RESULT(ORAMI)=ORAMN_$E(ORAMSKIP,1,(20-$L(ORAMN)))
        .. I $D(^OR(100.21,ORAMN)) S RESULT(ORAMI)=RESULT(ORAMI)_$P(^OR(100.21,ORAMN,0),"^")
        .. E  S RESULT(ORAMI)=RESULT(ORAMI)_"clinic not found.",ORAMERR=$G(ORAMERR)+1
        S RESULT(0)=$G(ORAMERR)
        Q
        ;
REMIND(RESULT,ORAMDFN,ORAMDT,ORAMREM)   ; RPC=ORAM2 REMINDER
        N ORAMRML,ORAMDAY,ORAMR,D0,DA,DIK,X
        Q:'+$G(ORAMDFN)  Q:$G(ORAMDT)=""  Q:$G(ORAMREM)=""
        S RESULT=0
        D NOW^%DTC S ORAMDAY=X D DT^DILF(,ORAMDT,.X) S ORAMDT=X
        S $P(^ORAM(103,ORAMDFN,0),"^",18)=$G(ORAMDT)
        K ^ORAM(103,ORAMDFN,5)
        S ORAMRML=$L(ORAMREM,"^"),^ORAM(103,ORAMDFN,5,0)="^^"_ORAMRML_"^"_ORAMRML_"^"_ORAMDAY_"^"
        F ORAMR=1:1:ORAMRML D
        . S ^ORAM(103,ORAMDFN,5,ORAMR,0)=$P(ORAMREM,"^",ORAMR)
        S DIK="^ORAM(103,",DA=ORAMDFN
        D IX^DIK
        S RESULT=1
        Q
