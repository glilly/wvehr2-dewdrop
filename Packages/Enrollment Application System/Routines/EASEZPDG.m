EASEZPDG        ;ALB/AMA/GTS/CMF - PRINT 10-10EZ OR EZR FROM DG OPTIONS ; 8/1/08 1:23pm
        ;;1.0;ENROLLMENT APPLICATION SYSTEM;**57,70**;Mar 15, 2001;Build 26
        ;
        Q
        ;
ENEZR(EASDFN,EASMTIEN)  ;DBIA 4600 - PRINT THE 10-10EZR FROM DG OPTIONS
        ;   INPUT:
        ;      EASDFN - POINTER TO THE PATIENT FILE (#2) - required
        ;      EASMTIEN - POINTER TO MEANS TEST FILE (#408.31) - optional
        ;       (+ien, "", or 0)
        ;   OUTPUT:
        ;      (+ien or ""):ZTSK - TASKMAN JOB NUMBER
        ;      (0):mt ien (forces test lookup only)
        ;
        N EASFLAG,X
        S EASFLAG="EZR"
        S EASDFN=$G(EASDFN)
        S EASMTIEN=$G(EASMTIEN)
        ;
        S X=$$ENEZ(EASDFN,EASMTIEN)
        Q X
        ;
ENEZ(EASDFN,EASMTIEN)   ;DBIA 4600 - PRINT THE 10-10EZ FROM DG OPTIONS
        ;   INPUT:
        ;      EASDFN - POINTER TO THE PATIENT FILE (#2) - required
        ;      EASMTIEN - POINTER TO MEANS TEST FILE (#408.31) - optional
        ;       (+ien, "", or 0)
        ;   OUTPUT:
        ;      (+ien or ""):ZTSK - TASKMAN JOB NUMBER
        ;      (0):mt ien (forces test lookup only)
        ;
        S EASDFN=$G(EASDFN)
        S EASMTIEN=$G(EASMTIEN)
        I EASMTIEN=0 Q $$PICK^EASEZPVU(EASDFN,0)
        E  S EASMTIEN=$$PICK^EASEZPVU(EASDFN,EASMTIEN)
        ;
        ;If any EAS applications exist, ensure they're all filed
        N X,INPROG
        S X=0,INPROG=0 F  S X=$O(^EAS(712,"AC",EASDFN,X)) Q:'X!INPROG  D
        . I $$GET1^DIQ(712,X,7.1)="" D
        . . N IX,DATE F IX="REV","PRT","SIG" Q:INPROG  D
        . . . S DATE=0 F  S DATE=$O(^EAS(712,IX,DATE)) Q:'DATE!INPROG  D
        . . . . I $D(^EAS(712,IX,DATE,X)) S INPROG=1
        I INPROG D  Q 0
        . N DIR
        . W !!,"No data have been found for the selected patient, or"
        . W !,"the patient may have an on-line 10-10EZ application"
        . W !,"in progress.  The 10-10EZ"_$S($G(EASFLAG)="EZR":"R",1:"")_" form shall not be printed."
        . S DIR(0)="E" D ^DIR
        ;
        N %ZIS,ZTDESC,ZTIO,ZTRTN,ZTSAVE,ZTSK,ZUSR,POP,ERR
        ;
        W !!?5,*7,"Do not select a slave device for output."
        W !?5,"This output requires a 132 column output printer."
        W !?5,"Output to SCREEN will be unreadable.",!
        ;
        ;
DEV     S %ZIS="QM"
        S %ZIS("S")="I $P($G(^(1)),U)'[""SLAVE""&($P($G(^(0)),U)'[""SLAVE"")"
        S %ZIS("B")=""
        ;S IOP="Q"
        D ^%ZIS
        ;
        I POP D  G EXIT
        . I $D(IO("Q")) K IO("Q")
        . W !,"Print request cancelled!"
        . Q
        I IO=IO(0),$E(IOST,1,2)="C-" D  G DEV
        . W !,*7,"CANNOT QUEUE TO HOME DEVICE!",!
        . Q
        ;
        I $G(EASFLAG)="EZR" S ZTDESC="1010EZR PRINT"
        E  S ZTDESC="1010EZ PRINT"
        S ZUSR=DUZ,ZTRTN="EN^EASEZPDG"
        ;
        F X="ZUSR","EASDFN","EASMTIEN","EASFLAG" S ZTSAVE(X)=""
        D ^%ZTLOAD
        D HOME^%ZIS
        ;
EXIT    Q +$G(ZTSK)
        ;
EN      ;BACKGROUND JOB ENTRY POINT TO PRINT EZ/EZR FROM DG OPTIONS
        ;
        N EASAPP,C2711
        S EASAPP=0
        I '$G(EASVRSN) S EASVRSN=6
        ;
        ;SET UP ^TMP("EZDATA" AND ^TMP("EZINDEX" FROM ^EAS(711,"A","A"
        D LOCAL711^EASEZU2
        ;
        S C2711=+$$KEY711^EASEZU1("TYPE OF BENEFIT-ENROLLMENT")
        D VISTA^EASEZPVD(EASDFN,EASMTIEN)
        ;
        ;SET UP ^TMP("EZTEMP" AND ^TMP("EZDISP" GLOBALS
        D SORT^EASEZC3(0)
        ;
        ;SET UP PRINT VARIABLES
        N EALNE,EAINFO,EAABRT,EAADL,EAMULT,EAAD,EACNT,KEY
        D SETUP^EASEZPDU(.EALNE,.EAINFO)
        ;
        ;DETERMINE WHICH FORM TO PRINT
        I $G(EASFLAG)="EZR" D EZR I 1
        E  D EZ
        ;
        K ^TMP("EASEZ",$J),^TMP("EASEZR",$J)
        K ^TMP("EZDATA",$J),^TMP("EZRDATA",$J)
        K ^TMP("EZINDEX",$J),^TMP("EZRINDEX",$J)
        K ^TMP("EZTEMP",$J),^TMP("EZRTEMP",$J)
        K ^TMP("EZDISP",$J),^TMP("EZRDISP",$J)
        Q
        ;
EZR     ; Entry point to print 1010EZR
        ;
        N EASDG,EAADL,EAAD,EACNT
        M ^TMP("EASEZR",$J)=^TMP("EASEZ",$J) K ^TMP("EASEZ",$J)
        M ^TMP("EZRDATA",$J)=^TMP("EZDATA",$J) K ^TMP("EZDATA",$J)
        M ^TMP("EZRINDEX",$J)=^TMP("EZINDEX",$J) K ^TMP("EZINDEX",$J)
        M ^TMP("EZRTEMP",$J)=^TMP("EZTEMP",$J) K ^TMP("EZTEMP",$J)
        M ^TMP("EZRDISP",$J)=^TMP("EZDISP",$J) K ^TMP("EZDISP",$J)
        ;
        D PAGE1^EASEZRPU
        D EN^EASEZRP1(.EALNE,.EAINFO)
        ;
        D PAGE2^EASEZRPP
        S EASDG=1   ;FLAG VARIABLE TO SIGNIFY PRINTING FROM DG
        D EN^EASEZRP2(.EALNE,.EAINFO,EASDG)
        ;
        ;EAS*1.0*70
        N EASMTV
        I +$G(EASMTIEN) S EASMTV=+$P($G(^DGMT(408.31,EASMTIEN,2)),U,11)
        I +$G(EASMTV)=0 D NETEZR^EASEZPDU(.EALNE,.EAINFO,EASDG) I 1
        E  D EN^EASEZRP3(.EALNE,.EAINFO,EASDG)
        ;
        ;Print additional insurance pages if more than 1 insurance company
        F EAADL=1:1 Q:'$D(^TMP("EZRTEMP",$J,"IA",EAADL))  D
        . S EAAD=1
        . D PAGEI^EASEZRPU(EAADL)
        I $G(EAAD) D EN^EASEZRPI(.EALNE,.EAINFO)
        ;
        ;Print additional dependent pages if more than 1 dependent
        S EAAD=0 F EAADL=1:1 Q:'$D(^TMP("EZRTEMP",$J,"IIB",EAADL))  D
        . S EAAD=1   ;FLAG THAT THERE ARE ADDITIONAL DEPENDENTS
        . D PAGEN^EASEZRPU(EAADL)
        I EAAD D EN^EASEZRPD(.EALNE,.EAINFO)
        ;
        ;Print additional dependent financial pages if more
        ;than 1 dependent, starting with the 2nd one
        ;(since Child 1 info already displayed on pages 2 & 3)
        S EAAD=0,EAADL=1 F  S EAADL=$O(^TMP("EZRTEMP",$J,"IIF",EAADL)) Q:'EAADL  D
        . S EAAD=1,KEY=+$$KEY711^EASEZU1("CHILD(N) CHILD #")
        . S ^TMP("EZRTEMP",$J,"IIF",EAADL,"7.")=KEY_"^CHILD "_EAADL_"^1"
        . D PAGEDFF^EASEZRPP(EAADL)
        ;
        ;EAS*1.0*70
        I +$G(EASMTV)=0 D  Q
        . ;SINCE ANY ADDITIONAL DEPENDENTS' NET WORTH AMOUNTS (SECTION IIG)
        . ;ARE INCLUDED IN THE VET'S AMOUNT, DISPLAY A MESSAGE ON THE FORM
        . I EAAD D
        . . N TEMP,HDR,FTR,BEGF,BEGG,ADFF,FNP,GNP
        . . S TEMP="EASEZR",HDR="HDR^EASEZRPF(.EALNE,.EAINFO)"
        . . S FTR="FT^EASEZRPF(.EALNE,.EAINFO)",BEGF="BEGINF^EASEZRPM"
        . . S BEGG="BEGING^EASEZRPM",ADFF="ADFF^EASEZRPM"
        . . S FNP=9,GNP=7
        . . D NETMSG
        . ;
        E  D
        . ;WITH NEW MEANS TEST VERSION, DISPLAY EACH CHILD'S NET WORTH AMOUNTS
        . N EAADG
        . S EAADG=0,EAADL=1 F  S EAADL=$O(^TMP("EZRTEMP",$J,"IIG",EAADL)) Q:'EAADL  D
        . . S EAADG=1,KEY=+$$KEY711^EASEZU1("CHILD(N) CHILD #")
        . . S ^TMP("EZRTEMP",$J,"IIG",EAADL,"9.")=KEY_"^CHILD "_EAADL_"^1"
        . . D PAGEDFG^EASEZRPP(EAADL)
        . I EAAD!EAADG D EN^EASEZRPM(.EALNE,.EAINFO,EASDG)
        ;
        Q
        ;
EZ      ;PRINT THE 10-10EZ FORM (copied from EASEZP6F)
        ;
        N EASDG,EAADL,EAAD,EACNT
        D PAGE1^EASEZP6U
        D PAGE1^EASEZPU3
        D EN^EASEZP61(.EALNE,.EAINFO)
        ;
        D PAGE2^EASEZPU2
        D EN^EASEZP62(.EALNE,.EAINFO)
        ;
        S EASDG=1   ;FLAG VARIABLE TO SIGNIFY PRINTING FROM DG
        D EN^EASEZP63(.EALNE,.EAINFO,EASDG)
        ;
        ;EAS*1.0*70
        N EASMTV
        I +$G(EASMTIEN) S EASMTV=+$P($G(^DGMT(408.31,EASMTIEN,2)),U,11)
        I +$G(EASMTV)=0 D NETEZ^EASEZPDU(.EALNE,.EAINFO,EASDG) I 1
        E  D EN^EASEZP64(.EALNE,.EAINFO,EASDG)
        ;
        ;Print additional insurance pages if more than 1 insurance company
        F EAADL=1:1 Q:'$D(^TMP("EZTEMP",$J,"IA",EAADL))  D
        . S EAAD=1
        . D PAGEI^EASEZPU3(EAADL)
        I $G(EAAD) D EN^EASEZP6I(.EALNE,.EAINFO)
        ;
        ;Print additional dependent pages if more than 1 dependent
        S EAAD=0 F EAADL=1:1 Q:'$D(^TMP("EZTEMP",$J,"IIB",EAADL))  D
        . S EAAD=1   ;FLAG THAT THERE ARE ADDITIONAL DEPENDENTS
        . D PAGEN^EASEZPU3(EAADL)
        I EAAD D EN^EASEZP6D(.EALNE,.EAINFO)
        ;
        ;Print additional dependent financial pages if more
        ;than 1 dependent, starting with the 2nd one
        ;(since Child 1 info already displayed on pages 2 & 3)
        S EAAD=0,EAADL=1 F  S EAADL=$O(^TMP("EZTEMP",$J,"IIF",EAADL)) Q:'EAADL  D
        . S EAAD=1,KEY=+$$KEY711^EASEZU1("CHILD(N) CHILD #")
        . S ^TMP("EZTEMP",$J,"IIF",EAADL,"7.")=KEY_"^CHILD "_EAADL_"^1"
        . D PAGEDFF^EASEZPU2(EAADL)
        ;
        ;EAS*1.0*70
        I +$G(EASMTV)=0 D  Q
        . ;SINCE ANY ADDITIONAL DEPENDENTS' NET WORTH AMOUNTS (SECTION IIG)
        . ;ARE INCLUDED IN THE VET'S AMOUNT, DISPLAY A MESSAGE ON THE FORM
        . I EAAD D
        . . ;PRINT IIF AND IIG SECTIONS
        . . N TEMP,HDR,FTR,BEGF,BEGG,ADFF,FNP,GNP
        . . S TEMP="EASEZ",HDR="HDR^EASEZP6F(.EALNE,.EAINFO)"
        . . S FTR="FT^EASEZP6F(.EALNE,.EAINFO)",BEGF="BEGINF^EASEZP6M"
        . . S BEGG="BEGING^EASEZP6M",ADFF="ADFF^EASEZP6M"
        . . S FNP=9,GNP=7
        . . D NETMSG
        . ;
        E  D
        . ;WITH NEW MEANS TEST VERSION, DISPLAY EACH CHILD'S NET WORTH AMOUNTS
        . N EAADG
        . S EAADG=0,EAADL=1 F  S EAADL=$O(^TMP("EZTEMP",$J,"IIG",EAADL)) Q:'EAADL  D
        . . S EAADG=1,KEY=+$$KEY711^EASEZU1("CHILD(N) CHILD #")
        . . S ^TMP("EZTEMP",$J,"IIG",EAADL,"9.")=KEY_"^CHILD "_EAADL_"^1"
        . . D PAGEDFG^EASEZPU2(EAADL)
        . I EAAD!EAADG D EN^EASEZP6M(.EALNE,.EAINFO,EASDG)
        ;
        Q
        ;
NETMSG  ;PRINT THE MESSAGE FOR THE NET WORTH SECTION
        ;
        N EASF,DEPF,DFCNT,NEWPG
        ;
        S EASF=$NA(^TMP(TEMP,$J,"DFF"))
        I $O(@EASF@(1)) D @BEGF
        ;
        ;Start printing with 2nd dependent
        S DEPF=1,DFCNT=0 F  S DEPF=$O(@EASF@(DEPF)) Q:'DEPF  D
        . S DFCNT=DFCNT+1
        . ;Check to see if a new page is needed
        . I (DFCNT>1),'((DFCNT-1)#FNP) D
        . . D @FTR
        . . D @BEGF
        . I (DFCNT#FNP)'=1 W !?131,$C(13) W:EALNE("ULC")="-" ! W EALNE("UL")
        . D @ADFF
        ;
        ;PRINT NET WORTH MESSAGE IF THERE ARE *any* ADDITIONAL DEPENDENTS
        I ((DFCNT#FNP)'=0),((DFCNT#FNP)'=GNP) W !!,?131,$C(13) W:EALNE("ULC")="-" ! W EALNE("UL")
        ;At the end of IIF, to find when to jump to the next page, 
        ;55 print lines, minus 3 lines for Section IIG title header,
        ;minus the number of lines already used on current page,
        ;divided by the number of lines for a Section IIG entry
        S NEWPG=(52-((DFCNT#FNP)*6))\7
        I '(DFCNT#FNP)!'NEWPG!(NEWPG=GNP) S NEWPG=GNP D @FTR
        D @BEGG
        W !!?23,"ANY PREVIOUS CALENDAR YEAR NET WORTH AMOUNTS FROM ANY ADDITIONAL DEPENDENT CHILD(REN)"
        W !!?29,"WILL BE INCLUDED IN THE VETERAN'S PREVIOUS CALENDAR YEAR NET WORTH AMOUNTS.",!
        D @FTR
        ;
        Q
