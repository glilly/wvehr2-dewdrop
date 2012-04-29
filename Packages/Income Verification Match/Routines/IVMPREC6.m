IVMPREC6        ;ALB/KCL/BRM/CKN - PROCESS INCOMING (Z05 EVENT TYPE) HL7 MESSAGES ; 1/3/07 2:58pm
        ;;2.0; INCOME VERIFICATION MATCH ;**3,4,12,17,34,58,79,102,115**; 21-OCT-94;Build 28
        ;;Per VHA Directive 10-93-142, this routine should not be modified.
        ;
        ; This routine will process batch ORU demographic (event type Z05) HL7
        ; messages received from the IVM center.  Format of HL7 batch message:
        ;
        ;       BHS
        ;       {MSH
        ;        PID
        ;        ZPD
        ;        ZGD
        ;        RF1 (optional)
        ;       }
        ;       BTS
        ;
        ;
EN      ; - entry point to process HL7 patient demographic message
        ;
        N DGENUPLD,VAFCA08,DGRUGA08,COMP,DODSEG,GUARSEG
        ;
        ; prevent a return Z07 when uploading a Z05 (Patient file triggers)
        S DGENUPLD="ENROLLMENT/ELIGIBILITY UPLOAD IN PROGRESS"
        ;
        ; prevent MPI A08 message when uploading Z05 (Patient file triggers)
        S VAFCA08=1  ;MPI/CIRN A08 suppression flag
        ;
        S IVMFLG=0,IVMADFLG=0
        ; - get incoming HL7 message from HL7 Transmission (#772) file
        F IVMDA=0:0 S IVMDA=$O(^TMP($J,IVMRTN,IVMDA)) Q:'IVMDA  S IVMSEG=$G(^(IVMDA,0)) I $E(IVMSEG,1,3)="MSH" D
        .K HLERR
        .;
        .; - message control id from MSH segment
        .S MSGID=$P(IVMSEG,HLFS,10),HLMID=MSGID
        .;
        .; - perform demographics message consistency check
        .D EN^IVMPRECA Q:$D(HLERR)
        .;
        .;Set array of Email, Cell, Pager fields
        .D EPCFLDS(.EPCFARY,.EPCDEL)
        .; - get next msg segment
        .D NEXT I $E(IVMSEG,1,3)'="PID" D  Q
        ..S HLERR="Missing PID segment" D ACK^IVMPREC
        .;
        .F I=1:1 D NEXT Q:$E(IVMSEG,1,4)="ZPD^"  ;Go through all PID
        .; - patient IEN (DFN) from PID segment
        .;Use IVMPID array created in IVMPRECA while performing consistency
        .;to process PID segment
        .;
        .;I '$G(IVMDFN) S HLERR="Invalid DFN" D ACK^IVMPREC  Q
        .S DFN=$G(IVMDFN)
        .;I ('DFN!(DFN'=+DFN)!('$D(^DPT(+DFN,0)))) D  Q
        .;.S HLERR="Invalid DFN" D ACK^IVMPREC
        .;I IVMPID(19)'=$P(^DPT(DFN,0),"^",9) D  Q
        .;.S HLERR="Couldn't match HEC SSN with DHCP SSN" D ACK^IVMPREC
        .;
        .; - check for entry in IVM PATIENT file, otherwise create stub entry
        .S IVM3015=$O(^IVM(301.5,"B",DFN,0))
        .I 'IVM3015 S IVM3015=$$LOG^IVMPLOG(DFN,DT)
        .I 'IVM3015 D  Q
        ..S HLERR="Failed to create entry in IVM PATIENT file"
        ..D ACK^IVMPREC
        .;
        .; - compare PID segment fields with DHCP fields
        .S IVMSEG="PID"  ;Setting IVMSEG to PID before it calls COMPARE
        .I 'DODSEG,'GUARSEG D COMPARE(IVMSEG) Q:$D(HLERR)
        .;
        .; - get next msg segment -decrement the counter so it can pickup ZPD
        .S IVMDA=IVMDA-1 D NEXT I $E(IVMSEG,1,3)'="ZPD" D  Q
        ..S HLERR="Missing ZPD segment" D ACK^IVMPREC
        .;Convert "" to null in ZPD segment except seq. 8,9, 31 and 32
        .S IVMSEG=$$CLEARF^IVMPRECA(IVMSEG,HLFS,",9,10,32,33,")
        .;
        .; - compare ZPD segment fields with DHCP fields
        .D COMPARE(IVMSEG)
        .;
        .; - get next msg segment
        .D NEXT I $E(IVMSEG,1,3)="ZEL" D  Q
        ..S HLERR="ZEL segment should not be sent in Z05 message" D ACK^IVMPREC
        .;
        .; - get next msg segment
        .I $E(IVMSEG,1,3)'="ZGD" D  Q
        ..S HLERR="Missing ZGD segment" D ACK^IVMPREC
        .;
        .; - compare ZGD segment fields with DHCP fields
        .; convert "" to null for ZGD segment
        .S IVMSEG=$$CLEARF^IVMPRECA(IVMSEG,HLFS,",7,") ;ignore seq. 6
        .; convert seq. 6 separately
        .S $P(IVMSEG,HLFS,7)=$$CLEARF^IVMPRECA($P(IVMSEG,HLFS,7),$E(HLECH))
        .D COMPARE(IVMSEG)
        .;S IVMFLG=0
        .;
        .; - check for RF1 segment and get segment if it exists
        .;     This process will automatically update patient address data
        .;     in the Patient (#2) file if the incoming address is more
        .;     recent than the existing one.
        .;Modified code to handle multiple RF1 segment - IVM*2*115
        .S (UPDEPC("SAD"),UPDEPC("CPH"),UPDEPC("PNO"),UPDEPC("EAD"))=0
        .S QFLG=0 I $$RF1CHK(IVMRTN,IVMDA) F I=1:1 D  Q:QFLG
        ..D NEXT
        ..S IVMSEG=$$CLEARF^IVMPRECA(IVMSEG,HLFS,",7,") ;ignore seq. 6
        ..S $P(IVMSEG,HLFS,7)=$$CLEARF^IVMPRECA($P(IVMSEG,HLFS,7),$E(HLECH))
        ..I $P(IVMSEG,HLFS,4)="" S QFLG=1 Q  ;Quit if RF1 is blank
        ..D COMPARE(IVMSEG)
        ..I '$$RF1CHK(IVMRTN,IVMDA) S QFLG=1
        .S IVMFLG=0
        ;
        ; - send mail message if necessary
        I IVMCNTR D MAIL^IVMUFNC()
        ; Cleanup variables if no msg necessary
        I 'IVMCNTR K IVMTEXT,XMSUB
        ;
ENQ     ; - cleanup variables
        K DA,DFN,IVMADDR,IVMADFLG,IVMDA,IVMDHCP,IVMFLAG,IVMFLD,IVMPIECE,IVMSEG,IVMSTART,IVMXREF,DGENUPLD,IVMPID,PIDSTR,ADDRESS,TELECOM,UPDEPC,EPCFARY,IVMDFN,DODSEG,EPCDEL,GUARSEG
        Q
        ;
        ;
NEXT    ; - get the next HL7 segment in the message from HL7 Transmission (#772) file
        ;
        S IVMDA=$O(^TMP($J,IVMRTN,IVMDA)),IVMSEG=$G(^(+IVMDA,0))
        Q
        ;
        ;
COMPARE(IVMSEG) ; - compare incoming HL7 segment/fields with DHCP fields
        ;
        ;  Input:  IVMSEG  --  as the text of the incoming HL7 message
        ;
        ; Output:  None
        ;
        ; - get 3 letter HL7 segment name
        S IVMXREF=$P(IVMSEG,HLFS,1),IVMSTART=IVMXREF
        ;
        ; - strip off HL7 segment name
        S IVMSEG=$P(IVMSEG,HLFS,2,99)
        ;
        ; - roll through "C" x-ref in IVM Demographic Upload Fields (#301.92) file
        F  S IVMXREF=$O(^IVM(301.92,"C",IVMXREF)) Q:IVMXREF']""  D
        .S IVMDEMDA=$O(^IVM(301.92,"C",IVMXREF,"")) Q:IVMDEMDA']""
        .I $$INACTIVE(IVMDEMDA) Q
        .;
        .; - compare incoming HL7 segment fields with DHCP fields
        .I IVMXREF["PID",(IVMSTART["PID") D PID^IVMPREC8
        .I IVMXREF["ZPD",(IVMSTART["ZPD") D ZPD^IVMPREC8
        .I IVMXREF["ZGD",(IVMSTART["ZGD") D ZGD^IVMPREC8
        .I IVMXREF["RF1",(IVMSTART["RF1") D RF1^IVMPREC8
        Q
        ;
        ;
DEMBULL ; -  build mail message for transmission to IVM mail group notifying
        ;    them that patients with updated demographic data has been received
        ;    from the IVM Center and may now be uploaded into DHCP.
        ;
        ; If record is auto uploaded, don't add veteran to bulletin
        I $$CKAUTO Q
        ;
        S IVMPTID=$$PT^IVMUFNC4(DFN)
        S XMSUB="IVM - DEMOGRAPHIC UPLOAD for "_$P($P(IVMPTID,"^"),",")_" ("_$P(IVMPTID,"^",3)_")"
        S IVMTEXT(1)="Updated demographic information has been received from the"
        S IVMTEXT(2)="Health Eligibilty Center.  Please select the 'Demographic Upload'"
        S IVMTEXT(3)="option from the IVM Upload Menu in order to take action on this"
        S IVMTEXT(4)="demographic information.  If you have any questions concerning the"
        S IVMTEXT(5)="information received, please contact the Health Eligibility Center."
        S IVMTEXT(7)=""
        S IVMTEXT(8)="The Health Eligibilty Center has identified the following"
        S IVMTEXT(9)="patients as having updated demographic information:"
        S IVMTEXT(10)=""
        S IVMCNTR=IVMCNTR+1
        S IVMTEXT(IVMCNTR+10)=$J(IVMCNTR_")",5)_"  "_$P(IVMPTID,"^")_" ("_$P(IVMPTID,"^",3)_")"
        Q
        ;
INACTIVE(IVMDEMDA)      ;Check if field is inactive in Demographic Upload
        ; Input  -- IVMDEMDA IVM Demographic Upload Fields IEN
        ; Output -- 1=Yes and 0=No
        Q +$P($G(^IVM(301.92,IVMDEMDA,0)),U,9)
        ;
RF1CHK(IVMRTN,IVMDA)    ;does an RF1 segment exist in this message?
        N RF1
        S RF1=$O(^TMP($J,IVMRTN,IVMDA))
        I $E($G(^(+RF1,0)),1,3)'="RF1" Q 0
        Q 1
        ;
CKAUTO()        ;
        ; Chect if message qualifies for an auto upload.
        N AUTO,IVMI,DOD
        S AUTO=0,IVMI=$O(^IVM(301.92,"C","ZPD09",""))
        I IVMI=IVMDEMDA  D
        .I +IVMFLD'>0 S AUTO=1 Q
        .S DOD=$P($G(^DPT(DFN,.35)),U)
        .I DOD=IVMFLD S AUTO=1 Q
        ;
        Q AUTO
BLDPID(PIDTMP,IVMPID)   ;Build IVMPID subscripted by sequence number
        N STR,X1,X2,N,TEXT,C,L
        S STR="",X1=1,(N,X2)=0
        F  S N=$O(PIDTMP(N)) Q:N=""  S TEXT=PIDTMP(N) F L=1:1:$L(TEXT) S C=$E(TEXT,L) D
        . I C="^" D  Q
        . . I X2 S X2=X2+1,IVMPID(X1,X2)=STR
        . . E  S IVMPID(X1)=STR
        . . S STR="",X1=X1+1,X2=0
        . I C="|" D  Q
        . . S X2=X2+1,IVMPID(X1,X2)=STR,STR=""
        . S STR=STR_C
        I $G(C)'="",$G(C)'="^",$G(C)'="|" D
        . I X2 S X2=X2+1,IVMPID(X1,X2)=STR Q
        . S IVMPID(X1)=STR
        Q
ADDRCHNG(DFN)   ;Store Address Change Date/time, Source and site if necessary
        N IVMVALUE,IVMFIELD
        I '$D(^TMP($J,"CHANGE UPDATE")) Q
        S IVMFIELD=0 F  S IVMFIELD=$O(^TMP($J,"CHANGE UPDATE",IVMFIELD)) Q:IVMFIELD=""  D
        . S IVMVALUE=$G(^TMP($J,"CHANGE UPDATE",IVMFIELD))
        . S DIE="^DPT(",DA=DFN,DR=IVMFIELD_"////^S X=IVMVALUE"
        . D ^DIE K DA,DIE,DR
        .; - delete inaccurate Addr Change Site data if Source is not VAMC
        . I IVMFIELD=.119,IVMVALUE'="VAMC" S FDA(2,+DFN_",",.12)="@" D UPDATE^DIE("E","FDA")
        K ^TMP($J,"CHANGE UPDATE")
        Q
EPCFLDS(EPCFARY,EPCDEL) ;
        ;EPCFARY - Contains IENs of Pager, email and Cell phone records in 301.92 File - Passed by reference
        ;EPCDEL - Contains field # of Pager, Email and Cell phone fields in Patient(#2) file. - Passed by reference
        I (DODSEG)!(GUARSEG) Q
        S EPCFARY("PNO")=$O(^IVM(301.92,"B","PAGER NUMBER",0))_"^"_$O(^IVM(301.92,"B","PAGER CHANGE DT/TM",0))_"^"_$O(^IVM(301.92,"B","PAGER CHANGE SITE",0))_"^"_$O(^IVM(301.92,"B","PAGER CHANGE SOURCE",0))
        S EPCFARY("CPH")=$O(^IVM(301.92,"B","CELLULAR NUMBER",0))_"^"_$O(^IVM(301.92,"B","CELL PHONE CHANGE DT/TM",0))_"^"_$O(^IVM(301.92,"B","CELL PHONE CHANGE SITE",0))_"^"_$O(^IVM(301.92,"B","CELL PHONE CHANGE SOURCE",0))
        S EPCFARY("EAD")=$O(^IVM(301.92,"B","EMAIL ADDRESS",0))_"^"_$O(^IVM(301.92,"B","EMAIL CHANGE DT/TM",0))_"^"_$O(^IVM(301.92,"B","EMAIL CHANGE SITE",0))_"^"_$O(^IVM(301.92,"B","EMAIL CHANGE SOURCE",0))
        S EPCDEL("PNO")=".135^.1312^.1313^.1314"
        S EPCDEL("CPH")=".134^.139^.1311^.13111"
        S EPCDEL("EAD")=".133^.136^.137^.138"
        Q
