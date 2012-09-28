C0XTESTKSB      ; GPL - Fileman Triples bulk load tester ;11/6/11  17:05
        ;;1.0;FILEMAN TRIPLE STORE;;Sep 26, 2012
        ; KSB - modified to fix a minor bug and to use;;;;;Build 10
        ;       high resolution time if routines available ; 11/19/11 1410 EST
        ;;0.1;C0X;nopatch;noreleasedate;Build 1
        ;Copyright 2011 George Lilly.  Licensed under the terms of the GNU
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
        ;
EN      ; run the test
        ;
        k C0XFDA ; clear the node variable
        s U="^"  ; initialization - Bhaskar 20111119
        i '$d(^C0X(101,0)) d  ; global doesn't exist
        . s ^C0X(101,0)="C0X TRIPLE^172.101^1^1"
        n zg
        S zg="_:G"_$$LKY9 ; all nodes are in the same graph
        n zi
        f zi=1:1:10000 d  ; try a test of 10000 nodes
        . s C0XFDA(172.101,zi,.01)="N"_$$LKY17 ; node name
        . s C0XFDA(172.101,zi,.02)=zg
        . s C0XFDA(172.101,zi,.03)=$R(100000)
        . s C0XFDA(172.101,zi,.04)=$R(100000)
        . s C0XFDA(172.101,zi,.05)=$R(100000)
        S C0XST=$$H    ; start of the insertion test
        W !,"INSERTION STARTS AT ",$ZDATE(C0XST,"YEAR-MM-DD:24:60:SS"),!
        d BULKLOAD(.C0XFDA)
        s C0XEND=$$H    ; end of the insertion test
        W !,"INSERTION ENDS AT ",$ZDATE(C0XEND,"YEAR-MM-DD:24:60:SS")
        S C0XDIFF=(86400*($P(C0XEND,",",1)-$P(C0XST,",",1)))+$P(C0XEND,",",2)-$P(C0XST,",",2)
        W !," ELAPSED TIME: ",C0XDIFF," SECONDS"
        W !
        W:C0XDIFF>0 " APPROXIMATELY ",$FN(10000/C0XDIFF,",",0)," NODES PER SECOND",!
        q
        ;
LKY9()  ;EXTRINIC THAT RETURNS A RANDOM 9 DIGIT NUMBER. USED FOR GENERATING
        ; UNIQUE NODE AND GRAPH NAMES
        N ZN,ZI
        S ZN=""
        F ZI=1:1:9 D  ;
        . S ZN=ZN_$R(10)
        Q ZN
        ;
LKY17() ;EXTRINIC THAT RETURNS A RANDOM 9 DIGIT NUMBER. USED FOR GENERATING
        ; UNIQUE NODE AND GRAPH NAMES
        N ZN,ZI
        S ZN=""
        F ZI=1:1:17 D  ;
        . S ZN=ZN_$R(10)
        Q ZN
        ;
BULKLOAD(ZBFDA) ; BULK LOADER FOR LOADING TRIPLES INTO FILE 172.101
        ; USING GLOBAL SETS INSTEAD OF UPDATE^DIE
        ; QUITS IF FILE IS NOT 172.101
        ; EXPECTS AN FDA WITHOUT STRINGS FOR THE IENS, STARTING AT 1
        ; QUITS IF FIRST ENTRY IS NOT IENS 1
        ; ASSUMES THAT THE LAST IENS IS THE COUNT OF ENTRIES
        ; ZBFDA IS PASSED BY REFERENCE
        ;
        ; -- reserves a block of iens from file 172.101 by locking the zero node
        ; -- ^C0X(101,0) and adding the count of entries to piece 2 and 3
        ; -- then unlocking to minimize the duration of the lock
        ;
        W !,"USING BULKLOAD"
        I '$D(ZBFDA) Q  ; EMPTY FDA
        I $O(ZBFDA(""))'=172.101 Q  ; WRONG FILE
        N ZCNT,ZP3,ZP4
        ; -- find the number of nodes to insert
        S ZCNT=$O(ZBFDA(172.101,""),-1)
        I ZCNT="" D  Q  ;
        . W !,"ERROR IN BULK LOAD - INVALID NODE COUNT"
        . B
        ; -- lock the zero node and reserve a block of iens to insert
        W !,"LOCKING ZERO NODE"
        LOCK +^C0X(101,0)
        S ZP3=$P(^C0X(101,0),U,3)
        S ZP4=$P(^C0X(101,0),U,4)
        S $P(^C0X(101,0),U,3)=ZP3+ZCNT+1
        S $P(^C0X(101,0),U,4)=ZP4+ZCNT+1
        LOCK -^C0X(101,0)
        N ZI,ZN,ZG,ZS,ZP,ZO,ZIEN,ZBASE
        S ZBASE=ZP3 ; the last ien in the file
        W !,"ZERO NODE UNLOCKED, IENS RESERVED=",ZCNT
        W !,$ZDATE($$H,"YEAR-MM-DD:24:60:SS")
        S ZI=""
        F  S ZI=$O(ZBFDA(172.101,ZI)) Q:ZI=""  D  ;
        . S ZN=$G(ZBFDA(172.101,ZI,.01)) ; node name
        . I ZN="" D BLKERR Q  ; 
        . S ZG=$G(ZBFDA(172.101,ZI,.02)) ; graph pointer
        . I ZG="" D BLKERR Q  ; 
        . S ZS=$G(ZBFDA(172.101,ZI,.03)) ; subject pointer
        . I ZS="" D BLKERR Q  ; 
        . S ZP=$G(ZBFDA(172.101,ZI,.04)) ; predicate pointer
        . I ZP="" D BLKERR Q  ; 
        . S ZO=$G(ZBFDA(172.101,ZI,.05)) ; object pointer
        . I ZO="" D BLKERR Q  ; 
        . S ZIEN=ZI+ZBASE ; the new ien
        . S ^C0X(101,ZIEN,0)=ZN_U_ZG_U_ZS_U_ZP_U_ZO ; set the zero node
        . S ^C0X(101,"B",ZN,ZIEN)="" ; the B index
        . S ^C0X(101,"G",ZG,ZIEN)="" ; the G for Graph index
        . S ^C0X(101,"SPO",ZS,ZP,ZO)=""
        . S ^C0X(101,"SOP",ZS,ZO,ZP)=""
        . S ^C0X(101,"OPS",ZO,ZP,ZS)=""
        . S ^C0X(101,"OSP",ZO,ZS,ZP)=""
        . S ^C0X(101,"GOPS",ZG,ZO,ZP,ZS)=""
        . S ^C0X(101,"GOSP",ZG,ZO,ZS,ZP)=""
        . S ^C0X(101,"GPSO",ZG,ZP,ZS,ZO)=""
        . S ^C0X(101,"GSPO",ZG,ZS,ZP,ZO)=""
        Q
        ;
BLKERR  ; 
        W !,"ERROR IN BULK LOAD",! ZWR ZBFDA(ZI)
        B
        Q
        ;
H()     
        quit:$length($ztrnlnm("GTMXC_posix"))&$length($text(zhorolog^%POSIX)) $$zhorolog^%POSIX quit $horolog
