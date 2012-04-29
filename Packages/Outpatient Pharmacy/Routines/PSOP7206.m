PSOP7206        ;SMT - PSO*7*206 Post Install ; 10/17/07 7:40am
        ;;7.0;OUTPATIENT PHARMACY;**206**;APR 2007;Build 39
        ;
        ;Enter at EN^PSOP7206 for POST INSTALL PSO*7*206
        ;Cleanup routine, to fix erroneous listings of partials in the
        ;activity log.
        ;
        ;
EN      ;
        N XMMG,XMSTRIP,XMROU,XMYBLOB,XMZ,XMDUZ,XMSUB,XMTEXT,DIFROM,XMY,X,CNT,OP,VAR
        S OP(1)="DRUG DEA CODES MAY HAVE CHANGED. PATCH PSO*7*206 HAS BEEN INSTALLED."
        S OP(2)="SCHEDULING CHANGES HAVE BEEN MADE AND SHOULD HAVE BEEN VERIFIED."
        S OP(3)="FOR MORE INFORMATION PLEASE SEE PATCH PSS*1*126."
        S XMDUZ=.5,XMSUB="VERIFY DRUG SCHEDULING CHANGES",XMTEXT="OP("
        S X="" F  S X=$O(^XUSEC("PSNMGR",X)) Q:'X  S XMY(X)=""
        D ^XMD
        Q
        ;
