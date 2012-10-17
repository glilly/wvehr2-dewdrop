CRHD9   ; CAIRO/CLC - HANDOFF TEAM LIST ;4/24/08  12:49
        ;;1.0;CRHD;**2**;Jan 28, 2008;Build 11
        ;=================================================================
        ;04/22/2009 BAY/KAM CRHD*1*2 Remedy Call 264027 Correct Issue of not
        ;                            being able to display/print patients
        ;                            with identical names
HOTMSAVE(CRHDRTN,CRHDTM)        ;
        ;create a team name
        N CRHDFDA,CRHDOUT,CRHDERR
        K CRHDRTN
        S CRHDRTN=0
        I (CRHDTM'?1A.E)&(CRHDTM'?1N.E) Q
        S CRHDFDA(183.3,"?+1,",.01)=CRHDTM
        D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
        I '$D(CRHDERR) S CRHDRTN=CRHDOUT(1)
        Q
HOTMDEL(CRHDRTN,CRHDTM) ;
        ;delete a Hand off team
        N DIK,DA
        K CRHDRTN
        S CRHDRTN=0
        I +CRHDTM S DIK="^CRHD(183.3,",DA=+CRHDTM D ^DIK S CRHDRTN=1
        Q
HOLIST(CRHDRTN) ;
        ;return a list of teams
        N CRHDX,CRHDX1,CRHDTDT,CRHDCT
        K CRHDRTN
        S CRHDX=""
        S CRHDCT=0
        S CRHDRTN(0)="0^No List Found"
        F  S CRHDX=$O(^CRHD(183.3,"B",CRHDX)) Q:CRHDX=""  D
        .S CRHDX1=0
        .F  S CRHDX1=$O(^CRHD(183.3,"B",CRHDX,CRHDX1)) Q:'CRHDX1  D
        ..;check to see if team list is active, if date is less then today then inactive
        ..S CRHDTDT=$P($G(^CRHD(183.3,CRHDX1,0)),"^",2)
        ..I CRHDTDT&(CRHDTDT<$$DT^XLFDT) Q
        ..S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDX1_"^"_CRHDX_"^"_"HOTEAM"
        I CRHDCT>0 K CRHDRTN(0)
        Q
HOPLIST(CRHDRTN,CRHDTM) ;
        ;Get list of Patients for a HO team
        N CRHDX,CRHDPT,CRHDPD,CRHDTLST,CRHDCT,CRHDPD2,VAIP,DFN,DIE,DA,DR
        K CRHDRTN
        S CRHDRTN(1)="No Patients Found"
        Q:'CRHDTM
        I '$D(^CRHD(183.3,"B",$P(CRHDTM,"^",2),+CRHDTM)) Q
        S CRHDX=0
        F  S CRHDX=$O(^CRHD(183.3,+CRHDTM,1,CRHDX)) Q:'CRHDX  D
        .S CRHDPT=+$G(^CRHD(183.3,+CRHDTM,1,CRHDX,0))
        .;check to see if patient has been discharged, if so delete from list
        .S DFN=CRHDPT D IN5^VADPT
        .I VAIP(1)="" D  Q
        ..S DA(1)=+CRHDTM,DIE="^CRHD(183.3,"_DA(1)_",1,",DA=CRHDX,DR=".01///@" D ^DIE
        .S CRHDPD=$$PATDATA(CRHDPT)
        .K CRHDPD2
        .D PATPRV(.CRHDPD2,CRHDTM,CRHDPT)
        . ;04/22/2009 BAY/KAM CRHD*1*2 Remedy Call 264027 Concatenated the
        . ;                            patient IEN to the subscript for
        . ;                            uniqueness in the next two lines
        . I $P(CRHDPD,"^",1)'="" S CRHDTLST($P(CRHDPD,"^",2)_$P(CRHDPD,"^",1))=CRHDPD
        . ;I $P(CRHDPD,"^",1)'="" S CRHDTLST($P(CRHDPD,"^",2))=CRHDPD ; ORIGINAL CODE
        . I $G(CRHDPD2)'="" S CRHDTLST($P(CRHDPD,"^",2)_$P(CRHDPD,"^",1))=CRHDTLST($P(CRHDPD,"^",2)_$P(CRHDPD,"^",1))_"^*"_CRHDPD2
        . ;I $G(CRHDPD2)'="" S CRHDTLST($P(CRHDPD,"^",2))=CRHDTLST($P(CRHDPD,"^",2))_"^*"_CRHDPD2 ; ORIGINAL CODE
        I $D(CRHDTLST) D
        .S CRHDCT=0
        .S CRHDX=""
        .F  S CRHDX=$O(CRHDTLST(CRHDX)) Q:CRHDX=""  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDTLST(CRHDX)
        Q
