DGENUPLB        ;ALB/TDM - PROCESS INCOMING (Z11 EVENT TYPE) HL7 MESSAGES ; 11/14/07 3:02pm
        ;;5.3;REGISTRATION;**625,763**;Aug 13,1993;Build 9
        ;
EP      N MSGARY
        D CHECK
        Q
        ;
CHECK   ;Check for Rated Disability Changes
        Q:'$D(DGELG)
        N RDOCC,TMPARY,RD,RDOCC1,RDOCC2,RDFLG,RDNOD
        ;
        ;Change in Rated Disabilities
        I $D(OLDELG("RATEDIS")) D
        .S RDOCC=0 F  S RDOCC=$O(OLDELG("RATEDIS",RDOCC)) Q:RDOCC=""  D
        ..S RD=$P(OLDELG("RATEDIS",RDOCC,"RD"),"^") Q:RD=""
        ..S TMPARY(RD)=RDOCC
        ;
        I $D(DGELG("RATEDIS")) D
        .S RDOCC=0 F  S RDOCC=$O(DGELG("RATEDIS",RDOCC)) Q:RDOCC=""  D
        ..S RD=$P(DGELG("RATEDIS",RDOCC,"RD"),"^") Q:RD=""
        ..S $P(TMPARY(RD),"^",2)=RDOCC
        ;
        I $D(TMPARY) D
        .S RD=""
        .F  S RD=$O(TMPARY(RD)) Q:RD=""  D
        ..S RDOCC2=+$P(TMPARY(RD),"^",2) Q:'RDOCC2
        ..S RDOCC1=+$P(TMPARY(RD),"^")
        ..I 'RDOCC1 D STOR390 Q
        ..S RDFLG=0
        ..F RDNOD="RD","PER","RDSC","RDEXT","RDORIG","RDCURR" D  Q:RDFLG
        ...I $G(OLDELG("RATEDIS",RDOCC1,RDNOD))'=$G(DGELG("RATEDIS",RDOCC2,RDNOD)) D STOR390
        Q
        ;
STOR390 ;Store Data in file# 390
        S RDFLG=1
        N DATA,DA
        S DATA(.01)=$$NOW^XLFDT
        S DATA(2)=DFN
        S DATA(3)=DGELG("RATEDIS",RDOCC2,"RD")
        S DATA(4)=DGELG("RATEDIS",RDOCC2,"PER")
        S DATA(5)=DGELG("RATEDIS",RDOCC2,"RDEXT")
        S DATA(6)=DGELG("RATEDIS",RDOCC2,"RDORIG")
        S DATA(7)=DGELG("RATEDIS",RDOCC2,"RDCURR")
        I '$$ADD^DGENDBS(390,,.DATA) S ERROR="FILEMAN FAILED TO ADD RATED DISABILITY UPLOAD AUDIT"
        Q
