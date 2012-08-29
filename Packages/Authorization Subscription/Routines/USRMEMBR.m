USRMEMBR        ; SLC/JER - User Class Management actions ;3/5/10
        ;;1.0;AUTHORIZATION/SUBSCRIPTION;**2,3,6,7,29,33**;Jun 20, 1997;Build 7
EDIT    ; Edit user's class membership
        ;N USRDA,USRDATA,USREXPND,USRI,USRSTAT,DIROUT,USRCHNG,USRLST
        N USRDA,USRDATA,USRI,DIROUT,USRCHNG,USRLST
        I '$D(VALMY) D EN^VALM2(XQORNOD(0))
        S (USRCHNG,USRI)=0
        F  S USRI=$O(VALMY(USRI)) Q:+USRI'>0  D  Q:$D(DIROUT)
        . S USRDATA=$G(^TMP("USRMMBRIDX",$J,USRI))
        . W !!,"Editing #",+USRDATA,!
        . S USRDA=+$P(USRDATA,U,2) D EDIT1
        . I +$G(USRCHNG) S USRLST=$S($L($G(USRLST)):$G(USRLST)_", ",1:"")_USRI
        . I $D(USRDATA) D UPDATE^USRM(USRDATA)
        W !,"Refreshing the list."
        S VALMSG="** "_$S($L($G(USRLST)):"Item"_$S($L($G(USRLST),",")>1:"s ",1:" ")_$G(USRLST),1:"Nothing")_" Edited **"
        K VALMY S VALMBCK="R"
        Q
EDIT1   ; Single record edit
        ; Receives USRDA
        N DA,DIE,DR
        I '+$G(USRDA) W !,"No Classes selected." H 2 S USRCHNG=0 Q
        S DIE="^USR(8930.3,",DA=USRDA,DR="[USR MEMBERSHIP EDIT]"
        D FULL^VALM1,^DIE S USRCHNG=1
        Q
