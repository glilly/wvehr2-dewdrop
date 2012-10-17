XQSUITE ;Luke/Sea - Window Suite driver ;2/14/95  10:32
        ;;8.0;KERNEL;;Jul 10, 1995;Build 15
        ;Modified from FOIA VISTA,
        ;Copyright 2008 WorldVistA.  Licensed under the terms of the GNU
        ;General Public License See attached copy of the License.
        ;
        ;This program is free software; you can redistribute it and/or modify
        ;it under the terms of the GNU General Public License as published by
        ;the Free Software Foundation; either version 2 of the License, or
        ;(at your option) any later version.
        ;
        ;This program is distributed in the hope that it will be useful,
        ;but WITHOUT ANY WARRANTY; without even the implied warranty of
        ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ;GNU General Public License for more details.
        ;
        ;You should have received a copy of the GNU General Public License along
        ;with this program; if not, write to the Free Software Foundation, Inc.,
        ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
        ;
        ;Jump-start XQSUITE by asking which suite to run
        S DIC=19,DIC(0)="AEQM" D ^DIC Q:Y<0  S (XQDIC,XQY)=+Y K DIC,XQUR,Y,^VA(200,DUZ,202.1)
        I $P(^DIC(19,XQY,0),U,4)'="Z" W !!,"Sorry, '",$P(^(0),U,2),"' is not a suite of windows." K XQY,XQDIC Q
        ;
        ;Enter with XQY=the IEN of the suite
        ;
EN      ;Entry point for ^XQ1
        S KWAPI=1
        S U="^"
        S XQWIN=$$NEXTNM^XGCLOAD("XQS")
        D ^XQDATE
        S ^XUTL("XQSUITE",$J,XQWIN,0)=%_U_%Y
        D PREP^XG
        S XQKWAPI=0 I XGWIN'["^$W" S XQKWAPI=1
        D GET^XGCLOAD("XQSUITE",$NA(^TMP($J,XQWIN)))
        I $L($P(^DIC(19,+XQY,0),U,2)) S ^TMP($J,XQWIN,"TITLE")=$P(^DIC(19,XQY,0),U,2)
        ;S XQPOP=$$NEXTNM^XGCLOAD("XQP")
        D GET^XGCLOAD("XQPOP",$NA(^TMP($J,"XQPOP")))
        ;
        S XQN=1000,XQJ=0 F XQI=1:1:$P(^DIC(19,XQY,10,0),U,4) D
        .S XQJ=$O(^DIC(19,XQY,10,XQJ))
        .Q:XQJ'=+XQJ
        .S XQJY=^DIC(19,XQY,10,XQJ,0)
        .I $L(XQJY,U)<3 F  S XQJY=XQJY_U Q:$L(XQJY,U)=3
        .S XQK=$P(XQJY,U,3) I XQK'>0 S XQK=XQN,XQN=XQN+1 ;Display order
        .S ^XUTL(XQWIN,$J,XQY,+XQJY)=^DIC(19,+XQJY,0)
        .S ^XUTL(XQWIN,$J,XQY,+XQJY,"W")=^DIC(19,+XQJY,"W")
        .S XQM(XQK)=XQJY_U_^XUTL(XQWIN,$J,XQY,+XQJY,"W")
        .Q
        K XQI,XQJ,XQJYM,XQK
        ;
ICONS   ;Build the generic (icon) windows for each option    
        S XQK=0,XQGB1="XQB1",XQGB2="XQB2",XQGL1="XQL1",XQGL2="XQL2",XQII="XQSI"
        S XQP1=30,XQP2=",334",XQIP1=30,XQIP2=20
        S XQPTH=$G(^XTV(8989.3,101)),XQNB=0,XQNI=0,XQLONG=0
        ;
        S ^TMP($J,XQWIN,"FFACE")="Courier New"
        S ^TMP($J,XQWIN,"NEXTG")="XQSI"_$O(XQM(0))
        F XQI=1:1 Q:XQK=""  D
        .S XQK=$O(XQM(XQK)) Q:XQK=""
        .S XQKY=+XQM(XQK)
        .S XQSIN=XQII_XQK
        .S XQB1=XQGB1_XQK,XQB2=XQGB2_XQK
        .S XQL1=XQGL1_XQK,XQL2=XQGL2_XQK
        .;
