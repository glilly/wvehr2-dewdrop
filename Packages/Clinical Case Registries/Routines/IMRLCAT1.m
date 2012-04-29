IMRLCAT1 ;HCIOFO/FT/FAI-DISTRIBUTION OF PATIENTS BY CAT ;07/17/00  16:08
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
PRNT ; Print Patients By Category
 D NOW^%DTC S IMRDTE=%,(IMRPG,IMRREC,IMRUT)=0
 S Y=IMRDTE D DD^%DT S IMRDTE=Y
 D HEDR K IMRX
 F IMRTY="A","S","Y","M","R","RI","E","P","Z" S IMRX(IMRTY)=0 S A="" F J=0:0 S A=$O(^TMP($J,IMRTY,A)) Q:A=""  S IMRX(IMRTY)=IMRX(IMRTY)+1
 F IMRTY="A","S","Y","M","R","RI","E","P","Z" Q:(IMRUT)  D:($Y+4+IMRX(IMRTY))>IOSL HDR Q:IMRUT  W !! S A="" F J=0:0 S A=$O(^TMP($J,IMRTY,A)) Q:A=""!(IMRUT)  D PR1
 Q:IMRUT
 I $D(IMRTEST),IMRTEST D LIST
 Q
PR1 ;
 W !,$S(IMRTY="Y":$J(A,3)_" years",1:A) S IMRNODE=$G(^TMP($J,IMRTY,A)),Z=0 F I=1:1:5 S Y=$S(I=5:Z,1:+$P(IMRNODE,U,I)) W ?(34+(I-1*10)),$J(Y,4) S Z=Z+Y S:'IMRREC IMRREC=1
 Q
HDR ; Check End Of Page
 Q:'IMRREC
 S IMRUT=0
 Q:$D(IO("S"))  ;slaved device
 I ($E(IOST,1,2)="C-"&IMRPG) W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRUT=1 Q
