MDHL7X  ; HOIFO/WAA -Generate HL7 Error Message ; 06/08/00
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; Reference IA #1131 for ^XMB("NETNAME") access.
        ; Reference IA #2165 for HLMA1 calls.
        ; Reference IA #2729 for XMXAPI calls.
        D GENERR,GENACK Q
GENERR  ; Generate error message
        N TXT,INST,MG,XMTO,XMDUZ,XMSUBJ,XMBODY,N,X S MG=0
        S INST=DEVIEN
        I INST>1 S MG=$P($G(^MDS(702.09,INST,0)),"^",2)
        I 'MG!('$$MG^MDHL7U2(MG)) S MG=$$FIND1^DIC(3.8,"","BX","MD DEVICE ERRORS") Q:'MG
        S MG=$$GET1^DIQ(3.8,+MG_",",.01)
        S XMTO="G."_MG_"@"_^XMB("NETNAME"),XMINSTR("FROM")=.5
        I '$D(X) S X=$G(ECODE(0))
        S TXT(1)=ERRTX,TXT(2)=X,TXT(3)=" "
        S N=3
        I '$G(ECODE,1) D  ; This is to process Device errors
        . N X
        . S X=0
        . F  S X=$O(ECODE(X)) Q:X<1  S N=N+1,TXT(N)=ECODE(X)
        . S N=N+1,TXT(N)=" "
        . Q
        F X="MSH","PID","OBR","OBX" I $D(SEG(X)) S N=N+1,TXT(N)=SEG(X)
        S XMSUBJ="A Clinical Instrument HL7 Error has occurred."
        S XMBODY="TXT"
        D SENDMSG^XMXAPI(DUZ,XMSUBJ,XMBODY,XMTO,.XMINSTR)
        Q
GENACK  ; Generate an HL7 ACK message
        ; Reference IA #2165 for GENACK^HLMA1 call
        N HLA,HLEID,HLEIDS,HLARYTYP,HLFORMAT,HLRESLTA
        S HLA("HLA",1)="MSA"_HL("FS")_$S($D(ERRTX):"AR",1:"AA")_HL("FS")_HL("MID")_$S($D(ERRTX):HL("FS")_ERRTX,1:"")
        S HLEID=HL("EID"),HLEIDS=HL("EIDS"),HLARYTYP="LM",HLFORMAT=1,HLRESLTA=HL("MID")
        D GENACK^HLMA1(HLEID,HLMTIENS,HLEIDS,HLARYTYP,HLFORMAT,.HLRESTLA)
        N ERRTX Q
