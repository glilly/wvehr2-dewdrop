GMVGGR1 ;HOIFO/YH,FT-VITAL SIGNS RECORD SF 511 ;10/24/07
        ;;5.0;GEN. MED. REC. - VITALS;**3,23**;Oct 31, 2002;Build 25
        ;
        ; This routine uses the following IAs:
        ;  #3214 - ^GMRYAPI calls         (private)
        ;  #4290 - ^PXRMINDX global       (controlled)
        ; #10040 - FILE 44 references     (supported)
        ; #10061 - ^VADPT calls           (supported)
        ; #10096 - ^%ZOSF calls           (supported)
        ;
        ; This routine supports the following IAs:
        ; #4654 - GMV V/M ALLDATA RPC is called at VMDATA (private)
        ;
VMDATA(RESULT,GMVDATA)  ;GMV V/M ALLDATA [RPC entry point]
        ;ENTRY POINT FROM GMRV SF511 GUI TO EXTRACT ALL DATA
        ; GMVDATA: piece 1 = DFN
        ;                2 = start date
        ;                3 = end date
        ;                4 = 0
        ;                5 = database screen
        ;                    0 = return records from Vitals & FlowSheets (default)
        ;                    1 = return records from Vitals only
        ;                    2 = return records from FlowSheets only
        ;
        N DFN,GQT,X,Y
        N GCHA,GMVCLIO,GMVLOOP,GSEL,%,%H,%I,%T,GMVQNAME,GMVDB
        K ^TMP($J)
        S (GMROUT,GN,GQT)=0,DFN=+$P(GMVDATA,"^"),GMRSTRT=$P(GMVDATA,"^",2),GMRFIN=$P(GMVDATA,"^",3),GMR=+$P(GMVDATA,"^",4),GMVDB=+$P(GMVDATA,U,5)
        S GMVDB=$S(GMVDB=2:2,GMVDB=1:1,1:0)
        S GSEL=0,GMR=0
        S Y=GMRSTRT X ^DD("DD") S GSTRFIN=Y S Y=GMRFIN X ^DD("DD") S GSTRFIN=GSTRFIN_" - "_Y
        S GMRHT=0
        K ^TMP($J,"GMR"),^TMP($J,"GMRK"),^TMP($J,"GDT"),^TMP($J,"GMRVG"),^TMP($J,"GTNM")
        S GSTART1=GMRSTRT-.0001,GEND1=GMRFIN
        F GTYPE="B","H","P","R","T","W","PO2","CVP","CG","PN" D SETT
        S GRPT=5 D:GMR'=1 SETIO D ^GMVGGR2
Q1      K GMR,GSOL,GIVDT,GMRHLOC,GMRVJ,GDATA,GDT,GEN,GEND1,GI,GJ,GK,GMRVX,GSTART1,GTNM,GTYP,GTYPE,GX,I D KVAR^VADPT K VA,VAROOT
        D QIO^GMVGR5
        K GRPT,GMROUT,GMRRMBD,GAGE,GCNT,GDOB,GCNTB,GCNTD,GCNTP,GCNTR,GCNTT,GCNTT1,GCNTI,GCNTO,GDT1,GCNTPD,GCNTTD,GCNTW,GPG,GPGS,GHT,GTYPE1,GCNTB3,GDTA,XDT,XIO,XX,^TMP($J,"GMRK"),^TMP($J,"GMR"),^TMP($J,"GDT"),^TMP($J,"GMRVG")
        K GLINE,GMRQUAL,^TMP($J,"GTNM"),G,GDA,GDIP,GDOP,GINF,GMIN,GMRFIN,GMRHT,GMRSITE,GMRSTRT,GMRVARY,GMRVHLOC,GMRWARD,GN,GNDATE,GNSHFT,GRNDIP,GRNDOP,GRNGIP,GSIP,GSOP,GSTAR,GSTRFIN,GSUB
        Q
