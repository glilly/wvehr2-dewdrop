BPSJZRP ;BHAM ISC/LJF - HL7 Registration ZRP Message ;21-NOV-2003
 ;;1.0;E CLAIMS MGMT ENGINE;**1,2**;JUN 2004;Build 12
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
 Q
 ;
EN(HL,PHIX,ZRP,NPI,NCP) ;
 ; ZRP array contains pharmacy registration info
 N ZRPS,FS,CPS,REP,NDZRO,NDHRS,NDREM,NDREP,NDREP1,NDADD,STATE
 N VAIX1,VAIX2,VAIXLP,VATLE,CNF,MSGCNT,TCH
 ;
 ; Quit if no Pharmacy index provided
 I '$G(PHIX) Q
 ;
 K ZRP S ZRPS=""
 ;
 ; Set HL7 Delimiters - use standard defaults if none provided
 S FS=$G(HL("FS")) I FS="" S FS="|"
 S CPS=$E($G(HL("ECH"))) I CPS="" S CPS="^"
 S REP=$E($G(HL("ECH")),2) I REP="" S REP="~"
 ;
 S NDZRO=$G(^BPS(9002313.56,PHIX,0))
 S NDREM=$G(^BPS(9002313.56,PHIX,"REMIT"))
 S NDREP=$G(^BPS(9002313.56,PHIX,"REP"))
 S NDREP1=$G(^BPS(9002313.56,PHIX,"REP1"))
 S NDADD=$G(^BPS(9002313.56,PHIX,"ADDR"))
 ;
 F ZRP=1:1:17 S ZRP(ZRP)="" ;Initialize
 S (ZRP(2),NCP)=$P(NDZRO,U,2)     ;NCPDP #
 S ZRP(3)=$P(NDZRO,U)       ;NAME
 S ZRP(4)=$P(NDZRO,U,3)     ;DEFAULT DEA #
 ;
 S ZRP(5)=$$OPHOURS(PHIX)
 ;
 I $L($P(NDADD,U,8)) S $P(ZRPS,CPS,1)=$P(NDADD,U,8)  ;SITE ADDRESS NAME
 I $L($P(NDADD,U,1)) S $P(ZRPS,CPS,1)=$P(ZRPS,CPS,1)_" "_$P(NDADD,U,1)  ;SITE ADDRESS 1
 I $L($P(NDADD,U,2)) S $P(ZRPS,CPS,2)=$P(NDADD,U,2)  ;SITE ADDRESS 2
 I $L($P(NDADD,U,3)) S $P(ZRPS,CPS,3)=$P(NDADD,U,3)  ;CITY
 I $L($P(NDADD,U,4)) S STATE=$P(NDADD,U,4) I STATE D  ; State
 . S STATE=$P($G(^DIC(5,STATE,0)),U,2)
 . I STATE]"" S $P(ZRPS,CPS,4)=STATE
 I $L($P(NDADD,U,5)) S $P(ZRPS,CPS,5)=$P(NDADD,U,5)  ;ZIP
 I ZRPS]"" S ZRP(6)=ZRPS,ZRPS=""
 ;
 I $L($P(NDREM,U,1)) S $P(ZRPS,CPS,1)=$P(NDREM,U,1)   ;REMITTANCE ADDRESS NAME
 I $L($P(NDREM,U,2)) S $P(ZRPS,CPS,1)=$P(ZRPS,CPS,1)_" "_$P(NDREM,U,2)  ;REMIT ADDRESS LINE 1
 I $L($P(NDREM,U,3)) S $P(ZRPS,CPS,2)=$P(NDREM,U,3)   ;REMIT ADDRESS LINE 2
 I $L($P(NDREM,U,6)) S $P(ZRPS,CPS,3)=$P(NDREM,U,6)   ;CITY
 I $L($P(NDREM,U,7)) S STATE=$P(NDREM,U,7) I STATE D  ;State
 . S STATE=$P($G(^DIC(5,STATE,0)),U,2)
 . I STATE]"" S $P(ZRPS,CPS,4)=STATE
 I $L($P(NDREM,U,8)) S $P(ZRPS,CPS,5)=$P(NDREM,U,8)  ;ZIP
 I ZRPS]"" S ZRP(7)=ZRPS,ZRPS=""
 ;
 ; Load the Name and Means Fields
 S VAIX1=$P(NDREP,U,3)
 S VAIX2=$P(NDREP,U,4)
 S VAIXLP=$P(NDREP,U,5)
 ;
 ; Contact
 I $G(VAIX1) S VATLE="" D
 . S CNF=$$VA200NM^BPSJUTL(VAIX1,.VATLE,.HL) I CNF]"" S ZRP(8)=CNF
 . I VATLE]"" S ZRP(9)=VATLE
 . S CNF=$$VA20013^BPSJUTL(VAIX1,.HL) I CNF]"" S ZRP(10)=CNF
 ;
 ; Alternate Contact
 I $G(VAIX2) S VATLE="" D
 . S CNF=$$VA200NM^BPSJUTL(VAIX2,.VATLE,.HL) I CNF]"" S ZRP(11)=CNF
 . I VATLE]"" S ZRP(12)=VATLE
 . S CNF=$$VA20013^BPSJUTL(VAIX2,.HL) I CNF]"" S ZRP(13)=CNF
 ;
 ; Lead Pharmacist
 I $G(VAIXLP) S VATLE="" D
 . S CNF=$$VA200NM^BPSJUTL(VAIXLP,.VATLE,.HL) I CNF]"" S ZRP(14)=CNF
 . I VATLE]"" S ZRP(15)=VATLE
 ;
 ; Pharmacist's License
 I $L($P(NDREP1,U)) S ZRP(16)=$P(NDREP1,U)
 ;
 ; NPI
 S ZRP(17)=$G(NPI)
 ;
 ; Encode special chars. Add Field separators.
 S TCH("\")="\E\",TCH("&")="\T\",TCH("|")="\F\"
 S (ZRPS(5),ZRPS(10),ZRPS(13))=1  ;Fields with HL7 repetion chars
 F ZRP=17:-1:1 D  S ZRP(ZRP)=$$ENCODE^BPSJUTL(ZRP(ZRP),.TCH)_FS
 . I $G(ZRPS(ZRP)) K TCH("~")  ; don't convert repetion chars
 . E  S TCH("~")="\R\"         ; ok to convert repetion chars
 S ZRP="ZRP|"
 ;
 Q
 ;
OPHOURS(PHINDEX) ; Operational Hours
 N DAY,DIX,OPH,RETURN,WEEK,OPDAY,OPHOUR
 N CLH
 ;
 S PHINDEX=+$G(PHINDEX),RETURN=""
 S WEEK="SUN^MON^TUE^WED^THU^FRI^SAT^"
 S OPH=$G(^BPS(9002313.56,PHINDEX,"TOPEN"))
 S CLH=$G(^BPS(9002313.56,PHINDEX,"TCLOSE"))
 I $G(CPS)="" S CPS=$E($G(HL("ECH"))) I CPS="" S CPS="^"
 I $G(REP)="" S REP=$E($G(HL("ECH")),2) I REP="" S REP="~"
 I OPH]"" F DAY=1:1:7 I $P(OPH,U,DAY)]"" D
 . I RETURN]"" S RETURN=RETURN_REP
 . S RETURN=RETURN_$P(WEEK,U,DAY)_CPS_$P(WEEK,U,DAY)_CPS
 . S OPHOUR=$$HOURS($P(OPH,U,DAY)) I OPHOUR<0 S OPHOUR="0000"
 . S RETURN=RETURN_OPHOUR_CPS
 . S OPHOUR=$$HOURS($P(CLH,U,DAY)) I OPHOUR<0 S OPHOUR="2359"
 . S RETURN=RETURN_OPHOUR
 I RETURN]"" Q RETURN
 ;
 S WEEK=U_WEEK
 S OPH=$G(^BPS(9002313.56,PHINDEX,"HOURS"))
 S OPDAY=$E($P(OPH,U,2),1,3)
 ;-if start day unrecognizable force to SUN
 I WEEK[(U_OPDAY_U) S RETURN=OPDAY_CPS
 E  S RETURN="SUN"_CPS
 S OPDAY=$E($P(OPH,U,3),1,3)
 ;-if end day unrecognizable force to SAT
 I WEEK[(U_OPDAY_U) S RETURN=RETURN_OPDAY_CPS
 E  S RETURN=RETURN_"SAT"_CPS
 ;-if start time unrecognizable force to 0000
 S OPHOUR=$$HOURS($E($P(OPH,U,4),1,4)) I OPHOUR<0 S OPHOUR="0000"
 ;-if end time unrecognizable force to 2359
 S OPDAY=$$HOURS($E($P(OPH,U,5),1,4)) I OPDAY<0 S OPDAY="2359"
 ;-if end time is less than start time force 0000 to 2359
 I OPDAY>OPHOUR S RETURN=RETURN_OPHOUR_CPS_OPDAY
 E  S RETURN=RETURN_"0000"_CPS_"2359"
 Q RETURN
 ;
HOURS(MIN) ; Validate time 0000 - 2359
 N HRS
 S HRS=$E(MIN,1,2),$E(MIN,1,2)=""
 I $L(HRS)=2,HRS>-1,HRS<24,$L(MIN)=2,MIN>-1,MIN<60 Q HRS_MIN
 Q -1
