IMRRX ; HCIOFO-FAI/EXTRACT PHARMACY DATA FOR IMR REGISTRY ; 12/24/02 9:31am
 ;;2.1;IMMUNOLOGY CASE REGISTRY;**3,8,5,15,18,19**;Feb 09, 1998
 ;
 ;***** EXTRACTS THE OUTPATIENT PHARMACY DATA
 ;
 ; IMRSD         Start date
 ; [IMRED]       End date (unlimited by default)
 ;
GET(IMRSD,IMRED) ;
 N IMRP,IMRR,NODE
 S NODE=$NA(^PS(55,IMRDFN,"P")),IMRRX=0
 S:$G(IMRED)'>0 IMRED=9999999
 ;--- Get outpatient pharmacy data
 S IMRP=IMRSD-1
 F  S IMRP=$O(@NODE@("A",IMRP))  Q:IMRP'>0  D
 . S IMRR=0
 . F  S IMRR=$O(@NODE@("A",IMRP,IMRR))  Q:IMRR'>0  D RX^IMRUTL,OPT
 ;--- Cleanup
 K IMREXP,X,IMRX3,IMRDST,IMRX,IMRN,IMRRI,IMRNDF,IMRSTR,IMRRXD1,IMRRXDR,IMRPS,IMRRXD,IMRCL,IMRXX1,IMREF,IMRDST,IMRAR,IMRDSUP,IMRDU,IMRUCST,IMRQ
 Q
 ;
 ;***** OUTPATIENT PHARMACY (RX SEGMENT)
 ;
 ; Uses the data loaded by the RX^IMRUTL (^TMP("PSOR",$J,...)
 ;
 ; piece 4=$S(0:original fill,1:1-n:refill number)
 ; piece 5 (IMRRXD)=last dispensed date
 ; piece 6 (IMRQ)=Quantity
 ; piece 7 (IMRDSUP)=days supply
 ; piece 8 (IMREF)=# of refills
 ; piece 9 (IMRPS)=patient status
 ; piece 10 (IMRCL)=clinic
 ; piece 11 (IMRUCST)=unit price of drugs
 ; piece 12 (IMRXSIG)=SIG
 ; piece 13 (IMRNDF)=national drug file entry external format
 ; piece 14 (IMRNFN)=National drug file entry internal format
 ;
OPT ;
 N BUF,TMP
 I 'IMRRXD1!('IMRXX1)  Q  ;quit if no issue date or drug
 ;--- Quit if status is canceled or deleted
 I IMRDST="CANCELLED"!(IMRDST="DELETED")  Q
 ;--- Quit if expiration is not greater than extract start date
 I IMREXP,IMREXP'>IMRSD  Q
 ;--- Get internal name of national drug
 S IMRNDF=$$NDF(IMRXX1,$S(+$G(IMRTRANS):"I",1:""))
 ;--- Get external name of national drug
 S IMRNFN=$$NDF(IMRXX1,$S(+$G(IMRTRANS):"E",1:""))
 S IMRX3="RX^"_(IMRRXD1\1)_"^"_IMRRXDR  ; RX^issue date^drug
 ;--- If no last dispensed date, set last dispensed date =issue date
 S:'IMRRXD IMRRXD=IMRRXD1
 ;--- Use fill date if available
 S:IMRFILDT IMRRXD=IMRFILDT
 ;--- If no unit price of drugs, set it equal to price per
 ;--- dispensed unit
 S:'IMRUCST IMRUCST=IMRDU
 ;--- If last dispensed date'<start date AND last dispensed date'>end
 ;--- date, set message node.
 I IMRRXD'<IMRSD,IMRRXD'>IMRED  D
 . S IMRC=IMRC+1
 . S ^TMP($J,"IMRX",IMRC)=IMRX3_"^0^"_IMRRXD_"^"_IMRQ_"^"_IMRDSUP_"^"_IMREF_"^"_IMRPS_"^"_IMRCL_"^"_IMRUCST_"^^"_IMRNDF_"^"_IMRNFN
 . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="RXS^"_IMRXSIG
 . S IMRSEND=1  D LCHK^IMRDAT
 . S:IMRRXD>IMRRX IMRRX=IMRRXD
 ;--- Process the refills
 S IMRN="",IMRRI=0
 F  S IMRN=$O(^TMP("PSOR",$J,IMRR,"REF",IMRN))  Q:IMRN=""  D
 . S BUF=$G(^TMP("PSOR",$J,IMRR,"REF",IMRN,0))
 . S IMRRXD=$P(BUF,"^")     ; Refill date
 . Q:(IMRRXD'>IMRSD)!(IMRRXD>IMRED)
 . S IMRUCST=$P(BUF,"^",6)  ; Current unit price of drug
 . ;--- If no current unit price, set IMRUCST=price per dispensed unit
 . S:'IMRUCST IMRUCST=IMRDU
 . ;--- Add RX and RXS segments
 . S IMRRI=IMRRI+1,IMRC=IMRC+1
 . S ^TMP($J,"IMRX",IMRC)=IMRX3_"^"_IMRRI_"^"_IMRRXD_"^"_$P(BUF,"^",4)_"^"_$P(BUF,"^",5)_"^^^^"_IMRUCST_"^^"_IMRNDF_"^"_IMRNFN
 . S IMRC=IMRC+1,^TMP($J,"IMRX",IMRC)="RXS^"_IMRXSIG
 . S IMRSEND=1  D LCHK^IMRDAT
 . S:IMRRXD>IMRRX IMRRX=IMRRXD
 Q
 ;
NDF(IMRDRG0,IMRFLG) ; Input: PSDRUG IEN, and either "I" or "E" or NULL for
 ;                 Internal or External data format.  A Null,"", will
 ;                 return the external format.
 ;                 RETURN: NDF IEN for Internal or NDF name for External.
 S IMRDRG1=""
 I $T(^PSNAPIS)]"","E"[IMRFLG,IMRDRG0,$P($G(^PSDRUG(IMRDRG0,"ND")),"^") S IMRDRG1=$$VAGN^PSNAPIS($P($G(^PSDRUG(IMRDRG0,"ND")),"^")) G EXIT ;use api if available
 G:'IMRDRG0 EXIT
 I IMRFLG="I" S IMRDRG1=$$GET1^DIQ(50,IMRDRG0,20,IMRFLG) ;File 50=DRUG file (^PSDRUG), field #20 is national drug file entry (pointer)
EXIT Q IMRDRG1
