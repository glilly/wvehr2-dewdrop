PPPPRT8 ;ALB/DMB - FFX PRINT ROUTINES ; 5/14/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
PRTFAC(PATDFN) ; Entry point for pharmacy
 ;
 N TMP,VISITS
 S VISITS=$$GETVIS^PPPGET7(PATDFN,"^TMP(""PPP"",$J,""VIS"")")
 I $D(^TMP("PPP",$J,"VIS")) S TMP=$$POF(PATDFN,"^TMP(""PPP"",$J,""VIS"")")
 K ^TMP("PPP",$J,"VIS")
 Q
 ;
POF(PATDFN,TARRY) ; Print Other Facilities
 ;
 ; This function takes the data contained in TARRY and writes
 ; it to standard out.
 ;
 N DIC,DR,DA,DIQ,DUOUT,DTOUT,U,PARMERR,PATNAME,PATDOB,PATSSN,PPPTMP
 N STANAME,LINEDATA,PDXDATA
 ;
 S PARMERR=-9001
 S U="^"
 ;
 I $G(PATDFN)<1 Q PARMERR
 I '$D(@TARRY) Q PARMERR
 ;
 ; Get the local name, SSN and DOB
 ;
 S DIC="^DPT(",DA=PATDFN,DR=".01;.03;.09",DIQ="PPPTMP" D EN^DIQ1
 S PATNAME=PPPTMP(2,PATDFN,.01)
 S PATDOB=$$E2IDT^PPPCNV1(PPPTMP(2,PATDFN,.03))
 S PATSSN=PPPTMP(2,PATDFN,.09)
 K PPPTMP,DIC,DR,DA,DTOUT,DUOUT
 ;
 ; Write out the header
 ;
 W !,"Visits to other facilities are on file for ==>"
 W !,?5,PATNAME,"  (",$E(PATSSN,1,3),"-",$E(PATSSN,4,5),"-",$E(PATSSN,6,9),")    Born ",$$I2EDT^PPPCNV1(PATDOB)
 W !!,"Station",?21,"Last PDX",?33,"PDX Status",?60,"Pharmacy Data"
 W ! F I=1:1:IOM W "="
 ;
 ; Now order through the array and print the info.
 ;
 S STANAME=""
 F  S STANAME=$O(@TARRY@(STANAME)) Q:STANAME=""  D
 .S LINEDATA=@TARRY@(STANAME,2)
 .W !,$E($P(LINEDATA,U),1,18)
 .W ?21,$S(+$P(LINEDATA,U,2)'<0:$P(LINEDATA,U,2),1:"UNKNOWN")
 .W ?33,$P(LINEDATA,U,3),?60,$P(LINEDATA,U,4)
 .I @TARRY@(STANAME,0)>0 D
 ..S PDXDATA=@TARRY@(STANAME,1)
 ..I PATNAME'=$P(PDXDATA,U,1) D
 ...W !,"  Warning... PDX Name (",$P(PDXDATA,U,1),") Does Not Equal Local Name."
 ..I PATDOB'=$P(PDXDATA,U,2) D
 ...W !,"  Warning... PDX DOB (",$$I2EDT^PPPCNV1($P(PDXDATA,U,2)),") Does Not Equal Local DOB."
 Q 0