SETT    ;SET GMRT
        S GTYP(1)=$S(GTYPE="B":"BLOOD PRESSURE",GTYPE="P":"PULSE",GTYPE="R":"RESPIRATION",GTYPE="T":"TEMPERATURE",GTYPE="H":"HEIGHT",GTYPE="W":"WEIGHT",GTYPE="CG":"CIRCUMFERENCE/GIRTH",GTYPE="PO2":"PULSE OXIMETRY",1:"")
        I GTYP(1)="" S GTYP(1)=$S(GTYPE="CVP":"CENTRAL VENOUS PRESSURE",GTYPE="PN":"PAIN",1:"")
        Q:GTYP(1)=""
        S GTYP=$O(^GMRD(120.51,"B",GTYP(1),"")),GX=GSTART1
        I GTYP>0 F  S GX=$O(^PXRMINDX(120.5,"PI",DFN,GTYP,GX)) Q:GX'>0!(GX>GEND1)  S GEN=0 F  S GEN=$O(^PXRMINDX(120.5,"PI",DFN,GTYP,GX,GEN)) Q:$L(GEN)'>0  D
        .K GMVCLIO
        .I GEN=+GEN,GMVDB=2 Q  ;want clio records only
        .I GEN'=+GEN,GMVDB=1 Q  ;want vitals records only
        .I GEN=+GEN D
        ..D F1205^GMVUTL(.GMVCLIO,GEN)
        .I GEN'=+GEN D
        ..D CLIO^GMVUTL(.GMVCLIO,GEN)
        .S GMVCLIO(0)=$G(GMVCLIO(0)),GMVCLIO(5)=$G(GMVCLIO(5))
        .I GMVCLIO(0)=""!($P(GMVCLIO(0),U,8)="") Q
        .S GMVLOOP=0,GG=""
        .F GMVLOOP=1:1 Q:$P(GMVCLIO(5),U,GMVLOOP)=""  D
        ..S GMVQNAME=$$FIELD^GMVGETQL($P(GMVCLIO(5),U,GMVLOOP),1,"E")
        ..I GMVQNAME=""!(GMVQNAME=-1) Q
        ..S GG=GG_$S(GG'="":";",1:"")_GMVQNAME
        .D BLDARR
        .Q
        Q
BLDARR  ;
        N GMVLOC,GMVUSER
        S GDATA=GMVCLIO(0)
        Q:GDATA=""
        S GMVLOC=+$P(GDATA,U,5) ;hospital location ien
        S GMVLOC=$P($G(^SC(GMVLOC,0)),U,1)
        S GMVUSER=+$P(GDATA,U,6) ;user duz
        S GMVUSER=$$PERSON^GMVUTL1(GMVUSER)
        S GMRVX=GTYPE,GMRVX(0)=$P(GDATA,"^",8),GMRVX(1)=0  D:GMRVX(0)>0!(GMRVX(0)<0)!($E(GMRVX(0))="0") EN1^GMVSAS0
        S ^TMP($J,"GMRVG",GX,GTYPE,$P(GDATA,"^",8))=GG_"^"_$S($G(GMRVX(1))>0:1,1:"")_"^^"_$P(GDATA,"^",10)_U_GMVLOC_U_GMVUSER_U_$S(GEN=+GEN:"Vitals",1:"CLIO")
        S:$D(^TMP($J,"GMRVG",GX,"H",$P(GDATA,"^",8))) GHT=$P(GDATA,"^",8)
        ;I GTYPE="B",$P(GDATA,"^",8)'>0 S ^TMP($J,"GMRVG",9999999-GX,"B",$P(GDATA,"^",8))="^^"
        K GG
        Q
SETIO   ;
        S X="GMRYRP0" X ^%ZOSF("TEST") Q:'$T
        D IO^GMVGR5
        D SETIOAR
        Q
SETIOAR F GTYPE1="XI"_($$INPUT^GMRYAPI()+4),"XO"_($$OUTPUT^GMRYAPI()+1) F GDT=0:0 S GDT=$O(^TMP($J,"GMR",GTYPE1,GDT)) Q:GDT'>0  F GDTA=0:0 S GDTA=$O(^TMP($J,"GMR",GTYPE1,GDT,GDTA)) Q:GDTA=""  D SETIOAR1
        Q
SETIOAR1        S:GTYPE1["XI" ^TMP($J,"GMRVG",GDT,"I",GDTA)="^" S:GTYPE1["XO" ^TMP($J,"GMRVG",GDT,"O",GDTA)="^"
        Q
