SDRRUTL ;10N20/MAH;Recall Reminder-Clinic Utilities;01/18/2008  11:32
        ;;5.3;Scheduling;**536**;Aug 13, 1993;Build 53
ASKDIV(SDRRDIV) ;
        N DIC,X,Y,I,DUOUT,DTOUT
        K SDRRDIV
        S SDRRDIV=0
        W !
        S DIC("A")="Select Medical Center Division: All// "
        S DIC="^DG(40.8,"
        S DIC(0)="AEQMN"
        F  D  Q:Y=-1
        . D ^DIC Q:Y=-1
        . S SDRRDIV(+Y)=$P(Y,U,2)
        . S DIC("A")="Another Medical Center Division: "
        Q:$D(DTOUT)!$D(DUOUT)
        S I=0
        I $O(SDRRDIV(0)) D  Q
        . F  S I=$O(SDRRDIV(I)) Q:'I  S SDRRDIV=SDRRDIV+1
        F  S I=$O(^DG(40.8,I)) Q:'I  S SDRRDIV(I)=$P(^(I,0),U),SDRRDIV=SDRRDIV+1
        Q
ASKSTOP(SDRRSC,SDRRST,SDRRND)   ;
        N DIC,X,Y,I,DUOUT,DTOUT,SDRRREC
        K SDRRSC
        S SDRRSC=0
        W !
        S DIC("A")="Select Clinic Stop Code: All// "
        S DIC="^DIC(40.7,"
        S:$G(SDRRST) DIC("S")="N SDRRXD S SDRRXD=$P(^(0),U,3) I 'SDRRXD!(SDRRXD'<SDRRST)"
        S DIC(0)="AEQMZ"
        F  D  Q:Y=-1
        . D ^DIC Q:Y=-1
        . S SDRRSC(+Y)=$P(Y(0),U,2)
        . S DIC("A")="Another Clinic Stop Code: "
        Q:$D(DTOUT)!$D(DUOUT)
        S I=0
        I $O(SDRRSC(0)) D  Q
        . F  S I=$O(SDRRSC(I)) Q:'I  S SDRRSC=SDRRSC+1
        F  S I=$O(^DIC(40.7,I)) Q:'I  S SDRRREC=^(I,0) D
        . Q:$P(SDRRREC,U,3)<SDRRST
        . S SDRRSC(I)=$P(SDRRREC,U),SDRRSC=SDRRSC+1
        Q
ASKCLIN(SDRRCLIN,SDRRDIV,SDRRST,SDRRND) ;
        N DIR,X,Y,DIRUT
        K SDRRCLIN
        S SDRRCLIN=0
        W !
        S DIR(0)="Y"
        S DIR("A")="All Clinics"
        S DIR("B")="No"
        D ^DIR Q:$D(DIRUT)
        I Y S SDRRCLIN="ALL" Q
        D ASKRANGE^SDRRUTL1(.SDRRCLIN,.SDRRDIV,.SDRRST,.SDRRND)
        Q
DELIM() ;
        N DIR,X,Y,DIRUT
        S DIR(0)="Y"
        S DIR("A")="Delimited Output"
        S DIR("B")="No"
        D ^DIR Q:$D(DIRUT) -1
        Q Y
REVERSE(SDRRST,SDRRND)  ; Given starting and ending dates return reverse starting and ending dates
        N SDRRRST,SDRRRND
        S SDRRRST=9999999-SDRRST+.9999
        S SDRRRND=9999999-SDRRND
        S SDRRST=SDRRRND
        S SDRRND=SDRRRST
        Q
DRANGE(SDRRST,SDRRND,SDRRSTX,SDRRNDX,SDRRABORT,SDRRMIN,SDRRMAX,SDRRFUTR)        ;
        ; Set SDRRFUTR=1 if dates in the future are OK.
        N DIR,DIRUT,X,Y
        I $G(SDRRFUTR) S DIR(0)="D^"_$G(SDRRMIN)_":"_$G(SDRRMAX)_":AEFX"
        E  S DIR(0)="D^"_$G(SDRRMIN)_":"_$G(SDRRMAX,DT)_":AEPX"
        S DIR("A")="Enter start date"
        I $D(SDRRST) D
        . S SDRRSTX=$$FMTE^XLFDT(SDRRST,5)
        . S DIR("B")=SDRRSTX
        D ^DIR I $D(DIRUT) S SDRRABORT=1 Q
        S SDRRST=Y
        K DIR
        I $G(SDRRFUTR) S DIR(0)="D^"_SDRRST_":"_$G(SDRRMAX)_":AEFX"
        E  S DIR(0)="D^"_SDRRST_":"_$G(SDRRMAX,DT)_":AEPX"
        S DIR("A")="Enter end date"
        I $D(SDRRND) D
        . S SDRRNDX=$$FMTE^XLFDT(SDRRND,5)
        . S DIR("B")=SDRRNDX
        D ^DIR I $D(DIRUT) S SDRRABORT=1 Q
        S SDRRND=Y
        S SDRRNDX=$$FMTE^XLFDT(SDRRND,2)
        S SDRRSTX=$$FMTE^XLFDT(SDRRST,2)
        Q
