C0XINIT ; GPL - Fileman Triples initialization routine ;10/13/11  17:05
        ;;0.1;C0X;nopatch;noreleasedate;Build 9
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
CLEAR   ; DELETE THE FILESTORE
        K ^C0X(101)
        K ^C0X(201)
        S ^C0X(101,0)="C0X TRIPLE^172.101I^^"
        S ^C0X(201,0)="C0X STRING^172.201I^^"
        Q
        ;
INIT    ; INITIALIZE THE TRIPLE STORE - THIS DELETES THE GLOBALS AND
        ; START ALL OVER... USE WITH CAUTION
        ;
        ; -- we should be more sophisticated here.. at least warn the user
        ; -- and give them a chance to cancel
        ;
        D CLEAR ; DELETE THE TRIPLESTORE
        ;
        ; -- we are assuming that FARY is set up properly in C0XF2N
        ; -- with repect to the default directory and the defaut fileman files
        ; -- here's what it is now: "/home/vista/gpl/fmts/trunk/samples/"
        ; -- that means that all the sample files will look like:
        ; --- qds/QDS_0001.rdf
        ; --- smart-rdf-in/small.rdf
        ;
        S FARY="C0XFARY"
        D INITFARY^C0XF2N(FARY)
        D USEFARY^C0XF2N(FARY)
        S C0XFARY("C0XDIR")="/home/vista/gpl/fmts/trunk/samples/smart-rdf-in/" ; 
        D USEFARY^C0XF2N(FARY)
        S SMART(1)="cole-susan.rdf"
        S SMART(2)="jones-cynthia.rdf"
        S SMART(3)="small.rdf"
        S SMART(4)="collins-frank.rdf"
        S SMART(5)="kelly-david.rdf"
        S SMART(6)="smith-maria.rdf"
        S SMART(7)="ford-shirley.rdf"
        S SMART(8)="morgan-jason.rdf"
        S SMART(9)="west-lisa.rdf"
        S SMART(10)="gracia-paul.rdf"
        S SMART(11)="reed-richard.rdf"
        S SMART(12)="west-sandra.rdf"
        S SMART(13)="jackson-jessica.rdf"
        S SMART(14)="small-allergies.rdf"
        S SMART(15)="white-patricia.rdf"
        N ZI S ZI=""
        F  S ZI=$O(SMART(ZI)) Q:ZI=""  D  ; for each smart file
        . D IMPORT^C0XF2N(SMART(ZI),C0XDIR,,FARY) ; import to the triplestore
        S FARY="C0XFARY"
        S C0XFARY("C0XDIR")="/home/vista/gpl/fmts/trunk/samples/qds/"
        D USEFARY^C0XF2N(FARY)
        D IMPORT^C0XF2N("QDS_0001.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0028b.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0052.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0073.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0385.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0002.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0031.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0055.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0074.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0387.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0004.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0032.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0056.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0075.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0389.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0012.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0033.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0059.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0081.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0421.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0013.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0034.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0061.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0083.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0575.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0014.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0036.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0062.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0084.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0018.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0038.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0064.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0086.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0024.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0041.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0067.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0088.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0027.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0043.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0068.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0089.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0028a.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0047.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0070.rdf",C0XDIR,,FARY)
        D IMPORT^C0XF2N("QDS_0105.rdf",C0XDIR,,FARY)
        ;D IMPORT^C0XF2N("qds.rdf",C0XDIR,,FARY)
        Q
        ;
