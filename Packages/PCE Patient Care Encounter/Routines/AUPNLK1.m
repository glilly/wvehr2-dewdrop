AUPNLK1 ; IHS/CMI/LAB - IHS PATIENT LOOKUP CHECK XREFS ;12/26/06  10:52
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**167**;Aug 12, 1996;Build 22
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
 ; Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
 ;'Modified' MAS Patient Look-up Check Cross-References June 1987
 ;
 ; Upon exiting this routine AUPDFN will exist as follows:
 ;        AUPDFN = 0 means no hits
 ;        AUPDFN < 0 means hits but no selection
 ;        AUPDFN > 0 means selection made
 ;
START ;
 D INIT ;                    Fix up AUPX & set up xrefs
 D SEARCH ;                  Search xrefs
 D EOJ ;                     Cleanup
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
SEARCH ; SEARCH XREFS
 F AUPLP=1:1 S AUPREF=$P(AUPREFS,",",AUPLP) Q:AUPREF=""!(AUPDFN)  D
 .I AUPREF="ADOB" S AUPVAL=AUPDT
 .E  I AUPREF="AZVWVOE" S AUPVAL=$E($TR(AUPX,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()-_=+[]{}<>,./?:;'\|"),1,30)
 .E  S AUPVAL=AUPX
 .D IHSVAL I 'AUPDFN,AUPREF="B" D IHSB I 'AUPDFN D IHSCHK
 I 'AUPDFN S:AUPCNT=1&($D(AUPIFNS(AUPCNT))) AUPDFN=+AUPIFNS(AUPCNT) S AUP("NOPRT^")="" D PRTAUP^AUPNLKUT:'AUPDFN&(AUPCNT>AUPNUM)&(DIC(0)["E") K AUP("NOPRT^") I 'AUPDFN,$D(AUPSEL),AUPSEL="" S AUPX="",AUPDFN=-1
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
IHSB ; CHECK TRANSPOSED OR MISSING FIRST/MIDDLE
 Q:AUPX'?1A.E1",".E
 S AUPNML=$P(AUPX,",",1),AUPNMF=$P($P(AUPX,",",2)," ",1),AUPNMM=$P($P(AUPX,",",2)," ",2)
 Q:AUPNMF=""
 I AUPNMF?.E1P.E S X=AUPNMF D PUNC S AUPNMF=X
 I AUPNMM?.E1P.E S X=AUPNMM D PUNC S AUPNMM=X
 S AUPBX=AUPNML
 F AUPBI=0:0 Q:AUPDFN  S AUPBX=$O(^DPT("B",AUPBX)) Q:$P($P(AUPBX,",",1)," ",1)'=AUPNML  S AUPBY=$P(AUPBX,",",2) D IHSB2 I Y F Y=0:0 S Y=$O(^DPT("B",AUPBX,Y)) Q:'Y  I '$D(AUPS(Y)) S AUPVAL=AUPBX,AUPNICK(Y)="" D SETAUP^AUPNLKUT Q:AUPDFN
 K AUPBI,AUPBX,AUPBY
 Q
 ;
PUNC ;
 F I=1:1:$L(X) I $E(X,I)?1P S X=$E(X,1,I-1)_$E(X,I+1,99)
 Q
 ;
IHSB2 ;
 S Y=0
 I " "_$P(AUPBY," ",2)[(" "_AUPNMF)," "_$P(AUPBY," ",1)[(" "_AUPNMM) S Y=1 Q
 I " "_$P(AUPBY," ",1)[(" "_AUPNMF)," "_$P(AUPBY," ",2)[(" "_AUPNMM) S Y=1 Q
 Q
 ;
IHSCHK ; CHECK NICKNAMES AND LAST NAME FOR MISPELLING
 Q:AUPX'?1A.E1",".E
 S AUPNMCVN=3
 D IHSCHK4
 Q:AUPDFN
 S AUPNMCHK("AUPX")=AUPX
 S AUPNMCHK("LAST")=$P(AUPX,",",1)
 I $D(^APMM(98,"B",AUPNMCHK("LAST"))) F AUPNMCHK("EN")=0:0 S AUPNMCHK("EN")=$O(^APMM(98,"B",AUPNMCHK("LAST"),AUPNMCHK("EN"))) Q:AUPNMCHK("EN")=""  D IHSCHK2 Q:AUPDFN
 S AUPX=AUPNMCHK("AUPX")
 K AUPNMCHK,AUPNMCVN
 Q
 ;
IHSCHK2 ;
 K AUPNMCHK("TBL")
 S AUPNMCHK("TBL",$P(^APMM(98,AUPNMCHK("EN"),0),U,1))=""
 F AUPL=0:0 S AUPL=$O(^APMM(98,AUPNMCHK("EN"),"F",AUPL)) Q:AUPL'=+AUPL  S AUPNMCHK("TBL",$P(^APMM(98,AUPNMCHK("EN"),"F",AUPL,0),U,1))=""
 K AUPNMCHK("TBL",$P(AUPNMCHK("AUPX"),U,1))
 S AUPNMCHK("NLAST")="" F AUPL=0:0 S AUPNMCHK("NLAST")=$O(AUPNMCHK("TBL",AUPNMCHK("NLAST"))) Q:AUPNMCHK("NLAST")=""  D IHSCHK3 Q:AUPDFN
 Q
 ;
IHSCHK3 ;
 S $P(AUPX,",",1)=AUPNMCHK("NLAST"),AUPVAL=AUPX
 S AUPNMCVN=3
 D IHSVAL
 Q:AUPDFN
 D IHSCHK4
 Q
 ;
IHSCHK4 ; CHECK FIRST & MIDDLE NAMES FOR NICK NAMES
 S AUPNML=$P(AUPX,",",1),AUPNMF=$P($P(AUPX,",",2)," ",1),AUPNMM=$P($P(AUPX,",",2)," ",2)
 Q:AUPNMF=""
 I $D(^APMM(99,"B",AUPNMF)) S AUPNMCVN=1 F AUPNMCV=0:0 S AUPNMCV=$O(^APMM(99,"B",AUPNMF,AUPNMCV)) Q:AUPNMCV=""  D IHSNMCV Q:AUPDFN
 K AUPNMCV,AUPNMCVT
 Q:AUPDFN
 I AUPNMM'="",$D(^APMM(99,"B",AUPNMM)) S AUPNMCVN=2 F AUPNMCV=0:0 S AUPNMCV=$O(^APMM(99,"B",AUPNMM,AUPNMCV)) Q:AUPNMCV=""  D IHSNMCV Q:AUPDFN
 K AUPNMCV,AUPNMCVN,AUPNMCVT
 Q:AUPDFN
 K AUPNML,AUPNMF,AUPNMM
 Q
 ;
IHSNMCV ; CHECK NICK NAMES
 K AUPNMCVT
 S AUPNMCVT($P(^APMM(99,AUPNMCV,0),U,1))=""
 F AUPL=0:0 S AUPL=$O(^APMM(99,AUPNMCV,"F",AUPL)) Q:AUPL'=+AUPL  S AUPNMCVT($P(^APMM(99,AUPNMCV,"F",AUPL,0),U,1))=""
 K AUPNMCVT($S(AUPNMCVN=1:AUPNMF,1:AUPNMM))
 S AUPNMCVI="" F AUPL=0:0 S AUPNMCVI=$O(AUPNMCVT(AUPNMCVI)) Q:AUPNMCVI=""!(AUPDFN)  S AUPVAL=AUPNML_","_$S(AUPNMCVN=1:AUPNMCVI,1:AUPNMF)_$S(AUPNMCVN=1&(AUPNMM'=""):" "_AUPNMM,AUPNMCVN=2:" "_AUPNMCVI,1:"") D IHSNMCV2
 K AUPNMCVI
 Q
 ;
IHSNMCV2 ;
 S AUPNMCVX=AUPX,AUPX=AUPVAL
 D IHSVAL
 S AUPX=AUPNMCVX
 K AUPNMCVX
 Q
 ;
IHSVAL ;
 I $D(^DPT(AUPREF,AUPVAL))&(DIC(0)["X") D CHKIFN Q
 D:$D(^DPT(AUPREF,AUPVAL)) CHKIFN
 D:DIC(0)'["X" CHKVAL
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
CHKVAL ;
 S AUPVAL=$S($D(AUPNMCVN):AUPVAL,AUPREF="ADOB":AUPDT,AUPX?.N:AUPX_" ",1:AUPX) S:$E(AUPVAL,$L(AUPVAL))="." AUPVAL=$E(AUPVAL,1,$L(AUPVAL)-1)
 F AUPLP1=0:0 S AUPVAL=$O(^DPT(AUPREF,AUPVAL)) Q:AUPVAL=""!(AUPDFN)!($P(AUPVAL,$S($E(AUPX,$L(AUPX))=".":$E(AUPX,1,$L(AUPX)-1),1:AUPX))'="")  D CHKIFN
 Q
 ;
CHKIFN ;
 F AUPIFN=0:0 S AUPIFN=$O(^DPT(AUPREF,AUPVAL,AUPIFN)) Q:'AUPIFN!(AUPDFN)  S Y=AUPIFN D SETAUP^AUPNLKUT I $S<1000 F AUPI=1:1:AUPNUM-5 Q:'$D(AUPIFNS(AUPI))  K AUPIFNS(AUPI) S AUPBEG=AUPI
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
INIT ; INITIALIZATION - FIX UP AUPX AND SET UP XREFS
 D ^AUPNLK1I
 Q
 ;
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
EOJ ;
 K AUPBEG,AUPDT,AUPI,AUPIFN,AUPIFNS,AUPLP,AUPLK1,AUPNMCHK,AUPNMCV,AUPNMCVN,AUPNMCVT,AUPNMF,AUPNML,AUPNMM,AUPNUM,AUPREF,AUPREFS,AUPVAL
 Q
