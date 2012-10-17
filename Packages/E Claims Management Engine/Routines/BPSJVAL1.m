BPSJVAL1        ;BHAM ISC/LJF - Pharmacy Application Validation ;3/5/08  11:17
        ;;1.0;E CLAIMS MGMT ENGINE;**1,5,7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        N BPSJVAL1,VERBOSE
        W !!!,"SITE REGISTRATION VALIDATION.",!
        D BPSJVAL^BPSJAREG(2)
        W !!!!
        ;
        Q
        ;
VALIDATE        ; Validate ZQR Data
        ;
        N SEG,SEGIX,ZQR,RIX,PIX,PIXL,SEGDAT,ZNOTE,ZMAX
        N HL7EOIEN,HL7EOIP
        N HL7VOIEN,HL7VOIP
        N HL7EDOM,HL7PDOM,HL7OPORT,HL7PORT,CMA
        ;
        ; Constants
        S HL7PORT=5105,ZMAX=8,CMA=","
        S HL7PDOM=$S($$PROD^XUPROD:"EPHARMACY.VITRIA-EDI.AAC.VA.GOV",1:"EPHARMACY.VITRIA-EDI-TEST.AAC.VA.GOV")
        ;
        S RETCODE=+$G(RETCODE)
        S ZQR="",RIX=0
        ;
        S HL7EOIEN=$$FIND1^DIC(870,"",,"EPHARM OUT","B")_CMA   ;EPHARM OUT
        S HL7VOIEN=$$FIND1^DIC(870,"",,"IIV EC","B")_CMA       ;IIV EC
        ;
        ; Vitria Domain name
        S HL7EDOM=$$GET1^DIQ(870,HL7EOIEN,.03)   ;EPHARM OUT
        I HL7EDOM=HL7PDOM S ZNOTE="   DOMAIN NAME - Required - VALID: "_HL7PDOM
        E  D
        . I HL7EDOM="" S ZNOTE="** DOMAIN NAME - Required - INVALID" S RETCODE=.3 Q
        . S ZNOTE=" * WARNING: EXPECTED DOMAIN NAME: "_HL7PDOM_"                            CURRENT DOMAIN NAME: "_HL7EDOM
        S RETCODE(.3)=ZNOTE
        I +$G(VERBOSE) W !,RETCODE(.3)
        ;
        ; Get IP addresses
        S HL7EOIP=$$GET1^DIQ(870,HL7EOIEN,400.01)   ;EPHARM OUT
        S HL7VOIP=$$GET1^DIQ(870,HL7VOIEN,400.01)   ;IIV EC
        ;
        I HL7EOIP,HL7EOIP=HL7VOIP S ZNOTE="   TCP/IP ADDRESS FOR ""EPHARM OUT"" - Required - VALID: "_HL7EOIP
        E  D
        . I 'HL7EOIP S ZNOTE="** TCP/IP ADDRESS FOR ""EPHARM OUT"" - Required - INVALID",RETCODE=.7 Q
        . I HL7VOIP,HL7EOIP'=HL7VOIP S ZNOTE=" * WARNING: ""EPHARM OUT"" TCP/IP ADDRESS DIFFERENT THAN ""IIV EC"" TCP/IP ADDRESS.        EPHARM OUT: "_HL7EOIP_"   IIV EC: "_HL7VOIP
        S RETCODE(.7)=ZNOTE
        I +$G(VERBOSE) W !,RETCODE(.7)
        ;
        ; Get Outgoing Port and IP Address
        S HL7OPORT=$$GET1^DIQ(870,HL7EOIEN,400.02)   ;EPHARM OUT
        I HL7OPORT,HL7OPORT=HL7PORT S ZNOTE="   ""EPHARM OUT"" PORT NUMBER - Required - VALID: "_HL7OPORT
        E  D
        . S ZNOTE=" * WARNING: EXPECTED ""EPHARM OUT"" PORT NUMBER: "_HL7PORT
        . S ZNOTE=ZNOTE_"                                         CURRENT "
        . S ZNOTE=ZNOTE_"""EPHARM OUT"" PORT NUMBER: "_HL7OPORT
        . I 'HL7OPORT S ZNOTE="** ""EPHARM OUT"" PORT NUMBER - Required - INVALID",RETCODE=.9 Q
        S RETCODE(.9)=ZNOTE
        I +$G(VERBOSE) W !,RETCODE(.9)
        ;
        F SEGIX=3:1 S SEG=$G(^TMP("HLS",$J,SEGIX)),PIX=0 Q:SEG=""  D
        . I $E(SEG,1,3)="ZQR" S ZQR=$E(SEG,4) S $E(SEG,1,4)=""
        . I ZQR="" Q
        . S PIXL=$L(SEG,ZQR)
        . F  S RIX=RIX+1,PIX=PIX+1 Q:RIX>ZMAX  D
        .. S RETCODE(RIX)=$P(SEG,ZQR,PIX) D @RIX
        .. ; RIX 4 - EPHARM IN Port - no longer required nor validated
        .. I +$G(VERBOSE),$L($G(RETCODE(RIX))),RIX'=4 W !,RETCODE(RIX) Q
        ;
        Q
        ; NS=Not Supported, R=Required, RE=Required or empty, C=Conditional
        ; CE=Conditional or empty, O=Optional,
        ;
1       ; Set ID - NS
        Q
2       ; Site Number - R
        S ZNOTE="   SITE NUMBER - Required - VALID: "_RETCODE(RIX)
        I RETCODE(RIX)="" S ZNOTE="** SITE NUMBER - Required - INVALID",RETCODE=2
        S RETCODE(RIX)=ZNOTE
        Q
3       ; Interface Version - R
        ;     Must equal 2 or greater for this validation version
        S ZNOTE="   INTERFACE VERSION - Required - VALID: "
        I RETCODE(RIX)<2 S ZNOTE="** INTERFACE VERSION - Required - INVALID: ",RETCODE=3
        S RETCODE(RIX)=ZNOTE_RETCODE(RIX)
        Q
4       ; EPHARM IN port - NS
        Q
5       ; Contact Name
        S RETCODE(RIX)="   CONTACT NAME - VALID: "_$$FMNAME^HLFNC(RETCODE(RIX))
        Q
6       ; Contact Means
        S RETCODE(RIX)="   CONTACT MEANS - VALID: "_$P($TR(RETCODE(RIX),"^"," "),"~")
        Q
7       ; Alternate Contact NAME
        S RETCODE(RIX)="   ALTERNATE CONTACT NAME - VALID: "_$$FMNAME^HLFNC(RETCODE(RIX))
        Q
8       ; Alternate Contact Means
        S RETCODE(RIX)="   ALTERNATE CONTACT MEANS - VALID: "_$P($TR(RETCODE(RIX),"^"," "),"~")
        Q
