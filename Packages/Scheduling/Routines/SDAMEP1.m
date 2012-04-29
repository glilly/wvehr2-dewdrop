SDAMEP1 ;ALB/CAW - Expanded Display (Appt. Data) ; 16 May 2001  4:49 PM  ; Compiled August 22, 2008 12:24:32
        ;;5.3;Scheduling;**20,241,534**;Aug 13, 1993;Build 8
        ;
APDATA  ; Appointment Data
        ;
        D SET($$SETSTR^VALM1("*** Appointment Demographics ***","",24,32))
        D CNTRL^VALM10(SDLN,24,32,IOINHI,IOINORM)
        D SET("")
        ;
        S X=""
        S X=$$SETSTR^VALM1("           Name:",X,1,SDWIDTH)
        S X=$$SETSTR^VALM1($P($G(^DPT(DFN,0)),U),X,SDFSTCOL,24)
        S X=$$SETSTR^VALM1("         Clinic:",X,40,SDWIDTH)
        S X=$$SETSTR^VALM1($P($G(^SC(SDCL,0)),U),X,SDSECCOL,24)
        D SET(X)
        ;
        S X=""
        S X=$$SETSTR^VALM1("             ID:",X,1,SDWIDTH)
        S X=$$SETSTR^VALM1(VA("PID"),X,SDFSTCOL,24)
        S X=$$SETSTR^VALM1("      Date/Time:",X,40,SDWIDTH)
        S X=$$SETSTR^VALM1($$FTIME^VALM1(SDT),X,SDSECCOL,24)
        D SET(X)
        ;
        S X=""
        S X=$$SETSTR^VALM1("         Status:",X,1,SDWIDTH)
        S X=$$SETSTR^VALM1($P($$STATUS^SDAM1(DFN,SDT,SDCL,$G(^DPT(DFN,"S",SDT,0)),SDDA),";",3),X,SDFSTCOL,50)
        D SET(X)
        ;
        S SDPV=$P($G(^DPT(DFN,"S",SDT,0)),U,7),SDPOV=$S(SDPV=1:"C&P",SDPV=2:"10-10",SDPV=3:"SCHEDULED",SDPV=4:"UNSCHEDULED",1:"UNKNOWN")
        S X="",X=$$SETSTR^VALM1("Purpose of Vst.:",X,1,16)
        S X=$$SETSTR^VALM1(SDPOV,X,SDFSTCOL,24)
        D SET(X)
        ;
        S X=""
        S X=$$SETSTR^VALM1(" Length of Appt:",X,1,SDWIDTH)
        S X=$$SETSTR^VALM1($G(SDSC(44.003,SDDA,1)),X,SDFSTCOL,4)
        S X=$$SETSTR^VALM1("      Appt Type:",X,40,SDWIDTH)
        S X=$$SETSTR^VALM1(SDPT(2.98,SDT,9.5),X,SDSECCOL,24)
        D SET(X)
        ;
        S X=""
        S X=$$SETSTR^VALM1("            Lab:",X,1,SDWIDTH)
        S X=$$SETSTR^VALM1($P(SDPT(2.98,SDT,5),"@",2),X,SDFSTCOL,5)
        S X=$$SETSTR^VALM1("   Elig of Appt:",X,40,SDWIDTH)
        S X=$$SETSTR^VALM1($G(SDSC(44.003,SDDA,30)),X,SDSECCOL,24)
        D SET(X)
        ;
        S X=""
        S X=$$SETSTR^VALM1("          X-ray:",X,1,SDWIDTH)
        S X=$$SETSTR^VALM1($P(SDPT(2.98,SDT,6),"@",2),X,SDFSTCOL,5)
        S X=$$SETSTR^VALM1("       Overbook:",X,40,SDWIDTH)
        S X=$$SETSTR^VALM1($G(SDSC(44.003,SDDA,9)),X,SDSECCOL,24)
        D SET(X)
        ;
        S X=""
        S X=$$SETSTR^VALM1("            EKG:",X,1,SDWIDTH)
        S X=$$SETSTR^VALM1($P(SDPT(2.98,SDT,7),"@",2),X,SDFSTCOL,5)
        S X=$$SETSTR^VALM1("Collateral Appt:",X,40,SDWIDTH)
        S X=$$SETSTR^VALM1($G(SDPT(2.98,SDT,13)),X,SDSECCOL,17)
        D SET(X)
        ;
        S X=""
        N SDINFL S SDINFL=$L($G(SDSC(44.003,SDDA,3))) ; lenght of INFO STRING
        I SDINFL<64 D
        .S X=$$SETSTR^VALM1("          Other:",X,1,SDWIDTH)
        .S X=$$SETSTR^VALM1($G(SDSC(44.003,SDDA,3)),X,SDFSTCOL,63)
        I SDINFL>63&(SDINFL<143) D
        .S X=$$SETSTR^VALM1("          Other:",X,1,SDWIDTH)
        .S X=$$SETSTR^VALM1($E($G(SDSC(44.003,SDDA,3)),1,64),X,17,80)
        .D SET(X)
        .S X=$$SETSTR^VALM1("",X,1,0)
        .S X=$$SETSTR^VALM1($E($G(SDSC(44.003,SDDA,3)),65,150),X,1,80)
        I SDINFL>142 D
        .S X=$$SETSTR^VALM1("   Other:",X,1,10)
        .S X=$$SETSTR^VALM1($E($G(SDSC(44.003,SDDA,3)),1,70),X,11,80)
        .D SET(X)
        .S X=$$SETSTR^VALM1("",X,1,0)
        .S X=$$SETSTR^VALM1($E($G(SDSC(44.003,SDDA,3)),71,150),X,1,80)
        D SET(X)
        ;
        S (X,SDEIC)="" F SDI=0:0 S SDI=$O(^DPT(DFN,"DE",SDI)) Q:'SDI  I $P(^(SDI,0),U)=SDCL F SDX=0:0 S SDX=$O(^DPT(DFN,"DE",SDI,1,SDX)) Q:'SDX  S SDEN=$G(^DPT(DFN,"DE",SDI,1,SDX,0))
        D ENROLL
        D SET($S($D(SDFLG):X,1:" "))
        S X="",X=$$SETSTR^VALM1($S('$D(SDEN):"",$P(SDEN,U)="":"",$P(SDEN,U,3)="":"Enrollment Date/Time:",1:""),X,4,21)
        I $D(SDEN),+SDEN,$P(SDEN,U,3)="" S X=$$SETSTR^VALM1($$FTIME^VALM1($P(SDEN,U)),X,26,18)
        D SET(X)
        Q
        ;
ENROLL  ;
        S SDFLG=1
        S X="",X=$$SETSTR^VALM1("Enrolled in this clinic:",X,1,25)
        S X=$$SETSTR^VALM1($S('$D(SDEN):"NO",$P(SDEN,U)="":"NO",$P(SDEN,U,3)'="":"NO",1:"YES"),X,26,3)
        S X=$$SETSTR^VALM1($S('$D(SDEN):"",$P(SDEN,U)="":"",$P(SDEN,U,3)="":" OPT or AC:",$P(SDEN,U,3)'="":"Disch fm Clinic:",1:""),X,44,17)
        I $D(SDEN),+SDEN,$P(SDEN,U,3)="" S X=$$SETSTR^VALM1($S($P(SDEN,U,2)="A":"AC",1:"OPT"),X,SDSECCOL,3)
        I $D(SDEN),+SDEN,$P(SDEN,U,3)'="" S X=$$SETSTR^VALM1($$FTIME^VALM1($P(SDEN,U,3)),X,62,17)
        Q
SET(X)  ; Set in ^TMP global for display
        ;
        S SDLN=SDLN+1,^TMP("SDAMEP",$J,SDLN,0)=X
        Q
        ;
INIT    ; -- set up vars
        N DR,DIQ,DIC,DA
        D PID^VADPT6
        S SDFSTCOL=18,SDWIDTH=16,SDSECCOL=57
        I SDDA="" S SDDA=+$$FIND^SDAM2(DFN,SDT,SDCL)
        S SDOE=+$P($G(^DPT(DFN,"S",SDT,0)),"^",20)
        S DIQ="SDPT(",DIC="^DPT(DFN,""S"",",DA=SDT,DR=".01;3;5;6;7;12;13;14;15;16;9.5;17;19;20;25;26;27;28" D EN^DIQ1
        S DIQ="SDSC(",DIC="^SC(SDCL,""S"",SDT,1,",DA=SDDA,DR="1;3;7;8;9;30;309;302;303;304;306" D EN^DIQ1
        I $G(SDOE) S DIQ="SDOE(",DIC="^SCE(",DA=+SDOE,DR=".07" D EN^DIQ1
        I $D(SDSC(44.003,SDDA,30)),SDSC(44.003,SDDA,30)="" S SDSC(44.003,SDDA,30)=$P($G(^DIC(8,+$G(^DPT(DFN,.36)),0)),U)
        I $D(SDSC(44.003,SDDA,9)),SDSC(44.003,SDDA,9)="" S SDSC(44.003,SDDA,9)="NO"
        I $D(SDPT(2.98,SDT,13)),SDPT(2.98,SDT,13)="" S SDPT(2.98,SDT,13)="NO"
        S DIQ(0)="I",DIQ="SDPTI(",DIC="^DPT(DFN,""S"",",DA=SDT,DR="3;20;25;26;27;28" D EN^DIQ1
        Q
