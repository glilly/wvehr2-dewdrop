BPSJZQR ;BHAM ISC/LJF - HL7 Registration ZQR Message ;21-NOV-2003
 ;;1.0;E CLAIMS MGMT ENGINE;**1,3**;JUN 2004;Build 20
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 ; ZQR is pharmacy site registration info
 ;
EN(HL) N ZQR,FS,CPS,REP,BPSFILE,BPSIEN,VAIX1,VAIX2,CNF,I
 ;
 ; Normally: HL("FS")="|"  HL("ECH")="^~\&"
 S FS=$G(HL("FS")) I FS="" S FS="|"
 S CPS=$E($G(HL("ECH"))) I CPS="" S CPS="^"
 S REP=$E($G(HL("ECH")),2) I REP="" S REP="~"
 ;
 S ZQR=FS_(+$G(HL("SITE")))
 ;
 ; Get Contact Info
 S BPSFILE=9002313.99,BPSIEN=$O(^BPS(BPSFILE,0))
 S VAIX1=$G(^BPS(BPSFILE,BPSIEN,"VITRIA")),VAIX2=$P(VAIX1,U,2)
 ;
 ; Get Version number
 S ZQR=ZQR_FS_$P(VAIX1,U,3)
 ;
 ; Port
 S ZQR=ZQR_FS_$G(HL("EPPORT"))
 ;
 ; Load the Name and Means Fields
 ; Default the values to null
 F I=5:1:8 S $P(ZQR,FS,I)=""
 ; Contact
 I VAIX1 D
 . S CNF=$$VA200NM^BPSJUTL(+VAIX1,"",.HL) I CNF]"" S $P(ZQR,FS,5)=CNF
 . S CNF=$$VA20013^BPSJUTL(+VAIX1,.HL) I CNF]"" S $P(ZQR,FS,6)=CNF
 ;
 ; Alternate Contact
 I VAIX2 D
 . S CNF=$$VA200NM^BPSJUTL(VAIX2,"",.HL) I CNF]"" S $P(ZQR,FS,7)=CNF
 . S CNF=$$VA20013^BPSJUTL(VAIX2,.HL) I CNF]"" S $P(ZQR,FS,8)=CNF
 ;
 Q "ZQR|"_ZQR
