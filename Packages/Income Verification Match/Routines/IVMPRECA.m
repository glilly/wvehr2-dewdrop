IVMPRECA        ;ALB/KCL/BRM/PJR/RGL/CKN - DEMOGRAPHICS MESSAGE CONSISTENCY CHECK ; 8/15/08 10:26am
        ;;2.0; INCOME VERIFICATION MATCH ;**5,6,12,34,58,56,115**; 21-OCT-94;Build 28
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
        ; This routine will perform data validation checks on uploadable
        ; demographic fields received from the IVM Center to ensure they
        ; are acurate prior to their upload into DHCP.
        ;
        ;
        ; Called from routine IVMPREC6 before uploadable demographic fields
        ; are stored in DHCP.
        ;
        ;
EN      ; - Entry point to create temp array and perform msg consistency checks
        ;
        N DFN,IVMCNTY,IVMCR,IVMEG,IVMFLAG,IVMFLD,IVMNUM,IVMSTR,IVMSTPTR,X
        N COMP,CNTR,NOPID,ADDRTYPE,ADDSEQ,TELESEQ,COMMTYPE,TCFLG,TMPARRY,PID3ARRY,CNTR2
        S IVMNUM=IVMDA ; 'current' line in ^HL(772,"IN",...
        S DODSEG=0 ;Initialize flag for DOD information
        S GUARSEG=0 ;Initialize flag for Guardian information
        ;
        ; - check the format of the HL7 demographic message
        D NEXT I $E(IVMSTR,1,3)'="PID" S HLERR="Missing PID segment" G ENQ
        S CNTR=1,NOPID=0,PIDSTR(CNTR)=$P(IVMSTR,HLFS,2,999)
        ;Handle wrapped PID segment
        F I=1:1 D  Q:NOPID
        . D NEXT I $E(IVMSTR,1,4)="ZPD^" S NOPID=1 Q
        . S CNTR=CNTR+1,PIDSTR(CNTR)=IVMSTR
        D BLDPID^IVMPREC6(.PIDSTR,.IVMPID)  ;Create IVMPID subscript by seq #
        ;convert "" to null for PID segment
        S CNTR="" F  S CNTR=$O(IVMPID(CNTR)) Q:CNTR=""  D
        . I $O(IVMPID(CNTR,"")) D  Q
        . . S CNTR2="" F  S CNTR2=$O(IVMPID(CNTR,CNTR2)) Q:CNTR2=""  D
        . . . S IVMPID(CNTR,CNTR2)=$$CLEARF(IVMPID(CNTR,CNTR2),$E(HLECH))
        . I CNTR=11 S IVMPID(CNTR)=$$CLEARF(IVMPID(CNTR),$E(HLECH)) Q
        . I IVMPID(CNTR)=HLQ S IVMPID(CNTR)=""
        I $E(IVMSTR,1,3)'="ZPD" S HLERR="Missing ZPD segment" G ENQ
        S IVMSTR("ZPD")=$P(IVMSTR,HLFS,2,999)
        I $P(IVMSTR("ZPD"),HLFS,8)'="" S GUARSEG=1
        I $P(IVMSTR("ZPD"),HLFS,9)'="" S DODSEG=1
        D NEXT I $E(IVMSTR,1,3)="ZEL" S HLERR="ZEL segment should not be sent in Z05 message" G ENQ
        I $E(IVMSTR,1,3)'="ZGD" S HLERR="Missing ZGD segment" G ENQ
        S IVMSTR("ZGD")=$P(IVMSTR,HLFS,2,999)
        ;
        ; - perform field validation checks for PID segment
        M TMPARRY(3)=IVMPID(3) D PARSPID3^IVMUFNC(.TMPARRY,.PID3ARY)
        S DFN=$G(PID3ARY("PI")),ICN=$G(PID3ARY("NI"))
        K TMPARRY,PID3ARY
        I '$$MATCH^IVMUFNC(DFN,ICN,"","","I",.ERRMSG) S HLERR=ERRMSG G ENQ
        S IVMDFN=DFN  ;Store DFN in temp variable to use later
        ;I IVMPID(19)'=$P(^DPT(DFN,0),"^",9) S HLERR="Couldn't match IVM SSN with DHCP SSN" G ENQ
        ;
        S X=IVMPID(7) I X]"",($$FMDATE^HLFNC(X)>DT) S HLERR="Date of Birth greater than current date" G ENQ
        ;
        S X=IVMPID(8) I X]"",X'="M",X'="F" S HLERR="Invalid code sent for Patient sex" G ENQ
        ;
        ; - if address - perform validation checks on addr fields
        ;Get all address from seq. 11 of PID segment
        I 'DODSEG,'GUARSEG D
        . D PID11 Q:$D(HLERR)
        . D PID13
        G ENQ:$D(HLERR)
        ;
        ; - perform field validation check for ZPD and ZGD segment
        ; - I X]"" was changed to I X below for IVM*2*56
        S X=$P(IVMSTR("ZPD"),HLFS,9) I X,($$FMDATE^HLFNC(X)<$P($G(^DPT(+DFN,0)),"^",3))!($$FMDATE^HLFNC(X)>$$DT^XLFDT) S HLERR="Invalid date of death" G ENQ
        S X=$P(IVMSTR("ZGD"),HLFS,2) I X,X'=1 S HLERR="Invalid Guardian Type" G ENQ
        ;
        ;
