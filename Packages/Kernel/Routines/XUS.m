XUS     ;SFISC/STAFF - SIGNON ;8:23 AM  23 Apr 2011
        ;;8.0;KERNEL;**16,26,49,59,149,180,265,337,419,434,437**;Jul 10, 1995;Build 6
        ; Modified from FOIA VISTA,
        ; Copyright (C) 2007 WorldVistA
        ;
        ; This program is free software; you can redistribute it and/or modify
        ; it under the terms of the GNU General Public License as published by
        ; the Free Software Foundation; either version 2 of the License, or
        ; (at your option) any later version.
        ;
        ; This program is distributed in the hope that it will be useful,
        ; but WITHOUT ANY WARRANTY; without even the implied warranty of
        ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        ; GNU General Public License for more details.
        ;
        ; You should have received a copy of the GNU General Public License
        ; along with this program; if not, write to the Free Software
        ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301
        ;
        ;Sign-on message numbers are 30810.51 to 30810.99
        S U="^" D DT^DICRW D INTRO^XUS1A()
        K  K ^XUTL("ZISPARAM",$I)
        S U="^",XQXFLG("GUI")="^"
        W ! S $Y=0 D SET1(1) I POP S XUM=3 G NO ;Sets DUZ("LANG")
        S XUSTMP(51)=$$EZBLD^DIALOG(30810.51),XUSTMP(52)=$$EZBLD^DIALOG(30810.52)
        W !!,"Volume set: ",$P(XUENV,U,4),"  UCI: ",XUCI,"  Device: ",$I W:$S('$D(IO("ZIO")):0,1:$I'=IO("ZIO")) " (",IO("ZIO"),")" W !
RESTART ;
        S XUM=$$SET2 G:XUM NO
        I $P(XU1,U,2)]"" S XUM=$$DEVPAS() I XUM G H:XUM<0,NO
        ;S PGM=$P(XOPT,U,8),XUA=$P(PGM,"[",1) I XUA]"" X XUEON G NEXT^XUS1