MAKE    .D
        ..S XQNI=XQNI+1
        ..S XQIP1=((XQNI*120)-120)+32
        ..S ^TMP($J,XQWIN,"G",XQSIN,"POS")=XQIP1_","_XQIP2
        ..S ^TMP($J,XQWIN,"G",XQSIN,"SIZE")="32,32"
        ..S ^TMP($J,XQWIN,"G",XQSIN,"TYPE")=$S(XQKWAPI:"BUTTON",1:"GENERIC")
        ..I $O(XQM(XQK))'="" S ^TMP($J,XQWIN,"G",XQSIN,"NEXTG")="XQSI"_$O(XQM(XQK))
        ..E  S ^TMP($J,XQWIN,"G",XQSIN,"NEXTG")="XQSI"_$O(XQM(0))
        ..I 'XQKWAPI D
        ...S XQICP=$P(XQM(XQK),U,4)
        ...S XQICP=$S(XQICP["\":XQICP,XQICP["[":XQICP,XQICP="":"",1:XQPTH_XQICP)
        ...I $L(XQICP) S ^TMP($J,XQWIN,"G",XQSIN,"DRAW",1)="BITMAP,0,0,F,"_XQICP
        ...E  S ^TMP($J,XQWIN,"G",XQSIN,"BCOLOR")="400,800,51110"
        ...Q
        ..S ^TMP($J,XQWIN,"G",XQSIN,"EVENT",$S(XQKWAPI:"SELECT",1:"DBLCLICK"))="SEL^XQSUITE"
        ..S ^TMP($J,XQWIN,"G",XQSIN,"EVENT","FOCUS")="FOCUS^XQSUITE"
        ..;
        ..S XQTXT=$P(XQM(XQK),U,5) I '$L(XQTXT) S XQTXT="No Title"
        ..S XQTL=$L(XQTXT)
        ..I XQTL>12 S XQLONG=1,X=XQTXT D SPLIT^XQSUITE1 S XQTXT=Y1,XQTL=$L(XQTXT)
        ..;S ^TMP($J,XQWIN,"G",XQB1,"TYPE")="GENERIC"
L1      ..S ^TMP($J,XQWIN,"G",XQL1,"TYPE")="LABEL"
        ..S ^TMP($J,XQWIN,"G",XQL1,"BCOLOR")="65535,65535,65535"
        ..S ^TMP($J,XQWIN,"G",XQL1,"SIZE")=XQTL*8_",16"
        ..S P1=XQIP1-(((XQTL*8)-36)\2),P2=XQIP2+32
        ..S ^TMP($J,XQWIN,"G",XQL1,"POS")=P1_","_P2
        ..S ^TMP($J,XQWIN,"G",XQL1,"TFFACE")="Courier New"
        ..S ^TMP($J,XQWIN,"G",XQL1,"TFSIZE")=10
        ..;S ^TMP($J,XQWIN,"G",XQL1,"DRAW",1)="DRAWTEXT,0,0,"_XQTXT
        ..S ^TMP($J,XQWIN,"G",XQL1,"TITLE")=XQTXT
L2      ..I XQLONG S XQTXT=Y2,XQTL=$L(XQTXT),XQLONG=0 D
        ...S ^TMP($J,XQWIN,"G",XQL2,"TYPE")="LABEL"
        ...S ^TMP($J,XQWIN,"G",XQL2,"BCOLOR")="65535,65535,65535"
        ...S ^TMP($J,XQWIN,"G",XQL2,"SIZE")=XQTL*8_",16"
        ...S P1=XQIP1-(((XQTL*8)-36)\2),P2=XQIP2+32+16
        ...S ^TMP($J,XQWIN,"G",XQL2,"POS")=P1_","_P2
        ...S ^TMP($J,XQWIN,"G",XQL2,"TFFACE")="Courier New"
        ...S ^TMP($J,XQWIN,"G",XQL2,"TFSIZE")=10
        ...;S ^TMP($J,XQWIN,"G",XQL2,"DRAW",1)="DRAWTEXT,0,0,"_XQTXT
        ...S ^TMP($J,XQWIN,"G",XQL2,"TITLE")=XQTXT
        ...Q
        ..Q
        .Q
KILL    K X,XQB1,XQB2,XQGB1,XQGB2,XQGL1,XQGL2,XQI,XQICP,XQII,XQIP1,XQIP2,XQJ,XQJY,XQK,XQKY,XQL1,XQL2,XQLONG,XQNB,XQNI,XQP,XQP1,XQP2,XQPTH,XQTL,XQTXT,XQSUIB,XQSUIIN
        ;
        D M^XG(XQWIN,$NA(^TMP($J,XQWIN)))
        ;
        ;Start up the XQSUI window
        ;
        D ESTA^XG()
        ;
        ;Return here after suite exits
        ;
        D K^XG(XQWIN)
        ;
OUT     ;Finish it all up here     
        K ^XUTL(XQWIN,$J,XQY)
        K ^TMP($J,XQWIN),^TMP($J,"XQP")
        ;D CLEAN^XG
        K %,%Y,XQWIN
        Q
        ;
SEL     ;One of the icons was double-clicked 
        ;N XQY,XQWIN
        S XQI=@XGEVENT@("WINDOW")
        S XQJ=@XGEVENT@("ELEMENT")
        S XQK=$P(XQJ,",",2)
        S XQY=+XQM($E(XQK,5,99))
        ;W !,XQI,"  ",XQJ,"  ",XQY
        ;
        S XQOK=1
        I $D(^DIC(19,XQY,25)),$L(^(25)) D  G OUT ;Routine type
        .S XQSUI=^DIC(19,XQY,25)
        .S:XQSUI'[U XQSUI=U_XQSUI
        .I XQSUI["[" D DO^%XUCI Q
        .;W !,"ROUTINE=",XQSUI
        .D @XQSUI
        .Q
        ;
        I $D(^DIC(19,XQY,24)),$L(^(24)) D  G:XQOK OUT ;Pointer type
        .;W !,"We have a pointer!"
        .S XQSUI=^DIC(19,XQY,24)
        .S XQSUI=$P($G(^XTV(8995,XQSUI,0)),U) I XQSUI="" S XQOK=0 Q
        .;W !,XQSUI
        .S XQWIN=$$NEXTNM^XGCLOAD("XQSUI")
        .D GET^XGCLOAD(XQSUI,$NA(^TMP($J,XQWIN)))
        .D M^XG(XQWIN,$NA(^TMP($J,XQWIN)))
        .D SD^XG($P,"FOCUS",XQWIN)
        .;D ESTA^XG() ;Send it off to window land
        .; 
        .;D K^XG(XQWIN) ;Return here after the ESTOP
        .Q
        Q
        ;
CLOSE   ;Close the XQSUITE window and do an ESTOP
        S XQWIN=@XGEVENT@("WINDOW")
        K XQM
        D ESTO^XG
        Q
        ;
HLP     ;Help Callback for XQHLPMEN menu
        S XQMESS="Sorry, I'm still writing the help messages.",XQTITLE="Help!"
        D POP^XQGP(XQMESS,XQTITLE)
        K XQMESS,XQTITLE
        Q
        ;
MAIL    ;Hook into Mail
        S XQMESS="Windowed MAIL is not available yet.",XQTITLE="Sorry!"
        D POP^XQGP(XQMESS,XQTITLE)
        K XQMESS,XQTITLE
        Q
        ;
ALERT   ;Hook into ALERT system
        S XQMESS="Alerts are not yet available in windows."
        S XQTITLE="Very Sorry!"
        D POP^XQGP(XQMESS,XQTITLE)
        K XQMESS,XQTITLE
        Q
        ;
FOCUS   ;Show Menu Text of button with FOCUS in XQSUIHTXT gadget
        ;N XQY,XQWIN
        S XQWIN=@XGEVENT@("WINDOW")
        S XQJ=@XGEVENT@("ELEMENT")
        S XQK=$P(XQJ,",",2)
        S XQN=$E(XQK,5,99)
        S XQY=+XQM(XQN)
        ;W !,XQWIN,"  ",XQY,"  ",XQJ,"  ",XQK
        ;
        S @XGWIN@(XQWIN,"G","XQSHTXT","TITLE")=$P(^DIC(19,XQY,0),U,2)
        K XQJ,XQK,XQN
        Q
