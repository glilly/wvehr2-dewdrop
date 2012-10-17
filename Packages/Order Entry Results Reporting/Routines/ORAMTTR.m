ORAMTTR ; POR/RSF - Rosendaal Calculations, Individual & Group ;11/13/09  10:44
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**307**;Dec 17, 1997;Build 60
        ;;Per VHA Directive 2004-038, this routine should not be modified
        ;needs testing in system with new file and parameters
        Q
        ;
MAIN    ; Rosendaal TTR Option
        N RESULT
        D NROSENT(.RESULT)
        Q
SINGLE  ; TTR for Individual
        N ORAMDFN,ORAMED,ORAMSD,DUOUT,DTOUT,DIRUT,RESULT
        S (ORAMED,ORAMSD)=""
        W !!,"Single Patient TRR Calculation (Rosendaal Method):",!
        S ORAMDFN=+$$PATIENT^ORAMX Q:+ORAMDFN'>0
        F  D  Q:+ORAMED>+ORAMSD!$D(DIRUT)
        . W !
        . S ORAMSD=+$$READ^ORAMX("DA^::E","Please Enter START Date: ","T-90","Enter a start date for the report")
        . Q:'ORAMSD
        . S ORAMED=+$$READ^ORAMX("DA^::E","  Please Enter END Date: ","T","Enter an INCLUSIVE end date for the report")
        . Q:'ORAMED
        . I $L(ORAMED,".")=1 S ORAMED=ORAMED_".2359"
        . I ORAMSD>ORAMED W !,"END DATE must be more recent than the START DATE" S (ORAMSD,ORAMED)=""
        Q:$S(+ORAMDFN'>0:1,ORAMED'>0:1,ORAMSD'>0:1,1:0)
        D NRINDV(.RESULT,ORAMDFN,ORAMSD,ORAMED,1)
        Q
NROSENT(RESULT) ;
        N ORAMSD,ORAMED,ORAMDFN,ORAMFSD,ORAMCLIN,ORAMPT,ORAMDATE,LG,HG,V1,V2,D1,D2,ORAMDAYS
        N ORAMDIG,ORAMTD,ORAMCARR,TOTS,CNT,ORSITE
        K ^TMP("ORAM",$J)
        W !!,"Rosendaal method for percentage of INR scores in therapeutic range",!
SD1     ; Get date range for calculations
        S ORAMSD=+$$READ^ORAMX("DA^::E","Please Enter START Date: ","T-90","Enter a start date for the report")
        Q:'ORAMSD
        S ORAMED=+$$READ^ORAMX("DA^::E","  Please Enter END Date: ","T","Enter an INCLUSIVE end date for the report")
        Q:'ORAMED
        I $L(ORAMED,".")=1 S ORAMED=ORAMED_".2359"
        I ORAMSD>ORAMED W !,"END DATE must be more recent than the START DATE" S (ORAMSD,ORAMED)="" G SD1
        S ORAMDFN=0 F  S ORAMDFN=$O(^ORAM(103,ORAMDFN)) Q:'$G(ORAMDFN)  D
        . N ORAMFS,ORAMDD,PGR
        . Q:'+$D(^ORAM(103,ORAMDFN,3))  ;go to next pt if no flow sheet entries
        . Q:'$D(^ORAM(103,ORAMDFN,6))  Q:$P(^ORAM(103,ORAMDFN,6),U,2)=""  ;QUIT IF NO CLINIC ASSIGNED
        . S ORAMCLIN=$P(^ORAM(103,ORAMDFN,6),U,2)
        . ; 1. Get local labs for patient w/in date range
        . D NGETINR(ORAMDFN,ORAMCLIN,ORAMSD,ORAMED)
        . ; 2. Next, loop thru flow sheets for patient to gather goal ranges
        . S ORAMDD=ORAMSD-.01
        . F  S ORAMDD=$O(^ORAM(103,ORAMDFN,3,"B",ORAMDD)) Q:'+$G(ORAMDD)  D
        .. S ORAMFS=0 F  S ORAMFS=$O(^ORAM(103,ORAMDFN,3,"B",ORAMDD,ORAMFS)) Q:'+$G(ORAMFS)  D
        ... I $G(PGR)="" S PGR=0 I ORAMFS>2 S PGR=$P(^ORAM(103,ORAMDFN,3,(ORAMFS-1),0),U,12) S:$G(PGR)="" PGR=0
        ... S ORAMFSD=$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U) Q:$G(ORAMFSD)<ORAMSD  Q:$G(ORAMFSD)>ORAMED  ;OUT OF DATE RANGE
        ... I $P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U,3)="",'+$D(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)) Q
        ... I +$D(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)) S ^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)=$P(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD),U)_U_$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U,12)
        ... I '+$D(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)) S ^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)=$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U,3)_U_$P(^(0),U,12)
        ; 3. Loop thru array of pts & INRs collected in prior steps
        ;    Format: ^TMP("ORAM",$J,CLINIC,DFN,FMDATE)=INR_VALUE ^GOAL RANGE
        S ORAMCLIN=0
        F  S ORAMCLIN=$O(^TMP("ORAM",$J,ORAMCLIN)) Q:$G(ORAMCLIN)=""  D
        . N ORAMPT S ORAMPT=0
        . F  S ORAMPT=$O(^TMP("ORAM",$J,ORAMCLIN,ORAMPT)) Q:'+$G(ORAMPT)  D
        .. N ORAMDATE S ORAMDATE=0
        .. S (LG,HG,V1,V1,D1,D2)=""
        .. F  S ORAMDATE=$O(^TMP("ORAM",$J,ORAMCLIN,ORAMPT,ORAMDATE)) Q:'+$G(ORAMDATE)  D NGETFS(.ORAMCARR,ORAMCLIN,ORAMPT,ORAMDATE,.D1,.D2,.V1,.V2,.PGR,.LG,.HG,.ORAMDIG,.ORAMTD)
        I $G(ORAMDIG)<1 S RESULT="0^0" W !!?2,"Unable to calulate TTR (may be due to a short time frame with few repeat",!?2,"readings on the same patients)."  Q
        S TOTS=$TR($J((ORAMDIG/ORAMTD)*100,8,1)," ","")
        S ORSITE=$$NAME^VASITE
        S:ORSITE']"" ORSITE=$P($$SITE^VASITE,U,2)
        W @IOF,"Results of Rosendaal Method for Time in Therapeutic Range:"
        W !!,"Facility-wide for ",ORSITE," for ",$$FMTE^XLFDT(ORAMSD,2)," - ",$$FMTE^XLFDT(ORAMED,2)
        W !,"TTR = ",TOTS,"% (TOTAL DAYS IN GOAL: ",$TR($J(ORAMDIG,8,1)," ","")," TOTAL DAYS: ",$TR($J(ORAMTD,8,1)," ",""),")"
        I +$O(ORAMCARR(0)) W !!,"Results by Clinic:"
        S CNT=0 F  S CNT=$O(ORAMCARR(CNT)) Q:$G(CNT)=""  D
        . N CTOT S CTOT=$TR($J(($P(ORAMCARR(CNT),U,2)/$P(ORAMCARR(CNT),U))*100,8,1)," ",""),$P(ORAMCARR(CNT),U,2)=$TR($J($P(ORAMCARR(CNT),U,2),8,1)," ",""),$P(ORAMCARR(CNT),U,3)=CTOT
        . W !,$E($P(^SC(CNT,0),U),1,21),": TTR = ",CTOT,"% (Total days in goal: ",$TR($J($P(ORAMCARR(CNT),U,2),8,1)," ","")," TOTAL DAYS: ",$TR($J($P(ORAMCARR(CNT),U),8,1)," ",""),")",!
        . S ORAMCARR(CNT)=$P(^SC(CNT,0),U)_U_$P(ORAMCARR(CNT),U,2,3)
        M RESULT=ORAMCARR
        S RESULT(0)=TOTS_U_$TR($J(ORAMDIG,8,1)," ","")_U_$TR($J(ORAMTD,8,1)," ","")
        K ^TMP("ORAM",$J)
        Q
        ;
