C0CIMMU ; CCDCCR/GPL - CCR/CCD PROCESSING FOR IMMUNIZATIONS ; 2/2/09
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2008,2009 George Lilly, University of Minnesota.
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
        ;
        ; PROCESS THE IMMUNIZATIONS SECTION OF THE CCR
        ;
MAP(IPXML,DFN,OUTXML)   ; MAP IMMUNIZATIONS
        ;
        N C0CZV,C0CZVI ; TO STORE MAPPED VARIABLES
        N C0CZT ; TMP ARRAY OF MAPPED XML
        S C0CZV=$NA(^TMP("C0CCCR",$J,"IMMUNE")) ; TEMP STORAGE FOR VARIABLES
        D EXTRACT(IPXML,DFN,OUTXML) ;EXTRACT THE VARIABLES
        N C0CZI,C0CZIC ; COUNT OF IMMUNIZATIONS
        S C0CZIC=$G(@C0CZV@(0)) ; TOTAL FROM VARIABLE ARRAY
        I C0CZIC>0 D  ;IMMUNIZATIONS FOUND
        . F C0CZI=1:1:C0CZIC D  ;FOR EACH IMMUNIZATION
        . . S C0CZVI=$NA(@C0CZV@(C0CZI)) ;THIS IMMUNIZATION
        . . D MAP^C0CXPATH(IPXML,C0CZVI,"C0CZT") ;MAP THE VARIABLES TO XML
        . . I C0CZI=1 D  ; FIRST ONE
        . . . D CP^C0CXPATH("C0CZT",OUTXML) ;JUST COPY RESULTS
        . . E  D  ;NOT THE FIRST
        . . . D INSINNER^C0CXPATH(OUTXML,"C0CZT")
        E  S @OUTXML@(0)=0 ; SIGNAL NO IMMUNIZATIONS
        N IMMUTMP,I
        D MISSING^C0CXPATH(OUTXML,"IMMUTMP") ; SEARCH XML FOR MISSING VARS
        I IMMUTMP(0)>0  D  ; IF THERE ARE MISSING VARS -
        . ; STRINGS MARKED AS @@X@@
        . W !,"IMMUNE Missing list: ",!
        . F I=1:1:IMMUTMP(0) W IMMUTMP(I),!
        Q
        ;
