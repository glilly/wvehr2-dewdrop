AAQJUTL ;FGO/JHS - Patch Documentation Utility ;05-27-99 [10/27/99 11:15pm]
 ;;1.4;AAQJ PATCH RECORD;; May 14, 1999
 W !,"On-Line Documentation for Patch Record and Simple Patch."
 W !!,"The documentation can be viewed on a display terminal,",!,"using FileMan Browser or queued to a printer."
 W !!,"Arrow keys can be used to scroll up and down through the text.",!,"For Browser functions, use: F1 key on a PC.  PF1 on a dumb terminal."
 W !,"Use F1 (or PF1) 'H' for Help and F1 'E' to Exit the Document."
ASK S AAQOUT=0 R !!,"Do you want to (P)rint or (V)iew?: V// ",AAQX:60 G:AAQX="^" EXIT W:$E(AAQX,1)="P" "rint" W:$E(AAQX,1)="V" "iew"
 I (AAQX="")!(AAQX="V") S AAQX="V"
 I AAQX?1L.E S AAQX=$$UP^XLFSTR(AAQX)
 I $E(AAQX,1)'="P",$E(AAQX,1)'="V" W !!,"Enter the letter P or V, `^' to quit." G ASK
GET ;Get a document to display or print
 K DIC S DIC="^DIZ(437016.9,",DIC(0)="AEMQ",D="B",DZ="??" D DQ^DICQ
 K DIC S DIC="^DIZ(437016.9,",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Document: " D ^DIC W ! I Y<0 W $C(7),!,"No Document selected.  Exiting." G EXIT
 S AAQJ=+Y,AAQJNAM=$P(Y,U,2)
 S:AAQX="P" IOP="Q",%ZIS="QN" D ^%ZIS Q:POP  I $D(IO("Q")) G QUE
 S AAQX="V",IOP="HOME" D ^%ZIS Q:POP
 ;;S DDBRTIEN=IOST(0),X="IOTM;IOBM;IOSTBM;IORI" D ENDR^%ZISS
 ;;S AAQX="V",%ZIS=0,%ZIS("B")="BROWSER" D ^%ZIS Q:POP
 ;;S AAQX="V",IOP="BROWSER" D ^%ZIS Q:POP
 G DQ
QUE S AAQX="P",ZTRTN="DQ^AAQJUTL",ZTDESC="Patch Documentation",ZTSAVE("AAQ*")="" D ^%ZTLOAD G EXIT
DQ U IO
 S AAQPG=0 D UCI^%ZOSV S AAQUCI=$P(Y,",",1),AAQDT=$$NOW^XLFDT,AAQHDT=$$FMTE^XLFDT(AAQDT)
 I AAQX="P" D HDR G LOOP
TST ; This is a Test to see if your terminal will work with Browser.
 I '$$TEST^DDBRT D  Q
 .W $C(7),!,?20,"Terminal cannot support a scroll region and reverse index.",!,?20,"Please contact IRM to see if they can correct this problem."
 .Q
 ;;I '$$TEST^DDBRT W $C(7),!,?20,"Terminal cannot support a scroll region and reverse index.",!,?20,"Please contact IRM to see if they can correct this problem." G EXIT
LOOP D HDR F N1=0:0 S N1=$O(^DIZ(437016.9,AAQJ,1,N1)) Q:AAQOUT=1  G:N1'>0 EXIT S X=^DIZ(437016.9,AAQJ,1,N1,0) D
 .W !,X
 .I IOST["C-",$Y+3>IOSL D RET
 .I IOST["P-",$Y+6>IOSL D HDR
 .Q
EXIT K %,%L,%X,%Y,%ZIS,AAQDT,AAQHDT,AAQJ,AAQJNAM,AAQOUT,AAQPG,AAQUCI,AAQX,D,DIC,DIZ,DZ,IOP,N1,POP,X,Y,ZTDESC,ZTRTN,ZTSAVE
 D ^%ZISC S:$D(ZTQUEUED) ZTREQ="@" Q
RET R !!,"Press RETURN to Continue, '^' to Exit: ",X:DTIME D:X["^" UPOUT
 D HDR
 Q
HDR Q:AAQOUT=1  W @IOF S AAQPG=AAQPG+1 W !!,AAQHDT,?30,AAQJNAM,?65,AAQUCI,?70,"PAGE ",AAQPG,!! S $Y=5 Q
UPOUT S AAQOUT=1 W @IOF S $Y=1
 Q
