IBCEP8  ;ALB/TMP - Functions for NON-VA PROVIDER ;11-07-00
        ;;2.0;INTEGRATED BILLING;**51,137,232,288,320,343,374,377,391**;21-MAR-94;Build 39
        ;;Per VHA Directive 2004-038, this routine should not be modified.
        ;
EN      ; -- main entry point
        N IBNPRV
        K IBFASTXT
        D FULL^VALM1
        D EN^VALM("IBCE PRVNVA MAINT")
        Q
        ;
HDR     ; -- header code
        K VALMHDR
        Q
        ;
INIT    ; Initialization
        N DIC,DA,X,Y,DLAYGO,IBIF,DIR,DTOUT,DUOUT
        K ^TMP("IBCE_PRVNVA_MAINT",$J)
        ;
        ; if coming in from main routine ^IBCEP6 this special variable IBNVPMIF is set already
        I $G(IBNVPMIF)'="" S IBIF=IBNVPMIF G INIT1
        ;
        S DIR("A")="(I)NDIVIDUAL OR (F)ACILITY?: ",DIR(0)="SA^I:INDIVIDUAL;F:FACILITY" D ^DIR K DIR
        I $D(DUOUT)!$D(DTOUT) S VALMQUIT=1 G INITQ
        S IBIF=Y
        ;
