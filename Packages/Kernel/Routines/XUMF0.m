XUMF0   ;ISS/RAM - XUMF API's;04/15/02
        ;;8.0;KERNEL;**407,474**;Jul 10, 1995;Build 13
        ;Per VHA Directive 10-92-142, this routine should not be modified
        ;
        Q
        ;
        ;
MFE(IFN,VUID,IEN,ERROR) ; -- update
        ;
        I 'IFN S ERROR="1^Error - IFN required HLNODE: "_HLNODE Q
        I IFN=4.009 S IEN=$$FIND1^DIC(IFN,,"B","GLOBAL VERSION") Q
        I 'VUID S ERROR="1^Error - VUID required HLNODE: "_HLNODE Q
        ;
        S ROOT=$$ROOT^DILFD(IFN,,1)
        S IEN=$O(@ROOT@("AMASTERVUID",VUID,1,0))
        ;
        ;reactivate an existing inactive VUID
        I 'IEN D
        .S IEN=$O(@ROOT@("AMASTERVUID",VUID,0,0)) Q:'IEN
        .K FDA,ERR
        .S IENS=IEN_","
        .S FDA(IFN,IENS,99.98)=1
        .D FILE^DIE("E","FDA","ERR")
        .I $D(ERR) D
        ..S ERROR="1^flag update error for IFN: "_IFN_" IEN: "_IEN_" PKV: "_PKV
        ..D EM^XUMF1H(ERROR,.ERR) K ERR
        ;
        Q
        ;
STUB    ; -- create record and update VUID with master flag
        ;
        S XREF="B"
        S NAME=$$UNESC($P(HLNODE,HLFS,3),.HL)
        S ROOT=$$ROOT^DILFD(IFN,,1)
        S IEN=$O(@ROOT@(XREF,NAME,0))
        ;
        I IEN D
        .N ROOT
        .S ROOT=$$ROOT^DILFD(IFN,,1)
        .M RECORD("BEFORE")=@ROOT@(IEN)
        .S RECORD("STATUS")=$$GETSTAT^XTID(IFN,,IEN_",")
        ;
        I 'IEN D  Q:ERROR
        .D CHK^DIE(IFN,.01,,NAME,.X)
        .I X="^" S ERROR="1^Error - .01 is invalid"_" File #: "_IFN_" HLNODE="_HLNODE Q
        .K DIC S DIC=IFN,DIC(0)="F" D FILE^DICN K DIC
        .I Y="-1" S ERROR="1^Error - stub entry IFN: "_IFN_" failed HLNODE: "_HLNODE Q
        .S IEN=+Y,RECORD("NEW")=1
        ;
        S:'$G(RECORD("NEW")) ^TMP("XUMF EVENT",$J,IFN,"BEFORE",IEN,"REPLACED BY")=""
        S:'$G(RECORD("NEW")) ^TMP("XUMF EVENT",$J,IFN,"BEFORE",IEN,"INHERITS FROM")=""
        ;
        S IENS=IEN_","
        ;
        ;I $L($P(MFE,U)),$P(MFE,U)'=99.99 Q
        S FDA(IFN,IENS,99.99)=VUID
        S FDA(IFN,IENS,99.98)=1
        ;
        K ERR
        ;
        D FILE^DIE("E","FDA","ERR")
        I $D(ERR) D
        .S ERROR="1^VUID update error IFN: "_IFN_" IEN: "_IEN_" VUID: "_VUID_" HLNODE: "_HLNODE
        .D EM^XUMF1H(ERROR,.ERR) K ERR
        ;
        D ADD^XUMF1H
        ;
        ; clean multiple flag
        K:'$D(XIEN(IEN)) XIEN
        S XIEN(IEN)=$G(XIEN(IEN))+1
        ;
        Q
        ;
