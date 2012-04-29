AAQJL80 ;FGO/JHS; List Patch Record (80 col.) ;03-16-98 [3/15/00 3:04pm]
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999 ;Beware a timestamp above with the Ides of March
 ;Any experienced VistA programmer should know that a change to lines 1 or 2 or a comment line will have no effect on the checksum value from CHECK^XTSUMBLD.
 S (AAQTST,AAQTSW)=0,U="^",DIC="^DIZ(437016,",DIC(0)="AEQM"
 D ^DIC W ! S AAQJDA=+Y,AAQPKG=$P(Y,U,2),AAQJPKG=AAQPKG G:Y=-1 EXIT
ASKALL R !,"List (L)ocal/Support Only or (A)ll Patches?: A// ",AAQALL:60 G:AAQALL="^" EXIT W:$E(AAQALL,1)="L" "ocal/Support Only" W:$E(AAQALL,1)="A" "ll Patches"
 I AAQALL?1L.E S AAQALL=$$UP^XLFSTR(AAQALL)
 I (AAQALL="")!(AAQALL="A") S AAQALL="A" S AAQSHDR="Sorted by Patch #" G ASKINS
 I $E(AAQALL,1)'="A",$E(AAQALL,1)'="L" W !!,"Enter uppercase L or A, `^' to quit." G ASKALL
 S AAQSHDR="Sorted by Local/Support #"
ASKINS S %=2 W !,"Do you want Install File info on the list" D YN^DICN S AAQINS=% I %=0 W !!,"Enter uppercase Y or N, `^' at DEVICE: to quit." G ASKINS
 W ! S DIC="^DIZ(437016,"
 S FLDS="[AAQJ LIST 80]",DHD="[AAQJ LIST 80 HEADING]"
 I AAQINS=1 S DHIT="D PINST^AAQJL80"
 I AAQALL="A" S BY="[AAQJ PKG/VERS/PATCH]" G FRTO
 S BY="[AAQJ LOCAL/SUPPORT]"
FRTO S FR(1)=AAQPKG,TO(1)=AAQPKG,FR(2)="",TO(2)=""
 D EN1^DIP
EXIT K %,AAQALL,AAQDESC,AAQX D EXITK^AAQJPINQ
 K AAQINS,AAQJDA,AAQJPKG,AAQPKG,AAQSHDR,AAQTST,AAQTSW,DIOO1,DDD0 Q
 ;Fields not listed as killed in %Index are killed by AAQJPINQ or DIP
PINST I $E(DIOO1,1,1)=" " S AAQX=$P(DIOO1," ",2)
 E  S AAQX=DIOO1
 I $E(AAQX,1,1)=0 S AAQPAT=$P(DIOO1,"0",2)
 E  S AAQPAT=AAQX
 S AAQJPAT=DIOO1,AAQPKG=DIOO2,AAQNOF=0 D PINST^AAQJPINQ Q
