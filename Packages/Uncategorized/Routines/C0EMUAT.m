C0EMUAT  ; C0E/GPL - Meaningful use attestation application ; 9/28/11 12:59pm
 ;Copyright 2008,2009 George Lilly, University of Minnesota.
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
muinit(sessid) ;
 n measet
 s measet=8 ; fix this.. it is the Meaningful Use measure set ien
 d tblinit(measet,"meaningful")
 q ""
 ;
qinit(sessid) ;
 n measet
 s measet=5 ; fix this.. it is the Hospital Meaningful use quality measure set
 d tblinit(measet,"quality")
 q ""
 ;
tblinit(setien,id) ; initialize the ewd tables for measure set ien setien
 n col,data
   s col(1,"name")="measure"
   s col(1,"header")="Measure"
   s col(2,"name")="denominator"
   s col(2,"header")="Denominator"
   s col(3,"name")="numerator"
   s col(3,"header")="Numerator"
   s col(4,"name")="percent"
   s col(4,"header")="Percent"
   d deleteFromSession^%zewdAPI(id_"ColDef",sessid)
   d mergeArrayToSession^%zewdAPI(.col,id_"ColDef",sessid)
   ;
   d GETFM("data",setien) ; get the matrix from the fileman file
   d deleteFromSession^%zewdAPI(id_"Info",sessid)
   d mergeArrayToSession^%zewdAPI(.data,id_"Info",sessid)
 q
 ;
C0QQFN() Q 1130580001.101 ; FILE NUMBER FOR C0Q QUALITY MEASURE FILE
C0QMFN() Q 1130580001.201 ; FILE NUMBER FOR C0Q MEASUREMENT FILE
C0QMMFN() Q 1130580001.2011 ; FN FOR MEASURE SUBFILE
C0QMMNFN() Q 1130580001.20111 ; FN FOR NUMERATOR SUBFILE
C0QMMDFN() Q 1130580001.20112 ; FN FOR DENOMINATOR SUBFILE
GETFM(RTN,SETIEN) ; GET THE MATRIX VALUES FROM THE FILEMAN FILE
   ;
 N C0EF S C0EF=1130592222.202 ; FILE NUMBER FOR THE C0E MU MEASURE SET FILE
 ;N C0EF S C0EF=$$C0QMFN()
 ;N C0EFS S C0EFS=1130592222.2021 ; FILE NUMBER FOR THE MEASURE SUBFILE
 N C0EFS S C0EFS=$$C0QMMFN()
 ;N C0EFM S C0EFM=1130592222.101 ; FILE NUMBER FOR THE MEASURE FILE
 N C0EFM S C0EFM=$$C0QQFN()
 ;
 N ZR S ZR=SETIEN ;
 N GPL
 ;D LIST^DIC(C0EFS,","_ZR_",",".01;1;2;3",,,,,,,,"GPL") ; GET ALL THE RECORDS
 D LIST^DIC(C0EFS,","_ZR_",",".01I;1.1;2.1",,,,,,,,"GPL") ; GET ALL THE RECORDS
 N ZN
 N ZI S ZI=""
 F  S ZI=$O(GPL("DILIST","ID",ZI)) Q:ZI=""  D  ;
 . S ZN=$$GET1^DIQ(C0EFM,GPL("DILIST","ID",ZI,.01)_",",.7,"E")
 . S @RTN@(ZI,"measure")=ZN
 . N ZNUM,ZDEM,ZPCT
 . S ZPCT=0
 . S @RTN@(ZI,"denominator")=+GPL("DILIST","ID",ZI,2.1)
 . S ZDEM=+GPL("DILIST","ID",ZI,2.1)
 . S @RTN@(ZI,"numerator")=+GPL("DILIST","ID",ZI,1.1)
 . S ZNUM=+GPL("DILIST","ID",ZI,1.1)
 . ;S @RTN@(ZI,"percent")=+GPL("DILIST","ID",ZI,3)_"%"
 . I ZDEM>0 S ZPCT=((ZNUM*100)/ZDEM)
 . S @RTN@(ZI,"percent")=$P(ZPCT,".",1)_"%"
 . S @RTN@(ZI,"ien")=ZI
 Q
 ;
