%ZVEMDC ;DJB,VEDD**File Characteristics [07/12/94]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
CHAR ;Identifiers, Post Selection Actions, Special Look-up Program
 I '$D(^DD(ZNUM,0,"ID")),'$D(^DD(ZNUM,0,"ACT")),'$D(^DD(ZNUM,0,"DIC")) D  S FLAGG=1 Q
 . W !?10,"No Identifiers, Post Selection Actions, or Special Look-up Program."
 NEW LINE,STRING
 D INIT^%ZVEMDPR G:FLAGQ EX
 W !?21,"F I L E   C H A R A C T E R I S T I C S"
 W !?20,"-----------------------------------------"
 W !!?1,"1. POST SELECTION ACTION:" I $D(^DD(ZNUM,0,"ACT")) D
 . W "  The following code is executed after an entry to"
 . W !?28,"this file has been selected. If Y=-1 entry will"
 . W !?28,"not be selected:"
 . W !?14,"CODE:" S STRING=^DD(ZNUM,0,"ACT") D STRING
 W !!?1,"2. SPECIAL LOOK-UP PROGRAM: "
 I $D(^DD(ZNUM,0,"DIC")) W "^",^DD(ZNUM,0,"DIC")
 W !!?1,"3. IDENTIFIERS:"
 I $D(^DD(ZNUM,0,"ID")) D NOTE,HD S VEEX="" D  ;
 . F  S VEEX=$O(^DD(ZNUM,0,"ID",VEEX)) Q:VEEX=""!FLAGQ  D  W !
 . . W !?1,$J(VEEX,11),?14,$S(+VEEX=VEEX:"Yes",1:"No")
 . . S STRING=^DD(ZNUM,0,"ID",VEEX) D STRING
EX ;Exit
 Q
STRING ;String=code - Prints a string in lines of 55 characters
 W ?20,$E(STRING,1,55) I $Y>VEESIZE D PAGE Q:FLAGQ
 S STRING=$E(STRING,56,9999) Q:STRING']""  W !
 G STRING
PAGE ;
 I FLAGP,$E(VEEIOST,1,2)="P-" W @VEE("IOF"),!!! D HD Q
 D PAUSEQE^%ZVEMKC(2) Q:FLAGQ  W @VEE("IOF") D HD
 Q
NOTE ;
 W "  If ASK=Yes, field is asked when a new entry is added.",!
 Q
HD ;Heading
 W !?7,"FIELD",?14,"ASK",?30,"WRITE STATEMENT TO GENERATE DISPLAY",!?7,"-----",?14,"---",?20,"-------------------------------------------------------"
 Q
