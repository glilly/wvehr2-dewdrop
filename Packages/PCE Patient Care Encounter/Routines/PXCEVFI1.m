PXCEVFI1        ;ISL/dee,esw - Routine to edit a visit or v-file entry ;8/3/04 10:32am
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**23,73,112,136,143,124,184,185**;Aug 12, 1996;Build 12
        Q
        ;
EDIT    ; -- edit the V-File stored in "AFTER"
        N DIR,DA,X,Y,C,PXCEINP,PXCEIN01,PXCEEND,PXD
        N PXCELINE,PXCETEXT,PXCEDIRB,PXCEMOD
        N PXCEKEY,PXCEIKEY,PXCENKEY,PXMDCNT
        W !
        G:PXCECAT="VST"!(PXCECAT="APPM")!(PXCECAT="CSTP") REST
        ;
EDIT01  ;
        I PXCECAT="CPT"!(PXCECAT="POV")!(PXCECAT="SK")!(PXCECAT="IMM") D SC^PXCEVFI2($P(^AUPNVSIT(PXCEVIEN,0),U,5))
        S PXCETEXT=$P($T(FORMAT+1^@PXCECODE),";;",2)
        K DIR,DA,X,Y,C,PXCEDIRB
        I $P(PXCEAFTR(0),"^",1) D
        . N DIEER,PXCEDILF,PXCEEXT
        . S PXCEEXT=$$EXTERNAL^DILFD(PXCEFILE,.01,"",$P(PXCEAFTR(0),"^",1),"PXCEDILF")
        . S PXCEDIRB=$S('$D(DIERR):PXCEEXT,1:$P(PXCEAFTR(0),"^",1))
        E  S PXCEDIRB=""
        I $P(PXCETEXT,"~",7)]"" D
        . D @$P(PXCETEXT,"~",7)
        E  D
        . I PXCEDIRB'="" S DIR("B")=PXCEDIRB
        . S DIR(0)=PXCEFILE_",.01OA"
        . S DIR("A")=$P(PXCETEXT,"~",4)
        . S:$P(PXCETEXT,"~",8)]"" DIR("?")=$P(PXCETEXT,"~",8)
        . D ^DIR
        I X="@" D  G ENDEDIT
        . N DIRUT
        . I $P(PXCEAFTR(0),"^",1)="" D
        .. W !,"There is no entry to delete."
        .. D WAIT^PXCEHELP
        . E  D DEL^PXCEVFI2(PXCECAT)
        I $D(DIRUT),$P(PXCEAFTR(0),"^",1)="" S PXCELOOP=1
        I $D(DIRUT) S PXCEQUIT=1 Q
        S (PXCEINP,PXD)=Y
        S PXCEIN01=X
        I $P(Y,"^",2)'=PXCEDIRB,$$DUP(PXCEINP) G EDIT01
        ;--File new CPT code and retrieve IEN
        I PXCECAT="CPT" D
        . S PXMDCNT=$$CODM^ICPTCOD(+Y,"^TMP(""PXMODARR"",$J",PXCESOR,+^TMP("PXK",$J,"VST",1,0,"AFTER"))
        . K ^TMP("PXMODARR",$J)
        . I $P(PXCEAFTR(0),"^",1)'=""!(PXMDCNT'>0) Q
        . N PXCEFIEN
        . D NEWCODE^PXCECPT
        . S ^TMP("PXK",$J,PXCECATS,1,"IEN")=PXCEFIEN
        I PXCECAT="PRV",$P(PXCEAFTR(0),"^",1)>0,PXCEDIRB]"" S $P(PXCEAFTR(0),"^",6)=""
        S $P(PXCEAFTR(0),"^",1)=$P(PXCEINP,"^")
        K DIR,DA
        ;following code added per PX*185
        I $D(XQORNOD(0)) I $P(XQORNOD(0),U,4)="HF" D
        .N HFIEN,NODE
        .S HFIEN=$P(PXCEINP,U),NODE=$G(^AUTTHF(HFIEN,0))
        .Q:'$D(NODE)
        .I $P(NODE,U,8)'="Y" W !!,"WARNING:  This Health Factor is currently not set to",!?10,"display on a Health Summary report.",!!
        .K HFIEN,NODE
        .Q
        ;
        ;
