ECXTREX ;BPFO/JRP - Queue DSS Fiscal Year Specific Extract;8-AUG-2003 ; 6/23/08 9:18am
        ;;3.0;DSS EXTRACTS;**49,71,84,92,105,112**;Dec 22, 1997;Build 26
        ;
EN      ;Main entry point
        W @IOF
        N DIC,X,Y,DTOUT,DUOUT
        W !,"****************************************************************"
        W !,"*                                                              *"
        W !,"* This option should be used with caution as it allows for the *"
        W !,"* extraction of data using specified fiscal year logic.  This  *"
        W !,"* gives the ability to extract fiscal year 200x data using     *"
        W !,"* fiscal year 200(x+1) logic and vice versa.  Note that data   *"
        W !,"* extracted via this method may or may not be transmittable to *"
        W !,"* the DSS production queue at the Austin Automation Center.    *"
        W !,"*                                                              *"
        W !,"*--------------------------------------------------------------*"
        W !,"*                                                              *"
        W !,"* Note that this option does not update the last date used for *"
        W !,"* the given extraction.  It also does not verify that the time *"
        W !,"* frame selected is after the last date used for the extract.  *"
        W !,"*                                                              *"
        W !,"****************************************************************"
        W !!
        ;Pick extract to queue
        S DIC="^ECX(727.1,"
        S DIC(0)="AEQMZ"
        S DIC("A")="Select DSS Extract to queue: "
        S DIC("S")="I ('$P(^(0),U,12))&($P(^(0),U,8)'="""")&($G(^(7))'[""Inactive"")"
        S DIC("W")="W ""("",$P(^(0),U,8),"")"""
        D ^DIC
        I ($D(DUOUT))!($D(DTOUT))!(Y<1) Q
        N ECXRTN,ECXDA
        S ECXDA=+Y
        ;Get extract specific routine name
        S ECXRTN=$G(^ECX(727.1,ECXDA,"ROU"))
        I ECXRTN="" D  Q
        .W !!,"Selected extract is not correctly defined in the EXTRACT"
        .W !,"DEFINITIONS file (#727.1).  The ROUTINE field (#4) does not"
        .W !,"have a value in it."
        .W !
        .D PAUSE
        ;Get time frame for extract
        N STRTDT,ENDDT,DIR,DIRUT,DIROUT,OUT,ECXDATES
        S OUT=0 F  S (STRTDT,ENDDT)="" D  Q:OUT
        .;Get start date (must be in past)
        .S DIR(0)="DOA"
        .S $P(DIR(0),"^",2)=":"_DT_":AEXP"
        .S DIR("A")="Starting with Date: "
        .D ^DIR
        .I $D(DIROUT)!$D(DIRUT)!(Y="") S (STRTDT,ENDDT)="" S OUT=1 Q
        .S STRTDT=Y
        .K DIR
        .;Get end date (must be in same month; must be in past)
        .S DIR(0)="DOA"
        .S X=$E(STRTDT,1,5)_"01"
        .S X=$$FMADD^XLFDT(X,32)
        .S X=$$FMADD^XLFDT(X,-($E(X,6,7)))
        .I X>DT S X=DT
        .S $P(DIR(0),"^",2)=STRTDT_":"_X_":AEXP"
        .S DIR("A")="Ending with Date: "
        .S DIR("B")=$$FMTE^XLFDT(X,"5D")
        .D ^DIR
        .I $D(DIROUT)!$D(DIRUT)!(Y="") S (STRTDT,ENDDT)=""  S OUT=1 Q
        .S ENDDT=Y
        .S OUT=1
        Q:(STRTDT="")!(ENDDT="")
        S ECXDATES=STRTDT_"^"_ENDDT_"^1"
        ;Get extract logic to use
        N ECXLOGIC,YEAR
        S YEAR=$E(DT)+17_$E(DT,2,3)
        K DIR
        S DIR("A")="Select fiscal year logic to use for extract"
        S DIR(0)="SO^"
        F X=2003:1:YEAR+1 D
        .S Y=$E(X,5)
        .S Y=$S((Y="")!(Y=" "):"",1:"Revision "_Y_" of ")
        .S DIR(0)=DIR(0)_X_":"_Y_"Fiscal Year "_$E(X,1,4)_";"
        D ^DIR
        I $D(DIROUT)!$D(DIRUT) Q
        S ECXLOGIC=Y
        ;Queue extract
        D @("BEG^"_ECXRTN)
        Q
PAUSE   ;pause screen
        N DIR,X,Y,DTOUT,DUOUT,DIROUT,DIRUT
        S DIR(0)="E"
        W !!
        D ^DIR
        W !!
        Q
