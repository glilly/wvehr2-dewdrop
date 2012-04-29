C0QERTIM        ; Time from admission to leaving a hospital location ;
        ;;0.1;C0Q;;;Build 12
EN      ;Get Location
        S DIC=42,DIC(0)="AEMQ" D ^DIC I Y<1 G EXIT
        S LOCATION=+Y
        ;Start date
        S %DT="AE",%DT("A")="Start DATE: " D ^%DT G:Y=-1 EXIT S START=Y
        ;End date
        S %DT="AE",%DT("A")="Stop DATE: " D ^%DT G:Y=-1 EXIT S STOP=Y
        ;select device:
        S %ZIS="Q" D ^%ZIS G EXIT:POP
        I $D(IO("Q")) D  G EXIT
        . S ZTRTN="DQ^C0QERTIM",ZTDESC="Time from admission to leaving a hospital location"
        . S ZTSAVE("LOCATION")="",ZTSAVE("START")="",ZTSAVE("STOP")=""
        . D ^%ZTLOAD D HOME^%ZIS K IO("Q")
        . Q
DQ      ; Get down to business
        ;sort on admit date/time in file 45, screen on LOSING WARD in sub-file 535.
        ;^DGPT("AF",date/time,DA)
        S PATCOUNT=0,ADMITIME=START
        F  S ADMITIME=$O(^DGPT("AF",ADMITIME)) Q:ADMITIME'>0  D
        . Q:ADMITIME>STOP
        . ;FMIN from ADMISSION DATE piece 2
        . S X=ADMITIME D H^%DTC S FMINDAY=%H,FMINSEC=%T
        . S D0="" F  S D0=$O(^DGPT("AF",ADMITIME,D0)) Q:D0'>0  D
        . . S D1=0 F  S D1=$O(^DGPT(D0,535,D1)) Q:D1'>0  D
        . . . ;Losing ward in piece 6 of ^DGPT(D0,535,D1,0)
        . . . Q:$P($G(^DGPT(D0,535,D1,0)),U,6)'=LOCATION
        . . . ;FMOUT from MOVEMENT DATE on leaving in piece 10
        . . . S X=$P($G(^DGPT(D0,535,D1,0)),U,10) D H^%DTC S FMOUTDAY=%H,FMOUTSEC=%T
        . . . I FMINDAY=FMOUTDAY S MINUTES=$P((FMOUTSEC-FMINSEC)/60,".")
        . . . I FMINDAY'=FMOUTDAY D
        . . . . S DIFFDAY=FMOUTDAY-FMINDAY
        . . . . S MINUTES=1440*(DIFFDAY-1)+$P((FMOUTSEC+86400-FMINSEC)/60,".")
        . . . . Q
        . . . S PATCOUNT=PATCOUNT+1
        . . . S ^TMP($J,"PATIENTS",$P(^DPT(+^DGPT(D0,0),0),U))=MINUTES
        . . . S ^TMP($J,"MINUTES",MINUTES)=1+$G(^TMP($J,"MINUTES",MINUTES))
        . . . Q
        . . Q
        . Q
        U IO W @IOF
        ;list median time from Admission to leaving hospital LOCATION
        S MID=$P(PATCOUNT/2,"."),SUM=0
        S MEDIAN=0 F  S MEDIAN=$O(^TMP($J,"MINUTES",MEDIAN)) Q:MEDIAN'>0  D
        . S SUM=SUM+^TMP($J,"MINUTES",MEDIAN) Q:SUM>MID
        . Q
        W "The median time spent in ",$P(^DIC(42,LOCATION,0),U)," is ",MEDIAN," minutes.",!
        W !,"Patient",?40,"Minutes in ",$P(^DIC(42,LOCATION,0),U)
        ;list patient and time from admission to leaving the location
        S PATIENT="" F  S PATIENT=$O(^TMP($J,"PATIENTS",PATIENT)) Q:PATIENT=""  D
        . W !,PATIENT,?40," ",^TMP($J,"PATIENTS",PATIENT)
EXIT    ; DO CLEANUP
        S:$D(ZTQUEUED) ZTREQ="@"
        K DIC,START,STOP,LOCATION,PATCOUNT,ADMITIME,FMINDAY,FMINSEC,FMOUTDAY,FMOUTSEC
        K POP,D0,D1,DIFFDAY,MINUTES,MID,MEDIAN,PATIENT,^TMP($J)
        Q