REST    S PXCEEND=0
        F PXCELINE=2:1 S PXCETEXT=$P($T(FORMAT+PXCELINE^@PXCECODE),";;",2) Q:PXCETEXT']""  D  Q:PXCEEND
        . I $P(PXCETEXT,"~",9)]"",$P(PXCETEXT,"~",3)'=80201 S PXCEKEY="" D  Q:PXCEKEY'=1
        .. S PXCENKEY=$L($P(PXCETEXT,"~",9))
        .. F PXCEIKEY=1:1:PXCENKEY I PXCEKEYS[$E($P(PXCETEXT,"~",9),PXCEIKEY) S PXCEKEY=1 Q
        . K DIR,DA,X,Y,C
        . I $P(PXCETEXT,"~",7)]"" D
        .. D @$P(PXCETEXT,"~",7)
        . E  D
        .. I $P(PXCEAFTR($P(PXCETEXT,"~",1)),"^",$P(PXCETEXT,"~",2))'="" D
        ... N DIERR,PXCEDILF,PXCEINT,PXCEEXT
        ... S PXCEINT=$P(PXCEAFTR($P(PXCETEXT,"~",1)),"^",$P(PXCETEXT,"~",2))
        ... S PXCEEXT=$$EXTERNAL^DILFD(PXCEFILE,$P(PXCETEXT,"~",3),"",PXCEINT,"PXCEDILF")
        ... S DIR("B")=$S('$D(DIERR):PXCEEXT,1:PXCEINT)
        .. S DIR(0)=PXCEFILE_","_$P(PXCETEXT,"~",3)_"A"
        .. S DIR("A")=$P(PXCETEXT,"~",4)
        .. S:$P(PXCETEXT,"~",8)]"" DIR("?")=$P(PXCETEXT,"~",8)
        .. D ^DIR
        .. K DIR,DA
        .. I X="@" S Y="@"
        .. E  I $D(DTOUT)!$D(DUOUT) S PXCEEND=1 S:PXCECAT="SIT"!(PXCECAT="APPM")!(PXCECAT="HIST")!(PXCECAT="CPT") PXCEQUIT=1 Q
        .. S $P(PXCEAFTR($P(PXCETEXT,"~",1)),"^",$P(PXCETEXT,"~",2))=$P(Y,"^")
        . I ($P(PXCETEXT,"~",3)=1202!($P(PXCETEXT,"~",3)=1204)) D:+Y>0 PROVIDER^PXCEVFI4(+Y)
        ;
ENDEDIT ;
        Q
        ;
DUP(PXCEINP)    ; -- Check for dup entries.
        Q:PXCECAT="SIT"!(PXCECAT="APPM")!(PXCECAT="HIST") 0
        ;
        N PXCEDUP,PXCEINDX,X,Y
        S PXCEDUP=0
        S PXCEINDX=""
        F  S PXCEINDX=$O(@(PXCEAUPN_"(""AD"",PXCEVIEN,PXCEINDX)")) Q:'PXCEINDX!PXCEDUP  S:+@(PXCEAUPN_"(PXCEINDX,0)")=+PXCEINP&(PXCEINDX'=PXCEFIEN) PXCEDUP=1
        I PXCEDUP D
        . I PXCEDUP
        . W !,$P(PXCEINP,"^",2)," is already a "_PXCECATT_" for this Encounter."
        . I PXCECAT="POV" W !!,"Duplicate Diagnosis Not Allowed." Q  ;PX/112
        . I PXCECAT="CPT",$$GET1^DIQ(357.69,$P(PXCEINP,"^",2),.01)>0 D  Q
        . . W !,"No duplicate E&M codes allowed."   ;PX/136
        . I $P($T(FORMAT^@PXCECODE),"~",4) D
        .. N DIR,DA
        .. S DIR(0)="Y"
        .. S DIR("A")="Do you want to add another "_$P(PXCEINP,"^",2)_""
        .. S DIR("B")="NO"
        .. D ^DIR
        .. S PXCEDUP='+Y
        Q PXCEDUP
        ;
