PRC1358C        ;WOIFO/LKG-1358 COMPLIANCE REPORTS ;5/17/09  23:37
        ;;5.1;IFCAP;**130**;Oct 20, 2000;Build 25
        ;Per VHA Directive 2004-038, this routine should not be modified.
IN1     ;Entry point for execution of scheduled 1358 compliance reports and
        ;start of logic for 1358 Separation of Duties Violations report
        N PRCDOW S PRCDOW=$$DOW^XLFDT($$NOW^XLFDT,1) Q:PRCDOW=0  ;Quit if Sunday
        N L,DIOBEG,DIOEND,DIC,DISUPNO,FLDS,BY,FR,TO,IOP,XMQUIET,XMDUZ,XMSUB,XMY
        S L=0,DIC=410,BY="[PRC SEPARATION VIOLATE]",FLDS="[PRC 1358 SEPARATION VIOL]"
        ;Set FR to "T-2" for Monday's output and "T-1" for other days
        S FR=$S(PRCDOW=1:"T-2",1:"T-1"),TO="T-1",IOP="P-MESSAGE-HFS;79"
        S XMQUIET=1,XMDUZ="1358 EXAMINER",XMSUB="1358 SEPARATION OF DUTIES VIOLATIONS"
        S XMY("G.PRC 1358 MONITORS")=""
        D EN1^DIP
IN2     ;Start of code for Missing Fields report
        K L,DIOBEG,DIOEND,DIC,DISUPNO,FLDS,BY,FR,TO,IOP,XMQUIET,XMDUZ,XMSUB,XMY
        S L=0,DIC=410,BY="[PRC MISSING 1358 FIELDS]",FLDS="[PRC 1358 MISSING FIELDS]"
        ;Set FR to "T-2" for Monday's output and "T-1" for other days
        S FR(3)=$S(PRCDOW=1:"T-2",1:"T-1"),TO(3)="T-1",IOP="P-MESSAGE-HFS;79"
        S XMQUIET=1,XMDUZ="1358 EXAMINER",XMSUB="1358 MISSING FIELDS"
        S XMY("G.PRC 1358 MONITORS")=""
        D EN1^DIP
        Q
        ;
IN3     ;Entry point for user interactive 1358 Separation of Duties Violations report
        N L,DIOBEG,DIOEND,DIC,DIPCRIT,DISUPNO,FLDS,BY,FR,TO,IOP,X S DIPCRIT=1
        S DIOBEG="W:$E(IOST,1,2)=""C-"" @IOF",DIOEND="R:$E(IOST,1,2)=""C-"" !,""Press RETURN to continue..."",X:DTIME"
        S L=0,DIC=410,BY="[PRC SEPARATION VIOLATE]",FLDS="[PRC 1358 SEPARATION VIOL]"
        D EN1^DIP
        Q
        ;
IN4     ;Entry point for user interactive Missing 1358 Fields report
        N L,DIOBEG,DIOEND,DIC,DIPCRIT,DISUPNO,FLDS,BY,FR,TO,IOP S DIPCRIT=1
        S DIOBEG="W:$E(IOST,1,2)=""C-"" @IOF",DIOEND="R:$E(IOST,1,2)=""C-"" !,""Press RETURN to continue..."",X:DTIME"
        S L=0,DIC=410,BY="[PRC MISSING 1358 FIELDS]",FLDS="[PRC 1358 MISSING FIELDS]"
        D EN1^DIP
        Q
