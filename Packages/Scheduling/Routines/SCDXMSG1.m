SCDXMSG1        ;ALB/JRP - AMB CARE MESSAGE BUILDER UTILS;08-MAY-1996 ; 6/21/05 2:08pm
        ;;5.3;Scheduling;**44,55,70,77,85,66,143,142,162,172,180,239,245,254,293,325,387,459,472,441,552**;AUG 13, 1993;Build 5
        ;
        ;-- Line tags for building HL7 segment
BLDEVN  S VAFEVN=$$EN^VAFHLEVN(EVNTHL7,ENCNDT,VAFSTR,HL("Q"),HL("FS"))
        ;SD*5.3*387 replaced EVNTDATE with ENCNDT
        Q
BLDPID  K VAFPID D BLDPID^VAFCQRY(DFN,1,VAFSTR,.VAFPID,.HL)
        ;check marital/religion status; rebuild PID segment.
        D SETMAR^SCMSVUT0(.VAFPID,HL("Q"),HL("FS"),HL("ECH"))
        Q
BLDZPD  S VAFZPD=$$EN1^VAFHLZPD(DFN,VAFSTR)
        D SETPOW^SCMSVUT0(DFN,.VAFZPD,HL("Q"),HL("FS"))
        Q
BLDPV1  D SETID^SCMSVUT0(ENCPTR,DELPTR)
        S VAFPV1=$$EN^VAFHLPV1(ENCPTR,DELPTR,VAFSTR,1,HL("Q"),HL("FS"))
        Q
BLDDG1  K @VAFARRY
        D EN^VAFHLDG1(ENCPTR,VAFSTR,HL("Q"),HL("FS"),VAFARRY)
        Q
BLDPR1  K @VAFARRY
        D SETPRTY^SCMSVUT0(ENCPTR)
        D EN^VAFHLPR1(ENCPTR,VAFSTR,HL("Q"),HL("FS"),HL("ECH"),VAFARRY)
        Q
BLDZEL  N ELCOD,ELIGENC,I,VAFMSTDT
        S VAFMSTDT=ENCDT
        D EN1^VAFHLZEL(DFN,VAFSTR,1,.VAFZEL)
        S ELCOD=$P($G(^SCE(ENCPTR,0)),"^",13),ELIGENC=$P($G(^DIC(8,+ELCOD,0)),"^",9)
        S $P(VAFZEL(1),HL("FS"),3)=ELIGENC
        Q
BLDZIR  K DGREL,DGINC,DGINR,DGDEP
        D ALL^DGMTU21(DFN,"V",ENCDT,"R")
        S VAFZIR=$$EN^VAFHLZIR(+$G(DGINR("V")),VAFSTR,1,ENCPTR)
        K DGREL,DGINC,DGINR,DGDEP
        Q
BLDZCL  K @VAFARRY
        D EN^VAFHLZCL(DFN,ENCPTR,VAFSTR,HL("Q"),HL("FS"),VAFARRY)
        Q
BLDZSC  K @VAFARRY
        D EN^VAFHLZSC(ENCPTR,VAFSTR,HL("Q"),HL("FS"),VAFARRY)
        Q
BLDZSP  S VAFZSP=$$EN^VAFHLZSP(DFN,1,1)
        S VAFZSP=$$SETVSI^SCMSVUT0(DFN,$G(VAFZSP),HL("Q"),HL("FS"))
        Q