ENQ     ; - send acknowledgement (ACK) 'AE' msg to the IVM Center
        I $D(HLERR) D ACK^IVMPREC
        Q
        ;
        ;
ADDRCHK ; - validate address fields sent by IVM Center
        ;
        S CNTRY=$P(X,$E(HLECH),6) I CNTRY']"" S HLERR="Invalid address - Missing Country" Q
        I '$$CNTRCONV^IVMPREC8(CNTRY) S HLERR="Invalid address - Invalid Country" Q
        S FORFLG=$S(CNTRY="USA":0,1:1)
        I $P(X,$E(HLECH),1)']"" S HLERR="Invalid address - Missing street address [line 1]" Q
        I $P(X,$E(HLECH),3)']"" S HLERR="Invalid address - Missing city" Q
        ;I $P(X,$E(HLECH),4)']"" S HLERR="Invalid address - Missing "_$S('FORFLG:"state abbreviation",1:"province") Q
        ;I $P(X,$E(HLECH),5)']"" S HLERR="Invalid address - Missing "_$S('FORFLG:"zip code",1:"postal code") Q
        I $P(X,$E(HLECH),4)']"",'FORFLG S HLERR="Invalid address - Missing State abbreviation" Q
        I $P(X,$E(HLECH),5)']"",'FORFLG S HLERR="Invalid address - Missing Zip Code" Q
        I 'FORFLG D  Q:$D(HLERR)
        . S IVMCNTY=$G(IVMPID(12))
        . I IVMCNTY']"" S HLERR="Invalid address - Missing county code" Q
        I $L($P(X,$E(HLECH),1))>35!($L($P(X,$E(HLECH),1))<3) S HLERR="Invalid street address [line 1]" Q
        I $P(X,$E(HLECH),2)]"",(($L($P(X,$E(HLECH),2))>30)!($L($P(X,$E(HLECH),2))<3)) S HLERR="Invalid street address [line 2]" Q
        I $L($P(X,$E(HLECH),3))>15!($L($P(X,$E(HLECH),3))<2) S HLERR="Invalid city" Q
        ;
        ; - save state pointer for county code validation only if not foreign address
        I 'FORFLG D  Q:$D(HLERR)
        .S IVMSTPTR=+$O(^DIC(5,"C",$P(X,$E(HLECH),4),0))
        .I 'IVMSTPTR S HLERR="Invalid state abbreviation" Q
        .I '$O(^DIC(5,IVMSTPTR,1,"C",IVMCNTY,0)) D  Q:$G(HLERR)]""
        ..N STFIPS
        ..S STFIPS=IVMSTPTR
        ..S:$L(STFIPS)<2 STFIPS="0"_STFIPS
        ..Q:$$FIPSCHK^XIPUTIL(STFIPS_IVMCNTY)  ;county code is valid
        ..S HLERR="Invalid county code"
        .S X=$P(X,$E(HLECH),5) D ZIPIN^VAFADDR I $D(X)[0 S HLERR="Invalid zip code" Q
        Q
        ;
        ;
NEXT    ; - get the next HL7 segment in the message from HL7 Transmission (#772) file
        S IVMNUM=$O(^TMP($J,IVMRTN,IVMNUM)),IVMSTR=$G(^(+IVMNUM,0))
        Q
PID11   ; Perform consistency check for seq. 11
        I $D(IVMPID(11)) D
        . I $O(IVMPID(11,"")) D  Q
        . . S ADDSEQ=0 F  S ADDSEQ=$O(IVMPID(11,ADDSEQ)) Q:ADDSEQ=""!($D(HLERR))  D
        . . . I $G(IVMPID(11,ADDSEQ))="" S HLERR="Invalid Address - Missing Address information" Q
        . . . S ADDRTYPE=$P($G(IVMPID(11,ADDSEQ)),$E(HLECH),7)
        . . . I ADDRTYPE="" S HLERR="Invalid Address - Missing Address Type" Q
        . . . I ADDRTYPE="P"!(ADDRTYPE="VAB1")!(ADDRTYPE="VAB2")!(ADDRTYPE="VAB3")!(ADDRTYPE="VAB4") S ADDRESS(ADDRTYPE)=IVMPID(11,ADDSEQ)
        . I $G(IVMPID(11))="" S HLERR="Invalid Address - Missing Address information" Q
        . S ADDRTYPE=$P($G(IVMPID(11)),$E(HLECH),7)
        . I ADDRTYPE="" S HLERR="Invalid Address - Missing Address Type" Q
        . I ADDRTYPE="P"!(ADDRTYPE="VAB1")!(ADDRTYPE="VAB2")!(ADDRTYPE="VAB3")!(ADDRTYPE="VAB4") S ADDRESS(ADDRTYPE)=IVMPID(11)
        Q:$D(HLERR)
        ;perform consistency checks on Permanent and all bad address
        I '$D(ADDRESS) S HLERR="Invalid Address - Invalid Address Type" Q
        S ADDRTYPE="" S ADDRTYPE=$O(ADDRESS(ADDRTYPE)) D
        . S X=$G(ADDRESS(ADDRTYPE)) D ADDRCHK
        Q
        ;
PID13   ; Perform consistency checks for seq. 13
        ;Get communication data for all types from seq. 13 or PID segment
        S TCFLG=1 ;Flag to check if Telecom data exist.
        I $D(IVMPID(13)) D
        . I $O(IVMPID(13,"")) D  Q
        . . S TELESEQ=0 F  S TELESEQ=$O(IVMPID(13,TELESEQ)) Q:((TELESEQ="")!($D(HLERR))!('TCFLG))  D
        . . . I $G(IVMPID(13,TELESEQ))="" S TCFLG=0 Q
        . . . I $P(IVMPID(13,TELESEQ),$E(HLECH),2)="" S HLERR="Invalid Communication Data - Missing Communication Type - PID Seq 13" Q
        . . . S TELECOM($P(IVMPID(13,TELESEQ),$E(HLECH),2))=IVMPID(13,TELESEQ)
        . I $G(IVMPID(13))="" S TCFLG=0 Q
        . I $P(IVMPID(13),$E(HLECH),2)="" S HLERR="Invalid Communication Data - Missing Communication Type - PID Seq 13" Q
        . S TELECOM($P(IVMPID(13),$E(HLECH),2))=IVMPID(13)
        Q:$D(HLERR)
        ;perform consistency checks on all types of communication data.
        I TCFLG D
        . S COMMTYPE="" F  S COMMTYPE=$O(TELECOM(COMMTYPE)) Q:COMMTYPE=""!$D(HLERR)  D
        . . I COMMTYPE="NET" D  Q
        . . . S X=$P(TELECOM(COMMTYPE),$E(HLECH),4)
        . . . I X]"",'$$CHKEMAIL^IVMPREC8(X) S HLERR="Invalid Email address"
        . . S X=$P(TELECOM(COMMTYPE),$E(HLECH)) I X]"",(($L(X)>20)!($L(X)<4)) S HLERR="Invalid phone number"
        Q
        ;
CLEARF(NODE,DEL,IGNORE) ;
        ; Input:       NODE    - SEGMENT/SEQ.
        ;               DEL    - Delimiter (optional - default is ^)
        ;            IGNORE    - String of seq # to avoid (optional)
        N I
        I $G(DEL)="" S DEL=HLFS
        F I=1:1:$L(NODE,DEL) D
        . I $G(IGNORE)[(","_I_",") Q  ;Ignore this seq. to convert
        . I $P(NODE,DEL,I)=HLQ S $P(NODE,DEL,I)=""
        Q NODE
