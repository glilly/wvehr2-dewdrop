C0STBL    ; GPL - Smart Container CREATE A TABLE OF NHINV VALUES;2/22/12  17:05
        ;;1.0;VISTA SMART CONTAINER;;Sep 26, 2012;Build 2
        ;Copyright 2012 George Lilly.  Licensed under the terms of the GNU
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
EN(BEGDFN,DFNCNT,ZPART) ; START IS A DFN
        I '$D(BEGDFN) S BDGDFN=""
        I '$D(DFNCNT) S DFNCNT=150
        I '$D(ZPART) S ZPART=""
        N ZTBL S ZTBL=$NA(^TMP("C0STBL"))
        N ZI,ZCNT,ZG
        S ZI=BEGDFN
        S ZCNT=0
        F  S ZI=$O(^DPT(ZI)) Q:(+ZI=0)!(ZCNT>DFNCNT)  D  ;
        . S ZCNT=ZCNT+1
        . W ZI," "
        . K ZG
        . D EN^C0SNHIN(.ZG,ZI,ZPART)
        . M @ZTBL@(ZI)=ZG
        . K G
        . ;D EN^C0SMART(.G,ZI,"med")
        . ;I $D(G) W !,$$output^C0XGET1("G")
        . ;k G
        . ;D EN^C0SMART(.G,ZI,"patient")
        . ;I $D(G) W !,$$output^C0XGET1("G")
        . ;K G
        . ;D EN^C0SMART(.G,ZI,"lab")
        . ;I $D(G) W !,$$output^C0XGET1("G")
        . ;K G
        . D EN^C0SMART(.G,ZI,"problem")
        . ;I $D(G) W !,$$output^C0XGET1("G")
        Q
        ;
LOADHACK        ;
        N ZI
        F ZI=2:1:374 D  ;
        . D IMPORT^C0XF2N("hack"_ZI_".xml","/home/vista/hack/")
        Q
        ;