VUID(FILE,FIELD,VUID1,X)        ; -- If value type pointer and VUID may be used,
        ; get IEN and set it as internal value
        N X1
        Q:'$L(FILE)!'FIELD!'$L(VUID1) 0
        D FIELD^DID(FILE,FIELD,,"POINTER","X1")
        S X1=$G(X1("POINTER"))
        Q:'$L(X1) 0
        S X1=U_X1_"""AMASTERVUID"",X,1,0)"
        S X1=$O(@X1)
        Q +X1
        ;
VAL(FILE,FIELD,VUID1,VALUE,IENS)        ; convert to internal
        ;
        N RESULT,ERR
        ;
        I $G(VALUE)="" Q "^"
        I $G(VALUE)="""""" Q ""
        ;
        I $L(VUID1) D  Q RESULT
        .S RESULT=$$VUID(FILE,FIELD,VUID,VALUE)
        .I 'RESULT S RESULT="^",ERROR="1^VUID lookup failed on "_VALUE
        ;
        D VAL^DIE(FILE,IENS,FIELD,,VALUE,.RESULT,,"ERR")
        I $D(ERR)!(RESULT="^") D
        .S ERROR="1^data validation error"
        .D EM^XUMF1H(ERROR,.ERR)
        ;
        Q RESULT
        ;
UNESC(VALUE,HL) ;Unescape value
        N RESULT,ESC,ESCFS,ESCCMP,ESCSUB,ESCREP,ESCESC,ESCSEQ,CVRT
        S ESC=$E(HL("ECH"),3)
        S ESCFS=ESC_"F"_ESC S CVRT(ESCFS)=HL("FS")
        S ESCCMP=ESC_"S"_ESC S CVRT(ESCCMP)=$E(HL("ECH"),1)
        S ESCREP=ESC_"R"_ESC S CVRT(ESCREP)=$E(HL("ECH"),2)
        S ESCESC=ESC_"E"_ESC S CVRT(ESCESC)=ESC
        S ESCSUB=ESC_"T"_ESC S CVRT(ESCSUB)=$E(HL("ECH"),4)
        F ESCSEQ=ESCFS,ESCCMP,ESCSUB,ESCREP,ESCESC D
        .F  Q:VALUE'[ESCSEQ  D
        ..S VALUE=$P(VALUE,ESCSEQ,1)_CVRT(ESCSEQ)_$P(VALUE,ESCSEQ,2,9999)
        Q VALUE
        ;
UNESCWP(TEXT,HL)        ;Unescape word processing field
        N ESC,NODE,NXTNODE,BNDBEG,BNDEND,CHECK,SPOT
        S ESC=$E(HL("ECH"),3)
        S NODE=0
        F  S NODE=+$O(TEXT(NODE)) Q:'NODE  D
        .S TEXT(NODE)=$$UNESC(TEXT(NODE),.HL)
        .S BNDBEG=$E(TEXT(NODE),$L(TEXT(NODE))-1,$L(TEXT(NODE)))
        .I BNDBEG[ESC D
        ..S NXTNODE=$O(TEXT(NODE)) Q:'NXTNODE
        ..S BNDEND=$E(TEXT(NXTNODE),1,2)
        ..Q:(BNDEND'[ESC)
        ..S CHECK=$$UNESC(BNDBEG_BNDEND,.HL)
        ..Q:($L(CHECK)=4)
        ..I $E(BNDBEG,1)=ESC D  Q
        ...S TEXT(NODE)=$E(TEXT(NODE),1,$L(TEXT(NODE))-2)_$E(CHECK,1)
        ...S TEXT(NXTNODE)=$E(CHECK,2)_$E(TEXT(NXTNODE),3,$L(TEXT(NXTNODE)))
        ..S TEXT(NODE)=$E(TEXT(NODE),1,$L(TEXT(NODE))-2)_CHECK
        ..S TEXT(NXTNODE)=$E(TEXT(NXTNODE),3,$L(TEXT(NXTNODE)))
        Q
        ;
EM      ; -- error message
        ;
        N X,XMTEXT,XMDUZ,GROUP,XMSUB,XMY
        ;
        D MSG^DIALOG("AM",.X,80,,"ERR")
        ;
        S X(.1)="HL7 message ID: "_$G(HL("MID"))
        S X(.11)="",X(.12)="This message was generated by the NTRT process and MFS.  No action is required on your part."
        S X(.13)="This message is informational and may be used in some instances as a troubleshooting tool."
        S X(.2)="",X(.3)=$G(ERROR)
        S X(.4)="",X(.5)="VUID: "_$G(VUID),X(.6)=""
        S:$G(XMSUB)="" XMSUB="MFS ERROR/WARNING/INFO"
        S XMY("G.XUMF ERROR")="",XMDUZ=.5
        S GROUP=$P($G(^DIC(4.001,+IFN,0)),U,6)
        I GROUP'="" S GROUP="G."_GROUP,XMY(GROUP)=""
        S XMTEXT="X("
        ;
        M X=^TMP("XUMF ERROR",$J)
        ;
        D ^XMD
        ;
        Q
        ;
        ;
EVT     ; -- calls the MFS event protocol
        ;
        N OROLD,X
        K DTOUT,DIROUT
        ;
        I '$D(^TMP("XUMF EVENT")) Q
        ;
        S X=+$O(^ORD(101,"B","XUMF MFS EVENTS",0))_";ORD(101,"
        D EN^XQOR
        ;
        K XQORPOP,X,^TMP("XUMF EVENT",$J) Q
        ;
        Q
        ;