EXTRACT(IPXML,DFN,OUTXML)       ; EXTRACT IMMUNIZATIONS INTO VARIABLES
        ;
        ; INXML AND OUTXML ARE PASSED BY NAME SO GLOBALS CAN BE USED
        ; INXML WILL CONTAIN ONLY THE PROBLEM SECTION OF THE OVERALL TEMPLATE
        ; ONLY THE XML FOR ONE PROBLEM WILL BE PASSED. THIS ROUTINE WILL MAKE
        ; COPIES AS NECESSARY TO REPRESENT MULTIPLE PROBLEMS
        ; INSERT^C0CXPATH IS USED TO APPEND THE PROBLEMS TO THE OUTPUT
        ;
        N RPCRSLT,J,K,PTMP,X,VMAP,TBU
        S TVMAP=$NA(^TMP("C0CCCR",$J,"IMMUNE"))
        S TARYTMP=$NA(^TMP("C0CCCR",$J,"IMMUARYTMP"))
        S IMMA=$NA(^TMP("PXI",$J)) ;
        K @IMMA ; CLEAR OUT PREVIOUS RESULTS
        K @TVMAP,@TARYTMP ; KILL OLD ARRAY VALUES
        D IMMUN^PXRHS03(DFN) ;
        I $O(@IMMA@(""))="" D  Q  ; RPC RETURNS NULL
        . W "NULL RESULT FROM IMMUN^PXRHS03 ",!
        . S @TVMAP@(0)=0
        N C0CIM,C0CC,C0CIMD,C0CIEN,C0CT ;
        S C0CIM=""
        S C0CC=0 ; COUNT
        F  S C0CIM=$O(@IMMA@(C0CIM)) Q:C0CIM=""  D  ; FOR EACH IMMUNE TYPE IN THE LIST
        . S C0CC=C0CC+1 ;INCREMENT COUNT
        . S @TVMAP@(0)=C0CC ; SAVE NEW COUNT TO ARRAY
        . S VMAP=$NA(@TVMAP@(C0CC)) ; THIS IMMUNE ELEMENT
        . K @VMAP ; MAKE SURE IT IS CLEARED OUT
        . W C0CIM,!
        . S C0CIMD="" ; IMMUNE DATE
        . F  S C0CIMD=$O(@IMMA@(C0CIM,C0CIMD)) Q:C0CIMD=""  D  ; FOR EACH DATE
        . . S C0CIEN=$O(@IMMA@(C0CIM,C0CIMD,"")) ;IEN OF IMMUNE RECORD
        . . D GETN^C0CRNF("C0CI",9000010.11,C0CIEN) ; GET THE FILEMAN RECORD FOR IENS
        . . W C0CIEN,"_",C0CIMD
        . . S C0CT=$$FMDTOUTC^C0CUTIL(9999999-C0CIMD,"DT") ; FORMAT DATE/TIME
        . . W C0CT,!
        . . S @VMAP@("IMMUNEOBJECTID")="IMMUNIZATION_"_C0CC ;UNIQUE OBJECT ID
        . . S @VMAP@("IMMUNEDATETIMETYPETEXT")="Immunization Date" ; ALL ARE THE SAME
        . . S @VMAP@("IMMUNEDATETIME")=C0CT ;FORMATTED DATE/TIME
        . . S C0CIP=$$ZVALUEI^C0CRNF("ENCOUNTER PROVIDER","C0CI") ;IEN OF PROVIDER
        . . S @VMAP@("IMMUNESOURCEACTORID")="ACTORPROVIDER_"_C0CIP
        . . S C0CIIEN=$$ZVALUEI^C0CRNF("IMMUNIZATION","C0CI") ;IEN OF IMMUNIZATION
        . . I $G(DUZ("AG"))="I" D  ; RUNNING IN RPMS
        . . . D GETN^C0CRNF("C0CZIM",9999999.14,C0CIIEN) ;GET IMMUNE RECORD
        . . . S C0CIN=$$ZVALUE^C0CRNF("NAME","C0CZIM") ; USE NAME IN IMMUNE RECORD
        . . . ; FOR LOOKING UP THE CODE
        . . . ; GET IT FROM THE CODE FILE
        . . . S C0CICD=$$ZVALUE^C0CRNF("HL7-CVX CODE","C0CZIM") ;CVX CODE
        . . . S @VMAP@("IMMUNEPRODUCTNAMETEXT")=C0CIN ;NAME
        . . . S @VMAP@("IMMUNEPRODUCTCODE")=C0CICD ; CVX CODE
        . . . I C0CICD'="" S @VMAP@("IMMUNEPRODUCTCODESYSTEM")="CDC Vaccine Code" ;
        . . . E  S @VMAP@("IMMUNEPRODUCTCODESYSTEM")="" ;NULL
        . . E  D  ; NOT IN RPMS
        . . . S C0CIN=$$ZVALUE^C0CRNF("IMMUNIZATION","C0CI") ;NAME OF IMMUNIZATION
        . . . S @VMAP@("IMMUNEPRODUCTNAMETEXT")=C0CIN ;NAME
        . . . S @VMAP@("IMMUNEPRODUCTCODE")="" ; CVX CODE
        . . . S @VMAP@("IMMUNEPRODUCTCODESYSTEM")="" ;NO CODE
        N C0CIRIM S C0CIRIM=$NA(^TMP("C0CRIM","VARS",DFN,"IMMUNE"))
        M @C0CIRIM=@TVMAP ; PERSIST RIM VARIABLES
        Q
        ;