PATDATA(DFN)    ;
        ;
        N CRHDNAME,CRHDSSN,CRHDDOB,CRHDAGE,CRHDSEX,VAIP,VADM
        K VAIP,VADM
        D DEM^VADPT,IN5^VADPT
        S CRHDNAME=VADM(1),CRHDSSN=$P(VADM(2),U,1),CRHDDOB=$P(VADM(3),U,1)
        S CRHDAGE=VADM(4),CRHDSEX=$P(VADM(5),U,1)
        K VAIP,VADM
        Q DFN_U_CRHDNAME_U_CRHDSSN_U_CRHDDOB_U_CRHDAGE_U_CRHDSEX
        ;
HODLIST(CRHDRTN,CRHDTM) ;Get list of Providers for a HO team
        N CRHDX,CRHDPRV,CRHDTLST,CRHDCT,CRHDZ0,CRHDSORT,CRHDUT
        N CRHDPX,CRHDPX0,CRHDNAM
        K CRHDRTN
        I '$D(^CRHD(183.3,"B",$P(CRHDTM,"^",2),+CRHDTM)) Q
        S CRHDX=0
        F  S CRHDX=$O(^CRHD(183.3,+CRHDTM,2,CRHDX)) Q:'CRHDX  D
        .S CRHDPRV=+$G(^CRHD(183.3,+CRHDTM,2,CRHDX,0))
        .S CRHDNAM=$$GET1^DIQ(200,+CRHDPRV,.01,"E")
        .;Delete Provider if inactive, 1st check to see if assigned to a patient, if so remove
        .I '$$ACTIVE^XUSER(+CRHDPRV) D  Q
        ..S CRHDPX=0 F  S CRHDPX=$O(^CRHD(183.3,+CRHDTM,1,CRHDPX)) Q:'CRHDPX  D
        ...S CRHDPX0=^CRHD(183.3,+CRHDTM,1,CRHDPX,0)
        ...I CRHDPX0[+CRHDPRV F CRHDI=2:1:$L(CRHDPX0,"^") I $P(CRHDPX0,"^",CRHDI)=+CRHDPRV S $P(^CRHD(183.3,+CRHDTM,1,CRHDPX,0),"^",CRHDI)=""
        ..S DA(1)=+CRHDTM,DIE="^CRHD(183.3,"_DA(1)_",2,",DA=CRHDX,DR=".01///@" D ^DIE
        .I CRHDNAM'="" D
        ..S CRHDZ0=$G(^CRHD(183.3,+CRHDTM,2,+CRHDX,0))
        ..S CRHDUT=$P(CRHDZ0,"^",2)
        ..I CRHDUT="" S CRHDUT="ZNOTYPE"
        ..S CRHDSORT(CRHDUT,CRHDNAM)=CRHDPRV_"^"_CRHDNAM_"^"_$P(CRHDZ0,"^",2)_"^"_+$P(CRHDZ0,"^",3)_"^"_+$P(CRHDZ0,"^",4)_"^"_$P(CRHDZ0,"^",5)_"^"_$P(CRHDZ0,"^",6)
        S CRHDI=""
        F  S CRHDI=$O(CRHDSORT(CRHDI)) Q:CRHDI=""  D
        .S CRHDPRV=""
        .F  S CRHDPRV=$O(CRHDSORT(CRHDI,CRHDPRV)) Q:CRHDPRV=""  D
        ..S CRHDTLST(CRHDPRV)=CRHDSORT(CRHDI,CRHDPRV)
        ..;S CRHDTLST(CRHDNAM)=CRHDPRV_"^"_CRHDNAM_"^"_$P(CRHDZ0,"^",2)_"^"_+$P(CRHDZ0,"^",3)_"^"_+$P(CRHDZ0,"^",4)_"^"_$P(CRHDZ0,"^",5)_"^"_$P(CRHDZ0,"^",6)
        I $D(CRHDTLST) D
        .S CRHDCT=0
        .S CRHDX=""
        .F  S CRHDX=$O(CRHDTLST(CRHDX)) Q:CRHDX=""  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDTLST(CRHDX)
        Q
CANEDIT(CRHDRTN,CRHDTM,DUZ)     ;
        ;Can user edit team list
        N CRHDPRV,CRHDMGR,CRHDA
        Q:CRHDTM=""
        ;S CRHDRTN="1^1"
        S CRHDA=$$GET1^DIQ(200,+DUZ,3,"I")
        S CRHDRTN="0^0"
        I CRHDA["@" S CRHDRTN="1^1" Q
        D HOTMMGR^CRHD1(.CRHDMGR,DUZ)
        I CRHDMGR S CRHDRTN="1^1" Q
        S CRHDPRV=$O(^CRHD(183.3,+CRHDTM,2,"B",+DUZ,0))
        I 'CRHDPRV Q
        E  S CRHDRTN=+$P($G(^CRHD(183.3,+CRHDTM,2,+CRHDPRV,0)),"^",3)_"^"_+$P($G(^CRHD(183.3,+CRHDTM,2,+CRHDPRV,0)),"^",4)
        Q
PATPRV(CRHDRTN,CRHDTM,CRHDDFN)  ;
        ;return Providers assigned to patient on list
        N CRHDPAT,CRHDNAM,CRHDZ0,CRHDP,CRHDATTN,CRHDRES,CRHDINT,CRHDFEL,CRHDMST,CRHDNUR,CRHDVP,CRHDI,CRHDI2
        S CRHDVP="^CRHDATTN^CRHDRES^CRHDINT^CRHDFEL^CRHDMST^CRHDNUR"
        S CRHDPAT=$O(^CRHD(183.3,+CRHDTM,1,"B",+CRHDDFN,0))
        I 'CRHDPAT Q
        S CRHDZ0=$G(^CRHD(183.3,+CRHDTM,1,+CRHDPAT,0))
        ;I need to add, if the physician is not on team list delete from patient.
        F CRHDI=2:1:7 S CRHDP=$P(CRHDZ0,"^",CRHDI) D
        .I '$D(@$P(CRHDVP,"^",CRHDI)) S @$P(CRHDVP,"^",CRHDI)=""
        .I CRHDP["," D
        ..F CRHDI2=1:1:$L(CRHDP,",") D
        ...I '$D(^CRHD(183.3,CRHDTM,2,"B",$P(CRHDP,",",CRHDI2))) Q
        ...S CRHDNAM=$$GET1^DIQ(200,+$P(CRHDP,",",CRHDI2),.01,"E")
        ...S @$P(CRHDVP,"^",CRHDI)=@$P(CRHDVP,"^",CRHDI)_+$P(CRHDP,",",CRHDI2)_"^"_CRHDNAM_"+"
        .;E  S:+CRHDP&($D(^CRHD(183.3,+CRHDTM,2,"B",+CRHDP))) @$P(CRHDVP,"^",CRHDI)=+CRHDP_"^"_$$GET1^DIQ(200,+CRHDP,.01,"E")
        .E  S:+CRHDP @$P(CRHDVP,"^",CRHDI)=+CRHDP_"^"_$$GET1^DIQ(200,+CRHDP,.01,"E")
        F CRHDI=2:1:7 I $E(@$P(CRHDVP,"^",CRHDI),$L(@$P(CRHDVP,"^",CRHDI)))="+" S @$P(CRHDVP,"^",CRHDI)=$E(@$P(CRHDVP,"^",CRHDI),1,$L(@$P(CRHDVP,"^",CRHDI))-1)
        S CRHDRTN=CRHDDFN_";"_$G(CRHDATTN)_";"_$G(CRHDRES)_";"_$G(CRHDINT)_";"_$G(CRHDFEL)_";"_$G(CRHDMST)_";"_$G(CRHDNUR)
        Q
USERPHPG(CRHDRTN,DUZ)   ;
        N CRHDOP,CRHDPG
        S CRHDOP=$$GET1^DIQ(200,+DUZ_",",.132,"E")             ;OFFICE PHONE
        S CRHDPG=$$GET1^DIQ(200,+DUZ_",",.138,"E")             ;PAGER
        S CRHDRTN=$S($L(CRHDOP)>2:CRHDOP,1:"")_"^"_$S($L(CRHDPG)>2:CRHDPG,1:"")
        Q
PRVINFO(CRHDRTN,CRHDTM,DUZ)     ;
        ;return user information
        N CRHDPRV,CRHDZ0,CRHDMGR
        Q:CRHDTM=""
        ;S CRHDRTN(1)="0^0"
        S CRHDPRV=$O(^CRHD(183.3,+CRHDTM,2,"B",+DUZ,0))
        I 'CRHDPRV Q
        S CRHDZ0=$G(^CRHD(183.3,+CRHDTM,2,+CRHDPRV,0))
        D MGR^CRHD7(.CRHDMGR,DUZ)
        I ($$GET1^DIQ(200,+DUZ,3,"E")["@")!(+CRHDMGR) S $P(CRHDZ0,"^",3)=1,$P(CRHDZ0,"^",4)=1
        S CRHDRTN=$P(CRHDZ0,"^",1)_"^"_$$GET1^DIQ(200,+CRHDZ0,.01,"E")_"^"_$P(CRHDZ0,"^",2,$L(CRHDZ0,"^"))
        Q
MOD(CRHDRTN,CRHDTM,CRHDLTYP,CRHDTXT,CRHDKFG)    ;
        N CRHDX,CRHDFDA,CRHDOUT,CRHDERR
        K CRHDRTN
        S CRHDRTN(0)=0
        I '$D(^CRHD(183.3,"B",$P(CRHDTM,"^",2),+CRHDTM)) Q
        I CRHDLTYP="P" D
        .K:CRHDKFG ^CRHD(183.3,+CRHDTM,1)
        .S CRHDX=0
        .F  S CRHDX=$O(CRHDTXT(CRHDX)) Q:'CRHDX  D
        ..I CRHDTXT(CRHDX)["~" S CRHDTXT(CRHDX)=$P(CRHDTXT(CRHDX),"~",2)
        ..S CRHDFDA(183.31,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",.01)=+$P(CRHDTXT(CRHDX),"^",1)
        ..S CRHDFDA(183.31,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",1)=+$P(CRHDTXT(CRHDX),";",2)
        ..S CRHDFDA(183.31,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",2)=+$P(CRHDTXT(CRHDX),";",3)
        ..S CRHDFDA(183.31,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",3)=+$P(CRHDTXT(CRHDX),";",4)
        ..S CRHDFDA(183.31,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",4)=+$P(CRHDTXT(CRHDX),";",5)
        ..S CRHDFDA(183.31,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",5)=+$P(CRHDTXT(CRHDX),";",6)
        ..S CRHDFDA(183.31,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",6)=+$P(CRHDTXT(CRHDX),";",7)
        .D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
        .I '$D(CRHDERR) S CRHDRTN(0)=1
        .E  S CRHDRTN(1)=1
        I CRHDLTYP="D" D
        .K:CRHDKFG ^CRHD(183.3,+CRHDTM,2)
        .S CRHDX=0
        .F  S CRHDX=$O(CRHDTXT(CRHDX)) Q:'CRHDX  D
        ..I CRHDTXT(CRHDX)["~" S CRHDTXT(CRHDX)=$P(CRHDTXT(CRHDX),"~",2)
        ..S CRHDFDA(183.32,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",.01)=$P(CRHDTXT(CRHDX),"^",1)
        ..S CRHDFDA(183.32,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",1)=$P(CRHDTXT(CRHDX),"^",3)
        ..S CRHDFDA(183.32,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",2)=$P(CRHDTXT(CRHDX),"^",4)
        ..S CRHDFDA(183.32,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",3)=$P(CRHDTXT(CRHDX),"^",5)
        ..S CRHDFDA(183.32,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",4)=$P(CRHDTXT(CRHDX),"^",6)
        ..S CRHDFDA(183.32,"?+"_(CRHDX+1)_","_+CRHDTM_","_"",5)=$P(CRHDTXT(CRHDX),"^",7)
        .D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
        .I '$D(CRHDERR) S CRHDRTN(0)=1
        .E  S CRHDRTN(1)=1
        K CRHDFDA,CRHDOUT,CRHDERR
        Q
FILENSAV(CRHDRTN,CRHDTM,CRHDFNM)        ;
        ;save filename for a team
        N CRHDFDA,CRHDOUT,CRHDERR,CRHDA
        K CRHDRTN
        S CRHDRTN=0
        ;I CRHDTM'?1A.E Q
        S CRHDFDA(183.4,"?+1,",.01)=$P(CRHDTM,"^",2)
        D UPDATE^DIE("","CRHDFDA","CRHDOUT","CRHDERR")
        I '$D(CRHDERR) D
        .S CRHDA=CRHDOUT(1)
        .K CRHDFDA,CRHDOUT
        .I CRHDA D
        ..S CRHDFDA(183.4,CRHDA_",",2)=CRHDFNM
        ..D FILE^DIE("","CRHDFDA")
        ..S CRHDRTN=1
        Q
FILENGET(CRHDRTN,CRHDTM)        ;
        ;get filename for a team
        S CRHDRTN=$$GET1^DIQ(183.4,+$$FIND1^DIC(183.4,"","X",$P(CRHDTM,"^",2),"","","ERR")_",",2,"I")
        Q
