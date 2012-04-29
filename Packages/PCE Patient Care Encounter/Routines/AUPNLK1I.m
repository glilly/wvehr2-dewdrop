AUPNLK1I ; IHS/CMI/LAB - INITIALIZATION FOR ^AUPNLK1 ;16DEC2006
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
INIT ; INITIALIZATION - FIX UP AUPX AND SET UP XREFS
 I AUPX?.E1L.E F AUPI=1:1:$L(AUPX) S:$E(AUPX,AUPI)?1L AUPX=$E(AUPX,0,AUPI-1)_$C($A(AUPX,AUPI)-32)_$E(AUPX,AUPI+1,$L(AUPX))
 I AUPX[", " F AUPL=0:0 Q:'$F(AUPX,", ")  S AUPX=$E(AUPX,1,($F(AUPX,", ")-2))_$E(AUPX,$F(AUPX,", "),$L(AUPX))
 K AUPREFS S AUPREFS=$S(DIC(0)'["M":"B",AUPX?1A1N.N:"CN,RM,BS5",AUPX?4N.1A:"CN,RM,BS",AUPX?9N.E:"SSN,CN,RM",1:"")
 S:AUPREFS="" AUPREFS=$S(AUPX?1N.N:$S($L(AUPX)<5:"CN,RM,BS,SSN",1:"CN,RM,SSN"),AUPX?1N.E:"CN,RM",1:"B,CN,RM,BS5") S:$D(AUPIX) AUPREFS=AUPIX_","_AUPREFS
 ; - - - - - IHS DOB - - - - -
 ;beginning Y2K IHS/CMI/LAB
 ;change "X" to %DT="PX", change allowable input from 6N to 8N
 ;I DIC(0)["M",AUPX'?1N.N S %DT="X",X=$S(AUPX?1"B"6N:$E(AUPX,2,7),1:AUPX) D ^%DT S:Y'=-1 AUPDT=Y,AUPREFS=AUPREFS_",ADOB" K %DT,Y ;Y2000 IHS/CMI/LAB
 I DIC(0)["M",AUPX'?1N.N S %DT="PX",X=$S(AUPX?1"B"8N:$E(AUPX,2,9),1:AUPX) D ^%DT S:Y'=-1 AUPDT=Y,AUPREFS=AUPREFS_",ADOB" K %DT,Y ;Y2000 IHS/CMI/LAB
 ;end Y2K fix
 ; - - - - - IHS TEMPORARY CHART # - - - - -
 I AUPX?1"T"5N,$D(^AUPNPAT("D",AUPX)) S (AUPIFN,Y)=$O(^AUPNPAT("D",AUPX,0)) D SETAUP^AUPNLKUT
 ; - - - - - - - - - - - - - - - - - - - - -
PHONE I DIC(0)["M",AUPX?.NP S AUPREFS=AUPREFS_",AZVWVOE" ;**GFT/VW
 Q
