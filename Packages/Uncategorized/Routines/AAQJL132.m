AAQJL132 ;FGO/JHS; Local Patch List (132 col.) ;10-07-97 [5/24/99 11:17pm]
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999
 W !!,"A 132 column printer should be used for this report.",!
 S U="^",DIC="^DIZ(437016,",DIC(0)="AEQM"
 D ^DIC W ! S AAQJDA=+Y,AAQJPKG=$P(Y,U,2) G:Y=-1 EXIT
 S AAQSHDR="Sorted by LOCAL/SUPPORT #"
ASKROU S %=2 W !,"Do you want the Routine field on the list" D YN^DICN S AAQROU=% I %=0 W !!,"Enter uppercase Y or N, `^' at DEVICE: to quit." G ASKROU
 G:%Y="^" EXIT
 S DIC="^DIZ(437016,"
 S FLDS="[AAQJ LIST 132]",DHD="[AAQJ LIST 132 HEADING]"
 S:AAQROU=1 FLDS="[AAQJ LIST 132 ROU]",DHD="[AAQJ LIST 132 ROU HDG]"
 S BY="[AAQJ LOCAL/SUPPORT]" G FRTO
FRTO S (FR,TO)=AAQJPKG D EN1^DIP
EXIT K %,%Y,AAQJDA,AAQJPKG,AAQROU,AAQSHDR,POP Q
 ;All other input variables killed by EN1^DIP
