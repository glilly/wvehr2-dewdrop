%ZVEMSU1 ;DJB,VSHL**Utilities - KEY,DIC,DIET,DIPT,DIBT ; 1/15/01 8:18am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
KEY ;Display escape sequence for any key hit.
 NEW COL,FLAGQ,HLD,I,X,Y
 ;
 S X="ERROR^%ZVEMSU1",@($$TRAP^%ZVEMKU1) KILL X
 ;
 W @VEE("IOF"),!,"K E Y B O A R D   I N T E R P R E T E R",!
 S FLAGQ=0
 F  D KEY1 Q:FLAGQ
 ;
KEYEX ;Exit
 X VEE("TRMOFF")
 X VEE("EON")
 Q
 ;
KEY1 ;Get user input. Use 'Read Terminators'.
 X VEE("TRMON")
 X VEE("EOFF")
 KILL HLD S HLD=""
 S COL=12
 W !?1,"Hit any key: "
 R X#1:100 I ('$T)!($G(X)<0) S FLAGQ=1 Q
 I $A(X)>31,$A(X)<127 S X=$A(X)
 E  X VEE("TRMRD") S X=Y
 W !!?3,"ASCII:",?COL,X
 S COL=COL+5
 S HLD(1)=X
 ;
 I (X=0)!(X=27) F I=2:1:10 R *Y:0 D  ;
 . Q:(Y<0)
 . Q:('$G(Y))
 . W ?COL,Y
 . S HLD(I)=Y
 . S COL=COL+5
 ;
 W !?3," CHAR:" S COL=12
 S X=0
 F  S X=$O(HLD(X)) Q:'X  D  ;
 . I HLD(X)>31,HLD(X)<127 W ?COL,$C(HLD(X))
 . S COL=COL+5
 ;
 D PAUSEQ^%ZVEMKC(2) W !
 Q
 ;
ERROR ;
 W ! G KEYEX
 Q
 ;====================================================================
DICCALL ;Template for on-the-fly DIC look-up
 I '$D(^DD) D MSG Q
 NEW C,CD,CDHLD,DDH,DIC,DISYS,U,X,Y
 S (CD,CDHLD)="S DIC=""^DIZ("",DIC(0)=""QEAM"" D ^DIC"
 W !?1,"DIC Look-up Template:"
 D SCREEN^%ZVEMKEA("",1,78) W !
 Q:CD=CDHLD!(",<ESC>,<F1E>,<F1Q>,<TO>,"[(","_VEESHC_","))
 X CD
 W !!?1,"Y = ",$G(Y) W:$D(Y(0)) !?1,"Y(0) = ",Y(0) W !
 Q
 ;====================================================================
DIET ;Display Fileman INPUT templates
 I '$D(^DD) D MSG Q
 I $G(DUZ)'>0 D ID^%ZVEMKU Q:$G(DUZ)=""
 NEW DIC,NODE0,X,Y
 S DIC="^DIE(",DIC(0)="QEAM"
 F  W ! D ^DIC Q:Y<0  W ! S D0=+Y D  D ^DIET
 . S NODE0=^DIE(D0,0) D HEADING
 Q
DIPT ;Display Fileman PRINT templates
 I '$D(^DD) D MSG Q
 I $G(DUZ)'>0 D ID^%ZVEMKU Q:$G(DUZ)=""
 NEW DIC,NODE0,X,Y
 S DIC="^DIPT(",DIC(0)="QEAM"
 F  W ! D ^DIC Q:Y<0  W ! S D0=+Y D  D ^DIPT
 . S NODE0=^DIPT(D0,0) D HEADING
 Q
DIBT ;Display Fileman SORT templates
 I '$D(^DD) D MSG Q
 NEW D0,DIC,NODE0,X,Y
 S DIC="^DIBT(",DIC(0)="QEAM"
 F  W ! D ^DIC Q:Y<0  W ! S D0=+Y D  D DIBT^DIPT
 . S NODE0=^DIBT(D0,0) D HEADING
 Q
MSG ;
 W $C(7),!?2,"Fileman not in this UCI.",!
 Q
HEADING ;Heading for template prints
 NEW DATE,FILE,FILENAM
 I '$D(DT) S DT=$$FMDATE^%ZVEMKDT()
 W @VEE("IOF") S FILENAM="",DATE=$P(NODE0,U,7)
 I DATE]"" S DATE=$$DATEDASH^%ZVEMKU1(DATE)
 S FILE=$P(NODE0,U,4) I FILE>0,$D(^DIC(FILE,0)) S FILENAM=$P(^(0),U,1)
 W !?1,"Template: ",$P(NODE0,U,1)
 W ?60,"Printed: ",$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 W !?1,"File: ",FILENAM," (#",FILE,")"
 W !?1,"Last Used: ",DATE
 W !,"-------------------------------------------------------------------------------"
 Q
