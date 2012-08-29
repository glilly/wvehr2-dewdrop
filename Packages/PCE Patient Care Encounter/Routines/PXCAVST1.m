PXCAVST1        ;ISL/dee & LEA/Chylton - Translates data from the PCE Device Interface into PCE's PXK format for the Visit and Providers ;6/6/05
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**73,74,111,121,130,168**;Aug 12, 1996;Build 14
        Q
        ;
VST(PXCAENC)    ;Visit
        N PXCAFTER
NODE0   ;
1       S PXCAFTER=$P(PXCAENC,"^",1)_"^^^^"
5       S PXCAFTER=PXCAFTER_PXCAPAT_"^^^"
8       S PXCAFTER=PXCAFTER_PXCACSTP_"^^^^^^^^^"
17      ;Store the Evaluation and Management Code in V-CPT and NOT in the Visit
        D EVALCODE($P(PXCAENC,"^",5),$P(PXCAENC,"^",4))
        S PXCAFTER=PXCAFTER_"^"
18      S PXCAFTER=PXCAFTER_$P(PXCAENC,"^",14)_"^^^"
21      I $P(PXCAENC,"^",13)]"" S PXCAFTER=PXCAFTER_$P(PXCAENC,"^",13)_"^"
        E  D 
        . N PXCAELIG
        . S PXCAELIG=$$ELIGIBIL^PXCEVSIT(PXCAPAT,PXCAHLOC,+PXCAENC)
        . S PXCAELIG=$S(PXCAELIG>0:PXCAELIG,1:"")
        . S PXCAFTER=PXCAFTER_PXCAELIG_"^"
22      S PXCAFTER=PXCAFTER_PXCAHLOC
        S ^TMP(PXCAGLB,$J,"VST",1,0,"AFTER")=PXCAFTER
        ;
NODE150 I $P($G(^SC(+PXCAHLOC,0)),"^",7)=PXCACSTP D
        . S ^TMP(PXCAGLB,$J,"VST",1,150,"AFTER")="^^P"
        ;
NODE800 ;
        S ^TMP(PXCAGLB,$J,"VST",1,800,"AFTER")=$P(PXCAENC,"^",6,10)_"^"_$P(PXCAENC,"^",17,19)
        ;
        I PXCAVSIT'>0 D
        . S ^TMP(PXCAGLB,$J,"VST",1,"IEN")=""
        . S ^TMP(PXCAGLB,$J,"VST",1,0,"BEFORE")=""
        . S ^TMP(PXCAGLB,$J,"VST",1,150,"BEFORE")=""
        . S ^TMP(PXCAGLB,$J,"VST",1,800,"BEFORE")=""
        . S ^TMP(PXCAGLB,$J,"VST",1,812,"BEFORE")=""
        . S ^TMP(PXCAGLB,$J,"VST",1,812,"AFTER")="^"_PXCAPKG_"^"_PXCASOR
        E  D
        . S ^TMP(PXCAGLB,$J,"VST",1,"IEN")=PXCAVSIT
        . S ^TMP(PXCAGLB,$J,"VST",1,0,"BEFORE")=$G(^AUPNVSIT(PXCAVSIT,0))
        . S $P(^TMP("PXK",$J,"VST",1,0,"AFTER"),"^",3)=$P(^AUPNVSIT(PXCAVSIT,0),"^",3)
        . S $P(^TMP("PXK",$J,"VST",1,0,"AFTER"),"^",7)=$P(^AUPNVSIT(PXCAVSIT,0),"^",7)
        . S ^TMP(PXCAGLB,$J,"VST",1,150,"BEFORE")=$G(^AUPNVSIT(PXCAVSIT,150))
        . S ^TMP(PXCAGLB,$J,"VST",1,800,"BEFORE")=$G(^AUPNVSIT(PXCAVSIT,800))
        . S ^TMP(PXCAGLB,$J,"VST",1,21,"BEFORE")=$G(^AUPNVSIT(PXCAVSIT,21))
        . S ^TMP(PXCAGLB,$J,"VST",1,21,"AFTER")=$G(^AUPNVSIT(PXCAVSIT,21))
        . S ^TMP(PXCAGLB,$J,"VST",1,811,"BEFORE")=$G(^AUPNVSIT(PXCAVSIT,811))
        . S ^TMP(PXCAGLB,$J,"VST",1,811,"AFTER")=$G(^AUPNVSIT(PXCAVSIT,811))
        . S ^TMP(PXCAGLB,$J,"VST",1,812,"BEFORE")=$G(^AUPNVSIT(PXCAVSIT,812))
        . S ^TMP(PXCAGLB,$J,"VST",1,812,"AFTER")=$G(^AUPNVSIT(PXCAVSIT,812))
        Q
        ;
