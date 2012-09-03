C0QQRDA ; GPL - Quality Reporting QRDA Processing ; 8/24/12 12:41pm
        ;;1.0;QUALITY MEASURES;**4**;May 21, 2012;Build 28
        ;Copyright 2012 George Lilly.  Licensed under the terms of the GNU
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
EN       ; Private to this Package; Main Entry Point for this routine
        ; This EP is interactive or silent depending on params
        ;
        ; Check for config errors first; try to set-up.
        N % S %=$$CHECKPAR()
        I +%=1 D EN^DDIOL($P(%,U,2)) QUIT  ; No inpatient pars found... QUIT
        ;
        N C0QFAIL S C0QFAIL=0
        I +%=2 D  ; No QRDA Measure Sets... try to set it up.
        . D EN^DDIOL("Trying to automatically set-up measure sets in parameters")
        . N % S %=$$SETUPPAR($$INPPARM())
        . I % D EN^DDIOL("Failed to set-up..."_$P(%,U,2)) S C0QFAIL=1
        . E  D EN^DDIOL("...Set-up complete",""),EN^DDIOL("","","!!!")
        ;
        I C0QFAIL QUIT
        ;
        ; Print Intro
        N %
        S %(1)="This program collects patients from the denominators of the measures"
        S %(2)="STK, VTE, and ED and outputs modified CCR files to the kernel default"
        S %(3)="directory (probably /tmp/)."
        S %(4)=""
        S %(5)="This will take some time to execute."
        S %(6)=""
        S %(6,"F")="!!!"
        ;
        D EN^DDIOL(.%)
        ;
        ; Ask user which measure set to run
        N DIR,DTOUT,DUOUT,X,Y,DIRUT,DIROUT,DA ; DIR variables
        S DIR(0)="SB^V:VTE;S:STK;E:ED;A:ALL"
        S DIR("A")="Measure to calculate"
        S DIR("A",1)="Which measure set would you like to produce QRDA documents for?"
        S DIR("A",2)="Choose to Run [V]TE Measure Set, [S]TK Measure Set, or "
        S DIR("A",3)="[E]D Measure Set. Or you can choose to run [A]ll of them."
        D ^DIR
        ;
        I $G(DTOUT)!$G(DUOUT) QUIT  ; Did user hit '^' or time out?
        ;
        ; Get the Measure Set IEN which the user has seleted.
        ; NB: field names start with VTE, STK, or ED; so I can use the output
        ; of DIR directly.
        ;
        N FLD S FLD=Y(0) ; Grab full text of user choice into var "FLD" for field.
        N C0QMSIENS ; Measure set IENs (^ piece); (0) stores the identifier for file names
        ;looks like this in the end
        ; C0QMSIENS=1^3^5
        ; C0QMSIENS(0)="ED^VTE^STK"
        ;
        N INPPARM S INPPARM=$$INPPARM() ; Inpatient Parameter IEN in 401
        ;
        ; If not all, grab the measure set; else, grab all of them in ^ pieces
        I FLD'="ALL" D
        . S C0QMSIENS=$$GET1^DIQ(1130580001.401,INPPARM,FLD,"I")
        . S C0QMSIENS(0)=FLD
        ;
        E  D
        . N C0QED S C0QED=$$GET1^DIQ(1130580001.401,INPPARM,"ED","I")
        . N C0QVTE S C0QVTE=$$GET1^DIQ(1130580001.401,INPPARM,"VTE","I")
        . N C0QSTK S C0QSTK=$$GET1^DIQ(1130580001.401,INPPARM,"STK","I")
        . S C0QMSIENS=C0QED_U_C0QVTE_U_C0QSTK
        . S C0QMSIENS(0)="ED"_U_"VTE"_U_"STK"
        ;
        ;
        S:'C0QMSIENS $EC=",U1,"  ; Debug.Assert that MSIEN is numeric.
        ;
        ;
        ; Do the work
        N C0QI ; Counter through the measures
        F C0QI=1:1:$L(C0QMSIENS,U) D
        . N MSIEN S MSIEN=$P(C0QMSIENS,U,C0QI) ; Measure Set IEN
        . N MSNAME S MSNAME=$P(C0QMSIENS(0),U,C0QI) ; Measure Set Name
        . N REF S REF=$NAME(^TMP("C0QQRDA",$J)) ; Global for data collection
        . K @REF  ; Clear global
        . D WORK(REF,MSIEN) ; Process Measure Set, collect data in global
        . D PRINTXML(REF,MSNAME) ; Generate XML; output to File. 
        . K @REF  ; Clear global
        QUIT
        ;
        ;SILENTEN(RETURN) ; For future RPC calls...; needs to be reworked.
        ; N % S %=$$CHECKPAR() 
        ; I % S RETURN(0)=% Q
        ;
        ; N DIQUIET S DIQUIET=1
        ; D EN 
        ; S RETURN(0)=0
        ; QUIT
        ;
