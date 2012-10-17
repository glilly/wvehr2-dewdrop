LR7OSUM6        ;DALOI/dcm - Silent Patient cum cont. ;2:54 PM  15 Aug 2009
        ;;5.2;LAB SERVICE;**121,201,187,286,356,372**;Sep 27, 1994;Build 15;WorldVistA 30-June-08
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
        ;
LRUDT(X)        ;Get output date/time
        N LRTIM,I
        S LRTIM=$E(X,9,12) F I=0:0 Q:$L(LRTIM)=4  S LRTIM=LRTIM_0
        S LRTIM=$S(LRTIM?4"0":"     ",1:$E(LRTIM,1,2)_":"_$E(LRTIM,3,4)),LRUDT=$$FMTE^XLFDT($P(X,"."),"5Z")_" "_$J(LRTIM,5)_" "
        Q LRUDT
        ;
        ;
HEAD    ;from LR7OSUM3, LR7OSUM4, LR7OSUM5
        D LRBOT,TOP
        Q
        ;
        ;
LRBOT   ;from LR7OSUM3
        N L1 D LINE^LR7OSUM4
Y       D LINE^LR7OSUM4
        Q
        ;
        ;
TOP     ;from LR7OSUM3
        S LRAG=0
        Q
        ;
        ;
KILL    D HEAD Q
        Q
        ;
        ;
LRMISC  S LRFDT=0,LRPG=1 D TOP
        ;
MHI     S LRMHN=$P(^TMP($J,LRDFN,LRMH),U,1),LRCNT=12 D WR
        ;
MDT     S LRFDT=$O(^TMP($J,LRDFN,"MISC",LRFDT)) G:LRFDT<1 END
        S LRUDT=$$LRUDT(9999999-LRFDT) D LRCNT S LRMIT=0
        ;
LRMIT   S LRMIT=$O(^TMP($J,LRDFN,"MISC",LRFDT,LRMIT)) G:LRMIT="TX" TXT G:LRMIT="" MDT S X=^(LRMIT) G:LRMIT=.1 MSG
        ;
        S LRVAL=$P(X,U,1),LRSPE=$P(X,U,2),LRTEST=$P(X,U,3),X1=$P(X,U,4)
        ;S LRLO="",LRHI=","LRUNT=""
        S LRLO=$P(X,"^",6),LRHI=$P(X,"^",7),LRUNT=$P(X,"^",8)
        S LRSPEM=$S($L(LRSPE):$P(^LAB(61,LRSPE,0),U,1),1:"")
        G:'LRTEST COMM
        ;Begin WorldVistA change; NO HOME 1.0
        ;S LRNAME=$P(^LAB(60,LRTEST,.1),U,1)
        S LRNAME=$P(^LAB(60,LRTEST,0),"^")
        I $L(LRNAME)>13,$P($G(^LAB(60,LRTEST,.1)),"^")'="" S LRNAME=$P(^LAB(60,LRTEST,.1),"^")
        E  S LRNAME=$E(LRNAME,1,13)
        ;End WorldVistA change
        ;S:$L(LRSPE)&($D(^LAB(60,LRTEST,1,LRSPE,0))) X=^(0),@("LRLO="_$S($L($P(X,U,2)):$P(X,U,2),1:"""""")),@("LRHI="_$S($L($P(X,U,3)):$P(X,U,3),1:"""""")),LRUNT=$P(X,U,7)
        ;
WR1     D LINE^LR7OSUM4
        S LRREF=$$EN^LRLRRVF(LRLO,LRHI)
        S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,LRUDT)_$$S^LR7OS(19,CCNT,$E(LRSPEM,1,16))_$$S^LR7OS(37,CCNT,LRNAME_":")_$$S^LR7OS(50,CCNT,LRVAL_" "_X1_"  "_LRUNT)_$$S^LR7OS(67,CCNT,LRREF)
        S:'$P($G(^TMP("LRT",$J,LRNAME)),"^",2) $P(^(LRNAME),"^",2)=GCNT
        K LRREF
        G LRMIT
        ;
        ;
MSG     D LINE^LR7OSUM4,LINE^LR7OSUM4
        X X ;Need to see what is in X
        G LRMIT
        ;
        ;
COMM    D LN
        S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(1,CCNT,"COMMENT: "_LRVAL)
        G LRMIT
        ;
        ;
WR      ;
        D LINE^LR7OSUM4
        S X=GIOM/2-($L(LRMHN)/2+5)
        S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(X,CCNT,"---- "_LRMHN_" ----"),^TMP("LRH",$J,LRMHN)=GCNT
        D LINE^LR7OSUM4
        D LN S ^TMP("LRC",$J,GCNT,0)=$$S^LR7OS(4,CCNT,"DATE    TIME   SPECIMEN")_$$S^LR7OS(37,CCNT,"TEST")_$$S^LR7OS(50,CCNT,"VALUE")_$$S^LR7OS(64,CCNT,"Ref ranges")
        D LN S X="",$P(X,"-",GIOM)="",^TMP("LRC",$J,GCNT,0)=X
        Q
        ;
        ;
TXT     S I=0
        F  S I=$O(^TMP($J,LRDFN,"MISC",LRFDT,"TX",I)) Q:I<1  S GCNT=GCNT+1,^TMP("LRC",$J,GCNT,0)=^(I,0)
        G LRMIT
        ;
        ;
END     S X="",$P(X,"=",GIOM)="",GCNT=GCNT+1,^TMP("LRC",$J,GCNT,0)=X
        D LRBOT S LRLO=""
        K LRSB,LRMISC
        Q
        ;
        ;
PRE     ;from LR7OSUM3
        Q:$D(^TMP($J,LRDFN,"MISC"))'=11
        S LRMISC=1,LRPG=0,LRMH="MISC"
        G LRMISC
        ;
        ;
LRCNT   ;
        S LRCNT=0,I=0
        F  S I=$O(^TMP($J,LRDFN,LRMH,LRFDT,I)) Q:I<1  S LRCNT=LRCNT+1
        S LRCTN=0
        I $D(^TMP($J,LRDFN,LRMH,LRFDT,"TX")) D
        . S J=0
        . F  S J=$O(^TMP($J,LRDFN,LRMH,LRFDT,"TX",J)) Q:J<1  S LRCTN=LRCTN+1
        S LRCNT=LRCNT*2+5+LRCTN
        Q
        ;
        ;
LN      ;
        S CCNT=1,GCNT=GCNT+1
        Q
