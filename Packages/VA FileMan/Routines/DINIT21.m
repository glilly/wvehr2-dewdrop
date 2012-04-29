DINIT21 ;SFISC/GFT-INITIALIZE VA FILEMAN 14AUG2009;1:58 PM  21 Aug 2010
        ;;22.0;VA FileMan;**110,160,1035**;Mar 30, 1999;Build 8
        ;
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
DINITOSX        G DD:'$O(^DD("OS",0)) W !!,"Do you want to change the MUMPS OPERATING SYSTEM File? NO//" R Y:60 Q:Y["^"!("Nn"[$E(Y))!('$T)
        I "Yy"'[$E(Y) W !,"Answer YES to overwrite ROUTINE SAVE logic & MAXIMUM ROUTINE SIZE" G DINITOSX
        S DINITOSX=1 ;for DINIT6
DD      F I=1:1 S X=$T(DD+I),Y=$P(X," ",3,99) Q:X?.P  S D="^DD(""OS"","_$E($P(X," ",2),3,99)_")" S @D=Y
        ;;0 MUMPS OPERATING SYSTEM^.7
        ;;8,0 MSM^^127^5000^^1^63
        ;;8,1 B X
        ;;8,"SDP" O @("DIO:"_DLP) F %=0:0 U DIO R % Q:$ZA=X&($ZB>Y)!($ZA>X)  U IO W:$A(%)'=12 ! W %
        ;;8,"SDPEND" S X=$ZA,Y=$ZB
        ;;8,"XY" S $X=IOX,$Y=IOY
        ;;8,8 X ^DD("$O")
        ;;8,18 I $D(^ (X))
        ;;8,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
        ;;9,0 DTM-PC^^127^5000^^1^115
        ;;9,1 B X
        ;;9,8 D:$P($ZVER,"/",2)<4 ^%VARLOG X:$P($ZVER,"/",2)'<4 ^DD("$O")
        ;;9,18 I $ZRSTATUS(X)'=""
        ;;9,"SDP" O @("DIO:"_"(""R"":"_$P(DLP,":",2,9)) F %=0:0 U DIO R % Q:$ZIOS=3  U IO W:$A(%)'=12 ! W %
        ;;9,"SDPEND" Q
        ;;9,"XY" S $X=IOX,$Y=IOY
        ;;9,"ZS" S %X="" X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  S %X=%X_$C(10)_^(%Y)" ZS @X:$E(%X,2,999999)
        ;;16,0 DSM for OpenVMS^^108^5000^^1^63
        ;;16,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
        ;;16,8 D DOLRO^%ZOSV
        ;;16,18 I $T(^@X)]""
        ;;16,"SDP" O DIO U DIO:DISCONNECT F %=0:0 U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
        ;;16,"SDPEND" W !,"#$#",! C IO
        ;;16,"XY" S $X=IOX,$Y=IOY
        ;;16,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
        ;;17,0 GT.M(VAX)^^250^15000^^1^250
        ;;17,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
        ;;17,8 X ^DD("$O") ;D DOLRO^%ZOSV
        ;;17,18 I $L($T(^@X))
        ;;17,"SDP" O DIO F  U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
        ;;17,"SDPEND" W !,"#$#",! C IO
        ;;17,"XY" S $X=IOX,$Y=IOY
        ;;17,"ZS" N %,%I,%F,%S S %I=$I,%F=$P($ZRO,",")_X_".m" O %F:(NEWVERSION) U %F X "S %S=0 F  S %S=$O(^UTILITY($J,0,%S)) Q:%S=""""  Q:'$D(^(%S))  S %=^UTILITY($J,0,%S) I $E(%)'="";"" W %,!" C %F U %I
        ;;18,0 CACHE/OpenM^^120^15000^^1^63
        ;;18,1 B X
        ;;18,8 X ^DD("$O")
        ;;18,18 I $T(^@X)]""
        ;;18,"SDP" C DIO O DIO F %=0:0 U DIO R % Q:%="#$#"  U IO W %
        ;;18,"SDPEND" W !,"#$#",! C IO
        ;;18,"XY" S $Y=IOY,$X=IOX
        ;;18,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
        ;;19,0 GT.M(UNIX)^^250^15000^^1^250
        ;;19,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
        ;;19,8 X ^DD("$O") ;D DOLRO^%ZOSV
        ;;19,18 I $L($T(^@X))
        ;;19,"SDP" O DIO F  U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
        ;;19,"SDPEND" W !,"#$#",! C IO
        ;;19,"XY" S $X=IOX,$Y=IOY
        ;;19,"ZS" N %,%I,%F,%S S %I=$I,%F=$P($P($P($ZRO,")"),"(",2)," ")_"/"_X_".m" O %F:(NEWVERSION) U %F X "S %S=0 F  S %S=$O(^UTILITY($J,0,%S)) Q:%S=""""  Q:'$D(^(%S))  S %=^UTILITY($J,0,%S) I $E(%)'="";"" W %,!" C %F U %I ZLINK X
        ;;100,0 OTHER^^40^5000
        ;;100,1 Q
