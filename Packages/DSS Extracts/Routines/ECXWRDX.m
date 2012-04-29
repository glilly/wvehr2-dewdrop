ECXWRDX ;ALB/JAP - Assign DSS Dept. to Ward ;July 16, 1998
 ;;3.0;DSS EXTRACTS;**8**;Dec 22, 1997
 ;
EN ;entry point from menu option
 ;lookup ward
 N DIC,DIR,DTOUT,DUOUT,DIRUT,X,Y,DSSID,OUT
 S DIC(0)="AEMQZ",DIC="^DIC(42," D ^DIC G:$D(DTOUT)!($D(DUOUT))!(+Y<1) EXIT
 S ECXWARD=+Y,DSSID=""
 S DR=".01;.02;.03;.015;.017",DIQ(0)="IE",DIQ="ECX",DA=ECXWARD,DIC="^DIC(42," K ECX D EN^DIQ1
 S ECXWARD=ECXWARD_U_$G(ECX(42,+ECXWARD,.01,"E"))
 W !!,"Ward: ",?18,$P(ECXWARD,U,2)
 S ECXDIV=$G(ECX(42,+ECXWARD,.015,"I"))
 I +ECXDIV>0 D
 .;division may not exist in file #727.3, or it may not have a dss id
 .S DSSID=$P($G(^ECX(727.3,+ECXDIV,0)),U,2) S:DSSID="" DSSID="Not defined"
 .S ECXDIV=ECXDIV_U_ECX(42,+ECXWARD,.015,"E")_"/"_$P(^DG(40.8,+ECXDIV,0),U,2)_" <"_DSSID_">"
 W !,"Ward Bedsection: ",?18,$G(ECX(42,+ECXWARD,.02,"E"))
 W !,"Ward Specialty: ",?18,$G(ECX(42,+ECXWARD,.017,"E"))
 W !,"Ward Service: ",?18,$G(ECX(42,+ECXWARD,.03,"E"))
 I +ECXDIV>0 W !,"Division: ",?18,$P(ECXDIV,U,2)
 ;dss id for division is needed to derive dss dept code
 I DSSID["Not" D  G EN
 .W !!,"Cannot proceed with assignment of DSS Department code for ward,"
 .W !,"because the "_ECX(42,+ECXWARD,.015,"E")_" division does not have a DSS Division Identifier."
 .W !
 .W !,"Use the Enter/Edit DSS Division Identifier option to associate an"
 .W !,"identifier with "_ECX(42,+ECXWARD,.015,"E")_"."
 .I $E(IOST)="C" D
 ..S SS=22-$Y F JJ=1:1:SS W !
 ..S DIR(0)="E" W ! D ^DIR K DIR,JJ,SS W !
 I ECXDIV="" D  G EN
 .W !!,"Cannot proceed with assignment of DSS Department code for ward,"
 .W !,"because the ward is not associated with a Medical Center Division."
 .W !
 .I $E(IOST)="C" D
 ..S SS=22-$Y F JJ=1:1:SS W !
 ..S DIR(0)="E" W ! D ^DIR K DIR W !
 I '$D(ECX(727.4,+ECXWARD)) D
 .S (X,DINUM)=+ECXWARD,DIC(0)="L",DLAYGO=727.4,DIC="^ECX(727.4,"
 .K DD,DO D FILE^DICN K DIC,DINUM,DLAYGO,X,Y
 S DR="1;",DIQ(0)="E",DIQ="ECX",DA=+ECXWARD,DIC="^ECX(727.4," K ECX D EN^DIQ1
 S ECXDEPT=$G(ECX(727.4,+ECXWARD,1,"E"))
 S ECXDEPT0=ECXDEPT K X,Y
 ;if ward has dss dept, then edit
 I ECXDEPT]"" D
 .D REVERSE^ECXDSSD(ECXDEPT,.ECXDESC)
 .W !!,"DSS Department for Ward "_$P(ECXWARD,U,2)
 .W !?5,"Service ",?20,"<"_$E(ECXDEPT,1)_">  = "_$P(ECXDESC,U,1)
 .W !?5,"Prod. Unit ",?20,"<"_$E(ECXDEPT,2,3)_"> = "_$P(ECXDESC,U,2)
 .W !?5,"Division ",?20,"<"_$E(ECXDEPT,4)_">  = "_$P(ECXDESC,U,3)
 .W !?5,"Suffix ",?22,"   = "_$E(ECXDEPT,5,7),!!
 .S DIR(0)="YA",DIR("A")="Do you want edit this DSS Department? ",DIR("B")="YES" K X,Y
 .D ^DIR K DIR W !!
 .Q:$D(DIRUT)
 .I Y=1 D DEPT(ECXWARD,ECXDIV,.ECXDEPT)
 G:ECXDEPT0]"" EN
 ;if ward doesn't have dss dept, then enter
 I ECXDEPT0="" D DEPT(ECXWARD,ECXDIV,.ECXDEPT)
 G EN
 ;
