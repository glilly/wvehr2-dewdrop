C0CPROBS        ; CCDCCR/GPL/CJE - CCR/CCD PROCESSING FOR PROBLEMS ; 6/6/08
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
        ; PROCESS THE PROBLEMS SECTION OF THE CCR
        ;
EXTRACT(IPXML,DFN,OUTXML)       ; EXTRACT PROBLEMS INTO PROVIDED XML TEMPLATE
        ;
        ; INXML AND OUTXML ARE PASSED BY NAME SO GLOBALS CAN BE USED
        ; INXML WILL CONTAIN ONLY THE PROBLEM SECTION OF THE OVERALL TEMPLATE
        ; ONLY THE XML FOR ONE PROBLEM WILL BE PASSED. THIS ROUTINE WILL MAKE
        ; COPIES AS NECESSARY TO REPRESENT MULTIPLE PROBLEMS
        ; INSERT^C0CXPATH IS USED TO APPEND THE PROBLEMS TO THE OUTPUT
        ;
        N RPCRSLT,J,K,PTMP,X,VMAP,TBU
        S TVMAP=$NA(^TMP("C0CCCR",$J,"PROBVALS"))
        S TARYTMP=$NA(^TMP("C0CCCR",$J,"PROBARYTMP"))
        K @TVMAP,@TARYTMP ; KILL OLD ARRAY VALUES
        I $$RPMS^C0CUTIL() D RPMS ; IF BGOPRB ROUTINE IS MISSING (IE RPMS)
        I ($$VISTA^C0CUTIL())!($$WV^C0CUTIL())!($$OV^C0CUTIL()) D VISTA QUIT
        Q
        ;
