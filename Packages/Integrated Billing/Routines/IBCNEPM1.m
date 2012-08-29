IBCNEPM1 ;DAOU/ESG - PAYER MAINT/INS COMPANY LIST FOR PAYER ;22-JAN-2003
 ;;2.0;INTEGRATED BILLING;**184**;21-MAR-94
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
EN(IEN,PAYER,PROFID,INSTID) ; -- main entry point for IBCNE PAYER EXPAND LIST
 ; IEN is the IEN of the Payer(#365.15).  PAYER is the payer's name.
 ; PROFID and INSTID are the EDI ID numbers for the selected payer
 ; These are passed into this routine from EXPND^IBCNEPM2.
 ;
 D EN^VALM("IBCNE PAYER EXPAND LIST")
 D BUILD^IBCNEPM
 S VALMBCK="R"
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="PAYER: "_$E(PAYER,1,30)_"     Prof. EDI#:"_$E($G(PROFID),1,15)_"  Inst. EDI#:"_$E($G(INSTID),1,15)
 S VALMHDR(2)="Insurance Company Name - Active Only"
 Q
 ;
INIT ; -- init variables and list array
 ; Variable PAYER (payer name) is returned by this procedure and used 
 ; by the list header.  Variable LINE is also set before coming into 
 ; this procedure.
 ;
 KILL ^TMP("IBCNEPM",$J,2),^TMP("IBCNEPM",$J,"LINK")
 NEW INS,ROW,STRING2,NAME,DATA,ADDRESS,DATA2,PROFID,INSTID
 ;
 ;IEN is the payer ien (#365.15)
 ;PAYER is the payer name
 I IEN=""!(PAYER="") Q
 ;
 ; INS is the insurance company ien
 S INS="",ROW=0
 F  S INS=$O(^TMP("IBCNEPM",$J,"PYR",PAYER,IEN,INS)) Q:INS=""  D
 . S STRING2="",ROW=ROW+1
 . S NAME=$P($G(^DIC(36,INS,0)),U)   ; insurance company name
 . S DATA=$G(^DIC(36,INS,.11))
 . S ADDRESS=$P(DATA,U)_"  "_$P(DATA,U,4)
 . I $P(DATA,U,4)'="" S ADDRESS=ADDRESS_","
 . S ADDRESS=ADDRESS_"  "_$P($G(^DIC(5,+$P(DATA,U,5),0)),U,2)
 . S DATA2=$G(^DIC(36,INS,3))
 . S PROFID=$P(DATA2,U,2),INSTID=$P(DATA2,U,4)
 . S STRING2=$$SETFLD^VALM1(NAME,STRING2,"INSURANCE CO")
 . S STRING2=$$SETFLD^VALM1(ADDRESS,STRING2,"ADDRESS")
 . S STRING2=$$SETFLD^VALM1(ROW,STRING2,"LINE")
 . S STRING2=$$SETFLD^VALM1(PROFID,STRING2,"PROFEDI")
 . S STRING2=$$SETFLD^VALM1(INSTID,STRING2,"INSTEDI")
 . D SET^VALM10(ROW,STRING2)
 . ;
 . ; "LINK" scratch global structure = payer ien^ins co ien^payer name
 . S ^TMP("IBCNEPM",$J,"LINK",ROW)=IEN_U_INS_U_PAYER
 . Q
 ;
 S VALMCNT=ROW
 I VALMCNT=0 S VALMSG=" No Matching Insurance Companies "
 Q
 ;
HELP ; -- help code
 N X S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
LINK ; -- code to facilitate the linking between the ins company and payer
 NEW DIR,X,Y,DIRUT,DIROUT,DTOUT,DUOUT,LINKDATA,PIEN,INS,TPAYER,INSNM
 NEW DA,DIE,DR,D,D0,DI,DIC,DISYS,DQ,%
 ;
 ;PIEN - temp variable for payer IEN (#365.15)
 ;TPAYER - temp variable for payer name
 ;
 D FULL^VALM1
 I 'VALMCNT D  G LINKX
 . W !!?5,"There are no insurance companies to select."
 . D PAUSE^VALM1
 . Q
 ;
 S DIR(0)="NO^1:"_VALMCNT_":0"
 S DIR("A")="Select Insurance Company Entry"
 W !
 D ^DIR K DIR
 I 'Y G LINKX
 S LINKDATA=$G(^TMP("IBCNEPM",$J,"LINK",+Y))
 I LINKDATA="" G LINKX
 S PIEN=+$P(LINKDATA,U,1),TPAYER=$P($G(^IBE(365.12,PIEN,0)),U,1)
 S INS=+$P(LINKDATA,U,2),INSNM=$P($G(^DIC(36,INS,0)),U,1)
 W !!,"             Payer:  ",TPAYER
 W !," Insurance Company:  ",INSNM
 W !
 S DIR(0)="YO"
 S DIR("A")=" Do you want to link this insurance company to this payer"
 S DIR("B")="YES"
 D ^DIR K DIR
 I 'Y G LINKX
 ;
 ; At this point we know that we should make the linkage
 S DA=INS,DIE=36,DR="3.1////"_PIEN D ^DIE
 ;
 ; update the scratch global by removing this insurance company
 KILL ^TMP("IBCNEPM",$J,"PYR",$P(LINKDATA,U,3),PIEN,INS)
 S ^TMP("IBCNEPM",$J,"PYR",$P(LINKDATA,U,3),PIEN)=$G(^TMP("IBCNEPM",$J,"PYR",$P(LINKDATA,U,3),PIEN))-1
 KILL ^TMP("IBCNEPM",$J,"INS",INS,PIEN)
 ;
 ; search scratch global for remaining pointers to this ins. company
 S PIEN="" F  S PIEN=$O(^TMP("IBCNEPM",$J,"INS",INS,PIEN)) Q:'PIEN  D
 . S TPAYER=$G(^TMP("IBCNEPM",$J,"INS",INS,PIEN))
 . Q:TPAYER=""
 . KILL ^TMP("IBCNEPM",$J,"PYR",TPAYER,PIEN,INS)
 . S ^TMP("IBCNEPM",$J,"PYR",TPAYER,PIEN)=$G(^TMP("IBCNEPM",$J,"PYR",TPAYER,PIEN))-1
 . KILL ^TMP("IBCNEPM",$J,"INS",INS,PIEN)
 ;
 ; rebuild the LINK area and the ListMan display global
 D INIT
 ;
 ; user message
 W !!?5,"They are now linked.  You may view/edit this relationship by using the"
 W !?5,"Insurance Company Entry/Edit option."
 D PAUSE^VALM1
LINKX ;
 S VALMBCK="R"
 Q
 ;