ADD     ; Add a member to the class
        N DA,DR,DIC,DLAYGO,X,Y,USRCLASS,USRUSER,USRQUIT,USRCNT D FULL^VALM1
        S USRCNT=0
        F  D  Q:+$G(USRQUIT)
        . W !
        . S DIC=200,DIC(0)="AEMQ"
        . S DIC("A")="Select "_$S(USRCNT'>0:"",1:"Another ")_"MEMBER: "
        . D ^DIC I +Y'>0 S USRQUIT=1 Q
        . I $$ISAWM^USRLM(+Y,USRDA) Q 
        . I $$ISTERM^USRLM(+Y) D  Q
        .. S USRQUIT=1
        .. W !,"The user you selected is terminated, cannot add them as a class member!"
        .. H 2
        . S (DIC,DLAYGO)=8930.3,DIC(0)="LM",X=""""_$P(Y,U,2)_""""
        . S DIC("W")="D DICW^USRMEMBR"
        . D ^DIC I +Y'>0 S USRQUIT=1 Q
        . S USRCREAT=+$P(Y,U,3),USRCNT=USRCNT+1
        . S DA=+Y,DIE=DIC,DIE("NO^")="BACK",DR="[USR CLASS EDIT]" D ^DIE
        . I $D(Y) D  Q
        . . S DIK=DIC D ^DIK K DIK
        . . S:+USRCNT'>1 VALMSG="** Nothing Added **"
        . . S VALMBCK="R",USRQUIT=1
        . I 'USRCREAT D  Q
        . . S:+USRCNT'>1 VALMSG="** Nothing Added **"
        . . S VALMBCK="R",USRQUIT=1
        W !,"Rebuilding membership list."
        S USRCLASS=+$G(^TMP("USRM",$J,0))
        D BUILD^USRMLST(USRCLASS)
        I USRCNT'>1,+$G(DA) D
        . S USRUSER=$$SIGNAME^USRLS(+$G(^USR(8930.3,+DA,0)))
        . S VALMSG="** "_USRUSER_" Added **"
        S VALMCNT=+$G(@VALMAR@(0))
        S VALMBCK="R"
        Q
DICW    ; Write code for member look-up
        N USRSIGNM,USRCLASS,USREFF,USREXP,USRMEM
        S USRMEM=$G(^USR(8930.3,+Y,0))
        S USRSIGNM=$$SIGNAME^USRLS(+USRMEM)
        S USRCLASS=$E($$CLNAME^USRLM(+$P(USRMEM,U,2),1),1,24)
        S USREFF=$$DATE^USRLS($P(USRMEM,U,3),"MM/DD/YY")
        S USREXP=$$DATE^USRLS($P(USRMEM,U,4),"MM/DD/YY")
        W USRSIGNM,"  ",USRCLASS,?60,USREFF," - ",USREXP
        Q
DELETE  ; Delete a member to the class
        N DIE,X,Y,USRCLASS D FULL^VALM1
        N USRCLASS,USRDA,USRCHNG,USRDATA,USRI,USRLST,DIROUT
        I '$D(VALMY) D EN^VALM2(XQORNOD(0))
        S USRI=0
        F  S USRI=$O(VALMY(USRI)) Q:+USRI'>0  D  Q:$D(DIROUT)
        . S USRDATA=$G(^TMP("USRMMBRIDX",$J,USRI))
        . S USRDA=+$P(USRDATA,U,2) D DELETE1(USRDA)
        . S:+$G(USRCHNG) USRLST=$S(+$G(USRLST):USRLST_", ",1:"")_+USRDATA
        . I $D(USRDATA) D UPDATE^USRM(USRDATA)
        W !,"Rebuilding the list."
        S USRCLASS=+$G(^TMP("USRM",$J,0))
        D BUILD^USRMLST(USRCLASS)
        S VALMCNT=+$G(@VALMAR@(0))
        K VALMY S VALMBCK="R"
        S VALMSG="** "_$S($L($G(USRLST)):"Item"_$S($L($G(USRLST),",")>1:"s ",1:" ")_$G(USRLST),1:"Nothing")_" removed **"
        Q
DELETE1(DA)     ; Delete one member from a class
        N DIE,DR,USER,CLASS,USRMEM0 S USRMEM0=$G(^USR(8930.3,+DA,0))
        I USRMEM0']"" W !,"Record #",DA," NOT FOUND!" Q
        ;S USER=$P($G(^VA(200,+USRMEM,0)),U)
        S USER=$$PERSNAME^USRLM1(+USRMEM0)
        S CLASS=$P($G(^USR(8930,+$P(USRMEM0,U,2),0)),U)
        W !,"Removing ",USER," from ",CLASS
        I '$$READ^USRU("Y","Are you SURE","NO") S USRCHNG=0 W !,USER," NOT Removed from ",CLASS,"." Q
        S USRCHNG=1
        S DIK="^USR(8930.3," D ^DIK K DIK W "."
        Q
SCHEDULE        ; Schedule changes in class membership
        N DIC,DLAYGO,X,Y
        N USRCREAT,USRDUZ,USRUSER,USRMIN,USRMAX,USREFF,USREXP,USRCLASS
        N USRCLNM
        D FULL^VALM1
        I '$D(VALMY) D EN^VALM2(XQORNOD(0))
        S DIC=8930,DIC(0)="AEMQZ",DIC("A")="Select CLASS: "
        S DIC("B")=$P($G(^TMP("USRMMBR",$J,0)),U,2)
        D ^DIC Q:+Y'>0
        S USRCLASS=+Y,USRCLNM=$$CLNAME^USRLM(USRCLASS,1)
        S USRMIN=DT,USRMAX=$$FMADD^XLFDT(DT,365)
        S USREFF=$$READ^USRU("D^"_USRMIN_":"_USRMAX_":EXFT"," Specify EFFECTIVE DATE/TIME","TODAY")
        S USREXP=$$READ^USRU("D^"_USRMIN_":"_USRMAX_":EXFT","Specify EXPIRATION DATE/TIME","T+365")
        S USRI=0
        F  S USRI=$O(VALMY(USRI)) Q:+USRI'>0  D
        . N USRDATA,USRDUZ,USRMEM,USRUSER,DIC,DIE,DA,DR,X,Y
        . S USRDATA=$G(^TMP("USRMMBRIDX",$J,USRI))
        . S USRMEM=$G(^USR(8930.3,+$P(USRDATA,U,2),0)),USRDUZ=+USRMEM
        . S DIC=200,DIC(0)="NX",X="`"_USRDUZ
        . D ^DIC Q:+Y'>0
        . S (DIC,DLAYGO)=8930.3,DIC(0)="LM",X=""""_$P(Y,U,2)_""""
        . D ^DIC Q:+Y'>0
        . S USRCREAT=+$P(Y,U,3)
        . S DA=+Y,DIE=DIC
        . S DR=".02////"_USRCLASS_";.03////"_USREFF_";.04////"_USREXP
        . D ^DIE
        W !,"Rebuilding membership list."
        S VALMBCK="R"
        Q