A       S (XUSER(0),XUSER(1),XQUR)=""
        ;Check for locked IP/device.
        I $$LKCHECK^XUSTZIP() S XUM=7,XUFAC=$P(XOPT,U,2),XUHALT=1 G NO
        ;Auto Sign-on check
        S X=$$AUTOXUS^XUS1B() I X>0 S DUZ=X D USER(DUZ) W !!,">> Auto Sign-on: ",$P(XUSER(0),U)," <<<",! G B
        X XUEOFF S AV=$$ASKAV() X XUEON I AV="^;^" G H ;Get out
        I AV["MAIL-BOX",AV[";XMR" S (XUA,PGM)="XMR",XMCHAN=$P($P(AV,";")," ",2),DUZ=.5 G XMR^XUSCLEAN
        S XQUR=$P(AV,";",3)
        S DUZ=$$CHECKAV(AV) K AV
        S XUM=$$UVALID() G:XUM NO
B       K XUF,%1 S XUF=0 X XUEON
        I DUZ D USER^XUS1 G:XUM NO
        I DUZ D SEC^XUS3:($D(^%ZIS(1,XUDEV,"TIME"))!$D(^(95))) G:XUM NO
        G NO:'DUZ
        S DTIME=$P(XOPT,U,10),X=$S(DUZ("BUF"):"",1:"NO-")_"TYPE-AHEAD" X:$D(^%ZOSF(X)) ^(X)
        D TT^XUS3:$G(XUTT)
        D CLRFAC^XUS3($G(IO("IP")))
PGM     ;
        S Y=+$G(^%ZIS(1,XUDEV,201)) I Y>0,$$CHK S XQY=Y G OK
        S Y=+$G(^VA(200,DUZ,201)) I Y>0,$$CHK S XQY=Y G OK
        I $D(DUZ("ASH")) S Y=$O(^DIC(19,"B","XU NOP MENU",0)) I Y>0 S XQY=Y G OK ;rwf 403
        S XUM=16
        G NO
        ;
OK      D CHEK^XQ83
        S (XUA,PGM)="XQ"
        G NEXT^XUS1
        ;
CHK()   ;Check that option exeist and LOCK
        I $D(^DIC(19,Y,0)),$S($P(^(0),U,6)="":1,1:$D(^XUSEC($P(^(0),U,6),DUZ))) Q 1
        Q 0
        ;
LC      S X=$$UP(X)
        Q
UP(%)   Q $TR(%,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        ;
FAC     ;Failed access
        S:'DUZ XUF(.1)=$E(%1)
        S:XUF=2 XUF(.2)=XUF(.2)+1,XUF(XUF(.2))=%1 S %1="" Q
        Q
NO      ;Tell why didn't get on
        S X=$$NO^XUS3() G RESTART:'X ;fall into exit
H       ;Exit point for all applications
C       ;CLOSE
        G ^XUSCLEAN
        ;
ON      X ^%ZOSF("EON") Q
        ;
ASKAV(PRE)      ;Ask and return Access;Verify code, Turn off echo before calling
        N X,Y S PRE=$G(PRE)
        F  W !,PRE,XUSTMP(51) S X=$$ACCEPT S:X="^" X="^;^" Q:$L(X)
        S X=$TR(X,$C(9),";") ;Convert TAB to ; to match GUI.
        I $P(X," ")="MAIL-BOX" S X=X_";XMR"
        I $E(X,1,7)="~~TOK~~" Q X ;Use CCOW token
        I '$L($P(X,";",2)) W !,PRE,XUSTMP(52) S Y=$$ACCEPT S:Y="^" X="^;" S $P(X,";",2)=Y
        Q X
        ;
        ;Timeout used by XUSTZ call.
ACCEPT(TO)      ;Read A/V and echo '*' char.
        ;Have the Read write to flush the buffer on some systems
        N C,A,E K DUOUT S A="",TO=$G(TO,60),E=0
        F  D  Q:E
        . R "",*C:TO S:('$T) DUOUT=1 S:('$T)!(C=94) A="^"
        . I (A="^")!(C=13)!($L(A)>60) S E=1 Q
        . I C=127 Q:'$L(A)  S A=$E(A,1,$L(A)-1) W $C(8,32,8) Q
        . S A=A_$C(C) W *42
        . Q
        Q A
        ;
CHECKAV(X1)     ;Check A/V code return DUZ or Zero. (Called from XUSRB)
        N %,%1,X,Y,IEN,DA,DIK
        S IEN=0
        ;Start CCOW
        I $E(X1,1,7)="~~TOK~~" D  Q:IEN>0 IEN
        . I $E(X1,8,9)="~1" S IEN=$$CHKASH^XUSRB4($E(X1,8,255))
        . I $E(X1,8,9)="~2" S IEN=$$CHKCCOW^XUSRB4($E(X1,8,255))
        . Q
        ;End CCOW
        ; WV p437 ;Allow case sensitivefor VOE
        S X1=$S($$GET^XPAR("SYS","XU VC CASE SENSITIVE"):$$UP($P(X1,";",1))_";"_$P(X1,";",2),1:$$UP(X1))
        ; End WV change
        S X1=$$UP(X1) S:X1[":" XUTT=1,X1=$TR(X1,":")
        S X=$P(X1,";") Q:X="^" -1 S:XUF %1="Access: "_X
        Q:X'?1.20ANP 0
        S X=$$EN^XUSHSH(X) I '$D(^VA(200,"A",X)) D LBAV Q 0
        S %1="",IEN=$O(^VA(200,"A",X,0)),XUF(.3)=IEN D USER(IEN)
        S X=$P(X1,";",2) S:XUF %1="Verify: "_X S X=$$EN^XUSHSH(X)
        I $P(XUSER(1),"^",2)'=X D LBAV Q 0
        I $G(XUFAC(1)) S DIK="^XUSEC(4,",DA=XUFAC(1) D ^DIK
        Q IEN
LBAV    ;Log Bad AV
        D:XUF FAC
        I IEN S X=$P($G(^VA(200,IEN,1.1)),U,2)+1,$P(^(1.1),"^",2)=X
        Q
        ;
USER(IX)        ;Build XUSER
        S XUSER(0)=$G(^VA(200,+IX,0)),XUSER(1)=$G(^(.1)),XUSER(1.1)=$G(^(1.1))
        Q
        ;
XUVOL   ;Setup XUENV, XUCI,XQVOL,XUVOL
        S U="^" D GETENV^%ZOSV S XUENV=Y,XUCI=$P(Y,U,1),XQVOL=$P(Y,U,2)
        S X=$O(^XTV(8989.3,1,4,"B",XQVOL,0)),XUVOL=$S(X>0:^XTV(8989.3,1,4,X,0),1:XQVOL_"^y^1")
        Q
        ;
XOPT    ;Setup initial XOPT
        S XOPT=$S($D(^XTV(8989.3,1,"XUS")):^("XUS"),1:"")
        F I=2:1:15 I $P(XOPT,U,I)="" S $P(XOPT,U,I)=$P("^5^900^1^1^^^^1^300^^^^N^90",U,I)
        Q
        ;
SET1(FLAG)      ;Setup parameters (also called from XUSRB)
        N %
        S U="^",XUEON=^%ZOSF("EON"),XUEOFF=^("EOFF")
        D XUVOL,XOPT S DUZ("LANG")=$P(XOPT,U,7) ;S:$P(XUVOL,U,6)="y" XRTL=XUCI_","_XQVOL
        K ^XUTL("XQ",$J) S XUF=0,XUDEV=0,DUZ=0,DUZ(0)="@",IOS=0,ION=""
        I FLAG S %ZIS="L",IOP="HOME" D ^%ZIS Q:POP
        S XUDEV=IOS,XUIOP=ION
        D GETFAC^XUS3($G(IO("IP")))
        S %=$P(XOPT,U,14)
        I "N"'[% D
        . S XUF=(%["R")+1,XUF(.1)="",XUF(.2)=0,XUF(.3)=0
        . I %["D" S:$D(^XTV(8989.3,1,4.33,"B",XUDEV))[0 XUF=0
        S DILOCKTM=+$G(^DD("DILOCKTM"),1) ;p434 IA#4909
        Q
SET2()  ;EF. Return error code (also called from XUSRB)
        N %,X
        S XUNOW=$$HTFM^XLFDT($H),DT=$P(XUNOW,".")
        K DUZ,XUSER
        S (DUZ,DUZ(2))=0,(DUZ(0),DUZ("AG"),XUSER(0),XUSER(1),XUTT,%UCI)=""
        S %=$$INHIBIT^XUSRB() I %>0 Q %
        S X=$G(^%ZIS(1,XUDEV,"XUS")),XU1=$G(^(1))
        I $L(X) F I=1:1:15 I $L($P(X,U,I)) S $P(XOPT,U,I)=$P(X,U,I)
        S DTIME=600
        I '$P(XOPT,U,11),$D(^%ZIS(1,XUDEV,90)),^(90)>2800000,^(90)'>DT Q 8
        Q 0
        ;
UVALID()        ;EF. Is it valid for this user to sign on?
        I DUZ'>0 Q 4
        I $P(XUSER(1.1),U,5),$P(XUSER(1.1),U,5)>XUNOW S XUM(0)=$$FMTE^XLFDT($P(XUSER(1.1),U,5),"2PM") Q 18 ;User locked until
        I $P(XUSER(0),U,11),$P(XUSER(0),U,11)'>DT Q 11 ;Access Terminated
        I $D(DUZ("ASH")) Q 0 ;If auto handle, Allow to sign-on p434
        I $P(XUSER(0),U,7) Q 5 ;Disuser flag set
        I '$L($P(XUSER(1),U,2)) Q 21 ;p419, p434
        Q 0
        ;
DEVPAS()        ;EF. Ask device password
        X XUEOFF W !,"DEVICE PASSWORD: " R X:60 X XUEON
        S X=$E(X,1,30) S:'$T X="^" D LC Q:X["^" -1 I $P(XU1,U,2)'=X S:XUF %1="Device: "_X D:XUF FAC Q 6
        Q 0
        ;
