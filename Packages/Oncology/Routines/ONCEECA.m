ONCEECA ;Hines OIFO/GWB - Enter/edit CHEMOTHERPEUTIC DRUGS (164.18) file ;11/3/08
        ;;2.11;ONCOLOGY;**49**;Mar 07, 1995;Build 38
        ;
EECA    W ! S (DIC,DIE)="^ONCO(164.18,",DIC(0)="AELMQZ",DLAYGO=164.18 D ^DIC
        I Y=-1 G EXIT
        S DA=+Y
        W ! S DR=".01;1;2" D ^DIE
        G EECA
        ;
EXIT    ;Exit routine
        K DA,DIC,DIE,DLAYGO,DR,Y
