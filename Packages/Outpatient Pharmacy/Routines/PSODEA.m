PSODEA  ;BHAM ISC/  - HELP TEXT FOR DEA FIELD IN DRUG FILE ; 10/17/07 7:41am
        ;;7.0;OUTPATIENT PHARMACY;**206**;DEC 1997;Build 39
        W !,"THE SPECIAL HANDLING CODE IS A 2 TO 6 POSTION FIELD.  IF APPLICABLE,",!,"A SCHEDULE CODE MUST APPEAR IN THE FIRST POSITION.  FOR EXAMPLE,"
        W !,"A SCHEDULE 3 NARCOTIC WILL BE CODED '3A' AND A SCHEDULE 2 DEPRESSANT",!,"WILL BE CODED '2L'.  THE CODES ARE:",!
        F I=1:1 S AA=$P($T(D+I),";",3,99) Q:AA=""  W !?10,AA
D       K AA Q
        ;;0          MANUFACTURED IN PHARMACY
        ;;1          SCHEDULE 1 ITEM
        ;;2          SCHEDULE 2 ITEM
        ;;3          SCHEDULE 3 ITEM
        ;;4          SCHEDULE 4 ITEM
        ;;5          SCHEDULE 5 ITEM
        ;;6          LEGEND ITEM
        ;;9          OVER-THE-COUNTER
        ;;L          DEPRESSANTS AND STIMULANTS
        ;;A          NARCOTICS AND ALCOHOLICS
        ;;P          DATED DRUGS
        ;;I          INVESTIGATIONAL DRUGS
        ;;M          BULK COMPOUND ITEMS
        ;;C          CONTROLLED SUBSTANCES - NON NARCOTIC
        ;;R          RESTRICTED ITEMS
        ;;S          SUPPLY ITEMS
        ;;B          ALLOW REFILL (SCH. 3, 4, 5 ONLY)
        ;;W          NOT RENEWABLE
        ;;
EDIT    ;INPUT XFORM FOR DEA FIELD IN DRUG FILE
        I X["B",(+X<3) W !,"The B designation is only valid for schedule 3, 4, 5 !",$C(7) K X Q
        Q
