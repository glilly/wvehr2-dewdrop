CWMAIL4 ;INDPLS/PLS- DELPHI VISTA MAIL SERVER, CON'T ;21-Jun-2005 06:34;CLC
        ;;2.3;CWMAIL;;Jul 19, 2005
        Q   ;ROUTINE CAN'T BE CALLED DIRECTLY
        ;
GETMSGL(DAT,CWDUZ,CWBSK,CWSRC)  ;
        ;API NOT CURRENTLY USED
        ;INPUT
        ;  DAT : RETURN ARRAY
        ;CWDUZ : USER
        ;CWBSK : BASKET IEN OR NAME
        ;CWSRC : LOOKUP TYPE 0(IEN); 1("C" X-REF) ; DEFAULT TO ZERO
        Q:'CWDUZ 0
        I +CWBSK'=CWBSK D
        . S CWBSK=+$O(^XMB(3.7,CWDUZ,2,"B",CWBSK,0))
        S CWSRC=+$G(CWSRC,0)
        N CWMSG,CWSEQ
        S (CWSEQ,CWMSG)=0
        I 'CWSRC D
        . F  S CWMSG=$O(^XMB(3.7,CWDUZ,2,CWBSK,1,CWMSG)) Q:CWMSG<1  S DAT(CWMSG)=""
ELSE    E  D
        . F  S CWSEQ=$O(^XMB(3.7,CWDUZ,2,CWBSK,1,"C",CWSEQ)) Q:CWSEQ<1  D
        . . F  S CWMSG=$O(^XMB(3.7,CWDUZ,2,CWBSK,1,"C",CWSEQ,CWMSG)) Q:CWMSG<1  D
        . . . S DAT(CWMSG)=""
        Q $O(DAT(0))>0
        ;
FMDTE(CWDT,CWPRM)       ;API TO RETURN A FORMATTED DATE
        ;replaces '@' with " " between date and time
        Q $TR($$FMTE^XLFDT(CWDT,CWPRM),"@"," ")
