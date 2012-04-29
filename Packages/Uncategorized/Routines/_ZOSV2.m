%ZOSV2  ;ISF/RWF - More GT.M support routines ;10/18/06  14:29
        ;;8.0;KERNEL;**275,425**;Jul 10, 1995;Build 13;WorldVistA 30-Jan-08
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
        Q
        ;SAVE: DIE open array reference.
        ;      XCN is the starting value to $O from.
SAVE(RN)        ;Save a routine
        N %,%F,%I,%N,SP,$ETRAP
        S $ETRAP="S $ECODE="""" Q"
        S %I=$I,SP=" ",%F=$$RTNDIR^%ZOSV()_$TR(RN,"%","_")_".m"
        O %F:(newversion:noreadonly:blocksize=2048:recordsize=2044) U %F
        F  S XCN=$O(@(DIE_XCN_")")) Q:XCN'>0  S %=@(DIE_XCN_",0)") Q:$E(%,1)="$"  I $E(%)'=";" W $P(%,SP)_$C(9)_$P(%,SP,2,99999),!
        C %F ;S %N=$$NULL
        ZLINK RN
        ;C %N
        U %I
        Q
NULL()  ;Open and use null to hide talking.  Return open name
        ;Doesn't work for compile errors
        N %N S %N=$S($ZV["VMS":"NLA0:",1:"/dev/nul")
        O %N U %N
        Q %N
        ;
DEL(RN) ;Delete a routine file, both source and object.
        N %N,%DIR,%I,$ETRAP
        S $ETRAP="S $ECODE="""" Q"
        S %I=$I,%DIR=$$RTNDIR^%ZOSV,RN=$TR(RN,"%","_")
        I $L($ZSEARCH(%DIR_RN_".m",244)) ZSYSTEM "rm -f "_%DIR_X_".m"
        I $L($ZSEARCH(%DIR_RN_".obj",244)) ZSYSTEM "rm -f "_%DIR_X_".obj"
        I $L($ZSEARCH(%DIR_RN_".o",244)) ZSYSTEM "rm -f "_%DIR_X_".o"
        Q
        ;LOAD: DIF open array to receive the routine lines.
        ;      XCNP The starting index -1.
LOAD(RN)        ;Load a routine
        N %
        S %N=0 F XCNP=XCNP+1:1 S %N=%N+1,%=$T(+%N^@RN) Q:$L(%)=0  S @(DIF_XCNP_",0)")=%
        Q
        ;
LOAD2(RN)       ;Load a routine
        N %,%1,%F,%N,$ETRAP
        S %I=$I,%F=$$RTNDIR^%ZOSV()_$TR(RN,"%","_")_".m"
        O %F:(readonly):1 Q:'$T  U %F
        F XCNP=XCNP+1:1 R %1:1 Q:'$T!$ZEOF  S @(DIF_XCNP_",0)")=$TR(%1,$C(9)," ")
        C %F I $L(%I) U %I
        Q
        ;
RSUM(RN)        ;Calculate a RSUM value
        N %,DIF,XCNP,%N,Y,$ETRAP K ^TMP("RSUM",$J)
        S $ETRAP="S $ECODE="""" Q"
        S Y=0,DIF="^TMP(""RSUM"",$J,",XCNP=0 D LOAD2(RN)
        F %=1,3:1 S %1=$G(^TMP("RSUM",$J,%,0)),%3=$F(%1," ") Q:'%3  S %3=$S($E(%1,%3)'=";":$L(%1),$E(%1,%3+1)=";":$L(%1),1:%3-2) F %2=1:1:%3 S Y=$A(%1,%2)*%2+Y
        K ^TMP("RSUM",$J)
        Q Y
        ;
RSUM2(RN)       ;Calculate a RSUM2 value
        N %,DIF,XCNP,%N,Y,$ETRAP K ^TMP("RSUM",$J)
        S $ETRAP="S $ECODE="""" Q"
        S Y=0,DIF="^TMP(""RSUM"",$J,",XCNP=0 D LOAD2(RN)
        F %=1,3:1 S %1=$G(^TMP("RSUM",$J,%,0)),%3=$F(%1," ") Q:'%3  S %3=$S($E(%1,%3)'=";":$L(%1),$E(%1,%3+1)=";":$L(%1),1:%3-2) F %2=1:1:%3 S Y=$A(%1,%2)*(%2+%)+Y
        K ^TMP("RSUM",$J)
        Q Y
        ;
TEST(RN)        ;Special GT.M Test to see if routine is here.
        N %F,%X
        S %F=$$RTNDIR^%ZOSV()_$TR(RN,"%","_")_".m"
        S %X=$ZSEARCH("X.X",245),%X=$ZSEARCH(%F,245)
        Q %X
