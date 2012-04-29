IMRPNEUM ;;HCIOFO/FT/SPS-Pneumococcal Immunization Report ;05/12/00 16:24
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**5**;Feb 09, 1998
 ; check security of user
 I '$D(^XUSEC("IMRA",DUZ)) S IMRLOC="IMRPNEUM" D ACESSERR^IMRERR,H^XUS K IMRLOC
 K DIR
 S DIR("A")="Select the report you want"
 S DIR(0)="S^1:PNEUMO-VAC FOR A DATE RANGE;2:NO PNEUMO-VAC IN 5 YEARS"
 S DIR("?",1)="The 'PNEUMO-VAC FOR A DATE RANGE' report will list all ICR patients who had"
 S DIR("?",2)="a pneumococcal vaccination within the date range selected by the user."
 S DIR("?",3)=" "
 S DIR("?",4)="The 'NO PNEUMO-VAC IN 5 YEARS' report will list living ICR patients who have"
 S DIR("?",5)="no record of a pneumococcal vaccination in the last 5 years."
 S DIR("?",6)=" "
 S DIR("?")="Please select the pneumococcal vaccination output you want."
 D ^DIR K DIR
 I $D(DIRUT) D KILL Q
 I Y=2 D ^IMRPNEU1 Q  ;no pneumo-vac in 5 years report
 ; select start/stop dates
ASK D ^IMRDATE Q:$G(IMRHNBEG)=""
 S IMRSD=IMRHNBEG,IMRED=IMRHNEND
 ; select device
 D IMRDEV^IMREDIT I POP D KILL Q
 I $D(IO("Q")) D  D KILL Q
 .S ZTRTN="START^IMRPNEUM",ZTDESC="Immunology Pneumococcal Report",ZTIO=ION_";"_IOM_";"_IOSL
 .S ZTSAVE("IMRED")="",ZTSAVE("IMRSD")=""
 .D ^%ZTLOAD
 .K ZTRTN,ZTDESC,ZTSK,ZTIO,ZTSAVE
 .Q
START ; start report
 U IO K ^TMP($J)
 S (IMRCNT,IMRDFN,IMRPG,IMRUT)=0,IMRLINE=$$REPEAT^XLFSTR("-",79)
 D GETNOW^IMRACESS ;get the current date/time
 D HDR
 S X="PXRHS03" X ^%ZOSF("TEST")
 I '$T D NODATA,EOP,KILL Q
 F  S IMRDFN=$O(^IMR(158,IMRDFN)) Q:'IMRDFN  S X=+^IMR(158,IMRDFN,0) D ^IMRXOR I $D(^DPT(X,0)) D A1
 I '$D(^TMP($J)) D NODATA,EOP,KILL Q
 S IMRNAME=""
 F  S IMRNAME=$O(^TMP($J,IMRNAME)) Q:IMRNAME=""!(IMRUT)  S IMRDFN=0 F  S IMRDFN=$O(^TMP($J,IMRNAME,IMRDFN)) Q:'IMRDFN!(IMRUT)  S IMRVDATE=0  F  S IMRVDATE=$O(^TMP($J,IMRNAME,IMRDFN,IMRVDATE)) Q:'IMRVDATE!(IMRUT)  D
 .I ($Y+4)>IOSL D EOP Q:IMRUT  D HDR
 .S IMRSSN=$P(^TMP($J,IMRNAME,IMRDFN,IMRVDATE),U,1)
 .W !,IMRNAME,?32,IMRSSN,?50,$$FMTE^XLFDT(IMRVDATE,"1D")
 .Q
 W !!,"Total: ",IMRCNT
 D:'IMRUT EOP
 S:$D(ZTQUEUED) ZTREQ="@"
KILL ; kill variables
 K ^TMP($J),^TMP("PXI",$J),DIR,DIROUT,DIRUT,DTOUT,DUOUT,I
 K IMR1,IMR2,IMR3,IMR5YR,IMRCNT,IMRDFN,IMRDTE,IMRED,IMRFLG,IMRLINE,IMRLOOP,IMRNAME,IMRNODE,IMRPG,IMRSD,IMRSSN,IMRSTN,IMRUT,IMRVDATE,IMRVISIT
 K X,Y
 D ^%ZISC
 Q
A1 ; get data from PCE utility
 S IMRNODE=$G(^DPT(+X,0))
 S IMRNAME=$P(IMRNODE,U,1),IMRSSN=$P(IMRNODE,U,9)
 K ^TMP("PXI",$J)
 D IMMUN^PXRHS03(+X)
 Q:'$D(^TMP("PXI",$J))
 S IMRLOOP=0
 F  S IMRLOOP=$O(^TMP("PXI",$J,"PNEUMO-VAC",IMRLOOP)) Q:'IMRLOOP  S IMRLOOP(1)=0 F  S IMRLOOP(1)=$O(^TMP("PXI",$J,"PNEUMO-VAC",IMRLOOP,IMRLOOP(1))) Q:'IMRLOOP(1)  D
 .S IMRVISIT=$P($G(^TMP("PXI",$J,"PNEUMO-VAC",IMRLOOP,IMRLOOP(1),0)),U,3)
 .Q:'IMRVISIT
 .Q:IMRVISIT<IMRSD
 .Q:IMRVISIT>IMRED
 .S ^TMP($J,IMRNAME,IMRDFN,IMRVISIT)=IMRSSN,IMRCNT=IMRCNT+1
 .Q
 Q
HDR ; report header
 W:$Y>0 @IOF
 S IMRPG=IMRPG+1
 W !?25,"PNEUMOCOCCAL VACCINATION REPORT",?70,"Page ",IMRPG
 W !?25,"From "_$$FMTE^XLFDT(IMRSD,"1D")_" to "_$$FMTE^XLFDT(IMRED,"1D")
 W !?25,"Run Date: ",IMRDTE
 W !,"NAME",?32,"SSN",?50,"DATE"
 W !,IMRLINE
 Q
EOP ; end of page question
 Q:$D(IO("S"))
 I IOST["C-" K DIR W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRUT=1
 Q
NODATA ; no data message
 W !,"There was no data for this report."
 Q
