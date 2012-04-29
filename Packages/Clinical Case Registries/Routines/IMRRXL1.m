IMRRXL1 ;HCIOFO/NCA,FT-Print the Outpatient Pharmacy Utilization ;12/18/97  16:26
 ;;2.1;IMMUNOLOGY CASE REGISTRY;;Feb 09, 1998
RXPRNT ;
 S IMRD="FOR THE PERIOD "_$E(IMRSD,4,5)_"/"_$E(IMRSD,6,7)_"/"_$E(IMRSD,2,3)_" TO "_$E(IMRED,4,5)_"/"_$E(IMRED,6,7)_"/"_$E(IMRED,2,3)
 F IMR0C=0:1:4,"T" Q:IMRUT  S IMRLBL=$S(IMR0C=+IMR0C:$P("NO CATEGORY DEFINED^HIV+^HIV+ (CD4<500)^AIDS-3^AIDS","^",IMR0C+1),1:"TOTAL HIV+ (ALL CATEGORIES) POPULATION"),IMR1C="C"_IMR0C D RXPR1
 Q
RXPR1 ;
 Q:'$D(^TMP($J,IMR1C,"A"))  S IMRX="PHARMACY PRESCRIPTION UTILIZATION DATA" D HEDR
 W !,"Totals:  " S X=^TMP($J,IMR1C,"RX"),Y=^("RX","F") W Y," fills reported during this period for ",X," patients"
 S X=0
 F I=0:0 S I=$O(^TMP($J,IMR1C,"A",I)) Q:I'>0  S J="" F K=0:0 S J=$O(^TMP($J,IMR1C,"A",I,J)) Q:J=""  S X=X+1
 W !?20,"Fills indicated for ",X," different entries in Drug File",!
 F I=0:0 S I=$O(^TMP($J,IMR1C,"RX","N",I)) W:I'>0 ! Q:I'>0!(IMRUT)  D
 .I ($Y+3>IOSL) D EOP Q:IMRUT  D HEDR
 .S X=+^TMP($J,IMR1C,"RX","N",I),Y=$P(^(I),U,2)
 .W !?8,$J(Y,7)," fill",$S(Y'=1:"s",1:" ")," reported for ",$J(X,5)," patient",$S(X>1:"s",1:"")
 .Q
 Q:IMRUT  D EOP Q:IMRUT
 D HEDR,HEDR1 S N=""
 F I=0:0 Q:IMRUT!(N'="")  S I=$O(^TMP($J,IMR1C,"A",I)) Q:+I'=I  S N="" F J=0:0 S N=$O(^TMP($J,IMR1C,"A",I,N)) Q:N=""!(IMRUT)  Q:$P(^(N),U,2)<IMRN1  D
 .I ($Y+3>IOSL) D EOP Q:IMRUT  D HEDR,HEDR1
 .D PRNT1
 .Q
 Q:IMRUT  D EOP Q:IMRUT
 S IMRN1=$S(IMRN2>0:IMRN2,1:-IMRN2),IMRTOT=0,IMRTOTL=0
 D HEDR,HEDR2
 F I=0:0 Q:IMRUT  S I=$O(^TMP($J,IMR1C,"C",I)) Q:+I'=I  S N="" F J=0:0 S N=$O(^TMP($J,IMR1C,"C",I,N)) Q:N=""!(IMRUT)  S C=$P(^(N),U,3) S IMRTOT=IMRTOT+C I C'<IMRN1 D
 .I ($Y+2>IOSL) D EOP Q:IMRUT  D HEDR,HEDR2
 .D PRNT2
 .Q
 Q:IMRUT  D EOP Q:IMRUT
 D:($Y+2>IOSL) HEDR,HEDR2
 W !!?4,"TOTAL FOR LISTED DRUGS",?37,$J(IMRTOTL,11,2)
 I IMRTOTL'=IMRTOT D:($Y+2>IOSL) HEDR,HEDR2 W !!?4,"TOTAL (INCLUDING UNLISTED DRUGS)",?37,$J(IMRTOT,11,2)
 Q:IMRUT  D EOP Q:IMRUT
 D HEDR,HEDR3 S C=1 S Y=$O(^TMP($J,IMR1C,"RX","CST",0)),Y=$O(^(Y,"")),Y=$L($P(Y,"-",2))
 F I=0:0 Q:IMRUT  S I=$O(^TMP($J,IMR1C,"RX","CST",I)) Q:I'>0  D
 .I ($Y+3>IOSL) D EOP Q:IMRUT  D HEDR,HEDR3
 .S X=$O(^TMP($J,IMR1C,"RX","CST",I,"")),X1=^(X)
 .W !,$J(+X,Y),"-",$J($P(X,"-",2),Y),?20,$J(X1,5)," patient",$S(X1>1:"s",1:"")
 .Q
 Q:IMRUT  D EOP Q:IMRUT
NOCOST I $D(^TMP($J,IMR1C,"C",9999999)) D HEDR W !?5,"DRUGS ENCOUNTERED WITH NO UNIT COST DATA IN DRUG FILE",! D HEDR1A S N=""
 I $D(^TMP($J,IMR1C,"C",9999999)) F I=0:0 Q:IMRUT!(N'="")  S I=$O(^TMP($J,IMR1C,"A",I)) Q:+I'=I  S N="" F J=0:0 S N=$O(^TMP($J,IMR1C,"A",I,N)) Q:N=""!(IMRUT)  I $P(^(N),U,4)'>0 D PRNT1
 Q:IMRUT  D:$D(^TMP($J,IMR1C,"C",9999999)) EOP Q:IMRUT
 S IMRN=0 D HEDR S X1="HIGHEST UTILIZATION PATIENTS BASED ON FILLS" D HEDR4
 F I=0:0 Q:IMRN'<IMRRMAX!(IMRUT)  S I=$O(^TMP($J,IMR1C,"RF",I)) Q:I'>0  F J=0:0 S J=$O(^TMP($J,IMR1C,"RF",I,J)) Q:J'>0!(IMRUT)  S X=^(J),IMRN=IMRN+1,DFN=J D NS^IMRCALL W !,IMRNAM,?32,IMRSSN,?45,$J($P(X,U,2),6),$J($P(X,U,3),10),$J($P(X,U,4),12,2)
 Q:IMRUT  D EOP Q:IMRUT
 D HEDR S IMRN=0 S X1="HIGHEST UTILIZATION PATIENTS BASED ON COST" D HEDR4
 F I=0:0 Q:IMRN'<IMRRMAX!(IMRUT)  S I=$O(^TMP($J,IMR1C,"RC",I)) Q:I'>0  F J=0:0 S J=$O(^TMP($J,IMR1C,"RC",I,J)) Q:J'>0!(IMRUT)  S X=^(J),IMRN=IMRN+1,DFN=J D NS^IMRCALL W !,IMRNAM,?32,IMRSSN,?45,$J($P(X,U,2),6),$J($P(X,U,3),10),$J($P(X,U,4),12,2)
 K DFN,IMRNAM,IMRSSN
 Q
PRNT1 ;
 S X=+^TMP($J,IMR1C,"A",I,N),Y=$P(^(N),U,2),Z=$P(^(N),U,3),Z1=$P(^(N),U,4) W !,N,?42,$J(Y,7),"       ",$J(X,6) W:X'=Y&(X'=1) ?63,$J(+^(N,"MAX"),7)," (",$P(^("MAX"),U,2)," pat)"
 Q
PRNT2 ;
 S X=+^TMP($J,IMR1C,"C",I,N),Y=$P(^(N),U,2),Z=$P(^(N),U,3),Z1=$P(^(N),U,4) W !,$E(N,1,35),?37,$J(Z,11,2),"  ",$J(Y,5),"  ",$J(Z1,9),"  ",$J(X,7) S IMRTOTL=IMRTOTL+Z
 Q
 ;
EOP ; Check End of Page
 Q:$D(IO("S"))  ;quit if a slave device
 I IOST["C-" K DIR W ! S DIR(0)="E" D ^DIR K DIR I 'Y S IMRUT=1
 Q
HEDR ;
 S IMRPG=IMRPG+1
 W @IOF
 W:IOST'["C-" !
 W !,IMRDTE,?(IOM-$L(IMRX)\2),IMRX,?(IOM-8),"Page ",IMRPG,!?(IOM-$L(IMRD)\2),IMRD,!?(IOM-$L(IMRLBL)\2),IMRLBL,!
 Q
HEDR1 ;
 W !,"For Drugs with ",IMRN1," or more fills",!
HEDR1A ;
 W !?66,"Max # Fills",!?66,"Per Patient",!?42,"# Fills",?55,"Patients",?66,"(# patients)",!
 Q
HEDR2 ;
 W !,"For Drugs with fills totaling $ ",$J($S(IMRN2>0:IMRN2,1:-IMRN2),4,2),"  or more",!
 W !?41,$S($E(IMRN2)'="-":"Current",1:""),?50,"# of",?58,"Quantity",?70,"# of",!?42,$S($E(IMRN2)'="-":"Value",1:"Amount"),?50,"Fills",?57,"Dispensed",?68,"Patients",!
 Q
HEDR3 ;
 W !,"Dollar Cost",!," of Fills",!
 Q
HEDR4 ;
 W !,X1,!,?47,"TOTAL",?55,"DIFFERENT",?67,"TOTAL",!,"PATIENT NAME",?35,"SSN",?47,"FILLS",?57,"DRUGS",?68,"COST",!
 Q
