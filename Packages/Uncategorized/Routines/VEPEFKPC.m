VEPEFKPC ; install and build file checker
 ;;1.0;VEPE - DAOU SYSTEMS;**1**; 01-OCT-2003
 ;; Copyright 2003 Daou Systems, Inc.
 ;
 Q
EN(XPDT,XPDQUIT,TARBLD) ; entry point
 ;
 ; XPDT is an array passed into this routine -
 ;      XPDT(ien) = [1] Transport global Install IEN
 ;                  [2] Name of Patch being installed
 ; XPDQUIT is an output variable indicating if the Install should stop
 ; TARBLD is the IEN of the target build that you want to check to see
 ;        if there is any overlap
 ;
 NEW OK,IEN,INST,NAME,BLD,BCIEN,BCTYP,BCNAME,DIR,X,Y
 NEW DTOUT,DUOUT,DIRUT,DIROUT,GLO,TARBLDNM
 NEW FILNUM,SUBFIL,FIELD
 I '$G(TARBLD) S XPDQUIT=1 G EXIT
 S OK=1,TARBLDNM=$P($G(^XPD(9.6,TARBLD,0)),U,1)
 S IEN=0
 F  S IEN=$O(XPDT(IEN)) Q:'IEN  D
 . S INST=$P(XPDT(IEN),U,1)
 . S NAME=$P(XPDT(IEN),U,2)
 . S BLD=$O(^XPD(9.6,"B",NAME,""))    ; build file
 . W !!?3,"Checking ",NAME," for overlap with ",TARBLDNM," "
 . I BLD S GLO="^XPD(9.6,BLD)"        ; build file
 . E  D  I 'OK Q
 .. S BLD=$O(^XTMP("XPDI",INST,"BLD",0))
 .. I 'BLD W "NO BUILD FOUND!!" S OK=0 Q
 .. S GLO="^XTMP(""XPDI"",INST,""BLD"",BLD)"     ; transport global
 .. Q
 . ;
 . ;
 . ; loop thru all build components in the incoming build
 . S BCIEN=0
 . F  S BCIEN=$O(@GLO@("KRN",BCIEN)) Q:'BCIEN  D
 .. I '$P($G(@GLO@("KRN",BCIEN,"NM",0)),U,4) Q
 .. S BCTYP=$P($G(^DIC(BCIEN,0)),U,1)    ; build component type
 .. W "."      ; display "." for each type of build component found
 .. S BCNAME=""
 .. F  S BCNAME=$O(@GLO@("KRN",BCIEN,"NM","B",BCNAME)) Q:BCNAME=""  D
 ... I '$D(^XPD(9.6,TARBLD,"KRN",BCIEN,"NM","B",BCNAME)) Q
 ... W !?8,BCNAME,?54,BCTYP," OVERLAP"
 ... S OK=0
 ... Q
 .. Q
 . ;
 . ;
 . ; DATA DICTIONARIES
 . S FILNUM="" W "."
 . F  S FILNUM=$O(@GLO@(4,"APDD",FILNUM)) Q:FILNUM=""  D
 .. S SUBFIL=""
 .. F  S SUBFIL=$O(@GLO@(4,"APDD",FILNUM,SUBFIL)) Q:SUBFIL=""  D
 ... ; if the $D'=11 and the same DD/multiple is in the target build,
 ... ; then display a message and quit
 ... I $D(@GLO@(4,"APDD",FILNUM,SUBFIL))'=11,$D(^XPD(9.6,TARBLD,4,"APDD",FILNUM,SUBFIL)) W !?8,FILNUM,"/",SUBFIL,?54,"Data Dictionary overlap" S OK=0 Q
 ... ; now look at all the fields
 ... S FIELD=""
 ... F  S FIELD=$O(@GLO@(4,"APDD",FILNUM,SUBFIL,FIELD)) Q:FIELD=""  D
 .... I '$D(^XPD(9.6,TARBLD,4,"APDD",FILNUM,SUBFIL,FIELD)) Q
 .... W !?8,FILNUM,"/",SUBFIL,":",FIELD,?54,"Data Dictionary overlap"
 .... S OK=0
 .... Q
 ... Q
 .. Q
 . ;
 . I OK W " OK",!?12,"No overlap found"
 . ;
 . Q
 ;
 I OK W ! G EXIT
 ;
 W !!?5,"Some overlap was found as listed above"
 S DIR(0)="Y"
 S DIR("A")="     Do you want to Quit this install so you can review the situation"
 S DIR("B")="YES"
 D ^DIR K DIR
 I 'Y G EXIT       ; no, don't quit the installation, get out of here
 ; At this point, yes, quit the installation
 ; set variable to quit the installation
 S XPDQUIT=1
 ; ***
EXIT ;
 Q
 ;
 ;
 ; This is where it goes!
 ;
 ;XPDI    ;SFISC/RSD - Install Process ;11/20/2000  14:22
 ;        ;;8.0;KERNEL;**10,21,39,41,44,58,68,108,145,184**;Jul 10, 1995
 ;EN      ;install
 ;        N DIR,DIRUT,POP,XPD,XPDA,XPDD,XPDIJ,XPDDIQ,XPDIT,XPDIABT,XPDNM,XPDNOQUE,XPDPKG,XPDREQAB,XPDST,XPDSET,XPDSET1,XPDT,XPDQUIT,XPDQUES,Y,ZTSK,%
 ;        S %="I '$P(^(0),U,9),$D(^XPD(9.7,""ASP"",Y,1,Y)),$D(^XTMP(""XPDI"",Y))",
 ;XPDST=$$LOOK^XPDI1(%)
 ;        Q:'XPDST!$D(XPDQUIT)
 ;        ;;;
 ;        D EN^VEPEFKPC(.XPDT,.XPDQUIT,xxxxxx) Q:$D(XPDQUIT)
 ;           where xxxxxx is the IEN of the target build
 ;           in ^XPD(9.6,xxxxxx,0)
 ;        ;;;
 ;        S XPDIT=0,(XPDSET,XPDSET1)=$P(^XPD(9.7,XPDST,0),U) K ^TMP($J)
 ;        ;Check each part of XPDT array
