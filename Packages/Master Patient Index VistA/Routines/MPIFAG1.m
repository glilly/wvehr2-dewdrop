MPIFAG1 ; EHR/DAOU/WCJ - ENTER HEALTH RECORD NUMBER ;1/27/07  21:26
 ;;1.0; MASTER PATIENT INDEX VISTA ;**40**;30 Apr 99;Build 13
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
 ;;;EHR PATIENT REGISTRATION;;
 ;
 ;This routine was originally from IHS routine AG1.
 ;It was modified so that it could be called from anywhere as long as
 ;DFN - patient
 ;DUZ(2) - location
 ;are defined.
 ;
 ;It was specifcally written so that it could be called within a DR string
 ;It is used to modify file 9000001 while in file 2.
 ;
HRN ;
 Q:'$G(DUZ(2))
 Q:'$G(DFN)
 N IENS,OUT,AG,SEQ,LIEN
 N DTOUT,DFOUT,DLOUT,DUOUT,DQOUT,Y
 N FDA,FDAIEN,XXX,PATID
 ;
 ; Find HRN for this DFN/location
 S IENS=","_DFN_","
 D FIND^DIC(9000001.41,IENS,"@;.01;.02;","X",DUZ(2),,,,,"OUT")
 ;
 ; Check if it's a new location
 S SEQ=$O(OUT("DILIST","ID",0))
 I SEQ S LIEN=$O(OUT("DILIST",2,SEQ)) ;(No point to this!)
 ;
 ; prompt user for HRN
L1 ;
 I SEQ S (AG("CH"),AG("OCH"))=OUT("DILIST","ID",SEQ,.02)
 I 'SEQ S (AG("CH"),AG("OCH"))=$$GENHRN()
 S DIR(0)="9000001.41,.02",DIR("B")=AG("CH")
 D ^DIR
 I 'SEQ,$D(DTOUT) S Y=$G(AG("CH")) K DTOUT
 I $G(AG("CH"))]"",$D(DTOUT) Q
 I $D(DUOUT) Q  ;W !,"EXIT NOT ALLOWED ??"
 ; See if anyone is using that one
 S AG("CH")=+Y
 G L3:'$D(^AUPNPAT("D",AG("CH")))
 Q:$D(^AUPNPAT("D",AG("CH"),$G(DFN)))
 S AG("D")=0
 ;
 ; someone is using this one already, see if it's the same location
L2 ;
 S AG("D")=$O(^AUPNPAT("D",AG("CH"),AG("D")))
 G L3:AG("D")=""
 S AG("DD")=0
 S AG("DD")=$O(^AUPNPAT("D",AG("CH"),AG("D"),AG("DD")))
 G L2:AG("DD")'=DUZ(2)
 W !,*7,AG("CH")," is already assigned to ",$P(^DPT(AG("D"),0),U)
 G L1
 ;
 ; let's do it.  unique for this Location
L3 ;
 S IENS="?+1,"_DFN_","
 S FDAIEN(1)=DUZ(2)
 S XXX="FDA"
 S FDA(9000001.41,IENS,.01)=DUZ(2)
 S FDA(9000001.41,IENS,.02)=AG("CH")
 D UPDATE^DIE("",XXX,"FDAIEN","RET")
 Q
 ;
 ;
CHECK(Y) ;
 N X,DA S DA(1)=+$G(DFN),DA=DUZ(2),X=Y
 X $P(^DD(9000001.41,.02,0),U,5,99) Q $D(X)>0
 ;
 ;
GENHRN() ;
 N HRN
 S HRN=$O(^AUPNPAT("D",999999999),-1) I HRN'?.N S HRN="" G Q
 S HRN=HRN+1
 I '$$CHECK(HRN) S HRN="" G Q
 F  Q:'$D(^AUPNPAT("D",HRN))  S HRN=HRN+1 I '$$CHECK(HRN) S HRN="" G Q
Q Q HRN
