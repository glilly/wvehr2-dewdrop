CRHDI01 ; CAIRO/CLC - POST INIT - routine to move data from old namespace 'AJR' to new namespace 'CRHD' ;04-Mar-2008 16:00;CLC
        ;;1.0;;;30-Jan-2008 13:44;Build 19
        ;=================================================================
        ;This will affect files
        ;^AJRCHGOV(                                  |  ^CRHD(
        ;5830006404 = AJRCHGOV TEMP FIELDS           | 183.2 = CRHD TEMPORARY DATA
        ;5830006405 = AJRCHGOV PARAMETERS            | 183   = CRHD HANDOFF PARAMETERS
        ;5830006406 = AJRCHGOV TEAM PROVIDERS        | 183.4 = CRHD TEAM CONTACT LIST
        ;5830006408 = AJRCHGOV HAND-OFF PATIENT LIST | 183.3 = CRHD HOT TEAM PATIENT LIST
ENT     ;
        N CRHDI
        F CRHDI="^AJRCHGOV(5830006404)-^CRHD(183.2)","^AJRCHGOV(5830006405)-^CRHD(183)","^AJRCHGOV(5830006406)-^CRHD(183.4)","^AJRCHGOV(5830006408)-^CRHD(183.3)" D ENT2($P(CRHDI,"-",1),$P(CRHDI,"-",2))
        Q
ENT2(CRHDS,CRHDD)       ;
        ;CRHDSRC : Source file number
        ;CRHDEST : Destination file number
        N CRHDSRC,CRHDEST,CRHD0,CRHDNXN,CRHDX
        N CRHDFLN,CRHDFLL,CRHDL,CRHDS0
        S CRHDSRC=+$P(CRHDS,"(",2)
        S CRHDEST=+$P(CRHDD,"(",2)
        I $D(@CRHDS)  D
        .;if destination file - no data exist
        .I $D(@CRHDD) D
        ..D DD(.CRHDL,CRHDEST)
        ..I +$P(@CRHDD@(0),"^",4)=0 D
        ...S CRHD0=@CRHDD@(0)
        ...M @CRHDD=@CRHDS
        ...S $P(@CRHDD@(0),"^",1)=$P(CRHD0,"^",1)
        ...S $P(@CRHDD@(0),"^",2)=$P(CRHD0,"^",2)
        ...S CRHDS0=0
        ...F  S CRHDS0=$O(@CRHDD@(CRHDS0)) Q:'CRHDS0  D
        ....S CRHDFLL=0
        ....F  S CRHDFLL=$O(@CRHDD@(CRHDS0,CRHDFLL)) Q:'CRHDFLL  D
        .....I $D(CRHDL(CRHDFLL)) S CRHDFLN=CRHDL(CRHDFLL),$P(@CRHDD@(CRHDS0,CRHDFLL,0),"^",2)=CRHDFLN
        Q
DD(CRHDRTN,CRHDDF)      ;
        N CRHDFLN,CRHDFLL
        K CRHDRTN
        S CRHDFLN=0
        F  S CRHDFLN=$O(^DD(CRHDDF,"SB",CRHDFLN)) Q:'CRHDFLN  D
        .S CRHDFLL=0
        .F  S CRHDFLL=$O(^DD(CRHDEST,"SB",CRHDFLN,CRHDFLL)) Q:'CRHDFLL  D
        ..S CRHDRTN(CRHDFLL)=CRHDFLN
        Q
