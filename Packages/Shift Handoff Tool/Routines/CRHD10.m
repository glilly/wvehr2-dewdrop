CRHD10  ; CAIRO/CLC - ASSIGN PROVIDERS TO A TEAM LIST ;04-Mar-2008 16:00;CLC
        ;;1.0;CRHD;****;Jan 28, 2008;Build 19
        ;=================================================================
TMDELAPV(CRHDRTN,CRHDTM)        ;
        ;delete all providers from list, delete entry.
        N DA,DIK
        K CRHDRTN
        S CRHDRTN=0
        I +CRHDTM S DIK="^CRHD(183.4,",DA=+CRHDTM D ^DIK S CRHDRTN=1
        Q
TMLIST(CRHDRTN,CRHDTM)  ;Get list of Providers for a team
        N CRHDX,CRHDPRV,CRHDTLST,CRHDCT,CRHDZ0,CRHDSORT,CRHDUT
        N CRHDI,CRHDTM6,CRHDPNAM
        K CRHDRTN
        S CRHDRTN(1)="No list found"
        Q:'CRHDTM
        Q:$P($G(CRHDTM),"^",2)=""
        I '$D(^CRHD(183.4,"B",$P(CRHDTM,"^",2))) Q
        S CRHDTM6=$O(^CRHD(183.4,"B",$P(CRHDTM,"^",2),0))
        I 'CRHDTM6 S CRHDRTN(1)=0 Q
        S CRHDX=0
        F  S CRHDX=$O(^CRHD(183.4,+CRHDTM6,1,CRHDX)) Q:'CRHDX  D
        .S CRHDPRV=+$G(^CRHD(183.4,+CRHDTM6,1,CRHDX,0))
        .S CRHDPNAM=$$GET1^DIQ(200,+CRHDPRV,.01,"E")
        .I CRHDPNAM'="" D
        ..S CRHDZ0=$G(^CRHD(183.4,+CRHDTM6,1,+CRHDX,0))
        ..S CRHDUT=$P(CRHDZ0,"^",2)
        ..I CRHDUT="" S CRHDUT="ZNOTYPE"
        ..S CRHDSORT(CRHDUT,CRHDPNAM)=CRHDPRV_"^"_CRHDPNAM_"^"_$P(CRHDZ0,"^",2)_"^"_$P(CRHDZ0,"^",3)_"^"_$P(CRHDZ0,"^",4)
        S CRHDI=""
        F  S CRHDI=$O(CRHDSORT(CRHDI)) Q:CRHDI=""  D
        .S CRHDPRV=""
        .F  S CRHDPRV=$O(CRHDSORT(CRHDI,CRHDPRV)) Q:CRHDPRV=""  D
        ..S CRHDTLST(CRHDPRV)=CRHDSORT(CRHDI,CRHDPRV)
        I $D(CRHDTLST) D
        .S CRHDCT=0
        .S CRHDX=""
        .F  S CRHDX=$O(CRHDTLST(CRHDX)) Q:CRHDX=""  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDTLST(CRHDX)
        Q
TMPRVINF(CRHDRTN,CRHDTM,CRHDPHY)        ;
        ;return user information
        N CRHDPRV,CRHDZ0,CRHDMGR,CRHDMN,CRHDPNAM
        Q:CRHDTM=""
        S CRHDMN=$O(^CRHD(183.4,"B",$P(CRHDTM,"^",2),0))
        S CRHDPRV=$O(^CRHD(183.4,+CRHDMN,1,"B",+CRHDPHY,0))
        I 'CRHDPRV Q
        S CRHDZ0=$G(^CRHD(183.4,+CRHDMN,1,+CRHDPRV,0))
        S CRHDPNAM=$$GET1^DIQ(200,+CRHDZ0,.01,"E")
        S CRHDRTN=$P(CRHDZ0,"^",1)_"^"_CRHDPNAM_"^"_$P(CRHDZ0,"^",2)_"^^^"_$P(CRHDZ0,"^",3,99)
        Q
TMMOD(CRHDRTN,CRHDTM,CRHDTXT,CRHDKFG)   ;
        N CRHDX,CRHDFDA,CRHDOUT,CRHDERR,CRHDMN,CRHDPG,CRHDPL,CRHDOP
        K CRHDRTN
        S CRHDRTN(0)=0
        I '$D(^CRHD(183.4,"B",$P(CRHDTM,"^",2),+CRHDTM)) D
        .S CRHDFDA(183.4,"?+1,",.01)=$P(CRHDTM,"^",2)
        .D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
A       .I '$D(CRHDERR) S CRHDMN=CRHDOUT(1) K CRHDFDA,CRHDOUT
        Q:'CRHDMN
        K:CRHDKFG ^CRHD(183.4,CRHDMN,1)
        S CRHDX=0
        F  S CRHDX=$O(CRHDTXT(CRHDX)) Q:'CRHDX  D
        .S CRHDPL=$L(CRHDTXT(CRHDX),"^"),CRHDPG=$P(CRHDTXT(CRHDX),"^",CRHDPL)
        .S CRHDOP=$P(CRHDTXT(CRHDX),"^",CRHDPL-1)
        .S CRHDFDA(183.41,"?+"_(CRHDX+1)_","_+CRHDMN_","_"",.01)=$P(CRHDTXT(CRHDX),"^",1)
        .S CRHDFDA(183.41,"?+"_(CRHDX+1)_","_+CRHDMN_","_"",1)=$P(CRHDTXT(CRHDX),"^",3)
        .S CRHDFDA(183.41,"?+"_(CRHDX+1)_","_+CRHDMN_","_"",2)=CRHDOP
        .S CRHDFDA(183.41,"?+"_(CRHDX+1)_","_+CRHDMN_","_"",3)=CRHDPG
        D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
        I '$D(CRHDERR) S CRHDRTN(0)=1
        E  S CRHDRTN(1)=1
        K CRHDFDA,CRHDOUT,CRHDERR
        Q
TMCOMB(CRHDRTN) ;return list of teams for a user with a combination list
        N CRHDS,CRHDF,CRHDFN,CRHDSRC,CRHDCT
        Q:'$G(DUZ)
        S CRHDCT=0
        S CRHDSRC=0
        F  S CRHDSRC=$O(^OR(100.24,DUZ,.01,CRHDSRC)) Q:'CRHDSRC  D
        .S CRHDS=$G(^OR(100.24,DUZ,.01,CRHDSRC,0))
        .I CRHDS D
        ..S CRHDFN=+$P($P(CRHDS,";",2),"(",2)
        ..S CRHDF=+CRHDS
        ..S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDS_"^"_$$GET1^DIQ(CRHDFN,CRHDF,.01,"E")
        Q
