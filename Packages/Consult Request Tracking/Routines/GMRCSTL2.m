GMRCSTL2        ;SLC/DCM,dee;MA - List Manager Format Routine - Get Active Consults by service - pending,active,scheduled,incomplete,etc. ;4/18/01  10:31
        ;;3.0;CONSULT/REQUEST TRACKING;**7,21,22,63**;DEC 27, 1997;Build 10
        ; Patch #21 changed array GMRCTOT to ^TMP("GMRCTOT",$J)
        ; Patch #21 also added a plus sign to the $P when setting
        ; GMRCDLA to check for a NULL value.
        ; This routine invokes IA #10035,#44, #10040
        Q
        ;
ONESTAT(GMRCARRN)       ;Process one status
        ; Input -- GMRCARRN  List Template Array Name (Subscript)
        ;          Values:
        ;          "CP": pending consults; "IFC": inter-facility consults
        ; Output - None
        S ^TMP("GMRCTOT",$J,1,GMRCSVC,STATUS)=0
        S ^TMP("GMRCTOT",$J,2,GMRCSVC,STATUS)=0
        S GMRCXDT=$S(GMRCDT1="ALL":0,1:9999999-GMRCDT2-.6)
        F  S GMRCXDT=$O(^GMR(123,"AE",GMRCSVC,STATUS,GMRCXDT)) Q:GMRCXDT=""!(GMRCXDT>(9999999-GMRCDT1))  D
        .S GMRCPT=0
