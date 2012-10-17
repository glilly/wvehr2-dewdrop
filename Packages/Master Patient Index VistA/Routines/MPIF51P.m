MPIF51P ;BP/CMC-MPIF*1*51 PATCH POST INSTALL ROUTINE ;5/20/09
        ;;1.0; MASTER PATIENT INDEX VISTA ;**51**;30 Apr 99;Build 3
        ;
        ;References to VA(15.3 are covered by IA #5456
        ;
QUE         ;
        D BMES^XPDUTL("Post-init send A24 HL7 messages for patients related to past merge events.")
        S QUEDUZ=$S($G(DUZ)="":.5,1:DUZ)
        S ZTSAVE("QUEDUZ")="",ZTRTN="EN^MPIF51P",ZTDESC="MPI/PD - Sending A24s for merged records MPIF*1*51 post init"
        S ZTIO="",ZTDTH=$$NOW^XLFDT D ^%ZTLOAD
        I $D(ZTSK) D BMES^XPDUTL("Job was queued as Task #"_ZTSK_".")
        ;
QUIT        ;
        K ZTSK S:$D(ZTQUEUED) ZTREQ="@"
        K QUEDUZ,ZTDESC,ZTIO,ZTREQ,ZTRTN,ZTSAVE,ZTDTH
        Q
EN           ;TO DO ALL PARTS
        N START,STOP,DIFF,CNT
        K ^XTMP("MPIFP51")
        I '$D(QUEDUZ) S QUEDUZ=DUZ I QUEDUZ="" S QUEDUZ=.5
        S START=$$NOW^XLFDT
        D SETUP
        D START(QUEDUZ)
        S STOP=$$NOW^XLFDT
        S DIFF=($$FMDIFF^XLFDT(STOP,START,2))/3600
        S CNT=$G(^XTMP("MPIFP51","TOTAL A24S"))
        D EMAIL(QUEDUZ,DIFF,CNT)
        K ^XTMP("MPIFP51")
        K QUEDUZ
        Q
SETUP   ;WANT TO $O THRU ^VA(15.3 -- NEED IA
        ;^VA(15.3,2,0)=2
        ;^VA(15.3,2,1,0)=^15.31A^159^159
        ;^VA(15.3,2,1,1,0)=7169803^7169804
        ;^VA(15.3,2,1,2,0)=100000011^7169922
        ;^VA(15.3,2,1,3,0)=100000039^100000040
        ;^VA(15.3,2,1,4,0)=7169675^17
        N %,X,Y,FILE,EN,TO,FROM,SITE,RETURN,CNT,ENT
        D NOW^%DTC S SITE=$P($$SITE^VASITE,"^",3),CNT=0
        S ^XTMP("MPIFP51",0)=%+30_"^"_%_"^MPIF*1*51 POST INIT"
        S FILE=2,EN=0
        F  S EN=$O(^VA(15.3,FILE,EN)) Q:EN=""  D
        .S ENT=0 F  S ENT=$O(^VA(15.3,FILE,EN,ENT)) Q:'ENT  D
        ..S FROM=$P($G(^VA(15.3,FILE,EN,ENT,0)),"^")
        ..S TO=$P($G(^VA(15.3,FILE,EN,ENT,0)),"^",2)
        ..;check to see what is the primary DFN for FROM record if the TO record has a -9 node
        ..I $D(^DPT(TO,-9)) D
        ...K RETURN D PRIMARY^MPIFRPC3(.RETURN,SITE,FROM)
        ...I $P(RETURN,"^")=-1 S ^XTMP("MPIFP51","ERROR",FROM)=RETURN Q
        ...I $P(RETURN,"^")'=1 S TO=$P(RETURN,"^")
        ..I $D(^XTMP("MPIFP51",TO)) S ^XTMP("MPIFP51",TO)=$G(^XTMP("MPIFP51",TO))_"^"_FROM
        ..I '$D(^XTMP("MPIFP51",TO)) S ^XTMP("MPIFP51",TO)=FROM
        ..S CNT=CNT+1
        S ^XTMP("MPIFP51","TOTAL")=CNT
        Q
        ;
START(QUEDUZ)   ;HAVE ALL THE DATA NOW IN XTMP TO SEND TO MPI
        N TO,CNT,PID2,ERR
        S TO=0,CNT=0
        D INIT^HLFNC2("MPIF ADT-A24 SERVER",.HL)
        F  S TO=$O(^XTMP("MPIFP51",TO)) Q:'TO  D
        .K PID2
        .D BLDPID^VAFCQRY(TO,2,"1,3,5",.PID2,.HL,.ERR)
        .D ADDDFNS(.PID2,.HL,TO)
        .D A24^MPIFA24B(TO,.PID2,1) S CNT=CNT+1
        S ^XTMP("MPIFP51","TOTAL A24S")=CNT
        Q
ADDDFNS(NPID,HL,TO)         ;ADDING DEPERATED DFNS TO PID2
        N MSG,EN,APID,LVL,PID,X,NXT,LNGTH,LVL2,SITE,Y,%,TPID,PDFN,DFNS,DFN,TAPID
        S EN=0,MSG="",SITE=$P($$SITE^VASITE(),"^",3)
        F  S EN=$O(NPID(EN)) Q:'EN  D
        .I EN=1 S MSG=NPID(EN)
        .I EN'=1 S MSG=MSG_NPID(EN)
        S APID(2)=2,APID(3)=""
        S APID(6)=$P(MSG,HL("FS"),6),APID(5)=""
        S TAPID(4)=$P(MSG,HL("FS"),4)
        I $L(TAPID(4))<246 S APID(4)=TAPID(4) S TAPID(4)=""
        S EN=1
AG      I $L(TAPID(4))>245 D
        .I EN=1 S APID(4)=$E(TAPID(4),1,245)
        .I EN=1 S TAPID(4)=$E(TAPID(4),246,$L(TAPID(4)))
        .S APID(4,EN)=$E(TAPID(4),1,245),EN=EN+1
        .S TAPID(4)=$E(TAPID(4),246,$L(TAPID(4)))
        I TAPID(4)'=""&($L(TAPID(4))>245) G AG
        I EN>1 S APID(4,EN)=TAPID(4)
        ;GET DEPRECATED DFNS
        D NOW^%DTC S PDFN=""
        S DFNS=$G(^XTMP("MPIFP51",TO)),HL("COMP")=$E(HL("ECH"),1),HL("SUBCOMP")=$E(HL("ECH"),4),HL("REP")=$E(HL("ECH"),2)
        S ENT=1 F  S DFN=$P(DFNS,"^",ENT) Q:DFN=""  D
        .S PDFN=HL("REP")_DFN_HL("COMP")_HL("COMP")_HL("COMP")_"USVHA"_HL("SUBCOMP")_HL("SUBCOMP")_"0363"_HL("COMP")_"PI"_HL("COMP")_"VA FACILITY ID"_HL("SUBCOMP")_SITE_HL("SUBCOMP")_"L"
        .S PDFN=PDFN_HL("COMP")_HL("COMP")_$$HLDATE^HLFNC($P(%,"."))
        .I $L($G(APID(4,EN)))+$L(PDFN)<245 S APID(4,EN)=$G(APID(4,EN))_PDFN,ENT=ENT+1 Q
        .I $L($G(APID(4,EN)))+$L(PDFN)>245 S EN=EN+1,APID(4,EN)=PDFN,ENT=ENT+1 Q
        ;S APID(4,EN)=APID(4,EN)_PDFN
        K NPID
        S NPID(1)="PID"_HL("FS")
        S LVL=1,X=1 F  S X=$O(APID(X)) Q:'X  D
        .S NPID(LVL)=$G(NPID(LVL))
        .S NXT=APID(X) D
        ..I '$O(APID(X,0)) S NXT=NXT_HL("FS")
        ..I $L($G(NPID(LVL))_NXT)>245 D
        ... S LNGTH=245-$L(NPID(LVL)),NPID(LVL)=NPID(LVL)_$E(NXT,1,LNGTH)
        ... S LNGTH=LNGTH+1,NXT=$E(NXT,LNGTH,$L(NXT)),LVL=LVL+1
        ..I $L($G(NPID(LVL))_NXT)'>245 S NPID(LVL)=$G(NPID(LVL))_NXT
        .S LVL2=0 F  S LVL2=$O(APID(X,LVL2)) Q:'LVL2  D
        ..S NXT=APID(X,LVL2) D
        ...I $L($G(NPID(LVL))_NXT)>245 S LNGTH=245-$L(NPID(LVL)),NPID(LVL)=NPID(LVL)_$E(NXT,1,LNGTH) S LNGTH=LNGTH+1,NXT=$E(NXT,LNGTH,$L(NXT)),LVL=LVL+1
        ...I $L($G(NPID(LVL))_NXT)'>245 S NPID(LVL)=$G(NPID(LVL))_NXT
        ...I '$O(APID(X,LVL2)) S NPID(LVL)=NPID(LVL)_HL("FS")
        Q
        ;
EMAIL(QUEDUZ,DIFF,CNT)   ;send results back to MPI
        N XMDUZ,XMSUB,SITENM,SITENUM,MPI,XMY,XMTEXT
        S SITENM=$P($$SITE^VASITE,"^",2),SITENUM=$P($$SITE^VASITE,"^",3)
        S XMDUZ="MPI AUSTIN"
        S XMSUB="MPIF*1.0*51 Post Init - "_SITENUM_"/"_SITENM
        S XMY("G.MPI POST INIT MONITOR@MPI-AUSTIN.MED.VA.GOV")="",XMTEXT="MPI(1,"
        S MPI(1,1)=SITENUM_"/"_SITENM_":   (Run Time = "_$J(DIFF,5,2)_" hrs)"
        S MPI(1,2)="Processed "_$G(^XTMP("MPIFP51","TOTAL"))_" merged records"
        S MPI(1,3)="Sent "_$G(^XTMP("MPIFP51","TOTAL A24S"))_" A24 messages"
        S MPI(1,4)=""
        D ^XMD
        ;send e-mail to local user who queued this job
        N XMDUZ,XMSUB,MPI,XMY,XMTEXT
        S XMDUZ="MPI AUSTIN"
        S XMSUB="MPIF*1.0*51 Post Init Complete."
        S XMY("`"_QUEDUZ_"@"_^XMB("NETNAME"))="",XMTEXT="MPI(1,"
        S MPI(1,1)="Post Init for patch MPIF*1.0*51 has run to completion."
        S MPI(1,2)="You should now delete routine ^MPIF51P."
        D ^XMD
        Q
