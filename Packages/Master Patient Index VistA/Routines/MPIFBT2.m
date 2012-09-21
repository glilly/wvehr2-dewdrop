MPIFBT2 ;SLC/ARS-BATCH RESPONSE FROM MPI ;FEB 4, 1997
        ;;1.0; MASTER PATIENT INDEX VISTA ;**1,3,10,17,21,31,43,53**;30 Apr 99;Build 1
        ;
        ; Integration Agreements Utilized:
        ;   ^DGCN(391.91 - #2751
        ;   EXC, START, STOP ^RGHLLOG - #2796
        ;   XMITFLAG^VAFCDD01 - #3493
        ;   $$PIVNW^VAFHPIVT - #3494
        ;
ADDPAT  ;Called when response from MPI is received for messages sent.
        K ^XTMP($J,"MPIF") D NOW^%DTC S ST=%,X1=ST,X2=20 D C^%DTC
        S STP=X,^XTMP($J,"MPIF","MPIIN",0)=STP_"^"_ST_"^"_"MPI BATCH JOB"
        K %,X,Y,X1,X2,ST,STP N RGLOG,MPIMSG S MPIMSG=HLMTIEN
        D START^RGHLLOG(HLMTIEN,"","ADDPAT^MPIFBT2")
        D PREPMSG,PROCESS(MPIMSG),STOP^RGHLLOG(0)
        K ACK1,ACK2,ACK3,ACK4,HDR,MPICKG,MPIIN,MPIIPPF,MPIIT,MPINUM,MPIPPF,DA
        K CNTR,COM,ENC,ESC,LOCAL,MSHDR,PATID,REP,SCOM,SEP,SITE,MPIDTH,VISTDTH,MPITMP,MPICNTR,MPIFOK,^XTMP($J,"MPIF"),DGSENFLG
        Q
PREPMSG ;prepare for response
        N I,J,X F I=1:1 X HLNEXT Q:HLQUIT'>0  D
        .S ^XTMP($J,"MPIF","MPIIN",I)=HLNODE,J=0
        .F  S J=$O(HLNODE(J))  Q:'J  S ^XTMP($J,"MPIF","MPIIN",I,J)=HLNODE(J)
        Q
PROCESS(MPIMSG) ;Process mesage out of array
        N HDR,MPICNTR S MPICNTR=1,HDR=^XTMP($J,"MPIF","MPIIN",1) ;check hdr here
        D CHDR(HDR,.SEP,MPICNTR,MPIMSG)
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        F  S MPICNTR=$O(^XTMP($J,"MPIF","MPIIN",MPICNTR)) Q:'MPICNTR  D LOOPS(.MPICNTR,SEP,MPIMSG)
        Q
LOOPS(CNTR,SEP,MPIMSG)  ;Loop in the batch
        K ^XTMP($J,"MPIF","MSHERR") N MSHDR,ACK1,ACK2,ACK3,ACK4,ACK5,PATID,LOCAL,MPITMP,LICN
        S MSHDR=^XTMP($J,"MPIF","MPIIN",+CNTR)
        D CHKMSH(MSHDR,.SITE,SEP,MPIMSG)
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S CNTR=$O(^XTMP($J,"MPIF","MPIIN",CNTR)) Q:CNTR'>0
        S ACK1=^XTMP($J,"MPIF","MPIIN",CNTR)
        I $P(ACK1,SEP)'="MSA" S ^XTMP($J,"MPIF","MSHERR")="NOT AN MSA SEGMENT" D EXC^RGHLLOG(203,"Around line number "_(CNTR*2)_" of message "_MPIMSG_".")
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        I ACK1["AR" S ^XTMP($J,"MPIF","MSHERR")="APP REJECT ERROR" D EXC^RGHLLOG(207,"Around line number "_(CNTR*2)_" of message "_MPIMSG_".")
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        I ACK1["AE" S ^XTMP($J,"MPIF","MSHERR")="APP ERROR" D EXC^RGHLLOG(208,"Around line number "_(CNTR*2)_" of message "_MPIMSG_".")
        ;ACK1 must be an AA
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S CNTR=$O(^XTMP($J,"MPIF","MPIIN",CNTR)) Q:CNTR'>0
        S ACK2=^XTMP($J,"MPIF","MPIIN",CNTR)
        I $P(ACK2,SEP)'="QAK" S ^XTMP($J,"MPIF","MSHERR")="NOT A QAK SEGMENT" D EXC^RGHLLOG(202,"Around line number "_(CNTR*2)_" of message "_MPIMSG_".")
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        I ACK2["NO DATA" D
        .S ^XTMP($J,"MPIF","MSHERR")="NO DATA in MPI "
        .;**43 NO DATA FOUND TRIGGER ADD
        .S MPIFRPC=1 D A28^MPIFQ3($P(ACK2,SEP,2)) K MPIFRPC
        .;I ACK2["POTENTIAL MATCHES" D EXC^RGHLLOG(218,"Potential matches found, please review via MPI/PD Exception Handler",$P(ACK2,SEP,2)) ;**53 MPIC_1853 Remove 218 references
        .;D EXC^RGHLLOG(218,"For Patient DFN="_$P(ACK2,SEP,2)_".  Use Single Patient Initialization to MPI option to manually process.",$P(ACK2,SEP,2))
        .;I $D(^DPT($P(ACK2,SEP,2),0)) S LICN=$$ICNLC^MPIF001($P(ACK2,SEP,2))
        .; ^ create a local ICN
        .;I ACK2'["POTENTIAL MATCHES" D
        .;D EXC^RGHLLOG(209,"For Patient DFN="_$P(ACK2,SEP,2)_".  Need required fields before patient can be processed again the MPI.",$P(ACK2,SEP,2))
        .;I $D(^DPT($P(ACK2,SEP,2),0)) S LICN=$$ICNLC^MPIF001($P(ACK2,SEP,2))
        .; ^ create a local ICN
        .N TACK,TCNTR S TCNTR=CNTR,CNTR=$O(^XTMP($J,"MPIF","MPIIN",CNTR)),TACK=^XTMP($J,"MPIF","MPIIN",CNTR)
        .I $P(TACK,SEP)="MSH" S CNTR=TCNTR
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S PATID=$P(ACK2,SEP,2),LOCAL=$G(^DPT(PATID,0)) ;Verify patient is in database
        I LOCAL']"" S ^XTMP($J,"MPIF","MSHERR")="PATIENT DFN NOT IN DATABASE- BAD " D EXC^RGHLLOG(210,"Around line number "_(CNTR*2)_"  DFN= "_PATID_"  MESSAGE# "_MPIMSG,PATID)
        S CNTR=$O(^XTMP($J,"MPIF","MPIIN",CNTR)) Q:CNTR'>0
        ; **43 MOVED CNTR INCREASE TO GET TO NEXT MSH
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S ACK3=^XTMP($J,"MPIF","MPIIN",CNTR) ;RDF DEFINITION SEGMENT NO-OP
        I $P(ACK3,SEP)'="RDF" S ^XTMP($J,"MPIF","MSHERR")="NOT RDF SEGMENT" D EXC^RGHLLOG(204,"Around line number "_(CNTR*2)_" of message "_MPIMSG_".",PATID)
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S CNTR=$O(^XTMP($J,"MPIF","MPIIN",CNTR)) Q:CNTR'>0
        S RDTSEQ=1
        S ACK4(RDTSEQ)=^XTMP($J,"MPIF","MPIIN",CNTR)
        I $P(ACK4(RDTSEQ),SEP)'="RDT" S ^XTMP($J,"MPIF","MSHERR")="NOT RDT SEGMENT" D EXC^RGHLLOG(205,"Around line number "_(CNTR*2)_" of message "_MPIMSG_".",PATID)
        ;
        N RDTSQ S RDTSQ=0
        F  S RDTSQ=$O(^XTMP($J,"MPIF","MPIIN",CNTR,RDTSQ)) Q:'RDTSQ  D
        .S ACK4(RDTSEQ+1)=^XTMP($J,"MPIF","MPIIN",CNTR,RDTSQ),RDTSEQ=RDTSEQ+1
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S MPITMP=$O(^XTMP($J,"MPIF","MPIIN",CNTR))
        I MPITMP'>0 S:$E($G(^XTMP($J,"MPIF","MPIIN",MPITMP)),1,3)="BTS" CNTR=$O(^XTMP($J,"MPIF","MPIIN",CNTR))
        Q:CNTR'>0
        D VFYRDT^MPIFBT3(.ACK4,SEP,CNTR,PATID,SITE,MPIMSG)
        S MPITMP=$O(^XTMP($J,"MPIF","MPIIN",CNTR))
        Q:MPITMP'>0
        S ACK5=^XTMP($J,"MPIF","MPIIN",MPITMP)
        I $P(ACK5,SEP)="RDT" D MULT^MPIFBT3(.CNTR,ACK5,SEP,MPIMSG,PATID)
        K RDTSEQ
        Q
TFLIST(TFSITE,PATID)    ;adding TFSITE site for patient to Treating Facility List (#391.91)
        I $G(TFSITE)="" S ^XTMP($J,"MPIF","MSHERR")="Treating Facility = null" D EXC^RGHLLOG(212,"DFN = "_PATID_" Treating Facility = Null",PATID) Q
        S TFSITE=$$LKUP^XUAF4(TFSITE)
        Q:+TFSITE'>0
        Q:$D(^DGCN(391.91,"APAT",PATID,TFSITE))
        K DD,DO N DIC,X,Y L +^DGCN(391.91,0):60
        I '$T D EXC^RGHLLOG(212,"Unable to Lock Treating Facility file to add patient DFN="_PATID_" Facility= "_TFSITE,PATID) Q
        S DIC="^DGCN(391.91,",DIC("DR")=".02///`"_TFSITE,X=PATID,DIC(0)="LQZ"
        I $D(^DGCN(391.91,"APAT",PATID,TFSITE)) L -^DGCN(391.91,0) Q
        D FILE^DICN L -^DGCN(391.91,0)
        I +Y=-1,'$D(^DGCN(391.91,"APAT",PATID,TFSITE)) S ^XTMP($J,"MPIF","MSHERR")="Treating Facility Add Failed" D EXC^RGHLLOG(212,"DFN= "_PATID_"  Treating Facility= "_TFSITE_"  failed when adding an entry to the Treating Facility file.",PATID)
        K DD,DO,DIC,X,Y
        Q
TFUPDT(PATID,MPIMSG,CNTR)       ;treating facility update message to pivot file
        N ERR,TRANS,EVDT,X,Y,%
        D NOW^%DTC S EVDT=% K %,X,Y
        S ERR=$$PIVNW^VAFHPIVT(PATID,EVDT,5,PATID_";DPT(")
        I +ERR<1 D EXC^RGHLLOG(212,"When trying to add Patient (DFN)"_PATID_"   message# "_MPIMSG_" around line number "_(CNTR*2),PATID)
        Q:+ERR<1
        D XMITFLAG^VAFCDD01("",+ERR)
        Q
CHDR(HDR,SEP,CNTR,MPIMSG)       ;Only process Batch message responses
        I $P(HDR,"^")'="BHS" S ^XTMP($J,"MPIF","MSHERR")="BHS SEGMENT MISSING" D EXC^RGHLLOG(200,"for message "_MPIMSG_".  The segment contains "_HDR)
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S SEP=$G(HL("FS")) ;get field sep, and encoding characters
        I SEP="" S ^XTMP($J,"MPIF","MSHERR")="Missing field seperator" D EXC^RGHLLOG(200,"Missing field seperator")
        Q
CHKMSH(MSHDR,SITE,SEP,MPIMSG)   ;VERIFY MSH
        I $P(MSHDR,SEP)="BTS" S ^XTMP($J,"MPIF","MSHERR")="BTS FOUND" Q
        S:$P(MSHDR,SEP)'="MSH" ^XTMP($J,"MPIF","MSHERR")="NOT MSH HEADER   MESSAGE# "_MPIMSG
        S:$E(MSHDR,4)'=SEP ^XTMP($J,"MPIF","MSHERR")="FIELD SEPARATOR MISMATCH   MESSAGE# "_MPIMSG
        I $D(^XTMP($J,"MPIF","MSHERR")) D EXC^RGHLLOG(201,$G(^XTMP($J,"MPIF","MSHERR")))
        Q:$D(^XTMP($J,"MPIF","MSHERR"))
        S SITE=$P(MSHDR,SEP,6)
        I SITE="" S ^XTMP($J,"MPIF","MSHERR")="SITE NOT IN MSH"
        I $D(^XTMP($J,"MPIF","MSHERR")) D EXC^RGHLLOG(8,"MSH Doesn't Have SITE as 6th piece.   MESSAGE# "_MPIMSG)
        Q
