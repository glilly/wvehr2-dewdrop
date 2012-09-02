C0CALERT         ; CCDCCR/CKU/GPL - CCR/CCD PROCESSING FOR ALERTS ; 09/11/08
        ;;1.2;C0C;;May 11, 2012;Build 50
        ;Copyright 2008,2009 George Lilly, University of Minnesota and others.
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
EXTRACT(ALTXML,DFN,ALTOUTXML,CALLBK)    ; EXTRACT ALERTS INTO  XML TEMPLATE
        ; CALLBACK IF PROVIDED IS CALLED FOR EACH ALLERGY BEFORE MAPPING
        ; ALTXML AND ALTOUTXML ARE PASSED BY NAME SO GLOBALS CAN BE USED
        ;
        ; GET ADVERSE REACTIONS AND ALLERGIES
        ; N GMRA,GMRAL ; FOR DEBUGGING, DON'T NEW THESE VARIABLES
        S GMRA="0^0^111"
        D EN1^GMRADPT
        I $G(GMRAL)'=1 D  Q ; NO ALLERGIES FOUND THUS *QUIT*
        . S @ALTOUTXML@(0)=0
        ; DEFINE MAPPING
        N ALTTVMAP,ALTVMAP,ALTTARYTMP,ALTARYTMP
        S ALTTVMAP=$NA(^TMP("C0CCCR",$J,"ALERTS"))
        S ALTTARYTMP=$NA(^TMP("C0CCCR",$J,"ALERTSARYTMP"))
        K @ALTTVMAP,@ALTTARYTMP
        N ALTTMP,ALTCNT S ALTG=$NA(GMRAL),ALTCNT=1
        S ALTTMP="" ;
        F  S ALTTMP=$O(@ALTG@(ALTTMP)) Q:ALTTMP=""  D  ; CHANGED TO $O BY GPL
        . W "ALTTMP="_ALTTMP,!
        . ; I $QS(ALTTMP,2)="S" W !,"S FOUND",! Q
        . S ALTVMAP=$NA(@ALTTVMAP@(ALTCNT))
        . K @ALTVMAP
        . S @ALTVMAP@("ALERTOBJECTID")="ALERT"_ALTCNT
        . N A1 S A1=@ALTG@(ALTTMP) ; ALL THE PIECES
        . I $D(CALLBK) D @CALLBK ;CALLBACK FOR EPRESCRIBING
        . N A2 S A2=$$GET1^DIQ(120.8,ALTTMP,"MECHANISM","I") ; MECHANISM
        . N A3 S A3=$P(A1,U,5) ; ADVERSE FLAG
        . N ADT S ADT="Patient has an " ; X $ZINT H 5
        . S ADT=ADT_$S(A2="P":"ADVERSE",A2="A":"ALLERGIC",1:"UNKNOWN")
        . S ADT=ADT_" reaction to "_$P(@ALTG@(ALTTMP),U,2)_"."
        . S @ALTVMAP@("ALERTDESCRIPTIONTEXT")=ADT
        . N ADTY S ADTY=$S(A2="P":"Adverse Reaction",A2="A":"Allergy",1:"") ;
        . S @ALTVMAP@("ALERTTYPE")=ADTY ; type of allergy
        . N ALTCDE ; SNOMED CODE THE THE ALERT
        . S ALTCDE=$S(A2="P":"282100009",A2="A":"416098002",1:"") ; IF NOT ADVERSE, IT IS ALLERGIC
        . S @ALTVMAP@("ALERTCODEVALUE")=ALTCDE ;
        . ; WILL USE 418634005 FOR ALLERGIC REACTION TO A SUBSTANCE
        . ; AND  282100009 FOR ADVERSE REACTION TO A SUBSTANCE
        . I ALTCDE'="" D  ; IF THERE IS A CODE
        . . S @ALTVMAP@("ALERTCODESYSTEM")="SNOMED CT"
        . . S @ALTVMAP@("ALERTCODESYSTEMVERSION")="2008"
        . E  D  ; SET TO NULL
        . . S @ALTVMAP@("ALERTCODESYSTEM")=""
        . . S @ALTVMAP@("ALERTCODESYSTEMVERSION")=""
        . S @ALTVMAP@("ALERTSTATUSTEXT")="" ; WHERE DO WE GET THIS?
        . N ALTPROV S ALTPROV=$P(^GMR(120.8,ALTTMP,0),U,5) ; SOURCE PROVIDER IEN
        . I ALTPROV'="" D  ; PROVIDER PROVIDEED
        . . S @ALTVMAP@("ALERTSOURCEID")="ACTORPROVIDER_"_ALTPROV
        . E  S @ALTVMAP@("ALERTSOURCEID")="" ; SOURCE NULL - SHOULD NOT HAPPEN
        . W "RUNNING ALERTS, PROVIDER: ",@ALTVMAP@("ALERTSOURCEID"),!
        . N ACGL1,ACGFI,ACIEN,ACVUID,ACNM,ACTMP
        . S ACGL1=$P(@ALTG@(ALTTMP),U,9) ; ADDRESS OF THE REACTANT XX;GLB(YY.Z,
        . S ACGFI=$$PRSGLB($P(ACGL1,";",2)) ; FILE NUMBER
        . S ACIEN=$P(ACGL1,";",1) ; IEN OF REACTANT
        . S ACVUID=$$GET1^DIQ(ACGFI,ACIEN,"VUID") ; VUID OF THE REACTANT
        . S @ALTVMAP@("ALERTAGENTPRODUCTOBJECTID")="PRODUCT_"_ACIEN ; IE OF REACTANT
        . S @ALTVMAP@("ALERTAGENTPRODUCTSOURCEID")="" ; WHERE DO WE GET THIS?
        . S ACNM=$P(@ALTG@(ALTTMP),U,2) ; REACTANT
        . S @ALTVMAP@("ALERTAGENTPRODUCTNAMETEXT")=ACNM
        . N ZC,ZCD,ZCDS,ZCDSV ; CODE,CODE SYSTEM,CODE VERSION
        . S (ZC,ZCD,ZCDS,ZCDSV)="" ; INITIALIZE
        . I ACVUID'="" D  ; IF VUID IS NOT NULL
        . . S ZC=$$CODE^C0CUTIL(ACVUID)
        . . S ZCD=$P(ZC,"^",1) ; CODE TO USE
        . . S ZCDS=$P(ZC,"^",2) ; CODING SYSTEM - RXNORM OR VUID
        . . S ZCDSV=$P(ZC,"^",3) ; CODING SYSTEM VERSION
        . E  D  ; IF REACTANT CODE VALUE IS NULL
        . . I $G(DUZ("AG"))="I" D  ; IF WE ARE RUNNING ON RPMS
        . . . S ACTMP=$O(^C0CCODES(176.112,"C",ACNM,0)) ;
        . . . W "RPMS NAME FOUND",ACNM," ",ACTMP,!
        . . S @ALTVMAP@("ALERTAGENTPRODUCTCODESYSTEM")=""
        . . S @ALTVMAP@("ALERTAGENTPRODUCTCODEVALUE")=""
        . S @ALTVMAP@("ALERTAGENTPRODUCTCODEVALUE")=ZCD
        . S @ALTVMAP@("ALERTAGENTPRODUCTCODESYSTEM")=ZCDS
        . S @ALTVMAP@("ALERTAGENTPRODUCTNAMETEXT")=ACNM_" "_ZCDS_": "_ZCD
        . S @ALTVMAP@("ALERTDESCRIPTIONTEXT")=ADT_" "_ZCDS_": "_ZCD
        . ; REACTIONS - THIS SHOULD BE MULTIPLE, IS SINGLE NOW
        . N ARTMP,ARIEN,ARDES,ARVUID
        . S (ARTMP,ARDES,ARVUID)=""
        . I $D(@ALTG@(ALTTMP,"S",1)) D  ; IF REACTION EXISTS
        . . S ARTMP=@ALTG@(ALTTMP,"S",1)
        . . W "REACTION:",ARTMP,!
        . . S ARIEN=$P(ARTMP,";",2)
        . . S ARDES=$P(ARTMP,";",1)
        . . S ARVUID=$$GET1^DIQ(120.83,ARIEN,"VUID")
        . S @ALTVMAP@("ALERTREACTIOINDESCRIPTIONTEXT")=ARDES
        . I ARVUID'="" D  ; IF REACTION VUID IS NOT NULL
        . . S @ALTVMAP@("ALERTREACTIONCODEVALUE")=ARVUID
        . . S @ALTVMAP@("ALERTREACTIONCODESYSTEM")="VUID"
        . E  D  ; IF IT IS NULL DON'T SET CODE SYSTEM
        . . S @ALTVMAP@("ALERTREACTIONCODEVALUE")=""
        . . S @ALTVMAP@("ALERTREACTIONCODESYSTEM")=""
        . S ALTARYTMP=$NA(@ALTTARYTMP@(ALTCNT))
        . ; NOW GO TO THE GLOBAL TO GET THE DATE/TIME AND BETTER DESCRIPTION
        . N C0CG1,C0CT ; ARRAY FOR VALUES FROM GLOBAL
        . D GETN1^C0CRNF("C0CG1",120.8,ALTTMP,"") ;GET VALUES BY NAME
        . S C0CT=$$ZVALUEI^C0CRNF("ORIGINATION DATE/TIME","C0CG1")
        . S @ALTVMAP@("ALERTDATETIME")=$$FMDTOUTC^C0CUTIL(C0CT,"DT")
        . K @ALTARYTMP
        . D MAP^C0CXPATH(ALTXML,ALTVMAP,ALTARYTMP)
        . I ALTCNT=1 D CP^C0CXPATH(ALTARYTMP,ALTOUTXML)
        . I ALTCNT>1 D INSINNER^C0CXPATH(ALTOUTXML,ALTARYTMP)
        . S ALTCNT=ALTCNT+1
        S @ALTTVMAP@(0)=ALTCNT-1 ; RECORD THE NUMBER OF ALERTS
        Q
PRSGLB(INGLB)   ; EXTRINSIC TO PARSE GLOBALS AND RETURN THE FILE NUMBER
        ; INGLB IS OF THE FORM: PSNDF(50.6,
        ; RETURN 50.6
        Q $P($P(INGLB,"(",2),",",1)  ;
