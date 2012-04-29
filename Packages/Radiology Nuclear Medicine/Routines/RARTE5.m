RARTE5  ;HISC/SWM AISC/MJK,RMO-Enter/Edit Outside Reports ;10/24/07  12:58
        ;;5.0;Radiology/Nuclear Medicine;**56**;Mar 16, 1998;Build 3
        ;Private IA #4793 CREATE^WVRALINK
        ;Controlled IA #3544 ^VA(200
        ;Supported IA #2056 GET1^DIQ
        ;Supported IA #10013 IX1^DIK
        ;Supported IA #10141 MES^XPDUTL
        ; adapted from RARTE, RARTE1, RARTE4
        F I=1:1:7 W !?3,$P($T(INTRO+I),";;",2)
        W ! D SET^RAPSET1 I $D(XQUIT) K XQUIT Q
        N RAXIT,RASUBY0,RA18EX,RAPRTSET,RAMEMARR,RA1,RA7003
        S RAXIT=0
        I $D(RANOSCRN) S X=$$DIVLOC^RAUTL7() I X D Q1 QUIT
        ;
        ; only require any Radiology Classification in New Person file
        S X=0 F I="C","R","S","T" S:$D(^VA(200,"ARC",I,DUZ)) X=1
        I 'X W !,"Your user account is missing a Radiology classification.",! D INCRPT Q
        ;
