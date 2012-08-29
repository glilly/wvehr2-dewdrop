%ZVEMDM ;DJB,VEDD**Menu Driver ; 12/6/00 9:18pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Entry Point
 NEW I,LIST,OPT,X,Y
 D INIT
 I $G(FLAGPRM)="VEDD",$G(%2)]"" S OPT=%2 G GETOPT1
 D HD
 I FLAGP F I=1,7,13,2,8,14,3,9,4,10,5,11,6,12 S X=$T(MENU+I) Q:X=""  W @$S(I<7:"!?1",I<13:"?26",1:"?56"),$S(I=5:"*",I=9:"*",I=12:"*",I=13:"*",1:" "),$J($P(LIST,"^",I),3)_"  ",$P(X,";",3)
 E  F I=1,7,13,2,8,14,3,9,4,10,5,11,6,12 S X=$T(MENU+I) Q:X=""  W @$S(I<7:"!?1",I<13:"?26",1:"?56")," ",$J($P(LIST,"^",I),3)_"  ",$P(X,";",3)
 W !
GETOPT ;Get Menu option to run
 I $G(FLAGPRM)="VEDD",$G(%2)]"" G EX
 R !?2,"Select OPTION: ",OPT:VEE("TIME") S:'$T OPT="^^" I "^"[OPT S FLAGM=1 G EX
GETOPT1 ;Parameter passing
 I OPT="^^" S FLAGE=1 G EX
 S OPT=$$ALLCAPS^%ZVEMKU(OPT)
 I ",C,D,G,GR,H,I,PI,PO,PR,R,T,TR,VGL,X,"[(","_OPT_",") F I=1:1:$L(LIST,"^") I $P(LIST,"^",I)=OPT S OPT=I Q
 I OPT?1.N,$T(MENU+OPT)'="" G RUN
 I OPT'?1.N F I=1:1 S X=$P($T(MENU+I),";",5) Q:X=""  I $E(X,1,$L(OPT))=OPT W $E(X,$L(OPT)+1,VEE("IOM")) S OPT=I G RUN
 W:OPT'["?" $C(7) W "   Enter Option mnemonic or name."
 G GETOPT
RUN ;Run selected menu option
 S X=$T(MENU+OPT) D
 . I $P(X,";",5)="HELP" D @$P(X,";",4) S FLAGQ=1 Q
 . D @$P(X,";",4)
 I FLAGG S FLAGG=0 G GETOPT ;FLAGG=No Groups or no Pointers.
EX ;
 Q
HD ;Heading
 W !?31,"M A I N   M E N U" W:FLAGP ?56,"[*=Opts not printable]" W !
 Q
INIT ;
 S LIST="X^PI^PO^GR^TR^I^G^T^D^C^R^VGL^PR^H"
 Q
CHECK ;Check validity of mnemonic passed as %2. Called by PARAM^%ZVEMD.
 Q:",X,PI,PO,GR,TR,I,G,T,D,C,R,"[(","_%2_",")
 S %2="" W $C(7),!!?2,"Second parameter is not a valid menu option mnemonic."
 W !?2,"Valid mnemonics: X,PI,PO,GR,TR,I,G,T,D,C,R",!
 Q
MENU ;MENU OPTIONS
 ;;Keys & Indexes;^%ZVEMDX;KEYS & INDEXES
 ;;Pointers IN;PTI^%ZVEMDPT;POINTERS IN
 ;;Pointers OUT;PTO^%ZVEMDPT;POINTERS OUT
 ;;Groups;GRP^%ZVEMDU;GROUPS
 ;;Trace a Field;EN^%ZVEMDT;TRACE A FIELD
 ;;Indiv Fld DD;^%ZVEMDI;INDIV FLD DD
 ;;Fld Global Location;EN^%ZVEMDL;FLD GLOBAL LOCATION
 ;;Templates;EN^%ZVEMDU1;TEMPLATES
 ;;File Description;DES^%ZVEMDU1;FILE DESCRIPTION
 ;;File Characteristics;CHAR^%ZVEMDC;FILE CHARACTERISTICS
 ;;Required Fields;REQ^%ZVEMDU;REQUIRED FIELDS
 ;;VGlobal Lister;VGL1^%ZVEMDY;VGLOBAL LISTER
 ;;Printing-On/Off;PRINTM^%ZVEMDPR;PRINTING-ON/OFF
 ;;Help;HELP^%ZVEMKT("VEDD1");HELP
