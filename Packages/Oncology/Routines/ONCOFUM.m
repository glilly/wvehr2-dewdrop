ONCOFUM ;Hines OIFO/GWB - ADD FOLLOW-UP CONTACT DATA; 10/1/93
 ;;2.11;ONCOLOGY;**11,45**;Mar 07, 1995
 ;
AC ;Add contacts from PATIENT (2) information
 S VP=ONCOVP,FIL=$P(VP,";",2),DFN=$P(VP,";"),GLR="^"_FIL_DFN_","
 S X=$P(@(GLR_"0)"),U)
 S LN=$P(X,",")
 S DIC="^ONCO(165,",DIC(0)="Z" D ^DIC
 S CP0=+Y G CKP:+Y>0
 S DIC(0)="ZL" D FILE^DICN S (DA,CP0)=+Y
PT S X11=$G(@(GLR_".11)"))
 S X13=$G(@(GLR_".13)"))
 S ZIP=$P(X11,U,6),ZP=$O(^VIC(5.11,"B",ZIP_" ",0))
 S XX11=$P(X11,U,1,3)_"^^^^^^"_ZP
 S $P(^ONCO(165,CP0,0),U,2)=1,^(.11)=XX11,^(.13)=X13
 ;
CKP ;Check ONCOLOGY PATIENT (160) file
 I '$D(^ONCO(160,ONCOD0,"C")) S ^ONCO(160,ONCOD0,"C",0)="^160.03S^0^0"
 G:FIL["LRT" PTCONT
 ;
K1 G K2:$D(^ONCO(160,ONCOD0,"C","B","NOK"))
 S X21=$G(^DPT(DFN,.21)) G K2:X21=""
 F J=1,2,8,9,10 S ONCOX(J)=$P(X21,U,J)
 S ZIP=ONCOX(8),ZP=$O(^VIC(5.11,"B",ONCOX(8)_" ",0))
 S XX21=$P(X21,U,3,5)_"^^^^^^"_ZP
 S X=ONCOX(1),X=$P(X," ",2)_","_$P(X," "),X=$S($P(X,",")="":LN_X,1:X)
 S (DIC,DIE)="^ONCO(165,",DIC(0)="Z" D ^DIC
 S CK0=+Y G SK1:+Y>0 S DIC(0)="ZL" D FILE^DICN S (DA,CK0)=+Y
 S DR="1///^S X=3;2///^S X=ONCOX(2);" D ^DIE S ^ONCO(165,CK0,.11)=XX21,^(.13)=ONCOX(9)
 I $P(XX21,U)=""&(ONCOX(10)="Y") S ^ONCO(165,CK0,.11)=^ONCO(165,CP0,.11)
SK1 S DA(1)=ONCOD0,(DIC,DIE)="^ONCO(160,"_DA(1)_",""C"",",X="NOK" D FILE^DICN S DA=+Y,DR="1///^S X=CK0;" D ^DIE
 ;
K2 G DE:$D(^ONCO(160,ONCOD0,"C","B","KIN")) S X211=$G(^DPT(DFN,.211)) G DE:X211="" F J=1,2,8,9,10 S ONCOX(J)=$P(X211,U,J)
 S ZIP=ONCOX(8),ZP=$O(^VIC(5.11,"B",ONCOX(8)_" ",0)),XX211=$P(X211,U,3,5)_"^^^^^^"_ZP,X=ONCOX(1),X=$P(X," ",2)_","_$P(X," ")
 S (DIC,DIE)="^ONCO(165,",DIC(0)="Z" D ^DIC S CK2=+Y G SK2:+Y>0 S DIC(0)="ZL" D FILE^DICN S (DA,CK2)=+Y
 S DR="1///^S X=3;2///^S X=ONCOX(2);" D ^DIE S ^ONCO(165,CK2,.11)=XX211,^(.13)=ONCOX(9)
 I $P(XX211,U)=""&(ONCOX(10)="Y") S ^ONCO(165,CK2,.11)=^ONCO(165,CP0,.11)
 ;
SK2 S DA(1)=ONCOD0,(DIC,DIE)="^ONCO(160,"_DA(1)_",""C"",",X="KIN" D FILE^DICN S DA=+Y,DR="1///^S X=CK2;" D ^DIE
 ;
DE ;Designee (Guardian)
 G EX:$D(^ONCO(160,ONCOD0,"C","B","GR")) S X34=$G(^DPT(DFN,.34)) G EX:X34="" F J=1,2,8,9,10 S ONCOX(J)=$P(X34,U,J)
 S ZIP=ONCOX(8),ZP=$O(^VIC(5.11,"B",ONCOX(8)_" ",0)),XX34=$P(X34,U,3,5)_"^^^^^^"_ZP,X=ONCOX(1),X=$P(X," ",2)_","_$P(X," "),X=$S($P(X,",")="":LN_X,1:X)
 S (DIC,DIE)="^ONCO(165,",DIC(0)="Z" D ^DIC S GR0=+Y G SDE:+Y>0 S DIC(0)="ZL" D FILE^DICN S (DA,GR0)=+Y
 S DR="1///^S X=3;2///^S X=ONCOX(2);" D ^DIE S ^ONCO(165,GR0,.11)=XX34,^(.13)=ONCOX(9)
 I $P(XX34,U)=""&(ONCOX(10)="Y") S ^ONCO(165,GR0,.11)=^ONCO(165,CP0,.11)
 ;
SDE S DA(1)=ONCOD0,(DIC,DIE)="^ONCO(160,"_DA(1)_",""C"",",X="GR" D FILE^DICN S DA=+Y,DR="1///^S X=GR0;" D ^DIE
 ;
PTCONT G EX:$D(^ONCO(160,ONCOD0,"C","B","PT"))
 K DA
 S DA(1)=ONCOD0
 S (DIE,DIC,DLAYGO)="^ONCO(160,"_DA(1)_",""C"","
 S DIC(0)="ZL",X="PT" D FILE^DICN S (DA,XD1)=+Y
 S DR="1///^S X=CP0;" D ^DIE G EX
 ;
TYP ;Type contact help
 W !?5,"Patient refers to this patient (him/herself)",!
 Q
 ;
NAM ;EXTENDED HELP for CONTACT NAME (160.03,1) 
 W !?3,"To change the contact, change the CONTACT NAME above."
 W !?3,"To edit the contact details, edit the CONTACT entry in"
 W !?3,"the ONCOLOGY CONTACT File."
 W !
 Q
 ;
EX ;EXIT ROUTINE
 K DIC,DIE,DIK,DR,DIC
 Q
