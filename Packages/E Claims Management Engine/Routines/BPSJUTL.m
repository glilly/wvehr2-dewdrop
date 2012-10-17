BPSJUTL ;BHAM ISC/LJF - e-Pharmacy Utils ;4/17/08  16:13
        ;;1.0;E CLAIMS MGMT ENGINE;**1,2,5,7**;JUN 2004;Build 46
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
HLP(PROTOCOL)   ;  Find the Protocol IEN
        Q +$O(^ORD(101,"B",PROTOCOL,0))
        ;
VAHL7ECH(HL)    ; Hl7 Encoding Characters
        S FS=$G(HL("FS")) I FS="" S FS="|"
        S ECH=$G(HL("ECH")) I ECH="" S ECH="^~\&"
        S CPS=$E(ECH),REP=$E(ECH,2)
        ;
        Q
        ;
MSG(BPSJMM,BPSJRTN)     ; Message Handler
        ;
        N XMDUZ,XMSUB,XMY,XMTEXT,XMZ,BPSX,BPSY
        ;
        I $G(BPSJRTN)]"" S BPSJMM(.0001)="Source Process: "_BPSJRTN
        F BPSX=1,2 S BPSY=$P($G(^BPS(9002313.99,1,"VITRIA")),"^",BPSX) I BPSY S XMY(BPSY)="" S:$L($G(^VA(200,BPSY,.15))) XMY(^(.15))=""
        Q:'$D(XMY)
        S XMTEXT="BPSJMM(",XMSUB="ECME Registration Problem.",XMDUZ="ECME PACKAGE"
        D ^XMD
        ;
        Q
        ;
VA200NM(VAIX,VATITLE,HL)        ;
        ;
        N RETDATA,BPSNMDAT
        N FS,CPS,REP
        ;
        I '$G(VAIX) Q ""
        S BPSNMDAT=$P($G(^VA(200,VAIX,0)),U,1) I BPSNMDAT="" Q ""
        ;
        D VAHL7ECH(.HL)
        D STDNAME^XLFNAME(.BPSNMDAT,"C")
        ;
        S RETDATA=$G(BPSNMDAT("FAMILY"))              ;1
        S RETDATA=RETDATA_CPS_$G(BPSNMDAT("GIVEN"))   ;2
        S RETDATA=RETDATA_CPS_$G(BPSNMDAT("MIDDLE"))  ;3
        S RETDATA=RETDATA_CPS_$G(BPSNMDAT("SUFFIX"))  ;4
        S RETDATA=RETDATA_CPS_$G(BPSNMDAT("PREFIX"))  ;5
        S RETDATA=RETDATA_CPS_$G(BPSNMDAT("DEGREE"))  ;6
        ;
        S VATITLE=$P($G(^VA(200,VAIX,0)),U,9)
        I VATITLE S VATITLE=$G(^DIC(3.1,VATITLE,0))
        ;
        Q RETDATA
        ;
VA20013(VAIX,HL)        ; Build the HL7 Contact Means data field
        ;
        N FDATA,RETDATA
        N FS,CPS,REP
        ;
        I '$G(VAIX) Q ""
        ; VAIX is the index to ^VA(200,n
        D VAHL7ECH(.HL)
        S RETDATA=$P($G(^VA(200,VAIX,.15)),U,1)   ; LJF@DAOU.COM
        I RETDATA]"",RETDATA["@" S RETDATA=CPS_"NET"_CPS_"INTERNET"_CPS_RETDATA
        S FDATA=$$EN^BPSJPHNM(VAIX,CPS,REP)
        I $L(FDATA) D
        . I $L(RETDATA) S RETDATA=RETDATA_REP
        . S RETDATA=RETDATA_FDATA
        Q RETDATA
        ;
ENCODE(INSTR,TCH)       ;  Encode data - Primarily HL7
        N X,WCHR,OSTR
        S OSTR=""
        I $G(INSTR)]"" F X=1:1:$L(INSTR) D  S OSTR=OSTR_WCHR
        . S WCHR=$E(INSTR,X) I $D(TCH(WCHR)) S WCHR=TCH(WCHR)
        Q OSTR
        ;
SPAR(HL,BPSJSEG,HCTS)   ;  Segment Parsing
        N II,IJ,IK,ISDATA
        N FS,CPS,REP,ECH
        ;
        I '$G(HCTS) Q
        ;
        D VAHL7ECH(.HL)
        M ISDATA=^TMP($J,"BPSJHLI",HCTS)
        S IK=0,IJ=1,II=""
        F  S II=$O(ISDATA(II)) Q:II=""  D
        . S ISDATA=$G(ISDATA(II)) Q:ISDATA=""
        . F  D  Q:ISDATA=""
        . . S IK=IK+1,BPSJSEG(IJ,IK)=$P(ISDATA,FS)
        . . S $P(ISDATA,FS)=""
        . . I $E(ISDATA)=FS S IJ=IJ+1,$E(ISDATA)=""
        ;
        ; Promote data in 1st subnode and kill subnode
        S II=""
        F  S II=$O(BPSJSEG(II)) Q:II=""  D
        . S IJ=$O(BPSJSEG(II,"")) Q:'IJ
        . S BPSJSEG(II)=BPSJSEG(II,IJ) K BPSJSEG(II,IJ)
        Q