INIT1   ;
        ;
        I IBIF="F" D
        . S VALM("TITLE")="Non-VA Lab or Facility Info"
        . K VALM("PROTOCOL")
        . S Y=$$FIND1^DIC(101,,,"IBCE PRVNVA NONIND MAINT")
        . I Y S VALM("PROTOCOL")=+Y_";ORD(101,"
        ;
        S DIC="^IBA(355.93,",DIC("DR")=".02///"_$S(IBIF'="F":2,1:1)
        S DIC("S")="I $P(^(0),U,2)="_$S(IBIF'="F":2,1:1)
        S DLAYGO=355.93,DIC(0)="AELMQ",DIC("A")="Select a NON"_$S(IBIF="I":"-",1:"/OTHER ")_"VA PROVIDER: "
        D ^DIC K DIC,DLAYGO
        I Y'>0 S VALMQUIT=1 G INITQ
        S IBNPRV=+Y
        D BLD^IBCEP8B(IBNPRV)
INITQ   Q
        ;
EXPND   ;
        Q
        ;
HELP    ;
        Q
        ;
EXIT    ;
        K ^TMP("IBCE_PRVNVA_MAINT",$J)
        D CLEAN^VALM10
        K IBFASTXT
        Q
        ;
EDIT1(IBNPRV,IBNOLM)    ; Edit non-VA provider/facility demographics
        ; IBNPRV = ien of entry in file 355.93
        ; IBNOLM = 1 if not called from list manager
        ;
        N DA,X,Y,DIE,DR,IBP
        I '$G(IBNOLM) D FULL^VALM1
        I IBNPRV D
        . I '$G(IBNOLM) D CLEAR^VALM1
        . S DIE="^IBA(355.93,",DA=IBNPRV,IBP=($P($G(^IBA(355.93,IBNPRV,0)),U,2)=2)
        . ; PRXM/KJH - Added NPI and Taxonomy to the list of fields to be edited. Put a "NO^" around the Taxonomy multiple (#42) since some of the sub-field entries are 'required'.
        . S DR=".01;"_$S(IBP:".03;.04",1:".05;.1;.06;.07;.08;.13///24;W !,""ID Qualifier: 24 - EMPLOYER'S IDENTIFICATION #"";.09Lab or Facility Primary ID;.11;.15")_";D PRENPI^IBCEP81(IBNPRV);D EN^IBCEP82(IBNPRV);S DIE(""NO^"")="""";42;K DIE(""NO^"")"
        . D ^DIE
        . Q:$G(IBNOLM)
        . D BLD^IBCEP8B(IBNPRV)
        I '$G(IBNOLM) K VALMBCK S VALMBCK="R"
        Q
        ;
EDITID(IBNPRV,IBSLEV)   ; Link from this list template to maintain provider-specific ids
        ; This entry point is called by 4 action protocols.
        ; IBNPRV = ien of entry in file 355.93 (can be either an individual or a facility) (required)
        ; IBSLEV = 1 for facility/provider own ID's
        ; IBSLEV = 2 for facility/provider ID's furnished by an insurance company
        ;
        Q:'$G(IBNPRV)
        Q:'$G(IBSLEV)
        N IBPRV,IBIF
        D FULL^VALM1    ; set full scrolling region
        D CLEAR^VALM1   ; clear screen
        S IBPRV=IBNPRV
        ;
        K IBFASTXT
        S IBIF=$$GET1^DIQ(355.93,IBPRV,.02,"I")    ; 1=facility/group      2=individual
        D EN^VALM("IBCE PRVPRV MAINT")
        ;
        K VALMQUIT
        S VALMBCK=$S($G(IBFASTXT)'="":"Q",1:"R")
        Q
        ;
NVAFAC  ; Enter/edit Non-VA facility information
        ; This entry point is called by the menu system for option IBCE PRVNVA FAC EDIT
        N X,Y,DA,DIC,IBNPRV,DLAYGO
        S DIC="^IBA(355.93,",DIC("S")="I $P(^(0),U,2)=1",DIC("DR")=".02///1"
        S DLAYGO=355.93,DIC(0)="AELMQ",DIC("A")="Select a NON/Other VA FACILITY: "
        D ^DIC K DIC,DLAYGO
        I Y'>0 S VALMQUIT=1 G NVAFACQ
        S IBNPRV=+Y
        D EDIT1(IBNPRV,1)
        ;
NVAFACQ Q
        ;
GETFAC(IB,IBFILE,IBELE,IBSFD)   ; Returns facility name,address lines or city-state-zip
        ; IB = ien of entry in file
        ; IBFILE = 0 for retrieval from file 4, 1 for retrieval from file 355.93
        ; If IBELE=0, returns name
        ;         =1, returns address line 1
        ;         =2, returns address line 2
        ;         =3, returns city, state zip
        ;         = "3C", returns city  = "3S", state    = "3Z", zip
        ; IBSFD (optional) = Output formatter segment name if the output needs
        ;       to be screened thru the VAMCFD^IBCEF75 procedure for the flag
        ;       in the insurance company file
        ;
        N Z,IBX,IBZ
        S IBX=""
        ;
        I $G(IBSFD)="SUB" D VAMCFD^IBCEF75(+$G(IBXIEN),.IBZ) I $D(IBZ),'$G(IBZ("C",1)) G GETFACX
        ;
        S Z=$S('IBFILE:$G(^DIC(4,+IB,1)),1:$G(^IBA(355.93,+IB,0)))
        I +IBELE=0 S IBX=$S('IBFILE:$P($G(^DIC(4,+IB,0)),U),1:$P($G(^IBA(355.93,+IB,0)),U))
        I IBELE=1!(IBELE=12) S IBX=$S('IBFILE:$P(Z,U),1:$P(Z,U,5))
        I IBELE=2!(IBELE=12) S IBX=$S(IBELE=12:IBX_" ",1:"")_$S('IBFILE:$P(Z,U,2),1:$P(Z,U,10))
        ;
        I +IBELE=3,'IBFILE D
        . S:IBELE=3!(IBELE["C") IBX=$P(Z,U,3) Q:IBELE["C"
        . S:IBELE=3 IBX=IBX_$S(IBX'="":", ",1:"") S:IBELE=3!(IBELE["S") IBX=IBX_$$STATE^IBCEFG1($P($G(^DIC(4,+IB,0)),U,2)) Q:IBELE["S"
        . S:IBELE=3 IBX=IBX_" " S:IBELE=3!(IBELE["Z") IBX=IBX_$P(Z,U,4)
        . Q
        ;
        I +IBELE=3,IBFILE D
        . S:IBELE=3!(IBELE["C") IBX=$P(Z,U,6) Q:IBELE["C"
        . S:IBELE=3 IBX=IBX_$S(IBX'="":", ",1:"") S:IBELE=3!(IBELE["S") IBX=IBX_$$STATE^IBCEFG1($P(Z,U,7))
        . S:IBELE=3 IBX=IBX_" " S:IBELE=3!(IBELE["Z") IBX=IBX_$P(Z,U,8)
        . Q
GETFACX ;
        Q IBX
        ;
ALLID(IBPRV,IBPTYP,IBZ) ; Returns array IBZ for all ids for provider IBPRV
        ; for all provider id types or for id type in IBPTYP
        ; IBPRV = vp ien of provider
        ; IBPTYP = ien of provider id type to return or "" for all
        ; IBZ = array returned with internal data:
        ;  IBZ(file 355.9 ien)=ID type^ID#^ins co^form type^bill care type^care un^X12 code for id type
        N Z,Z0
        K IBZ
        G:'$G(IBPRV) ALLIDQ
        S IBPTYP=$G(IBPTYP)
        S Z=0 F  S Z=$O(^IBA(355.9,"B",IBPRV,Z)) Q:'Z  S Z0=$G(^IBA(355.9,Z,0)) D
        . I $S(IBPTYP="":1,1:($P(Z0,U,6)=IBPTYP)) S IBZ(Z)=($P(Z0,U,6)_U_$P(Z0,U,7)_U_$P(Z0,U,2)_U_$P(Z0,U,4)_U_$P(Z0,U,5)_U_$P(Z0,U,3))_U_$P($G(^IBE(355.97,+$P(Z0,U,6),0)),U,3)
        ;
ALLIDQ  Q
        ;
CLIA()  ; Returns ien of CLIA # provider id type
        N Z,IBZ
        S (IBZ,Z)=0 F  S Z=$O(^IBE(355.97,Z)) Q:'Z  I $P($G(^(Z,0)),U,3)="X4",$P(^(0),U)["CLIA" S IBZ=Z Q
        Q IBZ
        ;
STLIC() ; Returns ien of STLIC# provider id type
        N Z,IBZ
        S (IBZ,Z)=0 F  S Z=$O(^IBE(355.97,Z)) Q:'Z  I $P($G(^(Z,1)),U,3) S IBZ=Z Q
        Q IBZ
        ;
TAXID() ; Returns ien of Fed tax id provider id type
        N Z,IBZ
        S (IBZ,Z)=0 F  S Z=$O(^IBE(355.97,Z)) Q:'Z  I $P($G(^(Z,1)),U,4) S IBZ=Z Q
        Q IBZ
        ;
CLIANVA(IBIFN)  ; Returns CLIA # for a non-VA facility on bill ien IBIFN
        N IBCLIA,IBZ,IBNVA,Z
        S IBCLIA="",IBZ=$$CLIA()
        I IBZ D
        . S IBNVA=$P($G(^DGCR(399,IBIFN,"U2")),U,10) Q:'IBNVA
        . S IBCLIA=$$IDFIND^IBCEP2(IBIFN,IBZ,IBNVA_";IBA(355.93,","",1)
        Q IBCLIA
        ;
VALFAC(X)       ; Function returns 1 if format is valid for X12 facility name
        ; Alpha/numeric/certain punctuation valid.  Must start with an Alpha
        N OK,VAL
        S OK=1
        S VAL("A")="",VAL("N")="",VAL=",.- "
        I $E(X)'?1A!'$$VALFMT(X,.VAL) S OK=0
        Q OK
        ;
VALFMT(X,VAL)   ; Returns 1 if format of X is valid, 0 if not
        ; X = data to be examined
        ; VAL = a 'string' of valid characters AND/OR (passed by reference)
        ;    if VAL("A") defined ==> Alpha
        ;    if VAL("A") defined ==> Numeric valid
        ;    if VAL("A") defined ==> Punctuation valid
        ;   any other character included in the string is checked individually
        N Z
        I $D(VAL("A")) D
        . N Z0
        . F Z=1:1:$L(X) I $E(X,Z)?1A S Z0(Z)=""
        . S Z0="" F  S Z0=$O(Z0(Z0),-1) Q:'Z0  S $E(X,Z0)=""
        I $D(VAL("N")) D
        . N Z0
        . F Z=1:1:$L(X) I $E(X,Z)?1N S Z0(Z)=""
        . S Z0="" F  S Z0=$O(Z0(Z0),-1) Q:'Z0  S $E(X,Z0)=""
        I $D(VAL("P")) D
        . N Z0
        . F Z=1:1:$L(X) I $E(X,Z)?1P S Z0(Z)=""
        . S Z0="" F  S Z0=$O(Z0(Z0),-1) Q:'Z0  S $E(X,Z0)=""
        I $G(VAL)'="" S X=$TR(X,VAL,"")
        Q (X="")
        ;
PS(IBXSAVE)     ; Returns 1 if IBXSAVE("PSVC") indicates the svc was non-lab
        ;
        Q $S($G(IBXSAVE("PSVC"))="":0,1:"13"[IBXSAVE("PSVC"))
        ;
        ; Pass in the Internal Entry number to File 355.93
        ; Return the Primary ID and Qualifier (ID Type) from 355.9
PRIMID(IEN35593)        ; Return External Primary ID and ID Quailier
        N INDXVAL,LIST,MSG,IDCODE
        S INDXVAL=IEN35593_";IBA(355.93,"
        N SCREEN S SCREEN="I $P(^(0),U,8)"
        D FIND^DIC(355.9,,"@;.06EI;.07","Q",INDXVAL,,,SCREEN,,"LIST","MSG")
        I '+$G(LIST("DILIST",0)) Q ""   ; No Primary ID
        I +$G(LIST("DILIST",0))>1 Q "***ERROR***^***ERROR***"  ; Bad.  More than one.
        ; Found just one
        S IDCODE=$$GET1^DIQ(355.97,LIST("DILIST","ID",1,.06,"I"),.03)
        Q $G(LIST("DILIST","ID",1,.07))_U_IDCODE_" - "_$G(LIST("DILIST","ID",1,.06,"E"))