BLDROL  K @VAFARRY
        N SCDXPRV,SCDXPAR,SCDXROL,PTRPRV,NODE,PRVNUM,TMP
        D GETPRV^SDOE(ENCPTR,"SCDXPRV")
        S PTRPRV=0
        F PRVNUM=1:1  S PTRPRV=+$O(SCDXPRV(PTRPRV)) Q:('PTRPRV)  D
        .K SCDXPAR,SCDXROL
        .S NODE=SCDXPRV(PTRPRV)
        .S SCDXPAR("PTR200")=+NODE
        .S SCDXPAR("INSTID")=$$VID4XMIT^SCDXFU11(XMITPTR)_"-"_(+NODE)_"*"_PRVNUM
        .S SCDXPAR("ACTION")="CO"
        .S SCDXPAR("ALTROLE")=($TR($P(NODE,"^",4),"PS","10"))_$E(HL("ECH"),1)_HL("Q")_$E(HL("ECH"),1)_"VA01"
        .S SCDXPAR("CODEONLY")=0
        .S SCDXPAR("RDATE")=ENCDT
        .D OUTPAT^VAFHLROL("SCDXPAR","SCDXROL",VAFSTR,HL("FS"),HL("ECH"),HL("Q"),240)
        .K SCDXROL("ERROR"),SCDXROL("WARNING")
        .M @VAFARRY@(PRVNUM)=SCDXROL
        Q
BLDPD1  S VAFPD1=$$EN^VAFHLPD1(DFN,VAFSTR)
        Q
BLDZEN  S VAFZEN=$$EN^VAFHLZEN(DFN,VAFSTR,1,HL("Q"),HL("FS"))
        Q
        ;
        ;-- Line tags for validating HL7 segments
VLDEVN  S ERROR=$$EN^SCMSVEVN(VAFEVN,HL("Q"),HL("FS"),VALERR)
        S:(ERROR>0) ERROR=0
        Q
VLDPID  S ERROR=$$EN^SCMSVPID(.VAFPID,HL("Q"),HL("FS"),HL("ECH"),VALERR,ENCDT,EVNTHL7)
        S:(ERROR>0) ERROR=0
        Q
VLDZPD  S ERROR=$$EN^SCMSVZPD(.VAFZPD,HL("Q"),HL("FS"),VALERR,ENCDT,NODE)
        S:(ERROR>0) ERROR=0
        Q
VLDPV1  S ERROR=$$EN^SCMSVPV1(VAFPV1,HL("Q"),HL("FS"),VALERR,NODE,EVNTHL7,ENCNDT)
        S:(ERROR>0) ERROR=0
        Q
VLDDG1  S ERROR=$$EN^SCMSVDG1(VAFARRY,HL("Q"),HL("FS"),ENCPTR,VALERR,ENCDT)
        S:(ERROR>0) ERROR=0
        Q
VLDPR1  S ERROR=$$EN^SCMSVPR1(VAFARRY,HL("Q"),HL("FS"),HL("ECH"),VALERR,ENCDT)
        S:(ERROR>0) ERROR=0
        Q
VLDZEL  N VAFZELSV M VAFZELSV=VAFZEL
        S ERROR=$$EN^SCMSVZEL(.VAFZELSV,HL("Q"),HL("FS"),VALERR,DFN)
        S:(ERROR>0) ERROR=0
        Q
VLDZIR  S ERROR=$$EN^SCMSVZIR(VAFZIR,HL("Q"),HL("FS"),VALERR)
        S:(ERROR>0) ERROR=0
        Q
VLDZCL  S ERROR=$$EN^SCMSVZCL(VAFARRY,HL("Q"),HL("FS"),VALERR,DFN)
        S:(ERROR>0) ERROR=0
        Q
VLDZSC  S ERROR=$$EN^SCMSVZSC(VAFARRY,HL("Q"),HL("FS"),VALERR,ENCPTR)
        S:(ERROR>0) ERROR=0
        Q
VLDZSP  S ERROR=$$EN^SCMSVZSP(VAFZSP,HL("Q"),HL("FS"),VALERR,DFN)
        S:(ERROR>0) ERROR=0
        Q
VLDROL  S ERROR=$$EN^SCMSVROL(VAFARRY,HL("Q"),HL("FS"),HL("ECH"),VALERR)
        S:(ERROR>0) ERROR=0
        Q
VLDPD1  S ERROR=0
        Q
VLDZEN  S ERROR=0
        Q
        ;
        ;-- Line tags for copying HL7 segments into HL7 message
CPYEVN  N I
        S @XMITARRY@(CURLINE)=VAFEVN
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFEVN(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFEVN(I)
        .S LINESADD=LINESADD+1
        Q
CPYPID  N I
        S @XMITARRY@(CURLINE)=VAFPID
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFPID(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFPID(I)
        .S LINESADD=LINESADD+1
        Q
CPYZPD  N I
        S @XMITARRY@(CURLINE)=VAFZPD
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFZPD(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFZPD(I)
        .S LINESADD=LINESADD+1
        Q
CPYPV1  N I
        S @XMITARRY@(CURLINE)=VAFPV1
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFPV1(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFPV1(I)
        .S LINESADD=LINESADD+1
        Q
CPYDG1  N I,J,K
        S I=""
        F K=0:1 S I=+$O(@VAFARRY@(I)) Q:('I)  D
        .S J=""
        .F  S J=$O(@VAFARRY@(I,J)) Q:(J="")  D
        ..S:('J) @XMITARRY@(CURLINE+K)=@VAFARRY@(I,J)
        ..S:(J) @XMITARRY@(CURLINE+K,J)=@VAFARRY@(I,J)
        ..S LINESADD=LINESADD+1
        S CURLINE=CURLINE+K-1
        Q
CPYPR1  N I,J,K
        S I=""
        F K=0:1 S I=+$O(@VAFARRY@(I)) Q:('I)  D
        .S J=""
        .F  S J=$O(@VAFARRY@(I,J)) Q:(J="")  D
        ..S:('J) @XMITARRY@(CURLINE+K)=@VAFARRY@(I,J)
        ..S:(J) @XMITARRY@(CURLINE+K,J)=@VAFARRY@(I,J)
        ..S LINESADD=LINESADD+1
        S CURLINE=CURLINE+K-1
        Q
CPYZEL  N I
        S @XMITARRY@(CURLINE)=VAFZEL(1)
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFZEL(1,I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFZEL(1,I)
        .S LINESADD=LINESADD+1
        Q
CPYZIR  N I
        S @XMITARRY@(CURLINE)=VAFZIR
        S LINESADD=LINESADD+1
        N I
        S I=""
        F  S I=+$O(VAFZIR(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFZIR(I)
        .S LINESADD=LINESADD+1
        Q
CPYZCL  N I,J,K
        S I=""
        F K=0:1 S I=+$O(@VAFARRY@(I)) Q:('I)  D
        .S J=""
        .F  S J=$O(@VAFARRY@(I,J)) Q:(J="")  D
        ..S:('J) @XMITARRY@(CURLINE+K)=@VAFARRY@(I,J)
        ..S:(J) @XMITARRY@(CURLINE+K,J)=@VAFARRY@(I,J)
        ..S LINESADD=LINESADD+1
        S CURLINE=CURLINE+K-1
        Q
CPYZSC  N I,J,K
        S I=""
        F K=0:1 S I=+$O(@VAFARRY@(I)) Q:('I)  D
        .S J=""
        .F  S J=$O(@VAFARRY@(I,J)) Q:(J="")  D
        ..S:('J) @XMITARRY@(CURLINE+K)=@VAFARRY@(I,J)
        ..S:(J) @XMITARRY@(CURLINE+K,J)=@VAFARRY@(I,J)
        ..S LINESADD=LINESADD+1
        S CURLINE=CURLINE+K-1
        Q
CPYZSP  N I
        S @XMITARRY@(CURLINE)=VAFZSP
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFZSP(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFZSP(I)
        .S LINESADD=LINESADD+1
        Q
CPYROL  N I,J,K
        S I=""
        F K=0:1 S I=+$O(@VAFARRY@(I)) Q:('I)  D
        .S J=""
        .F  S J=$O(@VAFARRY@(I,J)) Q:(J="")  D
        ..S:('J) @XMITARRY@(CURLINE+K)=@VAFARRY@(I,J)
        ..S:(J) @XMITARRY@(CURLINE+K,J)=@VAFARRY@(I,J)
        ..S LINESADD=LINESADD+1
        S CURLINE=CURLINE+K-1
        Q
CPYPD1  N I
        S @XMITARRY@(CURLINE)=VAFPD1
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFPD1(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFPD1(I)
        .S LINESADD=LINESADD+1
        Q
CPYZEN  N I
        S @XMITARRY@(CURLINE)=VAFZEN
        S LINESADD=LINESADD+1
        S I=""
        F  S I=+$O(VAFZEN(I)) Q:('I)  D
        .S @XMITARRY@(CURLINE,I)=VAFZEN(I)
        .S LINESADD=LINESADD+1
        Q
        ;
        ;-- Line tags for deleting HL7 segments
DELEVN  K VAFEVN
        Q
DELPID  K VAFPID
        Q
DELZPD  K VAFZPD
        Q
DELPV1  K VAFPV1
        Q
DELDG1  K @VAFARRY
        Q
DELPR1  K @VAFARRY
        Q
DELZEL  K VAFZEL
        Q
DELZIR  K VAFZIR
        Q
DELZCL  K @VAFARRY
        Q
DELZSC  K @VAFARRY
        Q
DELZSP  K VAFZSP
        Q
DELROL  K @VAFARRY
        Q
DELPD1  K VAFPD1
        Q
DELZEN  K VAFZEN
        Q
        ;
        ;
SEGMENTS(EVNTTYPE,SEGARRY)      ;Build list of HL7 segments for a given
        ; event type
        ;
        ;Input  : EVNTTYPE - Event type to build list for
        ;                    A08 & A23 are the only types currently supported
        ;                    (Defaults to A08)
        ;         SEGARRY - Array to place output in (full global reference)
        ;                   (Defaults to ^TMP("SCDX SEGMENTS",$J))
        ;Output : None
        ;           SEGARRY(Seq,Name) = Fields
        ;             Seq - Sequencing number to order the segments as
        ;                   they should be placed in the HL7 message
        ;             Name - Name of HL7 segment
        ;             Fields - List of fields used by Ambulatory Care
        ;                      VAFSTR would be set to this value
        ;       : MSH segment is not included
        ;
        ;Check input
        S EVNTTYPE=$G(EVNTTYPE)
        S:(EVNTTYPE'="A23") EVNTTYPE="A08"
        S SEGARRY=$G(SEGARRY)
        S:(SEGARRY="") SEGARRY="^TMP(""SCDX SEGMENTS"","_$J_")"
        ;Segments used by A08 & A23
        S @SEGARRY@(1,"EVN")="1,2"
        S @SEGARRY@(2,"PID")="1,2,3,4,5,6,7,8,10,11,13,14,16,17,19,22"
        S @SEGARRY@(3,"PD1")="3,4"
        S @SEGARRY@(4,"PV1")="1,2,4,14,19,39,44,50"
        ;Building list for A23 - add ZPD segment and quit
        I (EVNTTYPE="A23") D  Q
        .S @SEGARRY@(5,"ZPD")="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,40"
        S @SEGARRY@(5,"DG1")="1,2,3,4,5,15"
        S @SEGARRY@(6,"PR1")="1,3,16"
        S @SEGARRY@(7,"ROL")="1,2,3,4"
        S @SEGARRY@(8,"ZPD")="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,40"
        S @SEGARRY@(9,"ZEL")="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,29,37,38,40"
        S @SEGARRY@(10,"ZIR")="1,2,3,4,5,6,7,8,9,10,11,12,13"
        S @SEGARRY@(11,"ZCL")="1,2,3"
        S @SEGARRY@(12,"ZSC")="1,2,3"
        S @SEGARRY@(13,"ZSP")="1,2,3,4"
        S @SEGARRY@(14,"ZEN")="1,2,3,4,5,6,7,8,9,10"
        Q
        ;
UNWIND(XMITARRY,INSRTPNT)       ;Remove all data that was put into HL7 message
        ;
        ;Input  : XMITARRY - Array containing HL7 message (full global ref)
        ;                    (Defaults to ^TMP("HLS",$J))
        ;         INSRTPNT - Where to begin deletion from (Defaults to 1)
        ;Output : None
        ;
        ;Check input
        S XMITARRY=$G(XMITARRY)
        S:(XMITARRY="") XMITARRY="^TMP(""HLS"","_$J_")"
        S INSRTPNT=$G(INSRTPNT)
        S:(INSRTPNT="") INSRTPNT=1
        ;Remove insertion point from array
        K @XMITARRY@(INSRTPNT)
        ;Remove everything from insertion point to end of array
        F  S INSRTPNT=$O(@XMITARRY@(INSRTPNT)) Q:(INSRTPNT="")  K @XMITARRY@(INSRTPNT)
        ;Done
        Q
