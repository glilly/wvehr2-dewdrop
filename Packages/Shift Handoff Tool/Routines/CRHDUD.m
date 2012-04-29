CRHDUD  ;CAIRO/CLC - New Person general information ;04-Mar-2008 16:00;CLC;EMPLOYEE DIRECTORY
        ;;1.0;CRHD;****;Jan 28, 2008;Build 19
DISPEMP(CRHDRTN,CRHDEMP)        ;
        K CRHDRTN
        N CRHDUIF
        D DISP(.CRHDUIF,+CRHDEMP)
        I $D(CRHDUIF) S CRHDRTN(1)=CRHDUIF
        Q
DISP(CRHDRTN,CRHDEMP)   ;
        ;COLUMNS
        ;DUZ^NAME^SITE^TITLE^OFFICE PH^PAGER^RM^EMAIL^SRV^MAIL CODE
        N CRHDEXT,CRHDSF,CRHDPG,CRHDRM,CRHDNAM,CRHDTIT,CRHDSRV,CRHDSMC,CRHDSRM,CRHDFAX,CRHDEM
        N CRHDSRVN,CRHDMC
        ;
        K CRHDRTN
        I $$GET1^DIQ(200,+CRHDEMP,.01,"I")="" Q
        S CRHDNAM=$$GET1^DIQ(200,+CRHDEMP_",",.01,"E")
        I $L(CRHDNAM)<2 Q
        I '$$ACTIVE^XUSER(+CRHDEMP) S CRHDNAM=CRHDNAM_" (NOT AN ACTIVE USER)"
        S CRHDTIT=$$GET1^DIQ(200,+CRHDEMP_",",8,"E")
        S CRHDMC=$$GET1^DIQ(200,+CRHDEMP_",",28,"E")               ;MAIL CODE
        S CRHDEXT=$$GET1^DIQ(200,+CRHDEMP_",",.132,"E")            ;OFFICE PHONE
        S CRHDPG=$$GET1^DIQ(200,+CRHDEMP_",",.138,"E")             ;PAGER
        S CRHDEM=$$GET1^DIQ(200,+CRHDEMP_",",.151,"E")             ;EMAIL ADDRESS
        S CRHDRM=$$GET1^DIQ(200,+CRHDEMP_",",.141,"E")             ;ROOM
        S CRHDFAX=$$GET1^DIQ(200,+CRHDEMP_",",.136,"E")            ;FAX
        S CRHDSRV=$$GET1^DIQ(200,+CRHDEMP_",",29,"E")              ;SERVICE
        S CRHDSRVN=$$GET1^DIQ(200,+CRHDEMP_",",29,"I")             ;SERVICE IEN
        ;SERVICE INFORMATION
        S CRHDSMC=$$GET1^DIQ(49,+CRHDSRVN_",",1.5,"E")             ;SERVICE MAIL CODE
        S CRHDSRM=$$GET1^DIQ(200,+CRHDSRVN_",",6,"E")              ;SERVICE LOCATION
        ;DISPLAY INFORMATION
        S CRHDRTN=+CRHDEMP_"^"_CRHDNAM
        S $P(CRHDRTN,"^",3)=$$TITLE^XLFSTR(CRHDTIT)
        S $P(CRHDRTN,"^",4)=CRHDEXT
        S $P(CRHDRTN,"^",5)=CRHDPG
        S $P(CRHDRTN,"^",6)=CRHDRM
        S $P(CRHDRTN,"^",7)=CRHDEM
        S $P(CRHDRTN,"^",8)=CRHDFAX
        S $P(CRHDRTN,"^",9)=CRHDSRV
        S $P(CRHDRTN,"^",10)=CRHDSMC
        ;S $P(CRHDRTN,"^",11)=CRHDSRM
        S $P(CRHDRTN,"^",11)=$TR($P($$SITE^VASITE,"^",2,3),"^","-")
        Q
SRV(CRHDRTN,CRHDSRVN,CRHDDIV)   ;
        K CRHDRTN
        N CRHDUIF,CRHDUSR,CRHDS,CRHDCT,CRHDX,CRHDSORT
        I $D(^VA(200,"E")) D
        .S CRHDUSR=0
        .F  S CRHDUSR=$O(^VA(200,"E",+CRHDSRVN,CRHDUSR)) Q:'CRHDUSR  D
        ..I $$ACTIVE^XUSER(CRHDUSR) D
        ...K CRHDUIF
B       ...D DISP(.CRHDUIF,CRHDUSR)
        ...I $D(CRHDUIF) S:$P(CRHDUIF,"^",3)'="" CRHDSORT($P(CRHDUIF,"^",2))=CRHDUIF
        ;COLUMNS - SEE ABOVE USER
        ;
        ;DISPLAY INFORMATION
        I $D(CRHDSORT) D
        .S CRHDX=""
        .S CRHDCT=0
        .F  S CRHDX=$O(CRHDSORT(CRHDX)) Q:CRHDX=""  D
        ..S CRHDCT=CRHDCT+1
        ..S CRHDRTN(CRHDCT)=CRHDSORT(CRHDX)
        Q
SPEC(CRHDRTN,CRHDSP)    ;
        N CRHDCT,X,CRHDX,CRHDPRV,CRHDPG,CRHDNAM,CRHDS,CRHDUIF,CRHDSORT
        K CRHDRTN
        ;S S="                                   "
        ;S CRHDRTN(1)="Specialty: "_$C(9)_$$GET1^DIQ(45.7,+CRHDSP_",",.01,"E")
        ;S CRHDRTN(2)=""
        ;S CRHDRTN(3)="No provider Found."
        ;S CT=2
        I $D(^DIC(45.7,+CRHDSP,"PRO")) D
        .S X=0
        .F  S X=$O(^DIC(45.7,+CRHDSP,"PRO",X)) Q:'X  D
        ..Q:'$$ACTIVE^XUSER(X)
        ..S CRHDPRV=+$G(^DIC(45.7,+CRHDSP,"PRO",X,0))
        ..D DISP(.CRHDUIF,+CRHDPRV)
        ..I $D(CRHDUIF) S CRHDSORT($P(CRHDUIF,"^",2))=CRHDUIF
        I $D(CRHDSORT) D
        .S CRHDCT=0
        .S CRHDX=""
        .F  S CRHDX=$O(CRHDSORT(CRHDX)) Q:CRHDX=""  D
        ..S CRHDCT=CRHDCT+1
        ..S CRHDRTN(CRHDCT)=CRHDSORT(CRHDX)
        Q
HOTEAM(CRHDRTN,CRHDTM)  ;
        ;Get HOTeam phone list
        N CRHDX,CRHDPRV,CRHDCT,CRHDSORT,CRHDUIF
        K CRHDRTN
        I '$D(^CRHD(183.3,"B",$P(CRHDTM,"^",2),+CRHDTM)) Q
        S CRHDX=0
        F  S CRHDX=$O(^CRHD(183.3,+CRHDTM,2,CRHDX)) Q:'CRHDX  D
        .S CRHDPRV=+$G(^CRHD(183.3,+CRHDTM,2,CRHDX,0))
        .D DISP(.CRHDUIF,+CRHDPRV)
        .I $D(CRHDUIF) S CRHDSORT($P(CRHDUIF,"^",2))=CRHDUIF
        I $D(CRHDSORT) D
        .S CRHDCT=0
        .S CRHDX=""
        .F  S CRHDX=$O(CRHDSORT(CRHDX)) Q:CRHDX=""  D
        ..S CRHDCT=CRHDCT+1
        ..S CRHDRTN(CRHDCT)=CRHDSORT(CRHDX)
        Q
