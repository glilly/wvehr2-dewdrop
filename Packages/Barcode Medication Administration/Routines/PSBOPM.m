PSBOPM  ;BIRMINGHAM/BSR-BCMA OIT HISTORY ; 5/2/07 9:52am
        ;;3.0;BAR CODE MED ADMIN;**3,9,13,17,40**;Mar 2004;Build 9
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ; Reference/IA
        ; File 50.7/2880
        ; File 52.6/436
        ; File 52.7/437
        ; File 200/10060
        ; EN^PSJBCMA1/2829
        ;
EN      ;
        N PSBHDR,DFN
        S PSBGBL="^TMP(""PSBO"",$J,""B"")"
        F  S PSBGBL=$Q(@PSBGBL) Q:PSBGBL=""  Q:$QS(PSBGBL,2)'=$J  Q:$QS(PSBGBL,1)'["PSBO"  D
        .S DFN=$QS(PSBGBL,5)
        I '$G(DFN) W !,("Error: No Patient IEN")  Q
        S PSBSTRT=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7)
        S PSBSTOP=$P(PSBRPT(.1),U,8)+$P(PSBRPT(.1),U,9)
        S PSBCOM=$P(PSBRPT(.2),"^",8)   ;COMMENT FLAG 1 MEANS YES
        I PSBSTRT="0" D
        .D NOW^%DTC S PSBSTOP=%
        .S X1=((PSBSTOP)\1) S X2=-$$GET^XPAR("ALL","PSB MED HIST DAYS BACK")
        .S:X2'<0 X2=-30 D C^%DTC  S PSBSTRT=X
        .S PSBCOM=$$GET^XPAR("ALL","PSB RPT INCL COMMENTS")
        D OUT(DFN,PSBSTRT,PSBSTOP,PSBORDNM)
        Q
        ;
