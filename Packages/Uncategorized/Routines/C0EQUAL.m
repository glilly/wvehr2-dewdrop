C0EQUAL  ; C0E/GPL - Quality Reporting UI ; 5/18/11 11:43pm
 ;Copyright 2011 George Lilly
 ;Licensed under the terms of the GNU General Public License.
 ;See attached copy of the License.
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
 ; You should have received a copy of the GNU General Public License along
 ; with this program; if not, write to the Free Software Foundation, Inc.,
 ; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 Q
 ;
muinit(sessid)  ;
 n col,data
 s col(1,"name")="measure"
 s col(1,"header")="Measure"
 s col(2,"name")="denominator"
 s col(2,"header")="Denominator"
 s col(3,"name")="numerator"
 s col(3,"header")="Numerator"
 s col(4,"name")="percent"
 s col(4,"header")="Percent"
 d deleteFromSession^%zewdAPI("colDef",sessid)
 d mergeArrayToSession^%zewdAPI(.col,"colDef",sessid)
 ;
 d GETFM("data") ; get the matrix from the fileman file
 d deleteFromSession^%zewdAPI("meaningfulInfo",sessid)
 d mergeArrayToSession^%zewdAPI(.data,"meaningfulInfo",sessid)
 q ""
 ;
C0QQFN()        Q 1130580001.101 ; FILE NUMBER FOR C0Q QUALITY MEASURE FILE
C0QMFN()        Q 1130580001.201 ; FILE NUMBER FOR C0Q MEASUREMENT FILE
C0QMMFN()       Q 1130580001.2011 ; FN FOR MEASURE SUBFILE
C0QMMNFN()      Q 1130580001.20111 ; FN FOR NUMERATOR SUBFILE
C0QMMDFN()      Q 1130580001.20112 ; FN FOR DENOMINATOR SUBFILE
RLSTFN()        Q 810.5 ; FN FOR REMINDER PATIENT LIST FILE
RLSTPFN()       Q 810.53 ; FN FOR REMINDER PATIENT LIST PATIENT SUBFILE
 ;
GETFM(RTN)      ; GET THE MATRIX VALUES FROM THE FILEMAN FILE
 ;
 N C0EF S C0EF=$$C0QMFN() ; FILE NUMBER FOR C0Q QUAILITY MEASUREMENT
 N C0EFS S C0EFS=$$C0QMMNFN() ; FILE NUMBER FOR MEASURE SUBFILE
 N C0EFM S C0EFM=$$C0QQFN() ; FILE NUMBER C0Q QUALITY MEASURE FILE
 ;
 N ZR S ZR=1 ; USE RECORD NUMBER ONE - FIX THIS
 N GPL
 D LIST^DIC(C0EFS,","_ZR_",",".01;1;2;3",,,,,,,,"GPL") ; GET ALL THE RECORDS
 N ZI S ZI=""
 F  S ZI=$O(GPL("DILIST","ID",ZI)) Q:ZI=""  D  ;
 . S @RTN@(ZI,"measure")=GPL("DILIST","ID",ZI,.01)
 . S @RTN@(ZI,"denominator")=+GPL("DILIST","ID",ZI,2)
 . S @RTN@(ZI,"numerator")=+GPL("DILIST","ID",ZI,1)
 . S @RTN@(ZI,"percent")=+GPL("DILIST","ID",ZI,3)_"%"
 . S @RTN@(ZI,"ien")=ZI
 Q
 ;
