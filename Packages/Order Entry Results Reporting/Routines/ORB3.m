ORB3    ; slc/CLA,WAT - Main routine for OE/RR 3 notifications ;6/6/01  10:46 [8/16/05 5:33am]
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**31,74,91,105,139,190,220,253,265,296**;Dec 17, 1997;Build 19
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        ;This routine invokes to following ICR(s):
        ;ICR 4156     ;REGISTRATION, COMBAT VETERAN STATUS
        ;
EN(ORN,ORBDFN,ORNUM,ORBADUZ,ORBPMSG,ORBPDATA)   ;
        ;
        N ORBENT
        S ORBENT=$$ENTITY^ORB31(ORNUM)
        ;
        Q:$$GET^XPAR(ORBENT,"ORB SYSTEM ENABLE/DISABLE",1,"I")="D"
        Q:'$L($G(^ORD(100.9,ORN,0)))
        Q:+$$ONOFF^ORB3FN(ORN)=0
        ;
        S ORBPMSG=$E($G(ORBPMSG),1,51)
        ;
        ;if msg from notif file or oc notif (#54), quit if dup w/in past 1 min:
        N ORBDUP,ORBN
        S ORBN=^ORD(100.9,ORN,0)
        I ($P(ORBN,"^",4)="NOT")!(ORN=54) D
        .S ORBDUP=$$DUP^ORB31(ORN,ORBDFN,ORBPMSG,ORNUM)
        Q:+$G(ORBDUP)=1
        ;
        N ORBDESC
        S ORBDESC=" Send Alert Notification ("_(+ORN)_") "_$P($G(^ORD(100.9,+ORN,0)),U,1)_"  "
        ;
        D QUEUE^ORB31(ORN,ORBDFN,$G(ORNUM),.ORBADUZ,$G(ORBPMSG),$G(ORBPDATA),$H,ORBDESC,$G(DGPMA))
        Q
ZTSK    ;
        D START
        S ZTREQ="@"
        Q
UTL(ORBU,ORN,ORBDFN,ORNUM,ORBADUZ,ORBPMSG,ORBPDATA)     ;
        Q:$G(ORBU)'=1
START   Q:$G(ORN)=""!($G(ORBDFN)="")
        Q:'$L($G(^ORD(100.9,ORN,0)))
        N ORBNOW,ORBID,ORBLOCK,ORBDESC
        S ORBNOW=$$NOW^XLFDT
        S ORBLOCK=0
        ;
        ;lock to prevent concurrent processing by other resource slots:
        I '$D(ORBU) D
        .S ^XTMP("ORBLOCK",0)=$$FMADD^XLFDT(ORBNOW,1,"","","")_"^"_ORBNOW
        .S ORBID=$P($P($G(ORBPDATA),"|",2),"@")  ;get unique data id
        .I $L(ORBID) D
        ..LOCK +^XTMP("ORBLOCK",ORBDFN,ORN,ORBID):60 E  D  Q
        ...S ORBDESC=" Requeue Alert Notification ("_(+ORN)_") "_$P($G(^ORD(100.9,+ORN,0)),U,1)_"  "
        ...D QUEUE^ORB31(ORN,ORBDFN,$G(ORNUM),.ORBADUZ,$G(ORBPMSG),$G(ORBPDATA),$$HADD^XLFDT($H,"","",5,""),ORBDESC,$G(DGPMA)) ;requeue in 5 min.
        ...S ORBLOCK=1
        .;
        .I '$L(ORBID) D
        ..LOCK +^XTMP("ORBLOCK",ORBDFN,ORN):60 E  D  Q
        ...S ORBDESC=" Requeue Alert Notification ("_(+ORN)_") "_$P($G(^ORD(100.9,+ORN,0)),U,1)_"  "
        ...D QUEUE^ORB31(ORN,ORBDFN,$G(ORNUM),.ORBADUZ,$G(ORBPMSG),$G(ORBPDATA),$$HADD^XLFDT($H,"","",5,""),ORBDESC,$G(DGPMA)) ;requeue in 5 min.
        ...S ORBLOCK=1
        .;
        I ORBLOCK=1 D QUIT Q
        ;
DOALERT ; Entry point for alert logic outside of TaskMan
        N ORBDUZ,ORBN,ORBXQAID,ORPTNAM,ORBPRIM,ORBATTD,ORBDEV,ORBENT
        N ORBUI,ORBASPEC,ORBSMSG,ORBADT,ORBSDEV,ORBDEL,ORBDI,ORBTDEV,ORY
        S ORBUI=1,ORBADT=0
        S:'$L($G(ORBPMSG)) ORBPMSG=""
        I '$L(ORBPDATA),(+$G(ORNUM)>0) S ORBPDATA=+$G(ORNUM)_"@"
        S ORBN=^ORD(100.9,ORN,0)
        ;
        S ORBENT=$$ENTITY^ORB31(ORNUM)
        ;
        N DFN S DFN=ORBDFN,VA200="" D OERR^VADPT
        I ('$L($G(VA("BID"))))!('$L($G(VADM(1)))) D QUIT Q
        I (ORN=18)!(ORN=20)!(ORN=35) S ORBADT=1 ;A/D/T notif
        ;if not an A/D/T notif, get primary & attending from OERR^VADPT:
        I ORBADT=0 S ORBPRIM=+$P(VAIN(2),U),ORBATTD=+$P(VAIN(11),U)
        I ORBADT=1 D ADT^ORB31(ORN,ORBDFN,.ORBPRIM,.ORBATTD,$G(ORDGPMA)) ;A/D/T notif
        I $D(ORBU) D  ;create debug msg
        .S ORBU(ORBUI)="Processing notification: "_$P(ORBN,U),ORBUI=ORBUI+1
        .S ORBU(ORBUI)="            for patient: "_VADM(1),ORBUI=ORBUI+1
        .I $G(ORNUM)>0 S ORBU(ORBUI)="              for order: "_ORNUM,ORBUI=ORBUI+1
        D REGULAR^ORB3REG(ORN,.XQA,.ORBU,.ORBUI,.ORBDEV,ORBDFN)
        D SPECIAL^ORB3SPEC(ORN,.ORBASPEC,.ORBU,.ORBUI,$G(ORNUM),ORBDFN,$G(ORBPDATA),.ORBSMSG,$G(ORBPMSG),.ORBSDEV,$G(ORBPRIM),$G(ORBATTD))
        I $L($G(ORBSMSG)) S ORBPMSG=$E(ORBSMSG,1,51)
        I $D(ORBASPEC)>1 D SPECDUZS ;special recips
        I $D(ORBADUZ)>1 D PKGDUZS ;pkg-supplied recips
        D TITLE ;provider recips
        S ORBXQAID=$P(ORBN,"^",2)_","_ORBDFN_","_ORN
        ;
        I ($D(XQA)>1)!($D(ORBDEV)>1)!($D(ORBSDEV)>1) D  ;recips found
        .S XQAFLG=$P(ORBN,"^",5)
        .S XQADFN=ORBDFN
        .I XQAFLG="R" S XQAROU=$P(ORBN,"^",6)_"^"_$P(ORBN,"^",7)
        .I $G(ORBPDATA)'="" S XQADATA=ORBPDATA
        .S ORPTNAM=$E(VADM(1)_"         ",1,9)
        .I $G(ORN)=27 N CVMRKR,RSLT S RSLT=$$CVEDT^DGCV(DFN) I $P($G(RSLT),U)&($P($G(RSLT),U,3)) S CVMRKR=" CV "_$$FMTE^XLFDT($P($G(RSLT),U,2),"5DZ") ;WAT
        .S XQAMSG=ORPTNAM_" "_"("_$E(ORPTNAM)_$E(VA("BID"),1,4)_")"_$G(CVMRKR)_": " ;WAT
        .S XQAMSG=XQAMSG_$S(ORBPMSG'="":ORBPMSG,1:$P(ORBN,"^",3))
        .S XQAARCH=$$GET^XPAR(ORBENT,"ORB ARCHIVE PERIOD",ORN,"I")
        .S XQASUPV=$$GET^XPAR(ORBENT,"ORB FORWARD SUPERVISOR",ORN,"I")
        .S XQASURO=$$GET^XPAR(ORBENT,"ORB FORWARD SURROGATES",ORN,"I")
        .S XQAREVUE=$$GET^XPAR(ORBENT,"ORB FORWARD BACKUP REVIEWER",ORN,"I")
        .S XQACNDEL=$$GET^XPAR(ORBENT,"ORB REMOVE",ORN,"I")
        .S XQACNDEL=$S(XQACNDEL=1:1,1:"")
        .I $D(ORBDEV)>1 D REGDEV^ORB31(.ORBDEV)
        .I $D(ORBSDEV)>1 D REGDEV^ORB31(.ORBSDEV)
        .I $D(ORBTDEV)>1 D REGDEV^ORB31(.ORBTDEV)
        .S XQAID=ORBXQAID
        .I $D(XQA) D SETUP^XQALERT  ;if no [new] recips don't send alert
QUIT    ;
        K VA,VA200,VADM,VAERR,VAIN,XQA,XQADATA,XQAID,XQAFLG,XQAMSG,XQAROU,XQAARCH,XQASUPV,XQASURO,XQADFN
        K ^XTMP("ORBUSER",$J)
        I '$D(ORBU),$D(ORBLOCK) D
        .I $G(ORBID)]"" LOCK -^XTMP("ORBLOCK",ORBDFN,ORN,ORBID)
        .E  LOCK -^XTMP("ORBLOCK",ORBDFN,ORN)
        Q
PKGDUZS ;get DUZs from pkg-passed ORBADUZ() array
        N ORBPDUZ
        I $D(ORBU) D
        .S ORBU(ORBUI)=" ",ORBUI=ORBUI+1
        .I ORN=68 S ORBU(ORBUI)="Recipients with Lab Threshold Exceeded:",ORBUI=ORBUI+1
        .E  S ORBU(ORBUI)="Recipients defined when notif was triggered:",ORBUI=ORBUI+1
        S ORBPDUZ=""
        F  S ORBPDUZ=$O(ORBADUZ(ORBPDUZ)) Q:ORBPDUZ=""  S ORBDUZ=ORBPDUZ D USER
        Q
SPECDUZS        ;get DUZs rtn by SPECIAL^ORB3SPEC
        N ORBSDUZ
        I $D(ORBU) D
        .S ORBU(ORBUI)=" ",ORBUI=ORBUI+1
        .S ORBU(ORBUI)="Special recipients associated with the notification:",ORBUI=ORBUI+1
        S ORBSDUZ=""
        F  S ORBSDUZ=$O(ORBASPEC(ORBSDUZ)) Q:ORBSDUZ=""  S ORBDUZ=ORBSDUZ D USER
        Q
TITLE   ;get provider recips
        N TITLES
        I $D(ORBU) D
        .S ORBU(ORBUI)=" ",ORBUI=ORBUI+1
        .S ORBU(ORBUI)="Recipients determined by Provider Recipient parameter:",ORBUI=ORBUI+1
        ;
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
        I $D(ORBU),ORBADT=0 S ORBU(ORBUI)=" Inpt primary provider:",ORBUI=ORBUI+1
        I $D(ORBU),ORBADT=1 S ORBU(ORBUI)=" Inpt primary provider: option cannot determine without A/D/T event data.",ORBUI=ORBUI+1
        I +$G(ORBPRIM)>0 S ORBDUZ=ORBPRIM D USER
        Q
ATTEND  ;
        I $D(ORBU),ORBADT=0 S ORBU(ORBUI)=" Attending physician:",ORBUI=ORBUI+1
        I $D(ORBU),ORBADT=1 S ORBU(ORBUI)=" Attending physician: option cannot determine without A/D/T event data.",ORBUI=ORBUI+1
        I +$G(ORBATTD)>0 S ORBDUZ=ORBATTD D USER
        Q
TEAMS   ;
        I $D(ORBU) S ORBU(ORBUI)=" Teams/Personal Lists related to patient:",ORBUI=ORBUI+1
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
        D USER^ORB3USER(.XQA,ORBDUZ,ORN,.ORBU,.ORBUI,ORBDFN,+$G(ORNUM))
        Q
