C0EIN ;KBAZ/ZAG,CCDCCR/GPL - CCD/CCR Import Utility ; 9/29/11 8:44pm
 ;;1.0;C0C;;Sep 20, 2009;Build 3
 ;
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
SAVE(DFN,DUZ,FROM,INST,SRC,TYPE,ARRAY)
 K ^XMLTMP
 M ^XMLTMP("CCR")=ARRAY
 N XML S XML=$NA(^XMLTMP("CCR"))
 ;
 N RTN S RTN=""
 I '$D(INST) S INST="WorldVistA" ;test organization
 I '$D(TYPE) S TYPE="CCR" ;type of XML document
 I '$D(SRC) S SOURCE="ZAGTEST" ;source of CCR
 D IMPORT(RTN,DFN,DUZ,FROM,INST,SOURCE,TYPE,XML)
 ;
 QUIT  ;end of SAVE
 ;
 ;
IMPORT(RTN,DFN,DUZ,FROM,INST,SRC,TYP,ARY) ;File XML document into database
 I $G(DFN)="" S RTN="Patient not selected" Q  ;exit if not patient
 N C0EFILE S C0EFILE=175
 N C0EFDA,ZX
 S C0EFDA(C0EFILE,"+1,",.01)=DFN ;patient
 S C0EFDA(C0EFILE,"+1,",.02)=DUZ ;importing user
 S C0EFDA(C0EFILE,"+1,",1)=$$NOW^XLFDT ;date imported
 S C0EFDA(C0EFILE,"+1,",2)=TYP ;document type
 S C0EFDA(C0EFILE,"+1,",3)=$$ADDSRC(SRC) ;SOURCE
 ;S C0EFDA(C0EFILE,"+1,",7)="NEW" ;status field reserved for future use
 S C0EFDA(C0EFILE,"+1,",9)=FROM ;sending email address
 S C0EFDA(C0EFILE,"+1,",10)=INST ;sending institution
 D UPDIE ;file record
 S ZX=C0CIEN(1) ;get record number
 D WP^DIE(C0EFILE,ZX_",",4,,ARY,"ZERR")
 S RTN=ZX ;return IEN of xml file
 ;
 QUIT  ;end of  IN
 ;
 ;
ADDSRC(ZSRC) ;Extrinsic to add a source to the CCR source file returns
 ;record number. If source exists, just returns it's record number.
 ;
 N ZX,ZF,C0EFDA
 S ZF=171.401 ;file number for CCR source file
 S C0EFDA(ZF,"?+1,",.01)=ZSRC
 D UPDIE
 Q $O(^C0C(171.401,"B",ZSRC,""))
 ;
 ;
UPDIE ;Internal routine to call UPDATE^DIE and check for errors
 K ZERR,C0CIEN
 D CLEAN^DILF
 D UPDATE^DIE("","C0EFDA","C0CIEN","ZERR")
 I $D(ZERR) D  ;
 . W "ERROR",!
 . ZWR ZERR
 . B
 K C0EFDA
 ;
 QUIT  ;end of UPDIE
 ;
 ;
ADDRBOOK(prefix,options) ;create address book from "C0ESADDR" x-ref
 N U S U="^"
 N I
 N C0EADLST S C0EADLST="" ;address book list
 N C0EADDR S C0EADDR="" ;email address
 F I=1:1  D  Q:C0EADDR=""
 . S C0EADDR=$O(^VA(200,"B",C0EADDR)) ;addresses in x-ref
 . Q:C0EADDR=""
 . S C0EADLST(I)=C0EADDR
 N CNT S CNT=I-1
 ;
 S prefix=$$zcvt^%zewdAPI(prefix,"U")
 N I,N S I=0,N=1 F  S I=$O(C0EADLST(I)) D  Q:I=""!(N>CNT)
 . I prefix'="",$E($G(C0EADLST(I)),1,$L(prefix))'=prefix Q
 . S options(N)=C0EADLST(I)
 . S options(N)=$$replaceAll^%zewdAPI(options(N),"""","'")
 . S N=N+1
 ;
 QUIT  ;end of ADDRBOOK
 ;
 ;
END ;end of C0EIN
