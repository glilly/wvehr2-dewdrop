RMPRN7UT        ;HINES-CIOFO/HNC - DISPLAY HEADER GROUPS NPPD;2-14-01
        ;;3.0;PROSTHETICS;**57,84,103,144**;Feb 09, 1996;Build 17
        ;
        ; AAC Patch 84, 2/25/04, additions, deletions and change descriptions for Groups and lines
        ; AAC Patch 84, 2/25/04, change description for line 6
        ; AAC Patch 103, 1/17/05 - NPPD CATEGORIES/LINES - NEW and REPAIR UPDATES
        ;
DIS     W !,?5,"1.   2529-3 WHEELCHAIRS AND ACCESSORIES"
        W !,?5,"2.   2529-3 ARTIFICIAL LEGS"
        W !,?5,"3.   2529-3 ARTIFICIAL ARMS AND TERMINAL DEVICES"
        W !,?5,"4.   2529-3 ORTHOSIS/ORTHOTICS"
        W !,?5,"5.   2529-3 SHOES/ORTHOTICS"
        W !,?5,"6.   2529-3 SENSORI-NEURO AIDS"
        W !,?5,"7.   2529-3 RESTORATIONS"
        W !,?5,"8.   2529-3 OXYGEN AND RESPIRATORY"
        W !,?5,"9.   2529-3 MEDICAL EQUIPMENT"
        W !,?5,"10.  2529-3 ALL OTHER SUPPLIES AND EQUIPMENT"
        W !,?5,"11.  2529-3 HOME DIALYSIS PROGRAM"
        W !,?5,"12.  2529-3 ADAPTIVE EQUIPMENT"
        W !,?5,"13.  2529-3 HISA"
        W !,?5,"14.  2529-3 SURGICAL IMPLANTS"
        W !,?5,"15.  2529-3 MISC"
        W !,?5,"16.  2529-3 REPAIR"
        W !,?5,"17.  2529-3 BIOLOGICAL IMPLANTS"
ASK     ;
        K DIR,DTOUT,DIRUT
        S RMPRCDE=""
        S DIR(0)="N^1:17:0"
        S DIR("A")="Select 2529-3 NPPD Group "
        D ^DIR
        G:$D(DIRUT)!($D(DTOUT)) EXIT
        S BR=0,BRC=0 K BRA W @IOF
        I Y=1 S SELY=10
        I Y=2 S SELY=20
        I Y=3 S SELY=30
        I Y=4 S SELY=40
        I Y=5 S SELY=50
        I Y=6 S SELY=60
        I Y=7 S SELY=70
        I Y=8 S SELY=80
        I Y=9 S SELY=90
        I Y=10 S SELY=91
        I Y=11 S SELY=92
        I Y=12 S SELY=93
        I Y=13 S SELY=94
        I Y=14 S SELY=96
        I Y=15 S SELY=99
        I Y=16 S SELY=100
        I Y=17 S SELY=97
        F  S BR=$O(^TMP($J,"RMPRCODE",BR)) Q:BR=""  D
        .I $E(BR,1,2)=SELY S BRC=BRC+1 W !?5,BRC_".",?10,BR,?18,^(BR) S BRA(BRC,BR)=""
        .Q
        I SELY=100 D
        . D RSEL
        . Q
        E  D
        . D NSEL
        . Q
        G:$D(DIRUT)!($D(DTOUT)) EXIT
        Q
RSEL    ;repair selection
        N CNT,Y,OFFS,TXT,I
        S CNT=$P(^TMP($J,"RMPRCODE"),U,2) ; num of NPPD repair lines
        S OFFS=CNT-(CNT\2)-1
        F I=0:1:OFFS D
        . S TXT=$P($T(REP+I^RMPRN72),";;",2)
        . W !,$J(I+1,2)_".",?5,$P(TXT,";",1),?14,$P(TXT,";",2)
        . S TXT=$P($T(REP+I+OFFS+1^RMPRN72),";;",2)
        . Q:$E(TXT)'="R"
        . W ?35,$J(I+2+OFFS,2)_".",?40,$P(TXT,";",1),?51,$P(TXT,";",2)
        . Q
        F I=OFFS:1:17 W !
        S DIR(0)="N^1:"_CNT_":0"
        S DIR("A")="Select 2529-3 NPPD Line "
        D ^DIR
        Q:$D(DIRUT)!($D(DTOUT))
        S TXT=$P($T(REP+Y-1^RMPRN72),";;",2)
        S RMPRCDE=$P(TXT,";",1)
        Q
NSEL    ;new select
        I BR'="" W "QUIT" Q
        W !
        S DIR(0)="N^1:"_BRC_":0"
        S DIR("A")="Select 2529-3 NPPD Line "
        D ^DIR
        Q:$D(DIRUT)!($D(DTOUT))
        S RMPRCDE=$O(BRA(Y,RMPRCDE))
        Q
EXIT    ;exit on ^ or timeout
        K ^TMP($J)
        Q
        ;END