EVALCODE(CODE,PROV)     ;Store the Evaluation and Management Code in a CPT node.
        ;Evaluation and Management Code always has a sequence number of 1
        ;  and there is only one of them.
        Q:'CODE
        N PXCAFTER,PXCAITEM,PXCAPNAR,PXCACNAR,PXCACNT,PXCAMOD,PXCASTR
        N DIC,DR,DA,DIQ,PXCADIQ1
        S DIC=357.69
        S DR=".015;.02;.03"
        S DA=+CODE
        S DIQ="PXCADIQ1("
        S DIQ(0)="E"
        D EN^DIQ1
        S PXCAITEM=$S($G(PXCADIQ1(357.69,DA,.03,"E"))]"":PXCADIQ1(357.69,DA,.03,"E"),$G(PXCADIQ1(357.69,DA,.015,"E"))]"":PXCADIQ1(357.69,DA,.015,"E"),1:"UNKNOWN")
        S PXCAPNAR=+$$PROVNARR^PXAPI(PXCAITEM,9000010.18)
        I PXCAPNAR'>0 S PXCAPNAR=""
        S ^TMP(PXCAGLB,$J,"CPT",1,0,"BEFORE")=""
        S PXCAFTER=CODE_"^"_PXCAPAT_"^"_PXCAVSIT_"^"
        S PXCAFTER=PXCAFTER_PXCAPNAR
        S PXCAFTER=PXCAFTER_"^^^^^^^^^^^^1"
        S ^TMP(PXCAGLB,$J,"CPT",1,0,"AFTER")=PXCAFTER
        ; File modifiers in ^TMP global
        S ^TMP(PXCAGLB,$J,"CPT",1,1,1,"BEFORE")=""
        S (PXCACNT,PXCAMOD)=""
        F PXCACNT=1:1 S PXCAMOD=$O(PXCA("ENCOUNTER","MODIFIER",PXCAMOD)) Q:PXCAMOD=""  D
        . S PXCASTR=$$MODP^ICPTMOD(CODE,PXCAMOD,"E",PXCADT)
        . Q:+PXCASTR<1
        . S ^TMP(PXCAGLB,$J,"CPT",1,1,PXCACNT,"AFTER")=+PXCASTR
        S ^TMP(PXCAGLB,$J,"CPT",1,12,"BEFORE")=""
        I PROV S ^TMP(PXCAGLB,$J,"CPT",1,12,"AFTER")="^^^"_PROV
        E  S ^TMP(PXCAGLB,$J,"CPT",1,12,"AFTER")=""
        S ^TMP(PXCAGLB,$J,"CPT",1,802,"BEFORE")=""
        S ^TMP(PXCAGLB,$J,"CPT",1,812,"BEFORE")=""
        S ^TMP(PXCAGLB,$J,"CPT",1,812,"AFTER")="^"_PXCAPKG_"^"_PXCASOR
        S PXCACNAR=""
        I $G(PXCADIQ1(357.69,DA,.02,"E"))]"" D
        . S PXCACNAR=+$$PROVNARR^PXAPI(PXCADIQ1(357.69,DA,.02,"E"),9000010.18)
        . I PXCACNAR'>0 S PXCACNAR=""
        S ^TMP(PXCAGLB,$J,"CPT",1,802,"AFTER")=PXCACNAR
        S ^TMP(PXCAGLB,$J,"CPT",1,"IEN")=""
        Q
        ;
