OCXOCMP6        ;SLC/RJS,CLA - ORDER CHECK CODE COMPILER (Assemble Order Check Routines) ;1/05/04  14:33
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32,221,243**;Dec 17,1997;Build 242
        ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
        ;
EN()    ;
        ;
        Q:$G(OCXWARN) 1
        N OCXD0,OCXD1,OCXRN,OCXSCNT,OCXOFF
        ;
        W:'$G(OCXAUTO) !,?5,"Generate Extrinsic Function and Variables documentation..."
        S OCXD0=0 F  S OCXD0=$O(^TMP("OCXCMP",$J,"C CODE",OCXD0)) Q:'OCXD0  D DOC^OCXOCMPT(OCXD0)
        ;
        K ^OCXS(860.3,"APGM")
        S OCXD0=0 F  S OCXD0=$O(^OCXS(860.3,OCXD0)) Q:'OCXD0  D
        .K ^OCXS(860.3,OCXD0,"RTN") I '$G(OCXAUTO) W:($X>60) ! W "."
        ;
        K ^TMP("OCXCMP",$J,"D CODE")
        ;
        W:'$G(OCXAUTO) !,?5,"Assign Subroutines to Routines..."
        S OCXRN=1,OCXD0=0
        D GETHDR(1)
        F  S OCXD0=$O(^TMP("OCXCMP",$J,"C CODE",OCXD0)) Q:'OCXD0  D  Q:OCXWARN
        .N OCXLLAB,OCXSKIP,OCXEXF,OCXSUB,OCXSIZE,OCXFILE,OCXCCODE,OCXDCODE,OCXLAST
        .I '$G(OCXAUTO) W:($X>60) ! W "."
        .S OCXLLAB=^TMP("OCXCMP",$J,"LINE",OCXD0)
        .S OCXSKIP=((OCXLLAB="UPDATE")!(OCXLLAB="LOG"))
        .S OCXSIZE=$$SIZE^OCXOCMP8(OCXRN,OCXD0)
        .S OCXLAST='$O(^TMP("OCXCMP",$J,"C CODE",OCXD0))
        .S OCXFILE=(OCXSIZE>OCXCRS)!(OCXLAST) S:OCXSKIP OCXFILE=0
        .I OCXFILE D
        ..K OCXEXF S OCXEXF=""
        ..I $D(^TMP("OCXCMP",$J,"D CODE",OCXRN,"CALLS")) M OCXEXF=^("CALLS")
        ..S OCXSUB="" F  S OCXSUB=$O(OCXEXF(OCXSUB)) Q:'$L(OCXSUB)  I 'OCXEXF(OCXSUB) D
        ...S OCXEXF(OCXSUB)=1,OCXEXF=OCXSUB
        ...S OCXSUB="" F  S OCXSUB=$O(^TMP("OCXCMP",$J,"INCLUDE",OCXEXF,"CALLS",OCXSUB)) Q:'$L(OCXSUB)  D
        ....S OCXEXF(OCXSUB)=$G(OCXEXF(OCXSUB))
        ..S OCXSUB="" F  S OCXSUB=$O(OCXEXF(OCXSUB)) Q:'$L(OCXSUB)  D
        ...D APPEND^OCXOCMP8(OCXRN,OCXSUB,"F")
        ..D APPEND^OCXOCMP8(OCXRN,"$")
        ..S OCXRN=OCXRN+1 D GETHDR(OCXRN)
        ..;
        .D APPEND^OCXOCMP8(OCXRN,OCXD0,"C",OCXLLAB)
        .I ($E(OCXLLAB,1,2)="EL") D
        ..S ^OCXS(860.3,"APGM",(+$E(OCXLLAB,3,$L(OCXLLAB))),(OCXLLAB_U_$$RNAM(OCXRN)))=""
        .S $P(^TMP("OCXCMP",$J,"LINE",OCXD0),U,2)=$$RNAM(OCXRN)
        .Q:'OCXLAST
        .K OCXEXF S OCXEXF=""
        .I $D(^TMP("OCXCMP",$J,"D CODE",OCXRN,"CALLS")) M OCXEXF=^("CALLS")
        .S OCXSUB="" F  S OCXSUB=$O(OCXEXF(OCXSUB)) Q:'$L(OCXSUB)  I 'OCXEXF(OCXSUB) D
        ..S OCXEXF(OCXSUB)=1,OCXEXF=OCXSUB
        ..S OCXSUB="" F  S OCXSUB=$O(^TMP("OCXCMP",$J,"INCLUDE",OCXEXF,"CALLS",OCXSUB)) Q:'$L(OCXSUB)  D
        ...S OCXEXF(OCXSUB)=$G(OCXEXF(OCXSUB))
        .S OCXSUB="" F  S OCXSUB=$O(OCXEXF(OCXSUB)) Q:'$L(OCXSUB)  D
        ..D APPEND^OCXOCMP8(OCXRN,OCXSUB,"F")
        .D APPEND^OCXOCMP8(OCXRN,"$")
        ;
        W:'$G(OCXAUTO) !,?5,"Resolve Routine Line Tags..."
        S OCXD0=0 F  S OCXD0=$O(^TMP("OCXCMP",$J,"D CODE",OCXD0)) Q:'OCXD0  D  Q:OCXWARN
        .I '$G(OCXAUTO) W:($X>60) ! W "."
        .N TEXT,RTN,TEMP,ALT,LABL,OBJ,PIEC
        .S RTN=$$RNAM(OCXD0)
        .K TEMP M TEMP=^TMP("OCXCMP",$J,"D CODE",OCXD0)
        .S OCXD1=0 F OCXOFF=0:1 S OCXD1=$O(TEMP(OCXD1)) Q:'OCXD1  D  Q:OCXWARN
        ..N TEXT,PIEC
        ..S TEXT=TEMP(OCXD1,0) Q:'(TEXT["||")
        ..;
        ..F PIEC=2:2:$L(TEXT,"||") D  Q:OCXWARN
        ...S LABL=$P(TEXT,"||",PIEC)
        ...I ($E(LABL,1,5)="LINE:") D  I 1
        ....S LABL=$G(^TMP("OCXCMP",$J,"LINE",+$P(LABL,":",2)))
        ....I '$L(LABL) D WARN^OCXOCMPV("Line Label not found: "_$P(TEXT,"|",2),$P($T(+1)," ",1)) Q
        ....S:($P(LABL,"^",2)=RTN) LABL=$P(LABL,"^",1)
        ...;
        ...E  I ($E(LABL,1,5)="LNTAG") D  I 1
        ....N D0,CNT
        ....S D0=OCXD1 F CNT=1:1 S D0=$O(TEMP(D0),-1)  Q:$L($P(TEMP(D0,0)," ",1))
        ....S LABL=$P(TEMP(D0,0)," ",1) S:(LABL["(") LABL=$P(LABL,"(",1)
        ....S LABL="(+$P($H,"","",2))_""<"_LABL_"+"_CNT_U_RTN_">"""
        ...;
        ...E  D WARN^OCXOCMPV("Unknown Compiler directive: "_LABL,$P($T(+1)," ",1)) Q
        ...;
        ...S $P(TEXT,"||",PIEC)=LABL
        ..;
        ..F  Q:'(TEXT["||")  S TEXT=$P(TEXT,"||",1)_$P(TEXT,"||",2,999)
        ..S TEMP(OCXD1,0)=TEXT
        .;
        .K ^TMP("OCXCMP",$J,"D CODE",OCXD0)
        .M ^TMP("OCXCMP",$J,"D CODE",OCXD0)=TEMP
        ;
        Q:OCXWARN 1
        W:'$G(OCXAUTO) !,?5,"Generate Subroutine and Call documentation..."
        S OCXD0=0 F  S OCXD0=$O(^TMP("OCXCMP",$J,"C CODE",OCXD0)) Q:'OCXD0  D CALL^OCXOCMPT(OCXD0)
        ;
        W:'$G(OCXAUTO) !!,?5,"Delete Old OCXOZ* Routines..."
        S OCXRTEST=^%ZOSF("TEST"),OCXSAVE=^%ZOSF("SAVE"),OCXDEL=^%ZOSF("DEL")
        F OCXRN=1:1:1290 D
        .I '$G(OCXAUTO) W:($X>60) ! W:'(OCXRN#100) "."
        .S X=$$RNAM(OCXRN) X OCXRTEST I  X OCXDEL W:'$G(OCXAUTO) "!"
        ;
        W:'$G(OCXAUTO) !,?5,"File New OCXOZ* routines..."
        S OCXD0=$O(^TMP("OCXCMP",$J,"D CODE",0)) Q:'OCXD0 1
        F  S OCXD0=$O(^TMP("OCXCMP",$J,"D CODE",OCXD0)) Q:'OCXD0  D  Q:OCXWARN
        .I '$G(OCXAUTO) W:($X>60) ! W "."
        .D FILE^OCXOCMP8(OCXD0)
        S OCXD0=$O(^TMP("OCXCMP",$J,"D CODE",0)) Q:'OCXD0 1  D FILE^OCXOCMP8(OCXD0)
        ;
        Q OCXWARN
        ;
GETHDR(RNUM)    ;
        ;
        N OCXREC,D0,EFC,OCXEFF,PIEC,TEXT
        S OCXREC(1,0)=$$RNAM(RNUM)_" ;SLC/RJS,CLA - Order Check Scan ;"_$$NOW
        S OCXREC(2,0)=$T(+2)
        S OCXREC(3,0)=$T(+3)
        S OCXREC(4,0)=" ;"
        S OCXREC(5,0)=" ; ***************************************************************"
        S OCXREC(6,0)=" ; ** Warning: This routine is automatically generated by the   **"
        S OCXREC(7,0)=" ; ** Rule Compiler (^OCXOCMP) and ANY changes to this routine  **"
        S OCXREC(8,0)=" ; ** will be lost the next time the rule compiler executes.    **"
        S OCXREC(9,0)=" ; ***************************************************************"
        S OCXREC(10,0)=" ;"
        I (RNUM=1) D
        .S OCXREC(11,0)=" ;    compiled code line length: "_OCXCLL
        .S OCXREC(12,0)=" ;        compiled routine size: "_OCXCRS
        .S OCXREC(13,0)=" ; triggered rule ignore period: "_OCXTSPI
        .S OCXREC(14,0)=" ;"
        .S OCXREC(15,0)=" ;   Program Execution Trace Mode: "_$S($G(OCXTRACE):" ON",1:"OFF")
        .S OCXREC(16,0)=" ;" ; " ;    Elapsed time logging: "_$S($G(OCXTLOG):" ON",1:"OFF")
        .S OCXREC(17,0)=" ;               Raw Data Logging: "_$S($G(OCXDLOG):(" ON  Keep data for "_OCXDLOG_" day"_$S(OCXDLOG=1:"",1:"s")_" then purge."),1:"OFF")
        .S OCXREC(18,0)=" ; Compiler mode: "_$S(($G(OCXAUTO)>1):"Queued",$G(OCXAUTO):" ON",1:"OFF")
        .S OCXREC(19,0)=" ;   Compiled by: "_$P($G(^VA(200,+$G(DUZ),0)),U,1)_"  (DUZ="_(+$G(DUZ))_")"
        .S OCXREC(20,0)=" Q"
        .S OCXREC(21,0)=" ;"
        ;
        E  D
        .S OCXREC(11,0)=" Q"
        .S OCXREC(12,0)=" ;"
        ;
        M ^TMP("OCXCMP",$J,"D CODE",RNUM)=OCXREC
        Q
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
