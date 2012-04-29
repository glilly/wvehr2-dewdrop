PRCAFBDM ;WASH-ISC@ALTOONA,PA/CLH-Build MODIFIED FMS Billing Document ;9/16/94  12:11 PM
 ;;4.5;Accounts Receivable;**60,90,204,203,220**;Mar 20, 1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
EN(BILL,AMT,ADJTYP,PRCADJD,TN,ERR) ;Process NEW BILL to FMS
 Q:$D(RCONVERT)
 N GECSFMS,REC,FMSNUM
 K ^TMP("PRCABD",$J)
 I $G(BILL)="" S ERR="1^Missing Bill Number" Q
 ;
 ;  funds 5014 (old), 2431 (old), 528701,03,04,09 and 4032 should not create a BD
 S %=$P($G(^PRCA(430,BILL,11)),"^",17)
 I %=5014!(%=2431)!(%=4032) Q
 I %[5287 Q:$$PTACCT^PRCAACC(%)
 ;
 I +PRCADJD<1 S PRCADJD=DT
 I AMT<0 S AMT=-AMT
 I '$D(^PRCA(430,BILL,0)) S ERR="1^Unable to locate bill" Q
 S REC=$G(^PRCA(430,BILL,0)),FMSNUM=$P($P(REC,U),"-")_$P($P(REC,U),"-",2)
 W !!,"Creating FMS Modified Billing Document..."
 N FMSDT S FMSDT=$$FMSDATE^RCBEUTRA(DT)
 S ^TMP("PRCABD",$J,1)="BD2^"_$E(FMSDT,4,5)_U_$E(FMSDT,6,7)_U_$E(FMSDT,2,3)_"^^^^^^M^^^"_$J(AMT,0,2)_"^~"
 S ^TMP("PRCABD",$J,2)="LIN^~"
 S ^TMP("PRCABD",$J,3)="BDA^"_$$LINE^RCXFMSC1(BILL)_"^^^^^^^^^^^^^^"_$J(AMT,0,2)_"^"_$S(ADJTYP=35:"D",ADJTYP=1:"I",1:"")_"^AR_INTERFACE^~"
 ;build control segment
 D CONTROL^GECSUFMS("A",$P(REC,U,12),FMSNUM,"BD",10,"1","","Modified Billing Document")
 S FMSNUM1=$P($G(GECSFMS("DOC")),U,3)_"-"_$P($G(GECSFMS("DOC")),U,4)_"-"_$P($G(GECSFMS("BAT")),U,3)
 D OPEN^RCFMDRV1(FMSNUM1,7,"T"_TN,.ENT,.ERR,BILL,TN) I ERR]"" W !!,"Unable to create entry in AR Document File.",! S ERR=-1
 ;build and send document to FTH
 S DA=0 F  S DA=$O(^TMP("PRCABD",$J,DA)) Q:'DA  D SETCS^GECSSTAA(GECSFMS("DA"),^(DA))
 D SETCODE^GECSSDCT(GECSFMS("DA"),"D RETN^RCFMFN02")
 D SETSTAT^GECSSTAA(GECSFMS("DA"),"Q")
 D SSTAT^RCFMFN02("T"_TN,1)
 W !,"Document #",GECSFMS("DA")," Created.",!
 Q
 ;
