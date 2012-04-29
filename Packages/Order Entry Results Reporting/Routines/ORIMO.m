ORIMO   ;SLC/JDL - Inpatient medication on outpatient. ; 02/12/2007
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**187,190,195,215,243**;Dec 17, 1997;Build 242
IMOLOC(ORY,ORLOC,ORDFN) ;ORY>=0: LOC is an IMO authorized location
        S ORY=-1
        N PACH
        S PACH=$$PATCH^XPDUTL("PSJ*5.0*111")
        Q:'PACH
        I $L($TEXT(SDIMO^SDAMA203)) D
        . ;#DBIA 4133
        . S ORY=$$SDIMO^SDAMA203(ORLOC,ORDFN)
        . ;if RSA returns an error then check against Clinic Loc.
        . I ORY=-3 D
        . .I $P($G(^SC(ORLOC,0)),U,3)'="C" Q
        . .I $D(^SC("AE",1,ORLOC))=1 S ORY=1
        . K SDIMO(1)
        Q
        ;
IMOOD(ORY,ORDERID)      ;Is it an IMO order?
        Q:'$D(^OR(100,+ORDERID,0))
        N PIMO,DGRP,IMOGRP,ISIMO
        S (PIMO,DGRP,ISIMO)=0
        I $P($G(^OR(100,+ORDERID,0)),U,18)>0 S PIMO=1
        S DGRP=$P($G(^OR(100,+ORDERID,0)),U,11)
        S IMOGRP=$O(^ORD(100.98,"B","CLINIC ORDERS",""))
        I DGRP=IMOGRP S ISIMO=1
        I PIMO,ISIMO S ORY=1
        Q
        ;
ISCLOC(ORY,ALOC)        ;Is it a clinical location
        S ORY=0
        Q:'$D(^SC(+ALOC,0))
        I $P(^SC(+ALOC,0),U,3)="C" S ORY=1
        Q
ISIVQO(ORY,DLGID)       ;Is it an IV quick order
        S ORY=0
        Q:'$D(^ORD(101.41,DLGID,0))
        N IVGRP,DLGTYP,DLGGRP
        S IVGRP=$O(^ORD(100.98,"B","IV RX",0))
        S DLGTYP=$P($G(^ORD(101.41,DLGID,0)),U,4)
        S DLGGRP=$P($G(^ORD(101.41,DLGID,0)),U,5)
        I (DLGTYP="Q"),(DLGGRP=IVGRP) S ORY=1
        Q