OUT(DFN,PSBSTRT,PSBSTOP,PSBORDNM)              ;
        D CLEANALL ;CLEAN UP VARIABLES AND TMP ARRAY
        ;
        ;IF PSBORDNM DOESN'T CONTAIN A "U" OR A "V", SKIP THE ORDER LOOKUP
        S PSBOR=1
        I PSBORDNM'["U",PSBORDNM'["V" D
        .S:'$$GETORD^PSBOPM1(.PSBORDNM) PSBOR=0
        .I 'PSBOR&(PSBORDNM]"") S TMP("PSBOIS",$J,PSBORDNM)=""
        I PSBOR D
        .D GETORDN
        .D GETOIS
        D GETADSO ;  GET ALL ADDITIVES AND SOLUTIONS
        D FINDIENS^PSBOPM1 ; FIND EVERY MED LOG ENTRIES THAT SHOULD BE ON THE RPT
        D PREOUT ;   WRITE DATA TO GLOBAL
        D WRITEOT ;
        D CLEANSUM ; CLEAN UP AND LEAVE LIST OF IENS FOR THE REPORT.
        Q
        ;
GETORDN ;
        K ^TMP("PSJ1",$J)
        D EN^PSJBCMA1(DFN,PSBORDNM,1)
        Q
        ;
GETOIS   ; LOAD PSBOIS(#) WITH ALL OF THE ORDERABLE ITEMS
        I PSBORDNM["U" D
        .;GET UNIT DOSE ORDERS
        .I $D(^TMP("PSJ1",$J,2)) D
        ..S PSBOI=$P(^TMP("PSJ1",$J,2),"^")
        ..S PSBOI=$S(PSBOI["U":$TR(PSBOI,"U",""),PSBOI["V":$TR(PSBOI,"V",""),1:PSBOI)
        ..S TMP("PSBOIS",$J,PSBOI)=""
        ;
        ;IV ORDERS NEED TO USE THE ADDITIVE AND SOLUTION NUMBER TO BACK
        ;TRACK TO THE OI ASSOCIATED WITH IT
        I PSBORDNM["V" D
        .;GET ADDITIVES OFF THE ORDER
        .I $G(^TMP("PSJ1",$J,850,0))  D
        ..S XXX="" F  S XXX=$O(^TMP("PSJ1",$J,850,XXX)) Q:XXX=""  D
        ...S XXY="" F  S XXY=$O(^TMP("PSJ1",$J,850,XXX,XXY)) Q:XXY=""  D
        ....S PSBADD=$P(^TMP("PSJ1",$J,850,XXX,XXY),"^")
        ....;CONVERT ADDITIVE TO ORDERABLE ITEM AND ADD TO LIST
        ....S TMP("PSBOIS",$J,$$OFROMA(PSBADD))=""
        .;   GET SOLUTIONS OFF THE ORDER
        .I $G(^TMP("PSJ1",$J,950,0))  D
        ..S XXX="" F  S XXX=$O(^TMP("PSJ1",$J,950,XXX)) Q:XXX=""  D
        ...S XXY="" F  S XXY=$O(^TMP("PSJ1",$J,950,XXX,XXY)) Q:XXY=""  D
        ....S PSBSOL=$P(^TMP("PSJ1",$J,950,XXX,XXY),"^")
        ....;
        ....;CONVERT SOLUTIOIN TO ORDERABLE ITEM AND ADD TO LIST
        ....S TMP("PSBOIS",$J,$$OFROMS(PSBSOL))=""
        Q
        ;
OFROMA(PSBADD)  ;GET ORDERABLE ITEM FROM AN ADDITIVE
        Q $$GET1^DIQ(52.6,PSBADD_",",15,"I")
        ;
OFROMS(PSBSOL)  ; GET ORDERABLE ITEM FROM A SOLUTION
        Q $$GET1^DIQ(52.7,PSBSOL_",",9,"I")
        ;
GETADSO ; GET ALL ADDITIVES FOR ALL ORDERABLE ITEMS
        K PSBAOUT,PSBSOUT
        S XA="" F  S XA=$O(TMP("PSBOIS",$J,XA)) Q:XA=""  D
        .D LIST^DIC(52.6,"","@;15I","QPI","","","","AOI","","","PSBAOUT")
        .S XB=0 F  S XB=$O(PSBAOUT("DILIST",XB)) Q:XB=""  D
        ..I $P(PSBAOUT("DILIST",XB,0),"^",2)=XA D
        ...S TMP("PSBADDS",$J,$P(PSBAOUT("DILIST",XB,0),"^",1))=""
        K PSBAOUT
        ; GET ALL SOLUTIONS FOR ALL ORDERABLE ITEMS
        S XA="" F  S XA=$O(TMP("PSBOIS",$J,XA)) Q:XA=""  D
        .D LIST^DIC(52.7,"","@;9I","QPI","","","","AOI","","","PSBSOUT")
        .S XB=0 F  S XB=$O(PSBSOUT("DILIST",XB)) Q:XB=""  D
        ..I $P(PSBSOUT("DILIST",XB,0),"^",2)=XA D
        ...S TMP("PSBSOLS",$J,$P(PSBSOUT("DILIST",XB,0),"^",1))=""
        K PSBSOUT
        Q
        ;
PREOUT  ;
        N TYP
        F TYP="UD","ADD","SOL"  D
        .Q:'$D(TMP("PSBIENS",$J,TYP))
        .K PSBUNK S XDT="" F  S XDT=$O(TMP("PSBIENS",$J,TYP,XDT),-1) Q:XDT=""  D
        ..S I="" F  S I=$O(TMP("PSBIENS",$J,TYP,XDT,I)) Q:I=""  D
        ...I TYP="UD" Q:$D(TMP("PSBIENS",$J,"ADD",XDT,I))  Q:$D(TMP("PSBIENS",$J,"SOL",XDT,I))
        ...S PSBIEN=I
        ...S PSBIENS=PSBIEN_","
        ...D OUTPUT(TYP)
        Q
        ;
OUTPUT(TYP)     ;
        S PSBSPC=$J("",80)
        S W=$E($$GET1^DIQ(53.79,PSBIENS,.02)_PSBSPC,1,20)_" "
        S W=W_$S($P(^PSB(53.79,PSBIEN,0),U,9)="":"?? ",1:$E($P(^PSB(53.79,PSBIEN,0),U,9)_"  ",1,2)_" ")
        S:$P(^PSB(53.79,PSBIEN,0),U,9)="" PSBUNK=1
        S W=W_$E($P($G(^PSB(53.79,PSBIEN,.1)),U,2)_PSBSPC,1,2)_"  "
        S W=W_$E($E($$GET1^DIQ(53.79,PSBIENS,.06),1,18)_PSBSPC,1,21)_" "
        S W=W_$E($$GET1^DIQ(53.79,PSBIENS,"ACTION BY:INITIAL")_PSBSPC,1,10)_" "
        S W=W_$$GET1^DIQ(53.79,PSBIENS,.16)
        D ADD(W,TYP)
        F PSBNODE=.5,.6,.7 D
        .S PSBDD=$S(PSBNODE=.5:53.795,PSBNODE=.6:53.796,1:53.797)
        .F PSBY=0:0 S PSBY=$O(^PSB(53.79,PSBIEN,PSBNODE,PSBY)) Q:'PSBY  D
        ..D WRAPMEDS($$GET1^DIQ(PSBDD,PSBY_","_PSBIENS,.01),$$GET1^DIQ(PSBDD,PSBY_","_PSBIENS,.03),$$GET1^DIQ(PSBDD,PSBY_","_PSBIENS,.04),TYP)
        I PSBCOM=1  D COMNTS   ;GETS COMMENTS
        D ADD("",TYP)
        Q
        ;
COMNTS   ;
        N Z,CNT
        S Z="",CNT=0
        I $D(^PSB(53.79,PSBIEN,.3,0)) D
        .D ADD("",TYP)
        .D ADD($J("",44)_"Comments: "_$$MAKELINE("-",78),TYP)
        .S XT="" F  S XT=$O(^PSB(53.79,PSBIEN,.3,XT)) Q:XT=""  I XT'=0  D
        ..D:CNT=1 ADD("",TYP)
        ..S Y=$P(^PSB(53.79,PSBIEN,.3,XT,0),"^",3) D DD^%DT S XBR=Y
        ..S Z=XBR_"   "_$P(^VA(200,$P(^PSB(53.79,PSBIEN,.3,XT,0),"^",2),0),"^",2)
        ..D WRAP($P(^PSB(53.79,PSBIEN,.3,XT,0),"^",1),Z,PSBIEN)
        ..S CNT=1
        .D ADD($J("",54)_$$MAKELINE("-",78),TYP)
        Q
               ;
WRAP(SIZE,ZP,BRIEN)             ;
        D ADD($J("",55)_ZP,TYP)
        D ADD($J("",55)_$E(SIZE,1,75),TYP)
        I $L(SIZE)>75 D ADD($J("",55)_$E(SIZE,76,150),TYP)
        Q
        ;
HEADA   ;
        W !
        W "Location",?21,"St Sch Administration Date",?50,"By",?61,"Injection Site",?96,"Units",?112,"Units of"
        W !,?55,"Medication & Dosage",?96,"GIVEN",?112,"Administration"
        W !
        W $$MAKELINE("-",132)
        Q
        ;
ADD(XE,TYP)      ;
        S ^TMP("PSB",$J,TYP,$O(^TMP("PSB",$J,TYP,""),-1)+1)=XE
        Q
        ;
WRAPMEDS(MED,UG,UOA,TYP)         ;
        ;MED IS NOT WRAPPED: MAX LENGTH IN PSDRUG/52.6/52.7 IS 40
        ;UG/UOA MAX AT 30/40 AND WILL BE WRAPPED AT 15 EACH
        ;THIS WILL CREATE UPTO 3 LINES
        S MED=$E(MED_$J("",40),1,40)
        N UGWRAP
        S (CNTX,UOA1,UOA16,UOA31)=""
        I +$G(UG)?1"."1.N S UG=0_+UG
        F CNT=1:15:45  D
        .D PARSE(UOA,CNT)
        .S UGWRAP=$E(UG,CNT,(CNT+14))
        .I CNT=1 D ADD($J("",55)_MED_" "_$$PAD(UGWRAP,15)_" "_$$PAD(UOA1,15),TYP)
        .I (CNT>1),($L(UGWRAP)>0!$L(@("UOA"_CNT))>0) D ADD($J("",96)_$$PAD(UGWRAP,15)_" "_$$PAD(@("UOA"_CNT),15),TYP)
        Q
        ;
PAD(X,CNT)      ;
        Q $E(X_$J("",CNT),1,CNT)
WRITEOT ;
        N TPE
        S Y=$P(PSBSTRT,".",1)  D D^DIQ  S PSTRTA=Y
        S Y=$P(PSBSTOP,".",1)  D D^DIQ  S PSTP=Y
        S PSBHDR(1)="MEDICATION HISTORY for "_PSTRTA_"  to  "_PSTP
        I '$D(TMP("PSBIENS",$J)) D ADD("<<<< NO HISTORY FOUND FOR THIS TIME FRAME >>>>","UD")
        S TPE="" F  S TPE=$O(^TMP("PSB",$J,TPE)) Q:TPE=""  D
        .D MEDS(TPE)
        .D PT^PSBOHDR(DFN,.PSBHDR),HEADA
        .S EX="" F  S EX=$O(^TMP("PSB",$J,TPE,EX)) Q:EX=""  D
        ..I $Y>(IOSL-5) D
        ...W $$PTFTR^PSBOHDR()
        ...D PT^PSBOHDR(DFN,.PSBHDR),HEADA
        ..W !,$G(^TMP("PSB",$J,TPE,EX))
        W $$PTFTR^PSBOHDR()
        Q
        ;
FTR()   ;
        I (IOSL<100) F  Q:$Y>(IOSL-10)  W !
        W !,$TR($J("",IOM)," ","=")
        S X="Ward: "_PSBHDR("WARD")_"  Room-Bed: "_PSBHDR("ROOM")
        W !,PSBHDR("NAME"),?(IOM-11\2),PSBHDR("SSN"),?(IOM-$L(X)),X
        Q ""
        ;
MEDS(TYP)       ;
        N MED,XA,XB,DPTR,DRG,FLE,SBSC
        S MED="",XB=3,DRG=""
        S PSBHDR(3)="MEDICATIONS SEARCH LIST:"
        S XA="" F  S XA=$O(TMP("PSBOIS",$J,XA)) Q:XA=""  D
        .S MED=$$GET1^DIQ(50.7,XA,.01)
        .I $L(PSBHDR(XB)_" "_MED)>IOM D
        ..S XB=XB+1,PSBHDR(XB)="                         "_MED
        .E  S PSBHDR(XB)=PSBHDR(XB)_$S($L(PSBHDR(XB))<26:" ",1:"; ")_MED
        S XA=999 F  S XA=$O(PSBHDR(XA),-1) Q:XA=XB  K PSBHDR(XA)
        I TYP'="" D
        .I TYP["UD" S TYP="UNIT DOSE",SBSC="PSBOIS",FLE=50.7
        .I TYP["AD" S TYP="ADDITIVE",SBSC="PSBADDS",FLE=52.6
        .I TYP["SO" S TYP="SOLUTION",SBSC="PSBSOLS",FLE=52.7
        .S DPTR="" F  S DPTR=$O(TMP(SBSC,$J,DPTR)) Q:DPTR=""  I TMP(SBSC,$J,DPTR) D
        ..S DRG=$$GET1^DIQ(FLE,DPTR,.01)
        ..S PSBHDR($O(PSBHDR(999),-1)+1)=$S(TYP="UNIT DOSE":"",1:"SEARCH FOR "_TYP_": "_DRG)
        .K TMP(SBSC,$J)
        Q
        ;
CLEANALL               ; KILL ALL TMP LEVELS USED VARIABLES
        K ^TMP("PSB",$J),^TMP("PSJ1",$J),TMP("PSBOIS",$J),TMP("PSBADDS",$J),TMP("PSBSOLS",$J),TMP("PSBIENS",$J),TMP("ARY",$J),DRG,DPTR,PSBOR,FLE,SBSC,TPE
        Q
        ;
CLEANSUM               ; KILLL ALL BUT THE "PSBIENS" LEVEL
        K ^TMP("PSB",$J),^TMP("PSJ1",$J),TMP("PSBIENS",$J),TMP("PSBOIS",$J),TMP("PSBADDS",$J),TMP("PSBSOLS",$J)
        Q
MAKELINE(X,CNT) ;LINE OF WHAT'S PASSED IN CNT TIMES
        N Y,Z
        S Y=""
        F Z=1:1:CNT S Y=Y_X
        Q Y
        ;
PARSE(X,CNT)    ;Split text for wrapping.
        S CNTX="UOA"_CNT,@CNTX=@CNTX_$E(X,CNT,(CNT+14)),UOAX=""
        F  S:$F(@CNTX,", ",+UOAX)>0 UOAX=$F(@CNTX,", ",+UOAX)  Q:'$F(@CNTX,", ",+UOAX)
        I UOAX<1 F  S:$F(@CNTX," ",+UOAX)>0 UOAX=$F(@CNTX," ",+UOAX)  Q:'$F(@CNTX," ",+UOAX)
        I UOAX>1,(($L(UOA)-(CNT+14))>0) S CNTXX=$E(@CNTX,1,UOAX-1),@("UOA"_(CNT+15))=$E(@CNTX,UOAX,UOAX+14),@CNTX=CNTXX
        Q
        ;