ONE     .;Loop for one consult at a time
        .F  S GMRCPT=$O(^GMR(123,"AE",GMRCSVC,STATUS,GMRCXDT,GMRCPT)) Q:GMRCPT=""  D
        ..; Check for bad "AE" x-ref
        ..I '$D(^GMR(123,GMRCPT,0)) D  Q
        ...K ^GMR(123,"AE",GMRCSVC,STATUS,GMRCXDT,GMRCPT)
        ..S X=9999999-GMRCXDT
        ..D REGDTM^GMRCU
        ..S GMRCDT=$P(X," ",1)
        ..S GMRCDLA=$P(X," ",1)
        ..S GMRCD(0)=^GMR(123,GMRCPT,0)
        ..I GMRCARRN="IFC" D  Q:'GMRCCK
        ...S GMRCCK=1
        ...S:'$D(GMRCIS) GMRCCK=0 S:'$P($G(GMRCD(0)),"^",23) GMRCCK=0
        ...I GMRCCK=1 D
        ....S GMRCD(12)=$G(^GMR(123,GMRCPT,12))
        ....I GMRCIS="R",$P(GMRCD(12),"^",5)'="P" S GMRCCK=0
        ....I GMRCIS="C",$P(GMRCD(12),"^",5)'="F" S GMRCCK=0
        ....I $D(GMRCREMP),$P(GMRCD(12),"^",6)'=GMRCREMP S GMRCCK=0
        ....I $D(GMRCRF),$P($G(GMRCD(0)),"^",23)'=GMRCRF S GMRCCK=0
        ..S GMRCPTN=$P(^DPT($P(GMRCD(0),"^",2),0),"^",1)
        ..S GMRCPTN=$P(GMRCPTN,",",1)_","_$E($P(GMRCPTN,",",2),1)_"."
        ..S GMRCPTSN="("_$E($P(^DPT($P(GMRCD(0),"^",2),0),"^",9),6,9)_")"
        ..; IF Consults
        ..I GMRCARRN="IFC" D
        ...N GMRCIRF,RCVDT,COMPLDT,ND
        ...S GMRCIRFN="NONE",GMRCIDD="N/A",GMRCRDT=""
        ...S GMRCIRF=$P($G(GMRCD(0)),"^",23)
        ... I GMRCIRF S GMRCIRFN=$E($$GET1^DIQ(4,GMRCIRF,.01),1,16)
        ...I '$D(^TMP("GMRCTOT",$J,1,GMRCSVC,"F",GMRCIRFN)) D
        ....S ^TMP("GMRCTOT",$J,1,GMRCSVC,"F",GMRCIRFN)=0
        ....S GMRCST(1,GMRCSVC,GMRCIRFN)="0^0"
        ...D GETDT^GMRCSTU(GMRCPT)
        ...I COMPLDT<9999999,$S(GMRCDT1="ALL":1,RCVDT'<GMRCDT1&(RCVDT'>GMRCDT2):1,1:0) D
        ....S X1=COMPLDT,X2=RCVDT D ^%DTC
        ....S GMRCIDD=X
        ...I GMRCIS="C" D
        ....S GMRCRDT=$$GETRDT(GMRCPT)
        ....I GMRCRDT]"" D
        .....N X
        .....S X=GMRCRDT D REGDT^GMRCU
        .....S GMRCRDT=X
        ..S GMRCD=0
        ..S GMRCD=$O(^GMR(123,GMRCPT,40,"B",GMRCD))
        ..I GMRCD]"" D
        ...S GMRCDA=""
        ...S GMRCDA=$O(^GMR(123,+GMRCPT,40,"B",GMRCD,GMRCDA))
        ..S GMRCDLA=$E($P($G(^GMR(123.1,+$P(GMRCD(0),"^",13),0)),"^"),1,19)
        ..S GMRCLOC=$P(GMRCD(0),"^",4)
        ..S:$L(GMRCLOC) GMRCLOC=$P($G(^SC(GMRCLOC,0)),"^",1) ;DBIA#10040
        ..I '$L(GMRCLOC),$P(GMRCD(0),U,21) D
        ...S GMRCLOC=$$GET1^DIQ(4,$P(GMRCD(0),U,21),.01)
        ..I '$L(GMRCLOC),$P(GMRCD(0),U,23) D
        ...S GMRCLOC=$$GET1^DIQ(4,$P(GMRCD(0),U,23),.01)
        ..I GMRCARRN="IFC",$L(GMRCLOC) D
        ...S GMRCLOC=$E(GMRCLOC,1,23)
        ..I ^TMP("GMRCTOT",$J,1,GMRCSVC,"T")=0 D
        ...S GMRCCT=GMRCCT+1
        ...S ^TMP("GMRCR",$J,GMRCARRN,GMRCCT,0)=CTRLTEMP
        ...S GMRCCT=GMRCCT+1
        ...S TEMP="SERVICE: "_GMRCSVCP
        ...S:GMRCSVCG>0 TEMP=TEMP_" in Group: "_$P(^GMR(123.5,GMRCSVCG,0),"^",1)
        ...S ^TMP("GMRCR",$J,GMRCARRN,GMRCCT,0)=CTRLTEMP_TEMP
        ...S NUMCLIN=NUMCLIN+1
        ..S LINETEMP=""