START   K RAVER S RAVW="",RAREPORT=1 D ^RACNLU G Q1:"^"[X
        ; RACNLU defines RADFN, RADTI, RACNI, RARPT
        S RASUBY0=Y(0) ; save value of y(0)
        S RANUENTR=0 ;=0 subsequent edit of report, =1 initial making of report
        G:$P(^RA(72,+RAST,0),"^",3)>0 CONTIN
        I $D(^XUSEC("RA MGR",DUZ)) G CONTIN
        G:$P(RAMDV,"^",22)=1 CONTIN
        W $C(7),!!,"The STATUS for this case is CANCELLED. You may not enter a report.",!! D INCRPT G START
        ;
CONTIN  ; continue
        S RAXIT=0 D DISPLAY^RARTE6
        I RA18EX=-1 D INCRPT G START
        ; raprtset is defined in display^rarte6
        I RAPRTSET W !,"OUTSIDE report cannot be linked to a printset." D INCRPT G START
        S RAPNODE="^RADPT("_RADFN_",""DT"","_RADTI_",""P"","
        S RA7003=@(RAPNODE_RACNI_",0)")
        S RAXIT=$$LOCK^RARTE6(RAPNODE,RACNI) I RAXIT D INCRPT G START
        ;
        ; Existing rpt must have field 5 = "EF" and field 18 with data
        I $D(^RARPT(+RARPT,0)),(($P(^(0),"^",5)'="EF")!($P(^(0),"^",18)="")) W !?3,$C(7),"Only Electronicaly Filed reports can be selected!",! D UNLOCK^RAUTL12(RAPNODE,RACNI) D INCRPT G START
        ;Create new rpt, or skip to IN to edit existing report
        G IN:$D(^RARPT(+RARPT,0))
        ; check Credit Method
        S X=$P(@(RAPNODE_RACNI_",0)"),U,26)
        I X'=2 W !!?3,"This option is for Outside work (imaged and read), so the case should ",!?3,"be 'No Credit', but this case has a credit method of '",$$GET1^DIQ(70.03,RACNI_","_RADTI_","_RADFN_",",26),"'"
        K DIR S DIR(0)="Y",DIR("B")="NO"
        S DIR("A")="Do you want to continue"
        S DIR("?")="Enter YES to continue with this option"
        W ! D ^DIR K DIR
        I Y'=1 D INCRPT G START
        ;
        S RANUENTR=1 ; new report being made
NEW1    S RARPTN=$E(RADTE,4,7)_$E(RADTE,2,3)_"-"_RACN
        W !?3,"...report not entered for this exam...",!?10,"...will now initialize report entry..."
        S I=+$P(^RARPT(0),"^",3)
        ;
LOCK    ;Try to lock next avail IEN, if locked - fail, if used - increment again
        S I=I+1 S RAXIT=$$LOCK^RARTE6("^RARPT(",I) I RAXIT D UNLOCK^RAUTL12(RAPNODE,RACNI) D INCRPT G START
        ;don't check ^RARPT("B",RARPTN) due cloaked deleted reports
        I $D(^RARPT(I)) D UNLOCK^RAUTL12("^RARPT(",I) G LOCK
        S ^RARPT(I,0)=RARPTN,RARPT=I,^(0)=$P(^RARPT(0),"^",1,2)_"^"_I_"^"_($P(^(0),"^",4)+1),^DISV($S($D(DUZ)#2:DUZ,1:0),"^RARPT(")=I S:'$D(^RARPT(RARPT,"T")) ^("T")=""
        S ^RARPT(RARPT,0)=RARPTN_"^"_RADFN_"^"_RADTE_"^"_RACN_"^EF",DIK="^RARPT(",DA=RARPT D IX1^DIK
        K %,D,D0,DA,DI,DIC,DIE,DQ,DR,X,Y
        S DA(2)=RADFN,DA(1)=RADTI,DA=RACNI
        S DIE="^RADPT("_RADFN_",""DT"","_RADTI_",""P"","
        S DR="17////"_RARPT D ^DIE
        K %,D,D0,DA,DI,DIC,DIE,DQ,DR,RAY1,X,Y
        W !,RAI
        G IN0
IN      ;edit existing rpt, so lock rpt fr the 1st time
        S RAXIT=$$LOCK^RARTE6("^RARPT(",RARPT) I RAXIT D UNLOCK^RAUTL12(RAPNODE,RACNI) G Q1
IN0     ;skip to here if rpt created in this session and already locked
        ; save DXs before edit
        S RANY1=$$ANYDX^RARTE7(.RAA1) ;1=has DXs, 0=no DXs, RAA1() stores DXs
        ; Ask if copy standard report
        I $P(RAMDV,"^",12) D STD^RARTE1 I X="^" S RAXIT=1 G UNCASE
        ;  Ask Report Date
        S DR="8",DA=RARPT,DIE="^RARPT(" D ^DIE K DE,DQ
        ; y is defined if user "^" out
        I $D(Y) K Y G UNCASE
        ;   Display Clinical History
        D CHPRINT^RAUTL9
        ; report status before editing
        S RACT=$P(^RARPT(RARPT,0),U,5)
        ; Edit Report Text and enter Diagnostic code(s)
        D ERPT
        ; continue to check sufficient data even if RAXIT=1 at this point
UNCASE  ;
        D UNLOCK^RAUTL12(RAPNODE,RACNI) ;unlock case
        ; check if sufficient data; del rpt & xrefs if no rpt txt & impression
        S RAXIT=$$CCAN(RARPT)
        D UNLOCK^RAUTL12("^RARPT(",RARPT) ;unlock report
        G:RAXIT PRT
        ;
        ;  "EF" was stuffed in LOCK+5 for new reports
        I $P(^RARPT(RARPT,0),U,5)'="EF" D SETFF^RARTE6(74,5,RARPT,"EF")
        W !,"Report status is stored as ""Electronically Filed""."
        ;   Stuff in initial entry date only once
        I $P(^RARPT(RARPT,0),U,18)="" D SETFF^RARTE6(74,18,RARPT,"NOW","E")
        ;   Stuff in Activity Log subfile at all times
        D SETALOG^RARTE6("+1,"_RARPT_",","F","")
        ;
        ; transmit to women's health each time this point is reached
        ; COPY^WVRALINK will stop if the same case number is already in 790.1
        ;
        I $P(^RARPT(RARPT,0),U,5)="EF",$T(CREATE^WVRALINK)]"" D CREATE^WVRALINK(RADFN,RADTI,RACNI) ; women's health
        ;
PRT     I RAXIT S RAXIT=0 D INCRPT G START
        ;
        ; report status after editing
        S RACT=$P(^RARPT(RARPT,0),U,5)
        ; ---
        ; set RAHLTCPB to prevent broadcast ORM messages
        N RAHLTCPB S RAHLTCPB=1
        ; update case's exam status only if exam status isn't COMPLETE
        D:$$GET1^DIQ(72,+$P(RA7003,U,3)_",",3)'=9 UP1^RAUTL1
        S RANY2=$$ANYDX^RARTE7(.RAA2) ;RAA2() store DXs after edit
        ; always check alert if new/changed diagnostic codes, send alert if nec.
        D ALERT^RARTE7
        K RAAB
PRT1    R !!,"Do you wish to print this report? No// ",X:DTIME S:'$T!(X["^") X="N" S:X="" X="N" ;030497
        I "Nn"[$E(X) D INCRPT G START
        I "Yy"'[$E(X) W:X'["?" $C(7) W !!?3,"Enter 'YES' to print this report, or 'NO' not to." G PRT1
        S ION=$P(RAMLC,"^",10),IOP=$S(ION]"":"Q;"_ION,1:"Q")
        S RAMES="W !!?3,""Report has been queued for printing on device "",ION,""."""
        D Q^RARTR D INCRPT G START ; queue rpt, cleanup, startover
        ;
Q1      K %,%DT,%W,%Y,%Y1,C,D0,D1,DA,DIC,DIE,DR,OREND,RABTCH,RABTCHN,RACN,RACNI,RACOPY,RACS,RACT,RADATE,RADFN,RADTE,RADTI,RADUZ,RAELESIG,RAFIN,RAHEAD,RAI,RAJ1
        K RALI,RALR,RANME,RANUM,RAOR,RAORDIFN,RAPNODE,RAPRC,RAPRIT,RAQUIT,RAREPORT,RARES,RARPDT,RARPT,RARPTN,RARPTZ,RARTPN,RASET,RASI,RASIG,RASN,RASSN,RAST,RAST1,RASTI,RASTFF,RAVW,XQUIT,W,X,Y
        K D,D2,DDER,DI,DIPGM,DLAYGO,J,RAEND,RAF5,RAFL,RAFST,RAIX,RAPOP,RAY1
        K ^TMP($J,"RAEX")
        K POP,DUOUT,RAFDA,RATEXT,RADIR0,RAXIT
        D INCRPT
        Q
INCRPT  ; Kill extraneous variables to avoid collisions.
        ; Incomplete report information, select another case #.
        K DA,DIE,DR,RATXT
        K %,%DT,D,D0,D1,D2,DI,DIC,DIWT,DN,I,J,RACN,RACNI,RACT,RADATE,RADTE
        K RADTI,RAFIN,RAI,RALI,RALR,RANME,RAPRC,RARPT,RARPTN,RASSN,RAST,RAVW,X
        K RANUENTR
        Q
CCAN(IEN74)     ;Check canned report for Outside Reporting
        ; adapted from EN3^RAUTL15
        ; outputs:  0 if report is kept
        ;           1 if report is deleted due to no canned text entered
        ;
        ; keep report if it is linked to images
        I $O(^RARPT(IEN74,2005,0))>0 Q 0
        ;
        ;del canned report if missing both REPORT TEXT and IMPRESSION TEXT
        I '$O(^RARPT(IEN74,"I",0)),'$O(^RARPT(IEN74,"R",0)) D  Q 1
        .; no printsets in outside rpt'g, so no pointer to file 74 from 70.04
        .;
        .; exec field's xrefs' KILL logic
        .S DA(2)=RADFN,DA(1)=RADTI,DA=RACNI
        .D ENKILL^RAXREF(70.03,17,IEN74,.DA)
        .;
        .;del piece 17 from case record
        .S $P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),"^",17)="" K DA,X
        .;
        .; Del report ptr from batch and distribution files
        .D UPDTPNT^RAUTL9(IEN74)
        .;
        .; Del entry from Report file
        .K RATXT
        .S DA=IEN74,DIK="^RARPT(" D ^DIK
        .S RATXT(1)=" "
        .S RATXT(2)="   Outside canned report not complete.  Must Delete......deletion complete!"
        .S RATXT(3)=$C(7) D MES^XPDUTL(.RATXT)
        .Q
        Q 0
ERPT    ; Edit report text, impression, and enter/edit diagnostic codes
        S $P(RATXT,"+",52)=""
        W !!?5,RATXT,!?8,"Required:  REPORT TEXT and/or IMPRESSION TEXT",!?5,RATXT
        S RAXIT=0
        S DA=RARPT,DIE="^RARPT("
        S DR="200;I X=""^"" S Y=""@8"";300;I X'=""^"" S Y=""@9"";@8;S RAXIT=1;@9"
        D ^DIE
        ; Report Text and Impression Text cannot both be empty
        I '$O(^RARPT(RARPT,"I",0)),'$O(^RARPT(RARPT,"R",0)) G ERPT
        I RAXIT=1 Q
        ; Diagnostic codes
        ; (code taken from routine RARTE1)
        S RAIMGTYI=$P($G(^RADPT(RADFN,"DT",RADTI,0)),U,2),RAIMGTYJ=$P($G(^RA(79.2,+RAIMGTYI,0)),U)
        S X=+$O(^RA(72,"AA",RAIMGTYJ,9,0)),DA(2)=RADFN,DA(1)=RADTI,DA=RACNI,DIE="^RADPT("_DA(2)_",""DT"","_DA(1)_",""P""," K RAIMGTYI,RAIMGTYJ
        ; ask Prim. Diag, required if site require diag, don't ck abnormal here
        S DR=13_$S('$D(^RA(72,X,.1)):"",$P(^(.1),"^",5)'="Y":"",1:"R")
        S RAXIT=$$LOCK^RARTE6(DIE,.DA)
        ; allow user to "^" exit
        I 'RAXIT D ^DIE D UNLOCK^RAUTL12(DIE,.DA) K DA,DE,DQ,DIE,DR
        I RAXIT!($P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,13)="")!($D(Y)) S RAXIT=0 G PACS
        S DR="50///"_RACN
        S DR(2,70.03)=13.1
        S DR(3,70.14)=.01 ; don't ck abnormal here
        S DA(1)=RADFN,DA=RADTI,DIE="^RADPT("_DA(1)_",""DT"","
        S RAXIT=$$LOCK^RARTE6("^RADPT("_RADFN_",""DT"","_RADTI_",""P"",",.RACNI) ;lock at P level
        I 'RAXIT D ^DIE D UNLOCK^RAUTL12("^RADPT("_RADFN_",""DT"","_RADTI_",""P"",",.RACNI) K DA,DE,DQ,DIE,DR ;unlock at P level
        I $D(Y) K Y S RAXIT=1 ;$D(Y) means user "^" out
PACS    ; do not broadcast ORU message
        ;
        ; move WV outside of this in case rpt is deleted due insufficient data
        Q
        ;
INTRO   ;
        ;;+--------------------------------------------------------+
        ;;|                                                        |
        ;;|  This option is for entering canned text for           |
        ;;|  outside work:  interpreted report done outside,       |
        ;;|  and images made outside this facility.                |
        ;;|                                                        |
        ;;+--------------------------------------------------------+