CHECKPAR()      ; Private Proc; Check if environment is okay.
        ; Output: 0 or +ve^message for error
        ; 1 -> No Inpatient Parameters found
        ; 2 -> Measurement Set(s) not found.
        ;
        N INPPARM S INPPARM=$$INPPARM() ; Inpatient Parameters IEN
        I 'INPPARM Q 1_U_"No Inpatient Parameters found"
        ;
        ; Pointer fields to Measurement Set file, we grab the IENs
        N C0QED S C0QED=$$GET1^DIQ(1130580001.401,INPPARM,"ED","I")
        N C0QSTK S C0QSTK=$$GET1^DIQ(1130580001.401,INPPARM,"STK","I")
        N C0QVTE S C0QVTE=$$GET1^DIQ(1130580001.401,INPPARM,"VTE","I")
        ;
        N TXT S TXT="" ; Error text
        I 'C0QED S TXT=TXT_"ED,"
        I 'C0QSTK S TXT=TXT_"STK,"
        I 'C0QVTE S TXT=TXT_"VTE"
        I $E(TXT,$L(TXT))="," S TXT=$E(TXT,1,$L(TXT)-1) ; remove trailing comma
        I $L(TXT) Q 2_U_"Measure Sets missing from parameters: "_TXT
        ;
        QUIT 0 ; All okay
        ;
