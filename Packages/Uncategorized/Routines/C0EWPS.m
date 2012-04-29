C0PWPS   ; VISTACOM/GPL - CPRS RPC to pass DUZ to VistACom ; 4/11/11 7:00pm
 ;;0.1;C0P;nopatch;noreleasedate
 ;Copyright 2009 George Lilly.  Licensed under the terms of the GNU
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
 Q
 ; This routines is a substitute for COVER^ORWPS to pass the DUZ to VistACom
 ; It will be overlayed on systems that have eRx by C0PWPS which also has this feature
 ;
COVER(LST,DFN)  ; retrieve meds for cover sheet
 K ^TMP("PS",$J)
 D OCL^PSOORRL(DFN,"","")  ;DBIA #2400
 N ILST,ITMP,X S ILST=0
 S ITMP="" F  S ITMP=$O(^TMP("PS",$J,ITMP)) Q:'ITMP  D
 . S X=^TMP("PS",$J,ITMP,0)
 . I '$L($P(X,U,2)) S X="??"  ; show something if drug empty
 . I $D(^TMP("PS",$J,ITMP,"CLINIC",0)) S LST($$NXT^ORWPS)=$P(X,U,1,2)_U_$P(X,U,8,9)_U_"C"
 . E  S LST($$NXT^ORWPS)=$P(X,U,1,2)_U_$P(X,U,8,9)
 K ^TMP("PS",$J)
 ; BEGIN VISTACOM MOD -
 ; SAVE THE DUZ OFF TO THE VISTACOM TMP GLOBAL
 S ^TMP("ZEWD",$J,"DUZ")=DUZ ; TO BE PICKED UP AND DELETED LATER BY VISTACOM
 Q