HEDR ; Header of Report
 S X="Local ICR Demographics by Category"
 W:$Y>0 @IOF S IMRPG=IMRPG+1
 W !,IMRDTE,?72,"Page ",IMRPG,! W !?(50-$L(X))\2+30,X,!,?$S($L(IMRHED)'>50:(50-$L(IMRHED))\2+30,1:79-$L(IMRHED)),IMRHED,!!?33,"HIV+",?42,"HIV+TC",?53,"AIDS-3",?64,"AIDS",?73,"TOTAL",!
 Q
PERCHK ; Check Patient Lab
 S IMRCHK=0
 Q:$G(IMRHNBEG)=""  Q:$G(IMRHNEND)=""
 S DFN=IMRDFN,VASD("F")=IMRHNBEG,VASD("T")=IMRHNEND D SDA^VADPT ;appt date/time
 I $O(^UTILITY("VASD",$J,0))>0 S IMRCHK=1,IMRSCH=1
 ; array piece 1 - date/time of appointment
 ;             2 - clinic
 ;             3 - status
 ;             4 - appointment type
 K DFN,VASD,^UTILITY("VASD",$J)
 F IMRPTF=0:0 S IMRPTF=$O(^DGPT("B",IMRDFN,IMRPTF)) Q:IMRPTF'>0  I $D(^DGPT(IMRPTF,0)) D PTF^IMRUTL D
 . S IMRDD=+IMRDD,IMRAD=IMRAD\1 S:IMRDD IMRDD=IMRDD\1
 . I (IMRDD=0&(IMRAD'>IMRHNEND))!(IMRAD<(IMRHNEND+1)&(IMRDD'<IMRHNBEG)) D  I $D(IMRINP) S IMRCHK=1 Q
 . . I IMRSUF'="",'(IMRSUF="9AA"!(IMRSUF="A0")!(IMRSUF="9AB")!(IMRSUF="9BB")!(IMRSUF="A4")!(IMRSUF="A5")) Q
 . . I IMREC>1 Q
 . . S IMRINP=1
 . . Q
 . Q
 I $D(^DPT(IMRDFN,"LR")),^("LR")>0 S IMRLR=^("LR") F IMRJ=9999999-IMRHNEND-1:0 S IMRJ=$O(^LR(IMRLR,"CH",IMRJ)) Q:IMRJ'>0!(IMRJ>(9999999-IMRHNBEG))  S IMRLAB=1,IMRCHK=1 Q
 F IMRJ=0:0 Q:$D(IMRRX)  S IMRJ=$O(^PS(55,IMRDFN,"P","A",IMRJ)) Q:IMRJ'>0  F IMRRXN=0:0 S IMRRXN=$O(^PS(55,IMRDFN,"P","A",IMRJ,IMRRXN)) Q:IMRRXN'>0  I $D(^PSRX(IMRRXN,0)) D  I $D(IMRRX) S IMRCHK=1 Q
 . N X1 S X1=$G(^PSRX(IMRRXN,2)) S X1=$P(X1,U,2) D  ;X1=fill date-file 52
 . . Q:X1'>0  Q:X1<IMRHNBEG  Q:X1'<(IMRHNEND+1)
 . . S IMRRX=1 Q
 . F X1=0:0 Q:$D(IMRRX)  S X1=$O(^PSRX(IMRRXN,1,X1)) Q:X1'>0  D
 . . Q:^PSRX(IMRRXN,1,X1,0)<IMRHNBEG  Q:^(0)'<(IMRHNEND+1)  ;check refill date
 . . S IMRRX=1
 . . Q
 . Q
 Q
LIST ;list patients missing data values
 I '$D(^TMP($J,"ZZTEST")) Q
 N I,J,LINES,IMRDONE
 D PRTC Q:$D(IMRDONE)
 D LISTHDR
 S LINES=1
 S I="" F  S I=$O(^TMP($J,"ZZTEST","FIN",I)) Q:I=""  D  Q:$D(IMRDONE)
 . S J="" F  S J=$O(^TMP($J,"ZZTEST","FIN",I,J)) Q:J=""  D  Q:$D(IMRDONE)
 . . I ($Y+3>IOSL) D PRTC Q:$D(IMRDONE)  D LISTHDR
 . . S IMRNODE=^TMP($J,"ZZTEST","FIN",I,J)
 . . W !?1,I,?33,J,?49,$P(IMRNODE,U,1),?54,$P(IMRNODE,U,2),?59,$P(IMRNODE,U,3),?64,$P(IMRNODE,U,4),?69,$P(IMRNODE,U,5),?74,$P(IMRNODE,U,6)
 . . S LINES=LINES+1
 . . I LINES>5 W ! S LINES=1
 . . Q
 . Q
 D PRTC
 Q
LISTHDR ;header for list of missing data values
 W @IOF,!,IMRHENGD,?72,"Page ",IMRPG+1,!
 W !,?49,"SEX",?54,"DOB",?59,"RISK",?64,"RACE",?69,"ELIG",?74,"POS"
 W !,?49,"---",?54,"---",?59,"----",?64,"----",?69,"----",?74,"---"
 Q
PRTC ;press return to continue prompt
 Q:$E(IOST)'="C"!($D(IO("S")))
 K DIR W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRDONE=1
 Q
CHKCAT ; Check Entries For No Category Value
 ;I $D(IMRMCAT) Q
 S IMRMCAT=""
 ;I '$D(^XUSEC("IMRMGR",DUZ))&'$D(^XUSEC("IMRA",DUZ)) Q
 U IO
 W !!,"Checking for entries in the ICR file without CATEGORY data.",!
 K ^TMP($J,"CHKCAT")
 S IMRCNT=0
 F IMRI=0:0 S IMRI=$O(^IMR(158,IMRI)) Q:IMRI'>0  I $P($G(^(IMRI,0)),U,42)="" S IMRCNT=IMRCNT+1,^TMP($J,"CHKCAT",IMRI)=""
 I IMRCNT=0 W "    None found.",!
 I IMRCNT>0 D
 . W !!,$C(7),"There "_$S(IMRCNT>1:"are ",1:"is ")_IMRCNT_$S(IMRCNT>1:" entries",1:" entry")_" in the IMMUNOLOGY CASE REGISTRY file with",!,"NO CATEGORY indicated --",!!
 . K DIR S DIR(0)="Y",DIR("A")="DO YOU WANT TO SEE THE LIST",DIR("B")="YES" D ^DIR K DIR I Y'>0 Q
 . S IMRMC=Y
 . D IMRDEV^IMREDIT
 . Q:POP
 . I $D(IO("Q")) D  Q
 . . S ZTIO=ION,ZTDTH="NOW",ZTRTN="DQ^IMRLCAT1",ZTREQ="@",ZTSAVE("ZTREQ")="",ZTSAVE("^TMP($J,""CHKCAT"",")="",ZTDESC="Missing Categories" D ^%ZTLOAD K ZTSAVE,ZTRTN,ZTIO,ZTDTH,ZTDESC,ZTSAVE
 . . Q
 . D DQ
 . Q:$D(IO("S"))  ;slaved output
 . S DIR(0)="E" D ^DIR K DIR
 . Q
 K ^TMP($J,"CHKCAT")
 K IMRI,IMRCNT,X,Y D ^%ZISC
 Q
DQ ;
 U IO
 F IMRI=0:0 S IMRI=$O(^TMP($J,"CHKCAT",IMRI)) Q:IMRI'>0  D
 . S X=$P(^IMR(158,IMRI,0),U) D XOR^IMRXOR S DFN=X
 . D DEM^VADPT
 . W !,VADM(1),?32,$P(VADM(2),U,2)
 . K VADM,VAIDXD Q
 D ^%ZISC
 Q
