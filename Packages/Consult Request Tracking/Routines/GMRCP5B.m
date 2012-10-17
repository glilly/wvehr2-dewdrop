GMRCP5B ;SLC/DCM,RJS,WAT - Print Consult form 513 (Gather Data - Footers, Provisional Diagnosis and Reason For Request) ;09/10/08
        ;;3.0;CONSULT/REQUEST TRACKING;**4,13,12,15,24,23,22,29,65**;Dec 27, 1997;Build 7
        ;
        ; Patch #23 add "SERVICE RENDERED AS:" to SF513
        ; This routine invokes IA #1252 (SDUTL3),#10112 (VASITE)
        ; DBIA 10035      ;PATIENT FILE
        ; DBIA 2849       ;PROTOCOL
        ; DBIA 10060      ;NEW PERSON
        ; DBIA 10061      ;VADPT
        ; 10103                ;FMTE^XLFDT
        ; 10003                ;%DT
        ; 2056                  ;$$GET1^DIQ
        ; ICR 4156           ;REGISTRATION, COMBAT VETERAN STATUS
        Q
        ;
INIT(GMRCSG)    ; Initialize the form
        ;
        D HDR^GMRCP5D,FTR(.GMRCSG),REQUEST,PDIAG Q
        ;
REQUEST ;
        N GMRCX
        ;
        I $L($T(OUTPTPR^SDUTL3)) D
        .S GMRCX=$P($$OUTPTPR^SDUTL3(DFN),U,2)
        .D:$L(GMRCX) BLD("REQ",1,1,0,"Current Primary Care Provider: "_GMRCX)
        I $L($T(OUTPTTM^SDUTL3)) D
        .S GMRCX=$P($$OUTPTTM^SDUTL3(DFN),U,2)
        .D:$L(GMRCX) BLD("REQ",1,1,0,"    Current Primary Care Team: "_GMRCX)
        ;
        I $O(^TMP("GMRC",$J,"OUTPUT","REQ",0)) D BLD("REQ",1,1,0,"")
        ;
        D SUB("H","REQ",1,"Reason For Request continued.")
        D SUB("H","REQ",1," ")
        ;
        D BLD("REQ",1,1,0,"REASON FOR REQUEST: (Complaints and findings)")
        I '$O(^GMR(123,GMRCIFN,20,0)) D BLD("REQ",1,1,0,"") I 1
        E  D
        .N LN S LN=0 F  S LN=$O(^GMR(123,GMRCIFN,20,LN)) Q:LN=""  D
        ..D BLD("REQ",1,1,0,^GMR(123,GMRCIFN,20,LN,0))
        ;
        Q