DEPT(ECXWARD,ECXDIV,ECXDEPT) ;allow user to enter/edit dss dept for ward
 ;division is already known from file #42 (above)
 ;service is 'nursing' by definition - ien 27 in file #730
 ; input
 ; ECXWARD = 1st piece is ien to file #42 & file #727.4; required
 ; ECXDIV = 1st piece is ien to file $40.8 & file #727.3; required
 ; output
 ; ECXDEPT = current dss department code for ward or null
 N ECXSVC,ECXPUNIT,ECXDESC,ECXSUF,OUT,X,Y,SS,JJ,DIRUT,DTOUT,DUOUT
 I ECXDEPT="" D
 .W !,"The medical center division for the ward selected is"
 .W !,"already known.  The service associated with all ward"
 .W !,"production units is 'Nursing'.",!
 .W !!,"You must identify the DSS Production Unit for this ward,"
 .W !,"and a suffix (if needed) to complete the DSS Department code."
 .I $E(IOST)="C" D
 ..S SS=22-$Y F JJ=1:1:SS W !
 ..S DIR(0)="E" W ! D ^DIR K DIR W !
 I ECXDEPT]"" D
 .W !,"You may edit the DSS Production Unit and suffix,"
 F  D  Q:$D(DIRUT)!(OUT=1)
 .S ECXDEPT=""
 .S ECXSVC=27,(ECXPUNIT,ECXSUF)="",OUT=0
 .S ECXDEPT=$$DERIVE^ECXDSSD(ECXSVC,ECXPUNIT,+ECXDIV,ECXSUF)
 .;diplay dss dept code to user
 .I ECXDEPT="" S OUT=1 Q
 .D REVERSE^ECXDSSD(ECXDEPT,.ECXDESC)
 .W !!,"DSS Department for Ward "_$P(ECXWARD,U,2)
 .W !?5,"Service ",?20,"<"_$E(ECXDEPT,1)_">  = "_$P(ECXDESC,U,1)
 .W !?5,"Prod. Unit ",?20,"<"_$E(ECXDEPT,2,3)_"> = "_$P(ECXDESC,U,2)
 .W !?5,"Division ",?20,"<"_$E(ECXDEPT,4)_">  = "_$P(ECXDESC,U,3)
 .W !?5,"Suffix ",?22,"   = "_$E(ECXDEPT,5,7),!!
 .S DIR(0)="YA",DIR("A")="Is this ok? ",DIR("B")="YES" K X,Y
 .D ^DIR K DIR
 .I $D(DIRUT)!(Y=0) S ECXDEPT="" Q
 .I Y S OUT=1
 Q:$D(DIRUT)
 I ECXDEPT]"" S DIE="^ECX(727.4,",DA=+ECXWARD,DR="1////^S X=ECXDEPT;" D ^DIE
 W !!
 Q
 ;
EXIT ;common exit point
 K ECX,ECXWARD,ECXDEPT,ECXSVC,ECXDIV,ECXPUNIT,ECXSUF,ECXDESC
 Q
