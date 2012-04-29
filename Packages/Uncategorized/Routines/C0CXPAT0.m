C0CXPAT0   ; CCDCCR/GPL - XPATH TEST CASES ; 6/1/08
 ;;1.0;C0C;;May 19, 2009;Build 2
 ;Copyright 2008 George Lilly.  Licensed under the terms of the GNU
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
        W "NO ENTRY",!
        Q
        ;
 ;;><TEST>
 ;;><INIT>
 ;;>>>K C0C S C0C=""
 ;;>>>D PUSH^C0CXPATH("C0C","FIRST")
 ;;>>>D PUSH^C0CXPATH("C0C","SECOND")
 ;;>>>D PUSH^C0CXPATH("C0C","THIRD")
 ;;>>>D PUSH^C0CXPATH("C0C","FOURTH")
 ;;>>?C0C(0)=4
 ;;><INITXML>
 ;;>>>K GXML S GXML=""
 ;;>>>D PUSH^C0CXPATH("GXML","<FIRST>")
 ;;>>>D PUSH^C0CXPATH("GXML","<SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","<THIRD>")
 ;;>>>D PUSH^C0CXPATH("GXML","<FOURTH>@@DATA1@@</FOURTH>")
 ;;>>>D PUSH^C0CXPATH("GXML","<FIFTH>")
 ;;>>>D PUSH^C0CXPATH("GXML","@@DATA2@@")
 ;;>>>D PUSH^C0CXPATH("GXML","</FIFTH>")
 ;;>>>D PUSH^C0CXPATH("GXML","<SIXTH ID=""SELF"" />")
 ;;>>>D PUSH^C0CXPATH("GXML","</THIRD>")
 ;;>>>D PUSH^C0CXPATH("GXML","<SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","</SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","</SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","</FIRST>")
 ;;><INITXML2>
 ;;>>>K GXML S GXML=""
 ;;>>>D PUSH^C0CXPATH("GXML","<FIRST>")
 ;;>>>D PUSH^C0CXPATH("GXML","<SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","<THIRD>")
 ;;>>>D PUSH^C0CXPATH("GXML","<FOURTH>DATA1</FOURTH>")
 ;;>>>D PUSH^C0CXPATH("GXML","<FOURTH>")
 ;;>>>D PUSH^C0CXPATH("GXML","DATA2")
 ;;>>>D PUSH^C0CXPATH("GXML","</FOURTH>")
 ;;>>>D PUSH^C0CXPATH("GXML","</THIRD>")
 ;;>>>D PUSH^C0CXPATH("GXML","<_SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","<FOURTH>DATA3</FOURTH>")
 ;;>>>D PUSH^C0CXPATH("GXML","</_SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","</SECOND>")
 ;;>>>D PUSH^C0CXPATH("GXML","</FIRST>")
 ;;><PUSHPOP>
 ;;>>>D ZLOAD^C0CUNIT("ZTMP","C0CXPAT0")
 ;;>>>D ZTEST^C0CUNIT(.ZTMP,"INIT")
 ;;>>?C0C(C0C(0))="FOURTH"
 ;;>>>D POP^C0CXPATH("C0C",.GX)
 ;;>>?GX="FOURTH"
 ;;>>?C0C(C0C(0))="THIRD"
 ;;>>>D POP^C0CXPATH("C0C",.GX)
 ;;>>?GX="THIRD"
 ;;>>?C0C(C0C(0))="SECOND"
 ;;><MKMDX>
 ;;>>>D ZLOAD^C0CUNIT("ZTMP","C0CXPAT0")
 ;;>>>D ZTEST^C0CUNIT(.ZTMP,"INIT")
 ;;>>>S GX=""
 ;;>>>D MKMDX^C0CXPATH("C0C",.GX)
 ;;>>?GX="//FIRST/SECOND/THIRD/FOURTH"
 ;;><XNAME>
 ;;>>?$$XNAME^C0CXPATH("<FOURTH>DATA1</FOURTH>")="FOURTH"
 ;;>>?$$XNAME^C0CXPATH("<SIXTH  ID=""SELF"" />")="SIXTH"
 ;;>>?$$XNAME^C0CXPATH("</THIRD>")="THIRD"
 ;;><INDEX>
 ;;>>>D ZLOAD^C0CUNIT("ZTMP","C0CXPAT0")
 ;;>>>D ZTEST^C0CUNIT(.ZTMP,"INITXML")
 ;;>>>D INDEX^C0CXPATH("GXML")
 ;;>>?GXML("//FIRST/SECOND")="2^12"
 ;;>>?GXML("//FIRST/SECOND/THIRD")="3^9"
 ;;>>?GXML("//FIRST/SECOND/THIRD/FIFTH")="5^7"
 ;;>>?GXML("//FIRST/SECOND/THIRD/FOURTH")="4^4^@@DATA1@@"
 ;;>>?GXML("//FIRST/SECOND/THIRD/SIXTH")="8^8^"
 ;;>>?GXML("//FIRST/SECOND")="2^12"
 ;;>>?GXML("//FIRST")="1^13"
 ;;><INDEX2>
 ;;>>>D ZTEST^C0CXPATH("INITXML2")
 ;;>>>D INDEX^C0CXPATH("GXML")
 ;;>>?GXML("//FIRST/SECOND")="2^12"
 ;;>>?GXML("//FIRST/SECOND/_SECOND")="9^11"
 ;;>>?GXML("//FIRST/SECOND/_SECOND/FOURTH")="10^10^DATA3"
 ;;>>?GXML("//FIRST/SECOND/THIRD")="3^8"
 ;;>>?GXML("//FIRST/SECOND/THIRD/FOURTH[1]")="4^4^DATA1"
 ;;>>?GXML("//FIRST")="1^13"
 ;;><MISSING>
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>S OUTARY="^TMP($J,""MISSINGTEST"")"
 ;;>>>D MISSING^C0CXPATH("GXML",OUTARY)
 ;;>>?@OUTARY@(1)="DATA1"
 ;;>>?@OUTARY@(2)="DATA2"
 ;;><MAP>
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>S MAPARY="^TMP($J,""MAPVALUES"")"
 ;;>>>S OUTARY="^TMP($J,""MAPTEST"")"
 ;;>>>S @MAPARY@("DATA2")="VALUE2"
 ;;>>>D MAP^C0CXPATH("GXML",MAPARY,OUTARY)
 ;;>>?@OUTARY@(6)="VALUE2"
 ;;><MAP2>
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>S MAPARY="^TMP($J,""MAPVALUES"")"
 ;;>>>S OUTARY="^TMP($J,""MAPTEST"")"
 ;;>>>S @MAPARY@("DATA1")="VALUE1"
 ;;>>>S @MAPARY@("DATA2")="VALUE2"
 ;;>>>S @MAPARY@("DATA3")="VALUE3"
 ;;>>>S GXML(4)="<FOURTH>@@DATA1@@ AND @@DATA3@@</FOURTH>"
 ;;>>>D MAP^C0CXPATH("GXML",MAPARY,OUTARY)
 ;;>>>D PARY^C0CXPATH(OUTARY)
 ;;>>?@OUTARY@(4)="<FOURTH>VALUE1 AND VALUE3</FOURTH>"
 ;;><QUEUE>
 ;;>>>D QUEUE^C0CXPATH("BTLIST","GXML",2,3)
 ;;>>>D QUEUE^C0CXPATH("BTLIST","GXML",4,5)
 ;;>>?$P(BTLIST(2),";",2)=4
 ;;><BUILD>
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QUERY^C0CXPATH("GXML","//FIRST/SECOND/THIRD/FOURTH","G2")
 ;;>>>D ZTEST^C0CXPATH("QUEUE")
 ;;>>>D BUILD^C0CXPATH("BTLIST","G3")
 ;;><CP>
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D CP^C0CXPATH("GXML","G2")
 ;;>>?G2(0)=13
 ;;><QOPEN>
 ;;>>>K G2,GBL
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QOPEN^C0CXPATH("GBL","GXML")
 ;;>>?$P(GBL(1),";",3)=12
 ;;>>>D BUILD^C0CXPATH("GBL","G2")
 ;;>>?G2(G2(0))="</SECOND>"
 ;;><QOPEN2>
 ;;>>>K G2,GBL
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QOPEN^C0CXPATH("GBL","GXML","//FIRST/SECOND")
 ;;>>?$P(GBL(1),";",3)=11
 ;;>>>D BUILD^C0CXPATH("GBL","G2")
 ;;>>?G2(G2(0))="</SECOND>"
 ;;><QCLOSE>
 ;;>>>K G2,GBL
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QCLOSE^C0CXPATH("GBL","GXML")
 ;;>>?$P(GBL(1),";",3)=13
 ;;>>>D BUILD^C0CXPATH("GBL","G2")
 ;;>>?G2(G2(0))="</FIRST>"
 ;;><QCLOSE2>
 ;;>>>K G2,GBL
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QCLOSE^C0CXPATH("GBL","GXML","//FIRST/SECOND/THIRD")
 ;;>>?$P(GBL(1),";",3)=13
 ;;>>>D BUILD^C0CXPATH("GBL","G2")
 ;;>>?G2(G2(0))="</FIRST>"
 ;;>>?G2(1)="</THIRD>"
 ;;><INSERT>
 ;;>>>K G2,GBL,G3,G4
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QUERY^C0CXPATH("GXML","//FIRST/SECOND/THIRD/FIFTH","G2")
 ;;>>>D INSERT^C0CXPATH("GXML","G2","//FIRST/SECOND/THIRD")
 ;;>>>D INSERT^C0CXPATH("G3","G2","//")
 ;;>>?G2(1)=GXML(9)
 ;;><REPLACE>
 ;;>>>K G2,GBL,G3
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QUERY^C0CXPATH("GXML","//FIRST/SECOND/THIRD/FIFTH","G2")
 ;;>>>D REPLACE^C0CXPATH("GXML","G2","//FIRST/SECOND")
 ;;>>?GXML(2)="<FIFTH>"
 ;;><INSINNER>
 ;;>>>K GXML,G2,GBL,G3
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QUERY^C0CXPATH("GXML","//FIRST/SECOND/THIRD","G2")
 ;;>>>D INSINNER^C0CXPATH("GXML","G2","//FIRST/SECOND/THIRD")
 ;;>>?GXML(10)="<FIFTH>"
 ;;><INSINNER2>
 ;;>>>K GXML,G2,GBL,G3
 ;;>>>D ZTEST^C0CXPATH("INITXML")
 ;;>>>D QUERY^C0CXPATH("GXML","//FIRST/SECOND/THIRD","G2")
 ;;>>>D INSINNER^C0CXPATH("G2","G2")
 ;;>>?G2(8)="<FIFTH>"
 ;;><PUSHA>
 ;;>>>K GTMP,GTMP2
 ;;>>>N GTMP,GTMP2
 ;;>>>D PUSH^C0CXPATH("GTMP","A")
 ;;>>>D PUSH^C0CXPATH("GTMP2","B")
 ;;>>>D PUSH^C0CXPATH("GTMP2","C")
 ;;>>>D PUSHA^C0CXPATH("GTMP","GTMP2")
 ;;>>?GTMP(3)="C"
 ;;>>?GTMP(0)=3
 ;;><H2ARY>
 ;;>>>K GTMP,GTMP2
 ;;>>>S GTMP("TEST1")=1
 ;;>>>D H2ARY^C0CXPATH("GTMP2","GTMP")
 ;;>>?GTMP2(0)=1
 ;;>>?GTMP2(1)="^TEST1^1"
 ;;><XVARS>
 ;;>>>K GTMP,GTMP2
 ;;>>>D PUSH^C0CXPATH("GTMP","<VALUE>@@VAR1@@</VALUE>")
 ;;>>>D XVARS^C0CXPATH("GTMP2","GTMP")
 ;;>>?GTMP2(1)="^VAR1^1"
 ;;></TEST>
