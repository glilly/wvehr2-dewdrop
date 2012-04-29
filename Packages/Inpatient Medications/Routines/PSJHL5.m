PSJHL5  ;BIR/LDT-ACTIONS ON HL7 MESSAGES FROM OE/RR ;28 Jan 98 / 3:34 PM
        ;;5.0; INPATIENT MEDICATIONS ;**1,28,39,40,42,84,85,95,80,173,134**;16 DEC 97;Build 124
        ;
        ; Reference to ^PS(55 is supported by DBIA# 2191.
        ; Reference to EN^ORERR is supported by DBIA# 2187.
        ; Reference to NURV^ALPBCBU is supported by DBIA# 4120.
        ; Reference to UNESC^ORHLESC is supported by DBIA# 4922
        ;
ASSIGN  ; number assigned, update ORDERS FILE ENTRY
        S RXORDER=RXORDER_"0)"
        I '$P($G(@RXORDER),U) S ORDCON="Invalid Pharmacy order number/Number Assign Msg" S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(ORDCON,.PSJMSG) Q
        Q:'$P($G(@RXORDER),U)
        I RXON["P",PSJHLDFN'=$P($G(@(RXORDER)),U,15) S ORDCON="Patient does not match/Number Assign Msg" S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(ORDCON,.PSJMSG) Q
        I RXON["P",PSJHLDFN'=$P($G(@(RXORDER)),U,15) Q
        S $P(@RXORDER,"^",21)=PSJORDER
        Q
        ;
NURSEACK        ;Nurse Acknowledgement of Pending Orders
        I '$P($G(@(RXORDER_"0)")),U) S ORDCON="Invalid Pharmacy order number/Nurse Acknowledgement Msg" S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(ORDCON,.PSJMSG) Q
        Q:'$P($G(@(RXORDER_"0)")),U)
        I RXON["P",PSJHLDFN'=$P($G(@(RXORDER_"0)")),U,15) S ORDCON="Patient does not match/Nurse Acknowledgement Msg" S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(ORDCON,.PSJMSG) Q
        I RXON["P",PSJHLDFN'=$P($G(@(RXORDER_"0)")),U,15) Q
        I RXON["P" N STATUS S STATUS=$P($G(@(RXORDER_"0)")),U,9) D:STATUS="N" EN^PSJHLV(PSJHLDFN,RXON)
        I RXON["P" N STATUS S STATUS=$P($G(@(RXORDER_"0)")),U,9) Q:STATUS="A"
        N DIE,DA
        S DIE=$S(RXON["N"!(RXON["P"):"^PS(53.1,",RXON["V":"^PS(55,"_PSJHLDFN_",""IV"",",1:"^PS(55,"_PSJHLDFN_",5,"),DA=+RXON,DA(1)=PSJHLDFN
        S DR="16////"_NURSEACK_";17////"_ACKDATE S:RXON["U" DR=DR_";51////1" S:RXON["V" DR=DR_";143////1",PSIVACT=""
        I RXON["U" D NEWUDAL^PSGAL5(PSJHLDFN,RXON,22010)
        I RXON["P" D NEWNVAL^PSGAL5(RXON,22010)
        S PSGNVF=1 D ^DIE
        I RXON["V" NEW ON55,DFN,PSIVAL,PSIVREA,PSIVLN K PSIVACT D
        . S ON55=RXON,DFN=PSJHLDFN,PSIVAL="ORDER VERIFIED BY NURSE",PSIVALT="",PSIVREA="V"
        . D LOG^PSIVORAL
        D:RXON["P" EN^PSJLOI(PSJHLDFN,RXON) D:RXON["U" EN2^PSJLOI(PSJHLDFN,RXON)
        K:RXON["U" ^PS(55,"ANV",PSJHLDFN,+RXON)
        I $T(NURV^ALPBCBU)'="" D NURV^ALPBCBU(PSJHLDFN,RXON)
        Q
        ;
EDIT    ;Edit orders thru OE/RR
        N DA,DR,DIE,PREORDER,STPDT,PSIVACT,PSIVALT,ON55,PSIVREA,PSIVALCK,P
        S PREORDER=$S((PREON["N")!(PREON["P"):"^PS(53.1,"_+PREON_",2)",PREON["V":"^PS(55,"_PSJHLDFN_",""IV"","_+PREON_",0)",1:"^PS(55,"_PSJHLDFN_",5,"_+PREON_",2)")
        S STPDT=$S(PREON["V":$P($G(@PREORDER),"^",3),1:$P($G(@PREORDER),"^",4))
        D NOW^%DTC
        S DIE=$S(PREON["N"!(PREON["P"):"^PS(53.1,",PREON["V":"^PS(55,"_PSJHLDFN_",""IV"",",1:"^PS(55,"_PSJHLDFN_",5,"),DA=+PREON,DA(1)=+PSJHLDFN
        S DR=$S(PREON["V":"100////D;116////^S X=STPDT;123////E;114////"_PSJORDER_";.03////"_%,((PREON["P")!(PREON["N")):"25////"_%_";28////DE;107////E;105////"_PSJORDER_";32////"_STPDT,1:"25////"_STPDT_";28////DE;107////E;105////"_PSJORDER_";34////"_%)
        I PREON["U"!(PREON["A") S PSGAL("C")=4100 D ^PSGAL5
        I PREON["V" S PSIVACT=1,PSIVALT=2,ON55=PREON,PSIVREA="D",PSIVALCK="STOP",P(3)=STPDT
        D ^DIE,AUE^PSJHL6(PSJHLDFN,PREON)
        I PREON["V" N DFN S DFN=PSJHLDFN D LOG^PSIVORAL
        S PSJHLMTN="ORM",PSOC=$S((PREON["N")!(PREON["P"):"OC",1:"OD") D EN1^PSJHL2(PSJHLDFN,PSOC,PREON) S PSJHLMTN="ORR",PSOC="XO"
        Q
        ;
EDITCK  ;Check to see if PSJHLDFN passed matches PSJHLDFN in pending order.
        I (PREON["N")!(PREON["P"),PSJHLDFN'=$P($G(^PS(53.1,+PREON,0)),U,15) D
        . S ORDCON="Patient does not match/Edit Msg" S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(ORDCON,.PSJMSG)
        . D EN1^PSJHLERR(PSJHLDFN,"UX",$P(ORDER,"^"),ORDCON) S QFLG=1
        Q
        ;
STATUS  ;Check status of an order in response to a send order status request from CPRS.
        N STATUS,STPDT,NODE,NODE2
        S NODE=$G(@(RXORDER_"0)")),NODE2=$G(@(RXORDER_"2)"))
        I 'NODE S PSREASON="Invalid Pharmacy order number" D  Q
        .S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(PSREASON_"/Status Check",.PSJMSG)
        .D EN1^PSJHLERR(PSJHLDFN,"DE",$P(ORDER,U),PSREASON)
        S $P(@(RXORDER_"0)"),"^",21)=$P(ORDER,"^")
        S STATUS=$S(RXON["V":$P(NODE,"^",17),1:$P(NODE,"^",9))
        S STPDT=$S(RXON["V":$P(NODE,"^",3),1:$P(NODE2,"^",4))
        D NOW^%DTC I RXON'["P" I "DEH"'[STATUS I STPDT<% D EXPIR^PSJHL6 Q
        D EN1^PSJHL2(PSJHLDFN,"SC",RXON)
        Q
        ;
FLAG    ;Flag/Unflag orders
        I '$P($G(@(RXORDER_"0)")),U) S ORDCON="Invalid Pharmacy order number/Flag Msg" S X="ORERR" X ^%ZOSF("TEST") I  D EN^ORERR(ORDCON,.PSJMSG) Q
        Q:'$P($G(@(RXORDER_"0)")),U)
        S DIE=$S(RXON["N"!(RXON["P"):"^PS(53.1,",RXON["V":"^PS(55,"_PSJHLDFN_",""IV"",",1:"^PS(55,"_PSJHLDFN_",5,"),DA=+RXON,DA(1)=PSJHLDFN
        S DR=$S(PSJFLAG="FL":$S(RXON["V":"148////1",1:"124////1"),1:$S(RXON["V":"148////@",1:"124////@"))
        D ^DIE
        I $G(FLCMNT)]"" S FLCMNT=$$UNESC^ORHLESC(FLCMNT)
        I RXON["U" D
        . S ^PS(55,PSJHLDFN,5,+RXON,13)=FLCMNT
        . S FLCMNT="COMMENTS: "_FLCMNT S:$L(FLCMNT)>52 FLCMNT=$E(FLCMNT,1,49)_"..."
        . D NEWUDAL^PSGAL5(PSJHLDFN,+RXON,$S((PSJFLAG="FL")&(PSJYN="PHR"):7000,(PSJFLAG="UF")&(PSJYN="PHR"):7010,(PSJFLAG="FL")&(PSJYN=""):7020,1:7030),FLCMNT)
        I RXON["V" N DFN,ON55,PSIVREA,PSIVAL S DFN=PSJHLDFN S PSIVALT="",ON55=RXON,PSIVREA=$S(PSJFLAG="FL":"G",1:"UG"),PSIVAL=$S(PSJYN="PHR":"FLAGGED BY PHARMACIST ",1:"FLAGGED BY CPRS ")_FLCMNT D LOG^PSIVORAL
        I RXON["P" D
        . S ^PS(53.1,+RXON,13)=FLCMNT
        . S FLCMNT="COMMENTS: "_FLCMNT S:$L(FLCMNT)>52 FLCMNT=$E(FLCMNT,1,49)_"..."
        . D NEWNVAL^PSGAL5(+RXON,$S((PSJFLAG="FL")&(PSJYN="PHR"):7000,(PSJFLAG="UF")&(PSJYN="PHR"):7010,(PSJFLAG="FL")&(PSJYN=""):7020,1:7030),FLCMNT)
        ;The ... on Unit Dose and Pending orders is because of the limitations in the DD of 53.1.
        Q
