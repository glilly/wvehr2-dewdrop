DGRPU1  ;ALB/REW CUSTOM LOAD/EDIT SCREEN UTILITIES ;9-FEB-92
        ;;5.3;Registration;**139,169,415,527,508,664**;Aug 13, 1993;Build 15
        ;
QUES(DFN,DGQCODE)       ; EDIT SPECIFIC PORTIONS OF REGISTRATION DATA
        ;
        ;  INPUT:
        ;     DFN
        ;     DGQCODE = Code for question(s) to be asked
        ;  OUTPUT:
        ;     DGERR   = ERROR VARIABLE
        ;     DGCHANGE= 1 IF DATA MODIFIED 0 O/W
        ;  USED:
        ;     DGPTND  = Prior value(s) of Patient File node(s) [array]
        ;     DGQNODES= Node(s) used above
        ;     DGNODE  = Single node
        ;     DGDR    = edit=screen*10+item #
        ;     DGRPS   = Screen #
        ;     DGCODE  = CODE used by ^DGRPE
        ;     DGQ     = String of ^DGCODE^DGCODE etc.
        ;     DGPC    = Piece Number
        ;     DGX     = Line Tag offset
        ;
        N D,D0,DI,DIC,DGCODE,DGDR,DGNODE,DGQNODES,DGPC,DGPTND,DGRPS,DGQ,DGX
        N DQ,N,X,Y,%Y,DGPTNDM
        S (DGERR,DGRPS,DGCHANGE)=0
        I '($G(DFN)&$D(DGQCODE)) G QTE
        F DGX=1:1 S DGQ=$T(QDES+DGX) Q:DGQ[(U_DGQCODE_U)!(DGQ']"")
        F DGPC=2:1 S DGCODE=$P(DGQ,U,DGPC) Q:(DGCODE']"")!(DGCODE=DGQCODE)
        G:DGCODE']"" QTE
        S DGDR=$P($T(QNUM+DGX),U,DGPC)
        S DGRPS=DGDR\100
        S DGQNODES=$P($T(QNODE+DGX),U,DGPC)
        F N=1:1 S DGNODE=$P(DGQNODES,"~",N) Q:DGNODE']""  S DGPTND(DGNODE)=$G(^DPT(DFN,DGNODE))
        S DGQNODES=$P($T(MNODE+DGX),U,DGPC)
        F N=1:1 S DGNODE=$P(DGQNODES,"~",N) Q:DGNODE']""  M DGPTNDM(DGNODE)=^DPT(DFN,DGNODE) S DGPTNDM(DGNODE)=""
        D ^DGRPE
        F DGNODE=0:0 S DGNODE=$O(DGPTND(DGNODE)) Q:DGNODE']""  S:$G(^DPT(DFN,DGNODE))'=(DGPTND(DGNODE)) DGCHANGE=1
        S DGNODE="" F  S DGNODE=$O(DGPTNDM(DGNODE)) Q:DGNODE']""  D  Q:DGCHANGE
        .S X=0 F  S X=$O(DGPTNDM(DGNODE,X)) Q:'X  D  Q:DGCHANGE
        ..S Y="" F  S Y=$O(DGPTNDM(DGNODE,X,Y)) Q:Y']""  D  Q:DGCHANGE
        ...I $G(^DPT(DFN,DGNODE,X,Y))'=DGPTNDM(DGNODE,X,Y) S DGCHANGE=1
        .Q:DGCHANGE
        .S X=0 F  S X=$O(^DPT(DGNODE,X)) Q:'X  D  Q:DGCHANGE
        ..S Y="" F  S Y=$O(^DPT(DGNODE,X,Y)) Q:Y']""  D  Q:DGCHANGE
        ...I $G(^DPT(DFN,DGNODE,X,Y))'=DGPTNDM(DGNODE,X,Y) S DGCHANGE=1
QTE     I 'DGRPS S DGERR=1
QTQ     Q
QDES    ;MNEMONIC - DGQCODE should match with one of these
        ;;^ADD1^ADD2^ADD^ADD3^ADD4^
QNUM    ;REFERENCE NUMBERS USED TO SET DGDR FOR USE BY ^DGRPE
        ;;^104^105^109,105,112^109,105,111^111^
        ;;
QNODE   ;;NODES OF THE PATIENT FILE
        ;;^.11~.13^.121^.11~.121~.13^.11~.121~.13~.141^.141^
        ;;
MNODE   ;;MULTIPLES OF THE PATIENT FILE
        ;;^^^.02~.06^.02~.06~.14^.14^