RPMS    ; GETS THE PROBLEM LIST FOR RPMS
        S RPCGLO=$NA(^TMP("BGO",$J))
        D GET^BGOPROB(.RPCRSLT,DFN) ; CALL THE PROBLEM LIST RPC
        ; FORMAT OF RPC:
        ;   Number Code [1] ^ Patient IEN [2] ^ ICD Code [3] ^ Modify Date [4] ^ Class [5] ^ Provider Narrative [6] ^
        ;   Date Entered [7] ^ Status [8] ^ Date Onset [9] ^ Problem IEN [10] ^ Notes [11] ^ ICD9 IEN [12] ^
        ;   ICD9 Short Name [13] ^ Provider [14] ^ Facility IEN [15] ^ Priority [16]
        I '$D(@RPCGLO) W "NULL RESULT FROM GET^BGOPROB ",! S @OUTXML@(0)=0 Q
        S J=""
        F  S J=$O(@RPCGLO@(J)) Q:J=""  D  ; FOR EACH PROBLEM IN THE LIST
        . S VMAP=$NA(@TVMAP@(J))
        . K @VMAP
        . I DEBUG W "VMAP= ",VMAP,!
        . S PTMP=@RPCRSLT@(J) ; PULL OUT PROBLEM FROM RPC RETURN ARRAY
        . N C0CG1,C0CT ; ARRAY FOR VALUES FROM GLOBAL
        . D GETN1^C0CRNF("C0CG1",9000011,$P(PTMP,U,10),"") ;GET VALUES BY NAME
        . S @VMAP@("PROBLEMOBJECTID")="PROBLEM"_J ; UNIQUE OBJID FOR PROBLEM
        . S @VMAP@("PROBLEMIEN")=$P(PTMP,U,10)
        . S @VMAP@("PROBLEMSTATUS")=$S($P(PTMP,U,8)="A":"Active",$P(PTMP,U,8)="I":"Inactive",1:"")
        . S @VMAP@("PROBLEMDESCRIPTION")=$P(PTMP,U,6)
        . S @VMAP@("PROBLEMCODINGVERSION")=""
        . S @VMAP@("PROBLEMCODEVALUE")=$P(PTMP,U,3)
        . ; FOR CERTIFICATION - GPL
        . I @VMAP@("PROBLEMCODEVALUE")=493.90 S @VMAP@("PROBLEMCODEVALUE")=493
        . S @VMAP@("PROBLEMDATEOFONSET")=$$FMDTOUTC^C0CUTIL($$ZVALUEI^C0CRNF("DATE OF ONSET","C0CG1"),"DT")
        . S @VMAP@("PROBLEMDATEMOD")=$$FMDTOUTC^C0CUTIL($$ZVALUEI^C0CRNF("DATE LAST MODIFIED","C0CG1"),"DT")
        . ;S @VMAP@("PROBLEMSC")=$P(PTMP,U,7) ;UNKNOWN NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMSE")=$P(PTMP,U,8) ;UNKNOWN NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMCONDITION")=$P(PTMP,U,9) ;NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMLOC")=$P(PTMP,U,10) ;NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMLOCTYPE")=$P(PTMP,U,11) ;NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMPROVIDER")=$P(PTMP,U,12) ;NOT MAPPED IN C0CCCR0
        . ;S X=@VMAP@("PROBLEMPROVIDER") ; FORMAT Y;NAME Y IS IEN OF PROVIDER
        . S @VMAP@("PROBLEMSOURCEACTORID")="ACTORPROVIDER_"_$$ZVALUEI^C0CRNF("RECORDING PROVIDER","C0CG1")
        . ;S @VMAP@("PROBLEMSERVICE")=$P(PTMP,U,13) ;NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMHASCMT")=$P(PTMP,U,14) ;NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMDTREC")=$$FMDTOUTC^C0CUTIL($P(PTMP,U,15),"DT") ;NOT MAPPED IN C0CCCR0
        . ;S @VMAP@("PROBLEMINACT")=$$FMDTOUTC^C0CUTIL($P(PTMP,U,16),"DT") ;NOT MAPPED IN C0CCCR0
        . S ARYTMP=$NA(@TARYTMP@(J))
        . ; W "ARYTMP= ",ARYTMP,!
        . K @ARYTMP
        . D MAP^C0CXPATH(IPXML,VMAP,ARYTMP) ;
        . I J=1 D  ; FIRST ONE IS JUST A COPY
        . . ; W "FIRST ONE",!
        . . D CP^C0CXPATH(ARYTMP,OUTXML)
        . . ; W "OUTXML ",OUTXML,!
        . I J>1 D  ; AFTER THE FIRST, INSERT INNER XML
        . . D INSINNER^C0CXPATH(OUTXML,ARYTMP)
        ; ZWR ^TMP("C0CCCR",$J,"PROBVALS",*)
        ; ZWR ^TMP("C0CCCR",$J,"PROBARYTMP",*) ; SHOW THE RESULTS
        ; ZWR @OUTXML
        ; $$HTML^DILF(
        ; GENERATE THE NARITIVE HTML FOR THE CCD
        I CCD D CCD ; IF THIS IS FOR A CCD
        D MISSINGVARS
        Q
        ;
VISTA   ; GETS THE PROBLEM LIST FOR VISTA
        D LIST^ORQQPL3(.RPCRSLT,DFN,"") ; CALL THE PROBLEM LIST RPC
        I '$D(RPCRSLT(1)) D  Q  ; RPC RETURNS NULL
        . W "NULL RESULT FROM LIST^ORQQPL3 ",!
        . S @OUTXML@(0)=0
        . ; Q
        ; I DEBUG ZWR RPCRSLT
        S @TVMAP@(0)=RPCRSLT(0) ; SAVE NUMBER OF PROBLEMS
        F J=1:1:RPCRSLT(0)  D  ; FOR EACH PROBLEM IN THE LIST
        . S VMAP=$NA(@TVMAP@(J))
        . K @VMAP
        . I DEBUG W "VMAP= ",VMAP,!
        . S PTMP=RPCRSLT(J) ; PULL OUT PROBLEM FROM RPC RETURN ARRAY
        . S @VMAP@("PROBLEMOBJECTID")="PROBLEM"_J ; UNIQUE OBJID FOR PROBLEM
        . S @VMAP@("PROBLEMIEN")=$P(PTMP,U,1)
        . S @VMAP@("PROBLEMSTATUS")=$S($P(PTMP,U,2)="A":"Active",$P(PTMP,U,2)="I":"Inactive",1:"")
        . N ZPRIOR S ZPRIOR=$P(PTMP,U,14) ;PRIORITY FLAG
        . ; turn off acute/chronic for certification gpl
        . ;S @VMAP@("PROBLEMSTATUS")=@VMAP@("PROBLEMSTATUS")_$S(ZPRIOR="A":"/Acute",ZPRIOR="C":"/Chronic",1:"") ; append Chronic and Accute to Status
        . S @VMAP@("PROBLEMDESCRIPTION")=$P(PTMP,U,3)
        . S @VMAP@("PROBLEMCODINGVERSION")=""
        . S @VMAP@("PROBLEMCODEVALUE")=$P(PTMP,U,4)
        . ; FOR CERTIFICATION - GPL
        . I @VMAP@("PROBLEMCODEVALUE")["493.90" S @VMAP@("PROBLEMCODEVALUE")=493
        . S @VMAP@("PROBLEMDATEOFONSET")=$$FMDTOUTC^C0CUTIL($P(PTMP,U,5),"DT")
        . S @VMAP@("PROBLEMDATEMOD")=$$FMDTOUTC^C0CUTIL($P(PTMP,U,6),"DT")
        . S @VMAP@("PROBLEMSC")=$P(PTMP,U,7)
        . S @VMAP@("PROBLEMSE")=$P(PTMP,U,8)
        . S @VMAP@("PROBLEMCONDITION")=$P(PTMP,U,9)
        . S @VMAP@("PROBLEMLOC")=$P(PTMP,U,10)
        . S @VMAP@("PROBLEMLOCTYPE")=$P(PTMP,U,11)
        . S @VMAP@("PROBLEMPROVIDER")=$P(PTMP,U,12)
        . S X=@VMAP@("PROBLEMPROVIDER") ; FORMAT Y;NAME Y IS IEN OF PROVIDER
        . S @VMAP@("PROBLEMSOURCEACTORID")="ACTORPROVIDER_"_$P(X,";",1)
        . S @VMAP@("PROBLEMSERVICE")=$P(PTMP,U,13)
        . S @VMAP@("PROBLEMHASCMT")=$P(PTMP,U,14)
        . S @VMAP@("PROBLEMDTREC")=$$FMDTOUTC^C0CUTIL($P(PTMP,U,15),"DT")
        . S @VMAP@("PROBLEMINACT")=$$FMDTOUTC^C0CUTIL($P(PTMP,U,16),"DT")
        . S ARYTMP=$NA(@TARYTMP@(J))
        . ; W "ARYTMP= ",ARYTMP,!
        . K @ARYTMP
        . D MAP^C0CXPATH(IPXML,VMAP,ARYTMP) ;
        . I J=1 D  ; FIRST ONE IS JUST A COPY
        . . ; W "FIRST ONE",!
        . . D CP^C0CXPATH(ARYTMP,OUTXML)
        . . ; W "OUTXML ",OUTXML,!
        . I J>1 D  ; AFTER THE FIRST, INSERT INNER XML
        . . D INSINNER^C0CXPATH(OUTXML,ARYTMP)
        ; ZWR ^TMP("C0CCCR",$J,"PROBVALS",*)
        ; ZWR ^TMP("C0CCCR",$J,"PROBARYTMP",*) ; SHOW THE RESULTS
        ; ZWR @OUTXML
        ; $$HTML^DILF(
        ; GENERATE THE NARITIVE HTML FOR THE CCD
        I CCD D CCD ; IF THIS IS FOR A CCD
        D MISSINGVARS
        Q
CCD     
        N HTMP,HOUT,HTMLO,C0CPROBI,ZX
        F C0CPROBI=1:1:RPCRSLT(0) D  ; FOR EACH PROBLEM
        . S VMAP=$NA(@TVMAP@(C0CPROBI))
        . I DEBUG W "VMAP =",VMAP,!
        . D QUERY^C0CXPATH(TGLOBAL,"//ContinuityOfCareRecord/Body/PROBLEMS-HTML","HTMP") ; GET THE HTML FROM THE TEMPLATE
        . D UNMARK^C0CXPATH("HTMP") ; REMOVE <PROBLEMS-HTML> MARKUP
        . ; D PARY^C0CXPATH("HTMP") ; PRINT IT
        . D MAP^C0CXPATH("HTMP",VMAP,"HOUT") ; MAP THE VARIABLES
        . ; D PARY^C0CXPATH("HOUT") ; PRINT IT AGAIN
        . I C0CPROBI=1 D  ; FIRST ONE IS JUST A COPY
        . . D CP^C0CXPATH("HOUT","HTMLO")
        . I C0CPROBI>1 D  ; AFTER THE FIRST, INSERT INNER HTML
        . . I DEBUG W "DOING INNER",!
        . . N HTMLBLD,HTMLTMP
        . . D QUEUE^C0CXPATH("HTMLBLD","HTMLO",1,HTMLO(0)-1)
        . . D QUEUE^C0CXPATH("HTMLBLD","HOUT",2,HOUT(0)-1)
        . . D QUEUE^C0CXPATH("HTMLBLD","HTMLO",HTMLO(0),HTMLO(0))
        . . D BUILD^C0CXPATH("HTMLBLD","HTMLTMP")
        . . D CP^C0CXPATH("HTMLTMP","HTMLO")
        . . ; D INSINNER^C0CXPATH("HOUT","HTMLO","//")
        I DEBUG D PARY^C0CXPATH("HTMLO")
        D INSB4^C0CXPATH(OUTXML,"HTMLO") ; INSERT AT TOP OF SECTION
        Q
MISSINGVARS     
        N PROBSTMP,I
        D MISSING^C0CXPATH(ARYTMP,"PROBSTMP") ; SEARCH XML FOR MISSING VARS
        I PROBSTMP(0)>0  D  ; IF THERE ARE MISSING VARS -
        . ; STRINGS MARKED AS @@X@@
        . W !,"PROBLEMS Missing list: ",!
        . F I=1:1:PROBSTMP(0) W PROBSTMP(I),!
        Q
        ;
