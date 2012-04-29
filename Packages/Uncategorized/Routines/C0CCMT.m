C0CCMT  ; CCDCCR/GPL - CCR/CCD PROCESSING FOR COMMENTS ; 05/21/10
 ;;1.0;C0C;;May 21, 2010;Build 2
 ;Copyright 2010 George Lilly, University of Minnesota and others.
 ;Licensed under the terms of the GNU General Public License.
 ;See attached copy of the License.
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
 W "NO ENTRY FROM TOP",!
 Q
 ;
EXTRACT(NOTEXML,DFN,NOTEOUT) ; EXTRACT NOTES INTO  XML TEMPLATE
 ; NOTEXML AND NOTEOUT ARE PASSED BY NAME SO GLOBALS CAN BE USED
 ;
 D SETVARS^C0CPROC ; SET UP VARIABLES FOR PROCEDUCRES, ENCOUNTERS, AND NOTES
 ;I '$D(@C0CNTE) Q  ; NO NOTES AVAILABLE
 D MAP(NOTEXML,C0CNTE,NOTEOUT) ;MAP RESULTS FOR NOTES
 Q
 ;
MAP(NOTEXML,C0CNTE,NOTEOUT) ; MAP PROCEDURES XML
 ;
 N ZTEMP S ZTEMP=$NA(^TMP("C0CCCR",$J,DFN,"NOTETEMP")) ;WORK AREA FOR TEMPLATE
 K @ZTEMP
 N ZBLD
 S ZBLD=$NA(^TMP("C0CCCR",$J,DFN,"NOTEBLD")) ; BUILD LIST AREA
 D QUEUE^C0CXPATH(ZBLD,NOTEXML,1,1) ; FIRST LINE
 N ZINNER
 D QUERY^C0CXPATH(NOTEXML,"//Comments/Comment","ZINNER") ;ONE NOTE
 N ZTMP,ZVAR,ZI
 S ZI=""
 F  S ZI=$O(@C0CNTE@(ZI)) Q:ZI=""  D  ;FOR EACH NOTE
 . S ZTMP=$NA(@ZTEMP@(ZI)) ;THIS NOTE XML
 . S ZVAR=$NA(@C0CNTE@(ZI)) ;THIS NOTE VARIABLES
 . D MAP^C0CXPATH("ZINNER",ZVAR,ZTMP) ; MAP THE PROCEDURE
 . N ZNOTE,ZN
 . D CLEAN($NA(@C0CNTE@(ZI,"TEXT"))) ;REMOVE CONTROL CHARS AND XML RESERVED
 . M ZNOTE=@C0CNTE@(ZI,"TEXT") ;THE NOTE TO ADD TO THE BUILD
 . S ZNOTE(0)=$O(ZNOTE(""),-1) ;LENGTH OF THE NOTE
 . D INSERT^C0CXPATH(ZTMP,"ZNOTE","//Comment/Description/Text")
 . D QUEUE^C0CXPATH(ZBLD,ZTMP,1,@ZTMP@(0)) ;QUE FOR BUILD
 D QUEUE^C0CXPATH(ZBLD,NOTEXML,@NOTEXML@(0),@NOTEXML@(0))
 N ZZTMP
 D BUILD^C0CXPATH(ZBLD,NOTEOUT) ;BUILD FINAL XML
 K @ZTEMP,@ZBLD,@C0CNTE
 Q
 ;
CLEAN(INARY) ; INARY IS PASSED BY NAME
 ; REMOVE CONTROL CHARACTERS AND XML RESERVED SYMBOLS FROM THE ARRAY
 N ZI,ZJ S ZI=""
 F  S ZI=$O(@INARY@(ZI)) Q:ZI=""  D  ;
 . S @INARY@(ZI)=$$CLEAN^C0CXPATH(@INARY@(ZI)) ; CONTROL CHARS
 . S @INARY@(ZI)=$$SYMENC^MXMLUTL(@INARY@(ZI)) ; XML RESERVED SYMBOLS
 Q
 ;
