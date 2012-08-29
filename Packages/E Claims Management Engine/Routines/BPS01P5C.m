BPS01P5C ;ALB/SS - BPS*1.0*5 POST INSTALL ROUTINE ;14-NOV-06
 ;;1.0;E CLAIMS MGMT ENGINE;**5**;JUN 2004;Build 45
 ;;Per VHA Directive 2004-038, this routine should not be modified.
 Q
 ;/*
 ;Get ePharmacy ien by:
 ;  BPSDT - date, 
 ;  BPSRXIEN - RX ien and 
 ;  BPSREF - refil number 
 ;by using BPS LOG file, then BPS TRANSACTION file and then PRESCRIPTION file
 ;
 ;returns ien of #9002313.56 BPS PHARMACIES
 ;or zero (0) if not found
GETEPHRM(BPSDT,BPSRXIEN,BPSREF) ;*/
 I +$G(BPSRXIEN)=0 Q 0
 I $G(BPSREF)="" Q 0
 N BP57,BP59,BPZ,BPFND,BPSPHRM
 S BPFND=0,BPSPHRM=0
 ;create a BPS TRANSACTION ien
 S BP59=BPSRXIEN_"."_$E(((BPSREF_"1")+100000),2,6)
 ;first look at BPS LOG file for the date
 ;
 I $G(BPSDT)>0 S BP57=0 F  S BP57=$O(^BPSTL("B",BP59,BP57)) Q:(+BP57=0)!(BPFND>0)  D
 . I ($P($G(^BPSTL(BP57,0)),U,11)\1)=BPSDT S BPFND=BP57
 ;if was found in BPS LOG
 I BPFND>0 S BPSPHRM=+$P($G(^BPSTL(BPFND,1)),U,7) I BPSPHRM>0 Q BPSPHRM
 ;if not get it from BPS TRANSACTION
 S BPSPHRM=+$P($G(^BPST(BP59,1)),U,7) I BPSPHRM>0 Q BPSPHRM
 ;if not then get it using PRESCRIPTION file's OUTPATIENT SITE 
 Q +$$EPHARM(BPSRXIEN,BPSREF)
 ;
 ;/*
 ;returns ien of #9002313.56 BPS PHARMACIES associated
 ;with the prescription specified by:
 ; BPSRX - IEN in file #52
 ; BPSREFIL - zero(0) for the original prescription or the refill 
 ;    number for a refill (IEN of REFILL multiple #52.1)
EPHARM(BPSRX,BPSREFIL) ;*/
 I +$G(BPSRX)=0 Q ""
 I $G(BPSREFIL)="" Q ""
 N BPSDIV59
 S BPSDIV59=+$$RXSITE^PSOBPSUT(+BPSRX,+BPSREFIL) ;IA #4701
 I BPSDIV59>0 Q $$GETPHARM^BPSUTIL(BPSDIV59)
 Q ""
 ;
 ; Delete BPS NCPDP FIELD DEF entries that are obsolete
 ;  for version 5.1 or are not Telecommunication standard
DEL91 ;
 N I,FLDNUM
 ;
 ; Fields in LIST are obsolete and/or not part of the Telecommunication standard
 F I=1:1 S FLDNUM=$P($T(LIST+I),";",3) Q:FLDNUM="END"  D DEL91A(FLDNUM)
 ;
 ; Fields 601+ are either obsolete and/or not part of the Telecommunication standard
 S FLDNUM=600 F  S FLDNUM=$O(^BPSF(9002313.91,"B",FLDNUM)) Q:+FLDNUM=0  D DEL91A(FLDNUM)
 Q
 ;
DEL91A(FLDNUM) ;
 N DIE,DA,DR
 S DA=$O(^BPSF(9002313.91,"B",FLDNUM,""))
 I DA="" Q
 S DIE=9002313.91,DR=".01////@"
 D ^DIE
 Q
 ;
LIST ;;
 ;;329
 ;;404
 ;;410
 ;;416
 ;;422
 ;;425
 ;;428
 ;;432
 ;;437
 ;;508
 ;;516
 ;;525
 ;;535
 ;;END