NRINDV(RESULT,ORAMDFN,ORAMSD,ORAMED,ORAMWON)    ; TTR for single patient
        N ORAMFS,ORAMDD,PGR,ORAMCLIN
        S RESULT="NA"
        K ^TMP("ORAM",$J)
        Q:'+$D(^ORAM(103,ORAMDFN))  ;NOT IN FILE YET
        Q:'+$D(^ORAM(103,ORAMDFN,3))  ;NO FS ENTRIES YET
        Q:'$D(^ORAM(103,ORAMDFN,6))  Q:$P(^ORAM(103,ORAMDFN,6),U,2)=""  ;QUIT IF NO CLINIC ASSIGNED
        S:$G(ORAMSD)="" ORAMSD=$P(^ORAM(103,ORAMDFN,3,1,0),U)  ;IF NO DEFINED START DATE, DO FOR THE WHOLE TIME IN CLINIC.
        S:$G(ORAMED)="" ORAMED=DT
        S:$G(ORAMWON)="" ORAMWON=0  ;IF A NUMBER WILL WRITE RESULTS TO THE SCREEN
        S ORAMCLIN=$P(^ORAM(103,ORAMDFN,6),U,2)
        D NGETINR(ORAMDFN,ORAMCLIN,ORAMSD,ORAMED)  ;GETS LOCAL INR VALUES IN FORM ^TMP("ORAM",$J,CLINIC,DFN,FM_DATE)=VALUE^
        S ORAMDD=ORAMSD-.01
        F  S ORAMDD=$O(^ORAM(103,ORAMDFN,3,"B",ORAMDD)) Q:'+$G(ORAMDD)  D
        . S ORAMFS=0 F  S ORAMFS=$O(^ORAM(103,ORAMDFN,3,"B",ORAMDD,ORAMFS)) Q:'+$G(ORAMFS)  D
        .. N ORAMFSD
        .. I $G(PGR)="" S PGR=0 I ORAMFS>2 S PGR=$P(^ORAM(103,ORAMDFN,3,(ORAMFS-1),0),U,12) S:$G(PGR)="" PGR=0
        .. S ORAMFSD=$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U) Q:$G(ORAMFSD)<ORAMSD  Q:$G(ORAMFSD)>ORAMED  ;OUT OF DATE RANGE
        .. I $P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U,3)="",'+$D(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)) Q
        .. I +$D(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)) S ^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)=$P(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD),U)_U_$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U,12)
        .. I '+$D(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)) S ^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMFSD)=$P(^ORAM(103,ORAMDFN,3,ORAMFS,0),U,3)_U_$P(^(0),U,12)
        Q:'$D(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN))
        ;FORMED ARRAY OF PATIENTS AND SCORES IN THE DATE RANGE; FORMAT ^TMP("ORAM",$J,CLINIC,DFN,FMDATE)=INR_VALUE ^ GOAL RANGE.
        N ORAMDATE,LG,HG,V1,V2,D1,D2,ORAMDAYS,ORAMDIG,ORAMTD
        N ORAMC2,ORAMPT,ORAMCARR S ORAMC2=ORAMCLIN,ORAMPT=ORAMDFN
        S ORAMDATE=0 F  S ORAMDATE=$O(^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMDATE)) Q:'+$G(ORAMDATE)  D NGETFS(.ORAMCARR,ORAMCLIN,ORAMDFN,ORAMDATE,.D1,.D2,.V1,.V2,.PGR,.LG,.HG,.ORAMDIG,.ORAMTD)
        I $G(ORAMDIG)<1 S RESULT="0^0" W:+$G(ORAMWON) !!?2,"Unable to calulate TTR (may be due to a short time frame with few repeat",!?2,"readings on the same patient)."  Q
        N TOTS S TOTS=$TR($J((ORAMDIG/ORAMTD)*100,8,1)," ","")
        I +$G(ORAMWON) D
        . W !!,"Rosendaal method for percentage of INR scores in therapeutic range",!
        . W !,?5,$E($P(^DPT($G(ORAMDFN),0),U),1,10)_" ("_$E($P(^(0),U,9),6,9)_") for ",$$FMTE^XLFDT(ORAMSD,2)," - ",$$FMTE^XLFDT(ORAMED,2)
        . W !,?5,"TTR = ",TOTS,"%  (TOTAL DAYS IN GOAL: ",$TR($J(ORAMDIG,8,1)," ",""),"  TOTAL DAYS: ",$TR($J(ORAMTD,8,1)," ",""),")",!
        S RESULT=TOTS_U_$TR($J(ORAMDIG,8,1)," ","")_U_$TR($J(ORAMTD,8,1)," ","")
        K ^TMP("ORAM",$J)
        Q
        ;
