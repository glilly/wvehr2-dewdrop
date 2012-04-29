OCXOCMP8        ;SLC/RJS,CLA - ORDER CHECK CODE COMPILER (Assemble Order Check Routines utilities) ;10/29/98  12:37
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,243**;Dec 17,1997;Build 242
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        ;
        Q
FILE(RNUM)      ;
        ;
        W:'$G(OCXAUTO) !,$$RNAM(RNUM)
        N DIE,XCN,X
        S DIE="^TMP(""OCXCMP"",$J,""D CODE"","_RNUM_",",XCN=0,X=$$RNAM(RNUM)
        X ^%ZOSF("SAVE")
        Q
        ;
APPEND(DSUB,CSUB,SRC,LABEL)     ;
        ;
        N OCXSRC,OCXNDX,OCXNEXT,GLD,GLC
        S GLD="^TMP(""OCXCMP"",$J,""D CODE"","_(+DSUB)_")"
        I (CSUB="$") D  Q
        .S OCXNEXT=$O(@GLD@(" "),-1)+1
        .S @GLD@(OCXNEXT,0)="$"
        .S OCXNEXT=$O(@GLD@(" "),-1)+1
        .S @GLD@(OCXNEXT,0)=""
        ;
        I (SRC="C") M GLC=^TMP("OCXCMP",$J,"C CODE",+CSUB) S ^TMP("OCXCMP",$J,"D CODE","LINE",LABEL)=DSUB_","_($O(@GLD@(" "),-1)+1)
        I (SRC="F") M GLC=^TMP("OCXCMP",$J,"INCLUDE",CSUB)
        S OCXNDX=0 F  S OCXNDX=$O(GLC(OCXNDX)) Q:'OCXNDX  D
        .S OCXNEXT=$O(@GLD@(" "),-1)+1
        .S @GLD@(OCXNEXT,0)=GLC(OCXNDX,0)
        M @GLD@("CALLS")=GLC("CALLS")
        S @GLD@("SIZE")=$G(@GLD@("SIZE"))+$G(GLC("SIZE"))
        Q
        ;
SIZE(DSUB,CSUB) ;
        ;
        N D0,EFC,OCXEFC,OCXEFD,OCXEFF,OCXREC
        N OCXTEMP,PIEC,SIZEC,SIZED,SIZEF,TEXT
        ;
        S (SIZEC,SIZED,SIZEF)=0
        K OCXEFF,OCXEFC,OCXEFD
        S (OCXEFF,OCXEFC,OCXEFD)=""
        ;
        I $G(CSUB),$D(^TMP("OCXCMP",$J,"C CODE",+CSUB)) D
        .I $D(^TMP("OCXCMP",$J,"C CODE",+CSUB,"SIZE")) D  Q
        ..S SIZEC=^TMP("OCXCMP",$J,"C CODE",+CSUB,"SIZE")
        ..I $D(^TMP("OCXCMP",$J,"C CODE",+CSUB,"CALLS")) D
        ...K OCXEFC M OCXEFC=^TMP("OCXCMP",$J,"C CODE",+CSUB,"CALLS")
        .K OCXREC M OCXREC=^TMP("OCXCMP",$J,"C CODE",+CSUB)
        .S D0=0 F  S D0=$O(OCXREC(D0)) Q:'D0  D
        ..S TEXT=OCXREC(D0,0),SIZEC=SIZEC+$L(TEXT)
        ..Q:'(TEXT["$$")
        ..F PIEC=2:1:$L(TEXT,"$$") D
        ...S EFC=$P($P(TEXT,"$$",PIEC),"(",1)
        ...S:(EFC[" ") EFC=$P(EFC," ",1) Q:(EFC["^")  Q:'$L(EFC)
        ...I '$D(^TMP("OCXCMP",$J,"INCLUDE",EFC)) D  Q
        ....D WARN^OCXOCMPV("Unknown Local Extrinsic Function: "_EFC,$P($T(+1)," ",1)) Q
        ...S OCXEFC(EFC)=""
        .S SIZEC=SIZEC+100 ; ADJUST FOR SUBROUTINE DOCUMENTATION
        .S ^TMP("OCXCMP",$J,"C CODE",+CSUB,"SIZE")=SIZEC
        .M ^TMP("OCXCMP",$J,"C CODE",+CSUB,"CALLS")=OCXEFC
        ;
        I $G(DSUB),$D(^TMP("OCXCMP",$J,"D CODE",+DSUB)) D
        .I $G(^TMP("OCXCMP",$J,"D CODE",+DSUB,"SIZE")) D  Q
        ..S SIZED=^TMP("OCXCMP",$J,"D CODE",+DSUB,"SIZE")
        ..I $D(^TMP("OCXCMP",$J,"D CODE",+DSUB,"CALLS")) D
        ...K OCXEFD M OCXEFD=^TMP("OCXCMP",$J,"D CODE",+DSUB,"CALLS")
        ;
        K OCXEFF M OCXEFF=OCXEFC,OCXEFF=OCXEFD
        ;
        I $D(OCXEFF) S EFC="" F  S EFC=$O(OCXEFF(EFC)) Q:'$L(EFC)  I 'OCXEFF(EFC) D
        .K OCXTEMP
        .I $D(^TMP("OCXCMP",$J,"INCLUDE",EFC,"SIZE")) M OCXTEMP("SIZE")=^TMP("OCXCMP",$J,"INCLUDE",EFC,"SIZE")
        .I $D(^TMP("OCXCMP",$J,"INCLUDE",EFC,"CALLS")) M OCXTEMP("CALLS")=^TMP("OCXCMP",$J,"INCLUDE",EFC,"CALLS")
        .S OCXEFF(EFC)=OCXTEMP("SIZE")
        .Q:'$D(OCXTEMP("CALLS"))
        .S EFC="" F  S EFC=$O(OCXTEMP("CALLS",EFC)) Q:'$L(EFC)  S OCXEFF(EFC)=+$G(OCXEFF(EFC))
        ;
        I $D(OCXEFF) S EFC="" F  S EFC=$O(OCXEFF(EFC)) Q:'$L(EFC)  S SIZEF=SIZEF+OCXEFF(EFC)
        ;
        Q $G(SIZEC)+$G(SIZED)+$G(SIZEF)
        ;
RNAM(X) ;
        N CHAR
        S CHAR="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        Q "OCXOZ"_$E(CHAR,(X\36+1))_$E(CHAR,(X#36+1))
        ;
TODAY() N X,Y,%DT S X="T",%DT="" D ^%DT X ^DD("DD") Q Y
        ;
NOW()   N X,Y,%DT S X="N",%DT="T" D ^%DT X ^DD("DD") S:(Y["@") Y=$P(Y,"@",1)_" at "_$P(Y,"@",2,99) Q Y
        ;
