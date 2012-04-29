AUPNLKB ; IHS/CMI/LAB - Broke up AUPNLK because of size ;8DEC2006
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
LOOKUPS ; EXTERNAL ENTRY POINT
 S AUPBEG=1,(AUPDFN,AUPNUM)=0
 D QUICK ;                Try quick lookups first
 I AUPQF Q  ;HERE IS WHERE WE WOULD GO FARTHER IN OUR SEARCH IF MATCHING HRN WASN'T GOOD ENOUGH --GFT
 D XREFS ;                Try lookup on xrefs
 Q:AUPQF
 I DIC(0)["N" D DFN ;     Try by DFN
 Q:AUPQF
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
QUICK ; QUICK LOOKUPS
 I $D(AUPNLK("ICN")) D ICN Q
 D IHSCHRT I AUPDFN>0 S AUPQF=4 Q  ;**GFT/VW
 I AUPX["^" S AUPQF=3 Q
 S AUPDFN=0
 I AUPX=" " S Y=$S('($D(DUZ)#2):-1,$D(^DISV(DUZ,"^DPT(")):^("^DPT("),1:-1) D SETAUP^AUPNLKUT:Y>0 S AUPDFN=$S($D(AUPS(Y)):Y,1:-1) D CHKDFN K AUPSP Q
 I $E(AUPX)="`" S Y=$S($D(^DPT(+$P(AUPX,"`",2),0)):+$P(AUPX,"`",2),1:-1) D SETAUP^AUPNLKUT:Y>0 S AUPDFN=$S($D(AUPS(Y)):Y,1:-1) D CHKDFN Q
 Q
 ;
ICN ; LOOKUP BY ICN (for MFI)
 S AUPDFN=-1
 S X=$P(AUPNLK("ICN"),":",2),AUPNLK("ICN")=$P(AUPNLK("ICN"),":",1)
 Q:X'?1N.N
 Q:AUPNLK("ICN")'?1N.N
 Q:'$D(^AUTTLOC(AUPNLK("ICN"),0))
 Q:'$D(^AUPNPAT("AICN",AUPNLK("ICN"),X))
 S (AUPDFN,Y)=$O(^(X,0))
 S:$D(DIC("S")) AUPNLK("DICS")=DIC("S") K DIC("S") D SETAUP^AUPNLKUT S:$D(AUPNLK("DICS")) DIC("S")=AUPNLK("DICS") K AUPNLK("DICS")
 S AUPQF=4
 Q
 ;
IHSCHRT ; LOOKUP CHART #
 Q:'$D(^AUPNPAT("D",AUPX))
ALLQ D IHSCHRT1:'$G(AUPNLK("ALL")),IHSCHRT2:$G(AUPNLK("ALL"))
 Q
 ;
IHSCHRT1 ; LOOKUP CHART # WHEN ONLY 1 DUZ(2) SHOULD BE USED
 F Y=0:0 S Y=$O(^AUPNPAT("D",AUPX,Y)) Q:Y=""  Q:$D(^(Y,DUZ(2)))
 Q:Y=""
 D SETAUP^AUPNLKUT
 S AUPDFN=$S($D(AUPS(Y)):Y,1:-1)
 Q
 ;
IHSCHRT2 ; LOOKUP CHART # WHEN ALL INSTITUTIONS SHOULD BE SCANNED
 F AUPIFN=0:0 S AUPIFN=$O(^AUPNPAT("D",AUPX,AUPIFN)) Q:AUPIFN=""  S Y=AUPIFN D SETAUP^AUPNLKUT
 S:AUPCNT=1&($D(AUPIFNS(AUPCNT))) AUPDFN=+AUPIFNS(AUPCNT) D PRTAUP^AUPNLKUT:'AUPDFN&(AUPCNT>AUPNUM)&(DIC(0)["E") I 'AUPDFN,$D(AUPSEL),AUPSEL="" S AUPDFN=-1
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
XREFS ; LOOKUP BY XREFS
 ; Upon returning from ^AUPNLK1 AUPDFN values/meanings are:
 ;       0 = No hits
 ;      <0 = Hits but no selection
 ;      >0 = Selection made
 D ^AUPNLK1
 I $D(DTOUT) S AUPQF=2 Q
 I AUPDFN>0 S AUPQF=4 Q
 I AUPDFN<0 S AUPQF=3 Q
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
DFN ; LOOKUP BY DFN
 Q:AUPX'?1N.N
 S AUPDFN=-1,AUPBEG=1,AUPNUM=0
 I $D(^DPT(AUPX,0)) S Y=X D SETAUP^AUPNLKUT S AUPDFN=$S($D(AUPS(Y)):Y,1:-1) D CHKDFN Q
 Q
 ;
CHKDFN ;
 S:'$D(AUPDFN) AUPDFN=-1
 I +AUPDFN'>0!('$D(AUPS(+AUPDFN))) D:DIC(0)["Q" EN^DDIOL($C(7)_" ??") S AUPQF=3 Q
 S AUPQF=4
 Q
 ; - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ;
ADDPAT ; EXTERNAL ENTRY POINT - ADD PATIENT
 I AUPX?1"""".E1"""" S AUPX=$E(AUPX,2,$L(AUPX)-1)
 D ^AUPNLK2
 S Y=AUPDFN
 I Y<0 S AUPQF=3 Q
 S AUPQF=5
 Q
