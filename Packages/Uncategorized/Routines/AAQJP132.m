AAQJP132 ;FGO/JHS - List Patch Record (132 col.) ;10-07-97 [5/25/99 10:22pm]
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999
 W !!,"A 132 column printer should be used for this report.",!
 S U="^",DIC="^DIZ(437016,",DIC(0)="AEQM"
 D ^DIC W ! S AAQJDA=+Y,AAQJPKG=$P(Y,U,2) G:Y=-1 EXIT
ASKSRT R !,"Sort by (P)atch Number or (S)equence Number?: P// ",AAQSRT:60 G:AAQSRT="^" EXIT W:$E(AAQSRT,1)="P" "atch Number" W:$E(AAQSRT,1)="S" "equence Number"
 I (AAQSRT="")!(AAQSRT="P") S AAQSRT="P" S AAQSHDR="Sorted by PATCH #" G ASKROU
 I AAQSRT?1L.E S AAQSRT=$$UP^XLFSTR(AAQSRT)
 I $E(AAQSRT,1)'="P",$E(AAQSRT,1)'="S" W !!,"Enter uppercase P or S, `^' to quit." G ASKSRT
 S AAQSHDR="Sorted by SEQ #"
ASKROU S %=2 W !,"Do you want the Routine field on the list" D YN^DICN S AAQROU=% I %=0 W !!,"Enter uppercase Y or N, `^' at DEVICE: to quit." G ASKROU
 S DIC="^DIZ(437016,"
 S FLDS="[AAQJ LIST 132]",DHD="[AAQJ LIST 132 HEADING]"
 S:AAQROU=1 FLDS="[AAQJ LIST 132 ROU]",DHD="[AAQJ LIST 132 ROU HDG]"
 I AAQSRT="P" S BY="[AAQJ PKG/VERS/PATCH]" G FRTO
 S BY="[AAQJ PKG/VERS/SEQ]"
FRTO S (FR,TO)=AAQJPKG D EN1^DIP
EXIT K %,%Y,AAQJDA,AAQJPKG,AAQROU,AAQSHDR,AAQSRT,POP Q
 ;All other input variables killed by EN1^DIP