NGETINR(ORAMDFN,ORAMCLIN,ORAMSD,ORAMED) ; Get local INRs - sort by clinic, patient, & date
        N LDATE,INR,LRDFN,ORAMITST,ORAMQO,INRHD,INRRD,RSD,RED
        I '$G(ORAMDFN) Q  ;IF DFN IS NOT PASSED, EXIT
        S LRDFN=$G(^DPT(ORAMDFN,"LR")) Q:'+$G(LRDFN)
        S RSD=9999999-(ORAMSD-.01)  ;REVERSE START DATE
        S RED=9999999-ORAMED
        N ORAMITST,ORAMORD S ORAMQO=$$GET^XPAR("ALL","ORAM INR QUICK ORDER",1,"I")
        I +ORAMQO'>0 W !!,"Parameter ORAM QUICK ORDER not yet established. Please contact your CAC.",! Q
        S ORAMITST=$$INRCHK^ORAM(ORAMQO)
        I +ORAMITST'>0 W !!,"Parameter ORAM QUICK ORDER not properly set up. Please contact your CAC.",! Q
        S LDATE=RSD F  SET LDATE=$O(^LR(LRDFN,"CH",LDATE),-1) Q:LDATE<1!(LDATE<RED)  D
        . N SCORE S SCORE=$G(^LR(LRDFN,"CH",LDATE,ORAMITST))  ;648149
        . Q:SCORE=""  ;QUIT IF NO INR TEST
        . Q:$P(SCORE,U,1)=""  ;QUIT IF NO INR DATA
        . S INR=$P(SCORE,U,1)  ;INR
        . N ORAMX S ORAMX=$E((9999999-LDATE),1,7)
        . S ^TMP("ORAM",$J,ORAMCLIN,ORAMDFN,ORAMX)=$G(INR)_U
        Q
        ;