SETUPPAR(INPPARM)       ; Private Proc; Set-up QRDA lists if Inpatient Param is found.
        ; Input: Inpatient Parameter IEN in C0Q(401, -> C0Q Parameters
        ; Output: 0 if okay or 1^error description
        N C0QFDA
        ;
        N VTEIEN S VTEIEN=$O(^C0Q(201,"B","VTE CMS REPORTING MEASURES",""))
        I 'VTEIEN QUIT 1_U_"VTE not found"
        N STKIEN S STKIEN=$O(^C0Q(201,"B","STK CMS REPORTING MEASURES",""))
        I 'STKIEN QUIT 1_U_"STK not found"
        N EDIEN S EDIEN=$O(^C0Q(201,"B","ED CMS REPORTING MEASURES",""))
        I 'EDIEN QUIT 1_U_"ED not found"
        ;
        S C0QFDA(1130580001.401,INPPARM_",",5.1)=VTEIEN
        S C0QFDA(1130580001.401,INPPARM_",",5.2)=STKIEN
        S C0QFDA(1130580001.401,INPPARM_",",5.3)=EDIEN
        ;
        N C0QERR
        D FILE^DIE("",$NA(C0QFDA),$NA(C0QERR))
        I $D(C0QERR) Q 2_U_C0QERR("DIERR",1,"TEXT",1)
        Q 0
        ;
WORK(C0QREF,C0QMSIEN)   ; Private Proc; Process Measure Sets; Collect the data.
        ; Input/Output: C0QREF -> Global for Output passed by Name
        ;               C0QMSIEN -> (Input): Measurement Set IEN to calculate
        ;
        ; Print
        D EN^DDIOL(C0QMSIEN_": "_^C0Q(201,C0QMSIEN,0))
        D EN^DDIOL("")
        ;
        ; Calculate totals and move patients over from individual measures
        N A
        D UPDATE^C0QUPDT(.A,C0QMSIEN) ; FYI: A isn't used.
        ;
        ; Get QRDA code for Measure Set.
        N C0QMSQRDA S C0QMSQRDA=$$GET1^DIQ($$C0QMFN^C0QUPDT(),C0QMSIEN_",","QRDA TEMPLATE ROOT")
        ;
        N C0QI S C0QI=0 ; Fileman IEN looper
        F  S C0QI=$O(^C0Q(201,C0QMSIEN,5,C0QI)) Q:'C0QI  D  ; For each measure in Measure Set
        . ;
        . ; Get QRDA code using relational jump
        . N C0QMEASUREQRDA S C0QMEASUREQRDA=$$GET1^DIQ($$C0QMMFN^C0QUPDT(),C0QI_","_C0QMSIEN_",",".01:QRDA TEMPLATE ROOT")
        . ;
        . ; Then collect patients in the denominator, and store in output global
        . N C0QP S C0QP=0
        . F  S C0QP=$O(^C0Q(201,C0QMSIEN,5,C0QI,3,C0QP)) Q:'C0QP  D  ; For each patient in denominator
        . . N C0QDFN S C0QDFN=+^(C0QP,0)
        . . S @C0QREF@(C0QDFN,C0QMSQRDA,C0QMEASUREQRDA)=""
        QUIT
        ;
INPPARM()       ; $$ Private; Get Inpatient Parameters IEN
        ; Output: IEN of Inpatient Parameter in C0Q PARAMETER file
        ;
        ; Browse this tree of xrefs to get the IEN of INP type (last line here).
        ; ^C0Q(401,"B","INPATIENT",2)=""
        ; ^C0Q(401,"B","OUTPATIENT",1)=""
        ; ^C0Q(401,"MU","MU12",1)=""
        ; ^C0Q(401,"MU","MU12",2)=""
        ; ^C0Q(401,"MUTYP","MU12","EP",1)=""
        ; ^C0Q(401,"MUTYP","MU12","INP",2)=""
        ;
        N MUID S MUID="" ; Looper for MU Year ID
        N FOUND S FOUND=0 ; Found flag to get out of loop
        N IEN ; Output variable
        F  S MUID=$O(^C0Q(401,"MUTYP",MUID),-1) Q:MUID=""  Q:FOUND  D  ; Loop backwards
        . N TYP S TYP=""  ; Type ("EP" or "INP")
        . F  S TYP=$O(^C0Q(401,"MUTYP",MUID,TYP)) Q:TYP=""  Q:FOUND  D
        . . I TYP="INP" S IEN=$O(^(TYP,"")),FOUND=1 Q  ; If found, get IEN, quit out of loops
        QUIT +$G(IEN)
        ;
PRINTXML(C0QREF,C0QMNM) ; Print the XML; Private Proc
        ; Input: C0QREF -> Global By Name
        ;        C0QMNM -> Measure Name -> Either VTE, STK, ED. For use in filenames.
        ; Output: modified CCRs are saved in /tmp/
        N C0QDFN,C0QMS,C0QM S (C0QDFN,C0QMS,C0QM)="" ; DFN, Measure Set, Measure loopers
        F  S C0QDFN=$O(@C0QREF@(C0QDFN)) Q:C0QDFN=""  D  ; For each patient
        . ;
        . N GREEN S GREEN=$C(27)_"[1;37;42m"
        . N RESET S RESET=$C(27)_"[0m"
        . D EN^DDIOL(GREEN_"Prosessing DFN "_C0QDFN_RESET,"","!!!")
        . D EN^DDIOL("","","!")
        . ;
        . ; CCR Generatation is next; protected against crashes.
        . ; ET set to new value then restored.
        . N C0QCCRXML ; CCR XML
        . N OLDTRAP S OLDTRAP=$ET
        . ; ET: Rollback to this level, write the error in red , clear it, then quit
        . N ETTEXT S ETTEXT=$C(27)_"[1;37;41m"_$$EC^%ZOSV_$C(27)_RESET
        . N $ES,$ET
        . S $ET="W ETTEXT D ^%ZTER G ROLLDOWN^C0QQRDA"
        . D CCRRPC^C0CCCR(.C0QCCRXML,C0QDFN) ; Run CCR RPC.
        . S $ET=OLDTRAP
        . ;
        . ;
        . ; Quality XML Section generated by hand next...
        . N C0QXML ; Generated Quality XML
        . D XMLSTORE(.C0QXML,$$OT("QUALITY")) ; Open Tag
        . F  S C0QMS=$O(@C0QREF@(C0QDFN,C0QMS)) Q:C0QMS=""  D  ; For each measure set
        . . D XMLSTORE(.C0QXML,$$OT("MEASURE_SET")) ; Open tag
        . . D XMLSTORE(.C0QXML,$$TAG("ID",C0QMS)) ; Write out set QRDA code
        . . D XMLSTORE(.C0QXML,$$OT("MEASURES")) ; Open tag
        . . F  S C0QM=$O(@C0QREF@(C0QDFN,C0QMS,C0QM)) Q:C0QM=""  D  ; for each measure
        . . . D XMLSTORE(.C0QXML,$$TAG("MEASURE",C0QM)) ; Write <measure> and qrda code
        . . D XMLSTORE(.C0QXML,$$CT("MEASURES")) ; Close tag
        . . D XMLSTORE(.C0QXML,$$CT("MEASURE_SET")) ; Close tag
        . D XMLSTORE(.C0QXML,$$CT("QUALITY")) ; Close tag
        . ;
        . ;
        . ; Insert Quality XML under the root of the CCR document
        . D INSERT^C0CXPATH($NA(C0QCCRXML),$NA(C0QXML),"//ContinuityOfCareRecord")
        . ;
        . ; 
        . ; Get Kernel Default Directory
        . N DEFDIR S DEFDIR=$$DEFDIR^%ZISH()
        . ;
        . ; 
        . ; Write out to a file.
        . N FN S FN=C0QMNM_"_QRDA_CCR_DFN"_$$RJ^XLFSTR(C0QDFN,10,"0")_".XML" ; File Name
        . K C0QCCRXML(0) ; remove zero node; API doesn't support it.
        . D EN^DDIOL($$OUTPUT^C0CXPATH($NA(C0QCCRXML(1)),FN,DEFDIR))
        QUIT
        ;
        ; Quick XML stuff ; All Private
OT(STR) Q "<"_STR_">"  ; $$ Open Tag
CT(STR) Q "</"_STR_">"  ; $$ Close Tag
TAG(NM,CONTENT) Q "<"_NM_">"_CONTENT_"</"_NM_">"  ; $$ Whole tag
        ;
XMLSTORE(REF,STR)       ; Priv Proc - Store XML
        ; REF -> Save Array. Pass by Reference.
        ; STR -> What to store. Pass by Value.
        ; Use like this: D XMLSTORE(.STORE,"<tag>")
        ; Output: STORE(1)="<tag>"
        N L ; Number Subscript to use
        S L=$O(REF(" "),-1) S L=L+1 ; Get last number and increment
        S REF(L)=STR,REF(0)=L ; Store string in numbered sub, store last number in 0 node (not used here)
        QUIT
        ;
        ; Following is for formatting printed XML. L passed in Symbol Table and starts at 0.
L1      D WS S L=L+1 Q  ; Write space and increment
L2      S L=L-1 D WS Q  ; Decrement and Write space
WS      X "F I=1:1:L W "" """ Q  ; Write Space
        ; This is for rolling down the stack to the $ES level
ROLLDOWN        S $ET="Q:$ES  S $EC=""""",$EC=",U99," QUIT
