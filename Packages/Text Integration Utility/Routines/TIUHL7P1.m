TIUHL7P1        ; SLC/AJB - TIUHL7 Msg Processing; January 6, 2006
        ;;1.0;TEXT INTEGRATION UTILITIES;**200,228**;Jun 20, 1997
        Q
PROCMSG ;
        N DFN,DUZ,TIU,TIUDA,TIUDPRM,TIUDT,TIUERR,TIUI,TIUJ,TIUMSG,TIUNAME,TIUTMP,TIUFS,TIUCS,TIURS,TIUES,TIUSS,TIUZ
        ;
        ; quit if HL7 Message IEN is not present
        ;I '+$G(HLMTIENS) Q
        ;
        ; remove HL7 message entries 7 days or older
        D CLEAN^TIUHL7U1
        ;
        ; sets field, component and repetition separators from HL7 Message
        S TIUFS=$G(HL("FS")),TIUJ=0 F TIUI="TIUCS","TIURS","TIUES","TIUSS" S TIUJ=TIUJ+1 S @TIUI=$E(HL("ECH"),TIUJ,TIUJ)
        ;
        ; initializes variables and ^XTMP expiration
        S TIU="TIU",(TIU("EC"),TIUDA)=0,TIUDT=+$$NOW^XLFDT,TIUNAME=$NA(^XTMP("TIUHL7",TIUDT,HLMTIENS)),^XTMP("TIUHL7",0)=$$FMADD^XLFDT(TIUDT,7)_U_TIUDT
        ;
        ; retrieves HL7 message and stores to temporary global
        F TIUI=1:1 X HLNEXT Q:HLQUIT'>0  D
        . S @TIUNAME@("MSG",TIUI)=HLNODE,TIUJ=0
        . F  S TIUJ=$O(HLNODE(TIUJ)) Q:'TIUJ  S @TIUNAME@("MSG",TIUI)=@TIUNAME@("MSG",TIUI)_HLNODE(TIUJ)
        ;
        ; places temporary global in local meory & adds EOM flag
        M TIUMSG=@TIUNAME@("MSG")
        S TIU("XTMP")=TIUNAME,TIUNAME="TIUMSG",TIUI="",TIUI=$O(TIUMSG(TIUI),-1),TIUI=TIUI+1,TIUMSG(TIUI)="EOM"
        ;
        ; verify message format
        S TIUI="" F  S TIUI=$O(@TIUNAME@(TIUI)) Q:@TIUNAME@(TIUI)="EOM"  D
        . S TIUJ=$S(TIUI=1:"MSH",TIUI=2:"EVN",TIUI=3:"PID",TIUI=4:"PV1",TIUI=5:"TXA",TIUI=6:"OBX",1:"OBX")
        . I $P(@TIUNAME@(TIUI),TIUFS)'=TIUJ D ERR^TIUHL7U1("MSG",1,"000.000","Improper/missing message format: "_TIUJ_" segment.")
        ;
        ; if message fails check, quit processing
        I +TIU("EC") D ACK^TIUHL7U1("AR",TIUNAME,-1) Q
        ;
        ; get patient name [required]
        S TIU("PTNAME")=$$UPPER^HLFNC($$FMNAME^HLFNC($P($P($G(@TIUNAME@(3)),TIUFS,6),TIUCS,1,4),TIUCS)),TIU("PTNAME")=$$REMESC^TIUHL7U1(TIU("PTNAME"))
        ;
        ; get patient ICN/SSN/DFN - order may vary [conditionally required]
        S (TIU("DFN"),TIU("ICN"),TIU("SSN"))="" F TIUI=1:1:$L($P($G(@TIUNAME@(3)),TIUFS,4),TIURS) S TIUJ=$P($P($G(@TIUNAME@(3)),TIUFS,4),TIURS,TIUI) I +TIUJ>0 D
        . S TIUTMP=$S($P(TIUJ,TIUCS,5)="NI":"ICN",$P(TIUJ,TIUCS,5)="SS":"SSN",$P(TIUJ,TIUCS,5)="PI":"DFN",1:"UNK")
        . S @TIU@(TIUTMP)=$$REMESC^TIUHL7U1($P(TIUJ,TIUCS)) I TIUTMP="ICN",@TIU@(TIUTMP)["V" S @TIU@(TIUTMP)=$P(@TIU@(TIUTMP),"V")
        ;
        ; get PATIENT DOB (optional)
        S TIU("DOB")=$$HL7TFM^XLFDT($$REMESC^TIUHL7U1($P($G(@TIUNAME@(3)),TIUFS,8)))
        ;
        ; get DOCUMENT TITLE (#8925.1) [required] & set IEN
        S TIU("TITLE")=$$UPPER^HLFNC($P($G(@TIUNAME@(5)),TIUFS,17)),TIU("TITLE")=$$REMESC^TIUHL7U1(TIU("TITLE"))
        S TIU("TDA")=$$LU^TIUHL7U1(8925.1,TIU("TITLE"),"X","I $P(^TIU(8925.1,+Y,0),U,4)=""DOC""") I $L(TIU("TITLE"))'>0 S TIU("TITLE")="[UNKNOWN]"
        ;
        ; get DOCUMENT AVAILABILITY [optional]
        S TIU("AVAIL")=$$REMESC^TIUHL7U1($P($G(@TIUNAME@(5)),TIUFS,20))
        ;
        ;gets DOCUMENT COMPLETION STATUS [optional]
        S TIU("COMP")=$$REMESC^TIUHL7U1($P($G(@TIUNAME@(5)),TIUFS,18))
        ;
        ; get REFERENCE DATE [required]
        S TIU("RFDT")=$$HL7TFM^XLFDT($$REMESC^TIUHL7U1($P($G(@TIUNAME@(5)),TIUFS,5))) I TIU("RFDT")'>-1 D ERR^TIUHL7U1("TXA",4,"0000.00","Invalid HL7 date format for ACTIVITY DATE/TIME[REFERENCE DATE/TIME].")
        I +$P(TIU("RFDT"),"."),'+$P(TIU("RFDT"),".",2) S $P(TIU("RFDT"),".",2)=$P($$NOW^XLFDT,".",2)
        ;
        ; get EPISODE BEGIN DT/TIME [conditionally required for DISCHARGE SUMMARIES]
        S TIU("EPDT")=$$HL7TFM^XLFDT($$REMESC^TIUHL7U1($P($G(@TIUNAME@(4)),TIUFS,45))) I TIU("EPDT")'>-1 D ERR^TIUHL7U1("PV1",44,"0000.00","Invalid HL7 date format for ADMIT DATE/TIME [EPISODE BEGIN DATE/TIME].")
        I +$P(TIU("EPDT"),"."),'+$P(TIU("EPDT"),".",2) S $P(TIU("EPDT"),".",2)=$P($$NOW^XLFDT,".",2)
        ;
        ; get DICTATION DT/TIME [optional]
        S TIU("DICDT")=$$HL7TFM^XLFDT($$REMESC^TIUHL7U1($P($G(@TIUNAME@(5)),TIUFS,7))) I TIU("DICDT")'>-1 D ERR^TIUHL7U1("TXA",6,"0000.00","Invalid HL7 date format for TRANSCRIPTION DATE/TIME[DICTATION DATE/TIME].")
        I +$P(TIU("DICDT"),"."),'+$P(TIU("DICDT"),".",2) S $P(TIU("DICDT"),".",2)=$P($$NOW^XLFDT,".",2)
        ;
        ; get VISIT # [optional]
        S TIU("VNUM")=$$REMESC^TIUHL7U1($P($G(@TIUNAME@(4)),TIUFS,20))
        ;
        ; get HOSPITAL LOCATION [conditionally required for NEW VISITS]
        S TIU("HLOC")=$$REMESC^TIUHL7U1($P($P($G(@TIUNAME@(4)),TIUFS,4),TIUCS)) I +$L(TIU("HLOC")) S TIU("HLOC")=+$$LU^TIUHL7U1(44,TIU("HLOC"))
        ;
        ; get AUTHOR/DICTATOR SSN or IEN [optional] & NAME [required]
        S TIUTMP=$S($P($P($G(@TIUNAME@(5)),TIUFS,10),TIUCS,9)'="USSSA":"AUDA",1:"AUSSN") S @TIU@(TIUTMP)=$P($P($G(@TIUNAME@(5)),TIUFS,10),TIUCS)
        S TIU("AUNAME")=$$UPPER^HLFNC($$FMNAME^HLFNC($P($P($G(@TIUNAME@(5)),TIUFS,10),TIUCS,2,4),TIUCS)),TIU("AUNAME")=$$REMESC^TIUHL7U1(TIU("AUNAME"))
        ;
        ; get EXPECTED COSIGNER SSN or IEN [optional] & NAME [conditionally required]
        S TIUTMP=$S($P($P($G(@TIUNAME@(5)),TIUFS,11),TIUCS,9)'="USSSA":"CSDA",1:"CSSSN") S @TIU@(TIUTMP)=$P($P($G(@TIUNAME@(5)),TIUFS,11),TIUCS)
        S TIU("CSNAME")=$$UPPER^HLFNC($$FMNAME^HLFNC($P($P($G(@TIUNAME@(5)),TIUFS,11),TIUCS,2,4),TIUCS)),TIU("CSNAME")=$$REMESC^TIUHL7U1(TIU("CSNAME"))
        ;
        ; get ENTERED BY SSN or IEN [optional] & NAME [optional]
        S TIUTMP=$S($P($P($G(@TIUNAME@(5)),TIUFS,12),TIUCS,9)'="USSSA":"EBDA",1:"EBSSN") S @TIU@(TIUTMP)=$P($P($G(@TIUNAME@(5)),TIUFS,12),TIUCS)
        S TIU("EBNAME")=$$UPPER^HLFNC($$FMNAME^HLFNC($P($P($G(@TIUNAME@(5)),TIUFS,12),TIUCS,2,4),TIUCS)),TIU("EBNAME")=$$REMESC^TIUHL7U1(TIU("EBNAME"))
        ;
        ; get SURGICAL CASE or CONSULT # [conditionally required for SURGICAL REPORTS or CONSULT titles]
        S TIUTMP=$S($$MEMBEROF^TIUHL7U1(TIU("TITLE"),"CONSULTS"):"CNCN",1:"SRCN") S @TIU@(TIUTMP)=$$REMESC^TIUHL7U1($P($P($G(@TIUNAME@(5)),TIUFS,13),TIUCS))
        ;
        ; gets SIGNATURE/COSIGNATURE DATE/TIME [optional]
        S TIU("SIGNED")=$$REMESC^TIUHL7U1($P($P($G(@TIUNAME@(5)),TIUFS,23),TIUCS,15)),TIU("CSIGNED")=$$REMESC^TIUHL7U1($P($P($G(@TIUNAME@(5)),TIUFS,23),TIUCS,29))
        ;
        ; get DOCUMENT TEXT [required]
        S TIUTMP="" F  S TIUTMP=$O(@TIUNAME@(TIUTMP)) Q:TIUTMP=""  D:$P($G(@TIUNAME@(TIUTMP)),TIUFS)="OBX"
        . I $P(@TIUNAME@(TIUTMP),TIUFS,2)=1,$L($G(TIU("SUB")))'>0 S TIU("SUB")=$P($P(@TIUNAME@(TIUTMP),TIUFS,4),TIUCS,2),TIU("SUB")=$$REMESC^TIUHL7U1(TIU("SUB"))
        . F TIUI=1:1:$L($P(@TIUNAME@(TIUTMP),TIUFS,6),TIURS) S TIUZ("TEXT",TIUI,0)=$P($P(@TIUNAME@(TIUTMP),TIUFS,6),TIURS,TIUI),TIUZ("TEXT",TIUI,0)=$$STRIP^TIUHL7U2($$REMESC^TIUHL7U1(TIUZ("TEXT",TIUI,0)))
        ;
        ; begin data verification
        ; PATIENT IDENTIFICATION
        D
        . N TIUI,TIUJ,TIUERR,TIUN,TIUOUT,TIUTMP,TIUQUIT
        . I '+$L($G(TIU("PTNAME"))) D ERR^TIUHL7U1("PID",5,"0000.00","Missing PATIENT NAME.")
        . ; verify there is at least one piece of numeric PATIENT ID
        . S TIUJ=0 F TIUI="ICN","DFN","SSN" S:+$G(TIU(TIUI)) TIUJ=TIUJ+1
        . I '+TIUJ D ERR^TIUHL7U1("PID",5,"0000.00","Missing numeric PATIENT ID data; at least one numeric identifier [ICN,SSN,DFN] must be sent.") Q
        . I +TIUJ=1 D
        . . I '+$L($P(TIU("PTNAME"),",",2)) D ERR^TIUHL7U1("PID",5,"0000.00","FIRST NAME/INITIAL missing with only one numeric identifier sent.")
        . . S TIUN("PT")=$$PNAME^TIUHL7U1(TIU("PTNAME")),TIUTMP=1
        . E  S TIUN("PT")=$P(TIU("PTNAME"),",")
        . S TIUJ=0
        . ; check DFN if available
        . I +$G(TIU("DFN")) S TIUJ=TIUJ+1,DFN(TIUJ)=TIU("DFN") D
        . . I +$G(TIUTMP) S TIUN("DFN")=$$PNAME^TIUHL7U1($$GET1^DIQ(2,TIU("DFN"),.01))
        . . E  S TIUN("DFN")=$P($$GET1^DIQ(2,TIU("DFN"),.01),",")
        . . I '$$COMPARE^TIUHL7U1(TIUN("DFN"),TIUN("PT")) D ERR^TIUHL7U1("PID",5,"0000.00","PATIENT NAME discrepancy between HL7 message name ["_TIU("PTNAME")_"] & the HL7 message DFN #"_TIU("DFN")_" ["_$$GET1^DIQ(2,DFN(TIUJ),.01)_"].")
        . ; check ICN if available
        . I +$G(TIU("ICN")) S TIUJ=TIUJ+1,DFN(TIUJ)=+$$FIND1^DIC(2,"","X",TIU("ICN"),"AICN") D
        . . I +$G(TIUTMP) S TIUN("ICN")=$$PNAME^TIUHL7U1($$GET1^DIQ(2,DFN(TIUJ),.01))
        . . E  S TIUN("ICN")=$P($$GET1^DIQ(2,DFN(TIUJ),.01),",")
        . . I '$$COMPARE^TIUHL7U1(TIUN("ICN"),TIUN("PT")) D ERR^TIUHL7U1("PID",5,"0000.00","PATIENT NAME discrepancy between HL7 message name ["_TIU("PTNAME")_"] & the HL7 message ICN #"_TIU("ICN")_" ["_$$GET1^DIQ(2,DFN(TIUJ),.01)_"].")
        . ; check SSN if available
        . I +$G(TIU("SSN")) S TIUJ=TIUJ+1,DFN(TIUJ)=+$$FIND1^DIC(2,"","X",TIU("SSN"),"SSN") D
        . . I +$G(TIUTMP) S TIUN("SSN")=$$PNAME^TIUHL7U1($$GET1^DIQ(2,DFN(TIUJ),.01))
        . . E  S TIUN("SSN")=$P($$GET1^DIQ(2,DFN(TIUJ),.01),",")
        . . I '$$COMPARE^TIUHL7U1(TIUN("SSN"),TIUN("PT")) D ERR^TIUHL7U1("PID",5,"0000.00","PATIENT NAME discrepancy between HL7 message name ["_TIU("PTNAME")_"] & the HL7 message SSN #"_TIU("SSN")_" ["_$$GET1^DIQ(2,DFN(TIUJ),.01)_"].")
        . ; compare DFN lookup values
        . I TIUJ>1 S (TIUI,TIUJ)=0 F  S TIUI=$O(DFN(TIUI)) Q:'TIUI  I TIUI>1 S TIUJ=TIUI-1 I DFN(TIUI)'=DFN(TIUJ) D ERR^TIUHL7U1("PID",5,"0000.00","PATIENT IEN discrepancies between the numeric lookups.") Q
        . I TIU("EC") Q
        . S DFN=DFN(1)
        ;
        D CONTINUE^TIUHL7P2
        Q
