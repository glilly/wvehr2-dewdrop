GMTSPXHR        ; SLC/SBW,KER - PCE Clinical Reminders/Maint ; 06/22/2009
        ;;2.7;Health Summary;**8,22,23,28,34,56,63,75,82,89**;Oct 20, 1995;Build 61
        ;
        ; External References
        ;   DBIA  2182  MAIN^PXRM
        ;                       
MAIN    ; Entry Point for Clinical Reminders
        N CM,GMFLAG,HVET,HVDISP
        S (HVET,CM)=0
        I GMTSEGH["CR" S GMFLAG=0
        I GMTSEGH["CRS" S GMFLAG=1
        I GMTSEGH["CM" S GMFLAG=5,CM=1
        I GMTSEGH["CMB" S GMFLAG=4,CM=1
        I GMTSEGH["CF" S GMFLAG=5,CM=1
        I GMTSEGH["CLD" S GMFLAG=1,CM=0
        I GMTSEGH["MHVD" S HVET=1,CM=1,HVDISP=11
        I GMTSEGH["MHVS" S HVET=1,CM=1,HVDISP=10
        Q:+$G(GMTSAGE)'>0!($G(SEX)="")!($G(DFN)'>0)
        I HVET=1 D HVET Q
        Q:$O(GMTSEG(GMTSEGN,811.9,0))'>0
        N GMCR,GMFIRST,CRSEG,GMDISP
        S GMCR=0,GMFIRST=1
        F  S GMCR=$O(GMTSEG(GMTSEGN,811.9,GMCR)) Q:'GMCR  D  Q:$D(GMTSQIT)
        . S CRSEG=GMTSEG(GMTSEGN,811.9,GMCR)
        . K ^TMP("PXRHM",$J),^TMP("PXRM",$J)
        . D MAIN^PXRM(DFN,CRSEG,+$G(GMFLAG),1)
        . D:+$D(^TMP("PXRHM",$J)) GETCR
        I +$G(GMDISP)'>0 D CKP^GMTSUP Q:$D(GMTSQIT)  W "Selected Clinical Reminders not due.",!
        K ^TMP("PXRHM",$J),^TMP("PXRM",$J)
        Q
        ;
HVET    ;
        N GMFIRST
        K ^TMP("PXRHM",$J),^TMP("PXRMHV",$J)
        S GMFIRST=1
        D HS^PXRMHVET(DFN,HVDISP)
        D:+$D(^TMP("PXRMHV",$J)) GETCRH
        I +$G(GMDISP)'>0 D CKP^GMTSUP Q:$D(GMTSQIT)  W "No Patient Reminders found.",!
        K ^TMP("PXRHM",$J),^TMP("PXRMHV",$J)
        Q
        ;
GETCR   ; Get reminders that were returned
        N ITEM,GMDT,GMN0,X,GMTSDAT,GMTSDUE,GMREM
        I HVET=1 D GETCRH
        S ITEM=0
        F  S ITEM=$O(^TMP("PXRHM",$J,ITEM)) Q:ITEM'>0  D  Q:$D(GMTSQIT)
        . S GMREM=""
        . F  S GMREM=$O(^TMP("PXRHM",$J,ITEM,GMREM)) Q:GMREM=""  D CRDISP Q:$D(GMTSQIT)
        Q
        ;
GETCRH  ; Get Reminders that were returned for MyHealtheVet
        N ITEM,GMDT,GMN0,X,GMTSDAT,GMTSDUE,GMREM,GMSTATUS
        S GMSTATUS=""
        F  S GMSTATUS=$O(^TMP("PXRMHV",$J,GMSTATUS)) Q:GMSTATUS=""  D  Q:$D(GMTSQIT)
        .S GMREM="" F  S GMREM=$O(^TMP("PXRMHV",$J,GMSTATUS,GMREM)) Q:GMREM=""  D  Q:$D(GMTSQIT)
        ..S ITEM=0 F  S ITEM=$O(^TMP("PXRMHV",$J,GMSTATUS,GMREM,ITEM)) Q:ITEM'>0  D CRDISP Q:$D(GMTSQIT)
        Q
        ;
CRDISP  ; Display reminder data
        N DUECOL,HIST,LASTCOL,STATUS,STATCOL,TYPE
        I HVET=0 S GMN0=$G(^TMP("PXRHM",$J,ITEM,GMREM))
        I HVET=1 S GMN0=$G(^TMP("PXRMHV",$J,GMSTATUS,GMREM,ITEM))
        Q:GMN0']""
        S STATUS=$P(GMN0,U,1)
        S X=$P(GMN0,U,2) D REGDT4^GMTSU S GMTSDUE=X
        S X=$P(GMN0,U,3) D REGDT4^GMTSU S GMTSDAT=X
        S TYPE=$P(GMN0,U,4)
        I TYPE["E" S HIST="(hist)"
        I TYPE["X" S HIST="(exp)"
        S GMDISP=1
        D CKP^GMTSUP Q:$D(GMTSQIT)
        I '$D(GMTSOBJ("COMPONENT HEADER")),$D(GMTSOBJ("REPORT HEADER")),GMFIRST=1 W !!
        I GMTSNPG D HDR,CKP^GMTSUP Q:$D(GMTSQIT)
        I GMTSNPG D HDR
        I GMTSEGH["CF"!(GMTSEGH["CLD") D
        .I GMFIRST=1 W !!
        .S GMFIRST=0
        I GMFIRST W ?36,"--STATUS--",?47,"--DUE DATE--",?61,"--LAST DONE--",! S GMFIRST=0
        S STATCOL=41-($L(STATUS)/2)
        S DUECOL=53-($L(GMTSDUE)/2)
        S LASTCOL=67-($L(GMTSDAT)/2)
        I GMTSEGH["CLD" D  Q
        .I +GMTSDAT>0 S LASTCOL=40
        .I +GMTSDAT=0 S LASTCOL=40,GMTSDAT=""
        .W !,GMREM,?LASTCOL,GMTSDAT
        I GMTSEGH["CF" W GMREM,!
        I GMTSEGH'["CF" W GMREM,?STATCOL,STATUS,?DUECOL,GMTSDUE,?LASTCOL,GMTSDAT,?73,$G(HIST),!
        I 'CM Q
        ;   Display activity data on reminder
        I HVET=1 D HVETCM Q
        ;;   Display maintenance criteria for reminder
        N FREQCHK
        S GMDT=0,FREQCHK=0
        F  S GMDT=$O(^TMP("PXRHM",$J,ITEM,GMREM,"TXT",GMDT)) Q:+GMDT'>0  D  Q:$D(GMTSQIT)
        . I GMTSEGH["CF",FREQCHK=0,$P($G(^TMP("PXRHM",$J,ITEM,GMREM,"TXT",GMDT)),":")="Frequency" S FREQCHK=1 Q
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        . I GMTSNPG D HDR
        . W ?5,$G(^TMP("PXRHM",$J,ITEM,GMREM,"TXT",GMDT)),!
        W !
        Q
HVETCM  ;
        ;   Display maintenance criteria for reminder
        S GMDT=0
        F  S GMDT=$O(^TMP("PXRMHV",$J,GMSTATUS,GMREM,ITEM,"TXT",GMDT)) Q:+GMDT'>0  D  Q:$D(GMTSQIT)
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        . I GMTSNPG D HDR
        . W ?5,$G(^TMP("PXRMHV",$J,GMSTATUS,GMREM,ITEM,"TXT",GMDT)),!
        W !
        Q
        ;
HDR     ; Component Header
        Q:'$D(GMTSOBJ("COMPONENT HEADER"))
        N GMREC S GMREC=0
        F  S GMREC=$O(^TMP("PXRM",$J,"DISC",GMREC)) Q:+GMREC'>0  D  Q:$D(GMTSQIT)
        . D CKP^GMTSUP Q:$D(GMTSQIT)
        . W ?1,$G(^TMP("PXRM",$J,"DISC",GMREC)),!
        W !
        Q
