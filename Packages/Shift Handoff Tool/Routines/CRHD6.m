CRHD6   ; CAIRO/CLC - MISC ROUTINE FOR CAIRO HAND-OFF TOOL ;04-Mar-2008 16:00;CLC
        ;;1.0;CRHD;****;Jan 28, 2008;Build 19
        ;=================================================================
GETP(CRHDRTN,CRHDE)     ;
        N CRHDPAR,Y,CRHDX,CRHDCT,CRHDMN,CRHDP,CRHDE1,CRHDE2,CRHDE3,CRHDE4
        N CRHDX2,CRHDRSL,CRHDL,CRHDXCT,CRHDTRSL,CRHDEX,CRHDEE,CRHDXY
        S Y=-1
        S CRHDE1=+CRHDE                          ;internal entry number to file
        S CRHDE2=$P(CRHDE,"^",2)                 ;name
        S CRHDE3=$P(CRHDE,"^",3)                 ;types
        ;                                         USR - New Person
        ;                                         OTL - OE/RR Team
        ;                                         SRV - Service/Section
        ;                                         DIV-Institution;
        ;
        S CRHDCT=0
        S CRHDL=$L(CRHDE,"^")
        S CRHDE4="DIV.`"_$P($P(CRHDE,"^",CRHDL),"-",2)                  ;User Sign in Division
        I $P(CRHDE4,"`",2)="" D USERDIV^CRHD5(.CRHDEE,DUZ) S CRHDE4="DIV.`"_$G(CRHDEE(1))
        S CRHDE3=$P($P(CRHDE,"^",CRHDL),"-",1)
        S CRHDPAR=CRHDE3_".`"_CRHDE1
        I CRHDPAR'="" D LOOKUP^XPAREDIT(CRHDPAR,183)
        I Y>-1 D
        .S CRHDMN=+Y
        .S CRHDP=0
        .F  S CRHDP=$O(^CRHD(183,CRHDMN,1,CRHDP)) Q:'CRHDP  D
        ..S CRHDCT=CRHDCT+1
        ..I $P($G(^CRHD(183,CRHDMN,1,CRHDP,0)),"^",2)="" D
        ...S CRHDX2=0 F  S CRHDX2=$O(^CRHD(183,CRHDMN,1,CRHDP,1,CRHDX2)) Q:'CRHDX2  D
        ....S CRHDRTN(CRHDCT)=$P($G(^CRHD(183,CRHDMN,1,CRHDP,0)),"^",1)_"^"_$G(^CRHD(183,CRHDMN,1,CRHDP,1,CRHDX2,0))
        ....S CRHDCT=CRHDCT+1
        ..E  S CRHDRTN(CRHDCT)=$G(^CRHD(183,CRHDMN,1,CRHDP,0))
        ;get Temp fields expiration days
        S CRHDEX=$$GET^XPAR(CRHDE4,"CRHD TEMP FLD EXPIRE",1,"I")
        I 'CRHDEX S CRHDEX=2
        S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)="TEMP_FLD_EXPIRE"_"^"_CRHDEX
        ;get dnr title and/or text
        K CRHDRSL D DNRPARM^CRHDDR(.CRHDRSL,DUZ,$P($P(CRHDE,"^",CRHDL),"-",2)) D
        .I $D(CRHDRSL) D
        ..S (CRHDXCT,CRHDXY)=0 F  S CRHDXY=$O(CRHDRSL(CRHDXY)) Q:'CRHDXY  D
        ...S CRHDXCT=CRHDXCT+1,CRHDTRSL(CRHDXCT)=CRHDXY_"^"_$P($G(^ORD(101.43,+CRHDXY,0)),"^",1)
        .I $D(CRHDTRSL) K CRHDRSL M CRHDRSL=CRHDTRSL K CRHDTRSL
        I $D(CRHDRSL) D RTNLST("DNR_Titles") K CRHDRSL
        D GET^CRHD5(.CRHDRSL,CRHDE4,"CRHD DNR ORDER TITLE")
        I $D(CRHDRSL) D RTNLST("DNR_Text")
        Q
