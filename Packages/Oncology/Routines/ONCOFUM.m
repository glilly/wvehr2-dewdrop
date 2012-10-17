ONCOFUM ;Hines OIFO/GWB -FOLLOW-UP CONTACT (160,420) ;06/23/10
        ;;2.11;ONCOLOGY;**11,45,51**;Mar 07, 1995;Build 65
        ;
AC      ;Add patient to ONCOLOGY CONTACT file (165) using ^DPT(D0,.11) and
        ;^DPT(D0,.13) node data from PATIENT file (2)
        S FIL=$P(ONCOVP,";",2),DFN=$P(ONCOVP,";",1),GLR="^"_FIL_DFN_","
        S X=$P(@(GLR_"0)"),U,1)
        S DIC="^ONCO(165,",DIC(0)="Z" D ^DIC
        S CP0=+Y
        I +Y>0 G CKP
        K DO S DIC(0)="ZL" D FILE^DICN S (DA,CP0)=+Y
        S X11=$G(@(GLR_".11)"))
        S X13=$G(@(GLR_".13)"))
        S CITY=$P(X11,U,4)
        S STATE=$P(X11,U,5)
        S ZIP=$P(X11,U,6)
        S XX11=$P(X11,U,1,3)_"^"_CITY_"^"_STATE_"^^^^"_ZIP
        S $P(^ONCO(165,CP0,0),U,2)=1,^(.11)=XX11,^(.13)=X13
        ;
CKP     G:FIL["LRT" PTCONT
        ;
K1      ;Add NOK (Next of Kin) to ONCOLOGY CONTACT file (165) using
        ;^DPT(D0,.21) node data from PATIENT file (2)
        G K2:$D(^ONCO(160,ONCOD0,"C","B","NOK"))
        S X21=$G(^DPT(DFN,.21)) G K2:X21=""
        F J=1,6,7,8,9,10 S ONCOX(J)=$P(X21,U,J)
        S CITY=ONCOX(6)
        S STATE=ONCOX(7)
        S ZIP=ONCOX(8)
        S XX21=$P(X21,U,3,5)_"^"_CITY_"^"_STATE_"^^^^"_ZIP
        S X=ONCOX(1)
        S (DIC,DIE)="^ONCO(165,",DIC(0)="Z" D ^DIC
        S CK0=+Y
        G SK1:+Y>0
        K DO S DIC(0)="ZL" D FILE^DICN S (DA,CK0)=+Y
        S DR="1///^S X=3"
        D ^DIE S ^ONCO(165,CK0,.11)=XX21,^(.13)=ONCOX(9)
        I ($P(XX21,U,1)="")&(ONCOX(10)="Y") D
        .S ^ONCO(165,CK0,.11)=^ONCO(165,CP0,.11)
        ;
SK1     ;Add NOK (Next of Kin) TYPE OF FOLLOW-UP CONTACT (160,420)
        S DA(1)=ONCOD0,(DIC,DIE)="^ONCO(160,"_DA(1)_",""C"",",X="NOK"
        K DO D FILE^DICN S DA=+Y,DR="1///^S X=CK0" D ^DIE
        ;
K2      ;Add KIN (Other Kin) to ONCOLOGY CONTACT file (165) using ^DPT(D0,.211)
        ;node data from PATIENT file (2)
        G DE:$D(^ONCO(160,ONCOD0,"C","B","KIN"))
        S X211=$G(^DPT(DFN,.211)) G DE:X211=""
        F J=1,2,6,7,8,9,10 S ONCOX(J)=$P(X211,U,J)
        S CITY=ONCOX(6)
        S STATE=ONCOX(7)
        S ZIP=ONCOX(8)
        S XX211=$P(X211,U,3,5)_"^"_CITY_"^"_STATE_"^^^^"_ZIP
        S X=ONCOX(1)
        S (DIC,DIE)="^ONCO(165,",DIC(0)="Z" D ^DIC
        S CK2=+Y G SK2:+Y>0
        K DO S DIC(0)="ZL" D FILE^DICN S (DA,CK2)=+Y
        S DR="1///^S X=3;2///^S X=ONCOX(2)" D ^DIE
        S ^ONCO(165,CK2,.11)=XX211,^(.13)=ONCOX(9)
        I ($P(XX211,U)="")&(ONCOX(10)="Y") D
        .S ^ONCO(165,CK2,.11)=^ONCO(165,CP0,.11)
        ;
SK2     ;Add KIN (Other Kin) TYPE OF FOLLOW-UP CONTACT (160,420)
        S DA(1)=ONCOD0,(DIC,DIE)="^ONCO(160,"_DA(1)_",""C"",",X="KIN"
        K DO D FILE^DICN S DA=+Y,DR="1///^S X=CK2;" D ^DIE
        ;
DE      ;Add GR (Guardian) to ONCOLOGY CONTACT file (165) using ^DPT(D0,.34)
        ;node data from PATIENT file (2)
        G EX:$D(^ONCO(160,ONCOD0,"C","B","GR"))
        S X34=$G(^DPT(DFN,.34)) G EX:X34=""
        F J=1,6,7,8,9,10 S ONCOX(J)=$P(X34,U,J)
        S CITY=ONCOX(6)
        S STATE=ONCOX(7)
        S ZIP=ONCOX(8)
        S XX34=$P(X34,U,3,5)_"^"_CITY_"^"_STATE_"^^^^"_ZIP
        S X=ONCOX(1)
        S (DIC,DIE)="^ONCO(165,",DIC(0)="Z" D ^DIC
        S GR0=+Y G SDE:+Y>0
        K DO S DIC(0)="ZL" D FILE^DICN S (DA,GR0)=+Y
        S DR="1///^S X=3" D ^DIE S ^ONCO(165,GR0,.11)=XX34,^(.13)=ONCOX(9)
        I ($P(XX34,U)="")&(ONCOX(10)="Y") D
        .S ^ONCO(165,GR0,.11)=^ONCO(165,CP0,.11)
        ;
SDE     ;Add GR (Guardian) TYPE OF FOLLOW-UP CONTACT (160,420)
        S DA(1)=ONCOD0,(DIC,DIE)="^ONCO(160,"_DA(1)_",""C"",",X="GR"
        K DO D FILE^DICN S DA=+Y,DR="1///^S X=GR0;" D ^DIE
        ;
PTCONT  ;Add PT (Patient) TYPE OF FOLLOW-UP CONTACT (160,420)
        G EX:$D(^ONCO(160,ONCOD0,"C","B","PT"))
        S DA(1)=ONCOD0,(DIE,DIC)="^ONCO(160,"_DA(1)_",""C"",",X="PT"
        K DO D FILE^DICN S DA=+Y,DR="1///^S X=CP0;" D ^DIE
        G EX
        ;
TYP     ;TYPE OF FOLLOW-UP CONTACT (160.03,.01) EXECUTABLE HELP
        W !?5,"PT (Patient) refers to this patient.",!
        Q
        ;
NAM     ;CONTACT NAME (160.03,1) EXECUTABLE HELP 
        W !?3,"To change the contact, change the CONTACT NAME."
        W !?3,"To edit the contact details, edit the CONTACT"
        W !?3,"entry in the ONCOLOGY CONTACT File.",!
        Q
        ;
EX      ;Exit
        K CITY,CK0,CK2,CP0,DA,DFN,DIC,DIE,DR,FIL,GLR,GR0,J,ONCOVP,ONCOX,STATE
        K X,X11,X13,X21,X211,X34,XX11,XX21,XX211,XX34,Y,ZIP
        Q
        ;
CLEANUP ;Cleanup
        K ONCOD0
