MCEF    ;WISC/MLH-FILEMAN ENTER/EDIT OF MED PROCS ;4/7/97  11:15
        ;;2.3;Medicine;**8,15,42**;09/13/1996;Build 1
        ; Reference DBIA #10061[Supported] call to VADPT
ENTED   ;(MCARGNAM,FULBRIEF);enter/edit entry point
        K DIC
        D MCEPROC^MCARE
        ;    extract global loc, print name, full IT name, brief IT name, pat fld
        S DIC(0)="AEQLMZ"
        S (DIC,DIE)="^MCAR("_MCFILE_","
        I MCESON S DIC("S")=$$PREEDIT^MCESSCR(MCFILE)
        I MCPRO="GEN" S DIC("S")="I '$P(^MCAR(699.5,+Y,0),U,3)"
        S (DLAYGO,DIDEL)=MCFILE
        D DATE^MCAREH
        D ^DIC ;    get record to edit
        I Y<0 K DIC Q
        S MCARGDA=+Y
        I MCFILE=691.5,$D(^MCAR(MCFILE,MCARGDA,"A")) Q:'MCESON  D ESRC^MCESSCR(MCFILE,.MCARGDA) G:$D(MCBACK) BACK Q  ;RMP
        I MCESON,("125"'[$$ESTONUM^MCESSCR(MCFILE,MCARGDA)) D ESRC^MCESSCR(MCFILE,.MCARGDA) Q:'$D(MCBACK)
        D:$D(MCBACK) BACK
        I Y'<0,MCFILE=699.5 N MCGEN S MCGEN=0 D GENEX^MCARGES(+Y,.MCGEN) Q:MCGEN
        K DTOUT,DUOUT  ;MC*2.3*8
        D EDIT ;edit the record
        ;D ESRC^MCESSCR(MCFILE,MCARGDA)  ;MC*2.3*8, MOVED DOWN
        K MCBACK,DIR,DIC,MCFILE,MCARGDA,DA,DFN,DR,MCPATNM,DTOUT,DUOUT
        Q
EDIT    ;
        ;N DA,DFN,DR,MCARGDA
        S (MCARGDA,DA)=+Y ;    record number
        ;    choose and format input template
        S DR="["_MCEPROC_"]"
        S DFN=$P(Y(0),U,2)
        D IN^MCEO ;    order entry
        ;I '$D(DUOUT),'$D(DTOUT) D EDIT2
        I '$D(DUOUT) D EDIT2  ;MC*2.3*8
        Q
EDIT2   ;
        D ^DIE ;    edit the record
        I '$D(DA),$D(MCBACK) D BACKSS^MCESEDT K MCBACK
        Q:'$D(DA)
        I MCFILE=699.5 N MCGEN S MCGEN=0 D GENEX^MCARGES(MCARGDA,.MCGEN) Q:MCGEN
        I '$D(DUOUT) D EDIT3  ;MC*2.3*8
        Q
EDIT3   ;
        S DR=MCPATFLD,DA=MCARGDA,DIQ(0)="E"
        S DIC="^MCAR("_MCFILE_"," ; WAA 5/14/96
        D EN^DIQ1
        S MCPATNM=$G(^UTILITY("DIQ1",$J,MCFILE,DA,MCPATFLD,"E"))
        I $L(MCPOSTP)>1 S X=MCPOSTP X ^%ZOSF("TEST") D:$T @MCPOSTP
        Q:$D(DUOUT)  ;MC*2.3*8
        D OUT^MCEO,PCC^MCARE1 ;    order entry, PCC
        Q:$D(DUOUT)  ;MC*2.3*8
        D ESRC^MCESSCR(MCFILE,MCARGDA)  ;MC*2.3*8
        Q
BACK    ;Set Y to the new record and allow the user to edit the new record
        S Y=MCY,Y(0)=MCY(0),Y(0,0)=MCY(0,0),MCARGDA=+Y K MCY,DIROUT,DUOUT,DTOUT,EXIT
        Q
MCSEX(DFN)      ;
        N MCSEX,VADM
        ; Due to Patient data merge the DIC error out referencing file 690
        ; Uncomment next line if patching MCEF.
        S:DIC="^MCAR(690," DIC="^MCAR(700,"
        I '$D(DFN) S DFN=$P(@(DIC_DA_",0)"),U,2)
        D DEM^VADPT
        S MCSEX=$P(VADM(5),U,1)
        ;D KVAR^VADPT
        Q $S(MCSEX="M":1,MCSEX="F":2,1:0)
