ORBPRCHK        ; SLC/JMH - API to return who gets notifications TAKEN FROM ORB3;
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
CHECK(ORPERS,ORNUM,ORN,ORBDFN)  ; returns 1 if ORPERS should get the alert
        N ORRET,ORY
        D START(.ORRET,ORNUM,ORN,ORBDFN)
        S ORY=$S($D(ORRET(ORPERS)):1,1:0)
        Q ORY
START(ORRET,ORNUM,ORN,ORBDFN)   ;
        Q:$G(ORN)=""!($G(ORBDFN)="")
        Q:'$L($G(^ORD(100.9,ORN,0)))
        N ORBNOW,ORBID,ORBLOCK,ORBDESC
        S ORBNOW=$$NOW^XLFDT
        N ORBDUZ,ORBN,ORBXQAID,ORPTNAM,ORBPRIM,ORBATTD,ORBDEV,ORBENT
        N XQA,VAIN,VADM,DIC,ORBPDATA,ORBPMSG,VA,VA200,VAERR,X,Y
        N ORBUI,ORBASPEC,ORBSMSG,ORBADT,ORBSDEV,ORBDEL,ORBDI,ORBTDEV,ORY
        S ORBUI=1,ORBADT=0
        S:'$L($G(ORBPMSG)) ORBPMSG=""
        S ORBPDATA=+$G(ORNUM)_"@"
        S ORBN=^ORD(100.9,ORN,0)
        ;
        S ORBENT=$$ENTITY^ORB31(ORNUM)
        D REGULAR^ORB3REG(ORN,.XQA,.ORBU,.ORBUI,.ORBDEV,ORBDFN)
        D SPECIAL^ORB3SPEC(ORN,.ORBASPEC,.ORBU,.ORBUI,$G(ORNUM),ORBDFN,$G(ORBPDATA),.ORBSMSG,$G(ORBPMSG),.ORBSDEV,$G(ORBPRIM),$G(ORBATTD))
        I $D(ORBASPEC)>1 D SPECDUZS ;special recips
        I $D(ORBADUZ)>1 D PKGDUZS ;pkg-supplied recips
        D TITLE ;provider recips
        M ORRET=XQA
        Q
PKGDUZS ;get DUZs from pkg-passed ORBADUZ() array
        N ORBPDUZ
        S ORBPDUZ=""
        F  S ORBPDUZ=$O(ORBADUZ(ORBPDUZ)) Q:ORBPDUZ=""  S ORBDUZ=ORBPDUZ D USER
        Q
SPECDUZS        ;get DUZs rtn by SPECIAL^ORB3SPEC
        N ORBSDUZ
        S ORBSDUZ=""
        F  S ORBSDUZ=$O(ORBASPEC(ORBSDUZ)) Q:ORBSDUZ=""  S ORBDUZ=ORBSDUZ D USER
        Q