CTRL    ..I GMRCCTRL#100\10 D
        ...I GMRCCTRL#100\10=1 D
        ....S GMRCLINE=GMRCLINE+1
        ....S ^TMP("GMRCRINDEX",$J,GMRCLINE)=GMRCPT
        ....S LINETEMP=$J(GMRCLINE,4)_" "
        ...E  S LINETEMP=$J(GMRCPT,9)_" "
        ..I GMRCCTRL#2 S LINETEMP=GMRCPT_"^"_LINETEMP
        ..I GMRCCTRL#1000\100 D
        ...S STS=$$STATABBR^GMRCSTL1(STATUS)
        ...S STS=STS_$J("",4-$L(STS)+1)
        ..E  D
        ...S STS=$$STATNAME^GMRCSTL1(STATUS)
        ...S STS=STS_$J("",10-$L(STS)+1)
        ..S GMRCCT=GMRCCT+1
        ..S ^TMP("GMRCR",$J,GMRCARRN,GMRCCT,0)=LINETEMP_STS_GMRCDLA_$J("",20-$L(GMRCDLA))_GMRCDT_" "_GMRCPTN_" "_GMRCPTSN_$J("",12-$L(GMRCPTN)+5)_GMRCLOC
        ..; IF Consults
        ..I GMRCARRN="IFC" D
        ...S ^TMP("GMRCR",$J,GMRCARRN,GMRCCT,0)=^TMP("GMRCR",$J,GMRCARRN,GMRCCT,0)_$J("",25-$L(GMRCLOC))_GMRCIRFN_$J("",17-$L(GMRCIRFN))_" "_GMRCIDD_$J("",9-$L(GMRCIDD))_"  "_GMRCRDT
        ...I '$D(GMRCCNSLT(GMRCPT)) S ^TMP("GMRCTOT",$J,1,GMRCSVC,"F",GMRCIRFN)=^TMP("GMRCTOT",$J,1,GMRCSVC,"F",GMRCIRFN)+1,GMRCCNSLT(GMRCPT)=""
        ...I GMRCIDD'="N/A" D
        ....S $P(GMRCST(1,GMRCSVC,GMRCIRFN),"^")=$P(GMRCST(1,GMRCSVC,GMRCIRFN),"^")+GMRCIDD
        ....S $P(GMRCST(1,GMRCSVC,GMRCIRFN),"^",2)=$P(GMRCST(1,GMRCSVC,GMRCIRFN),"^",2)+1
        ....S $P(GMRCST(1,GMRCSVC),"^")=$P(GMRCST(1,GMRCSVC),"^")+GMRCIDD
        ....S $P(GMRCST(1,GMRCSVC),"^",2)=$P(GMRCST(1,GMRCSVC),"^",2)+1
        ..;
ADDTOT  ..;Add to totals
        ..;  for all status for this service
        ..S ^TMP("GMRCTOT",$J,1,GMRCSVC,"T")=^TMP("GMRCTOT",$J,1,GMRCSVC,"T")+1
        ..;  pending for this service
        ..S:",3,4,5,6,8,9,11,99,"[(","_STATUS_",") ^TMP("GMRCTOT",$J,1,GMRCSVC,"P")=^TMP("GMRCTOT",$J,1,GMRCSVC,"P")+1
        ..;  this status (STATUS) for this service
        ..S ^TMP("GMRCTOT",$J,1,GMRCSVC,STATUS)=^TMP("GMRCTOT",$J,1,GMRCSVC,STATUS)+1
        ..;  this status (STATUS) for services to all of its groupers
        F GRP=GROUPER:-1:1  D
        . I $D(^TMP("GMRCTOTX",$J,GROUPER(GRP),GMRCSVC,STATUS)) Q
        . S ^TMP("GMRCTOT",$J,2,GROUPER(GRP),STATUS)=$G(^TMP("GMRCTOT",$J,2,GROUPER(GRP),STATUS))+^TMP("GMRCTOT",$J,1,GMRCSVC,STATUS),^TMP("GMRCTOTX",$J,GROUPER(GRP),GMRCSVC,STATUS)=""
        Q
        ;
GETRDT(GMRCPT)  ;get the received date
        ; Input:
        ;  GMRCPT  = File #123 IEN
        ; Output:
        ;  GMRCRDT = Date of action entry for remote request received/received
        N GMRCCKR,GMRCRDT,ND
        S (GMRCCKR,ND)=0,GMRCRDT=""
        F  S ND=$O(^GMR(123,GMRCPT,40,ND)) Q:ND'>0!GMRCCKR  D
        .I $P(^GMR(123,GMRCPT,40,ND,0),"^",2)=23 D
        ..S GMRCRDT=$P(^GMR(123,GMRCPT,40,ND,0),"^"),GMRCCKR=1
        .I $P(^GMR(123,GMRCPT,40,ND,0),"^",2)=21 D
        ..S GMRCRDT=$P(^GMR(123,GMRCPT,40,ND,0),"^")
        Q GMRCRDT