ASKDATE(SDRRST,SDRRSTX,SDRRABORT,SDRRMIN,SDRRMAX,SDRRFUTR)      ;
        N DIR,DIRUT,X,Y
        I $G(SDRRFUTR) S DIR(0)="D^"_$G(SDRRMIN)_":"_$G(SDRRMAX)_":AEFX"
        E  S DIR(0)="D^"_$G(SDRRMIN)_":"_$G(SDRRMAX,DT)_":AEPX"
        S DIR("A")="Enter start date"
        I $D(SDRRST) D
        . S SDRRSTX=$$FMTE^XLFDT(SDRRST,2)
        . S DIR("B")=SDRRSTX
        D ^DIR I $D(DIRUT) S SDRRABORT=1 Q
        S SDRRST=Y
        S SDRRSTX=$$FMTE^XLFDT(SDRRST,2)
        Q
FYRANGE(SDRRST,SDRRND,SDRRSTX,SDRRNDX,SDRRABORT,SDRRMIN,SDRRMAX)        ;
        N SDRRMAXFY,SDRRFRFY,SDRRTOFY
        S (SDRRMAXFY,SDRRTOFY)=$$FY($$FMADD^XLFDT($E(DT,1,5)_"01",-1)) ; FY of last month
        S SDRRFRFY=$$ASKFY($G(SDRRMIN),$G(SDRRMAX),,"From")
        I SDRRFRFY=0 S SDRRABORT=1 Q
        I SDRRFRFY'=SDRRMAXFY D  Q:SDRRABORT
        . S SDRRTOFY=$$ASKFY($P(SDRRFRFY,U,3),$G(SDRRMAX),+$P(SDRRMAXFY," ",2),"Through")
        . I SDRRTOFY=0 S SDRRABORT=1
        S SDRRST=$P(SDRRFRFY,U,2)
        S SDRRND=$P(SDRRTOFY,U,3)
        S SDRRSTX=$$FMTE^XLFDT($E(SDRRST,1,5)_"01",2)
        S SDRRNDX=$$FMTE^XLFDT($$FMADD^XLFDT($E(SDRRND,1,5)_"01",-1),2)
        S SDRRSTX("FY")=$P(SDRRFRFY,U)
        S SDRRNDX("FY")=$P(SDRRTOFY,U)
        Q
ASKFY(SDRRMIN,SDRRMAX,SDRRDEF,SDRRPRMPT)        ; Function asks user which FY.
        N DIR,X,Y,DIRUT,SDRRFY
        S DIR("A")=$G(SDRRPRMPT,"Select")_" FY ("
        I '$G(SDRRMAX) D
        . S SDRRMAX=$$FMADD^XLFDT($E(DT,1,5)_"01",-1) ; last month
        . S SDRRMAX=$E($P($$FY(SDRRMAX),U,3),1,3)_"0000"
        I $G(SDRRMIN) S DIR("A")=DIR("A")_($E(SDRRMIN,1,3)+1700)_" "
        S DIR("A")=DIR("A")_"through "_($E(SDRRMAX,1,3)+1700)_"): "
        S DIR(0)="DA^"_$G(SDRRMIN)_":"_SDRRMAX_":AEM"
        S DIR("B")=$$FMTE^XLFDT($G(SDRRDEF,SDRRMAX))
        D ^DIR I $D(DIRUT) Q 0
        S SDRRFY=$$FY(Y)
        W "     ",$P(SDRRFY,U)
        Q SDRRFY
FY(SDRRDT)      ; Pass in a date (default = today's date),
        ; and this function returns what FY we are in,
        ; followed by the FY start date and FY end date.
        ; ie. S X=$$FY^SDRRUTL(3050208) results in X="FY 2005^3041000^3051000"
        N SDRRST,SDRRND
        S:'$D(SDRRDT) SDRRDT=DT
        S SDRRST=$E(SDRRDT,1,3)-($E(SDRRDT,4,5)<10)_"1000"
        S SDRRND=$E(SDRRST,1,3)+1_"1000"
        Q "FY "_(1701+$E(SDRRST,1,3))_U_SDRRST_U_SDRRND
ASKMON(SDRRMON) ; Function asks user which month.
        ; SDRRMON - (optional) default month
        N DIR,X,Y,DIRUT,SDRRDT
        S DIR("A")="Select Month"
        I $D(SDRRMON) S SDRRDT=SDRRMON
        E  D
        . S SDRRDT=$$FMADD^XLFDT($E(DT,1,5)_"01",-1) ; last month
        . S SDRRDT=$E(SDRRDT,1,5)_"00"
        S DIR(0)="D^:"_SDRRDT_":AEM"
        S DIR("B")=$$FMTE^XLFDT(SDRRDT)
        D ^DIR I $D(DIRUT) Q 0
        Q Y
MON(SDRRDT)     ; Pass in a date (default = today's date),
        ; and this function returns the first and last dates of the month.
        N SDRRMST,SDRRMND
        S:'$D(SDRRDT) SDRRDT=DT
        S SDRRMST=$E(SDRRDT,1,5)_"01"
        S SDRRMND=$$SCH^XLFDT("1M(1)",SDRRMST)\1
        Q SDRRMST_U_SDRRMND
BDAY    ;
        N GDAYS,JDAYS,YR1DAYS
        S GDAYS=$$FMDIFF^XLFDT(3050830,3050628) W !,"GDAYS=",GDAYS
        S JDAYS=$$FMDIFF^XLFDT(3050830,3050811) W !,"JDAYS=",JDAYS
        S YR1DAYS=365-GDAYS-JDAYS W !,"YR1DAYS=",YR1DAYS
        W !,"99th Birthday= ",$$FMADD^XLFDT(3050830,YR1DAYS\4)
        W !,"100th Birthday=",$$FMADD^XLFDT(3050830,(YR1DAYS+365)\4)
        W !,"101st Birthday=",$$FMADD^XLFDT(3050830,YR1DAYS+730\4)
        Q
