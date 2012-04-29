CRHD11  ; CAIRO/CLC - GET USERS PARAMETERS ;23-Mar-2008 13:13;CLC
        ;;1.0;CRHD;****;Jan 28, 2008;Build 19
        ;=================================================================
GETALLPL(CRHDRTN,DUZ,CRHDDIV)   ;
        ;get a list of Parameters levels
        N CRHDPAR,CRHDTEAM,CRHDSRV,Y,CRHDX,CRHDIVIE,CRHDCT,CRHDMGR
        N CRHDI
        D MGR^CRHD7(.CRHDMGR,+DUZ)
        I +CRHDMGR D GETMGRPL(.CRHDRTN,DUZ) Q
        S Y=-1
        S CRHDCT=1
        D TEAMS^ORWTPT(.CRHDTEAM,DUZ)
        S CRHDSRV=$$GET1^DIQ(200,DUZ_",",29,"E")
        S CRHDPAR="USR.`"_DUZ
        D LOOKUP^XPAREDIT(CRHDPAR,183)
        ;I (Y>0)&($$CKATNRES(+Y)) S CRHDRTN(CRHDCT)=Y_"^"_$$GETFENT($P(Y,"^",2),0,1)
        I Y>0 S CRHDRTN(CRHDCT)=Y_"^"_$$GETFENT($P(Y,"^",2),0,1)
        I $D(CRHDTEAM) D
        .S CRHDI=0
        .F  S CRHDI=$O(CRHDTEAM(CRHDI)) Q:'CRHDI  D
        ..S Y=0,CRHDPAR="OTL.`"_+CRHDTEAM(CRHDI) D LOOKUP^XPAREDIT(CRHDPAR,183)
        ..I Y>0 S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=Y_"^"_$$GETFENT($P(Y,"^",2),0,1)
        I $G(CRHDSRV)'="" S Y=0,CRHDPAR="SRV."_CRHDSRV D LOOKUP^XPAREDIT(CRHDPAR,183)
        I Y>0 S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=Y_"^"_$$GETFENT($P(Y,"^",2),0,1)
        I '+$G(CRHDDIV) S CRHDDIV=+$$SITE^VASITE
        S Y=0,CRHDPAR="DIV.`"_+CRHDDIV D LOOKUP^XPAREDIT(CRHDPAR,183)
        I Y>0 S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=Y_"^"_$$GETFENT($P(Y,"^",2),0,1)
        I (Y<0) D
        .S CRHDIVIE=$O(^DIC(4,"D",CRHDDIV,0))
        .I CRHDIVIE S Y=0,CRHDPAR="DIV.`"_CRHDIVIE D LOOKUP^XPAREDIT(CRHDPAR,183)
        .I Y>0 S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=Y_"^"_$$GETFENT($P(Y,"^",2),0,1)
        Q
GETIT(CRHDRTN,CRHDMN)   ;get all of the users PARameters 2
        N CRHDX2,CRHDCT,CRHDP,CRHDMGR
        K CRHDRTN
        S (CRHDP,CRHDCT)=0
        ;Q:'$$CKATNRES(+CRHDMN)
        F  S CRHDP=$O(^CRHD(183,+CRHDMN,1,CRHDP)) Q:'CRHDP  D
        .S CRHDCT=CRHDCT+1
        .I $P($G(^CRHD(183,+CRHDMN,1,CRHDP,0)),"^",2)="" D
        ..S CRHDX2=0 F  S CRHDX2=$O(^CRHD(183,+CRHDMN,1,CRHDP,1,CRHDX2)) Q:'CRHDX2  D
        ...S CRHDRTN(CRHDCT)=$P($G(^CRHD(183,+CRHDMN,1,CRHDP,0)),"^",1)_"^"_$G(^CRHD(183,+CRHDMN,1,CRHDP,1,CRHDX2,0))
        ...S CRHDCT=CRHDCT+1
        .E  S CRHDRTN(CRHDCT)=$G(^CRHD(183,+CRHDMN,1,CRHDP,0))
        Q
CKATNRES(CRHDN) ;Check for Resident and Student fields only exist
        ;0 - Resident and/or Student Parameters or no Parameters exist
        ;1 - if full setup
        ;I '$D(^CRHD(183,CRHDN)) Q 0
        ;I $D(^CRHD(183,CRHDN,1,0))&($P(^CRHD(183,CRHDN,1,0),"^",4)>2) Q 1
        ;E  Q 0
        ;
GETMGRPL(CRHDRTN,CRHDUSR)       ;Get a list of preferences for Manager, excludes user levels- this could be to long
        N CRHDPNAM,CRHDMN,CRHDCT,CRHDMGR
        S CRHDCT=0
        D MGR^CRHD7(.CRHDMGR,+CRHDUSR)
        Q:'CRHDMGR
        S CRHDPNAM=""
        F  S CRHDPNAM=$O(^CRHD(183,"B",CRHDPNAM)) Q:CRHDPNAM=""  D
        .S CRHDMN=0
        .F  S CRHDMN=$O(^CRHD(183,"B",CRHDPNAM,CRHDMN)) Q:'CRHDMN  D
        ..;Q:'$$CKATNRES(+CRHDMN)
        ..;S CRHDPFMT="^"_$P(CRHDPNAM,";",2)_+CRHDPNAM_",0)"
        ..I CRHDPNAM[";" S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDMN_"^"_CRHDPNAM_"^"_$$GETFENT(CRHDPNAM,0,1)
        Q
GETFENT(CRHDE,CRHDN,CRHDP)      ;Convert to file entry
        ;CRHDE = entity
        ;CRHDN = node
        ;CRHDP = piece
        N CRHDPFMT
        S CRHDPFMT="^"_$P(CRHDE,";",2)_+CRHDE_","_CRHDN_")"
        Q $P($G(@CRHDPFMT),"^",CRHDP)
DEFPREF(CRHDRTN,CRHDUSR)        ;Default preference for a user
        N CRHDE,CRHDOLST,CRHDX,Y,CRHDP
        K CRHDRTN
        S CRHDE="USR.`"_+CRHDUSR
        ;D GETLST^XPAR(.CRHDOLST,CRHDE,"CRHD DEFAULT PREFERENCE","E")
        S CRHDOLST=$$GET^XPAR(CRHDE,"CRHD DEFAULT PREFERENCE",1,"E")
        I CRHDOLST D
        .I '$$GET1^DIQ(183,+CRHDOLST_",",.01,"I") D NDEL^XPAR("USR.`"_+CRHDUSR,"CRHD DEFAULT PREFERENCE") Q
        .I CRHDOLST'?.E1"|".E S CRHDRTN(1)=+CRHDOLST_"^"_$$GET1^DIQ(183,+CRHDOLST_",",.01,"I")_"^"_$$GET1^DIQ(183,+CRHDOLST_",",.01,"E")_"^DEF" Q
        .S CRHDRTN(1)=$P(CRHDOLST,"^",2)
        .S CRHDRTN(1)=$TR(CRHDRTN(1),"|","^")_"^D"
        Q
