SROLABS ;BIR/SJA - ENTER/EDIT RISK MODEL LAB TEST ;12/19/07
        ;;3.0; Surgery ;**166**;24 Jun 93;Build 7
EN      N SRIEN,SRSP,SRTNM,SRTP,SRX,Y
        S SRSOUT=0 D LIST G:SRSOUT END
        D DSPLY G:SRSOUT END
        I SREDIT D EDIT
        G EN
END     D ^SRSKILL K SREDIT,SRFIRST,SRLABNM,SRSPNM
        Q
LIST    ; display test list
        W @IOF,!,?11,"Risk Model Lab Test (Enter/Edit)",!!," Select item to edit from list below:",!
        W !," 1. ALBUMIN",?32,"14. LDL"
        W !," 2. ALKALINE PHOSPHATASE",?32,"15. PLATELET COUNT"
        W !," 3. ANION GAP",?32,"16. POTASSIUM"
        W !," 4. BUN",?32,"17. PT"
        W !," 5. CHOLESTEROL",?32,"18. PTT"
        W !," 6. CPK",?32,"19. SGOT"
        W !," 7. CPK-MB",?32,"20. SODIUM"
        W !," 8. CREATININE",?32,"21. TOTAL BILIRUBIN"
        W !," 9. HDL",?32,"22. TRIGLYCERIDE"
        W !,"10. HEMATOCRIT",?32,"23. TROPONIN I"
        W !,"11. HEMOGLOBIN",?32,"24. TROPONIN T"
        W !,"12. HEMOGLOBIN A1C",?32,"25. WHITE BLOOD COUNT"
        W !,"13. INR",!
        K DIR S DIR("?")="Select the number from the list for the lab test you want to edit."
        S DIR(0)="NAO^1:25",DIR("A")="Enter number (1-25): " D ^DIR K DIR I $D(DTOUT)!$D(DUOUT)!'Y S SRSOUT=1 Q
        D TEST
        Q
EDIT    ; update selected field
        W ! K DR,DIE,DA S DA=SRIEN,DIE=139.2,DR="[SROALAB]" D ^DIE K DA,DIE,DR
        Q
DSPLY   ; display test information from file 139.2
        W @IOF,!,?11,"Risk Model Lab Test (Enter/Edit)",!!!,?16,"Test Name: "_SRLABNM,!!,"  Laboratory Data Name(s): "
        I '$O(^SRO(139.2,SRIEN,1,0)) W "NONE ENTERED"
        S SRX=0,SRFIRST=1 F  S SRX=$O(^SRO(139.2,SRIEN,1,SRX)) Q:'SRX  D
        .S SRTP=$P($G(^SRO(139.2,SRIEN,1,SRX,0)),"^"),Y=SRTP,C=$P(^DD(139.21,.01,0),"^",2) D Y^DIQ S SRTNM=Y
        .W:'SRFIRST ! W ?27,SRTNM S SRFIRST=0
        S SRSPNM="NONE ENTERED",SRSP=$P($G(^SRO(139.2,SRIEN,2)),"^") I SRSP S Y=SRSP,C=$P(^DD(139.2,2,0),"^",2) D Y^DIQ S SRSPNM=Y
        W !!,?17,"Specimen: ",SRSPNM,!!
        K DIR S DIR(0)="YA",DIR("A")="Do you want to edit this test ? ",DIR("B")="NO" D ^DIR K DIR I $D(DTOUT)!$D(DUOUT) S SRSOUT=1 Q
        S SREDIT=Y
        Q
TEST    ; match with entry in file 139.2
        I Y<14 S SRIEN=$S(Y=2:15,Y=3:26,Y=4:8,Y=5:24,Y=6:9,Y=7:10,Y=8:7,Y=9:21,Y=10:17,Y=11:1,Y=12:27,Y=13:25,1:11)
        I Y>13 S SRIEN=$S(Y=14:23,Y=15:18,Y=16:5,Y=17:19,Y=18:20,Y=19:13,Y=20:4,Y=21:14,Y=22:22,Y=23:2,Y=24:3,1:16)
        S SRLABNM=$P(^SRO(139.2,SRIEN,0),"^")
        Q
