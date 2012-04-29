PXCEC800        ;ISL/dee,ISA/KWP - Used in editing the 800 node, Service Connected conditions ;12/22/04 1:38pm
        ;;1.0;PCE PATIENT CARE ENCOUNTER;**124,174,168**;Aug 12, 1996;Build 14
        ;; ;
        Q
        ;
GET800  ;Used by the Service Connected Conditions
        N PXCEINDX,PXOUT
        N PXBDATA,PXLOC,PXAPTDT,PXDFN
        I $O(^SCE("AVSIT",PXCEVIEN,0)) D CLASS^PXBAPI21("","","","",PXCEVIEN)
        I '$O(^SCE("AVSIT",PXCEVIEN,0)) D
        . S PXAPTDT=+^AUPNVSIT(PXCEVIEN,0)
        . S PXDFN=$P(^AUPNVSIT(PXCEVIEN,0),"^",5)
        . S PXLOC=$P(^AUPNVSIT(PXCEVIEN,0),"^",22)
        . D CLASS^PXBAPI21("",PXDFN,PXAPTDT,PXLOC,"")
        F PXCEINDX=1:1:8 I $G(PXBDATA("ERR",PXCEINDX))=4 S PXOUT=PXBDATA("ERR",PXCEINDX)
        I $D(PXOUT) S PXCEEND=1 Q  ;for visit and required fields
        S $P(PXCEAFTR(800),"^",1)=$P($G(PXBDATA(3)),"^",2)
        S $P(PXCEAFTR(800),"^",2)=$P($G(PXBDATA(1)),"^",2) S:$P(PXCEAFTR(800),"^",2)="" $P(PXCEAFTR(800),"^",2)="@"
        S $P(PXCEAFTR(800),"^",3)=$P($G(PXBDATA(2)),"^",2) S:$P(PXCEAFTR(800),"^",3)="" $P(PXCEAFTR(800),"^",3)="@"
        S $P(PXCEAFTR(800),"^",4)=$P($G(PXBDATA(4)),"^",2) S:$P(PXCEAFTR(800),"^",4)="" $P(PXCEAFTR(800),"^",4)="@"
        S $P(PXCEAFTR(800),"^",5)=$P($G(PXBDATA(5)),"^",2)
        S $P(PXCEAFTR(800),"^",6)=$P($G(PXBDATA(6)),"^",2)
        S $P(PXCEAFTR(800),"^",7)=$P($G(PXBDATA(7)),"^",2)
        S $P(PXCEAFTR(800),"^",8)=$P($G(PXBDATA(8)),"^",2)
        Q
        ;
