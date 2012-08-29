PSBODL  ;BIRMINGHAM/EFC-DUE LIST ;Mar 2004
        ;;3.0;BAR CODE MED ADMIN;**5,9,38,32,25**;Mar 2004;Build 6
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified. 
        ;
        ; Reference/IA
        ; EN^PSJBCMA/2828
        ; $$GET^XPAR/2263
        ; ^XLFDT/10103
        ;
EN      ; Prt DL
        N PSBGBL,PSBHDR,IOINHI,IOINORM,PSBGIVEN,PSBIEN,PSBLGDT,PSBEVDT,DFN,PSBFLAG
        S X="IOINHI;IOINORM" D ENDR^%ZISS S X=""
        I '$D(^TMP("PSBO",$J,"B")) S ^TMP("PSBO",$J,"B","EMPTY")=""
        S PSBGBL="^TMP(""PSBO"",$J,""B"")"
        I $G(PSBRPT(.4)) S $P(PSBRPT(.2),U,8)=1
        F  S PSBGBL=$Q(@PSBGBL) Q:PSBGBL=""  Q:$QS(PSBGBL,1)'="PSBO"!($QS(PSBGBL,2)'=$J)  D
        .S DFN=$QS(PSBGBL,5)
        .K PSBHDR
        .S PSBHDR(1)="MEDICATION DUE LIST for "
        .S (Y,PSBEVDT)=$P(PSBRPT(.1),U,6) D D^DIQ S Z=Y,PSBHDR(1)=PSBHDR(1)_Y_"@" S Y=$P(PSBRPT(.1),U,7) S PSBHDR(1)=PSBHDR(1)_$E(Y_"0000",2,5)
        .S PSBEVDT2=$P(PSBRPT(.1),U,6) S Y=$P(PSBRPT(.1),U,9) S:Y]"" PSBHDR(1)=PSBHDR(1)_" to "_Z_"@"_$E(Y_"0000",2,5)
        .S PSBHDR(2)="Schedule Type(s): --"
        .F Y=1:1:4 I $P(PSBRPT(.2),U,Y) S $P(PSBHDR(2),": ",2)=$P(PSBHDR(2),": ",2)_$S(PSBHDR(2)["--":"",1:"/ ")_$P("Continuous^PRN^On-Call^One-Time",U,Y)_" " S PSBHDR(2)=$TR(PSBHDR(2),"-","")
        .S PSBHDR(3)="Order Type(s): --"
        .F Y=6,7,8 I $P(PSBRPT(.2),U,Y) S $P(PSBHDR(3),": ",2)=$P(PSBHDR(3),": ",2)_$S(PSBHDR(3)["--":"",1:"/ ")_$P("^^^^^IV^Unit Dose^Future Orders",U,Y)_" " S PSBHDR(3)=$TR(PSBHDR(3),"-","")
        .I $QS(PSBGBL,4)="EMPTY" D  Q
        ..S X="" F  S X=$O(PSBHDR(X)) Q:X=""  D  W !!?10,"** NO DATA FOR ENTIRE NURSE/WARD LOCATION **",! Q
        ...W !,PSBHDR(X)
        .D PRINT(DFN)
        K ^TMP("PSJ",$J),^TMP("PSB",$J),^TMP("PSBO",$J)
        Q
PRINT(DFN)      ;^TMP($J.
        N PSBGBL,PSBOSTRT,PSBOSTOP,PSBINDX,PSBTYPE,PSBSCH,PSBSCHT
        N PSBMED,PSBORD,PSB,PSBX,PSBY,PSBZ,PSBSTOP,PSBSTRT,PSBSM,PSBNUM,PSBAT
        N PSBADMIN,PSBADM,PSBSTAT,PSBWFLAG
        W $$HDR()
        S PSBOSTRT=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7)
        S PSBOSTOP=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,9)
        K ^TMP("PSJ",$J),^TMP("PSB",$J)
        D EN^PSJBCMA(DFN,PSBOSTRT,"")
        I $G(^TMP("PSJ",$J,1,0))=-1 W !!?10,"** NO SPECIFIED MEDICATIONS TO PRINT **",!,$$BLANKS(),$$FTR^PSBODL1() Q
        S PSBI1=0 F  S PSBODATE=$$FMADD^XLFDT(PSBEVDT,PSBI1) Q:PSBODATE>PSBEVDT2  D
        .S PSBI1=1
        .S Y=PSBODATE D D^DIQ
        .W !!,"Administration Date: "_Y,!
        .S PSBINDX=0
        .F  S PSBINDX=$O(^TMP("PSJ",$J,PSBINDX)) Q:'PSBINDX  D
        ..S PSBTYPE=$P(^TMP("PSJ",$J,PSBINDX,0),U,3),PSBTYPE=$E(PSBTYPE,$L(PSBTYPE))
        ..Q:PSBTYPE=""!(PSBTYPE="P")  ; No Pend this ver
        ..S PSBSTAT=^TMP("PSJ",$J,PSBINDX,1)
        ..I $P(PSBSTAT,U,7)["D"!($P(PSBSTAT,U,7)="E")!($P(PSBSTAT,U,8)) Q
        ..Q:PSBTYPE="U"&('$P(PSBRPT(.2),U,7))
        ..Q:PSBTYPE="V"&('$P(PSBRPT(.2),U,6))
        ..S PSBTYPE=$S(PSBTYPE="U":"UD-",PSBTYPE="V":"IV-",1:"**")
        ..S Y=$P(PSBSTAT,U,2)
        ..Q:Y="C"&('$P(PSBRPT(.2),U,1))
        ..Q:Y="P"&('$P(PSBRPT(.2),U,2))
        ..Q:Y="OC"&('$P(PSBRPT(.2),U,3))
        ..Q:Y="O"&('$P(PSBRPT(.2),U,4))
        ..S PSBSCHT=Y
        ..S:PSBSCHT="" PSBSCHT="*"
        ..S PSBMED=$P(^TMP("PSJ",$J,PSBINDX,3),U,2)
        ..S PSBORD=$P(^TMP("PSJ",$J,PSBINDX,0),U,3)
        ..S ^TMP("PSB",$J,"B",PSBTYPE,PSBSCHT,PSBMED,PSBORD)=""
        .I '$D(^TMP("PSB",$J,"B")) W !!?10,"** NO SPECIFIED MEDICATIONS TO PRINT **",!,$$BLANKS(),$$FTR^PSBODL1() Q
        .S PSBGBL=$NAME(^TMP("PSB",$J,"B")),PSBWFLAG=0
        .F  S PSBGBL=$Q(@PSBGBL) Q:PSBGBL=""  Q:($QS(PSBGBL,1)'="PSB")!($QS(PSBGBL,2)'=$J)!($QS(PSBGBL,3)'="B")  D
        ..K PSBORD,PSBFUTRO
        ..S PSBTYPE=$QS(PSBGBL,4)
        ..S PSBSCHT=$QS(PSBGBL,5)
        ..S PSBMED=$QS(PSBGBL,6)
        ..S PSBORD=$QS(PSBGBL,7)
        ..D CLEAN^PSBVT
        ..D PSJ1^PSBVT(DFN,PSBORD)
        ..D NOW^%DTC S PSBNOW=%
        ..Q:PSBOSP<PSBOSTRT
        ..Q:(PSBOSP<PSBOSTRT)&(PSBSCHT'="O")
        ..Q:(PSBOSP'>PSBNOW)
        ..S (PSBYES,PSBODD,PSBDAYB,PSBSCBR)=0
        ..S:$$PSBDCHK1^PSBVT1(PSBSCH) PSBYES=1,PSBDAYB=1
        ..F I=1:1 Q:$P(PSBSCH,"-",I)=""  I $P(PSBSCH,"-",I)?2N!($P(PSBSCH,"-",I)?4N) S PSBYES=1,PSBSCBR=1
        ..I PSBYES,PSBADST="",PSBSCHT'="O",PSBSCHT'="OC",PSBSCHT'="P" D  Q
        ...D ERROR^PSBMLU(PSBONX,PSBOITX,DFN,"Admin times required",PSBSCH)
        ..I PSBSCHT="OC" S PSBYES=1
        ..I PSBSCHT="P" S PSBYES=1
        ..I "PCS"'[PSBIVT S PSBYES=1
        ..I PSBIVT["S",PSBISYR'=1 S PSBYES=1
        ..I PSBIVT["C",PSBCHEMT'="P",PSBISYR'=1 S PSBYES=1
        ..I PSBIVT["C",PSBCHEMT="A" S PSBYES=1
        ..I PSBFREQ="O" S PSBFREQ=1440
        ..I PSBFREQ="D" S PSBFREQ=""
        ..I PSBSCHT="P" S PSBFREQ=1440
        ..I PSBSCHT="O" S PSBFREQ=1440
        ..I 'PSBYES,PSBFREQ<1 D ERROR^PSBMLU(PSBONX,PSBOITX,DFN,"Invalid frequency received from order",PSBSCH) Q
        ..S PSBVALB=$$IVPTAB^PSBVDLU3(PSBOTYP,PSBIVT,PSBISYR,PSBCHEMT,PSBIVPSH)
        ..I 'PSBDAYB,'PSBSCBR,PSBSCHT="C",PSBVALB="1",PSBADST'="",PSBFREQ<1 D ERROR^PSBMLU(PSBONX,PSBOITX,DFN,"Invalid frequency received from order",PSBSCH) Q
        ..I +PSBFREQ>0 I (PSBFREQ#1440'=0),(1440#PSBFREQ'=0) S PSBODD=1
        ..I PSBODD,PSBADST'="" D ERROR^PSBMLU(PSBONX,PSBOITX,DFN,"Administration Times on ODD SCHEDULE",PSBSCH) Q
        ..I PSBADST'="" D
        ...F PSBY=1:1:$L(PSBADST,"-")  D
        ....D:($P(PSBADST,"-",PSBY)'?2N)&($P(PSBADST,"-",PSBY)'?4N)
        .....D ERROR^PSBMLU(PSBONX,PSBOITX,DFN,"Invalid Admin times",PSBSCH)
        ..I PSBSCHT="C",PSBOTYP="U" Q:'$$OKAY^PSBVDLU1(PSBOST,PSBODATE,PSBSCH,PSBONX,PSBOITX,PSBFREQ,)
        ..I PSBSCHT="C",$$IVPTAB^PSBVDLU3(PSBOTYP,PSBIVT,PSBISYR,PSBCHEMT,PSBIVPSH),'$$OKAY^PSBVDLU1(PSBOST,PSBODATE,PSBSCH,PSBONX,PSBOITX,PSBFREQ) Q
        ..I PSBSCHT="O" D  Q:PSBGVN
        ...S (PSBGVN,X,Y)=""
        ...F  S X=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X),-1) Q:'X  D
        ....F  S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X,Y),-1) Q:'Y  D
        .....I $P(^PSB(53.79,Y,.1),U)=PSBONX,$P(^PSB(53.79,Y,0),U,9)="G" S PSBGVN=1,(X,Y)=0
        ..S PSBRMN=1
        ..I PSBSCHT="O" D
        ...Q:(PSBOST'=PSBOSP)
        ...Q:(PSBOSP<PSBOSTRT)
        ...Q:((%'>PSBOST)!(%'=PSBOST))
        ...S PSBRMN=0
        ..Q:'PSBRMN
        ..I PSBOST>$$FMADD^XLFDT(PSBNOW,"","",+($$GET^XPAR("DIV","PSB ADMIN BEFORE"))) S ^TMP("PSBO",$J,DFN,PSBORD,PSBTYPE)="" Q
        ..I PSBSCHT="OC" D  Q:PSBGVN&('$$GET^XPAR("DIV","PSB ADMIN MULTIPLE ONCALL"))
        ...S (PSBGVN,X,Y)=""
        ...F  S X=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X),-1) Q:'X  D
        ....F  S Y=$O(^PSB(53.79,"AOIP",DFN,PSBOIT,X,Y),-1) Q:'Y  D
        .....I $P(^PSB(53.79,Y,.1),U)=PSBONX,$P(^PSB(53.79,Y,0),U,9)="G" S PSBGVN=1,(X,Y)=0
        ..S PSBLGDT="",X=""
        ..F  S X=$O(^PSB(53.79,"AOIP",DFN,+PSBOIT,X),-1) Q:'X  D  Q:PSBLGDT
        ...S PSBIEN=""
        ...F  S PSBIEN=$O(^PSB(53.79,"AOIP",DFN,+PSBOIT,X,PSBIEN),-1) Q:PSBIEN=""  D  Q:PSBLGDT
        ....S:$P($G(^PSB(53.79,PSBIEN,0)),U,9)="G" PSBLGDT=X
        ..S PSBADMIN="" K ^TMP("PSB",$J,"GETADMIN")
        ..I PSBSCHT="C" D  Q:PSBADMIN=""
        ...S PSBX=PSBADST,PSBFLAG=1
        ...D:PSBX=""
        ....I PSBIVT="C",PSBCHEMT="A" S PSBX="0000",PSBFLAG=0
        ....I PSBIVT="C",PSBISYR=0 S PSBX="0000",PSBFLAG=0
        ....I PSBIVT="S",PSBISYR'=1 S PSBX="0000",PSBFLAG=0
        ....I "HA"[PSBIVT S:PSBIVT]"" PSBX="0000",PSBFLAG=0
        ...I ((PSBIVT="S")!(PSBIVT="C")),(PSBISYR=1) S:+($G(PSBX))=0 PSBX=""
        ...I (PSBIVT="C"),(PSBCHEMT="P") S:+($G(PSBX))=0 PSBX=""
        ...I PSBOTYP="U",PSBX="0000" S PSBX=""
        ...I PSBIVT="P" S:+($G(PSBX))=0 PSBX=""
        ...I PSBX="" S:($G(PSBFREQ)>29)!(PSBFREQ="D") PSBX=$$GETADMIN^PSBVDLU1(DFN,PSBONX,PSBOST,PSBFREQ,PSBODATE)
        ...E  S ^TMP("PSB",$J,"GETADMIN",0)=PSBX
        ...D:PSBX'=""
        ....F PSBXX=0:1 Q:'$D(^TMP("PSB",$J,"GETADMIN",PSBXX))  S PSBX=$G(^TMP("PSB",$J,"GETADMIN",PSBXX)) D
        .....F PSBY=1:1:$L(PSBX,"-")  D
        ......S PSBAT=+(PSBODATE_"."_$P(PSBX,"-",PSBY))
        ......I PSBFLAG Q:PSBAT<PSBOSTRT!(PSBAT>PSBOSTOP)
        ......D VAL^PSBMLVAL(.PSBZ,DFN,PSBON,PSBOTYP,PSBAT)
        ......I (PSBZ(0)<0)&(PSBCNT=1) S ^TMP("PSBO",$J,DFN,PSBORD,PSBTYPE,PSBAT)="" Q
        ......I (PSBAT'["."),($G(PSBORD)["V") I (PSBOST<PSBOSTOP),(PSBOST'<PSBOSTRT) S ^TMP("PSBO",$J,DFN,PSBORD,PSBTYPE,PSBAT)="" Q
        ......Q:+PSBZ(0)<0
        ......I $G(PSBOST)'>$G(PSBAT) D
        .......Q:($G(PSBOSP)'>$G(PSBAT))
        .......S PSBADMIN=PSBADMIN_$S(PSBADMIN]"":"-",1:"")_$P(PSBX,"-",PSBY)
        ......E  I ($P($G(PSBOST),".")'>$P($G(PSBAT),"."))&($P($G(PSBAT),".",2)="") S PSBADMIN=PSBADMIN_$S(PSBADMIN]"":"-",1:"")_$P(PSBX,"-",PSBY)
        ...I +$G(PSBFREQ)>0,$G(PSBFREQ)<30,PSBADMIN'="0000" S PSBADMIN="Due every "_$G(PSBFREQ)_" minutes."
        ..I $Y>(IOSL-(12+($L(PSBADMIN)/27))) W !?(IOM-36\2),"(Medications Continued on Next Page)",$$FTR^PSBODL1(),$$HDR()
        ..I PSBSM S PSBSM=$S(PSBSMX:"H",1:"")_"SM"
        ..E  S PSBSM=""
        ..W !,$J(PSBSM,3),?6,PSBTYPE,$E(PSBSCHT,1,4),?12 S PSBWFLAG=1
        ..S X="",Y=0
        ..D WRAPPUP^PSBODL1
        .I '$G(PSBWFLAG) W !!,?10,"** NO SPECIFIED MEDICATIONS TO PRINT **"
        .W $$BLANKS(),$$FTR^PSBODL1()
        .S PSBORD=$O(^TMP("PSBO",$J,DFN,""),-1)
        .I +$G(PSBORD)>0,$P(PSBRPT(.4),U,1),$D(^TMP("PSBO",$J,DFN,PSBORD)) D EN^PSBODL1
        Q
HDR()   ;
        D PT^PSBOHDR(DFN,.PSBHDR)
        W !,"Self",?85,"Last",?100,"Start",?110,"Stop",?120,"Verifying"
        W !,"Med",?6,"Sched",?14,"Medication",?50,"Dose",?78,"Route",?85,"Given",?100,"Date",?110,"Date",?120,"Rph/Rn"
        W !,?100,"@Time",?110,"@Time"
        W !,$TR($J("",IOM)," ","-")
        Q ""
BLANKS()        ;
        Q:'$P(PSBRPT(.2),U,5) ""
        W !
        D:$Y>(IOSL-26)
        .W ?(IOM-42\2),"(Changes/Addendums to Orders on Next Page)"
        .W $$FTR^PSBODL1(),$$HDR() ; New page - no room for blanks
        I IOSL<100 F  Q:$Y>(IOSL-26)  W !
        W ?(IOM-28\2),"Changes/Addendums to orders"
        F X=1:1:4 D
        .W !,$TR($J("",IOM)," ","-")
        .W !!?3,"CON ___ PRN ___"
        .W ?20,"Drug: ",$TR($J("",22)," ","_")
        .W ?50,"Give: ",$TR($J("",42)," ","_")
        .W ?100,"Start: _________ Stop: _________"
        .W !?20,"Spec"
        .W !?3,"OT  ___ OC  ___"
        .W ?20,"Inst: ",$TR($J("",72)," ","_")
        .W ?100,"Initials: ______ Date: _________"
        W !,$TR($J("",IOM)," ","-")
        Q ""