RTNLST(CRHDTT)  ;
        I $D(CRHDRSL) D
        .S CRHDX=0
        .I CRHDTT["DNR_Titles" F  S CRHDX=$O(CRHDRSL(CRHDX)) Q:'CRHDX  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDTT_"^"_CRHDRSL(CRHDX)
        .E  F  S CRHDX=$O(CRHDRSL(CRHDX)) Q:'CRHDX  S CRHDCT=CRHDCT+1,CRHDRTN(CRHDCT)=CRHDTT_"^"_$P(CRHDRSL(CRHDX),"^",2)
        Q
        ;
SAVEP(CRHDRTN,CRHDE,CRHDPN,CRHDV,CRHDVAL)       ;
        N CRHDENT,CRHDX,CRHDX1,CRHDOLST,CRHDFG,CRHDL
        S CRHDRTN(0)=1
        I CRHDE="" S CRHDRTN(0)=0_"^Entity data not valid" Q
        S CRHDL=$L(CRHDE,"^")
        I +CRHDE S CRHDENT=$P($P(CRHDE,"^",CRHDL),"-",1)_".`"_+CRHDE
        I CRHDPN="" S CRHDPN="CRHD DNR ORDER TITLE"
        ;get all Instances of a Parameter
        D GETLST^XPAR(.CRHDOLST,CRHDENT,CRHDPN,"I")
        I $D(CRHDOLST) S CRHDFG=$$DELALL^CRHD5(CRHDENT,CRHDPN)
        I $D(CRHDVAL) D
        .S CRHDX=0,CRHDCT=0
        .F  S CRHDX=$O(CRHDVAL(CRHDX)) Q:'CRHDX  D
        ..S CRHDCT=CRHDCT+1
        ..D SET^CRHD5(CRHDENT,CRHDPN,CRHDCT,CRHDVAL(CRHDX))
        Q
SAVEP2(CRHDRTN,CRHDE,CRHDPN,CRHDV,CRHDVAL)      ;
        N CRHDENT,CRHDX,CRHDX1,CRHDOLST,CRHDFG,CRHDL
        S CRHDRTN(0)=1
        I CRHDE="" S CRHDRTN(0)=0_"^Entity data not valid" Q
        S CRHDL=$L(CRHDE,"^")
        I +CRHDE S CRHDENT=$P($P(CRHDE,"^",CRHDL),"-",1)_".`"_+CRHDE
        I CRHDPN="" S CRHDRTN(0)=0_"^Parameter name not valid" Q     ;S PN="CRHD DNR ORDER TITLE"
        I CRHDV=""&('$D(CRHDVAL)) S CRHDFG=$$DELALL^CRHD5(CRHDENT,CRHDPN) S CRHDRTN(0)=1 Q
        ;get all Instances of a Parameter
        D GETLST^XPAR(.CRHDOLST,CRHDENT,CRHDPN,"I")
        I $G(CRHDOLST) S CRHDFG=$$DELALL^CRHD5(CRHDENT,CRHDPN) K CRHDOLST
        I $D(CRHDVAL) D
        .S CRHDX=0,CRHDCT=0
        .F  S CRHDX=$O(CRHDVAL(CRHDX)) Q:'CRHDX  D
        ..S CRHDCT=CRHDCT+1
        ..I CRHDVAL(CRHDX)'="" D
        ...I CRHDVAL(CRHDX)?1N.E S CRHDVAL(CRHDX)=+CRHDVAL(CRHDX)
        ...I CRHDVAL(CRHDX)?1A.E S CRHDVAL(CRHDX)=$P(CRHDVAL(CRHDX),"^",1)
        ..D SET^CRHD5(CRHDENT,CRHDPN,CRHDCT,CRHDVAL(CRHDX))
        Q
GETPAR2(CRHDRTN,CRHDE,CRHDPN)   ;
        ;Get XPAR parameter values
        N CRHDENT,CRHDX,CRHDX1,CRHDL,CRHDOLST,CRHDPNUM,CRHDFMT,CRHDFG
        N CRHDI
        S CRHDRTN(0)=1
        S CRHDFMT="I"
        I CRHDE="" S CRHDRTN(0)=0_"^Entity data not valid" Q
        S CRHDL=$L(CRHDE,"^")
        I +CRHDE S CRHDENT=$P($P(CRHDE,"^",CRHDL),"-",1)_".`"_+CRHDE
        I CRHDPN="" S CRHDRTN(0)=0_"^Parameter name not valid" Q     ;S PN="CRHD DNR ORDER TITLE"
        ;get format code
        S CRHDPNUM=$O(^XTV(8989.51,"B",CRHDPN,0))
        I CRHDPNUM D
        .S CRHDFMT=$S(($P($G(^XTV(8989.51,CRHDPNUM,1)),"^",1)="F")!($P($G(^XTV(8989.51,CRHDPNUM,1)),"^",6)="F"):"E",1:"B")
        ;get all Instances of a Parameter
        D GETLST^XPAR(.CRHDOLST,CRHDENT,CRHDPN,CRHDFMT)
        I CRHDFMT="B" D
        .K CRHDRTN
        .S CRHDI=0
        .F  S CRHDI=$O(CRHDOLST(CRHDI)) Q:'CRHDI  S:$G(CRHDOLST(CRHDI,"V"))'="" CRHDRTN(CRHDI)=$G(CRHDOLST(CRHDI,"V"))
        E  K CRHDRTN D
        .S CRHDI=0
        .F  S CRHDI=$O(CRHDOLST(CRHDI)) Q:'CRHDI  S CRHDRTN(CRHDI)=$P(CRHDOLST(CRHDI),"^",2)
        Q
