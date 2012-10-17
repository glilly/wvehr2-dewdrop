PXAICPTV        ;ISL/JVS,ISA/KWP,SCK - VALADATE PROCEDURES(CPT) ;11/14/96  12:46
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**15,73,74,111,121,130,168,194**;Aug 12, 1996;Build 2
        ;
VAL     ;--VALIDATE ENOUGH DATA
        ;----Missing a pointer to PROCEDURE(CPT) name
        I $G(PXAA("PROCEDURE"))']"" D  Q:$G(STOP)
        .S STOP=1 ;--USED TO STOP DO LOOP
        .S PXAERRF=1 ;--FLAG INDICATES THERE IS AN ERR
        .S PXADI("DIALOG")=8390001.001
        .S PXAERR(9)="PROCEDURE"
        .S PXAERR(11)=$G(PXAA("PROCEDURE"))
        .S PXAERR(12)="You are missing a pointer to the PROCEDURE CPT FILE#81 that represents the procedure's name"
        ;
        ;----NOT a pointer to PROCEDURE CPT FILE#81
        I +$$CPT^ICPTCOD($G(PXAA("PROCEDURE")))'>0 D  Q:$G(STOP) 
        .S STOP=1
        .S PXAERRF=1
        .S PXADI("DIALOG")=8390001.001
        .S PXAERR(9)="PROCEDURE"
        .S PXAERR(11)=$G(PXAA("PROCEDURE"))
        .S PXAERR(12)=PXAERR(11)_" is NOT a pointer value to the CPT FILE #81"
        ;
        ;----Not a valid CPT
        I '$P($$CPT^ICPTCOD(PXAA("PROCEDURE"),+^AUPNVSIT(PXAVISIT,0)),"^",7) D  Q:$G(STOP)
        .S STOP=1
        .S PXAERRF=1
        .S PXADI("DIALOG")=8390001.001
        .S PXAERR(9)="PROCEDURE"
        .S PXAERR(11)=$G(PXAA("PROCEDURE"))
        .S PXAERR(12)=PXAERR(11)_" is NOT a valid CPT code"
        ;
        ;----Not a valid modifier
        N SUB,MODIEN
        S SUB=""
        F  S SUB=$O(PXAA("MODIFIERS",SUB)) Q:SUB=""!($G(STOP))  D
        .;S MODIEN=$$MODP^ICPTMOD(PXAA("PROCEDURE"),SUB,"E","",0)
        .S MODIEN=$$MODP^ICPTMOD(PXAA("PROCEDURE"),SUB,"E",+^AUPNVSIT(PXAVISIT,0),0)
        .I $P(MODIEN,"^")>0 Q
        .S STOP=1
        .S PXAERRF=1
        .S PXADI("DIALOG")=8390001.001
        .S PXAERR(9)="MODIFIERS"_","_SUB
        .S PXAERR(11)=""
        .S PXAERR(12)=SUB_" is NOT a valid modifier for procedure "_$G(PXAA("PROCEDURE"))
        ;----"Missing the number of times the procedure was performed.
        I $G(PXAA("QTY"))<1 D
        .S STOP=0
        .S PXAERRF=1
        .S PXADI("DIALOG")=8390001.002
        .S PXAERR(9)="QTY"
        .S PXAERR(11)=$G(PXAA("QTY"))
        .S PXAERR(12)="If this node is empty we will assume it should be '1'. If it is a less than '1' we will delete any reference to it in the data base."
        ;
        ;
        Q
VAL04   ;---PROVIDER NARRATIVE
        S STOP=1
        S PXAERRF=1
        S PXADI("DIALOG")=8390001.001
        S PXAERR(9)="NARRATIVE"
        S PXAERR(11)=$G(PXAA("NARRATIVE"))
        S PXAERR(12)="We are unable to retrive a narrative from the PROVIDER NARRATIVE file #9999999.27"
        Q
VAL45   ;---PROVIDER NARRATIVE CATEGORY
        S STOP=0
        S PXAERRF=1
        S PXADI("DIALOG")=8390001.002
        S PXAERR(9)="CATEGORY"
        S PXAERR(11)=$G(PXAA("CATEGORY"))
        S PXAERR(12)="We are unable to retrieve a narrative from the PROVIDER NARRATIVE file #9999999.27"
        Q
        ;---------------------SUBROUTINE------------------------------
ARRAY   ;--SET ERRORS AND WARNINGS INTO AN ARRAY TO RETURN TO CALLER
        I PXADI("DIALOG")=8390001.001 D
        .S PXASUB=PXASUB+1
        .S PXAPROB($J,PXASUB,"ERROR1",PXAERR(7),PXAERR(9),PXAK)=$G(PXAERR(12))
        I PXADI("DIALOG")=8390001.002 D
        .S PXASUB=PXASUB+1
        .S PXAPROB($J,PXASUB,"WARNING2",PXAERR(7),PXAERR(9),PXAK)=$G(PXAERR(12))
        I PXADI("DIALOG")=8390001.003 D
        .S PXASUB=PXASUB+1
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"SC")=$G(PXAERR("6W"))
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"AO")=$G(PXAERR("7W"))
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"IR")=$G(PXAERR("8W"))
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"EC")=$G(PXAERR("9W"))
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"MST")=$G(PXAERR("10W"))
        .;PX*1*111 - Add HNC
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"HNC")=$G(PXAERR("17W"))
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"CV")=$G(PXAERR("18W"))
        .S PXAPROB($J,PXASUB,"WARNING3","ENCOUNTER",1,"SHAD")=$G(PXAERR("19W"))
        I PXADI("DIALOG")=8390001.004 D
        .S PXASUB=PXASUB+1
        .S PXAPROB($J,PXASUB,"ERROR4","PX/DL",PXAK)=$G(PXAERR("PL1"))
        Q
