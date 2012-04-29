SPNHL7 ;WDE/SAN-DIEGO;validate then build the z segment
 ;;2.0;Spinal Cord Dysfunction;**10,24**;01/02/97
CHK(SPNFDFN) ;
 ;       ifn is the record number in SPN(154 it's dinumed to dpt
 ;--------------------------------------------------------------------
 ;check registration date
 S SPNCHK=$$GET1^DIQ(154,SPNFDFN_",",.02)
 I $G(SPNCHK)="" D ZAP Q
 ;check registration status
 S SPNCHK=$$GET1^DIQ(154,SPNFDFN_",",.03)
 I $G(SPNCHK)="" D ZAP Q
 ;check VA SCI STATUS
 ;S SPNCHK=$$GET1^DIQ(154,SPNFDFN_",",2.6)
 ;I $G(SPNCHK)="" D ZAP Q
 ;check for etiology
 ;D GETS^DIQ(154,SPNFDFN_",","4*","","SPNCHK")
 ;I $D(SPNCHK)=0 D ZAP Q
 ;the record passed the test and we want it
CREATE ;this label is also called from the tag auto
 K SPMSG
 D INIT
 I HLDAP="" D ZAP Q  ;cant find the hl7 application
 I $P($G(^HL(771,HLDAP,0)),U,2)'="a" D ZAP Q  ;test for active/on
 D EN^SPNHPID(SPNFDFN)
 D EN^SPNHL1(SPNFDFN)
 ;at this point we have the HL7 message in the msg arrary!
 D SEND  ;send will send the message off to the hl7 sftw
ZAP ;
 K SPMSG,X,Y,SPTMP,OBXCNT,SPLINE,DATA,CL,SPNOBR
 K HL,HLA,SPNTMP,HLARYTYP,HLECH,HLFORMAT,HLFS,HLMTIEN,HLSAN,HLN,HLQ,HLRESLT
 Q
AUTO ;this tag is used for loading the AUSTIN system from a server request
 ;this should never be ran from a site unless informed to.
 S SPNIFN=0 F  S SPNIFN=$O(^SPNL(154,SPNIFN)) Q:(SPNIFN="")!('+SPNIFN)  D
 . D CHK(SPNIFN) I $D(SPNCHK) D AUTO^SPNHL71
 . K SPNCHK
 . Q
 Q
INIT ;
 ;
 S HLDAP=$O(^HL(771,"B","SPN-HL7-APP",0))
 Q:HLDAP=""  ;cant find the hl7 application
 Q:$P($G(^HL(771,HLDAP,0)),U,2)'="a"  ;test for active/on
 S HL="HL"
 S PEIN=$O(^ORD(101,"B","SPN-HL7-SERVER",0))
 D INIT^HLFNC2(PEIN,.HL,0)
 S HLCOMP=$E(HL("ECH"),1),HLREP=$E(HL("ECH"),2),HLSUB=$E(HL("ECH"),4),HLFS=HL("FS"),HLQ=HL("Q"),HLECH=HL("ECH")
 Q
 ;-------------------------------------------------------------------
SEND ;
 S HLARYTYP="LM",HLFORMAT=1,HLMTIEN="",HLRESLT=""
 S P=0 F  S P=$O(SPMSG(P)) Q:P=""  S HLA("HLS",P)=SPMSG(P)
 D GENERATE^HLMA(PEIN,HLARYTYP,HLFORMAT,.HLRESLT,HLMTIEN,.HLP)
 Q
EXIT ;Exit point to clean up all var's
 K CL,DATA,ETDAT,ETDATE,HL,HLA,HLARYTYP,HLDAP,HLDAP,HLECH,HLFORMAT,HLFS,HLMTIEN,HLN,HLP,HLQ,HLREP,HLRESLT,HLSAN,HLSUB,INJURY,INJURY,OBXCNT,PEIN,SPD,SPDATA,SPDD,SPDT,SPDTYPE,SPLINE,SPMSG,SPNCAUSE,SPNCHK,SPND,SPND1,SPNDD
 K SPNDOC,SPNDT,SPNET,SPNETIOL,SPNFREQ,SPNLDT,SPNLET,SPNLEXAM,SPNLFAC,SPNLFAM,SPNLSEEN,SPNOBR,SPNRDT,SPNTBL,SPNTMP,SPTMP,SPX
