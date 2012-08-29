PSJRXI ;IHS/DSD/JCM/RLW-LOGS PHARMACY INTERVENTIONS ; 15 May 98 / 9:28 AM
 ;;5.0; INPATIENT MEDICATIONS ;**3**;16 DEC 97
 ; This routine is used to create entries in the APSP INTERVENTION file.
 ;---------------------------------------------------------------
START ;   
 N SAVEX,SAVEY S SAVEX=X,SAVEY=Y
 D INIT
 D DIC G:PSJRXI("QFLG") END
 D EDIT
 S:'$D(PSJNEW("PROVIDER")) PSJNEW("PROVIDER")=$P(^APSPQA(32.4,PSJRXI("DA"),0),"^",3)
END D EOJ
 Q
 ;---------------------------------------------------------------
INIT ;
 W !!,"Now creating Pharmacy Intervention",!
 I $G(PSJDRUG("IEN")) W "For  ",$P($G(^PSDRUG(PSJDRUG("IEN"),0)),"^"),!
 K PSJRXI
 S PSJRXI("QFLG")=0
 Q
 ;
DIC ;
 N DIC,DR,DA,X,DD,DO,Y
 S DIC="^APSPQA(32.4,",DLAYGO=9009032.4,DIC(0)="L",X=DT
 S DIC("DR")=".02////"_PSGP_";.04////"_DUZ_";.05////"_PSJDD_";.06///PHARMACY"
 ;S DIC("DR")=DIC("DR")_$S($G(PSJRX("INTERVENE"))=1:";.07////18",$G(PSJRX("INTERVENE"))=2:";.07////19",1:"")_";.14////0"_";.16////"_$S($G(PSJSITE)]"":PSJSITE,1:"")
 S DIC("DR")=DIC("DR")_";.07"_$S($G(PSJRXREQ)=1:"////18",$G(PSJRXREQ)=2:"////19",1:"////6")_";.14////1"_";.16////"_$S($G(PSJSITE)]"":PSJSITE,1:"")
 D FILE^DICN K DIC,DR,DA
 I Y>0 S PSJRXI("DA")=+Y
 E  S PSJRXI("QFLG")=1 G DICX
 D DIE
DICX K X,Y
 Q
DIE ;
 K DIE,DIC,DR,DA
 S DIE="^APSPQA(32.4,",DA=PSJRXI("DA"),DR=$S($G(PSJRXI("EDIT"))]"":".03:1600",1:".03;.08")
 ;L +^APSPQA(32.4,PSJRXI("DA")) D ^DIE K DIE,DIC,DR,X,Y,DA L -^APSPQA(32.4,PSJRXI("DA"))
 L +^APSPQA(32.4,PSJRXI("DA")):1 E  W !,"Sorry, someone else is editing this intervention!" Q
 D ^DIE K DIE,DIC,DR,X,Y,DA L -^APSPQA(32.4,PSJRXI("DA"))
 W $C(7),!!,"See 'Pharmacy Intervention Menu' if you want to delete this",!,"intervention or for more options.",!
 Q
EDIT ;
 K DIR W ! S DIR(0)="Y",DIR("A")="Would you like to edit this intervention ",DIR("B")="N" D ^DIR K DIR I $D(DIRUT)!'Y G EDITX
 S PSJRXI("EDIT")=1 D DIE
 G EDIT
EDITX K X,Y
 Q
 ;
EOJ ;
 K PSJRXI S X=SAVEX,Y=SAVEY
 Q
 ;
EN1(PSJORDER) ; Entry Point if have internal rx #
 I PSJX']"" W !,$C(7),"No prescription data" Q
 S PSJORDER=$S((PSJORDER["N")!(PSJORDER["P"):"^PS(53.1,"_+PSJORDER,PSJORDER["V":"^PS(55,"_DFN_",""IV"","_+PSJORDER,1:"^PS(55,"_DFN_",5,"_+PSJORDER)_","
 N PSJDFN,PSJNEW,PSJDRUG,PSJY
 I $G(^PS(53.1,PSJX,0))']"" W !,$C(7),"No prescription data" G EN1X
 S PSJRXI("IRXN")=PSJORDER
 K PSJY S PSJY=@(PSJORDER_",0)")
 S PSJDFN=$P(PSJY,"^",15),PSJNEW("PROVIDER")=$P(PSJY,"^",2)
 S PSJDRUG=0,PSJDRUG=$O(^PS(53.1,PSJRXI("IRXN"),1,PSJDRUG)) Q:'PSJDRUG  S PSJDRUG("IEN")=$G(@(PSJORDER_","_PSJDRUG),"^")
 D START
EN1X Q