TITLE   ;get provider recips
        N TITLES
        S TITLES=$$GET^XPAR(ORBENT,"ORB PROVIDER RECIPIENTS",ORN,"I")
        I TITLES["P" D PRIMARY
        I TITLES["A" D ATTEND
        I TITLES["T" D TEAMS
        I TITLES["O" D ORDERER
        I TITLES["E" D ENTERBY
        I TITLES["R" D PCMMPRIM
        I TITLES["S" D PCMMASSC
        I TITLES["M" D PCMMTEAM
        Q
PRIMARY ;
        I +$G(ORBPRIM)>0 S ORBDUZ=ORBPRIM D USER
        Q
ATTEND  ;
        I +$G(ORBATTD)>0 S ORBDUZ=ORBATTD D USER
        Q
TEAMS   ;
        N ORBLST,ORBI,ORBJ,ORBTM,ORBTNAME,ORBTTYPE,ORBTD
        D TMSPT^ORQPTQ1(.ORBLST,ORBDFN)
        Q:+$G(ORBLST(1))<1
        S ORBI="" F  S ORBI=$O(ORBLST(ORBI)) Q:ORBI=""  D
        .S ORBTM=$P(ORBLST(ORBI),U),ORBTNAME=$P(ORBLST(ORBI),U,2)
        .S ORBTTYPE=$P(ORBLST(ORBI),U,3)
        .I $D(ORBU) D
        ..S ORBU(ORBUI)="  Patient list "_ORBTNAME_" ["_ORBTTYPE_"]:",ORBUI=ORBUI+1
        .N ORBLST2 D TEAMPROV^ORQPTQ1(.ORBLST2,ORBTM)
        .Q:+$G(ORBLST2(1))<1
        .S ORBJ="" F  S ORBJ=$O(ORBLST2(ORBJ)) Q:ORBJ=""  D
        ..S ORBDUZ=$P(ORBLST2(ORBJ),U)_U_ORBTM I +$G(ORBDUZ)>0 D USER
        .;
        .S ORBTD=$P($$TMDEV^ORB31(ORBTM),U,2)  ;Team's device
        .I $L(ORBTD) D
        ..S ORBTDEV(ORBTD)=""
        ..I $D(ORBU) D
        ...S ORBU(ORBUI)="   Team's Device "_ORBTD_" is a recipient",ORBUI=ORBUI+1
        Q
ORDERER ;
        Q:+$G(ORNUM)<1
        I $D(ORBU) S ORBU(ORBUI)=" Ordering provider:",ORBUI=ORBUI+1
        N ORBLST,ORBI,ORBTM,ORBJ,ORBTNAME,ORBPLST,ORBPI,ORBPTM,ORBTTYPE
        S ORBDUZ=$S(ORN=12:+$$UNSIGNOR^ORQOR2(ORNUM),1:$$ORDERER^ORQOR2(ORNUM))
        I +$G(ORBDUZ)>0 D
        .D USER
        .;if notif = Order Req E/S (#12) or Order Req Co-sign (#37) and
        .;user doesn't have ES authority, send to fellow team members w/ES:
        .I ((ORN=12)!(ORN=37)),('$D(^XUSEC("ORES",ORBDUZ))) D
        ..I $D(ORBU) S ORBU(ORBUI)=" Orderer can't elec sign, getting teams orderer belongs to:",ORBUI=ORBUI+1
        ..D TEAMPR^ORQPTQ1(.ORBLST,ORBDUZ)  ;get orderer's tms
        ..Q:+$G(ORBLST(1))<1
        ..D TMSPT^ORQPTQ1(.ORBPLST,ORBDFN)  ;get pt's tms
        ..Q:+$G(ORBPLST(1))<1
        ..S ORBI="" F  S ORBI=$O(ORBLST(ORBI)) Q:ORBI=""  D
        ...S ORBPI="" F  S ORBPI=$O(ORBPLST(ORBPI)) Q:ORBPI=""  D
        ....S ORBTM=$P(ORBLST(ORBI),U),ORBPTM=$P(ORBPLST(ORBPI),U)
        ....I ORBTM=ORBPTM D  ;if pt is on provider's team
        .....I +$G(ORBPTM)>0 D
        ......S ORBTNAME=$P(ORBPLST(ORBPI),U,2)
        ......S ORBTTYPE=$P(ORBPLST(ORBPI),U,3)
        ......I $D(ORBU) S ORBU(ORBUI)="  Orderer's pt list "_ORBTNAME_" ["_ORBTTYPE_"] recipients: ",ORBUI=ORBUI+1
        ......N ORBLST2 D TEAMPROV^ORQPTQ1(.ORBLST2,ORBPTM)
        ......Q:+$G(ORBLST2(1))<1
        ......S ORBJ="" F  S ORBJ=$O(ORBLST2(ORBJ)) Q:ORBJ=""  D
        .......S ORBDUZ=$P(ORBLST2(ORBJ),U)_U_ORBPTM I +$G(ORBDUZ)>0,($D(^XUSEC("ORES",+ORBDUZ))) D USER
        Q
ENTERBY ;
        I $D(ORBU) S ORBU(ORBUI)=" User entering order's most recent activity:",ORBUI=ORBUI+1
        Q:+$G(ORNUM)<1
        I $D(^OR(100,ORNUM,8,0)) D
        .S ORBDUZ=$P(^OR(100,ORNUM,8,$P(^OR(100,ORNUM,8,0),U,3),0),U,13)
        I +$G(ORBDUZ)>0 D USER
        Q
PCMMPRIM        ;
        I $D(ORBU) S ORBU(ORBUI)=" PCMM Primary Care Practitioner:",ORBUI=ORBUI+1
        S ORBDUZ=+$$OUTPTPR^SDUTL3(ORBDFN,$$NOW^XLFDT,1)  ;DBIA #1252
        I +$G(ORBDUZ)>0 D USER
        Q
PCMMASSC        ;
        I $D(ORBU) S ORBU(ORBUI)=" PCMM Associate Provider:",ORBUI=ORBUI+1
        S ORBDUZ=+$$OUTPTAP^SDUTL3(ORBDFN,$$NOW^XLFDT)  ;DBIA #1252
        I +$G(ORBDUZ)>0 D USER
        Q
PCMMTEAM        ;
        N ORPCMM,ORPCMMDZ
        I $D(ORBU) S ORBU(ORBUI)=" PCMM Team Position Assignments:",ORBUI=ORBUI+1
        S ORPCMM=$$PRPT^SCAPMC(ORBDFN,,,,,,"^TMP(""ORPCMM"",$J)",)  ;DBIA #1916
        S ORPCMMDZ=0
        F  S ORPCMMDZ=$O(^TMP("ORPCMM",$J,"SCPR",ORPCMMDZ)) Q:'ORPCMMDZ  D
        .S ORBDUZ=ORPCMMDZ D USER
        K ^TMP("ORPCMM",$J)
        Q
USER    ;should USER (ORBDUZ) be a recip
        I $P($$ONOFF^ORB3USER(ORN,+ORBDUZ,ORBDFN,,ORNUM),U)="ON" S XQA(+ORBDUZ)=""
        Q
