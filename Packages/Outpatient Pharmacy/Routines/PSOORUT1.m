PSOORUT1        ;BIR/SAB - Utility routine for oerr interface ;6/28/07 7:36am
        ;;7.0;OUTPATIENT PHARMACY;**1,14,30,46,132,148,233,274,225,305**;DEC 1997;Build 8
        ;External reference to ^PSDRUG supported by DBIA 221
        ;External reference to ^PSXOPUTL supported by DBIA 2203
        ;called from HD^PSOORUTL
REL     ;removed order from hold
        S ACT=1,ORS=0
        I POERR("PSOFILNM")["S" S DA=+POERR("PSOFILNM") D  G EXIT^PSOORUTL
        .Q:'$D(^PS(52.41,DA,0))  Q:$P(^PS(52.41,DA,0),"^",3)="RF"
        .S $P(^PS(52.41,DA,0),"^",3)="NW",POERR("STAT")="OR",POERR("FILLER")=DA_"^P"
        .S:$G(POERR("COMM"))']"" POERR("COMM")="Order RELEASED from HOLD by OE/RR before finished." S $P(^PS(52.41,DA,4),"^")=POERR("COMM"),ORS=1
        S DA=POERR("PSOFILNM") I $D(^PSRX(DA,0)) S ORS=1,PSDA=DA D  G EXIT^PSOORUTL
        .S POERR("FILLER")=DA_"^R",POERR("STAT")="OR"
        .S:'$D(POERR("COMM")) POERR("COMM")="Prescription Released from HOLD by OE/RR"
        .I DT>$P(^PSRX(DA,2),"^",6) D
        ..S EXP=$P(^PSRX(DA,2),"^",6) S:$P(^PSRX(DA,"STA"),"^")<12 $P(^PSRX(DA,"STA"),"^")=11,PSOEXFLG=1 S POERR("STAT")="UR",POERR("COMM")="Medication Expired on "_$E(EXP,4,5)_"/"_$E(EXP,6,7)_"/"_$E(EXP,2,3)_".",POERR("PHARMST")="" D ECAN^PSOUTL(DA) Q
        .I $P(^PSRX(DA,"STA"),"^")'=16 S POERR("STAT")="UR",POERR("COMM")="Unable to Release from Hold" Q
        .S RXFL(DA)=0,FDT=$P(^PSRX(DA,2),"^",2)
        .I $O(^PSRX(DA,1,0)) F I=0:0 S I=$O(^PSRX(DA,1,I)) Q:'I  S FDT=$P(^PSRX(DA,1,I,0),"^"),RXFL(DA)=I
        .I FDT>DT N PSOSITEZ,ZPSOPAR6 S PSOSITEZ=$S($P($G(^PSRX(DA,2)),"^",9):$P(^(2),"^",9),1:$O(^PS(59,0))),ZPSOPAR6=$P($G(^PS(59,PSOSITEZ,1)),"^",6) I ZPSOPAR6 D  Q
        ..S RXXDA=DA,DA=$O(^PS(52.5,"B",RXXDA,0)) I DA S DIK="^PS(52.5," D ^DIK K DIK
        ..S DA=RXXDA
        ..S DIC="^PS(52.5,",DIC(0)="L",DLAYGO=52.5,X=RXXDA,DIC("DR")=".02///"_FDT_";.03////"_$P(^PSRX(DA,0),"^",2)_";.04///M;.05///0;.06////"_PSOSITEZ_";2///0;9///"_RXFL(DA) K DD,DO D FILE^DICN K RXFL,DD,DO
        ..S DA=RXXDA K RXXDA S $P(^PSRX(DA,"STA"),"^")=5,LFD=$E(FDT,4,5)_"-"_$E(FDT,6,7)_"-"_$E(FDT,2,3) D ACT1
        ..S PSOSUSZ=1
        .E  S $P(^PSRX(DA,"STA"),"^")=0
        .S RXF=0 F I=0:0 S I=$O(^PSRX(DA,1,I)) Q:'I  S RXF=I S:I>5 RXF=I+1
        .D ACT^PSOORUTL
        .I $$SUBMIT^PSOBPSUT(DA) D ECMESND^PSOBPSU1(DA,,$$RXFLDT^PSOBPSUT(DA),$S('$O(^PSRX(DA,1,0)):"OF",1:"RF"))
        G EXIT^PSOORUTL
ACT1    S RXF=0 F I=0:0 S I=$O(^PSRX(DA,1,I)) Q:'I  S RXF=I S:I>5 RXF=I+1
        S IR=0 F FDA=0:0 S FDA=$O(^PSRX(DA,"A",FDA)) Q:'FDA  S IR=FDA
        S IR=IR+1,^PSRX(DA,"A",0)="^52.3DA^"_IR_"^"_IR
        D NOW^%DTC S ^PSRX(DA,"A",IR,0)=%_"^S^"_POERR("USER")_"^"_RXF_"^"_"RX Placed on Suspense until "_LFD
        Q
SUS     ;
        I $P($G(^PSRX(+$G(FILLER),"STA")),"^")=5 N PSOMSORR,PLACERXX D EN^PSOHLSN1(+$G(FILLER),"SC","ZS","")
        Q
BLD     ;builds med profile for Listman
        K ^TMP("PSOPF",$J),PSOLST S:$G(PSOOPT)'=3 PSOOPT=0 I '$G(PSOSD) S ^TMP("PSOPF",$J,1,0)="This patient has no prescriptions" S PSOCNT=0,PSOPF=1 Q
        D EOJ,SHOW
EOJ     ;
        K PSOQFLG,PSODRG,PSODATA,PSOLF
        Q
        ;-----------------------------------------------------------------
SHOW    ;
        ; - ePharmacy modification to create a section for Rx with REJECTs
        N PSOTMP,PSOSTS,PSODRNM,I,PSORX
        S (PSOSTS,PSODRNM)=""
        F  S PSOSTS=$O(PSOSD(PSOSTS)) Q:PSOSTS=""  D
        . F  S PSODRNM=$O(PSOSD(PSOSTS,PSODRNM)) Q:PSODRNM=""  D
        . . S PSORX=+$G(PSOSD(PSOSTS,PSODRNM))
        . . I PSOSTS="ACTIVE",$$FIND^PSOREJUT(PSORX) D  Q
        . . . S PSOTMP(" REJECT",PSODRNM)=PSOSTS
        . . S PSOTMP(PSOSTS,PSODRNM)=PSOSTS
        ;
        S (PSOSTS,PSODRG)="",(PSOCNT,PSOQFLG,IEN)=0
        K RN,DL S $P(RN," ",12)=" ",$P(DL," ",40)=" "
        F PSCNT=0:0 S PSOSTS=$O(PSOTMP(PSOSTS)) Q:PSOSTS=""  D
        . D STA
        . F PSOCT=0:0 S PSODRG=$O(PSOTMP(PSOSTS,PSODRG)) Q:PSODRG=""  Q:PSOCNT>1000!PSOQFLG  D
        . . S PSOSTA=PSOTMP(PSOSTS,PSODRG)
        . . S PSODATA=PSOSD(PSOSTA,PSODRG) I PSOSTA="ZNONVA" D NVA Q
        . . S PSOCNT=PSOCNT+1 I PSOSTA="PENDING" D PEN Q
        . . S:'$D(^PSRX(+PSODATA,0)) PSOCNT=PSOCNT-1 D:$D(^(0)) DISPL
        S (VALMCNT,PSOPF)=IEN
SHOWX   K DIRUT,DTOUT,DUOUT,DIROUT,PSODRG
        Q
        ;
DISPL   S IEN=IEN+1 N PSOID,PSOCMOP,STATLTH,ECME
        K PSOLNT,PSOQTL,PSOLSP S PSOLRX=$S($G(^PSRX(+PSODATA,"IB")):13,1:14)-$L($P(^PSRX(+PSODATA,0),"^")),$P(PSOLNT," ",PSOLRX)=" ",PSODQL=$L($P(PSODRG,"^"))+$L($P(^PSRX(+PSODATA,0),"^",7))
        I PSODQL<39 S $P(PSOQTL," ",(40-PSODQL))=" "
        E  S $P(PSOQTL," ",(52-$L($P(^PSRX(+PSODATA,0),"^",7))))=" ",$P(PSOLSP," ",(41-$L($P(PSODRG,"^"))))=" "
        S ECME=$$ECME^PSOBPSUT(+PSODATA) I ECME'="" S PSOLNT=$E(PSOLNT,1,$L(PSOLNT)-1)
        S ^TMP("PSOPF",$J,IEN,0)=$J(PSOCNT,2)_$S($L(PSOCNT)<3:" ",1:"")_$P(^PSRX(+PSODATA,0),"^")_$S($G(^PSRX(+PSODATA,"IB")):"$",1:"")_ECME_PSOLNT_$P(PSODRG,"^")_$S(PSODQL<39:PSOQTL_$P(^PSRX(+PSODATA,0),"^",7)_" ",1:$G(PSOLSP))
        S STA="A^N^R^H^N^S^^^^^^E^DC^^DC^DE^H^P^"
        S PSOCMOP=""
        I $D(^PSDRUG("AQ",$P(^PSRX(+PSODATA,0),"^",6))) S PSOCMOP=">"
        N X S X="PSXOPUTL" X ^%ZOSF("TEST") K X I $T D
        .N DA S DA=+PSODATA D ^PSXOPUTL K DA
        .I $G(PSXZ(PSXZ("L")))=0!($G(PSXZ(PSXZ("L")))=2) S PSOCMOP="T"
        .K PSXZ
        N PSOBADR
        S PSOBADR=$O(^PSRX(+PSODATA,"L",9999),-1)
        I PSOBADR'="" S PSOBADR=$G(^PSRX(+PSODATA,"L",PSOBADR,0)) I PSOBADR["(BAD ADDRESS)" S PSOBADR="B"
        I PSOBADR'="B" S PSOBADR=""
        S STAPRT=$P(STA,"^",$P(PSODATA,"^",2)+1)_PSOCMOP_PSOBADR
        S STATLTH=$L(STAPRT)
        S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_STAPRT_$S(STATLTH=0:"   ",STATLTH=1:"  ",STATLTH=2:" ",1:"")
        S PSOID=$P(^PSRX(+PSODATA,0),"^",13),PSOLF=+$G(^(3)),^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$E(PSOID,4,5)_"-"_$E(PSOID,6,7)_" "
        N RFLZRO,PSOLRD S PSOLRD=$P($G(^PSRX(+PSODATA,2)),"^",13)
        F PSOX=0:0 S PSOX=$O(^PSRX(+PSODATA,1,PSOX)) Q:'PSOX  D
        . S RFLZRO=$G(^PSRX(+PSODATA,1,PSOX,0))
        . I +RFLZRO=PSOLF,$P(RFLZRO,"^",16) S PSOLF=PSOLF_"^R"
        . S:$P(RFLZRO,"^",18)'="" PSOLRD=$P(RFLZRO,"^",18) I $P(RFLZRO,"^",16) S PSOLRD=PSOLRD_"^R"
        K PSOX
        I '$O(^PSRX(+PSODATA,1,0)),$P(^PSRX(+PSODATA,2),"^",15) S PSOLF=PSOLF_"^R",PSOLRD=PSOLRD_"^R"
        S PSOLF=$S($G(PSOLF):$E(PSOLF,4,5),1:"  ")_"-"_$S($G(PSOLF):$E(PSOLF,6,7),1:"  ")_$S($P(PSOLF,"^",2)="R":"R ",1:"  ")
        S PSOLRD=$S($G(PSOLRD):$E(PSOLRD,4,5),1:"  ")_"-"_$S($G(PSOLRD):$E(PSOLRD,6,7),1:"  ")_$S($P(PSOLRD,"^",2)="R":"R ",1:"  ")
        S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$S($G(PSORFG):PSOLRD,1:PSOLF)
        S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$J($P(PSODATA,"^",6),2)_" "_$J($P(PSODATA,"^",8),3)
        I PSODQL>38 S IEN=IEN+1 S ^TMP("PSOPF",$J,IEN,0)=PSOQTL_"Qty: "_$P(^PSRX(+PSODATA,0),"^",7)
        K PSOLNT,PSOQTL,PSOLSP,PSOLRX,PSODQL
        S PSOLST(PSOCNT)="52^"_+PSODATA_"^"_PSOSTA
        K PSODATA,PSOLF S PSOPF=IEN
        Q
        ;
STA     N LABEL,LINE,POS
        S LABEL=PSOSTS,IEN=IEN+1
        I PSOSTS="ZNONVA" S LABEL="Non-VA MEDS (Not dispensed by VA)"
        I PSOSTS=" REJECT" S LABEL="REFILL TOO SOON/DUR REJECTS (Third Party)"
        S POS=80-$L(LABEL)/2,$P(LINE,"-",81)="",$E(LINE,POS+1,POS+$L(LABEL))=LABEL
        S ^TMP("PSOPF",$J,IEN,0)=LINE
        Q
PENX    S PSOLST(PSOCNT)="52.41^"_$P(PSODATA,"^",10)_"^"_PSOSTA
        K PSODATA,PSOLF,RN,PSOLSP,PSOQTL,PSOLNT
        Q
PEN     ;
        N PSOQTL,PSOLNT,PSOLNTZ,PSOQTLX,PSCMOPF,SPACEZ
        Q:'$D(^PS(52.41,$P(PSODATA,"^",10),0))
        S PSCMOPF=0 I $P($G(PSODATA),"^",11),$D(^PSDRUG("AQ",$P(PSODATA,"^",11))) S PSCMOPF=1
        S IEN=IEN+1,^TMP("PSOPF",$J,IEN,0)=$J(PSOCNT,2)_$S($L(PSOCNT)<3:" ",1:"")_$P(PSODRG,"^")
        I $P($G(^PS(52.41,+$P(PSODATA,"^",10),0)),"^",23)=1 S ^TMP("PSOPF",$J,IEN,"RV")=""
        S PSOLNT=$L($P(PSODRG,"^")),PSOLNTZ=$L($P(PSODATA,"^",8))
        S $P(PSOQTLX," ",(11-PSOLNTZ))=" "
        S:PSOLNT<37 $P(PSOQTL," ",(37-PSOLNT))=" "
        I PSOLNT<38 D  G PENX
        .I PSOLNT=37 S PSOQTL=""
        .I $P(^PS(52.41,$P(PSODATA,"^",10),0),"^",3)="RF" S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$G(PSOQTL)_"  Refill Request   Rx #: "_$P(^PSRX($P(^PS(52.41,$P(PSODATA,"^",10),0),"^",19),0),"^") Q
        .S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$G(PSOQTL)_"  "_"QTY: "_$P(PSODATA,"^",8)_$G(PSOQTLX)_" ISDT: "_$S('$P(PSODATA,"^",9):"     ",1:$E($P(PSODATA,"^",9),4,5)_"-"_$E($P(PSODATA,"^",9),6,7))_$S($G(PSCMOPF):"> ",1:"  ")
        .S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_"REF: "_$S($L($P(PSODATA,"^",6))>1:"",1:" ")_$P(PSODATA,"^",6)
        S IEN=IEN+1,$P(SPACEZ," ",42)=" "
        I $P(^PS(52.41,$P(PSODATA,"^",10),0),"^",3)="RF" S ^TMP("PSOPF",$J,IEN,0)=SPACEZ_"Refill Request   Rx #: "_$P(^PSRX($P(^PS(52.41,$P(PSODATA,"^",10),0),"^",19),0),"^") G PENX
        S ^TMP("PSOPF",$J,IEN,0)=SPACEZ_"QTY: "_$P(PSODATA,"^",8)_$G(PSOQTLX)_" ISDT: "_$S('$P(PSODATA,"^",9):"     ",1:$E($P(PSODATA,"^",9),4,5)_"-"_$E($P(PSODATA,"^",9),6,7))_$S($G(PSCMOPF):"> ",1:"  ")_"REF: "_$S($L($P(PSODATA,"^",6))>1:"",1:" ")
        S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$P(PSODATA,"^",6)
        G PENX
        ;
NVA     ; Setting the Non-VA Meds on the Medication Profile Screen (ListMan)
        S IEN=IEN+1,^TMP("PSOPF",$J,IEN,0)="  "_$P(PSODRG,"^")_" "
        I ($L(^TMP("PSOPF",$J,IEN,0))+$L($P(PSODATA,"^",6))>70) S IEN=IEN+1,^TMP("PSOPF",$J,IEN,0)="    "
        S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$P(PSODATA,"^",6)_" "
        I ($L(^TMP("PSOPF",$J,IEN,0))+$L($P(PSODATA,"^",8))>70) S IEN=IEN+1,^TMP("PSOPF",$J,IEN,0)="    "
        S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_$P(PSODATA,"^",8)
        I ($L(^TMP("PSOPF",$J,IEN,0))+20)>70 D  Q
        . S IEN=IEN+1,$P(^TMP("PSOPF",$J,IEN,0)," ",51)="Date Documented: "_$E($P(PSODATA,"^",9),4,5)_"/"_$E($P(PSODATA,"^",9),6,7)_"/"_$E($P(PSODATA,"^",9),2,3)
        F I=0:0 S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_" " Q:$L(^TMP("PSOPF",$J,IEN,0))>49
        S ^TMP("PSOPF",$J,IEN,0)=^TMP("PSOPF",$J,IEN,0)_"Date Documented: "_$E($P(PSODATA,"^",9),4,5)_"/"_$E($P(PSODATA,"^",9),6,7)_"/"_$E($P(PSODATA,"^",9),2,3)
        Q