PDIAG   ;
        ;
        D BLD("PDIAG",1,1,0,"PROVISIONAL DIAG: "_$G(^GMR(123,GMRCIFN,30)))
        D BLD("PDIAG",1,1,0,GMRCDVL)
        ;
        S (GMRCQSTR,GMRCPGR,GMRCIPH,GMRCQSTT)=""
        ;
        I $S('$P(GMRCRD,U,23):1,$P(GMRCRD(12),U,5)="P":1,1:0) D
        .S GMRCQSTR=$P(GMRCRD,U,14)
        .S:'GMRCQSTR GMRCQSTR=$$GET1^DIQ(100,+$P(GMRCRD,U,3),1)
        .S GMRCPGR=$$GET1^DIQ(200,+$G(GMRCQSTR),.137) S:'$L(GMRCPGR) GMRCPGR=$$GET1^DIQ(200,+$G(GMRCQSTR),.138)
        .S GMRCIPH=$$GET1^DIQ(200,+$G(GMRCQSTR),.132)
        .;
        .S GMRCQSTT=$$GET1^DIQ(200,+$G(GMRCQSTR),20.3)
        .S:'$L(GMRCQSTT) GMRCQSTT=$$GET1^DIQ(200,+$G(GMRCQSTR),8)
        .S GMRCQSTR=$$GET1^DIQ(200,+$G(GMRCQSTR),.01)
        ;
        I $P(GMRCRD,U,23),$P(GMRCRD(12),U,5)="F" D
        .S GMRCQSTR=$P(GMRCRD(12),U,6)
        .S GMRCIPH=$P(GMRCRD(13),U,2)
        .S GMRCPGR=$P(GMRCRD(13),U,3)
        ;
        S GMRCIPH="(Phone: "_GMRCIPH_")"
        S GMRCPGR="(Pager: "_GMRCPGR_")"
        ;
        D BLD("PDIAG",1,1,0,"REQUESTED BY: ")
        D BLD("PDIAG",1,0,35,"|PLACE:")
        D BLD("PDIAG",1,0,59,"|URGENCY:")
        ;
        D BLD("PDIAG",1,1,0,$E(GMRCQSTR,1,37))
        D BLD("PDIAG",1,0,35,"|"_$E($P($G(^ORD(101,+$P(GMRCRD,U,10),0)),U,2),1,20))
        D BLD("PDIAG",1,0,59,"|"_$E($P($G(^ORD(101,+$P(GMRCRD,U,9),0)),U,2),1,18))
        ;
        I $L(GMRCQSTT) D
        .D BLD("PDIAG",1,1,0,GMRCQSTT)
        .D BLD("PDIAG",1,0,35,"|")
        .D BLD("PDIAG",1,0,59,"|")
        D BLD("PDIAG",1,1,0,GMRCPGR)
        D BLD("PDIAG",1,0,35,"|SERVICE RENDERED AS:")
        D BLD("PDIAG",1,0,59,"|")
        S GMRCINOU=$S($P(GMRCRD,U,18)="O":"Outpatient",1:"Inpatient")
        I $D(GMRCIPH)>0 D
        .D BLD("PDIAG",1,1,0,GMRCIPH)
        .D BLD("PDIAG",1,0,35,"|"_GMRCINOU)
        E  D
        .D BLD("PDIAG",1,1,35,"|"_GMRCINOU)
        D BLD("PDIAG",1,0,59,"|")
        K GMRCINOU
        ;***************************************************************
        D BLD("PDIAG",1,1,0,GMRCDVL)
        ;
        Q
        ;
FTR(GMRCSG)     ;Footer of form 513
        ;
        N GMRCRMBD,GMRCFAC1,GMRCLOC,GMRCX,SUB,VAIN,VAPA,VAERR
        ;
        D ADD^VADPT,INP^VADPT
        ;
        S (GMRCLOC,GMRCRMBD)=""
        S GMRCLOC=$P($G(VAIN(4)),U,2)
        S GMRCRMBD=$G(VAIN(5))
        S:'$L(GMRCLOC) GMRCLOC=$P($G(^SC(+$P($G(^GMR(123,+GMRCIFN,0)),U,4),0)),U,1)
        ;No location, IFC - consulting site
        I '$L(GMRCLOC),$P(GMRCRD,U,23),$P($G(GMRCRD(12)),U,5)="F" D
        .I $P(GMRCRD,U,21) S GMRCLOC=$$GET1^DIQ(4,$P(GMRCRD,U,21),.01)
        .E  S GMRCLOC=$$GET1^DIQ(4,$P(GMRCRD,U,23),.01)
        S:'$L(GMRCLOC) GMRCLOC=GMRCUL
        ;
        D BLD("FTR",0,1,0,GMRCEQL)
        D BLD("FTR",1,1,0,GMRCEQL)
        ;
        I ($G(GMRCSG("GMRCSIGM"))="electronic") D  I 1
        .D BLD("FTR",0,1,0,"SIGNATURE & TITLE: ")
        .D BLD("FTR",0,0,20,$G(GMRCSG("GMRCSIG"))_" /es/")
        .D BLD("FTR",0,0,54,"|")
        .D BLD("FTR",0,1,20,$G(GMRCSG("GMRCSIGT")))
        .D BLD("FTR",0,0,54,"|DATE: "_$$EXDT($G(GMRCSG("GMRCSDT"))))
        E  D
        .D BLD("FTR",0,1,0,"AUTHOR & TITLE: ")
        .D BLD("FTR",0,0,20,$G(GMRCSG("GMRCSIG")))
        .D BLD("FTR",0,0,54,"|")
        .D BLD("FTR",0,1,20,$G(GMRCSG("GMRCSIGT")))
        .D BLD("FTR",0,0,54,"|DATE: "_$$EXDT($G(GMRCSG("GMRCSDT"))))
        ;
        S GMRCFAC1=+$G(DUZ(2))
        S:'GMRCFAC1 GMRCFAC1=+$$SITE^VASITE()
        S GMRCFAC1=$$GET1^DIQ(4,+GMRCFAC1,.01)
        ;
        D BLD("FTR",0,1,0,GMRCDVL)
        D BLD("FTR",0,1,0,"ID #:"_$E(GMRCUL,1,8))
        D BLD("FTR",0,0,12,"|ORGANIZATION:"_$J($E(GMRCFAC1,1,17),17))
        D BLD("FTR",0,0,45,"|REG #:"_$E(GMRCUL,1,4))
        D BLD("FTR",0,0,58,"|LOC: "_$E($G(GMRCLOC),1,11))
        ;
        I $L(GMRCRMBD) D  I 1
        .D BLD("FTR",0,1,12,"|")
        .D BLD("FTR",0,0,45,"|")
        .D BLD("FTR",0,0,58,"|RM/BD: "_GMRCRMBD)
        ;
        D BLD("FTR",0,1,0,GMRCDVL)
        ;
        F SUB=0,1 D
        .I SUB D BLD("FTR",SUB,1,33,"Page ","GMRCPG,38"_" FIRST ONE") I 1
        .E  I '$G(GMRCGUI) D BLD("FTR",SUB,1,33,"Page ","GMRCPG,38"_" SECOND ONE")
        I $G(GMRCPG)=0 D BLD("FTR",0,1,51,"Standard Form 513 (Rev 9-77)")
        Q
        ;
CONSRQ(GMRCRQ)  ;
        ;
        N ORND,ORFL,REF
        I '$L(GMRCRQ) Q "Consult"
        S ORND=$P(GMRCRQ,";",1),ORFL=$P(GMRCRQ,";",2),REF=U_ORFL_ORND_",0)"
        S GMRCRQ=$P($G(@(REF)),U,2)
        Q:$L(GMRCRQ) GMRCRQ Q "Consult"
        ;
EXDT(X) ;EXTERNAL DATE FORMAT
        ;
        N DATE,TIME,HR,MN,PD,Y,%DT
        Q:'$L(X) ""
        I '(X?7N.1".".6N) S %DT="PTS" D ^%DT S X=Y
        Q $$FMTE^XLFDT(X,"5PMZ")
        ;
PRCMT(CMT)      ;
        ;
        Q $P($G(^GMR(123.1,+CMT,0)),U,8)
        ;
        ;
BLD(SUB,NDX,LINE,TAB,TEXT,RUNTIME)      ;
        ;
        Q:'$L($G(SUB))
        N LINECNT
        ;
        F LINECNT=1:1:+LINE S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX)+1,0)=""
        ;
        S $E(^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX),0),TAB+1)=TEXT
        I $L($G(RUNTIME)) S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,$$LASTLN(SUB,NDX),1)=RUNTIME
        ;
        S GMRCLAST=SUB
        Q
        ;
SUB(ZONE,SUB,NDX,TEXT)  ;
        ;
        N NEXT
        S NEXT=$O(^TMP("GMRC",$J,"OUTPUT",SUB,NDX,ZONE," "),-1)+1
        S ^TMP("GMRC",$J,"OUTPUT",SUB,NDX,ZONE,NEXT,0)=TEXT
        Q
        ;
LASTLN(SUB,NDX) ;
        Q +$O(^TMP("GMRC",$J,"OUTPUT",SUB,NDX," "),-1)
        ;
