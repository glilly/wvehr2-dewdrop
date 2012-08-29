GMTSPN2 ; SLC/KER - Progress Note Signatures           ; 8/1/06 4:24pm
        ;;2.7;Health Summary;**45,47,49,82**;Oct 20, 1995;Build 21
        Q
        ;                          
        ; External References
        ;   DBIA 10011  ^DIWP
        ;   DBIA  2056  $$GET1^DIQ
        ;   DBIA 10060  ^VA(200, .137
        ;   DBIA 10060  ^VA(200, .138
        ;                     
WS(X,I) ; Write Signatures 
        Q:$D(GMTSQIT)  N GMTSDIC,GMTSIEN,GMTSA,GMTSG S GMTSDIC=$G(X),GMTSIEN=$G(I)
        Q:'$L(GMTSIEN)  Q:$E($P(GMTSDIC,$J,1),1,11)'="^TMP(""TIU"","  Q:'$D(@($P(GMTSDIC,",",1,($L(GMTSDIC,",")-1))_")"))
        Q:'$D(@(GMTSDIC_GMTSIEN_")"))  S GMTSDIC=GMTSDIC_GMTSIEN_","
        D UNS,SOC,SIG,UNC,COC,COS,EXT
        Q
UNS     ;   Unsigned/Draft Copy
        Q:$D(GMTSQIT)  N GMTST S GMTST=$G(@(GMTSDIC_"1501,""I"")")) D:GMTST="" UNSIG
        Q
SOC     ;   Signed on Chart
        Q:$D(GMTSQIT)  N GMTSP,GMTSB S GMTSP=$G(PN("SCHART"))
        S GMTSB=$G(PN("SCHARTBY")) Q:'$L(GMTSP)  Q:'$L(GMTSB)
        D BL Q:$D(GMTSQIT)  D BY(GMTSP,"",GMTSB) Q:$D(GMTSQIT)
        Q
SIG     ;   Signature Block, Name, Title and Date
        Q:$D(GMTSQIT)  N GMTSA,GMTSG,GMTSE,GMTST,GMTSD,GMTSP,GMTSB
        S GMTSP="Signed by:",GMTSE=$G(@(GMTSDIC_"1505,""I"")"))
        S GMTSB=$G(PN("SIGBLK")) Q:'$L(GMTSB)  S GMTST=$G(PN("STITLE"))
        S GMTSD=$G(PN("SIGDT")),GMTSA=$$GET1^DIQ(200,+($G(SIGNEDBY)),.137)
        S GMTSG=$$GET1^DIQ(200,+($G(SIGNEDBY)),.138) D BL Q:$D(GMTSQIT)
        D BY(GMTSP,GMTSE,GMTSB) Q:$D(GMTSQIT)  D SB(GMTST,GMTSD) Q:$D(GMTSQIT)
        D PG(GMTSA,GMTSG) Q:$D(GMTSQIT)
        Q
UNC     ;   Uncosigned - Requires Cosignature
        Q:$D(GMTSQIT)  N GMTSP,GMTSB
        S GMTSP=$G(@(GMTSDIC_".05,""E"")")) Q:GMTSP'="UNCOSIGNED"
        Q:$E($G(GMTSTIUC),1)["D"&('CONEED)  D BL Q:$D(GMTSQIT)
        D CKP^GMTSUP Q:$D(GMTSQIT)  W !?27,"** REQUIRES COSIGNATURE **"
        Q
COC     ;   Cosigned on Chart
        Q:$D(GMTSQIT)  N GMTSP,GMTSB
        S GMTSP=$G(PN("COCHART")),GMTSB=$G(PN("COCHARTBY")) Q:'$L(GMTSP)  Q:'$L(GMTSB)
        Q:$E($G(GMTSTIUC),1)["D"&('CONEED)  D BL Q:$D(GMTSQIT)  D BY(GMTSP,"",GMTSB)
        Q
COS     ;   Co-Signature Block, Name, Title and Date
        Q:$D(GMTSQIT)  N GMTSA,GMTSG,GMTSE,GMTST,GMTSD,GMTSP,GMTSB
        S GMTSP="Cosigned by:",GMTSE=$G(@(GMTSDIC_"1511,""I"")")),GMTSB=$G(PN("COBLK")) Q:'$L(GMTSB)
        S GMTST=$G(PN("COTITLE")),GMTSD=$G(PN("COSDT"))
        S GMTSA=$$GET1^DIQ(200,+($G(COSGEDBY)),.137),GMTSG=$$GET1^DIQ(200,+($G(COSGEDBY)),.138)
        Q:$E($G(GMTSTIUC),1)["D"&('CONEED)  D BL Q:$D(GMTSQIT)
        D BY(GMTSP,GMTSE,GMTSB) Q:$D(GMTSQIT)  D SB(GMTST,GMTSD) Q:$D(GMTSQIT)
        D PG(GMTSA,GMTSG)
        Q
EXT     ;   Extra Signatures
        ;     Receipt Acknowledged by:
        Q:$D(GMTSQIT)  I +$O(@(GMTSDIC_"""EXTRASGNR"",0)")) D  Q:$D(GMTSQIT)
        . D BL Q:$D(GMTSQIT)  D BY("Receipt Acknowledged by:","","")
        ;     Extra Signature Block, Name, Title and Date
        N GMTSXTRA S GMTSXTRA=0
        F  S GMTSXTRA=+$O(@(GMTSDIC_"""EXTRASGNR"","_GMTSXTRA_")")) Q:+GMTSXTRA'>0  D  Q:$D(GMTSQIT)
        . N GMTSA,GMTSG,GMTSE,GMTST,GMTSD,GMTSP,GMTSB,GMTSI,GMTSC
        . S GMTSC=+($G(@(GMTSDIC_"""EXTRASGNR"","_GMTSXTRA_",""DATE"")")))
        . I GMTSC'>0 W ?27,"* AWAITING SIGNATURE *" D BL Q
        . S GMTSP="",GMTSE="/es/",GMTSB=$G(@(GMTSDIC_"""EXTRASGNR"","_GMTSXTRA_",""NAME"")")) Q:'$L(GMTSB)
        . S GMTST=$G(@(GMTSDIC_"""EXTRASGNR"","_GMTSXTRA_",""TITLE"")"))
        . S GMTSD=$$EDT^GMTSU(GMTSC),GMTSI=+($G(@(GMTSDIC_"""EXTRASGNR"","_GMTSXTRA_",""EXTRA"")")))
        . S GMTSA=$$GET1^DIQ(200,+($G(GMTSI)),.137),GMTSG=$$GET1^DIQ(200,+($G(GMTSI)),.138)
        . I +($G(GMTSXTRA))>1 D BL Q:$D(GMTSQIT)  D BL Q:$D(GMTSQIT)
        . D BY(GMTSP,GMTSE,GMTSB) Q:$D(GMTSQIT)
        . D SB(GMTST,GMTSD) Q:$D(GMTSQIT)  D PG(GMTSA,GMTSG) Q:$D(GMTSQIT)
        Q
        ;                      
UNSIG   ; Unsigned Note
        N GMTS,GMTS1,GMTS2,GMTST,GMTSB S GMTST="<  THE ABOVE NOTE IS UNSIGNED  >",GMTS=""
        S $P(GMTS," ",((79-$L(GMTST))\2)\2)=" ",$P(GMTS1," ",((79-$L(GMTST))\2)\2)=" "
        S GMTS2=GMTS_GMTS1,GMTS1=GMTS1_GMTS,GMTSB=GMTS1_GMTST_GMTS2
        D CKP^GMTSUP Q:$D(GMTSQIT)  W ! D CKP^GMTSUP Q:$D(GMTSQIT)  W !,GMTSB
        D CKP^GMTSUP Q:$D(GMTSQIT)  W !,"- DRAFT COPY * DRAFT COPY * DRAFT COPY * DRAFT COPY * DRAFT COPY * DRAFT COPY -"
        Q
        ;                        
        ; Warnings
WARN1   ;   Beginning of Note
        N GMTSD,GMTSW S GMTSW=1,GMTSD=0 D DEL1,RETR1 D:GMTSD BL Q
WARN2   ;   End of Note
        N GMTSD,GMTSW S GMTSW=2,GMTSD=0 D DEL2,RETR2 Q
DEL1    ;     Deleted Note (begin)
        Q:($G(STATUS)'="DELETED")&($G(PN("STATUS"))'="DELETED")
        N GMTST,GMTST2 S GMTST="<  THE FOLLOWING ENTRY HAS BEEN DELETED >",GMTST2="<<<<< DELETED  *  DELETED  *  DELETED  *  DELETED  *  DELETED  *  DELETED >>>>>" D WARN3 Q
DEL2    ;     Deleted Note (end)
        Q:($G(STATUS)'="DELETED")&($G(PN("STATUS"))'="DELETED")
        N GMTST,GMTST2 S GMTST="<  THE ABOVE ENTRY HAS BEEN DELETED >",GMTST2="<<<<< DELETED  *  DELETED  *  DELETED  *  DELETED  *  DELETED  *  DELETED >>>>>" D WARN3 Q
RETR1   ;     Retracted Note (begin)
        Q:($G(STATUS)'="RETRACTED")&($G(PN("STATUS"))'="RETRACTED")
        N GMTST,GMTST2 S GMTST="<  THE FOLLOWING ENTRY HAS BEEN RETRACTED >",GMTST2="<<<<<< RETRACTED  *  RETRACTED  *  RETRACTED  *  RETRACTED  *  RETRACTED >>>>>>" D WARN3 Q
RETR2   ;     Retracted Note (end)
        Q:($G(STATUS)'="RETRACTED")&($G(PN("STATUS"))'="RETRACTED")
        N GMTST,GMTST2 S GMTST="<  THE ABOVE ENTRY HAS BEEN RETRACTED >",GMTST2="<<<<<< RETRACTED  *  RETRACTED  *  RETRACTED  *  RETRACTED  *  RETRACTED >>>>>>" D WARN3 Q
WARN3   ;   Warning Display (display)
        N GMTS,GMTS1,GMTS2,GMTSB S GMTS="",GMTST=$G(GMTST),GMTST2=$G(GMTST2) Q:'$L(GMTST)  Q:'$L(GMTST2)
        S $P(GMTS,"<",((79-$L(GMTST))\2)\2)="<"
        S $P(GMTS1,"<",((79-$L(GMTST))\2)\2)="<",GMTS1=GMTS_GMTS1,GMTS=""
        S $P(GMTS,">",((79-$L(GMTST))\2)\2)=">"
        S $P(GMTS2,">",((79-$L(GMTST))\2)\2)=">",GMTS2=GMTS2_GMTS,GMTS=""
        S GMTSB=GMTS1_GMTST_GMTS2 F  Q:$L(GMTSB)'<$L(GMTST2)  S GMTSB=GMTSB_">"
        I +($G(GMTSW))=2 D BL Q:$D(GMTSQIT)
        I +($G(GMTSW))=1 D CKP^GMTSUP Q:$D(GMTSQIT)  W !,GMTSB
        D CKP^GMTSUP Q:$D(GMTSQIT)  W !,GMTST2 S:$D(GMTSD) GMTSD=1
        I +($G(GMTSW))=2 D CKP^GMTSUP Q:$D(GMTSQIT)  W !,GMTSB
        Q
        ;                   
        ; Miscelaneous
BY(GMTSH,GMTSE,GMTSN)   ; Signed by
        S GMTSH=$$TRIM($G(GMTSH)),GMTSE=$G(GMTSE),GMTSN=$G(GMTSN) Q:'$L((GMTSH_GMTSN))
        S:$L(GMTSH) GMTSH=GMTSH_"  " S GMTSE=$S(GMTSE="E":"/es/  ",GMTSE["/es/":"/es/  ",1:"") S:GMTSN="."&(GMTSH[" by:") GMTSH=$P(GMTSH," by:",1)_".",GMTSN="" S:GMTSN="." GMTSN=""
        I $L($$TRIM(GMTSH)) D CKP^GMTSUP Q:$D(GMTSQIT)  W !,$J("",(27-$L(GMTSH))),GMTSH
        W ?27,GMTSE,GMTSN
        Q
SB(GMTSB,GMTSD) ; Signature Block
        K ^UTILITY($J,"W") N X,DIWT,DIWL,DIWR,DIWF,GMTSI
        S (X,GMTSB)=$G(GMTSB),GMTSD=$G(GMTSD) Q:'$L((GMTSB_GMTSD))
        S GMTSI=1,DIWL=0,DIWF="C51" D ^DIWP S GMTSB=$$TRIM($G(^UTILITY($J,"W",0,1,0))) K:'$L(GMTSB) ^UTILITY($J,"W")
        I $L(GMTSD),'$L(GMTSB) K ^UTILITY($J,"W") D CKP^GMTSUP Q:$D(GMTSQIT)  W !,?27,GMTSD Q
        Q:'$L(GMTSB)  D CKP^GMTSUP K:$D(GMTSQIT) ^UTILITY($J,"W") Q:$D(GMTSQIT)  W !,?27,GMTSB,!,?27,GMTSD
        K ^UTILITY($J,"W")
        Q
PG(GMTSA,GMTSD) ; Pagers
        N GMTS S GMTS=0,GMTSA=$G(GMTSA),GMTSD=$G(GMTSD) Q:'$L((GMTSA_GMTSD))  Q:(+GMTSA+GMTSD)'>0
        D CKP^GMTSUP Q:$D(GMTSQIT)  W ! I $L(GMTSA),+GMTSA>0 D  Q:$D(GMTSQIT)
        . D CKP^GMTSUP Q:$D(GMTSQIT)  W !?34,"Analog Pager:  ",GMTSA S GMTS=1
        I $L(GMTSD),+GMTSD>0 D  Q:$D(GMTSQIT)
        . D CKP^GMTSUP Q:$D(GMTSQIT)  W !?33,"Digital Pager:  ",GMTSD S GMTS=1
        Q
BL      ;   Blank Line
        D CKP^GMTSUP Q:$D(GMTSQIT)  W ! Q
TRIM(X) ;   Trim Spaces from String
        S X=$G(X) F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
        F  Q:$E(X,$L(X))'=" "  S X=$E(X,1,($L(X)-1))
        Q X
