DGENUPL2        ;ALB/CJM,RTK,TMK,ISA/KWP/RMM/CKN,EG,ERC - PROCESS INCOMING (Z11 EVENT TYPE) HL7 MESSAGES ; 9/1/06 1:18pm
        ;;5.3;REGISTRATION;**147,222,232,310,314,367,397,677,631,675,672,673,716,653,688**;Aug 13,1993;Build 29
        ;
        ;**************************************************************
        ;The following procedures parse particular segment types.
        ;Input:SEG(),MSGID
        ;Output:DGPAT(),DGELG(),DGENR(),DGCDIS(),DGNTR(),DGOEIF(),ERROR
        ;**************************************************************
        ;
PID     ;
        S DGPAT("SSN")=SEG(19)
        Q
        ;
ZPD     ;
        D ZPD^DGENUPLA ;code removed due to size of DGENUPLA - DG*5.3*688
        Q
        ;
ZIE     ;
        S DGPAT("INELDATE")=$$CONVERT^DGENUPL1(SEG(2),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZIE SEGMENT, SEQ 2",.ERRCOUNT)
        S DGPAT("INELREA")=$$CONVERT^DGENUPL1(SEG(3))
        S DGPAT("INELDEC")=$$CONVERT^DGENUPL1(SEG(4))
        Q
        ;
ZIO     ;New segment - DG*5.3*653
        D ZIO^DGENUPLA  ;Code for ZIO has moved to DGENUPLA
        Q
        ;
ZEL(COUNT)      ;
        D ZEL^DGENUPLA(COUNT)  ;code for ZEL segment has moved to DGENUPLA
        Q
        ;
ZEN     ;
        N SUB
        S DGENR("DATE")=$$CONVERT^DGENUPL1(SEG(2),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEN SEGMENT, SEQ 2",.ERRCOUNT)
        S DGENR("SOURCE")=$$CONVERT^DGENUPL1(SEG(3))
        S DGENR("STATUS")=$$CONVERT^DGENUPL1(SEG(4))
        S ERROR=$$PEND(DFN,DGENR("STATUS"))
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"ENROLLMENT STATUS PENDING-ELIGIBILITY IS VERIFIED",.ERRCOUNT)
        S DGENR("REASON")=$$CONVERT^DGENUPL1(SEG(5))
        S DGENR("REMARKS")=$$CONVERT^DGENUPL1(SEG(6))
        S DGENR("FACREC")=$$CONVERT^DGENUPL1(SEG(7),"INSTITUTION",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"FACILITY RECEIVED "_SEG(7)_" NOT FOUND IN THE INSTITUTION FILE",.ERRCOUNT)
        S DGPAT("PREFAC")=$$CONVERT^DGENUPL1(SEG(8),"INSTITUTION",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"PREFERRED FACILITY "_SEG(8)_" NOT FOUND IN THE INSTITUTION FILE",.ERRCOUNT)
        ;
        S DGENR("PRIORITY")=$$CONVERT^DGENUPL1(SEG(9))
        S DGENR("EFFDATE")=$$CONVERT^DGENUPL1(SEG(10),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEN SEGMENT, SEQ 10",.ERRCOUNT)
        S DGENR("APP")=$$CONVERT^DGENUPL1(SEG(11),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEN SEGMENT, SEQ 11",.ERRCOUNT)
        ;
        ;!!!!!! take next line out when HEC begins transmitting application dt
        I DGENR("APP")=""!(DGENR("APP")="@") S DGENR("APP")=DGENR("DATE")
        I DGENR("APP")=""!(DGENR("APP")="@") S DGENR("APP")=DGENR("EFFDATE")
        ;
        S DGENR("END")=$$CONVERT^DGENUPL1(SEG(12),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZEN SEGMENT, SEQ 12",.ERRCOUNT)
        ;Phase II Parse out Sub-Group (SRS 6[B.4)
        S DGENR("SUBGRP")=$$CONVERT^DGENUPL1(SEG(13))
        ;
        ;want to ignore double quotes sent for enrollment fields
        S SUB=""
        F  S SUB=$O(DGENR(SUB)) Q:SUB=""  I DGENR(SUB)="@"!(DGENR(SUB)="""""") S DGENR(SUB)=""
        ;
        Q
        ;
ZMT     ;
        I SEG(1)>1 D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"ZMT SEGMENT, SEQ 1, SHOULD SPECIFY MEANS TEST",.ERRCOUNT) S ERROR=1 Q
        S DGELG("MTSTA")=$$CONVERT^DGENUPL1(SEG(3),"MT",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZMT SEGMENT, SEQ 3",.ERRCOUNT)
        Q
        ;
ZCD     ;
        ;Phase II for multiple ZCD's
        I SEG(1)>1 G SKIP
        S DGCDIS("BY")=$$CONVERT^DGENUPL1(SEG(3))
        S DGCDIS("DATE")=$$CONVERT^DGENUPL1(SEG(5),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZCD SEGMENT, SEQ 5",.ERRCOUNT)
        S DGCDIS("FACDET")=$$CONVERT^DGENUPL1(SEG(4),"INSTITUTION",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"FACILITY "_SEG(4)_" MAKING CATASTROPHIC DISABILITY DETERMINATION NOT FOUND IN THE INSTITUTION FILE",.ERRCOUNT)
        S DGCDIS("REVDTE")=$$CONVERT^DGENUPL1(SEG(2),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZCD SEGMENT, SEQ 2",.ERRCOUNT)
        S DGCDIS("METDET")=$$CONVERT^DGENUPL1($P(SEG(6),$E(HLECH)))
        S DGCDIS("VCD")=$$CONVERT^DGENUPL1(SEG(12))
        ;SEQ 14 - DATE VETERAN REQUESTED CD EVALUATION
        S DGCDIS("VETREQDT")=$$CONVERT^DGENUPL1(SEG(14),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZCD SEGMENT, SEQ 14",.ERRCOUNT)
        ;SEQ 15 - DATE FACILITY INITIATED REVIEW
        S DGCDIS("DTFACIRV")=$$CONVERT^DGENUPL1(SEG(15),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZCD SEGMENT, SEQ 15",.ERRCOUNT)
        ;SEQ 16 - DATE VETERAN WAS NOTIFIED
        S DGCDIS("DTVETNOT")=$$CONVERT^DGENUPL1(SEG(16),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZCD SEGMENT, SEQ 16",.ERRCOUNT)
SKIP    ;
        ;Phase II Parse out additional fields.  CONVERT type of RSN converts the code to IEN for diagnosis,procedure and condition (HL7TORSN^DGENA5).
        S DGCDIS("DIAG",SEG(1))=$$CONVERT^DGENUPL1(SEG(7),"CDRSN")
        S DGCDIS("PROC",SEG(1))=$$CONVERT^DGENUPL1(SEG(8),"CDRSN")
        S DGCDIS("EXT",SEG(1),1)=$$CONVERT^DGENUPL1($P(SEG(9),$E(HLECH)),"EXT")
        S DGCDIS("COND",SEG(1))=$$CONVERT^DGENUPL1(SEG(10),"CDRSN")
        S DGCDIS("SCORE",SEG(1))=$$CONVERT^DGENUPL1($P(SEG(11),$E(HLECH)))
        S DGCDIS("PERM",SEG(1))=$$CONVERT^DGENUPL1($P(SEG(13),$E(HLECH)))
        I DGCDIS("VCD")="Y",'DGCDIS("DIAG",SEG(1)),'DGCDIS("PROC",SEG(1)),'DGCDIS("COND",SEG(1)) D  Q
        .S ERROR=1 D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"NO VALID DIAGNOSIS,PROCEDURE, OR CONDITION IN THE ZCD SEGMENT",.ERRCOUNT)
        Q
        ;
ZSP     ;
        S DGELG("SC")=$$CONVERT^DGENUPL1(SEG(2),"Y/N",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZSP SEGMENT, SEQ 2",.ERRCOUNT)
        S DGELG("SCPER")=$$CONVERT^DGENUPL1(SEG(3))
        S DGELG("POS")=$$CONVERT^DGENUPL1(SEG(4),"POS",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZSP SEGMENT, SEQ 4",.ERRCOUNT)
        S DGELG("EFFDT")=$$CONVERT^DGENUPL1(SEG(11),"DATE",.ERROR)
        I ERROR D  Q
        . D ADDERROR^DGENUPL(MSGID,$G(DGELG("EFFDT")),"BAD VALUE, ZSP SEGMENT, SEQ 11",.ERRCOUNT)
        ;if effective date is null, set update value to "@" (delete)
        I DGELG("EFFDT")="" S DGELG("EFFDT")="@"
        ;
        ;added 8/3/98 to reduce #rejects
        ;if HEC sends SC=NO, SC% not sent, and site has value for SC% then delete it
        I DGELG("SC")="N",DGELG("SCPER")="" S DGELG("SCPER")="@"
        ;
        S DGELG("P&T")=$$CONVERT^DGENUPL1(SEG(6),"Y/N",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZSP SEGMENT, SEQ 6",.ERRCOUNT)
        S DGELG("UNEMPLOY")=$$CONVERT^DGENUPL1(SEG(7),"Y/N",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZSP SEGMENT, SEQ 7",.ERRCOUNT)
        S DGELG("SCAWDATE")=$$CONVERT^DGENUPL1(SEG(8),"DATE",.ERROR)
        I ERROR D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZSP SEGMENT, SEQ 8",.ERRCOUNT)
        S DGELG("P&TDT")=$$CONVERT^DGENUPL1(SEG(10),"DATE",.ERROR)
        I ERROR D
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZSP SEGMENT, SEQ 10 - P&T EFFECTIVE DATE",.ERRCOUNT)
        Q
        ;
ZMH     ;Purple Heart, OEFOIE, POW
        D ZMH^DGENUPL3 ;Moved to DGENUPL3 - DG*5.3*653 
        Q
        ;
ZRD     ;
        N COUNT,DXCODE,NAME,COND
        S DXCODE=$P(SEG(2),$E(HLECH))
        I DXCODE="""""" S DXCODE=""
        S NAME=$P(SEG(2),$E(HLECH),2)
        Q:DXCODE=""  ;segment does not contain a disability condition
        ;
        S COUNT=1+(+$G(DGELG("RATEDIS")))
        S (COND,DGELG("RATEDIS",COUNT,"RD"))=$$DCLOOKUP(DXCODE,NAME)
        S DGELG("RATEDIS",COUNT,"PER")=$$CONVERT^DGENUPL1(SEG(3)),DGELG("RATEDIS")=COUNT
        S DGELG("RATEDIS",COUNT,"RDEXT")=$$CONVERT^DGENUPL1(SEG(12))
        S DGELG("RATEDIS",COUNT,"RDORIG")=$$CONVERT^DGENUPL1(SEG(13),"DATE",.ERROR)
        I ERROR D  Q
        . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZRD SEGMENT, S 13",.ERRCOUNT)
        S DGELG("RATEDIS",COUNT,"RDCURR")=$$CONVERT^DGENUPL1(SEG(14),"DATE",.ERROR)
        I ERROR D  Q
        . D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZRD SEGMENT, S 14",.ERRCOUNT)
        I 'COND D  Q
        .D ADDERROR^DGENUPL(MSGID,$G(DGPAT("SSN")),"BAD VALUE, ZRD SEGMENT, SEQ 2 - DISABILTY CONDITION LOOKUP FAILED",.ERRCOUNT)
        .S ERROR=1
        Q
OBX     ;
        D OBX^DGENUPLA  ;code for OBX segment moved to DGENUPLA
        Q
        ;
        ;*********** end of segment parsers ****
        ;
DCLOOKUP(DGCODE,DGNAME) ;
        ; Description: Returns the ien of a Disability Condition (file #31) based on the DGCODE and DGNAME
        ;
        ;Input:
        ;  DGCODE - DX Code of the Disability Condition
        ;  DGNAME - name of the Disability Condition
        ;Output:
        ;  Function Value: ien of the entry found, or 0 otherwise
        ;
        Q:(DGCODE="") 0
        N NODE,IEN,FOUND
        S (FOUND,IEN)=0
        F  S IEN=$O(^DIC(31,"C",DGCODE,IEN)) Q:'IEN  D  Q:FOUND
        .S NODE=$G(^DIC(31,IEN,0))
        .I DGNAME=$P(NODE,"^"),DGCODE=$P(NODE,"^",3) S FOUND=1
        I 'FOUND S IEN=$O(^DIC(31,"C",DGCODE,0))
        Q +IEN
        ;
REGCHECK(DFN)   ;
        ; Description: passes patient through the registration consistency checker
        ;Input -
        ;  DFN - is a pointer to the Patient File
        ;
        N DGCD,DGCHK,DGDAY,DGEDCN,DGER,DGLST,DGNCK,DGRPCOLD,DGSC,DGTYPE,DGVT,VA,X
        ;
        S DGEDCN=0
        D ^DGRPC
        Q
PEND(DFN,DGSTAT)        ;
        N DGARR,DGEC,DGERR,DGX
        I $P($G(^DPT(DFN,.361)),U)'="V" Q 0
        I $G(DGSTAT)="@" Q 0
        I $G(DGSTAT)']"" Q 0
        S DGSTAT="^"_DGSTAT_"^"
        Q:"^15^17^"'[DGSTAT 0
        D GETS^DIQ(2,DFN_",",".301;.302;.361;.36295","IE","DGARR","DGERR")
        I $D(DGERR) Q 0
        S DGEC=$G(DGARR(2,DFN_",",.361,"I"))
        I $G(DGEC)']"" Q 0
        S DGEC=$P($G(^DIC(8,DGEC,0)),U,9)
        I $G(DGEC)']"" Q 0
        I DGEC=5 Q 1
        I DGEC=3 D  Q DGX
        . S DGX=1
        . I $G(DGARR(2,DFN_",",.301,"I"))'="Y" S DGX=0 Q
        . I +$G(DGARR(2,DFN_",",.302,"I"))>0 S DGX=0 Q
        . I +$G(DGARR(2,DFN_",",.36295,"I"))>0 S DGX=0 Q
        Q 0