NGETFS(ORAMCARR,ORAMCLIN,ORAMPT,ORAMDATE,D1,D2,V1,V2,PGR,LG,HG,ORAMDIG,ORAMTD)  ; Check flow sheet entries vs. goals
        N CG,ORAMZ,ORAMDAYS
        S CG=$P(^TMP("ORAM",$J,ORAMCLIN,ORAMPT,ORAMDATE),U,2),ORAMZ=0
        I $G(CG)="",'+$G(LG) Q:'+$G(PGR)  S CG=PGR  ;BRINGS IN THE LAST GOAL INFO THAT SHOULD BE IN EFFECT FOR THE FIRST SEGMENT
        I $G(CG)'="" S LG=$P(CG,"-"),HG=$P(CG,"-",2)  S:HG[" " HG=$P(HG," ",2)  ;USES NEW ONE IF AVAILABLE
        Q:$P(^TMP("ORAM",$J,ORAMCLIN,ORAMPT,ORAMDATE),U)=""
        N ORAMIV S ORAMIV=$P(^TMP("ORAM",$J,ORAMCLIN,ORAMPT,ORAMDATE),U) S:ORAMIV[">" ORAMIV=$P(ORAMIV,">",2) S:ORAMIV["<" ORAMIV=$P(ORAMIV,"<",2)
        Q:'+ORAMIV  ;QUITS IF NOT A NUMBER AFTER CHECKING FOR > AND < SIGNS
        S D2=ORAMDATE S V2=ORAMIV_U_$S(ORAMIV>HG:"H",ORAMIV<LG:"L",1:"G")  ;IF OUT OF RANGE LISTS H OR L OTHERWISE G
        I $G(D1)="" S ORAMZ=1
        I '+$G(ORAMZ) D
        . S ORAMDAYS=$$FMDIFF^XLFDT(D2,D1,1)  ;DAYS DIFFERENCE BETWEEN THE LAST TWO INRS
        . S ORAMTD=$G(ORAMTD)+ORAMDAYS
        . S $P(ORAMCARR(ORAMCLIN),U)=($P($G(ORAMCARR(ORAMCLIN)),U)+ORAMDAYS)
        . I $P(V1,U,2)=$P(V2,U,2) S:$P(V1,U,2)="G" ORAMDIG=$G(ORAMDIG)+ORAMDAYS,$P(ORAMCARR(ORAMCLIN),U,2)=$P(ORAMCARR(ORAMCLIN),U,2)+ORAMDAYS  ;IF ALL IN GOAL, ALL GOOD, OTHERWISE 0 IN GOAL
        . I $P(V1,U,2)'=$P(V2,U,2) D  ;WAS IN GOAL IN ONLY ONE OF THE READINGS (OR ONE H AND ONE L)
        .. N DIFF S DIFF=$$ABS^XLFMTH($P(V1,U)-$P(V2,U)) N NUMC,NUMPC S:$P(V1,U,2)="G" NUMC=$P(V1,U)_U_$P(V2,U,2) S:$P(V2,U,2)="G" NUMC=$P(V2,U)_U_$P(V1,U,2)
        .. I $G(NUMC)'="" D
        ... I $P(NUMC,U,2)="L" S NUMPC=$$ABS^XLFMTH(LG-$P(NUMC,U)),NUMPC=NUMPC/DIFF
        ... I $P(NUMC,U,2)="H" S NUMPC=$$ABS^XLFMTH(HG-$P(NUMC,U)),NUMPC=NUMPC/DIFF
        .. I $G(NUMC)="" D  ; FOR THE RARE CASE OF A SKIPPED GOAL RANGE, SO NOT =, BUT ONE IS LOW AND THE OTHER HIGH
        ... S NUMPC=$$ABS^XLFMTH(HG-LG),NUMPC=NUMPC/DIFF
        .. S ORAMDIG=$G(ORAMDIG)+$TR($J(NUMPC*ORAMDAYS,8.3)," ","")
        .. S $P(ORAMCARR(ORAMCLIN),U,2)=($P(ORAMCARR(ORAMCLIN),U,2)+$TR($J(NUMPC*ORAMDAYS,8.3)," ",""))
        S D1=D2,V1=V2
        Q
        ;
