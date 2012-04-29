LEXA1 ;ISL/KER - Lexicon Look-up (Loud) ;11/30/2008
 ;;2.0;LEXICON UTILITY;**3,4,6,11,15,38,55**;Sep 23, 1996;Build 11
 ;
EN ; Initialize
 ; Fileman Inquire Option
 I $D(DIC(0)),$G(DIC(0))["A" K X
 ; Date Check
 N LEXQ S LEXQ=0 I $D(LEXVDT) I $L($G(^TMP("LEXSCH",$J,"VDT",0))) S LEXVDT=^TMP("LEXSCH",$J,"VDT",0)
 I '$D(LEXVDT) I $L($G(^TMP("LEXSCH",$J,"VDT",0))) N LEXVDT S LEXVDT=^TMP("LEXSCH",$J,"VDT",0)
 ;
 ; LEXSUB  Special variable from version 1.0 specifying the
 ;         vocabulary subset to use during the search.  It is
 ;         a three character mnemonic taken from the Subset
 ;         Definition file #757.2.  The default is "WRD"
 S:'$L($G(LEXSUB)) LEXSUB="WRD"
 ;
 ; LEXAP   Special variable from version 1.0 specifying the
 ;         application using the Lexicon.  It is a pointer
 ;         value to the Subset Definition file #757.2.
 ;         The default is 1 (Lexicon)
 S:'$L($G(LEXAP))&($L($G(^TMP("LEXSCH",$J,"APP",0)))) LEXAP=^TMP("LEXSCH",$J,"APP",0)
 S:'$L($G(LEXAP)) LEXAP=1
 ;
 ; LEXLL   Special variable (new) specifying the length of the
 ;         displayable list the user is to select from.  Default
 ;         is 5 (display 5 at a time until the entire list has
 ;         been reviewed)
 S:'$L($G(LEXLL)) LEXLL=5
 ;
 ; LEXSRC  Special variable specifying the source of the
 ;         vocabulary to use during the search.  It is
 ;         an Internal Entry Number to the Source File
 ;         #757.14.  There is no default value.
 N LEXXSR S:$L($G(LEXSRC)) LEXXSR=$G(LEXSRC)
 ;
 ; LEXCAT  Special variable specifying the source category of
 ;         the vocabulary to use during the search.  It is
 ;         an Internal Entry Number in the Source Category
 ;         file #757.13.  There is no default value.
 N LEXXCT S:$L($G(LEXCAT)) LEXXCT=$G(LEXCAT)
 ;
 ; Check the DIC variables new LEXUR "user response"
 N LEXDICA,LEXDICB,LEXO,XTLKGBL,XTLKHLP,XTLKKSCH,XTLKSAY  D CHK N LEXUR
 ;
 ; Save the value of X if "Ask" is not specified in DIC(0)
 I DIC(0)'["A",$L($G(X)) S LEXSAVE=X K X
 ;
 ; Save the prompt
 I $L($G(DIC("A"))) S LEXDICA=DIC("A")
 ;
 ; Continue to lookup until the dialog with the application
 ; ends.  If there is nothing to lookup (X="") or an uparrow
 ; is detected, the Lexicon shuts down killing LEX.
 ;
 F  D LK Q:'$D(LEX)!($D(LEX("SEL")))
 G EXIT
LK ; Start Look-up
 ; X not provided
 D:'$D(LEXSAVE) ASK
 ; X provided
 S:$D(LEXSAVE) X=LEXSAVE K LEXSAVE
 ; X was null with a default provided
 S:$D(DIC("B"))&($G(X)="") X=DIC("B")
 ; Lookup X - LOOK(LEXX,LEXAP,LEXLL,LEXSUB,LEXVDT,LEXXSR,LEXXCT)
 D LOOK^LEXA(X,LEXAP,LEXLL,,,$G(LEXXSR),$G(LEXXCT))
 K DIC("B")
 ;
NOTFND ; If X was not found
 ;
 ;    Write "??"
 ;
 ;    Calling application uses Unresolved Narratives
 ;      Prompt to "accept or reject" the narrative, if
 ;      no selection is made continue the search
 ;
 ;    Calling application does not use Unresolved Narratives
 ;      Display help, Re-prompt and Continue search
 ;
 I '$D(LEX("LIST")),+($G(LEX))=0,$L(X),X'["^",$E(X,1)'=" " D  K LEX S LEX=0 Q
 . K DIC("B"),LEX("SEL") I +($G(^TMP("LEXSCH",$J,"UNR",0)))=0 I +($G(X))'=757.01 W "  ??" D:$D(LEX("HLP")) DH^LEXA3 W ! Q
 . I +($G(^TMP("LEXSCH",$J,"UNR",0)))=1 W "  ??" D EN^LEXA4 W !
FOUND ; If X was found
 ;
 ;    Begin user selection.  Continue to display the list
 ;    until the dialog with the user is terminated.  The
 ;    dialog is considered to be terminated if:
 ;
 ;      The selection list does not exist  '$D(LEX("LIST"))
 ;      The user has made a selection       $D(LEX("SEL")
 ;
 I $D(LEX("LIST")) F  Q:+($G(LEX))=0  D SELECT^LEXA2
 Q:$D(LEX("SEL"))
 I '$L($G(LEX)) K LEX Q
 I $L($G(LEX)),'$D(LEX("SEL")),$D(^TMP("LEXSCH",$J)) D
 . D EN^LEXA4 S:'$D(LEX("SEL")) LEX=0
 Q
EXIT ; Set/Kill variables Y, Y(0,0) Y(1) Y(81) from LEX("SEL")
 S:$L($G(LEXDICA)) DIC("A")=LEXDICA S:$L($G(LEXDICB)) DIC("B")=LEXDICB
 S:'$D(LEX("SEL","EXP",1)) Y=-1 K Y(1)
 I $D(LEX("SEL","EXP",1)) S Y=LEX("SEL","EXP",1) D Y1,SSBR S:DIC(0)["Z" Y(0)=^LEX(757.01,+(LEX("SEL","EXP",1)),0),Y(0,0)=$P(^LEX(757.01,+(LEX("SEL","EXP",1)),0),"^",1)
 D CL
 Q
CL ; Clear LEX and Multi-Term Lookup XTLK
 K LEX,LEXSUB,LEXAP,LEXLL D CLR
 Q
CLR ; Clear ^TMP Global
 K ^TMP("LEXSCH",$J),^TMP("LEXHIT",$J),^TMP("LEXFND",$J)
 Q
Y1 ; ICD in Y(1) and CPT in Y(81)
 N LEXVAS S LEXVAS=0,Y(1)=""
 F  S LEXVAS=$O(LEX("SEL","VAS","B",80,LEXVAS)) Q:+LEXVAS=0!(Y(1)'="")  D
 . S Y(1)=$P($G(LEX("SEL","VAS",LEXVAS)),"^",3)
 S LEXVAS=0,Y(81)="" F  S LEXVAS=$O(LEX("SEL","VAS","B",81,LEXVAS)) Q:+LEXVAS=0!(Y(81)'="")  D
 . S Y(81)=$P($G(LEX("SEL","VAS",LEXVAS)),"^",3)
 K:Y(1)="" Y(1) K:Y(81)="" Y(81)
 I $D(Y(1)) D
 .W !!,">>>  Code  :  "
 .I $D(IOINHI)&($D(IOINORM)) W IOINHI,Y(1),IOINORM,! Q
 .W Y(1),!
 Q
ASK ; Get user input
 N DIR,DIRUT,DIROUT S:$L($G(LEXDICA)) DIC("A")=LEXDICA
 S DIR("A")=DIC("A") W:'$L($G(X))&('$L($G(LEXDICB))) !
 I '$L($G(X)),$L($G(LEXDICB)) S DIR("B")=LEXDICB
 S DIR("?")="    "_$$SQ^LEXHLP
 S DIR("??")="^D INPHLP^LEXA1" N Y S DIR(0)="FAO^0:245" K X
 D ^DIR
 K DIC("B") D:$E(X,1)=" " RSBR
 W:$E(X,1)'=" " !
 F  Q:$E(X,1)'=" "  S X=$E(X,2,$L(X))
 W:$D(DTOUT) !,"Try later.",!
 I $D(DTOUT)!(X="^") S X=""
 S:X[U DUOUT=1 K DIRUT,DIROUT Q
INPHLP ; Look-up help
 N X S X="" S:$L($G(DIR("?"))) X=$G(DIR("?")) S:'$L(X) X="    "_$$SQ^LEXHLP
 W:$L(X) !!,X,!
 W !,"    Best results occur using one to three full or partial words without"
 W !,"    a suffix (i.e., ""DIABETES"",""DIAB MELL"",""DIAB MELL INSUL"") or"
 W !,"    a classification code (ICD, CPT, HCPCS, etc)"
 Q
CHK ; Check Fileman look-up variables
 K DIC("DR"),DIC("P"),DIC("V"),DLAYGO,DINUM
 S:$L($G(X)) LEXSAVE=X S:$L($G(DIC("B"))) LEXDICB=DIC("B") K DIC("B")
 I $L($G(DIC(0))) D
 . F  Q:DIC(0)'["L"  S DIC(0)=$P(DIC(0),"L",1)_$P(DIC(0),"L",2)
 . F  Q:DIC(0)'["I"  S DIC(0)=$P(DIC(0),"I",1)_$P(DIC(0),"I",2)
 S:'$L($G(DIC(0))) DIC(0)="QEAMF" S:'$L($G(DIC)) DIC="^LEX(757.01,"
 S:DIC(0)'["F" DIC(0)=DIC(0)_"F" S:'$L($G(DIC("A"))) DIC("A")="Enter Term/Concept:  "
 S LEXDICA=DIC("A")
 Q
SSBR ; Store data for Space Bar Return
 Q:'$L($G(DUZ))  Q:+($G(DUZ))=0  Q:'$L($G(DIC))  Q:$G(DIC)'["757.01,"
 Q:$G(DIC(0))'["F"  Q:+($G(Y))'>2  Q:$E($G(X),1)=" "  S ^DISV(DUZ,DIC)=+($G(Y))
 Q
RSBR ; Retrieve onSpace Bar Return
 Q:'$L($G(DUZ))  Q:$G(DIC)'="^LEX(757.01,"  Q:$G(DIC(0))'["F"
 Q:$E($G(X),1)'=" "  S:+($G(^DISV(DUZ,DIC)))>2 X=@(DIC_+($G(^DISV(DUZ,DIC)))_",0)")
 Q
