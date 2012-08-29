BPSSCRU6 ;BHAM ISC/SS - ECME SCREEN UTILITIES ;22-MAY-06
 ;;1.0;E CLAIMS MGMT ENGINE;**3**;JUN 2004;Build 20
 ;; Per VHA Directive 10-93-142, this routine should not be modified.
 ;USER SCREEN
 Q
 ;
 ;Input:
 ; BP59 - 
 ;Output:
 ; 
DISPREJ(BP59) ;
 N BPARR,BPN,BPCNT
 S BPN=0
 ;I (BPSTATUS["E REJECTED")!(BPSTATUS["E REVERSAL REJECTED") D
 D GETRJCOD^BPSSCRU3(BP59,.BPARR,.BPN,74,"")
 D WRAPLN2^BPSSCRU5(.BPN,.BPARR,$$GETMESS^BPSSCRU3(1000,504,BP59),74,"",0)
 D WRAPLN2^BPSSCRU5(.BPN,.BPARR,$$GETMESS^BPSSCRU3(1000,526,BP59),74,"",0)
 D WRAPLN2^BPSSCRU5(.BPN,.BPARR,$$GETMESS^BPSSCRU3(504,0,BP59),74,"",0)
 I BPN=0 Q
 S BPCNT=0
 F  S BPCNT=$O(BPARR(BPCNT)) Q:+BPCNT=0  D
 . W:$L(BPARR(BPCNT)) !,?6,BPARR(BPCNT)
 Q
 ;
 ;return Date in specified format
 ;BPDT - date in FileMan format
 ;BPMODE:
 ; 1- like "JUL 23, 2005"
 ; 2- like "JUL 23, 2005@16:03 "
 ; 3- MM/DD/YY
FORMDATE(BPDT,BPMODE) ;
 N Y,BPTIME,BPHR
 I $G(BPDT)=0 Q ""
 I BPMODE=1 S Y=BPDT\1 X ^DD("DD") Q Y
 I BPMODE=2 S Y=BPDT X ^DD("DD") Q Y
 I BPMODE=3 S Y=$E(BPDT,4,5)_"/"_$E(BPDT,6,7)_"/"_$E(BPDT,2,3) Q Y
 Q ""
 ;
 ;Generic function to ask a date
 ;Input:
 ;BPPROMPT - prompt like "START WITH DATE: "
 ;BPDFLDT - default for the prompt like "TODAY" or "T" or "T-100" or 12/12/2005
 ;output:
 ; 0 - nothing
 ; <0 quit
 ; >0 fileman date
ASKDATE(BPPROMPT,BPDFLDT) ;
 S %DT="AEX"
 S %DT("A")=BPPROMPT,%DT("B")=BPDFLDT
 D ^%DT K %DT
 I Y<0 Q -1
 Q +Y
 ;Release date
 ;RXNO - RX ien #52
 ;REFNO - fill number (0=original)
RELDATE(RXNO,REFNO) ;
 I REFNO=0 Q $$RXRELDT^BPSSCRU2(+RXNO)
 Q $$REFRELDT^BPSSCRU2(+RXNO,REFNO)
 ;
 ;Group name/Plan name - name originally comes from file #355.3 by BPS TRANSACTION file ien
PLANNAME(BP59) ;
 N BPPLNM
 S BPPLNM=$P($G(^BPST(BP59,10,1,3)),U)
 S:BPPLNM="" BPPLNM=$P($G(^BPST(BP59,10,1,1)),U,3)
 Q BPPLNM
 ;Insurance name - name originally comes from file #36 by BPS TRANSACTION file ien
INSNAME(BP59) ;
 Q $P($G(^BPST(BP59,10,1,0)),U,7)
 ;
 ;Returns close reason by ien file#356.8
CLREASON(BP3568) ;
 Q $P($G(^IBE(356.8,BP3568,0)),U)
 ;
 ;Convert YYYYMMDD to FileMan format
YMD2FM(BPYMD) ;
 Q ($E(BPYMD,1,4)-1700)_$E(BPYMD,5,8)
 ;
 ;get DRUG ien from PRESCRIPTION file
DRUGIEN(BP52,BPDFN) ;
 N XZ
 S XZ=0
 K ^TMP($J,"BPSDRUG")
 D RX^PSO52API(BPDFN,"BPSDRUG",BP52,,"")
 S XZ=$G(^TMP($J,"BPSDRUG",BPDFN,BP52,6))
 K ^TMP($J,"BPSDRUG")
 Q +$P(XZ,U)
 ;
 ;
CONVCLID(BPCLID) ;
 Q $P(BPCLID,"D2",2)
 ;BPSSCRU6
